Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754084Ab1ASUFr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jan 2011 15:05:47 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:60319 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752671Ab1ASUFq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jan 2011 15:05:46 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=RFz/OxlnOBx/bAlOdzYJh3YR+kV34ovcYph4V/cHK7/8cwCRTuwaQZLSBIcK6/7KKk
         PXD88vYWCd7Z2iVMSbbZ7/iABjVx+/6f8eVcDEhe4L815x/k8h3zPdjqtm9w++Pui4Dt
         LaabIjFwJOUOn983/n+Omsha9DdGyqjH4ig7o=
Date: Wed, 19 Jan 2011 21:05:40 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Alan Stern <stern@rowland.harvard.edu>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Ingo Molnar <mingo@elte.hu>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Prasad <prasad@linux.vnet.ibm.com>, Roland McGrath <roland@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: Re: Q: perf_event && task->ptrace_bps[]
Message-ID: <20110119200536.GC1772@nowhere>
References: <20101108145647.GA3426@redhat.com>
 <20110117203459.GA32700@redhat.com>
 <20110118184234.GA1808@nowhere>
 <20110119153746.GA32563@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110119153746.GA32563@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 19, 2011 at 04:37:46PM +0100, Oleg Nesterov wrote:
> On 01/18, Frederic Weisbecker wrote:
> > > Probably the best fix is to change this code so that the tracer owns
> > > ->ptrace_bps[], not the tracee. But this is not trivial, and needs a
> > > lot of changes in ptrace code.
> >
> > How much complicated would it be?
> 
> The problem is, ptrace_detach/release_task can't sleep currently.
> The necessary changes are nasty.

Ok, let's forget that then :)
 
> > Because I see three solutions to solve this:
> >
> > - Have a mutex inside thread->ptrace_bps. The contention must be
> > rare and only concern ptrace and tracee exit. That's the simplest.
> 
> I think we can reuse perf_event_mutex for this. Not very good too,
> but simple. But this depends on what can we do under this mutex...

That could work. I feel a bit uncomfortable to use a perf related
mutex for that though. I can't figure out any deadlock with the current
state, but if we are going to use that solution, perf events will be
created/destroyed/disabled/enabled under that mutex. May be that large
coverage might create some dependency problems in the future. I don't
know...

Dunno, that doesn't seem to be a good use of perf_event_mutex.

I had another idea based on a refcount. Can you have a look?
The drawback is to add an entry in task_struct. OTOH I can drop
more of them for the no-running-breakpoint case from thread_struct
in a subsequent task.

Note the problem touches more archs than x86. Basically every
arch that use breakpoint use a similar scheme that must be fixed.

(only compile tested yet)

diff --git a/arch/x86/kernel/ptrace.c b/arch/x86/kernel/ptrace.c
index 45892dc..08d79f9 100644
--- a/arch/x86/kernel/ptrace.c
+++ b/arch/x86/kernel/ptrace.c
@@ -608,6 +608,9 @@ static int ptrace_write_dr7(struct task_struct *tsk, unsigned long data)
 	unsigned len, type;
 	struct perf_event *bp;
 
+	if (ptrace_get_breakpoints(tsk) < 0)
+		return -ESRCH;
+
 	data &= ~DR_CONTROL_RESERVED;
 	old_dr7 = ptrace_get_dr7(thread->ptrace_bps);
 restore:
@@ -655,6 +658,9 @@ restore:
 		}
 		goto restore;
 	}
+
+	ptrace_put_breakpoints(tsk);
+
 	return ((orig_ret < 0) ? orig_ret : rc);
 }
 
