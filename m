Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754342Ab1IEOym (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Sep 2011 10:54:42 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57314 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752835Ab1IEOyk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Sep 2011 10:54:40 -0400
Subject: Re: RFC: PTRACE_SEIZE needs API cleanup?
From: Denys Vlasenko <dvlasenk@redhat.com>
To: Denys Vlasenko <vda.linux@googlemail.com>
Cc: Oleg Nesterov <oleg@redhat.com>, Tejun Heo <tj@kernel.org>,
        linux-kernel@vger.kernel.org
Date: Mon, 05 Sep 2011 16:54:29 +0200
In-Reply-To: <201109042311.18793.vda.linux@googlemail.com>
References: <201109042311.18793.vda.linux@googlemail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Message-ID: <1315234472.1888.44.camel@dhcp-25-63.brq.redhat.com>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2011-09-04 at 23:11 +0200, Denys Vlasenko wrote:
> Hi guys,
> 
> I added code to use PTRACE_SEIZE in strace and in the process
> had tasted how API looks like from userspace POV.
> 
> It is usable, but API feels somewhat quirky.
> 
> Consider the following: one of reasons why we added PTRACE_SEIZE
> is that existing ptrace API has unnecessary complications
> (quirks) such as SIGSTOP on attach, SIGTRAP after execve.
> 
> But whoever designed strace did not deliberately designed these quirks in,
> he thought it was a good, reasonable design. Only after a second, third,
> tenth look it became obvious in retrospect that some things are
> not exactly right.
> 
> Thankfully, quirks in new PTRACE_SEIZE code mostly have the nature of
> "unnecessarily invented entities" as opposed to problems
> in trying to use API in real world tasks, but I still think they are
> annoying enough to be looked at.
> 
> 
> We already have a mechanism how to modify ptrace behavior: ptrace options.
> But now we introduce a different mechnism to do the same: by using SEIZE
> instead of ATTACH, we magically change some aspects of ptrace.
> In effect, SEIZE sets some options. And these "SEIZE options" can't be
> set or cleared by SETOPTIONS. This is stupid. Why can't we just add
> more options instead of inventing new entities? Why we overloaded
> SEIZE with two functions: "attach to, but don't SIGSTOP the tracee"
> and "change behaviour of ptrace on this tracee"?
> 
> If the argument is that we want to set options immediately at attach,
> then I completely agree: yes, we do! Moreover, we want to set some
> _ordinary_ options too, such as PTRACE_O_TRACEEXEC, and we can't
> do that even now, in improved API! It needs more improving.
> 
> So my proposal is:
> (a) make SEIZE take a parameter "immediately set these options on attach"
> (b) without any options, make SEIZE just do "ATTACH sans SIGSTOP" thing,
>     nothing more.
> (c) make the following new PTRACE_O_foo options:
>    (1) "flag stops with PTRACE_EVENT_STOP event value in waitpid status"
>    (2) "enable PTRACE_INTERRUPT. It either causes PTRACE_EVENT_STOP with sig=SIGTRAP
>         if (1) is enabled, or creates a group-stop with sig=SIGTRAP otherwise"
>        [if the second part is too weird to implement, make (2) require (1)]
>    (3) "enable PTRACE_LISTEN. Works on group-stops even without any other options"
>    (4) "make auto-attached children stop a-la INTERRUPT, not with SIGSTOP"
>    (5) "enable saner error codes"


A crude patch is below. It rolls points 1-4 from above into a single
new option, PTRACE_O_TRACESTOP.

PTRACE_SEIZE does not assume PTRACE_O_TRACESTOP, but it allows all
PTRACE_O_opts to be set at attach time (they are passed in data param) -
including PTRACE_O_TRACESTOP, of course.

All formerly PTRACE_SEIZE-enabled behavior is now enabled by
PTRACE_O_TRACESTOP instead. PT_SEIZED bit is removed.

While at it, I cleaned up the following:

Exchanged PT_TRACESYSGOOD and PT_PTRACE_CAP bit positions, which made
PT_option bits contiguous and therefore made ptrace_setoptions much
simpler.

If ptrace_setoptions fails, options are not affected.

PT_EVENT_FLAG_SHIFT was not particularly useful, PT_OPT_FLAG_SHIFT with
value of PT_EVENT_FLAG_SHIFT-1 is better.

PT_TRACE_MASK constant is nuked, the only its use is replaced by
(PTRACE_O_MASK << PT_OPT_FLAG_SHIFT).

Not compile tested.

-- 
vda



diff --git a/include/linux/ptrace.h b/include/linux/ptrace.h
index 800f113..e2ba2dd 100644
--- a/include/linux/ptrace.h
+++ b/include/linux/ptrace.h
@@ -62,8 +62,9 @@
 #define PTRACE_O_TRACEEXEC	0x00000010
 #define PTRACE_O_TRACEVFORKDONE	0x00000020
 #define PTRACE_O_TRACEEXIT	0x00000040
+#define PTRACE_O_TRACESTOP	0x00000080
 
-#define PTRACE_O_MASK		0x0000007f
+#define PTRACE_O_MASK		0x000000ff
 
 /* Wait extended result codes for the above trace options.  */
 #define PTRACE_EVENT_FORK	1
@@ -85,24 +86,21 @@
  * flags.  When the a task is stopped the ptracer owns task->ptrace.
  */
 
-#define PT_SEIZED	0x00010000	/* SEIZE used, enable new behavior */
 #define PT_PTRACED	0x00000001
 #define PT_DTRACE	0x00000002	/* delayed trace (used on m68k, i386) */
-#define PT_TRACESYSGOOD	0x00000004
-#define PT_PTRACE_CAP	0x00000008	/* ptracer can follow suid-exec */
+#define PT_PTRACE_CAP	0x00000004	/* ptracer can follow suid-exec */
 
+#define PT_OPT_FLAG_SHIFT	3
+#define PT_TRACESYSGOOD	0x00000008	/* must be directly before PT_TRACE_event bits! */
 /* PT_TRACE_* event enable flags */
-#define PT_EVENT_FLAG_SHIFT	4
-#define PT_EVENT_FLAG(event)	(1 << (PT_EVENT_FLAG_SHIFT + (event) - 1))
-
+#define PT_EVENT_FLAG(event)	(1 << (PT_OPT_FLAG_SHIFT + (event)))
 #define PT_TRACE_FORK		PT_EVENT_FLAG(PTRACE_EVENT_FORK)
 #define PT_TRACE_VFORK		PT_EVENT_FLAG(PTRACE_EVENT_VFORK)
 #define PT_TRACE_CLONE		PT_EVENT_FLAG(PTRACE_EVENT_CLONE)
 #define PT_TRACE_EXEC		PT_EVENT_FLAG(PTRACE_EVENT_EXEC)
 #define PT_TRACE_VFORK_DONE	PT_EVENT_FLAG(PTRACE_EVENT_VFORK_DONE)
 #define PT_TRACE_EXIT		PT_EVENT_FLAG(PTRACE_EVENT_EXIT)
-
-#define PT_TRACE_MASK	0x000003f4
+#define PT_TRACE_STOP		PT_EVENT_FLAG(PTRACE_EVENT_STOP)
 
 /* single stepping state bits (used on ARM and PA-RISC) */
 #define PT_SINGLESTEP_BIT	31
@@ -228,7 +226,7 @@ static inline void ptrace_init_task(struct task_struct *child, bool ptrace)
 		child->ptrace = current->ptrace;
 		__ptrace_link(child, current->parent);
 
-		if (child->ptrace & PT_SEIZED)
+		if (child->ptrace & PTRACE_EVENT_STOP)
 			task_set_jobctl_pending(child, JOBCTL_TRAP_STOP);
 		else
 			sigaddset(&child->pending.signal, SIGSTOP);
diff --git a/kernel/ptrace.c b/kernel/ptrace.c
index 9de3ecf..0841969 100644
--- a/kernel/ptrace.c
+++ b/kernel/ptrace.c
@@ -219,19 +219,23 @@ static int ptrace_attach(struct task_struct *task, long request,
 
 	/*
 	 * SEIZE will enable new ptrace behaviors which will be implemented
-	 * gradually.  SEIZE_DEVEL is used to prevent applications
+	 * gradually.  SEIZE_DEVEL bit is used to prevent applications
 	 * expecting full SEIZE behaviors trapping on kernel commits which
 	 * are still in the process of implementing them.
 	 *
 	 * Only test programs for new ptrace behaviors being implemented
 	 * should set SEIZE_DEVEL.  If unset, SEIZE will fail with -EIO.
 	 *
-	 * Once SEIZE behaviors are completely implemented, this flag and
-	 * the following test will be removed.
+	 * Once SEIZE behaviors are completely implemented, this flag
+	 * will be removed.
 	 */
 	retval = -EIO;
-	if (seize && !(flags & PTRACE_SEIZE_DEVEL))
-		goto out;
+	if (seize) {
+		if ((flags & ~(long)PTRACE_O_MASK) != PTRACE_SEIZE_DEVEL)
+			goto out;
+		flags &= ~PTRACE_SEIZE_DEVEL;
+	} else
+		flags = 0;
 
 	audit_ptrace(task);
 
@@ -263,9 +267,7 @@ static int ptrace_attach(struct task_struct *task, long request,
 	if (task->ptrace)
 		goto unlock_tasklist;
 
-	task->ptrace = PT_PTRACED;
-	if (seize)
-		task->ptrace |= PT_SEIZED;
+	task->ptrace = PT_PTRACED | (flags << PT_OPT_FLAG_SHIFT);
 	if (task_ns_capable(task, CAP_SYS_PTRACE))
 		task->ptrace |= PT_PTRACE_CAP;
 
@@ -509,30 +511,13 @@ int ptrace_writedata(struct task_struct *tsk, char __user *src, unsigned long ds
 
 static int ptrace_setoptions(struct task_struct *child, unsigned long data)
 {
-	child->ptrace &= ~PT_TRACE_MASK;
-
-	if (data & PTRACE_O_TRACESYSGOOD)
-		child->ptrace |= PT_TRACESYSGOOD;
-
-	if (data & PTRACE_O_TRACEFORK)
-		child->ptrace |= PT_TRACE_FORK;
-
-	if (data & PTRACE_O_TRACEVFORK)
-		child->ptrace |= PT_TRACE_VFORK;
-
-	if (data & PTRACE_O_TRACECLONE)
-		child->ptrace |= PT_TRACE_CLONE;
-
-	if (data & PTRACE_O_TRACEEXEC)
-		child->ptrace |= PT_TRACE_EXEC;
-
-	if (data & PTRACE_O_TRACEVFORKDONE)
-		child->ptrace |= PT_TRACE_VFORK_DONE;
+	if (data & ~(long)PTRACE_O_MASK)
+		return -EINVAL;
 
-	if (data & PTRACE_O_TRACEEXIT)
-		child->ptrace |= PT_TRACE_EXIT;
+	child->ptrace &= ~(PTRACE_O_MASK << PT_OPT_FLAG_SHIFT);
+	child->ptrace |= (data << PT_OPT_FLAG_SHIFT);
 
-	return (data & ~PTRACE_O_MASK) ? -EINVAL : 0;
+	return 0;
 }
 
 static int ptrace_getsiginfo(struct task_struct *child, siginfo_t *info)
@@ -666,7 +651,7 @@ static int ptrace_regset(struct task_struct *task, int req, unsigned int type,
 int ptrace_request(struct task_struct *child, long request,
 		   unsigned long addr, unsigned long data)
 {
-	bool seized = child->ptrace & PT_SEIZED;
+	bool stop_events_enabled = child->ptrace & PT_TRACE_STOP;
 	int ret = -EIO;
 	siginfo_t siginfo, *si;
 	void __user *datavp = (void __user *) data;
@@ -715,7 +700,7 @@ int ptrace_request(struct task_struct *child, long request,
 		 * The actual trap might not be PTRACE_EVENT_STOP trap but
 		 * the pending condition is cleared regardless.
 		 */
-		if (unlikely(!seized || !lock_task_sighand(child, &flags)))
+		if (unlikely(!stop_events_enabled || !lock_task_sighand(child, &flags)))
 			break;
 
 		/*
@@ -740,7 +725,7 @@ int ptrace_request(struct task_struct *child, long request,
 		 * again.  Alternatively, ptracer can issue INTERRUPT to
 		 * finish listening and re-trap tracee into STOP.
 		 */
-		if (unlikely(!seized || !lock_task_sighand(child, &flags)))
+		if (unlikely(!stop_events_enabled || !lock_task_sighand(child, &flags)))
 			break;
 
 		si = child->last_siginfo;
diff --git a/kernel/signal.c b/kernel/signal.c
index 291c970..11bae20 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -823,8 +823,8 @@ static int check_kill_permission(int sig, struct siginfo *info,
  * @t: tracee wanting to notify tracer
  *
  * This function schedules sticky ptrace trap which is cleared on the next
- * TRAP_STOP to notify ptracer of an event.  @t must have been seized by
- * ptracer.
+ * TRAP_STOP to notify ptracer of an event.  @t must have PTRACE_O_TRACESTOP
+ * option active.
  *
  * If @t is running, STOP trap will be taken.  If trapped for STOP and
  * ptracer is listening for events, tracee is woken up so that it can
@@ -837,7 +837,7 @@ static int check_kill_permission(int sig, struct siginfo *info,
  */
 static void ptrace_trap_notify(struct task_struct *t)
 {
-	WARN_ON_ONCE(!(t->ptrace & PT_SEIZED));
+	WARN_ON_ONCE(!(t->ptrace & PT_TRACE_STOP));
 	assert_spin_locked(&t->sighand->siglock);
 
 	task_set_jobctl_pending(t, JOBCTL_TRAP_NOTIFY);
@@ -882,7 +882,7 @@ static int prepare_signal(int sig, struct task_struct *p, int from_ancestor_ns)
 		do {
 			task_clear_jobctl_pending(t, JOBCTL_STOP_PENDING);
 			rm_from_queue(SIG_KERNEL_STOP_MASK, &t->pending);
-			if (likely(!(t->ptrace & PT_SEIZED)))
+			if (likely(!(t->ptrace & PT_TRACE_STOP)))
 				wake_up_state(t, __TASK_STOPPED);
 			else
 				ptrace_trap_notify(t);
@@ -2004,7 +2004,7 @@ static bool do_signal_stop(int signr)
 			if (!task_is_stopped(t) &&
 			    task_set_jobctl_pending(t, signr | gstop)) {
 				sig->group_stop_count++;
-				if (likely(!(t->ptrace & PT_SEIZED)))
+				if (likely(!(t->ptrace & PT_TRACE_STOP)))
 					signal_wake_up(t, 0);
 				else
 					ptrace_trap_notify(t);
@@ -2057,13 +2057,13 @@ static bool do_signal_stop(int signr)
 /**
  * do_jobctl_trap - take care of ptrace jobctl traps
  *
- * When PT_SEIZED, it's used for both group stop and explicit
+ * When PT_TRACE_STOP is on, it's used for both group stop and explicit
  * SEIZE/INTERRUPT traps.  Both generate PTRACE_EVENT_STOP trap with
  * accompanying siginfo.  If stopped, lower eight bits of exit_code contain
  * the stop signal; otherwise, %SIGTRAP.
  *
- * When !PT_SEIZED, it's used only for group stop trap with stop signal
- * number as exit_code and no siginfo.
+ * When PT_TRACE_STOP is off, it's used only for group stop trap
+ * with stop signal number as exit_code and no siginfo.
  *
  * CONTEXT:
  * Must be called with @current->sighand->siglock held, which may be
@@ -2074,7 +2074,7 @@ static void do_jobctl_trap(void)
 	struct signal_struct *signal = current->signal;
 	int signr = current->jobctl & JOBCTL_STOP_SIGMASK;
 
-	if (current->ptrace & PT_SEIZED) {
+	if (current->ptrace & PT_TRACE_STOP) {
 		if (!signal->group_stop_count &&
 		    !(signal->flags & SIGNAL_STOP_STOPPED))
 			signr = SIGTRAP;

