Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751874Ab1IERGi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Sep 2011 13:06:38 -0400
Received: from mx1.redhat.com ([209.132.183.28]:7819 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751542Ab1IERGc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Sep 2011 13:06:32 -0400
Subject: [PATCH 2/2] Add new PTRACE_O_TRACESTOP option, make it control new
 ptrace behavior.
From: Denys Vlasenko <dvlasenk@redhat.com>
To: Denys Vlasenko <vda.linux@googlemail.com>
Cc: Oleg Nesterov <oleg@redhat.com>, Tejun Heo <tj@kernel.org>,
        linux-kernel@vger.kernel.org
Date: Mon, 05 Sep 2011 19:06:22 +0200
References: <201109042311.18793.vda.linux@googlemail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Message-ID: <1315242384.1888.64.camel@dhcp-25-63.brq.redhat.com>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-09-05 at 18:51 +0200, Denys Vlasenko wrote:
> > A crude patch is below. It rolls points 1-4 from above into a single
> > new option, PTRACE_O_TRACESTOP.
> 
> For easier review, split it into two parts. Part 1 follows.
> (It is still not even compile-tested).

Part 2. (ignore untitled one sent a few mins ago)
-- 
vda


Add new PTRACE_O_TRACESTOP option, make it control new ptrace behavior.

Introduce new ptrace option, PTRACE_O_TRACESTOP. This makes API
more symmetric: every PTRACE_EVENT_event has corresponding PTRACE_O_TRACEevent now,
as it used to have before PTRACE_SEIZE was introduced.

PTRACE_SEIZE does not assume PTRACE_O_TRACESTOP, but with this patch
it allows any PTRACE_O_opts to be set at attach time (they are passed in data param)
- including PTRACE_O_TRACESTOP, of course. Without any options,
PTRACE_SEIZE is equivalent to PTRACE_ATTACH. With only PTRACE_O_TRACESTOP option,
PTRACE_SEIZE behavior will be the same as PTRACE_SEIZE behavior before this patch.

This opens up two new possibilities:
(1) Ptrace options can be set on attach. Can be used to close a few corner cases
in strace where we get unwanted behavior before we have a chance to set options,
and removes the need to track "did we set opts for this task" state in strace
internals.
(2) PTRACE_LISTEN, PTRACE_INTERRUPT commands and PTRACE_EVENT_STOP event
can be enabled with PTRACE_SETOPTIONS with PTRACE_O_TRACESTOP.
Not a big deal, but IMO this makes API more symmetric.

All formerly PTRACE_SEIZE-enabled behavior is now enabled by
PTRACE_O_TRACESTOP instead (by PT_TRACE_STOP bit). PT_SEIZED bit is removed.

Signed-off-by: Denys Vlasenko <dvlasenk@redhat.com>


diff --git a/include/linux/ptrace.h b/include/linux/ptrace.h
index 9aa669c..e2ba2dd 100644
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
@@ -85,7 +86,6 @@
  * flags.  When the a task is stopped the ptracer owns task->ptrace.
  */
 
-#define PT_SEIZED	0x00010000	/* SEIZE used, enable new behavior */
 #define PT_PTRACED	0x00000001
 #define PT_DTRACE	0x00000002	/* delayed trace (used on m68k, i386) */
 #define PT_PTRACE_CAP	0x00000004	/* ptracer can follow suid-exec */
@@ -100,6 +100,7 @@
 #define PT_TRACE_EXEC		PT_EVENT_FLAG(PTRACE_EVENT_EXEC)
 #define PT_TRACE_VFORK_DONE	PT_EVENT_FLAG(PTRACE_EVENT_VFORK_DONE)
 #define PT_TRACE_EXIT		PT_EVENT_FLAG(PTRACE_EVENT_EXIT)
+#define PT_TRACE_STOP		PT_EVENT_FLAG(PTRACE_EVENT_STOP)
 
 /* single stepping state bits (used on ARM and PA-RISC) */
 #define PT_SINGLESTEP_BIT	31
diff --git a/kernel/ptrace.c b/kernel/ptrace.c
index 9c3536d..0bf3d74 100644
--- a/kernel/ptrace.c
+++ b/kernel/ptrace.c
@@ -267,9 +267,7 @@ static int ptrace_attach(struct task_struct *task, long request,
 	if (task->ptrace)
 		goto unlock_tasklist;
 
-	task->ptrace = PT_PTRACED;
-	if (seize)
-		task->ptrace |= PT_SEIZED;
+	task->ptrace = PT_PTRACED | (flags << PT_OPT_FLAG_SHIFT);
 	if (task_ns_capable(task, CAP_SYS_PTRACE))
 		task->ptrace |= PT_PTRACE_CAP;
 
@@ -653,7 +651,7 @@ static int ptrace_regset(struct task_struct *task, int req, unsigned int type,
 int ptrace_request(struct task_struct *child, long request,
 		   unsigned long addr, unsigned long data)
 {
-	bool seized = child->ptrace & PT_SEIZED;
+	bool stop_events_enabled = child->ptrace & PT_TRACE_STOP;
 	int ret = -EIO;
 	siginfo_t siginfo, *si;
 	void __user *datavp = (void __user *) data;
@@ -702,7 +700,7 @@ int ptrace_request(struct task_struct *child, long request,
 		 * The actual trap might not be PTRACE_EVENT_STOP trap but
 		 * the pending condition is cleared regardless.
 		 */
-		if (unlikely(!seized || !lock_task_sighand(child, &flags)))
+		if (unlikely(!stop_events_enabled || !lock_task_sighand(child, &flags)))
 			break;
 
 		/*
@@ -727,7 +725,7 @@ int ptrace_request(struct task_struct *child, long request,
 		 * again.  Alternatively, ptracer can issue INTERRUPT to
 		 * finish listening and re-trap tracee into STOP.
 		 */
-		if (unlikely(!seized || !lock_task_sighand(child, &flags)))
+		if (unlikely(!stop_events_enabled || !lock_task_sighand(child, &flags)))
 			break;
 
 		si = child->last_siginfo;
diff --git a/kernel/signal.c b/kernel/signal.c
index 291c970..9248600 100644
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
- * SEIZE/INTERRUPT traps.  Both generate PTRACE_EVENT_STOP trap with
+ * When PT_TRACE_STOP is on, it's used for both group stop and explicit
+ * INTERRUPT traps.  Both generate PTRACE_EVENT_STOP trap with
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



