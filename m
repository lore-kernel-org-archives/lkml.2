Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751344Ab0FDEPB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jun 2010 00:15:01 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:51950 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750732Ab0FDEPA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jun 2010 00:15:00 -0400
X-Authority-Analysis: v=1.1 cv=DT5lrGikL/lNZzMKzbmp3iVCACewI9NZ3q1CIi1KGbI= c=1 sm=0 a=PrV_ml3jdBcA:10 a=yQWWgrYGNuUA:10 a=7U3hwN5JcxgA:10 a=Q9fys5e9bTEA:10 a=gMqfjgEr1zLu/65IO0LwxA==:17 a=_iCx3PlZv8Y0nY-7joEA:9 a=QZ9Mpdru4s_z04mjoAIA:7 a=aPNeAwhEsNTQLdE1EYNF3WNVmx4A:4 a=PUjeQqilurYA:10 a=gMqfjgEr1zLu/65IO0LwxA==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: Re: [PATCH][GIT PULL][v2.6.35] tracing/events: Convert format
 output to seq_file
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       "Martin K. Petersen" <martin.petersen@oracle.com>,
       Kei Tokunaga <tokunaga.keiich@jp.fujitsu.com>,
       James Bottomley <James.Bottomley@suse.de>,
       Tomohiro Kusumi <kusumi.tomohiro@jp.fujitsu.com>,
       Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
In-Reply-To: <4C08594E.2000703@cn.fujitsu.com>
References: <1275594103.15884.35.camel@gandalf.stny.rr.com>
	 <4C08594E.2000703@cn.fujitsu.com>
Content-Type: text/plain; charset="ISO-8859-15"
Organization: Kihon Technologies Inc.
Date: Fri, 04 Jun 2010 00:14:57 -0400
Message-ID: <1275624897.15884.74.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-06-04 at 09:39 +0800, Li Zefan wrote:

> This patch seriously conflicts with my patch that extracts common fields
> from every trace event to a global list, which is already in your perf/core2
> branch. Should I rebase and resend it?

I pushed out a conflict resolution of pulling tip/perf/urgent-2 into
tip/perf/core-2 (and pushing that as tip/perf/core-4).

I did change a bit.

-- Steve

Here's the diff:

diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
index f4dbce1..5b08ff6 100644
--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -30,6 +30,8 @@ DEFINE_MUTEX(event_mutex);
 LIST_HEAD(ftrace_events);
 LIST_HEAD(ftrace_common_fields);
 
+#define COMMON_FIELD_COUNT	5
+
 struct list_head *
 trace_get_fields(struct ftrace_event_call *event_call)
 {
@@ -555,88 +557,157 @@ out:
 	return ret;
 }
 
