Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752261Ab0EKVPJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 May 2010 17:15:09 -0400
Received: from gate.crashing.org ([63.228.1.57]:57187 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752013Ab0EKVPH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 May 2010 17:15:07 -0400
Subject: Re: [PATCH/RFC] mutex: Fix optimistic spinning vs. BKL
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, Arnd Bergmann <arnd@arndb.de>,
       Ingo Molnar <mingo@elte.hu>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Tony Breeds <tonyb@au1.ibm.com>
In-Reply-To: <alpine.LFD.2.00.1005111051330.3711@i5.linux-foundation.org>
References: <1272429513.24542.83.camel@pasglop>
	 <201004281406.04080.arnd@arndb.de> <1272494121.24542.113.camel@pasglop>
	 <20100507042010.GR12389@ozlabs.org> <20100507053023.GF8069@nowhere>
	 <1273212116.4861.61.camel@pasglop>  <20100507212909.GD5401@nowhere>
	 <1273271262.4861.134.camel@pasglop> <1273478159.5605.3324.camel@twins>
	 <alpine.LFD.2.00.1005111051330.3711@i5.linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 12 May 2010 07:13:07 +1000
Message-ID: <1273612387.21352.42.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-05-11 at 11:06 -0700, Linus Torvalds wrote:
> 
> On Mon, 10 May 2010, Peter Zijlstra wrote:
> > 
> > As to the 2 jiffy spin timeout, I guess we should add a lockdep warning
> > for that, because anybody holding a mutex for longer than 2 jiffies and
> > not sleeping does need fixing anyway.
> 
> I really hate the jiffies thing, but looking at the optimistic spinning, I 
> do wonder about two things..
> 
> First - we check "need_resched()" only if owner is NULL. That sounds 
> wrong. If we need to reschedule, we need to stop spinning _regardless_ of 
> whether the owner may have been preempted before setting the owner field.

The inner call mutex_spin_on_owner() checks it regardless (yeah, I
tripped on that too initially).

 .../...

> Now, we could just count the number of times "owner" has changed, and I 
> suspect that would be sufficient. Now, that trivial counting sceme would 
> fail if "owner" stays the same (ie the same process re-takes the lock over 
> and over again, possibly due to hot cacheline things being very unfair 
> to the person who already owns it), but quite frankly, I don't think we 
> can get into that kind of situation. 

I've observed cases where owner didn't appear to change but we also
didn't trip on need_resched(), which leads me to wonder, if nobody is
contending to run on that processor, we may never set need_resched() and
end up spinning as long as the target is running.

This cause the deadlock with the BKL (which I fixed) but it also means
we may spend a long time without going to sleep, which means CPU not
dozed or returned to the hypervisor etc... for longer than needed.

That's the reasoning behind the jiffy timeout. It's not great but it
will get us out in some amount of time, which I wanted to guarantee.
  
 .../...

> Of course, it's quite possible that as long as "need_resched()" isn't set, 
> spinning really _is_ the right thing to do. Maybe it causes horrible CPU 
> load on some odd "everybody synchronize" loads, but maybe that really is 
> the best we can do.

Well, that happens at least occasionally but if you think that can be
safely ignored, then drop the jiffy timeout.

Cheers,
Ben.

> 			Linus
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/


