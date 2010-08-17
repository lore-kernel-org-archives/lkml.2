Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754429Ab0HQM6A (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Aug 2010 08:58:00 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:61277 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753129Ab0HQM57 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Aug 2010 08:57:59 -0400
X-Authority-Analysis: v=1.1 cv=mWMe3HXt1P3ELXxrmMgI9QKdSRnwjSxQbBh3ay0KAh4= c=1 sm=0 a=c1PsnirsPswA:10 a=Q9fys5e9bTEA:10 a=IXo+6rlC6z1XzBFn1RNpIA==:17 a=omOdbC7AAAAA:8 a=FVIerGIqPrdJkPS56NEA:9 a=GTC0x3jP4mdD5oxznWUA:7 a=_HIJCkXGof81LGDVwIc8sxloKcUA:4 a=PUjeQqilurYA:10 a=IXo+6rlC6z1XzBFn1RNpIA==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.87.39
Subject: Re: [PATCH] tracing: Simplify seqfile code for format file
From: Steven Rostedt <rostedt@goodmis.org>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <4C6A23C2.9020606@cn.fujitsu.com>
References: <4C6A23C2.9020606@cn.fujitsu.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Tue, 17 Aug 2010 08:57:56 -0400
Message-ID: <1282049876.3268.1292.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-08-17 at 13:53 +0800, Li Zefan wrote:
> We don't have to use the trick that marks a pointer's LSB to
> distinguish event fields from common fields.
> 

Hehe, you don't like tricks.  I find it as a certain art to the magic of
programming ;-)


> Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>

I'll pull this in and see if we can get this into 2.6.36 too.

Thanks!

-- Steve

> ---
>  kernel/trace/trace_events.c |   55 ++++++++++++++-----------------------------
>  1 files changed, 18 insertions(+), 37 deletions(-)
> 
> diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
> index 4c758f1..398c0e8 100644
> --- a/kernel/trace/trace_events.c
> +++ b/kernel/trace/trace_events.c
> @@ -600,21 +600,29 @@ out:
>  
>  enum {
>  	FORMAT_HEADER		= 1,
> -	FORMAT_PRINTFMT		= 2,
> +	FORMAT_FIELD_SEPERATOR	= 2,
> +	FORMAT_PRINTFMT		= 3,
>  };
>  
>  static void *f_next(struct seq_file *m, void *v, loff_t *pos)
>  {
>  	struct ftrace_event_call *call = m->private;
>  	struct ftrace_event_field *field;
> -	struct list_head *head;
> +	struct list_head *common_head = &ftrace_common_fields;
> +	struct list_head *head = trace_get_fields(call);
>  
>  	(*pos)++;
>  
>  	switch ((unsigned long)v) {
>  	case FORMAT_HEADER:
> -		head = &ftrace_common_fields;
> +		if (unlikely(list_empty(common_head)))
> +			return NULL;
> +
> +		field = list_entry(common_head->prev,
> +				   struct ftrace_event_field, link);
> +		return field;
>  
> +	case FORMAT_FIELD_SEPERATOR:
>  		if (unlikely(list_empty(head)))
>  			return NULL;
>  
> @@ -626,31 +634,10 @@ static void *f_next(struct seq_file *m, void *v, loff_t *pos)
>  		return NULL;
>  	}
>  
> -	head = trace_get_fields(call);
> -
> -	/*
> -	 * To separate common fields from event fields, the
> -	 * LSB is set on the first event field. Clear it in case.
> -	 */
> -	v = (void *)((unsigned long)v & ~1L);
> -
>  	field = v;
> -	/*
> -	 * If this is a common field, and at the end of the list, then
> -	 * continue with main list.
> -	 */
> -	if (field->link.prev == &ftrace_common_fields) {
> -		if (unlikely(list_empty(head)))
> -			return NULL;
> -		field = list_entry(head->prev, struct ftrace_event_field, link);
> -		/* Set the LSB to notify f_show to print an extra newline */
> -		field = (struct ftrace_event_field *)
> -			((unsigned long)field | 1);
> -		return field;
> -	}
> -
> -	/* If we are done tell f_show to print the format */
> -	if (field->link.prev == head)
> +	if (field->link.prev == common_head)
> +		return (void *)FORMAT_FIELD_SEPERATOR;
> +	else if (field->link.prev == head)
>  		return (void *)FORMAT_PRINTFMT;
>  
>  	field = list_entry(field->link.prev, struct ftrace_event_field, link);
> @@ -688,22 +675,16 @@ static int f_show(struct seq_file *m, void *v)
>  		seq_printf(m, "format:\n");
>  		return 0;
>  
> +	case FORMAT_FIELD_SEPERATOR:
> +		seq_putc(m, '\n');
> +		return 0;
> +
>  	case FORMAT_PRINTFMT:
>  		seq_printf(m, "\nprint fmt: %s\n",
>  			   call->print_fmt);
>  		return 0;
>  	}
>  
> -	/*
> -	 * To separate common fields from event fields, the
> -	 * LSB is set on the first event field. Clear it and
> -	 * print a newline if it is set.
> -	 */
> -	if ((unsigned long)v & 1) {
> -		seq_putc(m, '\n');
> -		v = (void *)((unsigned long)v & ~1L);
> -	}
> -
>  	field = v;
>  
>  	/*


