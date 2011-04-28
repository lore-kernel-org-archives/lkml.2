Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758055Ab1D1Xcp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Apr 2011 19:32:45 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:51225 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755121Ab1D1Xcn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Apr 2011 19:32:43 -0400
X-Authority-Analysis: v=1.1 cv=qyUSAyc82z9xLljZQc9ErY9Tl2GSEfqK/XYZS35I9d8= c=1 sm=0 a=vVy0PQ3ZQx8A:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=1XWaLZrsAAAA:8 a=xNvEIowLiOScly9nvtkA:9 a=PUjeQqilurYA:10 a=UTB_XpHje0EA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH] trace: Add a free on close control mechanism for
 buffer_size_kb
From: Steven Rostedt <rostedt@goodmis.org>
To: Vaibhav Nagarnaik <vnagarnaik@google.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@redhat.com>,
        linux-kernel@vger.kernel.org, Michael Rubin <mrubin@google.com>,
        David Sharp <dhsharp@google.com>
In-Reply-To: <1303512373-25992-1-git-send-email-vnagarnaik@google.com>
References: <1303512373-25992-1-git-send-email-vnagarnaik@google.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Thu, 28 Apr 2011 19:32:41 -0400
Message-ID: <1304033561.18763.212.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry, my mind has been elsewhere and I forgot about your patches.

On Fri, 2011-04-22 at 15:46 -0700, Vaibhav Nagarnaik wrote:
> The proc file entry buffer_size_kb is used to set the size of tracing
> buffer. The memory to expand the buffer size is kernel memory. Consider
> a use case where tracing is handled by a user space utility, which acts
> as a gate keeper for tracing requests. In an OOM condition, tracing is
> considered a low priority task and if the utility gets killed the ring
> buffer memory cannot be released back to the kernel.
> 
> This patch adds an IOCTL on the buffer_size_kb file to set a boolean.
> When this boolean is enabled, closing buffer_size_kb file will cause
> tracing to stop and free up the ring buffer memory.
> 
> The user space process can then open the buffer_size_kb file to set the
> new buffer size for tracing, enable the boolean through IOCTL and keep
> the file open. Under OOM condition, if the process gets killed, the
> kernel closes the file descriptor for buffer_size_kb. The release
> handler stops the tracing and releases the kernel memory automatically.
> 
> Signed-off-by: Vaibhav Nagarnaik <vnagarnaik@google.com>
> ---
>  include/linux/ftrace.h |    3 +
>  kernel/trace/trace.c   |  135 ++++++++++++++++++++++++++++++++++++------------
>  2 files changed, 105 insertions(+), 33 deletions(-)
> 
> diff --git a/include/linux/ftrace.h b/include/linux/ftrace.h
> index ca29e03..30c8a23 100644
> --- a/include/linux/ftrace.h
> +++ b/include/linux/ftrace.h
> @@ -114,6 +114,9 @@ struct ftrace_func_command {
>  					char *params, int enable);
>  };
>  
> +/* enable/disable auto free ring buffer on file close */
> +#define TRACE_RINGBUF_FREE_ON_CLOSE _IOW('t', 0x01, int)
> +
>  #ifdef CONFIG_DYNAMIC_FTRACE
>  
>  int ftrace_arch_code_modify_prepare(void);
> diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
> index d38c16a..c676f17 100644
> --- a/kernel/trace/trace.c
> +++ b/kernel/trace/trace.c
> @@ -2817,6 +2817,42 @@ static int tracing_resize_ring_buffer(unsigned long size)
>  	return ret;
>  }
>  
> +static ssize_t tracing_buffer_resize_atomic(unsigned long size)

Why call it "atomic"? Because you do the mutex? Anyway I hate the name.
It sounds like it can do it without preemption, which it clearly can't
do.

The rest looks fine to me.

-- Steve

> +{
> +	int cpu, ret = 0;
> +
> +	mutex_lock(&trace_types_lock);
> +
> +	tracing_stop();
> +
> +	/* disable all cpu buffers */
> +	for_each_tracing_cpu(cpu) {
> +		if (global_trace.data[cpu])
> +			atomic_inc(&global_trace.data[cpu]->disabled);
> +		if (max_tr.data[cpu])
> +			atomic_inc(&max_tr.data[cpu]->disabled);
> +	}
> +
> +	if (size != global_trace.entries)
> +		ret = tracing_resize_ring_buffer(size);
> +
> +	/* If check pages failed, return ENOMEM */
> +	if (tracing_disabled)
> +		ret = -ENOMEM;
> +
> +	for_each_tracing_cpu(cpu) {
> +		if (global_trace.data[cpu])
> +			atomic_dec(&global_trace.data[cpu]->disabled);
> +		if (max_tr.data[cpu])
> +			atomic_dec(&max_tr.data[cpu]->disabled);
> +	}
> +
> +	tracing_start();
> +	mutex_unlock(&trace_types_lock);
> +
> +	return ret;
> +}
> +
>  


