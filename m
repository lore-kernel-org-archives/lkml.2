Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756155Ab1DGSP2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Apr 2011 14:15:28 -0400
Received: from one.firstfloor.org ([213.235.205.2]:40520 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752060Ab1DGSP1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Apr 2011 14:15:27 -0400
Date: Thu, 7 Apr 2011 20:15:23 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andi Kleen <andi@firstfloor.org>, Andy Lutomirski <luto@mit.edu>,
        x86@kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: Re: [RFT/PATCH v2 2/6] x86-64: Optimize vread_tsc's barriers
Message-ID: <20110407181523.GC21838@one.firstfloor.org>
References: <cover.1302137785.git.luto@mit.edu> <80b43d57d15f7b141799a7634274ee3bfe5a5855.1302137785.git.luto@mit.edu> <BANLkTi=RkeFMpcb36RrJ=+eYm-xk4B2zYw@mail.gmail.com> <20110407164245.GA21838@one.firstfloor.org> <BANLkTikdn+Y2pWoLH_=Q4xHTgT6XGfOuSg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BANLkTikdn+Y2pWoLH_=Q4xHTgT6XGfOuSg@mail.gmail.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>   Instruction scheduling isn't some kind of theoretical game. It's a
> very practical issue, and CPU schedulers are constrained to do a good
> job quickly and _effectively_. In other words, instructions don't just
> schedule randomly. In the presense of the barrier, is there any reason
> to believe that the rdtsc would really schedule oddly? There is never
> any reason to _delay_ an rdtsc (it can take no cache misses or wait on
> any other resources), so when it is not able to move up, where would
> it move?

CPUs are complex beasts and I'm sure there are scheduling
constraints neither you nor me ever heard of :-)

There are always odd corner cases, e.g. if you have a correctable
error somewhere internally it may add a stall on some unit but not
on others, which may delay an arbitary uop.

Also there can be reordering against reading xtime and friends.

>  - the reason "back-to-back" (with the extreme example being in a
> tight loop) matters is that if something isn't in a tight loop, any
> jitter we see in the time counting wouldn't be visible anyway. One
> random timestamp is meaningless on its own. It's only when you have
> multiple ones that you can compare them. No?

There's also the multiple CPUs logging to a shared buffer case.

I thought Vojtech's original test case was something like that in fact.

> So _before_ we try some really clever data dependency trick with new
> inline asm and magic "double shifts to create a zero" things, I really
> would suggest just trying to remove the second lfence entirely and see
> how that works. Maybe it doesn't work, but ...

I would prefer to be safe than sorry. Also there are still other things
to optimize anyways (I suggested a few in my earlier mail) which
are 100% safe unlike this. Maybe those would be enough to offset
the cost of the "paranoid lfence"


-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
