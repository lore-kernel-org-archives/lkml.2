Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754138Ab2GRL5L (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2012 07:57:11 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:48852 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751853Ab2GRL5J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2012 07:57:09 -0400
Date: Wed, 18 Jul 2012 13:57:03 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>
Cc: paulus@samba.org, a.p.zijlstra@chello.nl, linux-kernel@vger.kernel.org,
        mingo@redhat.com, emachado@linux.vnet.ibm.com, acme@ghostprotocols.net,
        prasad.krishnan@gmail.com
Subject: Re: [PATCH v2 RESEND] Hardware breakpoints: Invoke
 __perf_event_disable() if interrupts are already disabled
Message-ID: <20120718115700.GB6233@somewhere.redhat.com>
References: <20120706101653.7515.23309.stgit@localhost.localdomain>
 <20120718103046.7512.8326.stgit@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120718103046.7512.8326.stgit@localhost.localdomain>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 18, 2012 at 04:00:46PM +0530, Naveen N. Rao wrote:
> Please find v2 of the patch from Prasad, based on Peter Zijlstra's
> feedback. This applies on top of v3.5-rc7. This has been tested and
> found to work fine by Edjunior.
> 
> Regards,
> Naveen
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
> Signed-off-by: Naveen N. Rao <naveen.n.rao@linux.vnet.ibm.com>
> ---
>  include/linux/perf_event.h    |    2 ++
>  kernel/events/core.c          |    2 +-
>  kernel/events/hw_breakpoint.c |   10 +++++++++-
>  3 files changed, 12 insertions(+), 2 deletions(-)
> 
> diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
> index 45db49f..c289ba0 100644
> --- a/include/linux/perf_event.h
> +++ b/include/linux/perf_event.h
> @@ -1292,6 +1292,7 @@ extern int perf_swevent_get_recursion_context(void);
>  extern void perf_swevent_put_recursion_context(int rctx);
>  extern void perf_event_enable(struct perf_event *event);
>  extern void perf_event_disable(struct perf_event *event);
> +extern int __perf_event_disable(void *info);
>  extern void perf_event_task_tick(void);
>  #else
>  static inline void
> @@ -1330,6 +1331,7 @@ static inline int  perf_swevent_get_recursion_context(void)		{ return -1; }
>  static inline void perf_swevent_put_recursion_context(int rctx)		{ }
>  static inline void perf_event_enable(struct perf_event *event)		{ }
>  static inline void perf_event_disable(struct perf_event *event)		{ }
> +static inline int __perf_event_disable(void *info)			{ }
>  static inline void perf_event_task_tick(void)				{ }
>  #endif
>  
> diff --git a/kernel/events/core.c b/kernel/events/core.c
> index d7d71d6..0ad0fc9 100644
> --- a/kernel/events/core.c
> +++ b/kernel/events/core.c
> @@ -1253,7 +1253,7 @@ retry:
>  /*
>   * Cross CPU call to disable a performance event
>   */
> -static int __perf_event_disable(void *info)
> +int __perf_event_disable(void *info)
>  {
>  	struct perf_event *event = info;
>  	struct perf_event_context *ctx = event->ctx;
> diff --git a/kernel/events/hw_breakpoint.c b/kernel/events/hw_breakpoint.c
> index bb38c4d..483f14a 100644
> --- a/kernel/events/hw_breakpoint.c
> +++ b/kernel/events/hw_breakpoint.c
> @@ -453,7 +453,15 @@ int modify_user_hw_breakpoint(struct perf_event *bp, struct perf_event_attr *att
>  	int old_type = bp->attr.bp_type;
>  	int err = 0;
>  
> -	perf_event_disable(bp);
> +	/*
> +	 * modify_user_hw_breakpoint can be invoked with IRQs disabled and hence it
> +	 * will not be possible to raise IPIs that invoke __perf_event_disable.
> +	 * So call the function directly.
> +	 */
> +	if (irqs_disabled())
> +		__perf_event_disable(bp);
> +	else
> +		perf_event_disable(bp);

This only works if we are sure the bp is on the current CPU. Do we
have that guarantee?

>  
>  	bp->attr.bp_addr = attr->bp_addr;
>  	bp->attr.bp_type = attr->bp_type;
> 
