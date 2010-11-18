Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753411Ab0KRBcw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Nov 2010 20:32:52 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:46469 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753151Ab0KRBcu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Nov 2010 20:32:50 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:x-mailer-version
         :in-reply-to:references;
        b=ZfUpboLMzg8FH6FgZtKq5NPoc/mYVJ0yU1wDrkyWIrRYAo/oe/12Oi6iXpfP8m2vPA
         Y7WXS94EjM5FBPAejWD8gUVjoq9c1NDVInSKdk7qUWGbdAPaNNONId5mCvki9Viws1iZ
         92ejLp1SCdoySeYONnN0J4S6ZJuuUg1nHDycM=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>, Li Zefan <lizf@cn.fujitsu.com>,
        Jason Baron <jbaron@redhat.com>
Subject: [PATCH 1/5] tracing: New flag to allow non privileged users to use a trace event
Date: Thu, 18 Nov 2010 02:32:39 +0100
Message-Id: <1290043963-1480-2-git-send-regression-fweisbec@gmail.com>
X-Mailer: git-send-regression
X-Mailer-version: 0.1, "The maintainer couldn't reproduce after one week full time debugging" special version.
In-Reply-To: <1290043963-1480-1-git-send-regression-fweisbec@gmail.com>
References: <1290043963-1480-1-git-send-regression-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds a new trace event internal flag that allows them to be
used in perf by non privileged users in case of task bound tracing.

This is desired for syscalls tracepoint because they don't leak
global system informations, like some other tracepoints.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Li Zefan <lizf@cn.fujitsu.com>
Cc: Jason Baron <jbaron@redhat.com>
---
 include/linux/ftrace_event.h    |    2 ++
 kernel/perf_event.c             |    9 ---------
 kernel/trace/trace_event_perf.c |   31 ++++++++++++++++++++++++++++++-
 3 files changed, 32 insertions(+), 10 deletions(-)

diff --git a/include/linux/ftrace_event.h b/include/linux/ftrace_event.h
index 8beabb9..312dce7 100644
--- a/include/linux/ftrace_event.h
+++ b/include/linux/ftrace_event.h
@@ -154,12 +154,14 @@ enum {
 	TRACE_EVENT_FL_ENABLED_BIT,
 	TRACE_EVENT_FL_FILTERED_BIT,
 	TRACE_EVENT_FL_RECORDED_CMD_BIT,
+	TRACE_EVENT_FL_CAP_ANY_BIT,
 };
 
 enum {
 	TRACE_EVENT_FL_ENABLED		= (1 << TRACE_EVENT_FL_ENABLED_BIT),
 	TRACE_EVENT_FL_FILTERED		= (1 << TRACE_EVENT_FL_FILTERED_BIT),
 	TRACE_EVENT_FL_RECORDED_CMD	= (1 << TRACE_EVENT_FL_RECORDED_CMD_BIT),
+	TRACE_EVENT_FL_CAP_ANY		= (1 << TRACE_EVENT_FL_CAP_ANY_BIT),
 };
 
 struct ftrace_event_call {
diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index 517d827..ee1e903 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -4747,15 +4747,6 @@ static int perf_tp_event_init(struct perf_event *event)
 	if (event->attr.type != PERF_TYPE_TRACEPOINT)
 		return -ENOENT;
 
-	/*
-	 * Raw tracepoint data is a severe data leak, only allow root to
-	 * have these.
-	 */
-	if ((event->attr.sample_type & PERF_SAMPLE_RAW) &&
-			perf_paranoid_tracepoint_raw() &&
-			!capable(CAP_SYS_ADMIN))
-		return -EPERM;
-
 	err = perf_trace_init(event);
 	if (err)
 		return err;
diff --git a/kernel/trace/trace_event_perf.c b/kernel/trace/trace_event_perf.c
index 39c059c..19a359d 100644
--- a/kernel/trace/trace_event_perf.c
+++ b/kernel/trace/trace_event_perf.c
@@ -21,17 +21,46 @@ typedef typeof(unsigned long [PERF_MAX_TRACE_SIZE / sizeof(unsigned long)])
 /* Count the events in use (per event id, not per instance) */
 static int	total_ref_count;
 
+static int perf_trace_event_perm(struct ftrace_event_call *tp_event,
+				 struct perf_event *p_event)
+{
+	/* No tracing, just counting, so no obvious leak */
+	if (!(p_event->attr.sample_type & PERF_SAMPLE_RAW))
+		return 0;
+
+	/* Some events are ok to be traced by non-root users... */
+	if (p_event->attach_state == PERF_ATTACH_TASK) {
+		if (tp_event->flags & TRACE_EVENT_FL_CAP_ANY)
+			return 0;
+	}
+
+	/*
+	 * ...otherwise raw tracepoint data can be a severe data leak,
+	 * only allow root to have these.
+	 */
+	if (perf_paranoid_tracepoint_raw() && !capable(CAP_SYS_ADMIN))
+		return -EPERM;
+
+	return 0;
+}
+
 static int perf_trace_event_init(struct ftrace_event_call *tp_event,
 				 struct perf_event *p_event)
 {
 	struct hlist_head __percpu *list;
-	int ret = -ENOMEM;
+	int ret;
 	int cpu;
 
+	ret = perf_trace_event_perm(tp_event, p_event);
+	if (ret)
+		return ret;
+
 	p_event->tp_event = tp_event;
 	if (tp_event->perf_refcount++ > 0)
 		return 0;
 
+	ret = -ENOMEM;
+
 	list = alloc_percpu(struct hlist_head);
 	if (!list)
 		goto fail;
-- 
1.6.2.3

