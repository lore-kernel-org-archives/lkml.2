Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932102Ab1FTWSf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jun 2011 18:18:35 -0400
Received: from claw.goop.org ([74.207.240.146]:53612 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755899Ab1FTWPX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jun 2011 18:15:23 -0400
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Xen Devel <Xen-devel@lists.xensource.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: [PATCH 04/15] xen/trace: add multicall tracing
Date: Mon, 20 Jun 2011 15:15:00 -0700
Message-Id: <a0fe82ae10c0a00c31e60ffacbeec6f49eba93a5.1308607697.git.jeremy.fitzhardinge@citrix.com>
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
 arch/x86/include/asm/xen/hypercall.h   |   22 ++++++
 arch/x86/include/asm/xen/trace_types.h |   18 +++++
 arch/x86/xen/multicalls.c              |   31 ++++++--
 arch/x86/xen/multicalls.h              |    3 +
 arch/x86/xen/trace.c                   |   57 +++++++++++++++
 include/trace/events/xen.h             |  118 ++++++++++++++++++++++++++++++++
 6 files changed, 241 insertions(+), 8 deletions(-)
 create mode 100644 arch/x86/include/asm/xen/trace_types.h

diff --git a/arch/x86/include/asm/xen/hypercall.h b/arch/x86/include/asm/xen/hypercall.h
index d240ea9..417777d 100644
--- a/arch/x86/include/asm/xen/hypercall.h
+++ b/arch/x86/include/asm/xen/hypercall.h
@@ -39,6 +39,8 @@
 #include <linux/string.h>
 #include <linux/types.h>
 
+#include <trace/events/xen.h>
+
 #include <asm/page.h>
 #include <asm/pgtable.h>
 
@@ -459,6 +461,8 @@ MULTI_fpu_taskswitch(struct multicall_entry *mcl, int set)
 {
 	mcl->op = __HYPERVISOR_fpu_taskswitch;
 	mcl->args[0] = set;
+
+	trace_xen_mc_entry(mcl, 1);
 }
 
 static inline void
@@ -475,6 +479,8 @@ MULTI_update_va_mapping(struct multicall_entry *mcl, unsigned long va,
 		mcl->args[2] = new_val.pte >> 32;
 		mcl->args[3] = flags;
 	}
+
+	trace_xen_mc_entry(mcl, sizeof(new_val) == sizeof(long) ? 3 : 4);
 }
 
 static inline void
@@ -485,6 +491,8 @@ MULTI_grant_table_op(struct multicall_entry *mcl, unsigned int cmd,
 	mcl->args[0] = cmd;
 	mcl->args[1] = (unsigned long)uop;
 	mcl->args[2] = count;
+
+	trace_xen_mc_entry(mcl, 3);
 }
 
 static inline void
@@ -504,6 +512,8 @@ MULTI_update_va_mapping_otherdomain(struct multicall_entry *mcl, unsigned long v
 		mcl->args[3] = flags;
 		mcl->args[4] = domid;
 	}
+
+	trace_xen_mc_entry(mcl, sizeof(new_val) == sizeof(long) ? 4 : 5);
 }
 
 static inline void
@@ -520,6 +530,8 @@ MULTI_update_descriptor(struct multicall_entry *mcl, u64 maddr,
 		mcl->args[2] = desc.a;
 		mcl->args[3] = desc.b;
 	}
+
+	trace_xen_mc_entry(mcl, sizeof(maddr) == sizeof(long) ? 2 : 4);
 }
 
 static inline void
@@ -528,6 +540,8 @@ MULTI_memory_op(struct multicall_entry *mcl, unsigned int cmd, void *arg)
 	mcl->op = __HYPERVISOR_memory_op;
 	mcl->args[0] = cmd;
 	mcl->args[1] = (unsigned long)arg;
+
+	trace_xen_mc_entry(mcl, 2);
 }
 
 static inline void
@@ -539,6 +553,8 @@ MULTI_mmu_update(struct multicall_entry *mcl, struct mmu_update *req,
 	mcl->args[1] = count;
 	mcl->args[2] = (unsigned long)success_count;
 	mcl->args[3] = domid;
+
+	trace_xen_mc_entry(mcl, 4);
 }
 
 static inline void
@@ -550,6 +566,8 @@ MULTI_mmuext_op(struct multicall_entry *mcl, struct mmuext_op *op, int count,
 	mcl->args[1] = count;
 	mcl->args[2] = (unsigned long)success_count;
 	mcl->args[3] = domid;
+
+	trace_xen_mc_entry(mcl, 4);
 }
 
 static inline void
