Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756062Ab2HORiX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 13:38:23 -0400
Received: from e28smtp01.in.ibm.com ([122.248.162.1]:34478 "EHLO
	e28smtp01.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755976Ab2HORiW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 13:38:22 -0400
Message-ID: <502BDE3D.6070909@linux.vnet.ibm.com>
Date: Wed, 15 Aug 2012 23:07:01 +0530
From: "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: fweisbec@gmail.com
CC: a.p.zijlstra@chello.nl, prasad.krishnan@gmail.com,
        linux-kernel@vger.kernel.org, mingo@redhat.com, paulus@samba.org,
        acme@ghostprotocols.net, emachado@linux.vnet.ibm.com
Subject: Re: [PATCH v3] Hardware breakpoints: Invoke __perf_event_disable()
 if interrupts are already disabled
References: <20120731134124.GD17078@somewhere.redhat.com> <20120802081635.5811.17737.stgit@localhost.localdomain>
In-Reply-To: <20120802081635.5811.17737.stgit@localhost.localdomain>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
x-cbid: 12081517-4790-0000-0000-00000425FE58
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Frederick,
Did you get a chance to take a look at this?

Regards,
Naveen

On 08/02/2012 01:46 PM, Naveen N. Rao wrote:
> Hi Frederick,
> I've added a check to make sure we are targeting the current task. This
> applies on top of v3.5. Kindly review.
>
> Thanks,
> Naveen
>
> History:
> v3: Added check to make sure we only target "current" task.
> v2: Use __perf_event_disable() directly
> ______
>
> From: K.Prasad <Prasad.Krishnan@gmail.com>
>
> While debugging a warning message on PowerPC while using hardware
> breakpoints, it was discovered that when perf_event_disable is invoked
> through hw_breakpoint_handler function with interrupts disabled, a
> subsequent IPI in the code path would trigger a WARN_ON_ONCE message in
> smp_call_function_single function.
>
> This patch calls __perf_event_disable() when interrupts are already
> disabled, instead of perf_event_disable().
>
> Reported-by: Edjunior Barbosa Machado <emachado@linux.vnet.ibm.com>
> Signed-off-by: K.Prasad <Prasad.Krishnan@gmail.com>
> [naveen.n.rao@linux.vnet.ibm.com: v3: Check to make sure we target current task]
> Signed-off-by: Naveen N. Rao <naveen.n.rao@linux.vnet.ibm.com>
> ---
>   include/linux/perf_event.h    |    2 ++
>   kernel/events/core.c          |    2 +-
>   kernel/events/hw_breakpoint.c |   11 ++++++++++-
>   3 files changed, 13 insertions(+), 2 deletions(-)
>
> diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
> index 45db49f..c289ba0 100644
> --- a/include/linux/perf_event.h
> +++ b/include/linux/perf_event.h
> @@ -1292,6 +1292,7 @@ extern int perf_swevent_get_recursion_context(void);
>   extern void perf_swevent_put_recursion_context(int rctx);
>   extern void perf_event_enable(struct perf_event *event);
>   extern void perf_event_disable(struct perf_event *event);
> +extern int __perf_event_disable(void *info);
>   extern void perf_event_task_tick(void);
>   #else
>   static inline void
> @@ -1330,6 +1331,7 @@ static inline int  perf_swevent_get_recursion_context(void)		{ return -1; }
>   static inline void perf_swevent_put_recursion_context(int rctx)		{ }
>   static inline void perf_event_enable(struct perf_event *event)		{ }
>   static inline void perf_event_disable(struct perf_event *event)		{ }
> +static inline int __perf_event_disable(void *info)			{ }
>   static inline void perf_event_task_tick(void)				{ }
>   #endif
>
> diff --git a/kernel/events/core.c b/kernel/events/core.c
> index d7d71d6..0ad0fc9 100644
> --- a/kernel/events/core.c
> +++ b/kernel/events/core.c
> @@ -1253,7 +1253,7 @@ retry:
>   /*
>    * Cross CPU call to disable a performance event
>    */
> -static int __perf_event_disable(void *info)
> +int __perf_event_disable(void *info)
>   {
>   	struct perf_event *event = info;
>   	struct perf_event_context *ctx = event->ctx;
> diff --git a/kernel/events/hw_breakpoint.c b/kernel/events/hw_breakpoint.c
> index bb38c4d..9a7b487 100644
> --- a/kernel/events/hw_breakpoint.c
> +++ b/kernel/events/hw_breakpoint.c
> @@ -453,7 +453,16 @@ int modify_user_hw_breakpoint(struct perf_event *bp, struct perf_event_attr *att
>   	int old_type = bp->attr.bp_type;
>   	int err = 0;
>
> -	perf_event_disable(bp);
> +	/*
> +	 * modify_user_hw_breakpoint can be invoked with IRQs disabled and hence it
> +	 * will not be possible to raise IPIs that invoke __perf_event_disable.
> +	 * So call the function directly after making sure we are targeting the
> +	 * current task.
> +	 */
> +	if (irqs_disabled() && bp->ctx && bp->ctx->task == current)
> +		__perf_event_disable(bp);
> +	else
> +		perf_event_disable(bp);
>
>   	bp->attr.bp_addr = attr->bp_addr;
>   	bp->attr.bp_type = attr->bp_type;
>

