Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753565Ab2JaF4Y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 01:56:24 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:37025 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753439Ab2JaF4T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 01:56:19 -0400
From: Daniel J Blueman <daniel@numascale-asia.com>
To: Borislav Petkov <bp@alien8.de>
Cc: Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        H Peter Anvin <hpa@zytor.com>, Steffen Persvold <sp@numascale.com>,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        Daniel J Blueman <daniel@numascale-asia.com>
Subject: [PATCH 3/4] AMD64 EDAC: Cleanup type usage to be consistent
Date: Wed, 31 Oct 2012 13:55:31 +0800
Message-Id: <1351662932-22279-3-git-send-email-daniel@numascale-asia.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1351662932-22279-1-git-send-email-daniel@numascale-asia.com>
References: <1351662932-22279-1-git-send-email-daniel@numascale-asia.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As the Northbridge IDs are at most 16-bits, use the same type
consistently.

Signed-off-by: Daniel J Blueman <daniel@numascale-asia.com>
---
 arch/x86/include/asm/amd_nb.h    |    2 +-
 arch/x86/include/asm/processor.h |    2 +-
 arch/x86/kernel/cpu/amd.c        |    4 ++--
 drivers/edac/amd64_edac.c        |   26 ++++++++++++++------------
 drivers/edac/amd64_edac.h        |    2 +-
 5 files changed, 19 insertions(+), 17 deletions(-)

diff --git a/arch/x86/include/asm/amd_nb.h b/arch/x86/include/asm/amd_nb.h
index b88fc7a..0cc1045 100644
--- a/arch/x86/include/asm/amd_nb.h
+++ b/arch/x86/include/asm/amd_nb.h
@@ -76,7 +76,7 @@ static inline bool amd_nb_has_feature(unsigned feature)
 	return ((amd_northbridges.flags & feature) == feature);
 }
 
-static inline struct amd_northbridge *node_to_amd_nb(int node)
+static inline struct amd_northbridge *node_to_amd_nb(u16 node)
 {
 	return (node < amd_northbridges.num) ? &amd_northbridges.nb[node] : NULL;
 }
