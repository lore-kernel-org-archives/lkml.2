Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752565Ab1G2SBG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jul 2011 14:01:06 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:46615 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752473Ab1G2SBE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jul 2011 14:01:04 -0400
X-Authority-Analysis: v=1.1 cv=sbbt6Wn8j+VvNVI1Ftt/uHhinWyuFt+R57MN9Ty2Tys= c=1 sm=0 a=myIctBItyH8A:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=1XWaLZrsAAAA:8 a=domA9NewP54s3fvequsA:9 a=PUjeQqilurYA:10 a=UTB_XpHje0EA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH 1/5] trace: Add a new readonly entry to report total
 buffer size
From: Steven Rostedt <rostedt@goodmis.org>
To: Vaibhav Nagarnaik <vnagarnaik@google.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@redhat.com>,
        Michael Rubin <mrubin@google.com>, David Sharp <dhsharp@google.com>,
        linux-kernel@vger.kernel.org
In-Reply-To: <1311721194-12164-2-git-send-email-vnagarnaik@google.com>
References: <1311721194-12164-1-git-send-email-vnagarnaik@google.com>
	 <1311721194-12164-2-git-send-email-vnagarnaik@google.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Fri, 29 Jul 2011 14:01:03 -0400
Message-ID: <1311962463.21143.70.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-07-26 at 15:59 -0700, Vaibhav Nagarnaik wrote:
> The current file "buffer_size_kb" reports the size of per-cpu buffer and
> not the overall memory allocated which could be misleading. A new file
> "buffer_total_size_kb" adds up all the enabled CPU buffer sizes and
> reports it. This is only a readonly entry.
> 
> Signed-off-by: Vaibhav Nagarnaik <vnagarnaik@google.com>
> ---
>  kernel/trace/trace.c |   27 +++++++++++++++++++++++++++
>  1 files changed, 27 insertions(+), 0 deletions(-)
> 
> diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
> index e5df02c..ce57c55 100644
> --- a/kernel/trace/trace.c
> +++ b/kernel/trace/trace.c
> @@ -3569,6 +3569,24 @@ tracing_entries_write(struct file *filp, const char __user *ubuf,
>  }
>  
>  static ssize_t
> +tracing_total_entries_read(struct file *filp, char __user *ubuf,
> +				size_t cnt, loff_t *ppos)
> +{
> +	struct trace_array *tr = filp->private_data;
> +	char buf[64];
> +	int r, cpu;
> +	unsigned long size = 0;
> +
> +	mutex_lock(&trace_types_lock);
> +	for_each_tracing_cpu(cpu)
> +		size += tr->entries >> 10;

Could you make this consistent with buffer_size_kb as well. That is, if
the buffer is "shrunk", could you have the expanded size printed as
well.

Thanks,

-- Steve

> +	mutex_unlock(&trace_types_lock);
> +
> +	r = sprintf(buf, "%lu\n", size);
> +	return simple_read_from_buffer(ubuf, cnt, ppos, buf, r);
> +}
> +
> +static ssize_t
>  tracing_free_buffer_write(struct file *filp, const char __user *ubuf,
>  			  size_t cnt, loff_t *ppos)
>  {
> @@ -3739,6 +3757,12 @@ static const struct file_operations tracing_entries_fops = {
>  	.llseek		= generic_file_llseek,
>  };
>  
> +static const struct file_operations tracing_total_entries_fops = {
> +	.open		= tracing_open_generic,
> +	.read		= tracing_total_entries_read,
> +	.llseek		= generic_file_llseek,
> +};
> +
>  static const struct file_operations tracing_free_buffer_fops = {
>  	.write		= tracing_free_buffer_write,
>  	.release	= tracing_free_buffer_release,
> @@ -4450,6 +4474,9 @@ static __init int tracer_init_debugfs(void)
>  	trace_create_file("buffer_size_kb", 0644, d_tracer,
>  			&global_trace, &tracing_entries_fops);
>  
> +	trace_create_file("buffer_total_size_kb", 0444, d_tracer,
> +			&global_trace, &tracing_total_entries_fops);
> +
>  	trace_create_file("free_buffer", 0644, d_tracer,
>  			&global_trace, &tracing_free_buffer_fops);
>  


