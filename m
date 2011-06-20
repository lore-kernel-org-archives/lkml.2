Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756123Ab1FTWQt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jun 2011 18:16:49 -0400
Received: from claw.goop.org ([74.207.240.146]:53651 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755990Ab1FTWPa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jun 2011 18:15:30 -0400
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Xen Devel <Xen-devel@lists.xensource.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: [PATCH 09/15] xen/trace: add tlb flush tracepoints
Date: Mon, 20 Jun 2011 15:15:05 -0700
Message-Id: <4db3e32a6b21efdb4d82646816ddb1bb82ff2259.1308607697.git.jeremy.fitzhardinge@citrix.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <cover.1308607697.git.jeremy.fitzhardinge@citrix.com>
References: <cover.1308607697.git.jeremy.fitzhardinge@citrix.com>
In-Reply-To: <cover.1308607697.git.jeremy.fitzhardinge@citrix.com>
References: <cover.1308607697.git.jeremy.fitzhardinge@citrix.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/x86/xen/mmu.c         |    8 +++++++
 include/trace/events/xen.h |   48 ++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 56 insertions(+), 0 deletions(-)

diff --git a/arch/x86/xen/mmu.c b/arch/x86/xen/mmu.c
index 8aaa398..ad8a226 100644
--- a/arch/x86/xen/mmu.c
+++ b/arch/x86/xen/mmu.c
@@ -1221,6 +1221,8 @@ static void xen_flush_tlb(void)
 	struct mmuext_op *op;
 	struct multicall_space mcs;
 
+	trace_xen_mmu_flush_tlb(0);
+
 	preempt_disable();
 
 	mcs = xen_mc_entry(sizeof(*op));
@@ -1239,6 +1241,8 @@ static void xen_flush_tlb_single(unsigned long addr)
 	struct mmuext_op *op;
 	struct multicall_space mcs;
 
+	trace_xen_mmu_flush_tlb_single(addr);
+
 	preempt_disable();
 
 	mcs = xen_mc_entry(sizeof(*op));
@@ -1261,6 +1265,8 @@ static void xen_flush_tlb_others(const struct cpumask *cpus,
 	} *args;
 	struct multicall_space mcs;
 
+	trace_xen_mmu_flush_tlb_others(cpus, mm, va);
+
 	if (cpumask_empty(cpus))
 		return;		/* nothing to do */
 
@@ -1300,6 +1306,8 @@ static void __xen_write_cr3(bool kernel, unsigned long cr3)
 	struct multicall_space mcs;
 	unsigned long mfn;
 
+	trace_xen_mmu_write_cr3(kernel, cr3);
+
 	if (cr3)
 		mfn = pfn_to_mfn(PFN_DOWN(cr3));
 	else
diff --git a/include/trace/events/xen.h b/include/trace/events/xen.h
index b1f73c4..7d88f7d 100644
--- a/include/trace/events/xen.h
+++ b/include/trace/events/xen.h
@@ -405,6 +405,54 @@ TRACE_EVENT(xen_mmu_pgd_unpin,
 	    TP_printk("mm %p pgd %p", __entry->mm, __entry->pgd)
 	);
 
+TRACE_EVENT(xen_mmu_flush_tlb,
+	    TP_PROTO(int x),
+	    TP_ARGS(x),
+	    TP_STRUCT__entry(__array(char, x, 0)),
+	    TP_fast_assign((void)x),
+	    TP_printk("%s", "")
+	);
+
+TRACE_EVENT(xen_mmu_flush_tlb_single,
+	    TP_PROTO(unsigned long addr),
+	    TP_ARGS(addr),
+	    TP_STRUCT__entry(
+		    __field(unsigned long, addr)
+		    ),
+	    TP_fast_assign(__entry->addr = addr),
+	    TP_printk("addr %lx", __entry->addr)
+	);
+
+TRACE_EVENT(xen_mmu_flush_tlb_others,
+	    TP_PROTO(const struct cpumask *cpus, struct mm_struct *mm,
+		     unsigned long addr),
+	    TP_ARGS(cpus, mm, addr),
+	    TP_STRUCT__entry(
+		    __field(unsigned, ncpus)
+		    __field(struct mm_struct *, mm)
+		    __field(unsigned long, addr)
+		    ),
+	    TP_fast_assign(__entry->ncpus = cpumask_weight(cpus);
+			   __entry->mm = mm;
+			   __entry->addr = addr),
+	    TP_printk("ncpus %d mm %p addr %lx",
+		      __entry->ncpus, __entry->mm, __entry->addr)
+	);
+
+TRACE_EVENT(xen_mmu_write_cr3,
+	    TP_PROTO(bool kernel, unsigned long cr3),
+	    TP_ARGS(kernel, cr3),
+	    TP_STRUCT__entry(
+		    __field(bool, kernel)
+		    __field(unsigned long, cr3)
+		    ),
+	    TP_fast_assign(__entry->kernel = kernel;
+			   __entry->cr3 = cr3),
+	    TP_printk("%s cr3 %lx",
+		      __entry->kernel ? "kernel" : "user", __entry->cr3)
+	);
+
+
 /* CPU */
 TRACE_EVENT(xen_cpu_write_ldt_entry,
 	    TP_PROTO(struct desc_struct *dt, int entrynum, u64 desc),
-- 
1.7.5.4

