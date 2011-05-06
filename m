Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752479Ab1EFX2s (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 May 2011 19:28:48 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:33723 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751392Ab1EFX2q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 May 2011 19:28:46 -0400
Subject: Re: [RFC] time: xtime_lock is held too long
From: john stultz <johnstul@us.ibm.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Andi Kleen <andi@firstfloor.org>, Thomas Gleixner <tglx@linutronix.de>,
        lkml <linux-kernel@vger.kernel.org>, Paul Mackerras <paulus@samba.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Anton Blanchard <anton@samba.org>, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <1304722835.2821.192.camel@edumazet-laptop>
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
	 <1304722000.20980.130.camel@work-vm>
	 <1304722835.2821.192.camel@edumazet-laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 06 May 2011 16:28:39 -0700
Message-ID: <1304724519.20980.139.camel@work-vm>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2011-05-07 at 01:00 +0200, Eric Dumazet wrote:
> Le vendredi 06 mai 2011 à 15:46 -0700, john stultz a écrit :
> > On Sat, 2011-05-07 at 00:30 +0200, Eric Dumazet wrote:
> > > I can see many cpus entering tick_do_update_jiffies64() and all are
> > > calling write_seqlock(&xtime_lock);
> > > 
> > > Only first one can perform the work, but all others are waiting on the
> > > spinlock, get it, change seqcount, and realize they have nothing to
> > > do...
> > 
> > Huh. So who is calling tick_do_update_jiffies64 in your case? I know the
> > sched_tick_timer and tick_nohz_handler checks to make sure
> > tick_do_timer_cpu == cpu to avoid exactly the thundering heard problem
> > on the jiffies update.
> > 
> > There's other spots that call tick_do_update_jiffies64, but I thought
> > those were more rare. So there may be something else wrong going on
> > here.
> > 
> 
> That I can answer :
[snip]
> (I added do_timestamp1/do_timestamp2) after/before write_seqlock()/write_sequnlock()
> 
>          <idle>-0     [003]   920.355377: do_timestamp1 <-tick_do_update_jiffies64
>           <idle>-0     [006]   920.355377: tick_do_update_jiffies64 <-tick_sched_timer
>           <idle>-0     [003]   920.355378: do_timestamp2 <-tick_do_update_jiffies64
>           <idle>-0     [000]   920.355657: tick_do_update_jiffies64 <-tick_check_idle
>           <idle>-0     [000]   920.355660: tick_do_update_jiffies64 <-tick_nohz_restart_sched_tick

Thomas, any clues why this would be getting hammered?



> > >  	/* Reevalute with xtime_lock held */
> > > -	write_seqlock(&xtime_lock);
> > > +	spin_lock(&xtime_lock.lock);
> > 
> > Oof.. No, this is too ugly and really just abuses the seqlock structure.
> > 
> 
> That was a hack/POC, of course, but we can cleanup seqlock.h to provide
> clean thing. A seqlock_t should include a seqcount_t and a spinlock_t.

Maybe I'm misunderstanding, but you seem to be trying to create some
sort of a layered lock from the seqlock ? I don't quite understand why
your proposing this instead of actually splitting the lock out?


> > If you really want to untangle what xtime_lock protects, you need to
> > introduce a new lock (I suggest in the timekeeper structure) to protect
> > the timekeeping data.
> > 
> > Then we can refine xtime_lock to also just protect the jiffies/tick
> > management bits as well if needed.
> 
> For the moment I am trying to understand the code. Its quite complex and
> uses a monolithic seqlock, defeating seqlock power.

Defeating seqlock power? My thoughts are that seqlocks are nice
lightweight reader/writer locks that avoid writer starvation. You seem
to be trying to redefine or extend them to be something else which is
more subtle. 

I agree, the code is complex!  I'm just not sure adding more
complicated/subtle locking mechanisms is a good solution. Instead I'd
suggest simply splitting up the locks (by using new locks) to reduce the
amount of data that is being protected by a single lock.

But again, maybe I'm misunderstanding you?

thanks
-john




