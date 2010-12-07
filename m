Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754300Ab0LGWRU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 17:17:20 -0500
Received: from relay1.sgi.com ([192.48.179.29]:55005 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754176Ab0LGWRO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 17:17:14 -0500
Message-Id: <20101207221711.909691676@sgi.com>
User-Agent: quilt/0.47-1
Date: Tue, 07 Dec 2010 16:14:31 -0600
From: steiner@sgi.com
To: mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com
Cc: linux-kernel@vger.kernel.org
Subject: [Patch 1/2] X86, UV UV Common function for reading MMRs
References: <20101207221430.309660089@sgi.com>
Content-Disposition: inline; filename=uv_early_read_mmr
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jack Steiner <steiner@sgi.com>

Early in boot, reading MMRs from the UV hub controller require
calls to early_ioremap()/early_iounmap().  Rather than duplicating
code, add a common function to do the map/read/unmap.


Signed-off-by: Jack Steiner <steiner@sgi.com>

---
 arch/x86/kernel/apic/x2apic_uv_x.c |   30 ++++++++++++++----------------
 1 file changed, 14 insertions(+), 16 deletions(-)

Index: linux/arch/x86/kernel/apic/x2apic_uv_x.c
===================================================================
--- linux.orig/arch/x86/kernel/apic/x2apic_uv_x.c	2010-11-30 12:54:36.000000000 -0600
+++ linux/arch/x86/kernel/apic/x2apic_uv_x.c	2010-11-30 12:55:56.051398739 -0600
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
@@ -58,16 +68,12 @@ static bool uv_is_untracked_pat_range(u6
 	return is_ISA_range(start, end) || is_GRU_range(start, end);
 }
 
-static int early_get_nodeid(void)
+static int __init early_get_nodeid(void)
 {
 	union uvh_node_id_u node_id;
-	unsigned long *mmr;
-
-	mmr = early_ioremap(UV_LOCAL_MMR_BASE | UVH_NODE_ID, sizeof(*mmr));
-	node_id.v = *mmr;
-	early_iounmap(mmr, sizeof(*mmr));
 
 	/* Currently, all blades have same revision number */
+	node_id.v = uv_early_read_mmr(UVH_NODE_ID);
 	uv_min_hub_revision_id = node_id.s.revision;
 
 	return node_id.s.node_id;
@@ -75,11 +81,7 @@ static int early_get_nodeid(void)
 
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
@@ -95,12 +97,8 @@ static void __init early_get_apic_pnode_
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
 

