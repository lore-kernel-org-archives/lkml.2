Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752848Ab0EGFa1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 May 2010 01:30:27 -0400
Received: from mail-ww0-f46.google.com ([74.125.82.46]:41885 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752399Ab0EGFaZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 May 2010 01:30:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=SqVD+nXcyiweG+lzBFTq0+lFofGf9uPz8dXwQ5SfptoFdOZAe6uGdeTpjzX8KsCnIu
         Ld8Cnmp3+9zvJ3hy1NQr+nK37HQfP4uug6RsSDHjCKXKq+OurYpJdi+AQl99bATJqzE1
         uDE4C1xdIJfhi+Or/mCkcv0/h+RpVMjBq8Zic=
Date: Fri, 7 May 2010 07:30:25 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Arnd Bergmann <arnd@arndb.de>, Peter Zijlstra <peterz@infradead.org>,
       Ingo Molnar <mingo@elte.hu>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Tony Breeds <tonyb@au1.ibm.com>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH/RFC] mutex: Fix optimistic spinning vs. BKL
Message-ID: <20100507053023.GF8069@nowhere>
References: <1272429513.24542.83.camel@pasglop> <201004281406.04080.arnd@arndb.de> <1272494121.24542.113.camel@pasglop> <20100507042010.GR12389@ozlabs.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100507042010.GR12389@ozlabs.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 07, 2010 at 02:20:10PM +1000, Tony Breeds wrote:
> On Thu, Apr 29, 2010 at 08:35:21AM +1000, Benjamin Herrenschmidt wrote:
> > On Wed, 2010-04-28 at 14:06 +0200, Arnd Bergmann wrote:
> > > 
> > > This needs to use time_before() to avoid problems on jiffies
> > > wraparound.
> > 
> > Ah right, forgot about that, been a while I didn't use jiffies for
> > anything :-)
> > 
> > I'll respin later today.
> 
> Like thie perhaps?  If this looks good it would be great to get this in .34
> 
> diff --git a/include/linux/sched.h b/include/linux/sched.h
> index 70abfd3..991d86f 100644
> --- a/include/linux/sched.h
> +++ b/include/linux/sched.h
> @@ -351,7 +351,8 @@ extern signed long schedule_timeout_killable(signed long timeout);
>  extern signed long schedule_timeout_uninterruptible(signed long timeout);
>  asmlinkage void __schedule(void);
>  asmlinkage void schedule(void);
> -extern int mutex_spin_on_owner(struct mutex *lock, struct thread_info *owner);
> +extern int mutex_spin_on_owner(struct mutex *lock, struct thread_info *owner,
> +                               unsigned long timeout);
>  
>  struct nsproxy;
>  struct user_namespace;
> diff --git a/kernel/mutex.c b/kernel/mutex.c
> index 947b3ad..fcf2573 100644
> --- a/kernel/mutex.c
> +++ b/kernel/mutex.c
> @@ -145,6 +145,7 @@ __mutex_lock_common(struct mutex *lock, long state, unsigned int subclass,
>  	struct task_struct *task = current;
>  	struct mutex_waiter waiter;
>  	unsigned long flags;
> +	unsigned long timeout;
>  
>  	preempt_disable();
>  	mutex_acquire(&lock->dep_map, subclass, 0, ip);
> @@ -168,15 +169,22 @@ __mutex_lock_common(struct mutex *lock, long state, unsigned int subclass,
>  	 * to serialize everything.
>  	 */
>  
> -	for (;;) {
> +	for (timeout = jiffies + 2; time_before(jiffies, timeout);) {
>  		struct thread_info *owner;
>  
>  		/*
> +		 * If we own the BKL, then don't spin. The owner of the mutex
> +		 * might be waiting on us to release the BKL.
> +		 */
> +		if (current->lock_depth >= 0)
> +			break;
> +
> +		/*
>  		 * If there's an owner, wait for it to either
>  		 * release the lock or go to sleep.
>  		 */
>  		owner = ACCESS_ONCE(lock->owner);
> -		if (owner && !mutex_spin_on_owner(lock, owner))
> +		if (owner && !mutex_spin_on_owner(lock, owner, timeout))
>  			break;



I like the safeguard against the bkl, it looks indeed like something
we should have in .34

But I really don't like the timeout.

This is going to make the things even worse if we have another cause of
deadlock by hiding the worst part of the consequences without actually
solving the problem.
And since the induced latency or deadlock won't be easily visible anymore,
we'll miss there is a problem. So we are going to spin for two jiffies
and only someone doing specific latency measurements will notice, if he's
lucky enough to meet the bug.

Moreover that adds some unnessary (small) overhead in this path.

May be can we have it as a debugging option, something that would
be part of lockdep, which would require CONFIG_DEBUG_MUTEX to
support mutex adaptive spinning.

A debugging option that could just dump the held locks and the
current one if we spin for an excessive timeslice.

Thanks.

