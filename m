Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753249Ab0LVNRv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Dec 2010 08:17:51 -0500
Received: from hera.kernel.org ([140.211.167.34]:38626 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752413Ab0LVNRt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Dec 2010 08:17:49 -0500
Date: Wed, 22 Dec 2010 13:17:25 GMT
From: tip-bot for Jack Steiner <steiner@sgi.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        steiner@sgi.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        steiner@sgi.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20101130195926.972776133@sgi.com>
References: <20101130195926.972776133@sgi.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/uv] x86, UV: Fix the effect of extra bits in the hub nodeid register
Message-ID: <tip-d8850ba425d9823d3184bd52f065899dac4689f9@git.kernel.org>
Git-Commit-ID: d8850ba425d9823d3184bd52f065899dac4689f9
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 22 Dec 2010 13:17:25 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  d8850ba425d9823d3184bd52f065899dac4689f9
Gitweb:     http://git.kernel.org/tip/d8850ba425d9823d3184bd52f065899dac4689f9
Author:     Jack Steiner <steiner@sgi.com>
AuthorDate: Tue, 30 Nov 2010 13:55:40 -0600
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 22 Dec 2010 12:31:15 +0100

x86, UV: Fix the effect of extra bits in the hub nodeid register

UV systems can be partitioned into multiple independent SSIs.
Large partitioned systems may have extra bits in the node_id
register. These bits are used when the total memory on all SSIs
exceeds 16TB.  These extra bits need to be ignored when
calculating x2apic_extra_bits.

Signed-off-by: Jack Steiner <steiner@sgi.com>
LKML-Reference: <20101130195926.972776133@sgi.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/apic/x2apic_uv_x.c |   33 +++++++++++++++++++++------------
 1 files changed, 21 insertions(+), 12 deletions(-)

diff --git a/arch/x86/kernel/apic/x2apic_uv_x.c b/arch/x86/kernel/apic/x2apic_uv_x.c
index 0c3675f..2a3f2a7 100644
--- a/arch/x86/kernel/apic/x2apic_uv_x.c
+++ b/arch/x86/kernel/apic/x2apic_uv_x.c
@@ -68,15 +68,19 @@ static bool uv_is_untracked_pat_range(u64 start, u64 end)
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
@@ -104,10 +108,10 @@ static void __init uv_set_apicid_hibit(void)
 
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
@@ -117,7 +121,7 @@ static int __init uv_acpi_madt_oem_check(char *oem_id, char *oem_table_id)
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
