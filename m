Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753360Ab2B0Jfc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Feb 2012 04:35:32 -0500
Received: from terminus.zytor.com ([198.137.202.10]:44803 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752170Ab2B0Jfa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Feb 2012 04:35:30 -0500
Date: Mon, 27 Feb 2012 01:34:57 -0800
From: tip-bot for Jiri Olsa <jolsa@redhat.com>
Message-ID: <tip-489c75c3b333dfda4c8d2b7ad1b00e5da024bfa7@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        fweisbec@gmail.com, rostedt@goodmis.org, tglx@linutronix.de,
        jolsa@redhat.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        fweisbec@gmail.com, rostedt@goodmis.org, tglx@linutronix.de,
        jolsa@redhat.com
In-Reply-To: <1329317514-8131-4-git-send-email-jolsa@redhat.com>
References: <1329317514-8131-4-git-send-email-jolsa@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] ftrace, perf: Add add/
 del tracepoint perf registration actions
Git-Commit-ID: 489c75c3b333dfda4c8d2b7ad1b00e5da024bfa7
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Mon, 27 Feb 2012 01:35:23 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  489c75c3b333dfda4c8d2b7ad1b00e5da024bfa7
Gitweb:     http://git.kernel.org/tip/489c75c3b333dfda4c8d2b7ad1b00e5da024bfa7
Author:     Jiri Olsa <jolsa@redhat.com>
AuthorDate: Wed, 15 Feb 2012 15:51:50 +0100
Committer:  Steven Rostedt <rostedt@goodmis.org>
CommitDate: Tue, 21 Feb 2012 11:08:25 -0500

ftrace, perf: Add add/del tracepoint perf registration actions

Adding TRACE_REG_PERF_ADD and TRACE_REG_PERF_DEL to handle
perf event schedule in/out actions.

The add action is invoked for when the perf event is scheduled in,
while the del action is invoked when the event is scheduled out.

Link: http://lkml.kernel.org/r/1329317514-8131-4-git-send-email-jolsa@redhat.com

Acked-by: Frederic Weisbecker <fweisbec@gmail.com>
Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 include/linux/ftrace_event.h    |    2 ++
 kernel/trace/trace_event_perf.c |    4 +++-
 kernel/trace/trace_events.c     |    2 ++
 kernel/trace/trace_kprobe.c     |    2 ++
 kernel/trace/trace_syscalls.c   |    4 ++++
 5 files changed, 13 insertions(+), 1 deletions(-)

diff --git a/include/linux/ftrace_event.h b/include/linux/ftrace_event.h
index 195e360..2bf677c 100644
--- a/include/linux/ftrace_event.h
+++ b/include/linux/ftrace_event.h
@@ -148,6 +148,8 @@ enum trace_reg {
 	TRACE_REG_PERF_UNREGISTER,
 	TRACE_REG_PERF_OPEN,
 	TRACE_REG_PERF_CLOSE,
+	TRACE_REG_PERF_ADD,
+	TRACE_REG_PERF_DEL,
 };
 
 struct ftrace_event_call;
diff --git a/kernel/trace/trace_event_perf.c b/kernel/trace/trace_event_perf.c
index 0cfcc37..d72af0b 100644
--- a/kernel/trace/trace_event_perf.c
+++ b/kernel/trace/trace_event_perf.c
@@ -211,12 +211,14 @@ int perf_trace_add(struct perf_event *p_event, int flags)
 	list = this_cpu_ptr(pcpu_list);
 	hlist_add_head_rcu(&p_event->hlist_entry, list);
 
-	return 0;
+	return tp_event->class->reg(tp_event, TRACE_REG_PERF_ADD, p_event);
 }
 
 void perf_trace_del(struct perf_event *p_event, int flags)
 {
+	struct ftrace_event_call *tp_event = p_event->tp_event;
 	hlist_del_rcu(&p_event->hlist_entry);
+	tp_event->class->reg(tp_event, TRACE_REG_PERF_DEL, p_event);
 }
 
 __kprobes void *perf_trace_buf_prepare(int size, unsigned short type,
diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
index 5138fea..079a93a 100644
--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -173,6 +173,8 @@ int ftrace_event_reg(struct ftrace_event_call *call,
 		return 0;
 	case TRACE_REG_PERF_OPEN:
 	case TRACE_REG_PERF_CLOSE:
+	case TRACE_REG_PERF_ADD:
+	case TRACE_REG_PERF_DEL:
 		return 0;
 #endif
 	}
diff --git a/kernel/trace/trace_kprobe.c b/kernel/trace/trace_kprobe.c
index 5667f89..580a05e 100644
--- a/kernel/trace/trace_kprobe.c
+++ b/kernel/trace/trace_kprobe.c
@@ -1912,6 +1912,8 @@ int kprobe_register(struct ftrace_event_call *event,
 		return 0;
 	case TRACE_REG_PERF_OPEN:
 	case TRACE_REG_PERF_CLOSE:
+	case TRACE_REG_PERF_ADD:
+	case TRACE_REG_PERF_DEL:
 		return 0;
 #endif
 	}
diff --git a/kernel/trace/trace_syscalls.c b/kernel/trace/trace_syscalls.c
index e23515f..96fc733 100644
--- a/kernel/trace/trace_syscalls.c
+++ b/kernel/trace/trace_syscalls.c
@@ -666,6 +666,8 @@ static int syscall_enter_register(struct ftrace_event_call *event,
 		return 0;
 	case TRACE_REG_PERF_OPEN:
 	case TRACE_REG_PERF_CLOSE:
+	case TRACE_REG_PERF_ADD:
+	case TRACE_REG_PERF_DEL:
 		return 0;
 #endif
 	}
@@ -690,6 +692,8 @@ static int syscall_exit_register(struct ftrace_event_call *event,
 		return 0;
 	case TRACE_REG_PERF_OPEN:
 	case TRACE_REG_PERF_CLOSE:
+	case TRACE_REG_PERF_ADD:
+	case TRACE_REG_PERF_DEL:
 		return 0;
 #endif
 	}