@@ -668,10 +674,17 @@ static unsigned long ptrace_get_debugreg(struct task_struct *tsk, int n)
 
 	if (n < HBP_NUM) {
 		struct perf_event *bp;
+
+		if (ptrace_get_breakpoints(tsk) < 0)
+			return -ESRCH;
+
 		bp = thread->ptrace_bps[n];
 		if (!bp)
-			return 0;
-		val = bp->hw.info.address;
+			val = 0;
+		else
+			val = bp->hw.info.address;
+
+		ptrace_put_breakpoints(tsk);
 	} else if (n == 6) {
 		val = thread->debugreg6;
 	 } else if (n == 7) {
@@ -686,6 +699,10 @@ static int ptrace_set_breakpoint_addr(struct task_struct *tsk, int nr,
 	struct perf_event *bp;
 	struct thread_struct *t = &tsk->thread;
 	struct perf_event_attr attr;
+	int err = 0;
+
+	if (ptrace_get_breakpoints(tsk) < 0)
+		return -ESRCH;
 
 	if (!t->ptrace_bps[nr]) {
 		ptrace_breakpoint_init(&attr);
@@ -709,24 +726,23 @@ static int ptrace_set_breakpoint_addr(struct task_struct *tsk, int nr,
 		 * writing for the user. And anyway this is the previous
 		 * behaviour.
 		 */
-		if (IS_ERR(bp))
-			return PTR_ERR(bp);
+		if (IS_ERR(bp)) {
+			err = PTR_ERR(bp);
+			goto put;
+		}
 
 		t->ptrace_bps[nr] = bp;
 	} else {
-		int err;
-
 		bp = t->ptrace_bps[nr];
 
 		attr = bp->attr;
 		attr.bp_addr = addr;
 		err = modify_user_hw_breakpoint(bp, &attr);
-		if (err)
-			return err;
 	}
 
-
-	return 0;
+put:
+	ptrace_put_breakpoints(tsk);
+	return err;
 }
 
 /*
diff --git a/include/linux/ptrace.h b/include/linux/ptrace.h
index 092a04f..519f03c 100644
--- a/include/linux/ptrace.h
+++ b/include/linux/ptrace.h
@@ -192,6 +192,9 @@ static inline void ptrace_init_task(struct task_struct *child, bool ptrace)
 		child->ptrace = current->ptrace;
 		__ptrace_link(child, current->parent);
 	}
+#ifdef CONFIG_HAVE_HW_BREAKPOINT
+	atomic_set(&child->ptrace_bp_refcnt, 1);
+#endif
 }
 
 /**
@@ -352,7 +355,12 @@ static inline void user_single_step_siginfo(struct task_struct *tsk,
 extern int task_current_syscall(struct task_struct *target, long *callno,
 				unsigned long args[6], unsigned int maxargs,
 				unsigned long *sp, unsigned long *pc);
-
-#endif
+#ifdef CONFIG_HAVE_HW_BREAKPOINT
+extern int ptrace_get_breakpoints(struct task_struct *tsk);
+extern void ptrace_put_breakpoints(struct task_struct *tsk);
+#else
+static inline void ptrace_put_breakpoints(struct task_struct *tsk) { }
+#endif /* CONFIG_HAVE_HW_BREAKPOINT */
+#endif /* __KERNEL */
 
 #endif
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 777cd01..523a1c5 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1526,6 +1526,9 @@ struct task_struct {
 		unsigned long memsw_bytes; /* uncharged mem+swap usage */
 	} memcg_batch;
 #endif
+#ifdef CONFIG_HAVE_HW_BREAKPOINT
+	atomic_t ptrace_bp_refcnt;
+#endif
 };
 
 /* Future-safe accessor for struct task_struct's cpus_allowed. */
diff --git a/kernel/exit.c b/kernel/exit.c
index 8cb8904..5284464 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -1015,7 +1015,7 @@ NORET_TYPE void do_exit(long code)
 	/*
 	 * FIXME: do that only when needed, using sched_exit tracepoint
 	 */
-	flush_ptrace_hw_breakpoint(tsk);
+	ptrace_put_breakpoints(tsk);
 
 	exit_notify(tsk, group_dead);
 #ifdef CONFIG_NUMA
diff --git a/kernel/ptrace.c b/kernel/ptrace.c
index 99bbaa3..23394f1 100644
--- a/kernel/ptrace.c
+++ b/kernel/ptrace.c
@@ -22,6 +22,7 @@
 #include <linux/syscalls.h>
 #include <linux/uaccess.h>
 #include <linux/regset.h>
+#include <linux/hw_breakpoint.h>
 
 
 /*
@@ -876,3 +877,19 @@ asmlinkage long compat_sys_ptrace(compat_long_t request, compat_long_t pid,
 	return ret;
 }
 #endif	/* CONFIG_COMPAT */
+
+#ifdef CONFIG_HAVE_HW_BREAKPOINT
+int ptrace_get_breakpoints(struct task_struct *tsk)
+{
+	if (atomic_inc_not_zero(&tsk->ptrace_bp_refcnt))
+		return 0;
+
+	return -1;
+}
+
+void ptrace_put_breakpoints(struct task_struct *tsk)
+{
+	if (!atomic_dec_return(&tsk->ptrace_bp_refcnt))
+		flush_ptrace_hw_breakpoint(tsk);
+}
+#endif /* CONFIG_HAVE_HW_BREAKPOINT */
