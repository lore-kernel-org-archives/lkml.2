Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755391Ab1EEP7s (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 May 2011 11:59:48 -0400
Received: from www.linutronix.de ([62.245.132.108]:35620 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755361Ab1EEP7q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 May 2011 11:59:46 -0400
Date: Thu, 5 May 2011 17:59:39 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Eric Dumazet <eric.dumazet@gmail.com>
cc: john stultz <johnstul@us.ibm.com>, Andi Kleen <andi@firstfloor.org>,
        lkml <linux-kernel@vger.kernel.org>, Paul Mackerras <paulus@samba.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Anton Blanchard <anton@samba.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [RFC] time: xtime_lock is held too long
In-Reply-To: <1304608095.3032.95.camel@edumazet-laptop>
Message-ID: <alpine.LFD.2.02.1105051750540.3005@ionos>
References: <1304478708-1273-1-git-send-email-john.stultz@linaro.org>  <m2oc3jxgtt.fsf@firstfloor.org>  <1304564090.2943.36.camel@work-vm>  <1304574244.32152.666.camel@edumazet-laptop>  <1304576495.2943.40.camel@work-vm>  <1304604284.3032.78.camel@edumazet-laptop>
  <alpine.LFD.2.02.1105051630390.3005@ionos> <1304608095.3032.95.camel@edumazet-laptop>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-500058178-1304611180=:3005"
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-500058178-1304611180=:3005
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT

On Thu, 5 May 2011, Eric Dumazet wrote:

> Le jeudi 05 mai 2011 à 16:39 +0200, Thomas Gleixner a écrit :
> > On Thu, 5 May 2011, Eric Dumazet wrote:
> > 
> > > I feel xtime_lock seqlock is abused these days.
> > > 
> > > seqlock abstraction is somewhat lazy/dangerous because write_sequnlock()
> > > does both the seqcount increment and spinlock release.
> > > 
> > > I am concerned by fact that readers might wait for long times, because
> > > writers hold the whole seqlock, while sometime they only want to guard
> > > other writers to come in.
> > > 
> > > Maybe it's time to separate the things (the seqcount and the spinlock)
> > > so that writer can manipulate data in different sections : 
> > > - Sections while holding spinlock, allowing "readers" to run
> > > - Very small sections enclosed in a pair of seqcount increments, to
> > > synchronize with readers.
> > 
> > Well, in the case of timekeeping that might be problematic. I'm not
> > sure whether we can calculate the new values under the spinlock and
> > then update the timekeeper under the seqlock because we might adjust
> > the mult/shift pair which then can result in observabcle time going
> > backwards problems. It might be worth a try, though. John ???
> >  
> > The only thing which really can move right away outside the xtime
> > seqlock region is calc_global_load().
> > 
> 
> That would be a start, but we also could have finer granularity in
> locks :
> 
> update_vsyscall() has its own protection and could be done outside of
> the seqcount inc pair used for ktime_get().

Yeah, we could move that out, but it might be interesting to add a few
tracepoints into update_wall_time() first to see which part takes the
most time.

> [ but my patch numbers were for a 32bit kernel, so vsyscall is not
> accounted for. ]

:)
 
> Another idea would be to prime cache lines to be dirtied in cpu cache
> before taking locks, and better pack variables to reduce number of cache
> lines.

Most variables are packed already in struct timekeeper, which should
be pretty cache hot anyway, so I don't know whether we gain much.

Thanks,

	tglx
--8323328-500058178-1304611180=:3005--
