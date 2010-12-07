Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754279Ab0LGWRT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 17:17:19 -0500
Received: from relay3.sgi.com ([192.48.152.1]:45105 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754180Ab0LGWRO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 17:17:14 -0500
Message-Id: <20101207221712.086380699@sgi.com>
User-Agent: quilt/0.47-1
Date: Tue, 07 Dec 2010 16:14:32 -0600
From: steiner@sgi.com
To: mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com
Cc: linux-kernel@vger.kernel.org
Subject: [Patch 2/2] X86, UV UV Mask extra bits in hub nodeid register
References: <20101207221430.309660089@sgi.com>
Content-Disposition: inline; filename=uv_early_set_x2apic_extra
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jack Steiner <steiner@sgi.com>

UV systems can be partitioned into multiple independent SSIs.
Large partitioned systems may have extra bits in the node_id register.
These bits are used when the total memory on all SSIs exceeds
16TB.  These extra bits need to be ignored when calculating
x2apic_extra_bits.

Signed-off-by: Jack Steiner <steiner@sgi.com>

---
 arch/x86/kernel/apic/x2apic_uv_x.c |   33 +++++++++++++++++++++------------
 1 file changed, 21 insertions(+), 12 deletions(-)

Index: linux/arch/x86/kernel/apic/x2apic_uv_x.c
===================================================================
--- linux.orig/arch/x86/kernel/apic/x2apic_uv_x.c	2010-11-30 13:10:47.972649334 -0600
+++ linux/arch/x86/kernel/apic/x2apic_uv_x.c	2010-11-30 13:43:33.799668601 -0600
@@ -68,15 +68,19 @@ static bool uv_is_untracked_pat_range(u6
 	return is_ISA_range(start, end) || is_GRU_range(start, end);
 }
 
-static int __init early_get_nodeid(void)
+static int __init early_get_pnodeid(void)
 {
 	union uvh_node_id_u node_id;
+	union uvh_rh_gam_config_mmr_u  m_n_config;
+	int pnode;
 
 	/* Currently, all blades have same revision number */
 	node_id.v = uv_early_read_mmr(UVH_NODE_ID);
+	m_n_config.v = uv_early_read_mmr(UVH_RH_GAM_CONFIG_MMR);
 	uv_min_hub_revision_id = node_id.s.revision;
 
-	return node_id.s.node_id;
+	pnode = (node_id.s.node_id >> 1) & ((1 << m_n_config.s.n_skt) - 1);
+	return pnode;
 }
 
 static void __init early_get_apic_pnode_shift(void)
@@ -104,10 +108,10 @@ static void __init uv_set_apicid_hibit(v
 
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
@@ -117,7 +121,7 @@ static int __init uv_acpi_madt_oem_check
 			uv_system_type = UV_X2APIC;
 		else if (!strcmp(oem_table_id, "UVH")) {
 			__get_cpu_var(x2apic_extra_bits) =
-				nodeid << (uvh_apicid.s.pnode_shift - 1);
+				pnodeid << uvh_apicid.s.pnode_shift;
 			uv_system_type = UV_NON_UNIQUE_APIC;
 			uv_set_apicid_hibit();
 			return 1;
@@ -680,27 +684,32 @@ void uv_nmi_init(void)
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
 
@@ -733,7 +742,7 @@ void __init uv_system_init(void)
 		for (j = 0; j < 64; j++) {
 			if (!test_bit(j, &present))
 				continue;
-			pnode = (i * 64 + j);
+			pnode = (i * 64 + j) & pnode_mask;
 			uv_blade_info[blade].pnode = pnode;
 			uv_blade_info[blade].nr_possible_cpus = 0;
 			uv_blade_info[blade].nr_online_cpus = 0;
@@ -754,6 +763,7 @@ void __init uv_system_init(void)
 		/*
 		 * apic_pnode_shift must be set before calling uv_apicid_to_pnode();
 		 */
+		uv_cpu_hub_info(cpu)->pnode_mask = pnode_mask;
 		uv_cpu_hub_info(cpu)->apic_pnode_shift = uvh_apicid.s.pnode_shift;
 		pnode = uv_apicid_to_pnode(apicid);
 		blade = boot_pnode_to_blade(pnode);
@@ -770,7 +780,6 @@ void __init uv_system_init(void)
 		uv_cpu_hub_info(cpu)->numa_blade_id = blade;
 		uv_cpu_hub_info(cpu)->blade_processor_id = lcpu;
 		uv_cpu_hub_info(cpu)->pnode = pnode;
-		uv_cpu_hub_info(cpu)->pnode_mask = pnode_mask;
 		uv_cpu_hub_info(cpu)->gpa_mask = (1UL << (m_val + n_val)) - 1;
 		uv_cpu_hub_info(cpu)->gnode_upper = gnode_upper;
 		uv_cpu_hub_info(cpu)->gnode_extra = gnode_extra;
@@ -794,7 +803,7 @@ void __init uv_system_init(void)
 
 	map_gru_high(max_pnode);
 	map_mmr_high(max_pnode);
-	map_mmioh_high(max_pnode);
+	map_mmioh_high(max_pnode & pnode_io_mask);
 
 	uv_cpu_init();
 	uv_scir_register_cpu_notifier();

