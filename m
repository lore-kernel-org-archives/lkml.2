Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756736Ab1EFQ7P (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 May 2011 12:59:15 -0400
Received: from one.firstfloor.org ([213.235.205.2]:42775 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756710Ab1EFQ7O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 May 2011 12:59:14 -0400
Date: Fri, 6 May 2011 18:59:13 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Andi Kleen <andi@firstfloor.org>, Eric Dumazet <eric.dumazet@gmail.com>,
        john stultz <johnstul@us.ibm.com>, lkml <linux-kernel@vger.kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Anton Blanchard <anton@samba.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [RFC] time: xtime_lock is held too long
Message-ID: <20110506165913.GF11636@one.firstfloor.org>
References: <m2oc3jxgtt.fsf@firstfloor.org> <1304564090.2943.36.camel@work-vm> <1304574244.32152.666.camel@edumazet-laptop> <1304576495.2943.40.camel@work-vm> <1304604284.3032.78.camel@edumazet-laptop> <alpine.LFD.2.02.1105051630390.3005@ionos> <1304608095.3032.95.camel@edumazet-laptop> <alpine.LFD.2.02.1105051750540.3005@ionos> <20110505210118.GI2925@one.firstfloor.org> <alpine.LFD.2.02.1105061117220.3005@ionos>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.02.1105061117220.3005@ionos>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 06, 2011 at 12:18:27PM +0200, Thomas Gleixner wrote:
> > There's actually some potential here. I got a moderate speedup in a
> > database benchmark with this patch recently. The biggest win
> 
> Numbers please.

Low single digit on a hard to improve well tuned workload.

> Well, then we should make sure that they are not.

Ok I will send a patch.

> 
> And looking at a few kernel images the interesting variables
> timekeeper, xtime, wall_to_monotonic are in a consecutive area which
> is not really surprising. Further all images have xtime and
> wall_to_monotonic in the same cacheline, just xtime_lock is somewhere
> else.

I guess it depends a lot on the particular alignment. 
But yes it should be ensured.

> 
> > (needs some cleanups, just for illustration)
> 
> And how's that cleanup going to look like? Making the timekeeping
> internal variables global again is not going to happen. And if you

Why not?  You could of course call some function in the file 
to do the prefetches, but that would seem dumb to me.

> want prefetching those variables in the timer interrupt, then you want
> to prefetch them in any random code path which ends up touching them.

If that code path shows up in profiling. Only the timer interrupt
did so far.

> That's the completely wrong aproach, really. If stuff takes too long,
> then we need to tackle it at the root of the problem and not solve it
> by sprinkling magic prefetches all over the place.

If you have a better way to make it faster please share it.

-Andi
