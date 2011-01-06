Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752930Ab1AFOud (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jan 2011 09:50:33 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:52448 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752749Ab1AFOub (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jan 2011 09:50:31 -0500
X-Authority-Analysis: v=1.1 cv=3uSaImBeuprzHBlOOPjkqgu+7PcxSRW0m2Aphm9Zmck= c=1 sm=0 a=heD8I4ohhdAA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=av4WBNzuu8Z6U8Y6z_AA:9 a=5bAS6N_gUttju-nA5RMA:7 a=WjcSpfcBY6eQGYxjLxUjUm9DYo8A:4 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH] rtmutex: ensure only the top waiter or higher priority
 task can take the lock and reduce unrelated boosting
From: Steven Rostedt <rostedt@goodmis.org>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dave Young <hidave.darkstar@gmail.com>,
        Darren Hart <dvhart@linux.intel.com>,
        Namhyung Kim <namhyung@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
In-Reply-To: <4D0877D2.10000@cn.fujitsu.com>
References: <4D07330A.7020600@cn.fujitsu.com>
	 <alpine.LFD.2.00.1012141850460.12146@localhost6.localdomain6>
	 <4D083900.1050801@cn.fujitsu.com>
	 <1292386606.5015.1862.camel@gandalf.stny.rr.com>
	 <4D0877D2.10000@cn.fujitsu.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Thu, 06 Jan 2011 09:50:28 -0500
Message-ID: <1294325428.26623.187.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-12-15 at 16:09 +0800, Lai Jiangshan wrote:

>  kernel/futex.c          |   26 +---
>  kernel/rtmutex.c        |  306 ++++++++++++++++--------------------------------
>  kernel/rtmutex_common.h |   16 --
>  3 files changed, 116 insertions(+), 232 deletions(-)
> 
> diff --git a/kernel/futex.c b/kernel/futex.c
> index 6c683b3..5f4ea5f 100644
> --- a/kernel/futex.c
> +++ b/kernel/futex.c
> @@ -775,18 +775,10 @@ static int wake_futex_pi(u32 __user *uaddr, u32 uval, struct futex_q *this)
>  		return -EINVAL;
>  
>  	raw_spin_lock(&pi_state->pi_mutex.wait_lock);
> +	/* set new owner to the most possible owner(top waiter). */
>  	new_owner = rt_mutex_next_owner(&pi_state->pi_mutex);
>  
>  	/*
> -	 * This happens when we have stolen the lock and the original
> -	 * pending owner did not enqueue itself back on the rt_mutex.
> -	 * Thats not a tragedy. We know that way, that a lock waiter
> -	 * is on the fly. We make the futex_q waiter the pending owner.
> -	 */
> -	if (!new_owner)
> -		new_owner = this->task;

Lai,

Why did you remove this? I just triggered a bug that was caused by
rt_mutex_next_owner() returning NULL.

Hmm, reading the comment it looks like it would only return NULL if the
next owner woke up and removed itself (which it does not do anymore).
But, this code is called unconditionally. I'm thinking we can trigger
this if a timeout occurred too.

I guess the real change should just be to the comment.

I can add trace debug to see if that was indeed the case.

-- Steve



