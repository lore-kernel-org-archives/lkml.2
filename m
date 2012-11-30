Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755725Ab2K3IpF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2012 03:45:05 -0500
Received: from mail-da0-f46.google.com ([209.85.210.46]:50191 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755675Ab2K3IpB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2012 03:45:01 -0500
From: Daniel J Blueman <daniel@numascale-asia.com>
To: Borislav Petkov <bp@alien8.de>
Cc: Daniel J Blueman <daniel@numascale-asia.com>,
        Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        H Peter Anvin <hpa@zytor.com>, Steffen Persvold <sp@numascale.com>,
        x86@kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 4/4 v8] AMD64 EDAC: Fix type usage in NB IDs and memory ranges
Date: Fri, 30 Nov 2012 16:44:20 +0800
Message-Id: <1354265060-22956-2-git-send-email-daniel@numascale-asia.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1354265060-22956-1-git-send-email-daniel@numascale-asia.com>
References: <1354265060-22956-1-git-send-email-daniel@numascale-asia.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use appropriate types for northbridge IDs and memory ranges. Mark immutable
data const and keep within compilation unit on related structures. Tested on
multi-socket server and multi-server, multi-socket NumaConnect setup.

v7: Refactor patches grouping changes
v8: Drop unneeded change; use const and static where appropriate

Signed-off-by: Daniel J Blueman <daniel@numascale-asia.com>
---
 arch/x86/include/asm/amd_nb.h |    2 +-
 drivers/edac/amd64_edac.c     |   26 +++++++++++++-------------
 drivers/edac/amd64_edac.h     |    6 +++---
 3 files changed, 17 insertions(+), 17 deletions(-)

diff --git a/arch/x86/include/asm/amd_nb.h b/arch/x86/include/asm/amd_nb.h
index 417eb24..d2e703b 100644
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
diff --git a/drivers/edac/amd64_edac.c b/drivers/edac/amd64_edac.c
index 6c1005f..30149e4 100644
--- a/drivers/edac/amd64_edac.c
+++ b/drivers/edac/amd64_edac.c
@@ -31,7 +31,7 @@ static struct ecc_settings **ecc_stngs;
  *
  *FIXME: Produce a better mapping/linearisation.
  */
-struct scrubrate {
+static const struct scrubrate {
        u32 scrubval;           /* bit pattern for scrub rate */
        u32 bandwidth;          /* bandwidth consumed (bytes/sec) */
 } scrubrates[] = {
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
@@ -1351,7 +1351,7 @@ static u8 f1x_determine_channel(struct amd64_pvt *pvt, u64 sys_addr,
 }
 
 /* Convert the sys_addr to the normalized DCT address */
-static u64 f1x_get_norm_dct_addr(struct amd64_pvt *pvt, unsigned range,
+static u64 f1x_get_norm_dct_addr(struct amd64_pvt *pvt, u8 range,
 				 u64 sys_addr, bool hi_rng,
 				 u32 dct_sel_base_addr)
 {
@@ -1427,7 +1427,7 @@ static int f10_process_possible_spare(struct amd64_pvt *pvt, u8 dct, int csrow)
  *	-EINVAL:  NOT FOUND
  *	0..csrow = Chip-Select Row
  */
-static int f1x_lookup_addr_in_dct(u64 in_addr, u32 nid, u8 dct)
+static int f1x_lookup_addr_in_dct(u64 in_addr, u8 nid, u8 dct)
 {
 	struct mem_ctl_info *mci;
 	struct amd64_pvt *pvt;
@@ -1742,7 +1742,7 @@ static struct amd64_family_type amd64_family_types[] = {
  *
  * Algorithm courtesy of Ross LaFetra from AMD.
  */
-static u16 x4_vectors[] = {
+static const u16 x4_vectors[] = {
 	0x2f57, 0x1afe, 0x66cc, 0xdd88,
 	0x11eb, 0x3396, 0x7f4c, 0xeac8,
 	0x0001, 0x0002, 0x0004, 0x0008,
@@ -1781,7 +1781,7 @@ static u16 x4_vectors[] = {
 	0x19a9, 0x2efe, 0xb5cc, 0x6f88,
 };
 
-static u16 x8_vectors[] = {
+static const u16 x8_vectors[] = {
 	0x0145, 0x028a, 0x2374, 0x43c8, 0xa1f0, 0x0520, 0x0a40, 0x1480,
 	0x0211, 0x0422, 0x0844, 0x1088, 0x01b0, 0x44e0, 0x23c0, 0xed80,
 	0x1011, 0x0116, 0x022c, 0x0458, 0x08b0, 0x8c60, 0x2740, 0x4e80,
@@ -1803,7 +1803,7 @@ static u16 x8_vectors[] = {
 	0x0100, 0x0200, 0x0400, 0x0800, 0x1000, 0x2000, 0x4000, 0x8000,
 };
 
-static int decode_syndrome(u16 syndrome, u16 *vectors, unsigned num_vecs,
+static int decode_syndrome(u16 syndrome, const u16 *vectors, unsigned num_vecs,
 			   unsigned v_dim)
 {
 	unsigned int i, err_sym;
@@ -2269,7 +2269,7 @@ static void get_cpus_on_this_dct_cpumask(struct cpumask *mask, u16 nid)
 }
 
 /* check MCG_CTL on all the cpus on this node */
-static bool amd64_nb_mce_bank_enabled_on_node(unsigned nid)
+static bool amd64_nb_mce_bank_enabled_on_node(u16 nid)
 {
 	cpumask_var_t mask;
 	int cpu, nbe;
@@ -2302,7 +2302,7 @@ out:
 	return ret;
 }
 
-static int toggle_ecc_err_reporting(struct ecc_settings *s, u8 nid, bool on)
+static int toggle_ecc_err_reporting(struct ecc_settings *s, u16 nid, bool on)
 {
 	cpumask_var_t cmask;
 	int cpu;
@@ -2340,7 +2340,7 @@ static int toggle_ecc_err_reporting(struct ecc_settings *s, u8 nid, bool on)
 	return 0;
 }
 
-static bool enable_ecc_error_reporting(struct ecc_settings *s, u8 nid,
+static bool enable_ecc_error_reporting(struct ecc_settings *s, u16 nid,
 				       struct pci_dev *F3)
 {
 	bool ret = true;
@@ -2392,7 +2392,7 @@ static bool enable_ecc_error_reporting(struct ecc_settings *s, u8 nid,
 	return ret;
 }
 
-static void restore_ecc_error_reporting(struct ecc_settings *s, u8 nid,
+static void restore_ecc_error_reporting(struct ecc_settings *s, u16 nid,
 					struct pci_dev *F3)
 {
 	u32 value, mask = 0x3;		/* UECC/CECC enable */
@@ -2431,7 +2431,7 @@ static const char *ecc_msg =
 	"'ecc_enable_override'.\n"
 	" (Note that use of the override may cause unknown side effects.)\n";
 
-static bool ecc_enabled(struct pci_dev *F3, u8 nid)
+static bool ecc_enabled(struct pci_dev *F3, u16 nid)
 {
 	u32 value;
 	u8 ecc_en = 0;
diff --git a/drivers/edac/amd64_edac.h b/drivers/edac/amd64_edac.h
index cecd0c4..a558084 100644
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