diff --git a/arch/x86/include/asm/processor.h b/arch/x86/include/asm/processor.h
index ad1fc85..eb3ba58 100644
--- a/arch/x86/include/asm/processor.h
+++ b/arch/x86/include/asm/processor.h
@@ -934,7 +934,7 @@ extern void start_thread(struct pt_regs *regs, unsigned long new_ip,
 extern int get_tsc_mode(unsigned long adr);
 extern int set_tsc_mode(unsigned int val);
 
-extern int amd_get_nb_id(int cpu);
+extern u16 amd_get_nb_id(int cpu);
 
 struct aperfmperf {
 	u64 aperf, mperf;
diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
index f7e98a2..52cab1f 100644
--- a/arch/x86/kernel/cpu/amd.c
+++ b/arch/x86/kernel/cpu/amd.c
@@ -364,9 +364,9 @@ static void __cpuinit amd_detect_cmp(struct cpuinfo_x86 *c)
 #endif
 }
 
-int amd_get_nb_id(int cpu)
+u16 amd_get_nb_id(int cpu)
 {
-	int id = 0;
+	u16 id = 0;
 #ifdef CONFIG_SMP
 	id = per_cpu(cpu_llc_id, cpu);
 #endif
diff --git a/drivers/edac/amd64_edac.c b/drivers/edac/amd64_edac.c
index 9920dfd..12cd675 100644
--- a/drivers/edac/amd64_edac.c
+++ b/drivers/edac/amd64_edac.c
@@ -239,7 +239,7 @@ static int amd64_get_scrub_rate(struct mem_ctl_info *mci)
  * DRAM base/limit associated with node_id
  */
 static bool amd64_base_limit_match(struct amd64_pvt *pvt, u64 sys_addr,
-				   unsigned nid)
+				   u16 nid)
 {
 	u64 addr;
 
@@ -265,7 +265,7 @@ static struct mem_ctl_info *find_mc_by_sys_addr(struct mem_ctl_info *mci,
 						u64 sys_addr)
 {
 	struct amd64_pvt *pvt;
-	unsigned node_id;
+	u16 node_id;
 	u32 intlv_en, bits;
 
 	/*
@@ -613,7 +613,8 @@ static u64 sys_addr_to_input_addr(struct mem_ctl_info *mci, u64 sys_addr)
 static u64 input_addr_to_dram_addr(struct mem_ctl_info *mci, u64 input_addr)
 {
 	struct amd64_pvt *pvt;
-	unsigned node_id, intlv_shift;
+	u16 node_id;
+	unsigned intlv_shift;
 	u64 bits, dram_addr;
 	u32 intlv_sel;
 
@@ -1337,7 +1338,7 @@ static u8 f1x_determine_channel(struct amd64_pvt *pvt, u64 sys_addr,
 }
 
 /* Convert the sys_addr to the normalized DCT address */
-static u64 f1x_get_norm_dct_addr(struct amd64_pvt *pvt, unsigned range,
+static u64 f1x_get_norm_dct_addr(struct amd64_pvt *pvt, u16 range,
 				 u64 sys_addr, bool hi_rng,
 				 u32 dct_sel_base_addr)
 {
@@ -1413,7 +1414,7 @@ static int f10_process_possible_spare(struct amd64_pvt *pvt, u8 dct, int csrow)
  *	-EINVAL:  NOT FOUND
  *	0..csrow = Chip-Select Row
  */
-static int f1x_lookup_addr_in_dct(u64 in_addr, u32 nid, u8 dct)
+static int f1x_lookup_addr_in_dct(u64 in_addr, u16 nid, u8 dct)
 {
 	struct mem_ctl_info *mci;
 	struct amd64_pvt *pvt;
@@ -1491,7 +1492,7 @@ static u64 f1x_swap_interleaved_region(struct amd64_pvt *pvt, u64 sys_addr)
 
 /* For a given @dram_range, check if @sys_addr falls within it. */
 static int f1x_match_to_this_node(struct amd64_pvt *pvt, unsigned range,
-				  u64 sys_addr, int *nid, int *chan_sel)
+				  u64 sys_addr, u16 *nid, int *chan_sel)
 {
 	int cs_found = -EINVAL;
 	u64 chan_addr;
@@ -1572,10 +1573,10 @@ static int f1x_match_to_this_node(struct amd64_pvt *pvt, unsigned range,
 }
 
 static int f1x_translate_sysaddr_to_cs(struct amd64_pvt *pvt, u64 sys_addr,
-				       int *node, int *chan_sel)
+				       u16 *node, int *chan_sel)
 {
 	int cs_found = -EINVAL;
-	unsigned range;
+	u16 range;
 
 	for (range = 0; range < DRAM_RANGES; range++) {
 
@@ -1607,7 +1608,8 @@ static void f1x_map_sysaddr_to_csrow(struct mem_ctl_info *mci, u64 sys_addr,
 {
 	struct amd64_pvt *pvt = mci->pvt_info;
 	u32 page, offset;
-	int nid, csrow, chan = 0;
+	int csrow, chan = 0;
+	u16 nid;
 
 	error_address_to_page_and_offset(sys_addr, &page, &offset);
 
@@ -2065,7 +2067,7 @@ static void read_mc_regs(struct amd64_pvt *pvt)
 	struct cpuinfo_x86 *c = &boot_cpu_data;
 	u64 msr_val;
 	u32 tmp;
-	unsigned range;
+	u16 range;
 
 	/*
 	 * Retrieve TOP_MEM and TOP_MEM2; no masking off of reserved bits since
@@ -2263,7 +2265,7 @@ static int init_csrows(struct mem_ctl_info *mci)
 }
 
 /* get all cores on this DCT */
-static void get_cpus_on_this_dct_cpumask(struct cpumask *mask, unsigned nid)
+static void get_cpus_on_this_dct_cpumask(struct cpumask *mask, u16 nid)
 {
 	int cpu;
 
@@ -2273,7 +2275,7 @@ static void get_cpus_on_this_dct_cpumask(struct cpumask *mask, unsigned nid)
 }
 
 /* check MCG_CTL on all the cpus on this node */
-static bool amd64_nb_mce_bank_enabled_on_node(unsigned nid)
+static bool amd64_nb_mce_bank_enabled_on_node(u16 nid)
 {
 	cpumask_var_t mask;
 	int cpu, nbe;
diff --git a/drivers/edac/amd64_edac.h b/drivers/edac/amd64_edac.h
index 90cae61..647c9b8 100644
--- a/drivers/edac/amd64_edac.h
+++ b/drivers/edac/amd64_edac.h
@@ -332,7 +332,7 @@ struct amd64_pvt {
 	/* pci_device handles which we utilize */
 	struct pci_dev *F1, *F2, *F3;
 
-	unsigned mc_node_id;	/* MC index of this MC node */
+	u16 mc_node_id;	/* MC index of this MC node */
 	int ext_model;		/* extended model value of this node */
 	int channel_count;
 
-- 
1.7.9.5

