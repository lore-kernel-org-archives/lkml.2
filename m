Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758393Ab2JaQy1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 12:54:27 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:40017 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753027Ab2JaQyZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 12:54:25 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com
Cc: mukesh.rathor@oracle.com, jingjie.jiang@oracle.com,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>, stable@vger.kernel.org
Subject: [PATCH] xen/mmu: Use Xen specific TLB flush instead of the generic one.
Date: Wed, 31 Oct 2012 12:40:40 -0400
Message-Id: <1351701640-18786-1-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.7.6
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As Mukesh explained it, the MMUEXT_TLB_FLUSH_ALL allows the
hypervisor to do a TLB flush on all active vCPUs. If instead
we were using the generic one (which ends up being xen_flush_tlb)
we end up making the MMUEXT_TLB_FLUSH_LOCAL hypercall. But
before we make that hypercall the kernel will IPI all of the
vCPUs (even those that were asleep from the hypervisor
perspective). The end result is that we needlessly wake them
up and do a TLB flush when we can just let the hypervisor
do it correctly.

This patch gives around 50% speed improvement when migrating
idle guest's from one host to another.

Oracle-bug: 14630170

CC: stable@vger.kernel.org
Tested-by:  Jingjie Jiang <jingjie.jiang@oracle.com>
Suggested-by:  Mukesh Rathor <mukesh.rathor@oracle.com>
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 arch/x86/xen/mmu.c         |   21 ++++++++++++++++++++-
 include/trace/events/xen.h |    8 ++++++++
 2 files changed, 28 insertions(+), 1 deletions(-)

diff --git a/arch/x86/xen/mmu.c b/arch/x86/xen/mmu.c
index 6226c99..dcf5f2d 100644
--- a/arch/x86/xen/mmu.c
+++ b/arch/x86/xen/mmu.c
@@ -1288,6 +1288,25 @@ unsigned long xen_read_cr2_direct(void)
 	return this_cpu_read(xen_vcpu_info.arch.cr2);
 }
 
+void xen_flush_tlb_all(void)
+{
+	struct mmuext_op *op;
+	struct multicall_space mcs;
+
+	trace_xen_mmu_flush_tlb_all(0);
+
+	preempt_disable();
+
+	mcs = xen_mc_entry(sizeof(*op));
+
+	op = mcs.args;
+	op->cmd = MMUEXT_TLB_FLUSH_ALL;
+	MULTI_mmuext_op(mcs.mc, op, 1, NULL, DOMID_SELF);
+
+	xen_mc_issue(PARAVIRT_LAZY_MMU);
+
+	preempt_enable();
+}
 static void xen_flush_tlb(void)
 {
 	struct mmuext_op *op;
@@ -2518,7 +2537,7 @@ int xen_remap_domain_mfn_range(struct vm_area_struct *vma,
 	err = 0;
 out:
 
-	flush_tlb_all();
+	xen_flush_tlb_all();
 
 	return err;
 }
diff --git a/include/trace/events/xen.h b/include/trace/events/xen.h
index 15ba03b..d06b6da 100644
--- a/include/trace/events/xen.h
+++ b/include/trace/events/xen.h
@@ -377,6 +377,14 @@ DECLARE_EVENT_CLASS(xen_mmu_pgd,
 DEFINE_XEN_MMU_PGD_EVENT(xen_mmu_pgd_pin);
 DEFINE_XEN_MMU_PGD_EVENT(xen_mmu_pgd_unpin);
 
+TRACE_EVENT(xen_mmu_flush_tlb_all,
+	    TP_PROTO(int x),
+	    TP_ARGS(x),
+	    TP_STRUCT__entry(__array(char, x, 0)),
+	    TP_fast_assign((void)x),
+	    TP_printk("%s", "")
+	);
+
 TRACE_EVENT(xen_mmu_flush_tlb,
 	    TP_PROTO(int x),
 	    TP_ARGS(x),
-- 
1.7.7.6

