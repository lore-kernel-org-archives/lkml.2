Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932513Ab2JEMgY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2012 08:36:24 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:34813 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932479Ab2JEMgW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2012 08:36:22 -0400
Date: Fri, 5 Oct 2012 14:36:19 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Dave Jones <davej@redhat.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org
Subject: Re: RCU_USER_QS traces.
Message-ID: <20121005123609.GA13172@somewhere>
References: <20121004144106.GB11191@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121004144106.GB11191@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 04, 2012 at 10:41:06AM -0400, Dave Jones wrote:
>  > We have CONFIG_RCU_USER_QS that is a specific case. It's an intermediate state
>  > before we implement a true CONFIG_NO_HZ_FULL. But the option is useless on its
>  > own for users. Worse, it introduces a real overhead. OTOH we want it to be upstream
>  > to make the development of full tickless feature more incremental.
> 
> I couldn't resist trying it.. Did these get reported yet ?

Hi Dave,

Thanks for this report. I need to find the source of the issue.

If you don't mind, could you please apply the following patch? You'll also
need to enable:

- CONFIG_EVENT_TRACING and CONFIG_RCU_TRACE

And you also need this boot parameter:

- trace_event=rcu_dyntick

Thanks a lot!

---
>From 824f2ef855597d6dd263bb363727e4585db88ca3 Mon Sep 17 00:00:00 2001
From: Frederic Weisbecker <fweisbec@gmail.com>
Date: Thu, 4 Oct 2012 17:30:36 +0200
Subject: [PATCH] rcu: Dump rcu traces and stacktraces on dynticks warnings

Temp patch for debugging.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 kernel/rcutree.c |   38 ++++++++++++++++++++++++--------------
 1 files changed, 24 insertions(+), 14 deletions(-)

diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index 4fb2376..1bc96fd 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -59,6 +59,12 @@
 
 #include "rcu.h"
 
+#define trace_rcu_dyntick_stacktrace(...) {	\
+	trace_rcu_dyntick(__VA_ARGS__);	   \
+	trace_dump_stack();\
+}
+
+
 /* Data structures. */
 
 static struct lock_class_key rcu_node_class[RCU_NUM_LVLS];
@@ -334,11 +340,11 @@ static struct rcu_node *rcu_get_root(struct rcu_state *rsp)
 static void rcu_eqs_enter_common(struct rcu_dynticks *rdtp, long long oldval,
 				bool user)
 {
-	trace_rcu_dyntick("Start", oldval, 0);
+	trace_rcu_dyntick_stacktrace("Start", oldval, 0);
 	if (!user && !is_idle_task(current)) {
 		struct task_struct *idle = idle_task(smp_processor_id());
 
-		trace_rcu_dyntick("Error on entry: not idle task", oldval, 0);
+		trace_rcu_dyntick_stacktrace("Error on entry: not idle task", oldval, 0);
 		ftrace_dump(DUMP_ORIG);
 		WARN_ONCE(1, "Current pid: %d comm: %s / Idle pid: %d comm: %s",
 			  current->pid, current->comm,
@@ -349,7 +355,8 @@ static void rcu_eqs_enter_common(struct rcu_dynticks *rdtp, long long oldval,
 	smp_mb__before_atomic_inc();  /* See above. */
 	atomic_inc(&rdtp->dynticks);
 	smp_mb__after_atomic_inc();  /* Force ordering with next sojourn. */
-	WARN_ON_ONCE(atomic_read(&rdtp->dynticks) & 0x1);
+	if (WARN_ON_ONCE(atomic_read(&rdtp->dynticks) & 0x1))
+		ftrace_dump(DUMP_ORIG);
 
 	/*
 	 * It is illegal to enter an extended quiescent state while
@@ -374,7 +381,8 @@ static void rcu_eqs_enter(bool user)
 
 	rdtp = &__get_cpu_var(rcu_dynticks);
 	oldval = rdtp->dynticks_nesting;
-	WARN_ON_ONCE((oldval & DYNTICK_TASK_NEST_MASK) == 0);
+	if (WARN_ON_ONCE((oldval & DYNTICK_TASK_NEST_MASK) == 0))
+		ftrace_dump(DUMP_ORIG);
 	if ((oldval & DYNTICK_TASK_NEST_MASK) == DYNTICK_TASK_NEST_VALUE)
 		rdtp->dynticks_nesting = 0;
 	else
@@ -489,9 +497,9 @@ void rcu_irq_exit(void)
 	oldval = rdtp->dynticks_nesting;
 	rdtp->dynticks_nesting--;
 	WARN_ON_ONCE(rdtp->dynticks_nesting < 0);
-	if (rdtp->dynticks_nesting)
-		trace_rcu_dyntick("--=", oldval, rdtp->dynticks_nesting);
-	else
+	if (rdtp->dynticks_nesting) {
+		trace_rcu_dyntick_stacktrace("--=", oldval, rdtp->dynticks_nesting);
+	} else
 		rcu_eqs_enter_common(rdtp, oldval, true);
 	local_irq_restore(flags);
 }
@@ -510,13 +518,14 @@ static void rcu_eqs_exit_common(struct rcu_dynticks *rdtp, long long oldval,
 	atomic_inc(&rdtp->dynticks);
 	/* CPUs seeing atomic_inc() must see later RCU read-side crit sects */
 	smp_mb__after_atomic_inc();  /* See above. */
-	WARN_ON_ONCE(!(atomic_read(&rdtp->dynticks) & 0x1));
+	if (WARN_ON_ONCE(!(atomic_read(&rdtp->dynticks) & 0x1)))
+		ftrace_dump(DUMP_ORIG);
 	rcu_cleanup_after_idle(smp_processor_id());
-	trace_rcu_dyntick("End", oldval, rdtp->dynticks_nesting);
+	trace_rcu_dyntick_stacktrace("End", oldval, rdtp->dynticks_nesting);
 	if (!user && !is_idle_task(current)) {
 		struct task_struct *idle = idle_task(smp_processor_id());
 
-		trace_rcu_dyntick("Error on exit: not idle task",
+		trace_rcu_dyntick_stacktrace("Error on exit: not idle task",
 				  oldval, rdtp->dynticks_nesting);
 		ftrace_dump(DUMP_ORIG);
 		WARN_ONCE(1, "Current pid: %d comm: %s / Idle pid: %d comm: %s",
@@ -536,7 +545,8 @@ static void rcu_eqs_exit(bool user)
 
 	rdtp = &__get_cpu_var(rcu_dynticks);
 	oldval = rdtp->dynticks_nesting;
-	WARN_ON_ONCE(oldval < 0);
+	if (WARN_ON_ONCE(oldval < 0))
+		ftrace_dump(DUMP_ORIG);
 	if (oldval & DYNTICK_TASK_NEST_MASK)
 		rdtp->dynticks_nesting += DYNTICK_TASK_NEST_VALUE;
 	else
@@ -650,9 +660,9 @@ void rcu_irq_enter(void)
 	oldval = rdtp->dynticks_nesting;
 	rdtp->dynticks_nesting++;
 	WARN_ON_ONCE(rdtp->dynticks_nesting == 0);
-	if (oldval)
-		trace_rcu_dyntick("++=", oldval, rdtp->dynticks_nesting);
-	else
+	if (oldval) {
+		trace_rcu_dyntick_stacktrace("++=", oldval, rdtp->dynticks_nesting);
+	} else
 		rcu_eqs_exit_common(rdtp, oldval, true);
 	local_irq_restore(flags);
 }
-- 
1.7.1

