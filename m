Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755753Ab0E1TQt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 May 2010 15:16:49 -0400
Received: from cobra.newdream.net ([66.33.216.30]:42019 "EHLO
	cobra.newdream.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754783Ab0E1TQr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 May 2010 15:16:47 -0400
Date: Fri, 28 May 2010 12:16:50 -0700 (PDT)
From: Sage Weil <sage@newdream.net>
To: linux-kernel@vger.kernel.org, mingo@elte.hu, peterz@infradead.org,
       andreas.herrmann3@amd.com, tglx@linutronix.de, efault@gmx.de
cc: akpm@linux-foundation.org
Subject: Re: [PATCH] sched: add wait_for_completion_killable_timeout
In-Reply-To: <Pine.LNX.4.64.1005241129500.1745@cobra.newdream.net>
Message-ID: <Pine.LNX.4.64.1005281214390.2828@cobra.newdream.net>
References: <Pine.LNX.4.64.1005241129500.1745@cobra.newdream.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi-

Do I need an ACK on this, or should I just send this to Linus with the 
Ceph fix?  It's a pretty trivial fixup.

Thanks-
sage


On Mon, 24 May 2010, Sage Weil wrote:

> Hi guys,
> 
> I need this patch (or something similar) to fix an issue with the way Ceph 
> is waiting for MDS requests to complete.  I'm assuming there's no specific 
> reason the _killable_timeout variant was excluded?  Can this go into .35?
> 
> Thanks-
> sage
> 
> ---
> 
> From 1ae82e511ba1664691380ea5c630a94eec370166 Mon Sep 17 00:00:00 2001
> From: Sage Weil <sage@newdream.net>
> Date: Mon, 24 May 2010 11:12:42 -0700
> Subject: [PATCH] sched: add wait_for_completion_killable_timeout
> 
> Add missing _killable_timeout variant for wait_for_completion that will
> return when a timeout expires or the task is killed.
> 
> CC: Ingo Molnar <mingo@elte.hu>
> CC: Peter Zijlstra <peterz@infradead.org>
> CC: Andreas Herrmann <andreas.herrmann3@amd.com>
> CC: Thomas Gleixner <tglx@linutronix.de>
> CC: Mike Galbraith <efault@gmx.de>
> Signed-off-by: Sage Weil <sage@newdream.net>
> ---
>  include/linux/completion.h |    2 ++
>  kernel/sched.c             |   17 +++++++++++++++++
>  2 files changed, 19 insertions(+), 0 deletions(-)
> 
> diff --git a/include/linux/completion.h b/include/linux/completion.h
> index 4a6b604..51e3145 100644
> --- a/include/linux/completion.h
> +++ b/include/linux/completion.h
> @@ -83,6 +83,8 @@ extern unsigned long wait_for_completion_timeout(struct completion *x,
>  						   unsigned long timeout);
>  extern unsigned long wait_for_completion_interruptible_timeout(
>  			struct completion *x, unsigned long timeout);
> +extern unsigned long wait_for_completion_killable_timeout(
> +			struct completion *x, unsigned long timeout);
>  extern bool try_wait_for_completion(struct completion *x);
>  extern bool completion_done(struct completion *x);
>  
> diff --git a/kernel/sched.c b/kernel/sched.c
> index 3c2a54f..4d051c7 100644
> --- a/kernel/sched.c
> +++ b/kernel/sched.c
> @@ -4161,6 +4161,23 @@ int __sched wait_for_completion_killable(struct completion *x)
>  EXPORT_SYMBOL(wait_for_completion_killable);
>  
>  /**
> + * wait_for_completion_killable_timeout: - waits for completion of a task (w/(to,killable))
> + * @x:  holds the state of this particular completion
> + * @timeout:  timeout value in jiffies
> + *
> + * This waits for either a completion of a specific task to be
> + * signaled or for a specified timeout to expire. It can be
> + * interrupted by a kill signal. The timeout is in jiffies.
> + */
> +unsigned long __sched
> +wait_for_completion_killable_timeout(struct completion *x,
> +				     unsigned long timeout)
> +{
> +	return wait_for_common(x, timeout, TASK_KILLABLE);
> +}
> +EXPORT_SYMBOL(wait_for_completion_killable_timeout);
> +
> +/**
>   *	try_wait_for_completion - try to decrement a completion without blocking
>   *	@x:	completion structure
>   *
> -- 
> 1.7.0
> 
> 
