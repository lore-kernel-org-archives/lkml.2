Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752369Ab0HRR7i (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Aug 2010 13:59:38 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:63724 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751201Ab0HRR7g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Aug 2010 13:59:36 -0400
X-Authority-Analysis: v=1.1 cv=hq19gxSPBs22H2+7jjeFeKdMjhxfK61NGD3XKDB0Rhk= c=1 sm=0 a=wbkiIP7zdmUA:10 a=Q9fys5e9bTEA:10 a=IXo+6rlC6z1XzBFn1RNpIA==:17 a=VwQbUJbxAAAA:8 a=omOdbC7AAAAA:8 a=meVymXHHAAAA:8 a=blmq_UX0ufI_ZrWZHIAA:9 a=24T9up81hh4sOq-2MLoA:7 a=1nrx8usKqk_3R37VZMAQ9bmHfNcA:4 a=PUjeQqilurYA:10 a=jeBq3FmKZ4MA:10 a=tv-wtlpLor4nV-ES:21 a=6FIKyKC1xLxzeecY:21 a=IXo+6rlC6z1XzBFn1RNpIA==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.87.39
Subject: [PATCH][GIT PULL][2.6.36] tracing: Clean up seqfile code for
 format file
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Li Zefan <lizf@cn.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Wed, 18 Aug 2010 13:59:33 -0400
Message-ID: <1282154373.17751.42.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Ingo,

Li sent a patch that does a cleaner processing of the format file. It
removes a hack that is used to notify the show part of the seqfile
formatting that a newline needs to be used.

Li's solution is cleaner and is better for the release.

Please pull the latest tip/perf/urgent tree, which can be found at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
tip/perf/urgent


Li Zefan (1):
      tracing: Clean up seqfile code for format file

----
 kernel/trace/trace_events.c |   55 ++++++++++++++-----------------------------
 1 files changed, 18 insertions(+), 37 deletions(-)
---------------------------
commit 86397dc3ccfc0e17b7550d05eaf15fe91f6498dd
Author: Li Zefan <lizf@cn.fujitsu.com>
Date:   Tue Aug 17 13:53:06 2010 +0800

    tracing: Clean up seqfile code for format file
    
    Remove the nasty hack that marks a pointer's LSB to distinguish common
    fields from event fields. Replace it with a more sane approach.
    
    Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
    LKML-Reference: <4C6A23C2.9020606@cn.fujitsu.com>
    Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

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


