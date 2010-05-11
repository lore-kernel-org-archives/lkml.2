Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758195Ab0EKDKq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 May 2010 23:10:46 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:50327 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757786Ab0EKDJN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 May 2010 23:09:13 -0400
X-Authority-Analysis: v=1.1 cv=Ebn0m7KaSvUJV60GCOzUqyhjUj7QmnsyUUVbVvk8w6o= c=1 sm=0 a=7mIHG430SpkA:10 a=GzHTLUccyWwA:10 a=gMqfjgEr1zLu/65IO0LwxA==:17 a=20KFwNOVAAAA:8 a=meVymXHHAAAA:8 a=uSEfUfkat4rXeH0mG2kA:9 a=yhzdY_oBqP-BomHK_8QA:7 a=3sTEF-riIudke56GH4xmg8eFITQA:4 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=gMqfjgEr1zLu/65IO0LwxA==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Message-Id: <20100511030911.927339838@goodmis.org>
User-Agent: quilt/0.48-1
Date: Mon, 10 May 2010 23:00:30 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       Lai Jiangshan <laijs@cn.fujitsu.com>, Li Zefan <lizf@cn.fujitsu.com>,
       Masami Hiramatsu <mhiramat@redhat.com>, Christoph Hellwig <hch@lst.de>
Subject: [PATCH 10/10 -v3][RFC] tracing: Combine event filter_active and enable into single flags field
References: <20100511030020.837892321@goodmis.org>
Content-Disposition: inline; filename=0010-tracing-Combine-event-filter_active-and-enable-into-.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

The filter_active and enable both use an int (4 bytes each) to
set a single flag. We can save 4 bytes per event by combining the
two into a single integer.

   text	   data	    bss	    dec	    hex	filename
5788186	1337252	9351592	16477030	 fb6b66	vmlinux.orig
5761074	1262596	9351592	16375262	 f9ddde	vmlinux.id
5761007	1256916	9351592	16369515	 f9c76b	vmlinux.flags

This gives us another 5K in savings.

The modification of both the enable and filter fields are done
under the event_mutex, so it is still safe to combine the two.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 include/linux/ftrace_event.h       |   21 +++++++++++++++++++--
 kernel/trace/trace.h               |    2 +-
 kernel/trace/trace_events.c        |   14 +++++++-------
 kernel/trace/trace_events_filter.c |   10 +++++-----
 kernel/trace/trace_kprobe.c        |    2 +-
 5 files changed, 33 insertions(+), 16 deletions(-)

diff --git a/include/linux/ftrace_event.h b/include/linux/ftrace_event.h
index 0be0285..5ac97a4 100644
--- a/include/linux/ftrace_event.h
+++ b/include/linux/ftrace_event.h
@@ -143,6 +143,16 @@ struct ftrace_event_class {
 	int			(*raw_init)(struct ftrace_event_call *);
 };
 
