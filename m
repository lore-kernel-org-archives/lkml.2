Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762071Ab0HFUjC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Aug 2010 16:39:02 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:60107 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762042Ab0HFUi6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Aug 2010 16:38:58 -0400
X-Authority-Analysis: v=1.1 cv=iAgpuTQS0MLtLwMsZiCHuoBwPeqvJBBqRrgqCYgBu0I= c=1 sm=0 a=vMBlIDAt6S4A:10 a=Q9fys5e9bTEA:10 a=IXo+6rlC6z1XzBFn1RNpIA==:17 a=pGLkceISAAAA:8 a=meVymXHHAAAA:8 a=20KFwNOVAAAA:8 a=B1BknRpORHdQTdHxPEcA:9 a=E-CkAu8Vplo-6YxqupgWo32ACXIA:4 a=PUjeQqilurYA:10 a=MSl-tDqOz04A:10 a=jeBq3FmKZ4MA:10 a=jEp0ucaQiEUA:10 a=IXo+6rlC6z1XzBFn1RNpIA==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.87.39
Subject: Re: [PATCH] tracing: wake up tasks reading trace_pipe on write to
 trace_marker
From: Steven Rostedt <rostedt@goodmis.org>
To: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>
In-Reply-To: <20100727224408.GB4142@joi.lan>
References: <20100727224408.GB4142@joi.lan>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Fri, 06 Aug 2010 16:38:56 -0400
Message-ID: <1281127136.3352.13.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-07-28 at 00:44 +0200, Marcin Slusarz wrote:
> Currently we rely on other code periodically waking up trace reader.
> If there aren't any other data than markers, reader will never be woken up.
> Fix it.
> 
> Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
> Cc: Steven Rostedt <rostedt@goodmis.org>
> Cc: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Ingo Molnar <mingo@redhat.com>
> ---
>  kernel/trace/trace.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
> index 086d363..02e04c8 100644
> --- a/kernel/trace/trace.c
> +++ b/kernel/trace/trace.c
> @@ -1520,6 +1520,7 @@ int trace_array_vprintk(struct trace_array *tr,
>  	if (!filter_check_discard(call, entry, buffer, event)) {
>  		ring_buffer_unlock_commit(buffer, event);
>  		ftrace_trace_stack(buffer, irq_flags, 6, pc);
> +		trace_wake_up();
>  	}
>  

This can't work. trace_printk() and friends must be able to be used
anywhere. This can cause race conditions with the rq locks in the
scheduler.

But you do bring up a good idea. That is, perhaps we should have a way
to attach to known safe tracepoints that we can hook to to check if a
wake up should happen or not.

-- Steve