@@ -558,6 +576,8 @@ MULTI_set_gdt(struct multicall_entry *mcl, unsigned long *frames, int entries)
 	mcl->op = __HYPERVISOR_set_gdt;
 	mcl->args[0] = (unsigned long)frames;
 	mcl->args[1] = entries;
+
+	trace_xen_mc_entry(mcl, 2);
 }
 
 static inline void
@@ -567,6 +587,8 @@ MULTI_stack_switch(struct multicall_entry *mcl,
 	mcl->op = __HYPERVISOR_stack_switch;
 	mcl->args[0] = ss;
 	mcl->args[1] = esp;
+
+	trace_xen_mc_entry(mcl, 2);
 }
 
 #endif /* _ASM_X86_XEN_HYPERCALL_H */
diff --git a/arch/x86/include/asm/xen/trace_types.h b/arch/x86/include/asm/xen/trace_types.h
new file mode 100644
index 0000000..21e1874
--- /dev/null
+++ b/arch/x86/include/asm/xen/trace_types.h
@@ -0,0 +1,18 @@
+#ifndef _ASM_XEN_TRACE_TYPES_H
+#define _ASM_XEN_TRACE_TYPES_H
+
+enum xen_mc_flush_reason {
+	XEN_MC_FL_NONE,		/* explicit flush */
+	XEN_MC_FL_BATCH,	/* out of hypercall space */
+	XEN_MC_FL_ARGS,		/* out of argument space */
+	XEN_MC_FL_CALLBACK,	/* out of callback space */
+};
+
+enum xen_mc_extend_args {
+	XEN_MC_XE_OK,
+	XEN_MC_XE_BAD_OP,
+	XEN_MC_XE_NO_SPACE
+};
+typedef void (*xen_mc_callback_fn_t)(void *);
+
+#endif	/* _ASM_XEN_TRACE_TYPES_H */
diff --git a/arch/x86/xen/multicalls.c b/arch/x86/xen/multicalls.c
index d4be3fd..ac3641d 100644
--- a/arch/x86/xen/multicalls.c
+++ b/arch/x86/xen/multicalls.c
@@ -65,6 +65,8 @@ void xen_mc_flush(void)
 	   something in the middle */
 	local_irq_save(flags);
 
+	trace_xen_mc_flush(b->mcidx, b->argidx, b->cbidx);
+
 	if (b->mcidx) {
 #if MC_DEBUG
 		memcpy(b->debug, b->entries,
@@ -116,11 +118,15 @@ struct multicall_space __xen_mc_entry(size_t args)
 	struct multicall_space ret;
 	unsigned argidx = roundup(b->argidx, sizeof(u64));
 
+	trace_xen_mc_entry_alloc(args);
+
 	BUG_ON(preemptible());
 	BUG_ON(b->argidx > MC_ARGS);
 
 	if (b->mcidx == MC_BATCH ||
 	    (argidx + args) > MC_ARGS) {
+		trace_xen_mc_flush_reason((b->mcidx == MC_BATCH) ?
+					  XEN_MC_FL_BATCH : XEN_MC_FL_ARGS);
 		xen_mc_flush();
 		argidx = roundup(b->argidx, sizeof(u64));
 	}
@@ -145,20 +151,25 @@ struct multicall_space xen_mc_extend_args(unsigned long op, size_t size)
 	BUG_ON(preemptible());
 	BUG_ON(b->argidx > MC_ARGS);
 
-	if (b->mcidx == 0)
-		return ret;
-
-	if (b->entries[b->mcidx - 1].op != op)
-		return ret;
+	if (unlikely(b->mcidx == 0 ||
+		     b->entries[b->mcidx - 1].op != op)) {
+		trace_xen_mc_extend_args(op, size, XEN_MC_XE_BAD_OP);
+		goto out;
+	}
 
-	if ((b->argidx + size) > MC_ARGS)
-		return ret;
+	if (unlikely((b->argidx + size) > MC_ARGS)) {
+		trace_xen_mc_extend_args(op, size, XEN_MC_XE_NO_SPACE);
+		goto out;
+	}
 
 	ret.mc = &b->entries[b->mcidx - 1];
 	ret.args = &b->args[b->argidx];
 	b->argidx += size;
 
 	BUG_ON(b->argidx > MC_ARGS);
+
+	trace_xen_mc_extend_args(op, size, XEN_MC_XE_OK);
+out:
 	return ret;
 }
 
@@ -167,8 +178,12 @@ void xen_mc_callback(void (*fn)(void *), void *data)
 	struct mc_buffer *b = &__get_cpu_var(mc_buffer);
 	struct callback *cb;
 
-	if (b->cbidx == MC_BATCH)
+	if (b->cbidx == MC_BATCH) {
+		trace_xen_mc_flush_reason(XEN_MC_FL_CALLBACK);
 		xen_mc_flush();
+	}
+
+	trace_xen_mc_callback(fn, data);
 
 	cb = &b->callbacks[b->cbidx++];
 	cb->fn = fn;
diff --git a/arch/x86/xen/multicalls.h b/arch/x86/xen/multicalls.h
index fa7b8af..dee79b7 100644
--- a/arch/x86/xen/multicalls.h
+++ b/arch/x86/xen/multicalls.h
@@ -25,6 +25,7 @@ static inline void xen_mc_batch(void)
 
 	/* need to disable interrupts until this entry is complete */
 	local_irq_save(flags);
+	trace_xen_mc_batch(paravirt_get_lazy_mode());
 	__this_cpu_write(xen_mc_irq_flags, flags);
 }
 
