Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754903Ab0DBVZ2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Apr 2010 17:25:28 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:50598 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754551Ab0DBVZV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Apr 2010 17:25:21 -0400
Date: Fri, 2 Apr 2010 23:25:15 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Matt Turner <mattst88@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>, LKML <linux-kernel@vger.kernel.org>,
       linux-alpha@vger.kernel.org
Subject: Re: Discrepancy between comments for sched_find_first_bit
Message-ID: <20100402212515.GC17041@elte.hu>
References: <b4198de61003282037p502e9fbfi62123088b9d73923@mail.gmail.com>
 <1269858302.12097.272.camel@laptop>
 <20100402201648.GA15498@elte.hu>
 <g2rb4198de61004021350tf509b5c3k22dfa8f2e24fedc8@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <g2rb4198de61004021350tf509b5c3k22dfa8f2e24fedc8@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Matt Turner <mattst88@gmail.com> wrote:

> On Fri, Apr 2, 2010 at 4:16 PM, Ingo Molnar <mingo@elte.hu> wrote:
> >
> > * Peter Zijlstra <peterz@infradead.org> wrote:
> >
> >> On Sun, 2010-03-28 at 23:37 -0400, Matt Turner wrote:
> >> > include/asm-generic/bitops/sched.h says
> >> > /*
> >> > ?* Every architecture must define this function. It's the fastest
> >> > ?* way of searching a 100-bit bitmap. ?It's guaranteed that at least
> >> > ?* one of the 100 bits is cleared.
> >> > ?*/
> >> >
> >> > arch/alpha/include/asm/bitops.h says
> >> > /*
> >> > ?* Every architecture must define this function. It's the fastest
> >> > ?* way of searching a 140-bit bitmap where the first 100 bits are
> >> > ?* unlikely to be set. It's guaranteed that at least one of the 140
> >> > ?* bits is set.
> >> > ?*/
> >> >
> >> > Is the guarantee that one of the first 100-bits set (and that the last
> >> > 40 are useless?), or 140-bits? If it's just the first 100 bits we care
> >> > about, then the alpha version needs to be fixed.
> >> >
> >> > I'm just checking this out, because gcc produces horrendous code for
> >> > sched_find_first_bit on alpha. I rewrote it in assembly and it's
> >> > better than 4 times faster.
> >> >
> >> > Also, is it even worth optimizing that function? It looks like it's
> >> > only used in kernel/sched_rt.c.
> >>
> >> (might help if you CC the scheduler people on scheduler functions :-)
> >>
> >> Right, so it used to be 140 bits with the old O(1) scheduler, currently
> >> (as you noted) sched_rt is the only user left and will therefore only
> >> care about the first 100 bits.
> >>
> >> As it stands I think it might still make sense to optimize this as for
> >> rt loads it still on a hot path.
> >>
> >> As to the 100 vs 140 length, would it really make much of difference to
> >> shorten the implementation to 100? If not I'd leave it at 140.
> >>
> >> Ingo, any comments?
> >
> > I guess getting below the 128 bits boundary would shave an instruction and a
> > branch off or so?
> >
> > ? ? ? ?Ingo
> >
> 
> That's right. I should be able to get rid of a cmov, which kind of
> counts as two instructions in EV6 scheduling.
> 
> So I should send a patch to reduce this to the first 100 (128) bits?

Sure, why not, every instruction counts :-)

Note, if you do it then please also include a disassembly of the area that 
changed, so that we document the effect.

	Ingo
