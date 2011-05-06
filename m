Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932568Ab1EFUSR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 May 2011 16:18:17 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:35617 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753185Ab1EFUSQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 May 2011 16:18:16 -0400
Subject: Re: [RFC] time: xtime_lock is held too long
From: john stultz <johnstul@us.ibm.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Andi Kleen <andi@firstfloor.org>, Thomas Gleixner <tglx@linutronix.de>,
        lkml <linux-kernel@vger.kernel.org>, Paul Mackerras <paulus@samba.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Anton Blanchard <anton@samba.org>, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <1304703767.3066.211.camel@edumazet-laptop>
References: <m2oc3jxgtt.fsf@firstfloor.org>
	 <1304564090.2943.36.camel@work-vm>
	 <1304574244.32152.666.camel@edumazet-laptop>
	 <1304576495.2943.40.camel@work-vm>
	 <1304604284.3032.78.camel@edumazet-laptop>
	 <alpine.LFD.2.02.1105051630390.3005@ionos>
	 <1304608095.3032.95.camel@edumazet-laptop>
	 <alpine.LFD.2.02.1105051750540.3005@ionos>
	 <20110505210118.GI2925@one.firstfloor.org>
	 <alpine.LFD.2.02.1105061117220.3005@ionos>
	 <20110506165913.GF11636@one.firstfloor.org>
	 <1304703767.3066.211.camel@edumazet-laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 06 May 2011 13:18:07 -0700
Message-ID: <1304713087.20980.120.camel@work-vm>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-05-06 at 19:42 +0200, Eric Dumazet wrote:
> Le vendredi 06 mai 2011 à 18:59 +0200, Andi Kleen a écrit :
> 
> > If you have a better way to make it faster please share it.
> 
> Ideally we could use RCU :)
> 
> Have whatever state hold in one structure (possibly big, it doesnt
> matter) and switch pointer in writer once everything is setup in new
> structure.

Yea. RCU is tough though, because we do need the hardware cycle value
that we use to be valid for the current interval stored in the
timekeeper structure (ie: the cycle value can't be before the current
cycle_last, and it can't be greater then the next cycle_last).

The reason being, that should a frequency correction occur, you might
end up applying the old frequency to a longer interval then desired,
which could cause small timekeeping inconsistencies.

So we really do need a way to ensure that gettimeofday calls fall on one
side or the other of the accumulation loop. We may be able to tighten
that window some, but I don't know if RCU will work.

thanks
-john

