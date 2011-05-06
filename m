Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756275Ab1EFKSe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 May 2011 06:18:34 -0400
Received: from www.linutronix.de ([62.245.132.108]:36971 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755835Ab1EFKSd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 May 2011 06:18:33 -0400
Date: Fri, 6 May 2011 12:18:27 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Andi Kleen <andi@firstfloor.org>
cc: Eric Dumazet <eric.dumazet@gmail.com>, john stultz <johnstul@us.ibm.com>,
        lkml <linux-kernel@vger.kernel.org>, Paul Mackerras <paulus@samba.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Anton Blanchard <anton@samba.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [RFC] time: xtime_lock is held too long
In-Reply-To: <20110505210118.GI2925@one.firstfloor.org>
Message-ID: <alpine.LFD.2.02.1105061117220.3005@ionos>
References: <1304478708-1273-1-git-send-email-john.stultz@linaro.org> <m2oc3jxgtt.fsf@firstfloor.org> <1304564090.2943.36.camel@work-vm> <1304574244.32152.666.camel@edumazet-laptop> <1304576495.2943.40.camel@work-vm> <1304604284.3032.78.camel@edumazet-laptop>
 <alpine.LFD.2.02.1105051630390.3005@ionos> <1304608095.3032.95.camel@edumazet-laptop> <alpine.LFD.2.02.1105051750540.3005@ionos> <20110505210118.GI2925@one.firstfloor.org>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 5 May 2011, Andi Kleen wrote:

> > > Another idea would be to prime cache lines to be dirtied in cpu cache
> > > before taking locks, and better pack variables to reduce number of cache
> > > lines.
> > 
> > Most variables are packed already in struct timekeeper, which should
> > be pretty cache hot anyway, so I don't know whether we gain much.
> 
> There's actually some potential here. I got a moderate speedup in a
> database benchmark with this patch recently. The biggest win

Numbers please.

> was in the timer interrupt.

Because this _is_ the timer interrupt ?
 
> All those variables are on separate cache lines.

Well, then we should make sure that they are not.

And looking at a few kernel images the interesting variables
timekeeper, xtime, wall_to_monotonic are in a consecutive area which
is not really surprising. Further all images have xtime and
wall_to_monotonic in the same cacheline, just xtime_lock is somewhere
else.

> (needs some cleanups, just for illustration)

And how's that cleanup going to look like? Making the timekeeping
internal variables global again is not going to happen. And if you
want prefetching those variables in the timer interrupt, then you want
to prefetch them in any random code path which ends up touching them.

That's the completely wrong aproach, really. If stuff takes too long,
then we need to tackle it at the root of the problem and not solve it
by sprinkling magic prefetches all over the place.

Thanks,

	tglx
