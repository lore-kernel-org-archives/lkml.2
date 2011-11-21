Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754944Ab1KUTYI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Nov 2011 14:24:08 -0500
Received: from mx1.redhat.com ([209.132.183.28]:64444 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752599Ab1KUTYG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Nov 2011 14:24:06 -0500
Date: Mon, 21 Nov 2011 20:19:20 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@redhat.com>,
        Jiri Olsa <jolsa@redhat.com>, Masami Hiramatsu <mhiramat@redhat.com>,
        Seiji Aguchi <saguchi@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org
Subject: Q: tracing: can we change trace_signal_generate() signature?
Message-ID: <20111121191920.GA24883@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Is it possible to change trace_signal_generate()'s args or this
is the part of the kernel ABI?

We have the "feature request". The customer wants to know was the
signal delivered or not, and why. We could add another trace_()
into __send_signal() but this looks ugly to me.

So. Can't we add

	enum {
		TRACE_SIGNAL_DELIVERED,
		TRACE_SIGNAL_IGNORED_OR_BLOCKED,
		TRACE_SIGNAL_ALREADY_PENDING,
	}

and move trace_signal_generate() to the end of __send_signal()
with the additional argument(s) to avoid the new tracepoint?

If yes, then can't we also kill trace_signal_overflow_fail()
and trace_signal_lose_info()? We can simply add more
TRACE_SIGNAL_'s instead, this certainly looks better imho.

IOW. Ignoring the changes in include/trace/events/signal.h,
can the patch below work or the changes like this are not
allowed?

See also https://bugzilla.redhat.com/show_bug.cgi?id=738720

Thanks,

Oleg.


--- x/kernel/signal.c
+++ x/kernel/signal.c
@@ -1019,19 +1019,27 @@ static inline int legacy_queue(struct sigpending *signals, int sig)
 	return (sig < SIGRTMIN) && sigismember(&signals->signal, sig);
 }
 
+enum {
+	TRACE_SIGNAL_DELIVERED,
+	TRACE_SIGNAL_IGNORED_OR_BLOCKED,
+	TRACE_SIGNAL_ALREADY_PENDING,
+	TRACE_SIGNAL_OVERFLOW_FAIL,
+	TRACE_SIGNAL_LOSE_INFO,
+};
+
 static int __send_signal(int sig, struct siginfo *info, struct task_struct *t,
 			int group, int from_ancestor_ns)
 {
 	struct sigpending *pending;
 	struct sigqueue *q;
 	int override_rlimit;
-
-	trace_signal_generate(sig, info, t);
+	int ret = 0, result;
 
 	assert_spin_locked(&t->sighand->siglock);
 
+	result = TRACE_SIGNAL_IGNORED_OR_BLOCKED;
 	if (!prepare_signal(sig, t, from_ancestor_ns))
-		return 0;
+		goto ret;
 
 	pending = group ? &t->signal->shared_pending : &t->pending;
 	/*
@@ -1039,8 +1047,11 @@ static int __send_signal(int sig, struct siginfo *info, struct task_struct *t,
 	 * exactly one non-rt signal, so that we can get more
 	 * detailed information about the cause of the signal.
 	 */
+	result = TRACE_SIGNAL_ALREADY_PENDING;
 	if (legacy_queue(pending, sig))
-		return 0;
+		goto ret;
+
+	result = TRACE_SIGNAL_DELIVERED;
 	/*
 	 * fast-pathed signals for kernel-internal things like SIGSTOP
 	 * or SIGKILL.
@@ -1095,14 +1106,15 @@ static int __send_signal(int sig, struct siginfo *info, struct task_struct *t,
 			 * signal was rt and sent by user using something
 			 * other than kill().
 			 */
-			trace_signal_overflow_fail(sig, group, info);
-			return -EAGAIN;
+			result = TRACE_SIGNAL_OVERFLOW_FAIL;
+			ret = -EAGAIN;
+			goto ret;
 		} else {
 			/*
 			 * This is a silent loss of information.  We still
 			 * send the signal, but the *info bits are lost.
 			 */
-			trace_signal_lose_info(sig, group, info);
+			result = TRACE_SIGNAL_LOSE_INFO;
 		}
 	}
 
@@ -1110,7 +1122,9 @@ out_set:
 	signalfd_notify(t, sig);
 	sigaddset(&pending->signal, sig);
 	complete_signal(sig, t, group);
-	return 0;
+ret:
+	trace_signal_generate(sig, info, t, group, result);
+	return ret;
 }
 
 static int send_signal(int sig, struct siginfo *info, struct task_struct *t,

