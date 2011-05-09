Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753463Ab1EIIkj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 May 2011 04:40:39 -0400
Received: from www.linutronix.de ([62.245.132.108]:39259 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752717Ab1EIIkh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 May 2011 04:40:37 -0400
Date: Mon, 9 May 2011 10:40:33 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: john stultz <johnstul@us.ibm.com>
cc: Eric Dumazet <eric.dumazet@gmail.com>, Andi Kleen <andi@firstfloor.org>,
        lkml <linux-kernel@vger.kernel.org>, Paul Mackerras <paulus@samba.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Anton Blanchard <anton@samba.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [RFC] time: xtime_lock is held too long
In-Reply-To: <1304724519.20980.139.camel@work-vm>
Message-ID: <alpine.LFD.2.02.1105091036000.2895@ionos>
References: <1304574244.32152.666.camel@edumazet-laptop>  <1304576495.2943.40.camel@work-vm>  <1304604284.3032.78.camel@edumazet-laptop>  <alpine.LFD.2.02.1105051630390.3005@ionos>  <1304608095.3032.95.camel@edumazet-laptop>  <alpine.LFD.2.02.1105051750540.3005@ionos>
  <20110505210118.GI2925@one.firstfloor.org>  <alpine.LFD.2.02.1105061117220.3005@ionos>  <20110506165913.GF11636@one.firstfloor.org>  <1304703767.3066.211.camel@edumazet-laptop>  <20110506175051.GL11636@one.firstfloor.org>  <1304710003.2821.0.camel@edumazet-laptop>
  <1304712267.2821.29.camel@edumazet-laptop>  <1304713443.20980.124.camel@work-vm>  <1304721004.2821.148.camel@edumazet-laptop>  <1304722000.20980.130.camel@work-vm>  <1304722835.2821.192.camel@edumazet-laptop> <1304724519.20980.139.camel@work-vm>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-1681086758-1304930434=:2895"
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-1681086758-1304930434=:2895
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT

On Fri, 6 May 2011, john stultz wrote:
> On Sat, 2011-05-07 at 01:00 +0200, Eric Dumazet wrote:
> > Le vendredi 06 mai 2011 à 15:46 -0700, john stultz a écrit :
> > > On Sat, 2011-05-07 at 00:30 +0200, Eric Dumazet wrote:
> > > > I can see many cpus entering tick_do_update_jiffies64() and all are
> > > > calling write_seqlock(&xtime_lock);
> > > > 
> > > > Only first one can perform the work, but all others are waiting on the
> > > > spinlock, get it, change seqcount, and realize they have nothing to
> > > > do...
> > > 
> > > Huh. So who is calling tick_do_update_jiffies64 in your case? I know the
> > > sched_tick_timer and tick_nohz_handler checks to make sure
> > > tick_do_timer_cpu == cpu to avoid exactly the thundering heard problem
> > > on the jiffies update.
> > > 
> > > There's other spots that call tick_do_update_jiffies64, but I thought
> > > those were more rare. So there may be something else wrong going on
> > > here.
> > > 
> > 
> > That I can answer :
> [snip]
> > (I added do_timestamp1/do_timestamp2) after/before write_seqlock()/write_sequnlock()
> > 
> >          <idle>-0     [003]   920.355377: do_timestamp1 <-tick_do_update_jiffies64
> >           <idle>-0     [006]   920.355377: tick_do_update_jiffies64 <-tick_sched_timer
> >           <idle>-0     [003]   920.355378: do_timestamp2 <-tick_do_update_jiffies64
> >           <idle>-0     [000]   920.355657: tick_do_update_jiffies64 <-tick_check_idle
> >           <idle>-0     [000]   920.355660: tick_do_update_jiffies64 <-tick_nohz_restart_sched_tick
> 
> Thomas, any clues why this would be getting hammered?

Hmm, tick-sched code grew quite a few unconditional callsites which
i'm not sure of whether they are correct.

Thanks,

	tglx
--8323328-1681086758-1304930434=:2895--
