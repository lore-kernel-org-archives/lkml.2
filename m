Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752747Ab0HSLWO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Aug 2010 07:22:14 -0400
Received: from hera.kernel.org ([140.211.167.34]:51884 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751406Ab0HSLWN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Aug 2010 07:22:13 -0400
Date: Thu, 19 Aug 2010 11:21:49 GMT
From: tip-bot for Li Zefan <lizf@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        rostedt@goodmis.org, lizf@cn.fujitsu.com, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        lizf@cn.fujitsu.com, rostedt@goodmis.org, tglx@linutronix.de
In-Reply-To: <4C6A23C2.9020606@cn.fujitsu.com>
References: <4C6A23C2.9020606@cn.fujitsu.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] tracing: Clean up seqfile code for format file
Message-ID: <tip-86397dc3ccfc0e17b7550d05eaf15fe91f6498dd@git.kernel.org>
Git-Commit-ID: 86397dc3ccfc0e17b7550d05eaf15fe91f6498dd
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 19 Aug 2010 11:21:50 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  86397dc3ccfc0e17b7550d05eaf15fe91f6498dd
Gitweb:     http://git.kernel.org/tip/86397dc3ccfc0e17b7550d05eaf15fe91f6498dd
Author:     Li Zefan <lizf@cn.fujitsu.com>
AuthorDate: Tue, 17 Aug 2010 13:53:06 +0800
Committer:  Steven Rostedt <rostedt@goodmis.org>
CommitDate: Wed, 18 Aug 2010 11:09:14 -0400

tracing: Clean up seqfile code for format file

Remove the nasty hack that marks a pointer's LSB to distinguish common
fields from event fields. Replace it with a more sane approach.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
LKML-Reference: <4C6A23C2.9020606@cn.fujitsu.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
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
