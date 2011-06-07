Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752608Ab1FGJId (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 05:08:33 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:32948 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751834Ab1FGJIb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 05:08:31 -0400
Date: Tue, 7 Jun 2011 11:07:43 +0200
From: Ingo Molnar <mingo@elte.hu>
To: david@lang.hm
Cc: pageexec@freemail.hu, Andrew Lutomirski <luto@mit.edu>, x86@kernel.org,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        Jesper Juhl <jj@chaosbits.net>, Borislav Petkov <bp@alien8.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arjan van de Ven <arjan@infradead.org>,
        Jan Beulich <JBeulich@novell.com>,
        richard -rw- weinberger <richard.weinberger@gmail.com>,
        Mikael Pettersson <mikpe@it.uu.se>, Andi Kleen <andi@firstfloor.org>,
        Brian Gerst <brgerst@gmail.com>,
        Louis Rilling <Louis.Rilling@kerlabs.com>, Valdis.Kletnieks@vt.edu
Subject: Re: [PATCH v5 8/9] x86-64: Emulate legacy vsyscalls
Message-ID: <20110607090743.GC4133@elte.hu>
References: <cover.1307292171.git.luto@mit.edu>
 <4DECFE18.23229.133B32ED@pageexec.freemail.hu>
 <20110606164700.GA2391@elte.hu>
 <4DED5985.542.14A05486@pageexec.freemail.hu>
 <alpine.DEB.2.02.1106061553010.25491@asgard.lang.hm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1106061553010.25491@asgard.lang.hm>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* david@lang.hm <david@lang.hm> wrote:

> > why are you cutting out in all those mails of yours what i 
> > already told you many times? the original statement from Andy was 
> > about the int cc path vs. the pf path: he said that the latter 
> > would not tolerate a few well predicted branches (if they were 
> > put there at all, that is) because the pf handler is such a 
> > critical fast path code. it is *not*. it can't be by almost 
> > definition given how much processing it has to do (it is by far 
> > one of the most complex of cpu exceptions to process).
> 
> it seems to me that such a complicated piece of code that is 
> executed so frequently is especially sensitive to anything that 
> makes it take longer

Exactly.

Firstly, fully handling the most important types of minor page faults 
takes about 2000 cycles on modern x86 hardware - just two cycles 
overhead is 0.1% overhead and in the kernel we are frequently doing 
0.01% optimizations as well ...

Secondly, we optimize the branch count, even if they are 
well-predicted: the reason is to reduce the BTB footprint which is a 
limited CPU resource like the TLB. Every BTB entry we use up reduces 
the effective BTB size visible to user-space applications.

Thirdly, we always try to optimize L1 instruction cache footprint in 
fastpaths as well and new instructions increase the icache footprint. 

Fourthly, the "single branch overhead" is the *best case* that is 
rarely achieved in practice: often there are other instructions such 
as the compare instruction that precedes the branch ...

These are the reasons why we did various micro-optimizations in the 
past like:

  b80ef10e84d8: x86: Move do_page_fault()'s error path under unlikely()
  92181f190b64: x86: optimise x86's do_page_fault (C entry point for the page fault path)
  74a0b5762713: x86: optimize page faults like all other achitectures and kill notifier cruft

So if he argues that a single condition does not matter to our page 
fault fastpath then that is just crazy talk and i'd not let him close 
to the page fault code with a ten foot pole.

Thanks,

	Ingo