+enum {
+	TRACE_EVENT_FL_ENABLED_BIT,
+	TRACE_EVENT_FL_FILTERED_BIT,
+};
+
+enum {
+	TRACE_EVENT_FL_ENABLED	= (1 << TRACE_EVENT_FL_ENABLED_BIT),
+	TRACE_EVENT_FL_FILTERED	= (1 << TRACE_EVENT_FL_FILTERED_BIT),
+};
+
 struct ftrace_event_call {
 	struct list_head	list;
 	struct ftrace_event_class *class;
@@ -154,8 +164,15 @@ struct ftrace_event_call {
 	void			*mod;
 	void			*data;
 
-	int			enabled;
-	int			filter_active;
+	/*
+	 * 32 bit flags:
+	 *   bit 1:		enabled
+	 *   bit 2:		filter_active
+	 *
+	 *  Must hold event_mutex to change.
+	 */
+	unsigned int		flags;
+
 	int			perf_refcount;
 };
 
diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index c88c563..6356259 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -802,7 +802,7 @@ filter_check_discard(struct ftrace_event_call *call, void *rec,
 		     struct ring_buffer *buffer,
 		     struct ring_buffer_event *event)
 {
-	if (unlikely(call->filter_active) &&
+	if (unlikely(call->flags & TRACE_EVENT_FL_FILTERED) &&
 	    !filter_match_preds(call->filter, rec)) {
 		ring_buffer_discard_commit(buffer, event);
 		return 1;
diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
index 8a2b370..2593365 100644
--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -137,8 +137,8 @@ static int ftrace_event_enable_disable(struct ftrace_event_call *call,
 
 	switch (enable) {
 	case 0:
-		if (call->enabled) {
-			call->enabled = 0;
+		if (call->flags & TRACE_EVENT_FL_ENABLED) {
+			call->flags &= ~TRACE_EVENT_FL_ENABLED;
 			tracing_stop_cmdline_record();
 			if (call->class->reg)
 				call->class->reg(call, TRACE_REG_UNREGISTER);
@@ -149,7 +149,7 @@ static int ftrace_event_enable_disable(struct ftrace_event_call *call,
 		}
 		break;
 	case 1:
-		if (!call->enabled) {
+		if (!(call->flags & TRACE_EVENT_FL_ENABLED)) {
 			tracing_start_cmdline_record();
 			if (call->class->reg)
 				ret = call->class->reg(call, TRACE_REG_REGISTER);
@@ -163,7 +163,7 @@ static int ftrace_event_enable_disable(struct ftrace_event_call *call,
 					"%s\n", call->name);
 				break;
 			}
-			call->enabled = 1;
+			call->flags |= TRACE_EVENT_FL_ENABLED;
 		}
 		break;
 	}
@@ -352,7 +352,7 @@ s_next(struct seq_file *m, void *v, loff_t *pos)
 	(*pos)++;
 
 	list_for_each_entry_continue(call, &ftrace_events, list) {
-		if (call->enabled)
+		if (call->flags & TRACE_EVENT_FL_ENABLED)
 			return call;
 	}
 
@@ -411,7 +411,7 @@ event_enable_read(struct file *filp, char __user *ubuf, size_t cnt,
 	struct ftrace_event_call *call = filp->private_data;
 	char *buf;
 
-	if (call->enabled)
+	if (call->flags & TRACE_EVENT_FL_ENABLED)
 		buf = "1\n";
 	else
 		buf = "0\n";
@@ -486,7 +486,7 @@ system_enable_read(struct file *filp, char __user *ubuf, size_t cnt,
 		 * or if all events or cleared, or if we have
 		 * a mixture.
 		 */
-		set |= (1 << !!call->enabled);
+		set |= (1 << !!(call->flags & TRACE_EVENT_FL_ENABLED));
 
 		/*
 		 * If we have a mixture, no need to look further.
diff --git a/kernel/trace/trace_events_filter.c b/kernel/trace/trace_events_filter.c
index 2702d6b..239ea5d 100644
--- a/kernel/trace/trace_events_filter.c
+++ b/kernel/trace/trace_events_filter.c
@@ -547,7 +547,7 @@ static void filter_disable_preds(struct ftrace_event_call *call)
 	struct event_filter *filter = call->filter;
 	int i;
 
-	call->filter_active = 0;
+	call->flags &= ~TRACE_EVENT_FL_FILTERED;
 	filter->n_preds = 0;
 
 	for (i = 0; i < MAX_FILTER_PRED; i++)
@@ -574,7 +574,7 @@ void destroy_preds(struct ftrace_event_call *call)
 {
 	__free_preds(call->filter);
 	call->filter = NULL;
-	call->filter_active = 0;
+	call->flags &= ~TRACE_EVENT_FL_FILTERED;
 }
 
 static struct event_filter *__alloc_preds(void)
@@ -613,7 +613,7 @@ static int init_preds(struct ftrace_event_call *call)
 	if (call->filter)
 		return 0;
 
-	call->filter_active = 0;
+	call->flags &= ~TRACE_EVENT_FL_FILTERED;
 	call->filter = __alloc_preds();
 	if (IS_ERR(call->filter))
 		return PTR_ERR(call->filter);
@@ -1268,7 +1268,7 @@ static int replace_system_preds(struct event_subsystem *system,
 		if (err)
 			filter_disable_preds(call);
 		else {
-			call->filter_active = 1;
+			call->flags |= TRACE_EVENT_FL_FILTERED;
 			replace_filter_string(filter, filter_string);
 		}
 		fail = false;
@@ -1317,7 +1317,7 @@ int apply_event_filter(struct ftrace_event_call *call, char *filter_string)
 	if (err)
 		append_filter_err(ps, call->filter);
 	else
-		call->filter_active = 1;
+		call->flags |= TRACE_EVENT_FL_FILTERED;
 out:
 	filter_opstack_clear(ps);
 	postfix_clear(ps);
diff --git a/kernel/trace/trace_kprobe.c b/kernel/trace/trace_kprobe.c
index 934078b..0e3ded6 100644
--- a/kernel/trace/trace_kprobe.c
+++ b/kernel/trace/trace_kprobe.c
@@ -1382,7 +1382,7 @@ static int register_probe_event(struct trace_probe *tp)
 		kfree(call->print_fmt);
 		return -ENODEV;
 	}
-	call->enabled = 0;
+	call->flags = 0;
 	call->class->reg = kprobe_register;
 	call->data = tp;
 	ret = trace_add_event_call(call);
-- 
1.7.0


