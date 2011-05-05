Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753354Ab1EEUlH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 May 2011 16:41:07 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:44327 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750925Ab1EEUlF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 May 2011 16:41:05 -0400
Subject: Re: [PATCH] time: Add locking to xtime access in get_seconds()
From: john stultz <johnstul@us.ibm.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Andi Kleen <andi@firstfloor.org>, lkml <linux-kernel@vger.kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Anton Blanchard <anton@samba.org>,
        Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <1304627098.3131.1.camel@edumazet-laptop>
References: <1304478708-1273-1-git-send-email-john.stultz@linaro.org>
	 <m2oc3jxgtt.fsf@firstfloor.org> <1304564090.2943.36.camel@work-vm>
	 <20110505175713.GG2925@one.firstfloor.org>
	 <1304626621.20980.19.camel@work-vm>
	 <1304627098.3131.1.camel@edumazet-laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 05 May 2011 13:40:50 -0700
Message-ID: <1304628050.20980.34.camel@work-vm>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-05-05 at 22:24 +0200, Eric Dumazet wrote:
> Le jeudi 05 mai 2011 à 13:17 -0700, john stultz a écrit :
> > On Thu, 2011-05-05 at 19:57 +0200, Andi Kleen wrote:
> > > > I suspect the reason this hasn't been triggered on x86 or power6 is due
> > > > to compiler or processor optimizations reordering the assignment to in
> > > > effect make it atomic. Or maybe the timing window to see the issue is
> > > > harder to observe?
> > > 
> > > On x86 all aligned stores are atomic. So I don't see how this 
> > > could be a problem ever.
> > 
> > No no. The issue was with the fact that in update_xtime_cache we modify
> > xtime_cache twice (once setting it possibly backwards to xtime, then
> > adding in the nsec offset).
> > 
> > Since get_seconds does no locking, this issue should be visible
> > anywhere, as long as you manage to hit the race window between the first
> > assignment and the second.
> > 
> > However, in the testing, the issue only showed up on P7, but not P6 or
> > x86.
> > 
> > My guess was that the code:
> > 
> > xtime_cache.sec = xtime.sec
> > xtime_cache.nsec = xtime.nsec
> > xtime_cache.sec = xtime_cache.sec 
> > 		 + div(xtime_cache.nsec + nsec, NSEC_PER_SEC, &rem);
> > xtime_cache.nsec = rem
> > 
> > Was getting rearranged to:
> > 
> > xtime_cache.sec = xtime.sec 
> > 		+ div(xtime.nsec + nsec, NSEC_PER_SEC, &rem);
> > xtime_cache.nsec = rem
> > 
> > 
> > Which makes the xtime_cache.sec update atomic.
> > 
> > But its just a guess.
> 
> Sure (disassembly could help to check this), but get_seconds() reads
> xtime.tv_sec  ;)

Currently, yes. 
But as I mentioned in an earlier mail, the problem was with
2.6.32-stable.

thanks
-john



