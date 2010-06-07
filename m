Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756514Ab0FGH7D (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jun 2010 03:59:03 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:54277 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752724Ab0FGH7A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jun 2010 03:59:00 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.4.0
Message-ID: <4C0CA681.5000100@jp.fujitsu.com>
Date: Mon, 07 Jun 2010 16:57:53 +0900
From: Kei Tokunaga <tokunaga.keiich@jp.fujitsu.com>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: rostedt@goodmis.org
CC: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       "Martin K. Petersen" <martin.petersen@oracle.com>,
       James Bottomley <James.Bottomley@suse.de>,
       Tomohiro Kusumi <kusumi.tomohiro@jp.fujitsu.com>,
       Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>,
       Li Zefan <lizf@cn.fujitsu.com>,
       Kei Tokunaga <tokunaga.keiich@jp.fujitsu.com>
Subject: Re: [PATCH v2][GIT PULL][v2.6.35] tracing/events: Convert format
 output to seq_file
References: <1275594103.15884.35.camel@gandalf.stny.rr.com> <1275622026.15884.72.camel@gandalf.stny.rr.com>
In-Reply-To: <1275622026.15884.72.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Steven Rostedt wrote:
> Ingo,
> 
> Please pull the latest tip/perf/urgent-2 tree, which can be found at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
> tip/perf/urgent-2
> 
> 
> Steven Rostedt (1):
>       tracing/events: Convert format output to seq_file
> 
> ----
>  kernel/trace/trace_events.c |  208 +++++++++++++++++++++++++++++--------------
>  1 files changed, 141 insertions(+), 67 deletions(-)
> ---------------------------
> commit bcaa10360f3b2a623453a9fb10ef77aafeef8bb6
> Author: Steven Rostedt <srostedt@redhat.com>
> Date:   Thu Jun 3 15:21:34 2010 -0400
> 
>     tracing/events: Convert format output to seq_file
>     
>     Two new events were added that broke the current format output.
>     
>     Both from the SCSI system: scsi_dispatch_cmd_done and scsi_dispatch_cmd_timeout
>     
>     The reason is that their print_fmt exceeded a page size. Since the output
>     of the format used simple_read_from_buffer and trace_seq, it was limited
>     to a page size in output.
>     
>     This patch converts the printing of the format of an event into seq_file,
>     which allows greater than a page size to be shown.
>     
>     I diffed all event formats comparing the output with and without this
>     patch. All matched except for the above two, which showed just:
>     
>       FORMAT TOO BIG
>     
>     without this patch, but now properly displays the output with this patch.
>     
>     v2: Remove updating *pos in seq start function.
>        [ Thanks to Li Zefan for pointing that out ]

There's been an oversight...  Thanks a lot for finding and fixing
this!  I built a kernel with the patch applied and confirmed the
issue is fixed on my box.

Tested-by: Kei Tokunaga <tokunaga.keiich@jp.fujitsu.com>

>     Reviewed-by: Li Zefan <lizf@cn.fujitsu.com>
>     Cc: Martin K. Petersen <martin.petersen@oracle.com>
>     Cc: Kei Tokunaga <tokunaga.keiich@jp.fujitsu.com>
>     Cc: James Bottomley <James.Bottomley@suse.de>
>     Cc: Tomohiro Kusumi <kusumi.tomohiro@jp.fujitsu.com>
>     Cc: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
>     Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
> 
> diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
> index 53cffc0..45a8968 100644
> --- a/kernel/trace/trace_events.c
> +++ b/kernel/trace/trace_events.c
> @@ -29,6 +29,8 @@ DEFINE_MUTEX(event_mutex);
>  
>  LIST_HEAD(ftrace_events);
>  
> +#define COMMON_FIELD_COUNT	5
> +
>  struct list_head *
>  trace_get_fields(struct ftrace_event_call *event_call)
>  {
> @@ -544,85 +546,155 @@ out:
>  	return ret;
>  }
>  
> -static ssize_t
> -event_format_read(struct file *filp, char __user *ubuf, size_t cnt,
> -		  loff_t *ppos)
> +enum {
> +	FORMAT_HEADER		= 1,
> +	FORMAT_PRINTFMT		= 2,
> +};
> +
> +static void *f_next(struct seq_file *m, void *v, loff_t *pos)
>  {
> -	struct ftrace_event_call *call = filp->private_data;
> +	struct ftrace_event_call *call = m->private;
>  	struct ftrace_event_field *field;
>  	struct list_head *head;
> -	struct trace_seq *s;
> -	int common_field_count = 5;
> -	char *buf;
> -	int r = 0;
> -
> -	if (*ppos)
> -		return 0;
> +	loff_t index = *pos;
>  
> -	s = kmalloc(sizeof(*s), GFP_KERNEL);
> -	if (!s)
> -		return -ENOMEM;
> +	(*pos)++;
>  
> -	trace_seq_init(s);
> +	head = trace_get_fields(call);
>  
> -	trace_seq_printf(s, "name: %s\n", call->name);
> -	trace_seq_printf(s, "ID: %d\n", call->event.type);
> -	trace_seq_printf(s, "format:\n");
> +	switch ((unsigned long)v) {
> +	case FORMAT_HEADER:
>  
> -	head = trace_get_fields(call);
> -	list_for_each_entry_reverse(field, head, link) {
> -		/*
> -		 * Smartly shows the array type(except dynamic array).
> -		 * Normal:
> -		 *	field:TYPE VAR
> -		 * If TYPE := TYPE[LEN], it is shown:
> -		 *	field:TYPE VAR[LEN]
> -		 */
> -		const char *array_descriptor = strchr(field->type, '[');
> -
> -		if (!strncmp(field->type, "__data_loc", 10))
> -			array_descriptor = NULL;
> -
> -		if (!array_descriptor) {
> -			r = trace_seq_printf(s, "\tfield:%s %s;\toffset:%u;"
> -					"\tsize:%u;\tsigned:%d;\n",
> -					field->type, field->name, field->offset,
> -					field->size, !!field->is_signed);
> -		} else {
> -			r = trace_seq_printf(s, "\tfield:%.*s %s%s;\toffset:%u;"
> -					"\tsize:%u;\tsigned:%d;\n",
> -					(int)(array_descriptor - field->type),
> -					field->type, field->name,
> -					array_descriptor, field->offset,
> -					field->size, !!field->is_signed);
> -		}
> +		if (unlikely(list_empty(head)))
> +			return NULL;
>  
> -		if (--common_field_count == 0)
> -			r = trace_seq_printf(s, "\n");
> +		field = list_entry(head->prev, struct ftrace_event_field, link);
> +		return field;
>  
> -		if (!r)
> -			break;
> +	case FORMAT_PRINTFMT:
> +		/* all done */
> +		return NULL;
>  	}
>  
> -	if (r)
> -		r = trace_seq_printf(s, "\nprint fmt: %s\n",
> -				call->print_fmt);
> +	/*
> +	 * To separate common fields from event fields, the
> +	 * LSB is set on the first event field. Clear it in case.
> +	 */
> +	v = (void *)((unsigned long)v & ~1L);
>  
> -	if (!r) {
> -		/*
> -		 * ug!  The format output is bigger than a PAGE!!
> -		 */
> -		buf = "FORMAT TOO BIG\n";
> -		r = simple_read_from_buffer(ubuf, cnt, ppos,
> -					      buf, strlen(buf));
> -		goto out;
> +	field = v;
> +	if (field->link.prev == head)
> +		return (void *)FORMAT_PRINTFMT;
> +
> +	field = list_entry(field->link.prev, struct ftrace_event_field, link);
> +
> +	/* Set the LSB to notify f_show to print an extra newline */
> +	if (index == COMMON_FIELD_COUNT)
> +		field = (struct ftrace_event_field *)
> +			((unsigned long)field | 1);
> +
> +	return field;
> +}
> +
> +static void *f_start(struct seq_file *m, loff_t *pos)
> +{
> +	loff_t l = 0;
> +	void *p;
> +
> +	/* Start by showing the header */
> +	if (!*pos)
> +		return (void *)FORMAT_HEADER;
> +
> +	p = (void *)FORMAT_HEADER;
> +	do {
> +		p = f_next(m, p, &l);
> +	} while (p && l < *pos);
> +
> +	return p;
> +}
> +
> +static int f_show(struct seq_file *m, void *v)
> +{
> +	struct ftrace_event_call *call = m->private;
> +	struct ftrace_event_field *field;
> +	const char *array_descriptor;
> +
> +	switch ((unsigned long)v) {
> +	case FORMAT_HEADER:
> +		seq_printf(m, "name: %s\n", call->name);
> +		seq_printf(m, "ID: %d\n", call->event.type);
> +		seq_printf(m, "format:\n");
> +		return 0;
> +
> +	case FORMAT_PRINTFMT:
> +		seq_printf(m, "\nprint fmt: %s\n",
> +			   call->print_fmt);
> +		return 0;
>  	}
>  
> -	r = simple_read_from_buffer(ubuf, cnt, ppos,
> -				    s->buffer, s->len);
> - out:
> -	kfree(s);
> -	return r;
> +	/*
> +	 * To separate common fields from event fields, the
> +	 * LSB is set on the first event field. Clear it and
> +	 * print a newline if it is set.
> +	 */
> +	if ((unsigned long)v & 1) {
> +		seq_putc(m, '\n');
> +		v = (void *)((unsigned long)v & ~1L);
> +	}
> +
> +	field = v;
> +
> +	/*
> +	 * Smartly shows the array type(except dynamic array).
> +	 * Normal:
> +	 *	field:TYPE VAR
> +	 * If TYPE := TYPE[LEN], it is shown:
> +	 *	field:TYPE VAR[LEN]
> +	 */
> +	array_descriptor = strchr(field->type, '[');
> +
> +	if (!strncmp(field->type, "__data_loc", 10))
> +		array_descriptor = NULL;
> +
> +	if (!array_descriptor)
> +		seq_printf(m, "\tfield:%s %s;\toffset:%u;\tsize:%u;\tsigned:%d;\n",
> +			   field->type, field->name, field->offset,
> +			   field->size, !!field->is_signed);
> +	else
> +		seq_printf(m, "\tfield:%.*s %s%s;\toffset:%u;\tsize:%u;\tsigned:%d;\n",
> +			   (int)(array_descriptor - field->type),
> +			   field->type, field->name,
> +			   array_descriptor, field->offset,
> +			   field->size, !!field->is_signed);
> +
> +	return 0;
> +}
> +
> +static void f_stop(struct seq_file *m, void *p)
> +{
> +}
> +
> +static const struct seq_operations trace_format_seq_ops = {
> +	.start		= f_start,
> +	.next		= f_next,
> +	.stop		= f_stop,
> +	.show		= f_show,
> +};
> +
> +static int trace_format_open(struct inode *inode, struct file *file)
> +{
> +	struct ftrace_event_call *call = inode->i_private;
> +	struct seq_file *m;
> +	int ret;
> +
> +	ret = seq_open(file, &trace_format_seq_ops);
> +	if (ret < 0)
> +		return ret;
> +
> +	m = file->private_data;
> +	m->private = call;
> +
> +	return 0;
>  }
>  
>  static ssize_t
> @@ -820,8 +892,10 @@ static const struct file_operations ftrace_enable_fops = {
>  };
>  
>  static const struct file_operations ftrace_event_format_fops = {
> -	.open = tracing_open_generic,
> -	.read = event_format_read,
> +	.open = trace_format_open,
> +	.read = seq_read,
> +	.llseek = seq_lseek,
> +	.release = seq_release,
>  };
>  
>  static const struct file_operations ftrace_event_id_fops = {
> 
> 
> 
> 

