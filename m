Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752615Ab1AFKUa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jan 2011 05:20:30 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:42786 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752427Ab1AFKU2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jan 2011 05:20:28 -0500
Date: Thu, 6 Jan 2011 11:20:20 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] x86/uv changes for v2.6.38
Message-ID: <20110106102020.GA23899@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest x86-uv-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git x86-uv-for-linus

 Thanks,

	Ingo

------------------>
Cliff Wickman (1):
      x86, UV, BAU: Extend for more than 16 cpus per socket

Jack Steiner (2):
      x86, UV: Add common uv_early_read_mmr() function for reading MMRs
      x86, UV: Fix the effect of extra bits in the hub nodeid register


 arch/x86/include/asm/uv/uv_bau.h   |    9 +++--
 arch/x86/kernel/apic/x2apic_uv_x.c |   61 ++++++++++++++++++++----------------
 arch/x86/platform/uv/tlb_uv.c      |   22 ++++++++++--
 3 files changed, 57 insertions(+), 35 deletions(-)

diff --git a/arch/x86/include/asm/uv/uv_bau.h b/arch/x86/include/asm/uv/uv_bau.h
index 42d412f..ce1d54c 100644
--- a/arch/x86/include/asm/uv/uv_bau.h
+++ b/arch/x86/include/asm/uv/uv_bau.h
@@ -26,20 +26,22 @@
  * BAU_SB_DESCRIPTOR_BASE register, set 1 is located at BASE + 512,
  * set 2 is at BASE + 2*512, set 3 at BASE + 3*512, and so on.
  *
- * We will use 31 sets, one for sending BAU messages from each of the 32
+ * We will use one set for sending BAU messages from each of the
  * cpu's on the uvhub.
  *
  * TLB shootdown will use the first of the 8 descriptors of each set.
  * Each of the descriptors is 64 bytes in size (8*64 = 512 bytes in a set).
  */
 
+#define MAX_CPUS_PER_UVHUB		64
+#define MAX_CPUS_PER_SOCKET		32
+#define UV_ADP_SIZE			64 /* hardware-provided max. */
+#define UV_CPUS_PER_ACT_STATUS		32 /* hardware-provided max. */
 #define UV_ITEMS_PER_DESCRIPTOR		8
 /* the 'throttle' to prevent the hardware stay-busy bug */
 #define MAX_BAU_CONCURRENT		3
-#define UV_CPUS_PER_ACT_STATUS		32
 #define UV_ACT_STATUS_MASK		0x3
 #define UV_ACT_STATUS_SIZE		2
-#define UV_ADP_SIZE			32
 #define UV_DISTRIBUTION_SIZE		256
 #define UV_SW_ACK_NPENDING		8
 #define UV_NET_ENDPOINT_INTD		0x38
@@ -100,7 +102,6 @@
  * number of destination side software ack resources
  */
 #define DEST_NUM_RESOURCES		8
-#define MAX_CPUS_PER_NODE		32
 /*
  * completion statuses for sending a TLB flush message
  */
diff --git a/arch/x86/kernel/apic/x2apic_uv_x.c b/arch/x86/kernel/apic/x2apic_uv_x.c
index c1c52c3..2a3f2a7 100644
--- a/arch/x86/kernel/apic/x2apic_uv_x.c
+++ b/arch/x86/kernel/apic/x2apic_uv_x.c
@@ -48,6 +48,16 @@ unsigned int uv_apicid_hibits;
 EXPORT_SYMBOL_GPL(uv_apicid_hibits);
 static DEFINE_SPINLOCK(uv_nmi_lock);
 
