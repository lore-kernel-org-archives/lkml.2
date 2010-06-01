Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756683Ab0FANaM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jun 2010 09:30:12 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:45676 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756514Ab0FAN3X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jun 2010 09:29:23 -0400
From: Borislav Petkov <bp@amd64.org>
To: <mingo@elte.hu>, <norsk5@yahoo.com>
Cc: <hpa@zytor.com>, <tglx@linutronix.de>, <linux-edac@vger.kernel.org>,
       <linux-kernel@vger.kernel.org>,
       Borislav Petkov <borislav.petkov@amd.com>
Subject: [PATCH 5/6] amd64_edac: Remove polling mechanism
Date: Tue,  1 Jun 2010 15:29:30 +0200
Message-Id: <1275398971-12439-6-git-send-email-bp@amd64.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1275398971-12439-1-git-send-email-bp@amd64.org>
References: <1275398971-12439-1-git-send-email-bp@amd64.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <borislav.petkov@amd.com>

Switch to reusing the mcheck core's machine check polling mechanism
instead of duplicating functionality by using the EDAC polling routine.

Correct formatting while at it.

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 drivers/edac/amd64_edac.c   |  118 -------------------------------------------
 drivers/edac/edac_mce_amd.c |   16 +++---
 2 files changed, 8 insertions(+), 126 deletions(-)

diff --git a/drivers/edac/amd64_edac.c b/drivers/edac/amd64_edac.c
index 297cc12..80600f1 100644
--- a/drivers/edac/amd64_edac.c
+++ b/drivers/edac/amd64_edac.c
@@ -1973,107 +1973,6 @@ static int get_channel_from_ecc_syndrome(struct mem_ctl_info *mci, u16 syndrome)
 }
 
 /*
- * Check for valid error in the NB Status High register. If so, proceed to read
- * NB Status Low, NB Address Low and NB Address High registers and store data
- * into error structure.
- *
- * Returns:
- *	- 1: if hardware regs contains valid error info
- *	- 0: if no valid error is indicated
- */
-static int amd64_get_error_info_regs(struct mem_ctl_info *mci,
-				     struct err_regs *regs)
-{
-	struct amd64_pvt *pvt;
-	struct pci_dev *misc_f3_ctl;
-
-	pvt = mci->pvt_info;
-	misc_f3_ctl = pvt->misc_f3_ctl;
-
-	if (amd64_read_pci_cfg(misc_f3_ctl, K8_NBSH, &regs->nbsh))
-		return 0;
-
-	if (!(regs->nbsh & K8_NBSH_VALID_BIT))
-		return 0;
-
-	/* valid error, read remaining error information registers */
-	if (amd64_read_pci_cfg(misc_f3_ctl, K8_NBSL, &regs->nbsl) ||
-	    amd64_read_pci_cfg(misc_f3_ctl, K8_NBEAL, &regs->nbeal) ||
-	    amd64_read_pci_cfg(misc_f3_ctl, K8_NBEAH, &regs->nbeah) ||
-	    amd64_read_pci_cfg(misc_f3_ctl, K8_NBCFG, &regs->nbcfg))
-		return 0;
-
-	return 1;
-}
-
-/*
- * This function is called to retrieve the error data from hardware and store it
- * in the info structure.
- *
- * Returns:
- *	- 1: if a valid error is found
- *	- 0: if no error is found
- */
-static int amd64_get_error_info(struct mem_ctl_info *mci,
-				struct err_regs *info)
-{
-	struct amd64_pvt *pvt;
-	struct err_regs regs;
-
-	pvt = mci->pvt_info;
-
-	if (!amd64_get_error_info_regs(mci, info))
-		return 0;
-
-	/*
-	 * Here's the problem with the K8's EDAC reporting: There are four
-	 * registers which report pieces of error information. They are shared
-	 * between CEs and UEs. Furthermore, contrary to what is stated in the
-	 * BKDG, the overflow bit is never used! Every error always updates the
-	 * reporting registers.
-	 *
-	 * Can you see the race condition? All four error reporting registers
-	 * must be read before a new error updates them! There is no way to read
-	 * all four registers atomically. The best than can be done is to detect
-	 * that a race has occured and then report the error without any kind of
-	 * precision.
-	 *
-	 * What is still positive is that errors are still reported and thus
-	 * problems can still be detected - just not localized because the
-	 * syndrome and address are spread out across registers.
-	 *
-	 * Grrrrr!!!!!  Here's hoping that AMD fixes this in some future K8 rev.
-	 * UEs and CEs should have separate register sets with proper overflow
-	 * bits that are used! At very least the problem can be fixed by
-	 * honoring the ErrValid bit in 'nbsh' and not updating registers - just
-	 * set the overflow bit - unless the current error is CE and the new
-	 * error is UE which would be the only situation for overwriting the
-	 * current values.
-	 */
-
-	regs = *info;
-
-	/* Use info from the second read - most current */
-	if (unlikely(!amd64_get_error_info_regs(mci, info)))
-		return 0;
-
-	/* clear the error bits in hardware */
-	pci_write_bits32(pvt->misc_f3_ctl, K8_NBSH, 0, K8_NBSH_VALID_BIT);
-
-	/* Check for the possible race condition */
-	if ((regs.nbsh != info->nbsh) ||
-	     (regs.nbsl != info->nbsl) ||
-	     (regs.nbeah != info->nbeah) ||
-	     (regs.nbeal != info->nbeal)) {
-		amd64_mc_printk(mci, KERN_WARNING,
-				"hardware STATUS read access race condition "
-				"detected!\n");
-		return 0;
-	}
-	return 1;
-}
-
-/*
  * Handle any Correctable Errors (CEs) that have occurred. Check for valid ERROR
  * ADDRESS and process.
  */
