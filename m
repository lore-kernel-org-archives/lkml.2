Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751429Ab1FYKMK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Jun 2011 06:12:10 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:40607 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750950Ab1FYKMI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Jun 2011 06:12:08 -0400
Date: Sat, 25 Jun 2011 12:11:46 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Peter Zijlstra <peterz@infradead.org>, "H. Peter Anvin" <hpa@zytor.com>,
        the arch/x86 maintainers <x86@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Nick Piggin <npiggin@kernel.dk>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: Re: [PATCH RFC 0/7] x86: convert ticketlocks to C and remove
 duplicate code
Message-ID: <20110625101146.GB19097@elte.hu>
References: <cover.1308259496.git.jeremy.fitzhardinge@citrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1308259496.git.jeremy.fitzhardinge@citrix.com>
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


* Jeremy Fitzhardinge <jeremy@goop.org> wrote:

>  2. With NR_CPUS < 256 the ticket size is 8 bits.  The compiler doesn't
>     use the same trick as the hand-coded asm to directly compare the high
>     and low bytes in the word, but does a bit of extra shuffling around.
>     However, the Intel optimisation guide and several x86 experts have
>     opined that its best to avoid the high-byte operations anyway, since
>     they will cause a partial word stall, and the gcc-generated code should
>     be better.
> 
>     Overall the compiler-generated code is very similar to the hand-coded
>     versions, with the partial byte operations being the only significant
>     difference. (Curiously, gcc does generate a high-byte compare for me
>     in trylock, so it can if it wants to.)
> 
> I've been running with this code in place for several months on 4 core
> systems without any problems.

Please do measurements both in terms of disassembly based instruction 
count(s) in the fastpath(s) (via looking at the before/after 
disassembly) and actual cycle, instruction and branch counts (via 
perf measurements).

> I couldn't measure a consistent performance difference between the two
> implemenations; there seemed to be +/- ~1% +/-, which is the level of
> variation I see from simply recompiling the kernel with slightly
> different code alignment.

Then you've done the micro-cost measurements the wrong way - we can 
and do detect much finer effects than 1%, see the methods used in 
this commit for example:

  c8b281161dfa: sched: Increase SCHED_LOAD_SCALE resolution

Please also ensure that the cold-cache behavior is fairly measured 
via hot-cache benchmarks (that is not always guaranteed).

Thanks,

	Ingo