+static unsigned long __init uv_early_read_mmr(unsigned long addr)
+{
+	unsigned long val, *mmr;
+
+	mmr = early_ioremap(UV_LOCAL_MMR_BASE | addr, sizeof(*mmr));
+	val = *mmr;
+	early_iounmap(mmr, sizeof(*mmr));
+	return val;
+}
+
 static inline bool is_GRU_range(u64 start, u64 end)
 {
 	return start >= gru_start_paddr && end <= gru_end_paddr;
@@ -58,28 +68,24 @@ static bool uv_is_untracked_pat_range(u64 start, u64 end)
 	return is_ISA_range(start, end) || is_GRU_range(start, end);
 }
 
-static int early_get_nodeid(void)
+static int __init early_get_pnodeid(void)
 {
 	union uvh_node_id_u node_id;
-	unsigned long *mmr;
-
-	mmr = early_ioremap(UV_LOCAL_MMR_BASE | UVH_NODE_ID, sizeof(*mmr));
-	node_id.v = *mmr;
-	early_iounmap(mmr, sizeof(*mmr));
+	union uvh_rh_gam_config_mmr_u  m_n_config;
+	int pnode;
 
 	/* Currently, all blades have same revision number */
+	node_id.v = uv_early_read_mmr(UVH_NODE_ID);
+	m_n_config.v = uv_early_read_mmr(UVH_RH_GAM_CONFIG_MMR);
 	uv_min_hub_revision_id = node_id.s.revision;
 
-	return node_id.s.node_id;
+	pnode = (node_id.s.node_id >> 1) & ((1 << m_n_config.s.n_skt) - 1);
+	return pnode;
 }
 
 static void __init early_get_apic_pnode_shift(void)
 {
-	unsigned long *mmr;
-
-	mmr = early_ioremap(UV_LOCAL_MMR_BASE | UVH_APICID, sizeof(*mmr));
-	uvh_apicid.v = *mmr;
-	early_iounmap(mmr, sizeof(*mmr));
+	uvh_apicid.v = uv_early_read_mmr(UVH_APICID);
 	if (!uvh_apicid.v)
 		/*
 		 * Old bios, use default value
@@ -95,21 +101,17 @@ static void __init early_get_apic_pnode_shift(void)
 static void __init uv_set_apicid_hibit(void)
 {
 	union uvh_lb_target_physical_apic_id_mask_u apicid_mask;
-	unsigned long *mmr;
 
-	mmr = early_ioremap(UV_LOCAL_MMR_BASE |
-		UVH_LB_TARGET_PHYSICAL_APIC_ID_MASK, sizeof(*mmr));
-	apicid_mask.v = *mmr;
-	early_iounmap(mmr, sizeof(*mmr));
+	apicid_mask.v = uv_early_read_mmr(UVH_LB_TARGET_PHYSICAL_APIC_ID_MASK);
 	uv_apicid_hibits = apicid_mask.s.bit_enables & UV_APICID_HIBIT_MASK;
 }
 
 static int __init uv_acpi_madt_oem_check(char *oem_id, char *oem_table_id)
 {
-	int nodeid;
+	int pnodeid;
 
 	if (!strcmp(oem_id, "SGI")) {
-		nodeid = early_get_nodeid();
+		pnodeid = early_get_pnodeid();
 		early_get_apic_pnode_shift();
 		x86_platform.is_untracked_pat_range =  uv_is_untracked_pat_range;
 		x86_platform.nmi_init = uv_nmi_init;
@@ -119,7 +121,7 @@ static int __init uv_acpi_madt_oem_check(char *oem_id, char *oem_table_id)
 			uv_system_type = UV_X2APIC;
 		else if (!strcmp(oem_table_id, "UVH")) {
 			__get_cpu_var(x2apic_extra_bits) =
-				nodeid << (uvh_apicid.s.pnode_shift - 1);
+				pnodeid << uvh_apicid.s.pnode_shift;
 			uv_system_type = UV_NON_UNIQUE_APIC;
 			uv_set_apicid_hibit();
 			return 1;
@@ -682,27 +684,32 @@ void uv_nmi_init(void)
 void __init uv_system_init(void)
 {
 	union uvh_rh_gam_config_mmr_u  m_n_config;
+	union uvh_rh_gam_mmioh_overlay_config_mmr_u mmioh;
 	union uvh_node_id_u node_id;
 	unsigned long gnode_upper, lowmem_redir_base, lowmem_redir_size;
-	int bytes, nid, cpu, lcpu, pnode, blade, i, j, m_val, n_val;
+	int bytes, nid, cpu, lcpu, pnode, blade, i, j, m_val, n_val, n_io;
 	int gnode_extra, max_pnode = 0;
 	unsigned long mmr_base, present, paddr;
-	unsigned short pnode_mask;
+	unsigned short pnode_mask, pnode_io_mask;
 
 	map_low_mmrs();
 
 	m_n_config.v = uv_read_local_mmr(UVH_RH_GAM_CONFIG_MMR );
 	m_val = m_n_config.s.m_skt;
 	n_val = m_n_config.s.n_skt;
+	mmioh.v = uv_read_local_mmr(UVH_RH_GAM_MMIOH_OVERLAY_CONFIG_MMR);
+	n_io = mmioh.s.n_io;
 	mmr_base =
 	    uv_read_local_mmr(UVH_RH_GAM_MMR_OVERLAY_CONFIG_MMR) &
 	    ~UV_MMR_ENABLE;
 	pnode_mask = (1 << n_val) - 1;
+	pnode_io_mask = (1 << n_io) - 1;
+
 	node_id.v = uv_read_local_mmr(UVH_NODE_ID);
 	gnode_extra = (node_id.s.node_id & ~((1 << n_val) - 1)) >> 1;
 	gnode_upper = ((unsigned long)gnode_extra  << m_val);
-	printk(KERN_DEBUG "UV: N %d, M %d, gnode_upper 0x%lx, gnode_extra 0x%x\n",
-			n_val, m_val, gnode_upper, gnode_extra);
+	printk(KERN_INFO "UV: N %d, M %d, N_IO: %d, gnode_upper 0x%lx, gnode_extra 0x%x, pnode_mask 0x%x, pnode_io_mask 0x%x\n",
+			n_val, m_val, n_io, gnode_upper, gnode_extra, pnode_mask, pnode_io_mask);
 
 	printk(KERN_DEBUG "UV: global MMR base 0x%lx\n", mmr_base);
 
@@ -735,7 +742,7 @@ void __init uv_system_init(void)
 		for (j = 0; j < 64; j++) {
 			if (!test_bit(j, &present))
 				continue;
-			pnode = (i * 64 + j);
+			pnode = (i * 64 + j) & pnode_mask;
 			uv_blade_info[blade].pnode = pnode;
 			uv_blade_info[blade].nr_possible_cpus = 0;
 			uv_blade_info[blade].nr_online_cpus = 0;
@@ -756,6 +763,7 @@ void __init uv_system_init(void)
 		/*
 		 * apic_pnode_shift must be set before calling uv_apicid_to_pnode();
 		 */
+		uv_cpu_hub_info(cpu)->pnode_mask = pnode_mask;
 		uv_cpu_hub_info(cpu)->apic_pnode_shift = uvh_apicid.s.pnode_shift;
 		pnode = uv_apicid_to_pnode(apicid);
 		blade = boot_pnode_to_blade(pnode);
@@ -772,7 +780,6 @@ void __init uv_system_init(void)
 		uv_cpu_hub_info(cpu)->numa_blade_id = blade;
 		uv_cpu_hub_info(cpu)->blade_processor_id = lcpu;
 		uv_cpu_hub_info(cpu)->pnode = pnode;
-		uv_cpu_hub_info(cpu)->pnode_mask = pnode_mask;
 		uv_cpu_hub_info(cpu)->gpa_mask = (1UL << (m_val + n_val)) - 1;
 		uv_cpu_hub_info(cpu)->gnode_upper = gnode_upper;
 		uv_cpu_hub_info(cpu)->gnode_extra = gnode_extra;
@@ -796,7 +803,7 @@ void __init uv_system_init(void)
 
 	map_gru_high(max_pnode);
 	map_mmr_high(max_pnode);
-	map_mmioh_high(max_pnode);
+	map_mmioh_high(max_pnode & pnode_io_mask);
 
 	uv_cpu_init();
 	uv_scir_register_cpu_notifier();
diff --git a/arch/x86/platform/uv/tlb_uv.c b/arch/x86/platform/uv/tlb_uv.c
index ba9caa8..df58e9c 100644
--- a/arch/x86/platform/uv/tlb_uv.c
+++ b/arch/x86/platform/uv/tlb_uv.c
@@ -1341,7 +1341,7 @@ uv_activation_descriptor_init(int node, int pnode)
 
 	/*
 	 * each bau_desc is 64 bytes; there are 8 (UV_ITEMS_PER_DESCRIPTOR)
-	 * per cpu; and up to 32 (UV_ADP_SIZE) cpu's per uvhub
+	 * per cpu; and one per cpu on the uvhub (UV_ADP_SIZE)
 	 */
 	bau_desc = kmalloc_node(sizeof(struct bau_desc) * UV_ADP_SIZE
 				* UV_ITEMS_PER_DESCRIPTOR, GFP_KERNEL, node);
@@ -1490,7 +1490,7 @@ calculate_destination_timeout(void)
 /*
  * initialize the bau_control structure for each cpu
  */
-static void __init uv_init_per_cpu(int nuvhubs)
+static int __init uv_init_per_cpu(int nuvhubs)
 {
 	int i;
 	int cpu;
@@ -1507,7 +1507,7 @@ static void __init uv_init_per_cpu(int nuvhubs)
 	struct bau_control *smaster = NULL;
 	struct socket_desc {
 		short num_cpus;
-		short cpu_number[16];
+		short cpu_number[MAX_CPUS_PER_SOCKET];
 	};
 	struct uvhub_desc {
 		unsigned short socket_mask;
@@ -1540,6 +1540,10 @@ static void __init uv_init_per_cpu(int nuvhubs)
 		sdp = &bdp->socket[socket];
 		sdp->cpu_number[sdp->num_cpus] = cpu;
 		sdp->num_cpus++;
+		if (sdp->num_cpus > MAX_CPUS_PER_SOCKET) {
+			printk(KERN_EMERG "%d cpus per socket invalid\n", sdp->num_cpus);
+			return 1;
+		}
 	}
 	for (uvhub = 0; uvhub < nuvhubs; uvhub++) {
 		if (!(*(uvhub_mask + (uvhub/8)) & (1 << (uvhub%8))))
@@ -1570,6 +1574,12 @@ static void __init uv_init_per_cpu(int nuvhubs)
 				bcp->uvhub_master = hmaster;
 				bcp->uvhub_cpu = uv_cpu_hub_info(cpu)->
 						blade_processor_id;
+				if (bcp->uvhub_cpu >= MAX_CPUS_PER_UVHUB) {
+					printk(KERN_EMERG
+						"%d cpus per uvhub invalid\n",
+						bcp->uvhub_cpu);
+					return 1;
+				}
 			}
 nextsocket:
 			socket++;
@@ -1595,6 +1605,7 @@ nextsocket:
 		bcp->congested_reps = congested_reps;
 		bcp->congested_period = congested_period;
 	}
+	return 0;
 }
 
 /*
@@ -1625,7 +1636,10 @@ static int __init uv_bau_init(void)
 	spin_lock_init(&disable_lock);
 	congested_cycles = microsec_2_cycles(congested_response_us);
 
-	uv_init_per_cpu(nuvhubs);
+	if (uv_init_per_cpu(nuvhubs)) {
+		nobau = 1;
+		return 0;
+	}
 
 	uv_partition_base_pnode = 0x7fffffff;
 	for (uvhub = 0; uvhub < nuvhubs; uvhub++)