@@ -40,6 +41,8 @@ void xen_mc_flush(void);
 /* Issue a multicall if we're not in a lazy mode */
 static inline void xen_mc_issue(unsigned mode)
 {
+	trace_xen_mc_issue(mode);
+
 	if ((paravirt_get_lazy_mode() & mode) == 0)
 		xen_mc_flush();
 
diff --git a/arch/x86/xen/trace.c b/arch/x86/xen/trace.c
index 8cca616..734beba 100644
--- a/arch/x86/xen/trace.c
+++ b/arch/x86/xen/trace.c
@@ -1,4 +1,61 @@
 #include <linux/ftrace.h>
 
+#define N(x)	[__HYPERVISOR_##x] = "("#x")"
+static const char *xen_hypercall_names[] = {
+	N(set_trap_table),
+	N(mmu_update),
+	N(set_gdt),
+	N(stack_switch),
+	N(set_callbacks),
+	N(fpu_taskswitch),
+	N(sched_op_compat),
+	N(dom0_op),
+	N(set_debugreg),
+	N(get_debugreg),
+	N(update_descriptor),
+	N(memory_op),
+	N(multicall),
+	N(update_va_mapping),
+	N(set_timer_op),
+	N(event_channel_op_compat),
+	N(xen_version),
+	N(console_io),
+	N(physdev_op_compat),
+	N(grant_table_op),
+	N(vm_assist),
+	N(update_va_mapping_otherdomain),
+	N(iret),
+	N(vcpu_op),
+	N(set_segment_base),
+	N(mmuext_op),
+	N(acm_op),
+	N(nmi_op),
+	N(sched_op),
+	N(callback_op),
+	N(xenoprof_op),
+	N(event_channel_op),
+	N(physdev_op),
+	N(hvm_op),
+
+/* Architecture-specific hypercall definitions. */
+	N(arch_0),
+	N(arch_1),
+	N(arch_2),
+	N(arch_3),
+	N(arch_4),
+	N(arch_5),
+	N(arch_6),
+	N(arch_7),
+};
+#undef N
+
+static const char *xen_hypercall_name(unsigned op)
+{
+	if (op < ARRAY_SIZE(xen_hypercall_names) && xen_hypercall_names[op] != NULL)
+		return xen_hypercall_names[op];
+
+	return "";
+}
+
 #define CREATE_TRACE_POINTS
 #include <trace/events/xen.h>
diff --git a/include/trace/events/xen.h b/include/trace/events/xen.h
index 46c170c..54600a7 100644
--- a/include/trace/events/xen.h
+++ b/include/trace/events/xen.h
@@ -6,7 +6,125 @@
 
 #include <linux/tracepoint.h>
 #include <asm/paravirt_types.h>
+#include <asm/xen/trace_types.h>
 
+/* Multicalls */
+
+TRACE_EVENT(xen_mc_batch,
+	    TP_PROTO(enum paravirt_lazy_mode mode),
+	    TP_ARGS(mode),
+	    TP_STRUCT__entry(
+		    __field(enum paravirt_lazy_mode, mode)
+		    ),
+	    TP_fast_assign(__entry->mode = mode),
+	    TP_printk("start batch LAZY_%s",
+		      (__entry->mode == PARAVIRT_LAZY_MMU) ? "MMU" :
+		      (__entry->mode == PARAVIRT_LAZY_CPU) ? "CPU" : "NONE")
+	);
+
+TRACE_EVENT(xen_mc_issue,
+	    TP_PROTO(enum paravirt_lazy_mode mode),
+	    TP_ARGS(mode),
+	    TP_STRUCT__entry(
+		    __field(enum paravirt_lazy_mode, mode)
+		    ),
+	    TP_fast_assign(__entry->mode = mode),
+	    TP_printk("issue mode LAZY_%s",
+		      (__entry->mode == PARAVIRT_LAZY_MMU) ? "MMU" :
+		      (__entry->mode == PARAVIRT_LAZY_CPU) ? "CPU" : "NONE")
+	);
+
+TRACE_EVENT(xen_mc_entry,
+	    TP_PROTO(struct multicall_entry *mc, unsigned nargs),
+	    TP_ARGS(mc, nargs),
+	    TP_STRUCT__entry(
+		    __field(unsigned short, op)
+		    __field(unsigned short, nargs)
+		    __array(unsigned long, args, 6)
+		    ),
+	    TP_fast_assign(__entry->op = mc->op;
+			   __entry->nargs = nargs;
+			   memcpy(__entry->args, mc->args, sizeof(unsigned long) * nargs);
+			   memset(__entry->args + nargs, 0, sizeof(unsigned long) * (6 - nargs));
+		    ),
+	    TP_printk("op %u%s args [%lx, %lx, %lx, %lx, %lx, %lx]",
+		      __entry->op, xen_hypercall_name(__entry->op),
+		      __entry->args[0], __entry->args[1], __entry->args[2],
+		      __entry->args[3], __entry->args[4], __entry->args[5])
+	);
+
+TRACE_EVENT(xen_mc_entry_alloc,
+	    TP_PROTO(size_t args),
+	    TP_ARGS(args),
+	    TP_STRUCT__entry(
+		    __field(size_t, args)
+		    ),
+	    TP_fast_assign(__entry->args = args),
+	    TP_printk("alloc entry %zu arg bytes", __entry->args)
+	);
+
+TRACE_EVENT(xen_mc_callback,
+	    TP_PROTO(xen_mc_callback_fn_t fn, void *data),
+	    TP_ARGS(fn, data),
+	    TP_STRUCT__entry(
+		    __field(xen_mc_callback_fn_t, fn)
+		    __field(void *, data)
+		    ),
+	    TP_fast_assign(
+		    __entry->fn = fn;
+		    __entry->data = data;
+		    ),
+	    TP_printk("callback %pf, data %p",
+		      __entry->fn, __entry->data)
+	);
+
+TRACE_EVENT(xen_mc_flush_reason,
+	    TP_PROTO(enum xen_mc_flush_reason reason),
+	    TP_ARGS(reason),
+	    TP_STRUCT__entry(
+		    __field(enum xen_mc_flush_reason, reason)
+		    ),
+	    TP_fast_assign(__entry->reason = reason),
+	    TP_printk("flush reason %s",
+		      (__entry->reason == XEN_MC_FL_NONE) ? "NONE" :
+		      (__entry->reason == XEN_MC_FL_BATCH) ? "BATCH" :
+		      (__entry->reason == XEN_MC_FL_ARGS) ? "ARGS" :
+		      (__entry->reason == XEN_MC_FL_CALLBACK) ? "CALLBACK" : "??")
+	);
+
+TRACE_EVENT(xen_mc_flush,
+	    TP_PROTO(unsigned mcidx, unsigned argidx, unsigned cbidx),
+	    TP_ARGS(mcidx, argidx, cbidx),
+	    TP_STRUCT__entry(
+		    __field(unsigned, mcidx)
+		    __field(unsigned, argidx)
+		    __field(unsigned, cbidx)
+		    ),
+	    TP_fast_assign(__entry->mcidx = mcidx;
+			   __entry->argidx = argidx;
+			   __entry->cbidx = cbidx),
+	    TP_printk("flushing %u hypercalls, %u arg bytes, %u callbacks",
+		      __entry->mcidx, __entry->argidx, __entry->cbidx)
+	);
+
+TRACE_EVENT(xen_mc_extend_args,
+	    TP_PROTO(unsigned long op, size_t args, enum xen_mc_extend_args res),
+	    TP_ARGS(op, args, res),
+	    TP_STRUCT__entry(
+		    __field(unsigned long, op)
+		    __field(size_t, args)
+		    __field(enum xen_mc_extend_args, res)
+		    ),
+	    TP_fast_assign(__entry->op = op;
+			   __entry->args = args;
+			   __entry->res = res),
+	    TP_printk("extending op %lu%s by %zu bytes res %s",
+		      __entry->op, xen_hypercall_name(__entry->op),
+		      __entry->args,
+		      __entry->res == XEN_MC_XE_OK ? "OK" :
+		      __entry->res == XEN_MC_XE_BAD_OP ? "BAD_OP" :
+		      __entry->res == XEN_MC_XE_NO_SPACE ? "NO_SPACE" : "???")
+	);
 #endif /*  _TRACE_XEN_H */
 
 /* This part must be outside protection */
-- 
1.7.5.4

