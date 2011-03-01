Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756691Ab1CAP06 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Mar 2011 10:26:58 -0500
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:58355 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755100Ab1CAP04 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Mar 2011 10:26:56 -0500
From: Borislav Petkov <bp@amd64.org>
To: <linux-edac@vger.kernel.org>
Cc: <linux-kernel@vger.kernel.org>, Borislav Petkov <borislav.petkov@amd.com>
Subject: [PATCH 2/8] amd64_edac: Fix node id signedness
Date: Tue,  1 Mar 2011 16:26:50 +0100
Message-Id: <1298993216-19434-3-git-send-email-bp@amd64.org>
X-Mailer: git-send-email 1.7.4.rc2
In-Reply-To: <1298993216-19434-1-git-send-email-bp@amd64.org>
References: <1298993216-19434-1-git-send-email-bp@amd64.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <borislav.petkov@amd.com>

A node id can never be negative since we use it as an index into
the DRAM ranges array. This also makes one of the BUG_ON conditions
redundant.

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 drivers/edac/amd64_edac.c |   16 +++++++++-------
 drivers/edac/amd64_edac.h |    4 ++--
 2 files changed, 11 insertions(+), 9 deletions(-)

diff --git a/drivers/edac/amd64_edac.c b/drivers/edac/amd64_edac.c
index 70e0f84..8d9def5 100644
--- a/drivers/edac/amd64_edac.c
+++ b/drivers/edac/amd64_edac.c
@@ -226,7 +226,8 @@ static int amd64_get_scrub_rate(struct mem_ctl_info *mci)
  * returns true if the SysAddr given by sys_addr matches the
  * DRAM base/limit associated with node_id
  */
-static bool amd64_base_limit_match(struct amd64_pvt *pvt, u64 sys_addr, int nid)
+static bool amd64_base_limit_match(struct amd64_pvt *pvt, u64 sys_addr,
+				   unsigned nid)
 {
 	u64 addr;
 
@@ -252,7 +253,7 @@ static struct mem_ctl_info *find_mc_by_sys_addr(struct mem_ctl_info *mci,
 						u64 sys_addr)
 {
 	struct amd64_pvt *pvt;
-	int node_id;
+	unsigned node_id;
 	u32 intlv_en, bits;
 
 	/*
@@ -302,7 +303,7 @@ static struct mem_ctl_info *find_mc_by_sys_addr(struct mem_ctl_info *mci,
 	}
 
 found:
-	return edac_mc_find(node_id);
+	return edac_mc_find((int)node_id);
 
 err_no_match:
 	debugf2("sys_addr 0x%lx doesn't match any node\n",
@@ -602,7 +603,7 @@ static u64 sys_addr_to_input_addr(struct mem_ctl_info *mci, u64 sys_addr)
 static u64 input_addr_to_dram_addr(struct mem_ctl_info *mci, u64 input_addr)
 {
 	struct amd64_pvt *pvt;
-	int node_id, intlv_shift;
+	unsigned node_id, intlv_shift;
 	u64 bits, dram_addr;
 	u32 intlv_sel;
 
@@ -616,7 +617,8 @@ static u64 input_addr_to_dram_addr(struct mem_ctl_info *mci, u64 input_addr)
 	 */
 	pvt = mci->pvt_info;
 	node_id = pvt->mc_node_id;
-	BUG_ON((node_id < 0) || (node_id > 7));
+
+	BUG_ON(node_id > 7);
 
 	intlv_shift = num_node_interleave_bits(dram_intlv_en(pvt, 0));
 
@@ -2147,7 +2149,7 @@ static int init_csrows(struct mem_ctl_info *mci)
 }
 
 /* get all cores on this DCT */
-static void get_cpus_on_this_dct_cpumask(struct cpumask *mask, int nid)
+static void get_cpus_on_this_dct_cpumask(struct cpumask *mask, unsigned nid)
 {
 	int cpu;
 
@@ -2157,7 +2159,7 @@ static void get_cpus_on_this_dct_cpumask(struct cpumask *mask, int nid)
 }
 
 /* check MCG_CTL on all the cpus on this node */
-static bool amd64_nb_mce_bank_enabled_on_node(int nid)
+static bool amd64_nb_mce_bank_enabled_on_node(unsigned nid)
 {
 	cpumask_var_t mask;
 	int cpu, nbe;
diff --git a/drivers/edac/amd64_edac.h b/drivers/edac/amd64_edac.h
index fe2cc30..6220bae 100644
--- a/drivers/edac/amd64_edac.h
+++ b/drivers/edac/amd64_edac.h
@@ -288,7 +288,7 @@
 #define MSR_MCGCTL_NBE			BIT(4)
 
 /* AMD sets the first MC device at device ID 0x18. */
-static inline int get_node_id(struct pci_dev *pdev)
+static inline u8 get_node_id(struct pci_dev *pdev)
 {
 	return PCI_SLOT(pdev->devfn) - 0x18;
 }
@@ -335,7 +335,7 @@ struct amd64_pvt {
 	/* pci_device handles which we utilize */
 	struct pci_dev *F1, *F2, *F3;
 
-	int mc_node_id;		/* MC index of this MC node */
+	unsigned mc_node_id;	/* MC index of this MC node */
 	int ext_model;		/* extended model value of this node */
 	int channel_count;
 
-- 
1.7.4.rc2

