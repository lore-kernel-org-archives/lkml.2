Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756664Ab1EFUY2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 May 2011 16:24:28 -0400
Received: from e37.co.us.ibm.com ([32.97.110.158]:42271 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756357Ab1EFUY0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 May 2011 16:24:26 -0400
Subject: Re: [RFC] time: xtime_lock is held too long
From: john stultz <johnstul@us.ibm.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Andi Kleen <andi@firstfloor.org>, Thomas Gleixner <tglx@linutronix.de>,
        lkml <linux-kernel@vger.kernel.org>, Paul Mackerras <paulus@samba.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Anton Blanchard <anton@samba.org>, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <1304712267.2821.29.camel@edumazet-laptop>
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
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 06 May 2011 13:24:03 -0700
Message-ID: <1304713443.20980.124.camel@work-vm>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-05-06 at 22:04 +0200, Eric Dumazet wrote:
> Le vendredi 06 mai 2011 à 21:26 +0200, Eric Dumazet a écrit :
> > Le vendredi 06 mai 2011 à 19:50 +0200, Andi Kleen a écrit :
> > > On Fri, May 06, 2011 at 07:42:47PM +0200, Eric Dumazet wrote:
> > > > Le vendredi 06 mai 2011 à 18:59 +0200, Andi Kleen a écrit :
> > > > 
> > > > > If you have a better way to make it faster please share it.
> > > > 
> > > > Ideally we could use RCU :)
> > > 
> > > Hmm, I didn't think my case had a lot of loops in the seqlock -- just
> > > expensive cache misses -- but I should double check.
> > > 
> > > For the lots of loop case we probably need to understand first why you
> > > iterate that often.
> > 
> > Yep, I'll try to investigate on this
> > 
> 
> So apparently some calls to tick_do_update_jiffies64() are pretty
> expensive :

So would the easier solution be to just break out timekeeper locking
from the xtime_lock?

So basically we would just add a timekeeper.lock seqlock and use it to
protect only the timekeeping code? We can still keep xtime_lock around
for the tick/jiffies protection (well, until tglx kills jiffies :), but
gettimeofday and friends wouldn't be blocked for so long.

That should be pretty straight forward now that the timekeeper data is
completely static to timkeeeping.c.

thanks
-john


