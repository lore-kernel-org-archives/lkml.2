Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752874Ab2A1SoZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jan 2012 13:44:25 -0500
Received: from mx1.redhat.com ([209.132.183.28]:65433 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752540Ab2A1Snr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jan 2012 13:43:47 -0500
From: Jiri Olsa <jolsa@redhat.com>
To: rostedt@goodmis.org, fweisbec@gmail.com, mingo@redhat.com,
        paulus@samba.org, acme@ghostprotocols.net, a.p.zijlstra@chello.nl
Cc: linux-kernel@vger.kernel.org, aarapov@redhat.com,
        Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 4/7] ftrace, perf: Add add/del tracepoint perf registration actions
Date: Sat, 28 Jan 2012 19:43:26 +0100
Message-Id: <1327776209-4883-5-git-send-email-jolsa@redhat.com>
In-Reply-To: <1327776209-4883-1-git-send-email-jolsa@redhat.com>
References: <1326912275-26405-1-git-send-email-jolsa@redhat.com>
 <1327776209-4883-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding TRACE_REG_PERF_ADD and TRACE_REG_PERF_DEL to handle
perf event schedule in/out actions.

The add action is invoked for when the perf event is scheduled in,
while the del action is invoked when the event is scheduled out.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
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
index 6916b0d..dbdd804 100644
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
-- 
1.7.1