-static void print_event_fields(struct trace_seq *s, struct list_head *head)
+enum {
+	FORMAT_HEADER		= 1,
+	FORMAT_PRINTFMT		= 2,
+};
+
+static void *f_next(struct seq_file *m, void *v, loff_t *pos)
 {
+	struct ftrace_event_call *call = m->private;
 	struct ftrace_event_field *field;
+	struct list_head *head;
 
-	list_for_each_entry_reverse(field, head, link) {
-		/*
-		 * Smartly shows the array type(except dynamic array).
-		 * Normal:
-		 *	field:TYPE VAR
-		 * If TYPE := TYPE[LEN], it is shown:
-		 *	field:TYPE VAR[LEN]
-		 */
-		const char *array_descriptor = strchr(field->type, '[');
-
-		if (!strncmp(field->type, "__data_loc", 10))
-			array_descriptor = NULL;
-
-		if (!array_descriptor) {
-			trace_seq_printf(s, "\tfield:%s %s;\toffset:%u;"
-					"\tsize:%u;\tsigned:%d;\n",
-					field->type, field->name, field->offset,
-					field->size, !!field->is_signed);
-		} else {
-			trace_seq_printf(s, "\tfield:%.*s %s%s;\toffset:%u;"
-					"\tsize:%u;\tsigned:%d;\n",
-					(int)(array_descriptor - field->type),
-					field->type, field->name,
-					array_descriptor, field->offset,
-					field->size, !!field->is_signed);
-		}
+	(*pos)++;
+
+	head = &ftrace_common_fields;
+
+	switch ((unsigned long)v) {
+	case FORMAT_HEADER:
+		field = list_entry(head->prev, struct ftrace_event_field, link);
+		return field;
+
+	case FORMAT_PRINTFMT:
+		/* all done */
+		return NULL;
+	}
+
+	/*
+	 * To separate common fields from event fields, the
+	 * LSB is set on the first event field. Clear it in case.
+	 */
+	v = (void *)((unsigned long)v & ~1L);
+	field = v;
+
+	head = trace_get_fields(call);
+
+	/*
+	 * If this is the last common field, then set the field to
+	 * the first event field and also set the LSB to tell f_show()
+	 * to print a newline.
+	 */
+	if (field->link.prev == &ftrace_common_fields) {
+		field = list_entry(head->prev, struct ftrace_event_field, link);
+		return (void *)((unsigned long)field | 1);
 	}
+
+	if (field->link.prev == head)
+		return (void *)FORMAT_PRINTFMT;
+
+	field = list_entry(field->link.prev, struct ftrace_event_field, link);
+
+	return field;
 }
 
-static ssize_t
-event_format_read(struct file *filp, char __user *ubuf, size_t cnt,
-		  loff_t *ppos)
+static void *f_start(struct seq_file *m, loff_t *pos)
 {
-	struct ftrace_event_call *call = filp->private_data;
-	struct list_head *head;
-	struct trace_seq *s;
-	char *buf;
-	int r;
+	loff_t l = 0;
+	void *p;
 
-	if (*ppos)
+	/* Start by showing the header */
+	if (!*pos)
+		return (void *)FORMAT_HEADER;
+
+	p = (void *)FORMAT_HEADER;
+	do {
+		p = f_next(m, p, &l);
+	} while (p && l < *pos);
+
+	return p;
+}
+
+static int f_show(struct seq_file *m, void *v)
+{
+	struct ftrace_event_call *call = m->private;
+	struct ftrace_event_field *field;
+	const char *array_descriptor;
+
+	switch ((unsigned long)v) {
+	case FORMAT_HEADER:
+		seq_printf(m, "name: %s\n", call->name);
+		seq_printf(m, "ID: %d\n", call->event.type);
+		seq_printf(m, "format:\n");
 		return 0;
 
-	s = kmalloc(sizeof(*s), GFP_KERNEL);
-	if (!s)
-		return -ENOMEM;
+	case FORMAT_PRINTFMT:
+		seq_printf(m, "\nprint fmt: %s\n",
+			   call->print_fmt);
+		return 0;
+	}
 
-	trace_seq_init(s);
+	/*
+	 * To separate common fields from event fields, the
+	 * LSB is set on the first event field. Clear it and
+	 * print a newline if it is set.
+	 */
+	if ((unsigned long)v & 1) {
+		seq_putc(m, '\n');
+		v = (void *)((unsigned long)v & ~1L);
+	}
 
-	trace_seq_printf(s, "name: %s\n", call->name);
-	trace_seq_printf(s, "ID: %d\n", call->event.type);
-	trace_seq_printf(s, "format:\n");
+	field = v;
 
-	/* print common fields */
-	print_event_fields(s, &ftrace_common_fields);
+	/*
+	 * Smartly shows the array type(except dynamic array).
+	 * Normal:
+	 *	field:TYPE VAR
+	 * If TYPE := TYPE[LEN], it is shown:
+	 *	field:TYPE VAR[LEN]
+	 */
+	array_descriptor = strchr(field->type, '[');
 
-	trace_seq_putc(s, '\n');
+	if (!strncmp(field->type, "__data_loc", 10))
+		array_descriptor = NULL;
 
-	/* print event specific fields */
-	head = trace_get_fields(call);
-	print_event_fields(s, head);
+	if (!array_descriptor)
+		seq_printf(m, "\tfield:%s %s;\toffset:%u;\tsize:%u;\tsigned:%d;\n",
+			   field->type, field->name, field->offset,
+			   field->size, !!field->is_signed);
+	else
+		seq_printf(m, "\tfield:%.*s %s%s;\toffset:%u;\tsize:%u;\tsigned:%d;\n",
+			   (int)(array_descriptor - field->type),
+			   field->type, field->name,
+			   array_descriptor, field->offset,
+			   field->size, !!field->is_signed);
 
-	r = trace_seq_printf(s, "\nprint fmt: %s\n", call->print_fmt);
+	return 0;
+}
 
-	if (!r) {
-		/*
-		 * ug!  The format output is bigger than a PAGE!!
-		 */
-		buf = "FORMAT TOO BIG\n";
-		r = simple_read_from_buffer(ubuf, cnt, ppos,
-					      buf, strlen(buf));
-		goto out;
-	}
+static void f_stop(struct seq_file *m, void *p)
+{
+}
 
-	r = simple_read_from_buffer(ubuf, cnt, ppos,
-				    s->buffer, s->len);
- out:
-	kfree(s);
-	return r;
+static const struct seq_operations trace_format_seq_ops = {
+	.start		= f_start,
+	.next		= f_next,
+	.stop		= f_stop,
+	.show		= f_show,
+};
+
+static int trace_format_open(struct inode *inode, struct file *file)
+{
+	struct ftrace_event_call *call = inode->i_private;
+	struct seq_file *m;
+	int ret;
+
+	ret = seq_open(file, &trace_format_seq_ops);
+	if (ret < 0)
+		return ret;
+
+	m = file->private_data;
+	m->private = call;
+
+	return 0;
 }
 
 static ssize_t
@@ -834,8 +905,10 @@ static const struct file_operations ftrace_enable_fops = {
 };
 
 static const struct file_operations ftrace_event_format_fops = {
-	.open = tracing_open_generic,
-	.read = event_format_read,
+	.open = trace_format_open,
+	.read = seq_read,
+	.llseek = seq_lseek,
+	.release = seq_release,
 };
 
 static const struct file_operations ftrace_event_id_fops = {



