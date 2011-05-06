Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754240Ab1EFWqr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 May 2011 18:46:47 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:34428 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751034Ab1EFWqq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 May 2011 18:46:46 -0400
Subject: Re: [RFC] time: xtime_lock is held too long
From: john stultz <johnstul@us.ibm.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Andi Kleen <andi@firstfloor.org>, Thomas Gleixner <tglx@linutronix.de>,
        lkml <linux-kernel@vger.kernel.org>, Paul Mackerras <paulus@samba.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Anton Blanchard <anton@samba.org>, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <1304721004.2821.148.camel@edumazet-laptop>
References: <1304574244.32152.666.camel@edumazet-laptop>
	 <1304576495.2943.40.camel@work-vm>
	 <1304604284.3032.78.camel@edumazet-laptop>
	 <alpine.LFD.2.02.1105051630390.3005@ionos>
	 <1304608095.3032.95.camel@edumazet-laptop>
	 <alpine.LFD.2.02.1105051750540.3005@ionos>
	 <20110505210118.GI2925@one.firstfloor.org>
	 <alpine.LFD.2.02.1105061117220.3005@ionos>
	 <20110506165913.GF11636@one.firstfloor.org>
	 <1304703767.3066.211.camel@edumazet-laptop>
	 <20110506175051.GL11636@one.firstfloor.org>
	 <1304710003.2821.0.camel@edumazet-laptop>
	 <1304712267.2821.29.camel@edumazet-laptop>
	 <1304713443.20980.124.camel@work-vm>
	 <1304721004.2821.148.camel@edumazet-laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 06 May 2011 15:46:40 -0700
Message-ID: <1304722000.20980.130.camel@work-vm>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2011-05-07 at 00:30 +0200, Eric Dumazet wrote:
> Le vendredi 06 mai 2011 à 13:24 -0700, john stultz a écrit :
> 
> > So would the easier solution be to just break out timekeeper locking
> > from the xtime_lock?
> > 
> > So basically we would just add a timekeeper.lock seqlock and use it to
> > protect only the timekeeping code? We can still keep xtime_lock around
> > for the tick/jiffies protection (well, until tglx kills jiffies :), but
> > gettimeofday and friends wouldn't be blocked for so long.
> > 
> > That should be pretty straight forward now that the timekeeper data is
> > completely static to timkeeeping.c.
> > 
> 
> Yes :)
> 
> I can see many cpus entering tick_do_update_jiffies64() and all are
> calling write_seqlock(&xtime_lock);
> 
> Only first one can perform the work, but all others are waiting on the
> spinlock, get it, change seqcount, and realize they have nothing to
> do...

Huh. So who is calling tick_do_update_jiffies64 in your case? I know the
sched_tick_timer and tick_nohz_handler checks to make sure
tick_do_timer_cpu == cpu to avoid exactly the thundering heard problem
on the jiffies update.

There's other spots that call tick_do_update_jiffies64, but I thought
those were more rare. So there may be something else wrong going on
here.


> Meanwhile, a reader must wait that all writers are finished, because of
> all seqcount changes storm.
> 
> Following patch helps. Of course we might find out why so many cpus (on
> my 8 cpus machine !) are calling tick_do_update_jiffies64() at the same
> time...
> 
> 
> This is basically what I said in my first mail : 
> 
> Separate logical sections to reduce windows where readers are blocked/spinning.
>
> diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
> index d5097c4..251b2fe 100644
> --- a/kernel/time/tick-sched.c
> +++ b/kernel/time/tick-sched.c
> @@ -56,7 +56,7 @@ static void tick_do_update_jiffies64(ktime_t now)
>  		return;
> 
>  	/* Reevalute with xtime_lock held */
> -	write_seqlock(&xtime_lock);
> +	spin_lock(&xtime_lock.lock);

Oof.. No, this is too ugly and really just abuses the seqlock structure.

If you really want to untangle what xtime_lock protects, you need to
introduce a new lock (I suggest in the timekeeper structure) to protect
the timekeeping data.

Then we can refine xtime_lock to also just protect the jiffies/tick
management bits as well if needed.

thanks
-john


