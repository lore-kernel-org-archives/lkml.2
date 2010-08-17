Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754647Ab0HQFs1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Aug 2010 01:48:27 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:54594 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751637Ab0HQFs0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Aug 2010 01:48:26 -0400
Message-ID: <4C6A23C2.9020606@cn.fujitsu.com>
Date: Tue, 17 Aug 2010 13:53:06 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] tracing: Simplify seqfile code for format file
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We don't have to use the trick that marks a pointer's LSB to
distinguish event fields from common fields.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 kernel/trace/trace_events.c |   55 ++++++++++++++-----------------------------
 1 files changed, 18 insertions(+), 37 deletions(-)

diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
index 4c758f1..398c0e8 100644
--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -600,21 +600,29 @@ out:
 
 enum {
 	FORMAT_HEADER		= 1,
-	FORMAT_PRINTFMT		= 2,
+	FORMAT_FIELD_SEPERATOR	= 2,
+	FORMAT_PRINTFMT		= 3,
 };
 
 static void *f_next(struct seq_file *m, void *v, loff_t *pos)
 {
 	struct ftrace_event_call *call = m->private;
 	struct ftrace_event_field *field;
-	struct list_head *head;
+	struct list_head *common_head = &ftrace_common_fields;
+	struct list_head *head = trace_get_fields(call);
 
 	(*pos)++;
 
 	switch ((unsigned long)v) {
 	case FORMAT_HEADER:
-		head = &ftrace_common_fields;
+		if (unlikely(list_empty(common_head)))
+			return NULL;
+
+		field = list_entry(common_head->prev,
+				   struct ftrace_event_field, link);
+		return field;
 
+	case FORMAT_FIELD_SEPERATOR:
 		if (unlikely(list_empty(head)))
 			return NULL;
 
@@ -626,31 +634,10 @@ static void *f_next(struct seq_file *m, void *v, loff_t *pos)
 		return NULL;
 	}
 
-	head = trace_get_fields(call);
-
-	/*
-	 * To separate common fields from event fields, the
-	 * LSB is set on the first event field. Clear it in case.
-	 */
-	v = (void *)((unsigned long)v & ~1L);
-
 	field = v;
-	/*
-	 * If this is a common field, and at the end of the list, then
-	 * continue with main list.
-	 */
-	if (field->link.prev == &ftrace_common_fields) {
-		if (unlikely(list_empty(head)))
-			return NULL;
-		field = list_entry(head->prev, struct ftrace_event_field, link);
-		/* Set the LSB to notify f_show to print an extra newline */
-		field = (struct ftrace_event_field *)
-			((unsigned long)field | 1);
-		return field;
-	}
-
-	/* If we are done tell f_show to print the format */
-	if (field->link.prev == head)
+	if (field->link.prev == common_head)
+		return (void *)FORMAT_FIELD_SEPERATOR;
+	else if (field->link.prev == head)
 		return (void *)FORMAT_PRINTFMT;
 
 	field = list_entry(field->link.prev, struct ftrace_event_field, link);
@@ -688,22 +675,16 @@ static int f_show(struct seq_file *m, void *v)
 		seq_printf(m, "format:\n");
 		return 0;
 
+	case FORMAT_FIELD_SEPERATOR:
+		seq_putc(m, '\n');
+		return 0;
+
 	case FORMAT_PRINTFMT:
 		seq_printf(m, "\nprint fmt: %s\n",
 			   call->print_fmt);
 		return 0;
 	}
 
-	/*
-	 * To separate common fields from event fields, the
-	 * LSB is set on the first event field. Clear it and
-	 * print a newline if it is set.
-	 */
-	if ((unsigned long)v & 1) {
-		seq_putc(m, '\n');
-		v = (void *)((unsigned long)v & ~1L);
-	}
-
 	field = v;
 
 	/*
-- 
1.6.3