@@ -2197,20 +2096,6 @@ void amd64_decode_bus_error(int node_id, struct err_regs *regs)
 }
 
 /*
- * The main polling 'check' function, called FROM the edac core to perform the
- * error checking and if an error is encountered, error processing.
- */
-static void amd64_check(struct mem_ctl_info *mci)
-{
-	struct err_regs regs;
-
-	if (amd64_get_error_info(mci, &regs)) {
-		struct amd64_pvt *pvt = mci->pvt_info;
-		amd_decode_nb_mce(pvt->mc_node_id, &regs, 1);
-	}
-}
-
-/*
  * Input:
  *	1) struct amd64_pvt which contains pvt->dram_f2_ctl pointer
  *	2) AMD Family index value
@@ -2749,9 +2634,6 @@ static void amd64_setup_mci_misc_attributes(struct mem_ctl_info *mci)
 	mci->dev_name		= pci_name(pvt->dram_f2_ctl);
 	mci->ctl_page_to_phys	= NULL;
 
-	/* IMPORTANT: Set the polling 'check' function in this module */
-	mci->edac_check		= amd64_check;
-
 	/* memory scrubber interface */
 	mci->set_sdram_scrub_rate = amd64_set_scrub_rate;
 	mci->get_sdram_scrub_rate = amd64_get_scrub_rate;
diff --git a/drivers/edac/edac_mce_amd.c b/drivers/edac/edac_mce_amd.c
index 97e64bc..bae9351 100644
--- a/drivers/edac/edac_mce_amd.c
+++ b/drivers/edac/edac_mce_amd.c
@@ -133,7 +133,7 @@ static void amd_decode_dc_mce(u64 mc0_status)
 	u32 ec  = mc0_status & 0xffff;
 	u32 xec = (mc0_status >> 16) & 0xf;
 
-	pr_emerg(" Data Cache Error");
+	pr_emerg("Data Cache Error");
 
 	if (xec == 1 && TLB_ERROR(ec))
 		pr_cont(": %s TLB multimatch.\n", LL_MSG(ec));
@@ -176,7 +176,7 @@ static void amd_decode_ic_mce(u64 mc1_status)
 	u32 ec  = mc1_status & 0xffff;
 	u32 xec = (mc1_status >> 16) & 0xf;
 
-	pr_emerg(" Instruction Cache Error");
+	pr_emerg("Instruction Cache Error");
 
 	if (xec == 1 && TLB_ERROR(ec))
 		pr_cont(": %s TLB multimatch.\n", LL_MSG(ec));
@@ -233,7 +233,7 @@ static void amd_decode_bu_mce(u64 mc2_status)
 	u32 ec = mc2_status & 0xffff;
 	u32 xec = (mc2_status >> 16) & 0xf;
 
-	pr_emerg(" Bus Unit Error");
+	pr_emerg("Bus Unit Error");
 
 	if (xec == 0x1)
 		pr_cont(" in the write data buffers.\n");
@@ -275,7 +275,7 @@ static void amd_decode_ls_mce(u64 mc3_status)
 	u32 ec  = mc3_status & 0xffff;
 	u32 xec = (mc3_status >> 16) & 0xf;
 
-	pr_emerg(" Load Store Error");
+	pr_emerg("Load Store Error");
 
 	if (xec == 0x0) {
 		u8 rrrr = (ec >> 4) & 0xf;
@@ -304,7 +304,7 @@ void amd_decode_nb_mce(int node_id, struct err_regs *regs, int handle_errors)
 	if (TLB_ERROR(ec) && !report_gart_errors)
 		return;
 
-	pr_emerg(" Northbridge Error, node %d", node_id);
+	pr_emerg("Northbridge Error, node %d", node_id);
 
 	/*
 	 * F10h, revD can disable ErrCpu[3:0] so check that first and also the
@@ -342,13 +342,13 @@ static void amd_decode_fr_mce(u64 mc5_status)
 static inline void amd_decode_err_code(unsigned int ec)
 {
 	if (TLB_ERROR(ec)) {
-		pr_emerg(" Transaction: %s, Cache Level %s\n",
+		pr_emerg("Transaction: %s, Cache Level %s\n",
 			 TT_MSG(ec), LL_MSG(ec));
 	} else if (MEM_ERROR(ec)) {
-		pr_emerg(" Transaction: %s, Type: %s, Cache Level: %s",
+		pr_emerg("Transaction: %s, Type: %s, Cache Level: %s",
 			 RRRR_MSG(ec), TT_MSG(ec), LL_MSG(ec));
 	} else if (BUS_ERROR(ec)) {
-		pr_emerg(" Transaction type: %s(%s), %s, Cache Level: %s, "
+		pr_emerg("Transaction type: %s(%s), %s, Cache Level: %s, "
 			 "Participating Processor: %s\n",
 			  RRRR_MSG(ec), II_MSG(ec), TO_MSG(ec), LL_MSG(ec),
 			  PP_MSG(ec));
-- 
1.7.1

