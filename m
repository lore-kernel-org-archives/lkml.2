Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758474Ab1EZUEw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 16:04:52 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:58759 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757836Ab1EZUEv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 16:04:51 -0400
X-Authority-Analysis: v=1.1 cv=y6zMVzRGPZqd+EkIbWgKRW0ZY5+85Abqc3bXR1aXymM= c=1 sm=0 a=Yc1t9-nblxEA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=1XWaLZrsAAAA:8 a=OufUfpwXtcHk7VmOb3YA:9 a=PUjeQqilurYA:10 a=UTB_XpHje0EA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH] trace: Set oom_score_adj to maximum for ring buffer
 allocating process
From: Steven Rostedt <rostedt@goodmis.org>
To: Vaibhav Nagarnaik <vnagarnaik@google.com>
Cc: Ingo Molnar <mingo@redhat.com>, Frederic Weisbecker <fweisbec@gmail.com>,
        Michael Rubin <mrubin@google.com>, David Sharp <dhsharp@google.com>,
        linux-kernel@vger.kernel.org
In-Reply-To: <1306439537-23706-1-git-send-email-vnagarnaik@google.com>
References: <1306439537-23706-1-git-send-email-vnagarnaik@google.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Thu, 26 May 2011 16:04:48 -0400
Message-ID: <1306440288.3857.9.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-05-26 at 12:52 -0700, Vaibhav Nagarnaik wrote:
> The tracing ring buffer is allocated from kernel memory. While
> allocating the memory, if OOM happens, the allocating process might not
> be the one that gets killed, since the ring-buffer memory is not
> allocated as process memory. Thus random processes might get killed
> during the allocation.
> 
> This patch makes sure that the allocating process is considered the most
> likely oom-kill-able process while the allocating is going on. Thus if
> oom-killer is invoked because of ring-buffer allocation, it is easier
> for the ring buffer memory to be freed and save important system
> processes from being killed.

Hmm, have you tried this in practice? Yes we may kill the "echo" command
but it doesn't stop the ring buffer from being allocated, and thus
killing the echo command may not be enough, and those critical processes
that you are trying to protect will be killed next.

Perhaps we should change the allocation of the ring buffer or detect OOM
triggering. Maybe make all the allocations ATOMIC, thus it will be
either available or not, and fail instead of trying to swap out other
memory for the allocation.

-- Steve

> 
> Signed-off-by: Vaibhav Nagarnaik <vnagarnaik@google.com>
> ---
>  kernel/trace/trace.c |    9 +++++++++
>  1 files changed, 9 insertions(+), 0 deletions(-)
> 
> diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
> index b926578..15a667a 100644
> --- a/kernel/trace/trace.c
> +++ b/kernel/trace/trace.c
> @@ -37,6 +37,7 @@
>  #include <linux/init.h>
>  #include <linux/poll.h>
>  #include <linux/fs.h>
> +#include <linux/oom.h>
>  
>  #include "trace.h"
>  #include "trace_output.h"
> @@ -3498,6 +3499,7 @@ tracing_entries_write(struct file *filp, const char __user *ubuf,
>  	unsigned long val;
>  	char buf[64];
>  	int ret;
> +	int oom_score_adj;
>  
>  	if (cnt >= sizeof(buf))
>  		return -EINVAL;
> @@ -3518,7 +3520,14 @@ tracing_entries_write(struct file *filp, const char __user *ubuf,
>  	/* value is in KB */
>  	val <<= 10;
>  
> +	/*
> +	 * make sure this process is picked over others to be killed in OOM
> +	 * condition
> +	 */
> +	oom_score_adj = test_set_oom_score_adj(OOM_SCORE_ADJ_MAX);
>  	ret = tracing_resize_ring_buffer(val);
> +	/* restore the original oom_score_adj value */
> +	test_set_oom_score_adj(oom_score_adj);
>  	if (ret < 0)
>  		return ret;
>  


