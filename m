Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756872Ab1HEP3A (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Aug 2011 11:29:00 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:56123 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753643Ab1HEP27 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Aug 2011 11:28:59 -0400
Date: Fri, 5 Aug 2011 18:27:55 +0300
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, linux-mm@kvack.org
Subject: Re: select_task_rq_fair: WARNING: at kernel/lockdep.c match_held_lock
Message-ID: <20110805152755.GA4148@swordfish.minsk.epam.com>
References: <20110804141306.GA3536@swordfish.minsk.epam.com>
 <1312470358.16729.25.camel@twins>
 <20110804153752.GA3562@swordfish.minsk.epam.com>
 <1312472867.16729.38.camel@twins>
 <20110804155347.GB3562@swordfish.minsk.epam.com>
 <1312547780.28695.1.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1312547780.28695.1.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On (08/05/11 14:36), Peter Zijlstra wrote:
> The below is what I've come up with.
>

Hello,
I think that should work. Will test, anyway.

Thanks,
	Sergey
 
> ---
> Subject: lockdep: Fix wrong assumption in match_held_lock
> From: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Date: Fri Aug 05 14:26:17 CEST 2011
> 
> match_held_lock() was assuming it was being called on a lock class
> that had already seen usage. 
> 
> This condition was true for bug-free code using lockdep_assert_held(),
> since you're in fact holding the lock when calling it. However the
> assumption fails the moment you assume the assertion can fail, which
> is the whole point of having the assertion in the first place.
> 
> Anyway, now that there's more lockdep_is_held() users, notably
> __rcu_dereference_check(), its much easier to trigger this since we
> test for a number of locks and we only need to hold any one of them to
> be good.
> 
> Reported-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
> Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> ---
>  kernel/lockdep.c |    8 +++++++-
>  1 file changed, 7 insertions(+), 1 deletion(-)
> 
> Index: linux-2.6/kernel/lockdep.c
> ===================================================================
> --- linux-2.6.orig/kernel/lockdep.c
> +++ linux-2.6/kernel/lockdep.c
> @@ -3111,7 +3111,13 @@ static int match_held_lock(struct held_l
>  		if (!class)
>  			class = look_up_lock_class(lock, 0);
>  
> -		if (DEBUG_LOCKS_WARN_ON(!class))
> +		/*
> +		 * If look_up_lock_class() failed to find a class, we're trying
> +		 * to test if we hold a lock that has never yet been acquired.
> +		 * Clearly if the lock hasn't been acquired _ever_, we're not
> +		 * holding it either, so report failure.
> +		 */
> +		if (!class)
>  			return 0;
>  
>  		if (DEBUG_LOCKS_WARN_ON(!hlock->nest_lock))
> 
