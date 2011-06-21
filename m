Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756492Ab1FUODk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jun 2011 10:03:40 -0400
Received: from merlin.infradead.org ([205.233.59.134]:46933 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753210Ab1FUODj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jun 2011 10:03:39 -0400
Subject: Re: [PATCH RFC 0/7] x86: convert ticketlocks to C and remove
 duplicate code
From: Peter Zijlstra <peterz@infradead.org>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        the arch/x86 maintainers <x86@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Nick Piggin <npiggin@kernel.dk>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
In-Reply-To: <cover.1308259496.git.jeremy.fitzhardinge@citrix.com>
References: <cover.1308259496.git.jeremy.fitzhardinge@citrix.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Tue, 21 Jun 2011 16:01:08 +0200
Message-ID: <1308664868.26237.173.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-06-16 at 14:40 -0700, Jeremy Fitzhardinge wrote:
> From: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
> 
> Hi all,
> 
> I'm proposing this series for 3[.0].1.
> 
> This is a repost of a series to clean up the x86 ticket lock
> code by converting it to a mostly C implementation and removing
> lots of duplicate code relating to the ticket size.
> 
> The last time I posted this series, the only significant comments
> were from Nick Piggin, specifically relating to:
> 
>  1. A wrongly placed barrier on unlock (which may have allowed the
>     compiler to move things out of the locked region.  I went
>     belt-and-suspenders by having two barriers to prevent motion
>     into or out of the locked region.
> 
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
> 
> I couldn't measure a consistent performance difference between the two
> implemenations; there seemed to be +/- ~1% +/-, which is the level of
> variation I see from simply recompiling the kernel with slightly
> different code alignment.
> 
> Overall, I think the large reduction in code size is a big win.

No complaints from me, I rather like the result.

One other thing you could contemplate is adding something like:

#define xadd(ptr, inc)							\
do {									\
	switch(sizeof(*(ptr))) {					\
	case 1:								\
		asm volatile (LOCK_PREFIX "xaddb %0, %1\n"		\
                             : "+r" (inc), "+m" (*(ptr))		\
                             : : "memory", "cc");			\
	case 2:
		... xaddw ...
	case 4:
		... xaddl ...
} while (0)

and a similar something for inc. For both there seem to be various asm
bits left (we could even consider adding xadd to
arch/x86/include/asm/cmpxchg*.h).

Also, you might have wanted to CC Linus on this, he's usually interested
in these bits.
