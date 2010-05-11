Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932399Ab0EKST4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 May 2010 14:19:56 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:37894 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932381Ab0EKSTw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 May 2010 14:19:52 -0400
Subject: Re: [PATCH/RFC] mutex: Fix optimistic spinning vs. BKL
From: Peter Zijlstra <peterz@infradead.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
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
Date: Tue, 11 May 2010 20:19:40 +0200
Message-ID: <1273601980.1810.59.camel@laptop>
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

There is a second need_resched() in the inner spin loop in
kernel/sched.c:mutex_spin_on_owner().

> Second: we allow "owner" to change, and we'll continue spinning. This is 
> how you can end up spinning for a long time - not because anybody holds 
> the mutex for longer than 2 jiffies, but because a lot of other threads 
> _together_ hold the mutex for longer than 2 jiffies.

Granted.

> Now, I think we do want some limited "continue spinning even if somebody 
> else ended up getting it instead", but I think we should at least limit 
> it. Otherwise we end up being potentially rather unfair, since we don't 
> have any fair queueing logic for the optimistic spinning phase.
> 
> Now, we could just count the number of times "owner" has changed, and I 
> suspect that would be sufficient. Now, that trivial counting sceme would 
> fail if "owner" stays the same (ie the same process re-takes the lock over 
> and over again, possibly due to hot cacheline things being very unfair 
> to the person who already owns it), but quite frankly, I don't think we 
> can get into that kind of situation. 
> 
> Why? Mutexes may end up being very heavily contended, but they can't be 
> contended by just _one_ thread. So if we're really in a starvation issue, 
> the thread that is waiting _will_ see multiple different owners.
> 
> So once you have seen X number of other owners, you just say "screw it, 
> this spinning thing isn't working for me, I'll go to the sleeping case".

Right, so basically count the number of mutex_spin_on_owner() calls and
bail when >N.

> Of course, it's quite possible that as long as "need_resched()" isn't set, 
> spinning really _is_ the right thing to do. Maybe it causes horrible CPU 
> load on some odd "everybody synchronize" loads, but maybe that really is 
> the best we can do.

Ben's argument was that spinning for a long time wrecks power usage.

That said, I'd still like a counter/event/warning to see if someone
actually manages to hold onto a mutex for long (2 jiffies) without
scheduling at all. If we ever run into something like that, that needs
to get fixed regardless.



