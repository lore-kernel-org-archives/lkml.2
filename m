Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756062Ab2LMOCv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 09:02:51 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:44099 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756022Ab2LMOCp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 09:02:45 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 033/241] xen/mmu: Use Xen specific TLB flush instead of the generic one.
Date: Thu, 13 Dec 2012 11:56:38 -0200
Message-Id: <1355407206-17100-34-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1355407206-17100-1-git-send-email-herton.krzesinski@canonical.com>
References: <1355407206-17100-1-git-send-email-herton.krzesinski@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.2 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>

commit 95a7d76897c1e7243d4137037c66d15cbf2cce76 upstream.

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

Tested-by:  Jingjie Jiang <jingjie.jiang@oracle.com>
Suggested-by:  Mukesh Rathor <mukesh.rathor@oracle.com>
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 arch/x86/xen/mmu.c         |   21 ++++++++++++++++++++-
 include/trace/events/xen.h |    8 ++++++++
 2 files changed, 28 insertions(+), 1 deletion(-)

diff --git a/arch/x86/xen/mmu.c b/arch/x86/xen/mmu.c
index 3a73785..dc5c3e3 100644
--- a/arch/x86/xen/mmu.c
+++ b/arch/x86/xen/mmu.c
@@ -1203,6 +1203,25 @@ unsigned long xen_read_cr2_direct(void)
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
@@ -2339,7 +2358,7 @@ int xen_remap_domain_mfn_range(struct vm_area_struct *vma,
 	err = 0;
 out:
 
-	flush_tlb_all();
+	xen_flush_tlb_all();
 
 	return err;
 }
diff --git a/include/trace/events/xen.h b/include/trace/events/xen.h
index 92f1a79..348c4fe 100644
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
1.7.9.5

