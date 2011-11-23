Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755488Ab1KWRmX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Nov 2011 12:42:23 -0500
Received: from mx1.redhat.com ([209.132.183.28]:27004 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755332Ab1KWRmV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Nov 2011 12:42:21 -0500
Date: Wed, 23 Nov 2011 18:37:26 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, Jiri Olsa <jolsa@redhat.com>,
        Masami Hiramatsu <mhiramat@redhat.com>,
        Seiji Aguchi <saguchi@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] tracing: let trace_signal_generate() report more
	info, kill overflow_fail/lose_info
Message-ID: <20111123173726.GA25450@redhat.com>
References: <20111121191920.GA24883@redhat.com> <1321905799.20742.20.camel@frodo> <20111121202110.GA27966@redhat.com> <1321912356.20742.24.camel@frodo> <20111122205239.GA20971@redhat.com> <20111122205258.GB20971@redhat.com> <4ECC4FDC.1010506@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4ECC4FDC.1010506@cn.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/23, Li Zefan wrote:
>
> >  /**
> >   * signal_generate - called when a signal is generated
> >   * @sig: signal number
> >   * @info: pointer to struct siginfo
> >   * @task: pointer to struct task_struct
> > + * @group: shared or private
> > + * @resutl: TRACE_SIGNAL_*
> >   *
>
> s/resutl/result ;)

I'll send the bugreport to gcc.gnu.org. Surely -Wall should catch
such a typo!

------------------------------------------------------------------------------
[PATCH v2 1/2] tracing: let trace_signal_generate() report more info, kill overflow_fail/lose_info

Incompatible change.

__send_signal()->trace_signal_generate() doesn't report enough info.
The users want to know was the signal actually delivered or not, and
they also need the shared/private info.

The patch moves trace_signal_generate() at the end of __send_signal()
and adds the 2 additional arguments.

This also allows us to kill trace_signal_overflow_fail/lose_info, we
can simply add the appropriate TRACE_SIGNAL_ "result" codes.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 include/trace/events/signal.h |   85 +++++++++++------------------------------
 kernel/signal.c               |   22 +++++++----
 2 files changed, 36 insertions(+), 71 deletions(-)

diff --git a/include/trace/events/signal.h b/include/trace/events/signal.h
index 17df434..2de7208 100644
--- a/include/trace/events/signal.h
+++ b/include/trace/events/signal.h
@@ -23,11 +23,23 @@
 		}						\
 	} while (0)
 
+#ifndef TRACE_HEADER_MULTI_READ
+enum {
+	TRACE_SIGNAL_DELIVERED,
+	TRACE_SIGNAL_IGNORED,
+	TRACE_SIGNAL_ALREADY_PENDING,
+	TRACE_SIGNAL_OVERFLOW_FAIL,
+	TRACE_SIGNAL_LOSE_INFO,
+};
+#endif
+
 /**
  * signal_generate - called when a signal is generated
  * @sig: signal number
  * @info: pointer to struct siginfo
  * @task: pointer to struct task_struct
+ * @group: shared or private
+ * @result: TRACE_SIGNAL_*
  *
  * Current process sends a 'sig' signal to 'task' process with
  * 'info' siginfo. If 'info' is SEND_SIG_NOINFO or SEND_SIG_PRIV,
@@ -37,9 +49,10 @@
  */
 TRACE_EVENT(signal_generate,
 
-	TP_PROTO(int sig, struct siginfo *info, struct task_struct *task),
+	TP_PROTO(int sig, struct siginfo *info, struct task_struct *task,
+			int group, int result),
 
-	TP_ARGS(sig, info, task),
+	TP_ARGS(sig, info, task, group, result),
 
 	TP_STRUCT__entry(
 		__field(	int,	sig			)
@@ -47,6 +60,8 @@ TRACE_EVENT(signal_generate,
 		__field(	int,	code			)
 		__array(	char,	comm,	TASK_COMM_LEN	)
 		__field(	pid_t,	pid			)
+		__field(	int,	group			)
+		__field(	int,	result			)
 	),
 
 	TP_fast_assign(
@@ -54,11 +69,14 @@ TRACE_EVENT(signal_generate,
 		TP_STORE_SIGINFO(__entry, info);
 		memcpy(__entry->comm, task->comm, TASK_COMM_LEN);
 		__entry->pid	= task->pid;
+		__entry->group	= group;
+		__entry->result	= result;
 	),
 
-	TP_printk("sig=%d errno=%d code=%d comm=%s pid=%d",
+	TP_printk("sig=%d errno=%d code=%d comm=%s pid=%d grp=%d res=%d",
 		  __entry->sig, __entry->errno, __entry->code,
-		  __entry->comm, __entry->pid)
+		  __entry->comm, __entry->pid, __entry->group,
+		  __entry->result)
 );
 
 /**
@@ -101,65 +119,6 @@ TRACE_EVENT(signal_deliver,
 		  __entry->sa_handler, __entry->sa_flags)
 );
 
-DECLARE_EVENT_CLASS(signal_queue_overflow,
-
-	TP_PROTO(int sig, int group, struct siginfo *info),
-
-	TP_ARGS(sig, group, info),
-
-	TP_STRUCT__entry(
-		__field(	int,	sig	)
-		__field(	int,	group	)
-		__field(	int,	errno	)
-		__field(	int,	code	)
-	),
-
-	TP_fast_assign(
-		__entry->sig	= sig;
-		__entry->group	= group;
-		TP_STORE_SIGINFO(__entry, info);
-	),
-
-	TP_printk("sig=%d group=%d errno=%d code=%d",
-		  __entry->sig, __entry->group, __entry->errno, __entry->code)
-);
-
-/**
- * signal_overflow_fail - called when signal queue is overflow
- * @sig: signal number
- * @group: signal to process group or not (bool)
- * @info: pointer to struct siginfo
- *
- * Kernel fails to generate 'sig' signal with 'info' siginfo, because
- * siginfo queue is overflow, and the signal is dropped.
- * 'group' is not 0 if the signal will be sent to a process group.
- * 'sig' is always one of RT signals.
- */
-DEFINE_EVENT(signal_queue_overflow, signal_overflow_fail,
-
-	TP_PROTO(int sig, int group, struct siginfo *info),
-
-	TP_ARGS(sig, group, info)
-);
-
-/**
- * signal_lose_info - called when siginfo is lost
- * @sig: signal number
- * @group: signal to process group or not (bool)
- * @info: pointer to struct siginfo
- *
- * Kernel generates 'sig' signal but loses 'info' siginfo, because siginfo
- * queue is overflow.
- * 'group' is not 0 if the signal will be sent to a process group.
- * 'sig' is always one of non-RT signals.
- */
-DEFINE_EVENT(signal_queue_overflow, signal_lose_info,
-
-	TP_PROTO(int sig, int group, struct siginfo *info),
-
-	TP_ARGS(sig, group, info)
-);
-
 #endif /* _TRACE_SIGNAL_H */
 
 /* This part must be outside protection */
diff --git a/kernel/signal.c b/kernel/signal.c
index b3f78d0..5f130f6 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -1025,13 +1025,13 @@ static int __send_signal(int sig, struct siginfo *info, struct task_struct *t,
 	struct sigpending *pending;
 	struct sigqueue *q;
 	int override_rlimit;
-
-	trace_signal_generate(sig, info, t);
+	int ret = 0, result;
 
 	assert_spin_locked(&t->sighand->siglock);
 
+	result = TRACE_SIGNAL_IGNORED;
 	if (!prepare_signal(sig, t, from_ancestor_ns))
-		return 0;
+		goto ret;
 
 	pending = group ? &t->signal->shared_pending : &t->pending;
 	/*
@@ -1039,8 +1039,11 @@ static int __send_signal(int sig, struct siginfo *info, struct task_struct *t,
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
@@ -1095,14 +1098,15 @@ static int __send_signal(int sig, struct siginfo *info, struct task_struct *t,
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
 
@@ -1110,7 +1114,9 @@ out_set:
 	signalfd_notify(t, sig);
 	sigaddset(&pending->signal, sig);
 	complete_signal(sig, t, group);
-	return 0;
+ret:
+	trace_signal_generate(sig, info, t, group, result);
+	return ret;
 }
 
 static int send_signal(int sig, struct siginfo *info, struct task_struct *t,
-- 
1.5.5.1


