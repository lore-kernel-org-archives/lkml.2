Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755854Ab0I3LBF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Sep 2010 07:01:05 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:41687 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754242Ab0I3LBC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Sep 2010 07:01:02 -0400
From: Borislav Petkov <bp@amd64.org>
To: <norsk5@yahoo.com>
Cc: <linux-edac@vger.kernel.org>, <x86@kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Borislav Petkov <borislav.petkov@amd.com>
Subject: [PATCH 5/8] EDAC, MCE: Pass complete MCE info to decoders
Date: Thu, 30 Sep 2010 13:01:46 +0200
Message-Id: <1285844509-27120-6-git-send-email-bp@amd64.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1285844509-27120-1-git-send-email-bp@amd64.org>
References: <1285844509-27120-1-git-send-email-bp@amd64.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <borislav.petkov@amd.com>

... instead of the MCi_STATUS info only for improved handling of certain
types of errors later.

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 drivers/edac/amd64_edac.c     |   13 +++++--
 drivers/edac/amd64_edac_dbg.c |   10 ++++-
 drivers/edac/edac_mce_amd.c   |   74 +++++++++++++++++++---------------------
 drivers/edac/edac_mce_amd.h   |    6 ++--
 4 files changed, 56 insertions(+), 47 deletions(-)

diff --git a/drivers/edac/amd64_edac.c b/drivers/edac/amd64_edac.c
index e7d5d6b..76f7cc0 100644
--- a/drivers/edac/amd64_edac.c
+++ b/drivers/edac/amd64_edac.c
@@ -2073,11 +2073,18 @@ static inline void __amd64_decode_bus_error(struct mem_ctl_info *mci,
 		amd64_handle_ue(mci, info);
 }
 
-void amd64_decode_bus_error(int node_id, struct err_regs *regs)
+void amd64_decode_bus_error(int node_id, struct mce *m, u32 nbcfg)
 {
 	struct mem_ctl_info *mci = mci_lookup[node_id];
+	struct err_regs regs;
 
-	__amd64_decode_bus_error(mci, regs);
+	regs.nbsl  = (u32) m->status;
+	regs.nbsh  = (u32)(m->status >> 32);
+	regs.nbeal = (u32) m->addr;
+	regs.nbeah = (u32)(m->addr >> 32);
+	regs.nbcfg = nbcfg;
+
+	__amd64_decode_bus_error(mci, &regs);
 
 	/*
 	 * Check the UE bit of the NB status high register, if set generate some
@@ -2086,7 +2093,7 @@ void amd64_decode_bus_error(int node_id, struct err_regs *regs)
 	 *
 	 * FIXME: this should go somewhere else, if at all.
 	 */
-	if (regs->nbsh & K8_NBSH_UC_ERR && !report_gart_errors)
+	if (regs.nbsh & K8_NBSH_UC_ERR && !report_gart_errors)
 		edac_mc_handle_ue_no_info(mci, "UE bit is set");
 
 }
