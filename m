Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751778Ab2BTHLP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Feb 2012 02:11:15 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:59367 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750850Ab2BTHLO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Feb 2012 02:11:14 -0500
Message-ID: <4F41F315.1040900@cn.fujitsu.com>
Date: Mon, 20 Feb 2012 15:15:33 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc14 Thunderbird/3.1.4
MIME-Version: 1.0
To: paulmck@linux.vnet.ibm.com
CC: linux-kernel@vger.kernel.org, mingo@elte.hu, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        fweisbec@gmail.com, patches@linaro.org
Subject: Re: [PATCH RFC tip/core/rcu] rcu: direct algorithmic SRCU implementation
References: <20120213020951.GA12138@linux.vnet.ibm.com>
In-Reply-To: <20120213020951.GA12138@linux.vnet.ibm.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2012-02-20 15:09:26,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2012-02-20 15:09:32,
	Serialize complete at 2012-02-20 15:09:32
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/13/2012 10:09 AM, Paul E. McKenney wrote:

>  /*
>   * Helper function for synchronize_srcu() and synchronize_srcu_expedited().
>   */
> -static void __synchronize_srcu(struct srcu_struct *sp, void (*sync_func)(void))
> +static void __synchronize_srcu(struct srcu_struct *sp, bool expedited)
>  {
>  	int idx;
>  
> @@ -178,90 +316,51 @@ static void __synchronize_srcu(struct srcu_struct *sp, void (*sync_func)(void))
>  			   !lock_is_held(&rcu_sched_lock_map),
>  			   "Illegal synchronize_srcu() in same-type SRCU (or RCU) read-side critical section");
>  
> -	idx = sp->completed;
> +	idx = ACCESS_ONCE(sp->completed);
>  	mutex_lock(&sp->mutex);
>  
>  	/*
>  	 * Check to see if someone else did the work for us while we were
> -	 * waiting to acquire the lock.  We need -two- advances of
> +	 * waiting to acquire the lock.  We need -three- advances of
>  	 * the counter, not just one.  If there was but one, we might have
>  	 * shown up -after- our helper's first synchronize_sched(), thus
>  	 * having failed to prevent CPU-reordering races with concurrent
> -	 * srcu_read_unlock()s on other CPUs (see comment below).  So we
> -	 * either (1) wait for two or (2) supply the second ourselves.
> +	 * srcu_read_unlock()s on other CPUs (see comment below).  If there
> +	 * was only two, we are guaranteed to have waited through only one
> +	 * full index-flip phase.  So we either (1) wait for three or
> +	 * (2) supply the additional ones we need.
>  	 */
>  
> -	if ((sp->completed - idx) >= 2) {
> +	if (sp->completed == idx + 2)
> +		idx = 1;
> +	else if (sp->completed == idx + 3) {
>  		mutex_unlock(&sp->mutex);
>  		return;
> -	}
> -
> -	sync_func();  /* Force memory barrier on all CPUs. */
> +	} else
> +		idx = 0;


Hi, Paul

I don't think this check-and-return path is needed since we will introduce call_srcu().
We just need a correct code to show how it works and to be used for a while,
and new call_srcu() will be implemented based on this correct code which will be removed.

And I think this unneeded check-and-return path is incorrect. See the following:

Reader			Updater						Helper thread
			old_ptr = rcu_ptr;
			/* rcu_ptr = NULL; but be reordered to (1) */
			start synchronize_srcu()
			idx = ACCESS_ONCE(sp->completed);(2)
									synchronize_srcu()
									synchronize_srcu()
srcu_read_lock();
old_ptr = rcu_ptr;
			rcu_ptr = NULL;(1)
			mutex_lock() and read sp->completed
			and return from synchronize_srcu()
			free(old_ptr);
use freed old_ptr
srcu_read_unlock();


So, we need a smb_mb() between (1) and (2) to force the order.

__synchronize_srcu() {
	smp_mb(); /* F */
	idx = ACCESS_ONCE(sp->completed); /* (2) */
	....
}

And this smp_mb() F is paired with helper's smp_mb() D. So if Updater sees X advances of
->completed, Updater must sees X times of *full* flip_and_wait(). So We need see -two- advances of
->completed from Helper only, not -three-.

        if (sp->completed == idx + 1)
                idx = 1;
        else if (sp->completed == idx + 2) {
                mutex_unlock(&sp->mutex);
                return;
        } else
                idx = 0;


Or simpler:

__synchronize_srcu() {
	unsigned int idx;   /* <-------- unsigned */

	/* comments for smp_mb() F */
	smp_mb(); /* F */
	idx = ACCESS_ONCE(sp->completed);

	mutex_lock(&sp->mutex);
	idx = sp->completed - idx;

	/* original comments */
	for (; idx < 2; idx++)
                flip_idx_and_wait(sp, expedited);
        mutex_unlock(&sp->mutex);
}

At last, I can't understand the comments of this check-and-return path.
So maybe the above reply and I are totally wrong.
But the comments of this check-and-return path does not describe the code
well(especially the order), and it contains the old "synchronize_sched()"
which make me confuse.

My conclusion, we can just remove the check-and-return path to reduce
the complexity since we will introduce call_srcu().

This new srcu is very great, especially the SRCU_USAGE_COUNT for every
lock/unlock witch forces any increment/decrement pair changes the counter
for me.


Thanks,
Lai

