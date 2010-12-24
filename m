Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753319Ab0LXEpq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Dec 2010 23:45:46 -0500
Received: from novprvoes0310.provo.novell.com ([137.65.248.74]:49015 "EHLO
	novprvoes0310.provo.novell.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752601Ab0LXEpp convert rfc822-to-8bit
	(ORCPT <rfc822;groupwise-ghaskins@novell.com:7:1>);
	Thu, 23 Dec 2010 23:45:45 -0500
Message-Id: <4D13DF250200005A000793E1@novprvoes0310.provo.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.2 
Date: Thu, 23 Dec 2010 21:45:41 -0700
From: "Gregory Haskins" <ghaskins@novell.com>
To: "Steven Rostedt" <rostedt@goodmis.org>, <linux-kernel@vger.kernel.org>
Cc: "Lai Jiangshan" <laijs@cn.fujitsu.com>, "Ingo Molnar" <mingo@elte.hu>,
        "Peter Zijlstra" <peterz@infradead.org>,
        "Thomas Gleixner" <tglx@linutronix.de>,
        "Peter Morreale" <PMorreale@novell.com>
Subject: Re: [RFC][RT][PATCH 3/4] rtmutex: Revert Optimize rt lock
 wakeup
References: <20101223224755.078983538@goodmis.org>
 <20101223225116.729981172@goodmis.org>
In-Reply-To: <20101223225116.729981172@goodmis.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Steve,

>>> On 12/23/2010 at 05:47 PM, in message <20101223225116.729981172@goodmis.org>,
Steven Rostedt <rostedt@goodmis.org> wrote: 
> From: Steven Rostedt <srostedt@redhat.com>
> 
> The commit: rtmutex: Optimize rt lock wakeup
> 
> Does not do what it was suppose to do.
> This is because the adaptive waiter sets its state to TASK_(UN)INTERRUPTIBLE
> before going into the loop. Thus, the test in wakeup_next_waiter()
> will always fail on an adaptive waiter, as it only tests to see if
> the pending waiter never has its state set ot TASK_RUNNING unless
> something else had woke it up.
> 
> The smp_mb() added to make this test work is just as expensive as
> just calling wakeup. And since we we fail to wake up anyway, we are
> doing both a smp_mb() and wakeup as well.
> 
> I tested this with dbench and we run faster without this patch.
> I also tried a variant that instead fixed the loop, to change the state
> only if the spinner was to go to sleep, and that still did not show
> any improvement.

Just a quick note to say I am a bit skeptical of this patch.  I know you are offline next week, so lets plan on hashing it out after the new year before I ack it.

Happy holidays!
-Greg

> 
> Cc: Gregory Haskins <ghaskins@novell.com>
> Cc: Peter Morreale <pmorreale@novell.com>
> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
> ---
>  kernel/rtmutex.c |   29 ++---------------------------
>  1 files changed, 2 insertions(+), 27 deletions(-)
> 
> diff --git a/kernel/rtmutex.c b/kernel/rtmutex.c
> index 318d7ed..e218873 100644
> --- a/kernel/rtmutex.c
> +++ b/kernel/rtmutex.c
> @@ -554,33 +554,8 @@ static void wakeup_next_waiter(struct rt_mutex *lock, 
> int savestate)
>  	 */
>  	if (!savestate)
>  		wake_up_process(pendowner);
> -	else {
> -		/*
> -		 * We can skip the actual (expensive) wakeup if the
> -		 * waiter is already running, but we have to be careful
> -		 * of race conditions because they may be about to sleep.
> -		 *
> -		 * The waiter-side protocol has the following pattern:
> -		 * 1: Set state != RUNNING
> -		 * 2: Conditionally sleep if waiter->task != NULL;
> -		 *
> -		 * And the owner-side has the following:
> -		 * A: Set waiter->task = NULL
> -		 * B: Conditionally wake if the state != RUNNING
> -		 *
> -		 * As long as we ensure 1->2 order, and A->B order, we
> -		 * will never miss a wakeup.
> -		 *
> -		 * Therefore, this barrier ensures that waiter->task = NULL
> -		 * is visible before we test the pendowner->state.  The
> -		 * corresponding barrier is in the sleep logic.
> -		 */
> -		smp_mb();
> -
> -		/* If !RUNNING && !RUNNING_MUTEX */
> -		if (pendowner->state & ~TASK_RUNNING_MUTEX)
> -			wake_up_process_mutex(pendowner);
> -	}
> +	else
> +		wake_up_process_mutex(pendowner);
>  
>  	rt_mutex_set_owner(lock, pendowner, RT_MUTEX_OWNER_PENDING);
>  