diff --git a/drivers/edac/amd64_edac_dbg.c b/drivers/edac/amd64_edac_dbg.c
index 22ef3fe..f6d5695 100644
--- a/drivers/edac/amd64_edac_dbg.c
+++ b/drivers/edac/amd64_edac_dbg.c
@@ -10,11 +10,14 @@ static ssize_t amd64_nbea_store(struct mem_ctl_info *mci, const char *data,
 				size_t count)
 {
 	struct amd64_pvt *pvt = mci->pvt_info;
-	unsigned long long value;
+	u64 value;
 	int ret = 0;
+	struct mce m;
 
 	ret = strict_strtoull(data, 16, &value);
 	if (ret != -EINVAL) {
+		struct err_regs *regs = &pvt->ctl_error_info;
+
 		debugf0("received NBEA= 0x%llx\n", value);
 
 		/* place the value into the virtual error packet */
@@ -22,9 +25,12 @@ static ssize_t amd64_nbea_store(struct mem_ctl_info *mci, const char *data,
 		value >>= 32;
 		pvt->ctl_error_info.nbeah = (u32) value;
 
+		m.addr   = value;
+		m.status = regs->nbsl | ((u64)regs->nbsh << 32);
+
 		/* Process the Mapping request */
 		/* TODO: Add race prevention */
-		amd_decode_nb_mce(pvt->mc_node_id, &pvt->ctl_error_info);
+		amd_decode_nb_mce(pvt->mc_node_id, &m, regs->nbcfg);
 
 		return count;
 	}
diff --git a/drivers/edac/edac_mce_amd.c b/drivers/edac/edac_mce_amd.c
index d0e850e..6cfa881 100644
--- a/drivers/edac/edac_mce_amd.c
+++ b/drivers/edac/edac_mce_amd.c
@@ -2,7 +2,7 @@
 #include "edac_mce_amd.h"
 
 static bool report_gart_errors;
-static void (*nb_bus_decoder)(int node_id, struct err_regs *regs);
+static void (*nb_bus_decoder)(int node_id, struct mce *m, u32 nbcfg);
 
 void amd_report_gart_errors(bool v)
 {
@@ -10,13 +10,13 @@ void amd_report_gart_errors(bool v)
 }
 EXPORT_SYMBOL_GPL(amd_report_gart_errors);
 
-void amd_register_ecc_decoder(void (*f)(int, struct err_regs *))
+void amd_register_ecc_decoder(void (*f)(int, struct mce *, u32))
 {
 	nb_bus_decoder = f;
 }
 EXPORT_SYMBOL_GPL(amd_register_ecc_decoder);
 
-void amd_unregister_ecc_decoder(void (*f)(int, struct err_regs *))
+void amd_unregister_ecc_decoder(void (*f)(int, struct mce *, u32))
 {
 	if (nb_bus_decoder) {
 		WARN_ON(nb_bus_decoder != f);
@@ -97,17 +97,17 @@ const char *ext_msgs[] = {
 };
 EXPORT_SYMBOL_GPL(ext_msgs);
 
-static void amd_decode_dc_mce(u64 mc0_status)
+static void amd_decode_dc_mce(struct mce *m)
 {
-	u32 ec  = mc0_status & 0xffff;
-	u32 xec = (mc0_status >> 16) & 0xf;
+	u32 ec  = m->status & 0xffff;
+	u32 xec = (m->status >> 16) & 0xf;
 
 	pr_emerg(HW_ERR "Data Cache Error: ");
 
 	if (xec == 1 && TLB_ERROR(ec))
 		pr_cont(": %s TLB multimatch.\n", LL_MSG(ec));
 	else if (xec == 0) {
-		if (mc0_status & (1ULL << 40))
+		if (m->status & (1ULL << 40))
 			pr_cont(" during Data Scrub.\n");
 		else if (TLB_ERROR(ec))
 			pr_cont(": %s TLB parity error.\n", LL_MSG(ec));
@@ -140,10 +140,10 @@ wrong_dc_mce:
 	pr_emerg(HW_ERR "Corrupted DC MCE info?\n");
 }
 
-static void amd_decode_ic_mce(u64 mc1_status)
+static void amd_decode_ic_mce(struct mce *m)
 {
-	u32 ec  = mc1_status & 0xffff;
-	u32 xec = (mc1_status >> 16) & 0xf;
+	u32 ec  = m->status & 0xffff;
+	u32 xec = (m->status >> 16) & 0xf;
 
 	pr_emerg(HW_ERR "Instruction Cache Error");
 
@@ -154,7 +154,7 @@ static void amd_decode_ic_mce(u64 mc1_status)
 			pr_cont(": %s TLB Parity error.\n", LL_MSG(ec));
 		else if (BUS_ERROR(ec)) {
 			if (boot_cpu_data.x86 == 0xf &&
-			    (mc1_status & (1ULL << 58)))
+			    (m->status & BIT(58)))
 				pr_cont(" during system linefill.\n");
 			else
 				pr_cont(" during attempted NB data read.\n");
@@ -197,10 +197,10 @@ wrong_ic_mce:
 	pr_emerg(HW_ERR "Corrupted IC MCE info?\n");
 }
 
-static void amd_decode_bu_mce(u64 mc2_status)
+static void amd_decode_bu_mce(struct mce *m)
 {
-	u32 ec = mc2_status & 0xffff;
-	u32 xec = (mc2_status >> 16) & 0xf;
+	u32 ec = m->status & 0xffff;
+	u32 xec = (m->status >> 16) & 0xf;
 
 	pr_emerg(HW_ERR "Bus Unit Error");
 
@@ -239,10 +239,10 @@ wrong_bu_mce:
 	pr_emerg(HW_ERR "Corrupted BU MCE info?\n");
 }
 
-static void amd_decode_ls_mce(u64 mc3_status)
+static void amd_decode_ls_mce(struct mce *m)
 {
-	u32 ec  = mc3_status & 0xffff;
-	u32 xec = (mc3_status >> 16) & 0xf;
+	u32 ec  = m->status & 0xffff;
+	u32 xec = (m->status >> 16) & 0xf;
 
 	pr_emerg(HW_ERR "Load Store Error");
 
@@ -260,9 +260,11 @@ wrong_ls_mce:
 	pr_emerg(HW_ERR "Corrupted LS MCE info?\n");
 }
 
-void amd_decode_nb_mce(int node_id, struct err_regs *regs)
+void amd_decode_nb_mce(int node_id, struct mce *m, u32 nbcfg)
 {
-	u32 ec  = ERROR_CODE(regs->nbsl);
+	u32 ec   = m->status & 0xffff;
+	u32 nbsh = (u32)(m->status >> 32);
+	u32 nbsl = (u32)m->status;
 
 	/*
 	 * GART TLB error reporting is disabled by default. Bail out early.
@@ -278,10 +280,10 @@ void amd_decode_nb_mce(int node_id, struct err_regs *regs)
 	 */
 	if ((boot_cpu_data.x86 == 0x10) &&
 	    (boot_cpu_data.x86_model > 7)) {
-		if (regs->nbsh & K8_NBSH_ERR_CPU_VAL)
-			pr_cont(", core: %u\n", (u8)(regs->nbsh & 0xf));
+		if (nbsh & K8_NBSH_ERR_CPU_VAL)
+			pr_cont(", core: %u\n", (u8)(nbsh & 0xf));
 	} else {
-		u8 assoc_cpus = regs->nbsh & 0xf;
+		u8 assoc_cpus = nbsh & 0xf;
 
 		if (assoc_cpus > 0)
 			pr_cont(", core: %d", fls(assoc_cpus) - 1);
@@ -289,17 +291,17 @@ void amd_decode_nb_mce(int node_id, struct err_regs *regs)
 		pr_cont("\n");
 	}
 
-	pr_emerg(HW_ERR "%s.\n", EXT_ERR_MSG(regs->nbsl));
+	pr_emerg(HW_ERR "%s.\n", EXT_ERR_MSG(nbsl));
 
 	if (BUS_ERROR(ec) && nb_bus_decoder)
-		nb_bus_decoder(node_id, regs);
+		nb_bus_decoder(node_id, m, nbcfg);
 }
 EXPORT_SYMBOL_GPL(amd_decode_nb_mce);
 
-static void amd_decode_fr_mce(u64 mc5_status)
+static void amd_decode_fr_mce(struct mce *m)
 {
 	/* we have only one error signature so match all fields at once. */
-	if ((mc5_status & 0xffff) == 0x0f0f)
+	if ((m->status & 0xffff) == 0x0f0f)
 		pr_emerg(HW_ERR " FR Error: CPU Watchdog timer expire.\n");
 	else
 		pr_emerg(HW_ERR "Corrupted FR MCE info?\n");
@@ -326,7 +328,6 @@ static int amd_decode_mce(struct notifier_block *nb, unsigned long val,
 			   void *data)
 {
 	struct mce *m = (struct mce *)data;
-	struct err_regs regs;
 	int node, ecc;
 
 	pr_emerg(HW_ERR "MC%d_STATUS: ", m->bank);
@@ -346,33 +347,28 @@ static int amd_decode_mce(struct notifier_block *nb, unsigned long val,
 
 	switch (m->bank) {
 	case 0:
-		amd_decode_dc_mce(m->status);
+		amd_decode_dc_mce(m);
 		break;
 
 	case 1:
-		amd_decode_ic_mce(m->status);
+		amd_decode_ic_mce(m);
 		break;
 
 	case 2:
-		amd_decode_bu_mce(m->status);
+		amd_decode_bu_mce(m);
 		break;
 
 	case 3:
-		amd_decode_ls_mce(m->status);
+		amd_decode_ls_mce(m);
 		break;
 
 	case 4:
-		regs.nbsl  = (u32) m->status;
-		regs.nbsh  = (u32)(m->status >> 32);
-		regs.nbeal = (u32) m->addr;
-		regs.nbeah = (u32)(m->addr >> 32);
-		node       = amd_get_nb_id(m->extcpu);
-
-		amd_decode_nb_mce(node, &regs);
+		node = amd_get_nb_id(m->extcpu);
+		amd_decode_nb_mce(node, m, 0);
 		break;
 
 	case 5:
-		amd_decode_fr_mce(m->status);
+		amd_decode_fr_mce(m);
 		break;
 
 	default:
diff --git a/drivers/edac/edac_mce_amd.h b/drivers/edac/edac_mce_amd.h
index 2ee499d..0fba0e7 100644
--- a/drivers/edac/edac_mce_amd.h
+++ b/drivers/edac/edac_mce_amd.h
@@ -63,8 +63,8 @@ struct err_regs {
 
 
 void amd_report_gart_errors(bool);
-void amd_register_ecc_decoder(void (*f)(int, struct err_regs *));
-void amd_unregister_ecc_decoder(void (*f)(int, struct err_regs *));
-void amd_decode_nb_mce(int, struct err_regs *);
+void amd_register_ecc_decoder(void (*f)(int, struct mce *, u32));
+void amd_unregister_ecc_decoder(void (*f)(int, struct mce *, u32));
+void amd_decode_nb_mce(int, struct mce *, u32);
 
 #endif /* _EDAC_MCE_AMD_H */
-- 
1.7.1

