Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753595Ab2KSKDg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2012 05:03:36 -0500
Received: from mail-da0-f46.google.com ([209.85.210.46]:55847 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753573Ab2KSKDe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2012 05:03:34 -0500
From: Daniel J Blueman <daniel@numascale-asia.com>
To: Borislav Petkov <bp@alien8.de>
Cc: Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        H Peter Anvin <hpa@zytor.com>, Steffen Persvold <sp@numascale.com>,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        Daniel J Blueman <daniel@numascale-asia.com>
Subject: [PATCH 3/3, v3] AMD64 EDAC: Cleanup type usage to be consistent
Date: Mon, 19 Nov 2012 18:02:48 +0800
Message-Id: <1353319368-9179-3-git-send-email-daniel@numascale-asia.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1353319368-9179-1-git-send-email-daniel@numascale-asia.com>
References: <1353319368-9179-1-git-send-email-daniel@numascale-asia.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As the Northbridge IDs are at most 16-bits, use the same type
consistently and cleanup some indexes to use smaller types.

v2: Drop changes for later cleanups
v3: Further changes suggested by Boris

Signed-off-by: Daniel J Blueman <daniel@numascale-asia.com>
---
 arch/x86/include/asm/amd_nb.h    |    2 +-
 arch/x86/include/asm/processor.h |    2 +-
 arch/x86/kernel/cpu/amd.c        |    4 ++--
 drivers/edac/amd64_edac.c        |   16 ++++++++--------
 drivers/edac/amd64_edac.h        |    6 +++---
 5 files changed, 15 insertions(+), 15 deletions(-)

diff --git a/arch/x86/include/asm/amd_nb.h b/arch/x86/include/asm/amd_nb.h
index 9f5532a..b0815a0 100644
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
index 6e3f002..b27412a 100644
--- a/drivers/edac/amd64_edac.c
+++ b/drivers/edac/amd64_edac.c
@@ -239,7 +239,7 @@ static int amd64_get_scrub_rate(struct mem_ctl_info *mci)
  * DRAM base/limit associated with node_id
  */
 static bool amd64_base_limit_match(struct amd64_pvt *pvt, u64 sys_addr,
-				   unsigned nid)
+				   u8 nid)
 {
 	u64 addr;
 
@@ -265,7 +265,7 @@ static struct mem_ctl_info *find_mc_by_sys_addr(struct mem_ctl_info *mci,
 						u64 sys_addr)
 {
 	struct amd64_pvt *pvt;
-	unsigned node_id;
+	u8 node_id;
 	u32 intlv_en, bits;
 
 	/*
@@ -1021,7 +1021,7 @@ static void read_dram_base_limit_regs(struct amd64_pvt *pvt, unsigned range)
 	/* Factor in CC6 save area by reading dst node's limit reg */
 	if (c->x86 == 0x15) {
 		struct pci_dev *misc, *f1 = NULL;
-		u16 nid = dram_dst_node(pvt, range);
+		u8 nid = dram_dst_node(pvt, range);
 		u32 llim;
 
 		misc = node_to_amd_nb(nid)->misc;
@@ -1348,7 +1348,7 @@ static u8 f1x_determine_channel(struct amd64_pvt *pvt, u64 sys_addr,
 }
 
 /* Convert the sys_addr to the normalized DCT address */
-static u64 f1x_get_norm_dct_addr(struct amd64_pvt *pvt, unsigned range,
+static u64 f1x_get_norm_dct_addr(struct amd64_pvt *pvt, u8 range,
 				 u64 sys_addr, bool hi_rng,
 				 u32 dct_sel_base_addr)
 {
@@ -1399,7 +1399,7 @@ static u64 f1x_get_norm_dct_addr(struct amd64_pvt *pvt, unsigned range,
  * checks if the csrow passed in is marked as SPARED, if so returns the new
  * spare row
  */
-static int f10_process_possible_spare(struct amd64_pvt *pvt, u8 dct, int csrow)
+static int f10_process_possible_spare(struct amd64_pvt *pvt, u16 dct, int csrow)
 {
 	int tmp_cs;
 
@@ -1424,7 +1424,7 @@ static int f10_process_possible_spare(struct amd64_pvt *pvt, u8 dct, int csrow)
  *	-EINVAL:  NOT FOUND
  *	0..csrow = Chip-Select Row
  */
-static int f1x_lookup_addr_in_dct(u64 in_addr, u32 nid, u8 dct)
+static int f1x_lookup_addr_in_dct(u64 in_addr, u8 nid, u8 dct)
 {
 	struct mem_ctl_info *mci;
 	struct amd64_pvt *pvt;
@@ -2256,7 +2256,7 @@ static int init_csrows(struct mem_ctl_info *mci)
 }
 
 /* get all cores on this DCT */
-static void get_cpus_on_this_dct_cpumask(struct cpumask *mask, unsigned nid)
+static void get_cpus_on_this_dct_cpumask(struct cpumask *mask, u16 nid)
 {
 	int cpu;
 
@@ -2266,7 +2266,7 @@ static void get_cpus_on_this_dct_cpumask(struct cpumask *mask, unsigned nid)
 }
 
 /* check MCG_CTL on all the cpus on this node */
-static bool amd64_nb_mce_bank_enabled_on_node(unsigned nid)
+static bool amd64_nb_mce_bank_enabled_on_node(u16 nid)
 {
 	cpumask_var_t mask;
 	int cpu, nbe;
diff --git a/drivers/edac/amd64_edac.h b/drivers/edac/amd64_edac.h
index 90cae61..37cf7ad 100644
--- a/drivers/edac/amd64_edac.h
+++ b/drivers/edac/amd64_edac.h
@@ -332,7 +332,7 @@ struct amd64_pvt {
 	/* pci_device handles which we utilize */
 	struct pci_dev *F1, *F2, *F3;
 
-	unsigned mc_node_id;	/* MC index of this MC node */
+	u16 mc_node_id;		/* MC index of this MC node */
 	int ext_model;		/* extended model value of this node */
 	int channel_count;
 
@@ -368,7 +368,7 @@ struct amd64_pvt {
 	struct error_injection injection;
 };
 
-static inline u64 get_dram_base(struct amd64_pvt *pvt, unsigned i)
+static inline u64 get_dram_base(struct amd64_pvt *pvt, u8 i)
 {
 	u64 addr = ((u64)pvt->ranges[i].base.lo & 0xffff0000) << 8;
 
@@ -378,7 +378,7 @@ static inline u64 get_dram_base(struct amd64_pvt *pvt, unsigned i)
 	return (((u64)pvt->ranges[i].base.hi & 0x000000ff) << 40) | addr;
 }
 
-static inline u64 get_dram_limit(struct amd64_pvt *pvt, unsigned i)
+static inline u64 get_dram_limit(struct amd64_pvt *pvt, u8 i)
 {
 	u64 lim = (((u64)pvt->ranges[i].lim.lo & 0xffff0000) << 8) | 0x00ffffff;
 
-- 
1.7.10.4

