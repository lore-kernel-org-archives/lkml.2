Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755846Ab1EDVWF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 May 2011 17:22:05 -0400
Received: from smtp-out.google.com ([74.125.121.67]:45859 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753551Ab1EDVWD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 May 2011 17:22:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=bsfyQ8WVZFGDgXPSvdVYVaAbDNviNUx2PRegU+DUxAd36LaqkxDdmFV+oB8GYKtFpN
         QdLXtxCScFM7yGLj104A==
MIME-Version: 1.0
In-Reply-To: <1304467520-31530-1-git-send-email-vnagarnaik@google.com>
References: <1304467520-31530-1-git-send-email-vnagarnaik@google.com>
From: Vaibhav Nagarnaik <vnagarnaik@google.com>
Date: Wed, 4 May 2011 14:21:28 -0700
Message-ID: <BANLkTimorXOLcvB2dwXMAH8n2UU-C2ntcA@mail.gmail.com>
Subject: Re: [PATCH] trace: Check for waiting readers before calling wakeup()
To: Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>
Cc: Michael Rubin <mrubin@google.com>, David Sharp <dhsharp@google.com>,
        linux-kernel@vger.kernel.org,
        Vaibhav Nagarnaik <vnagarnaik@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Steven, Frederic

Does this patch look ok?



Vaibhav Nagarnaik



On Tue, May 3, 2011 at 5:05 PM, Vaibhav Nagarnaik <vnagarnaik@google.com> wrote:
> In using syscall tracing by concurrent processes, the wakeup() that is
> called in the event commit function causes contention on the spin lock
> of the waitqueue. I enabled sys_enter_getuid and sys_exit_getuid
> tracepoints, and by running getuid_microbench from autotest in parallel
> I found that the contention causes exponential latency increase in the
> tracing path.
>
> The autotest binary getuid_microbench calls getuid() in a tight loop for
> the given number of iterations and measures the average time required to
> complete a single invocation of syscall.
>
> The patch checks if there are any readers waiting in the waitqueue
> before the queue is locked. This reduces any contention and the
> latencies associated with it when there are no readers in the queue.
>
> In the following example, the script enables the sys_enter_getuid and
> sys_exit_getuid tracepoints and runs the getuid_microbench in parallel
> with the given number of processes. The output clearly shows the latency
> increase caused by contentions.
>
> $ ~/getuid.sh 1
> 1000000 calls in 0.720974253 s (720.974253 ns/call)
>
> $ ~/getuid.sh 2
> 1000000 calls in 1.166457554 s (1166.457554 ns/call)
> 1000000 calls in 1.168933765 s (1168.933765 ns/call)
>
> $ ~/getuid.sh 3
> 1000000 calls in 1.783827516 s (1783.827516 ns/call)
> 1000000 calls in 1.795553270 s (1795.553270 ns/call)
> 1000000 calls in 1.796493376 s (1796.493376 ns/call)
>
> $ ~/getuid.sh 4
> 1000000 calls in 4.483041796 s (4483.041796 ns/call)
> 1000000 calls in 4.484165388 s (4484.165388 ns/call)
> 1000000 calls in 4.484850762 s (4484.850762 ns/call)
> 1000000 calls in 4.485643576 s (4485.643576 ns/call)
>
> $ ~/getuid.sh 5
> 1000000 calls in 6.497521653 s (6497.521653 ns/call)
> 1000000 calls in 6.502000236 s (6502.000236 ns/call)
> 1000000 calls in 6.501709115 s (6501.709115 ns/call)
> 1000000 calls in 6.502124100 s (6502.124100 ns/call)
> 1000000 calls in 6.502936358 s (6502.936358 ns/call)
>
> After the patch, the latencies scale well and are exactly as expected.
> $ ~/getuid.sh 1
> 1000000 calls in 0.626811320 s (626.811320 ns/call)
>
> $ ~/getuid.sh 2
> 1000000 calls in 0.616566144 s (616.566144 ns/call)
> 1000000 calls in 0.622712754 s (622.712754 ns/call)
>
> $ ~/getuid.sh 3
> 1000000 calls in 0.602886676 s (602.886676 ns/call)
> 1000000 calls in 0.612168691 s (612.168691 ns/call)
> 1000000 calls in 0.623516009 s (623.516009 ns/call)
>
> $ ~/getuid.sh 4
> 1000000 calls in 0.614037455 s (614.037455 ns/call)
> 1000000 calls in 0.615070842 s (615.070842 ns/call)
> 1000000 calls in 0.615051941 s (615.051941 ns/call)
> 1000000 calls in 0.621556902 s (621.556902 ns/call)
>
> $ ~/getuid.sh 5
> 1000000 calls in 0.605297117 s (605.297117 ns/call)
> 1000000 calls in 0.609545095 s (609.545095 ns/call)
> 1000000 calls in 0.610305369 s (610.305369 ns/call)
> 1000000 calls in 0.614056014 s (614.056014 ns/call)
> 1000000 calls in 0.622048279 s (622.048279 ns/call)
>
> Signed-off-by: Vaibhav Nagarnaik <vnagarnaik@google.com>
> Acked-by: Frederic Weisbecker <fweisbec@gmail.com>
> ---
>  kernel/trace/trace.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
> index 06f4458..e03ee24 100644
> --- a/kernel/trace/trace.c
> +++ b/kernel/trace/trace.c
> @@ -353,7 +353,7 @@ void trace_wake_up(void)
>  {
>        int cpu;
>
> -       if (trace_flags & TRACE_ITER_BLOCK)
> +       if (trace_flags & TRACE_ITER_BLOCK || !waitqueue_active(&trace_wait))
>                return;
>        /*
>         * The runqueue_is_locked() can fail, but this is the best we
> --
> 1.7.3.1
>
>
