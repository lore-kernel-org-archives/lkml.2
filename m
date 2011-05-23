Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752249Ab1EWKtU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 May 2011 06:49:20 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:56425 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750883Ab1EWKtT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 May 2011 06:49:19 -0400
Date: Mon, 23 May 2011 12:49:02 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Dan Rosenberg <drosenberg@vsecurity.com>
Cc: Tony Luck <tony.luck@gmail.com>, linux-kernel@vger.kernel.org,
        davej@redhat.com, kees.cook@canonical.com, davem@davemloft.net,
        eranian@google.com, torvalds@linux-foundation.org, adobriyan@gmail.com,
        penberg@kernel.org, hpa@zytor.com,
        Arjan van de Ven <arjan@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [BUG] perf: bogus correlation of kernel symbols
Message-ID: <20110523104902.GB24674@elte.hu>
References: <1305292059.1949.0.camel@dan>
 <1305293345.1949.22.camel@dan>
 <20110516153527.GC21107@elte.hu>
 <1305852966.3005.19.camel@dan>
 <20110520120750.GJ14745@elte.hu>
 <1305896093.3005.24.camel@dan>
 <20110520131108.GA17699@elte.hu>
 <1306089922.1806.27.camel@dan>
 <BANLkTik1SK_kWVvGsKk0SqdByQ5-0b5nFg@mail.gmail.com>
 <1306110336.25049.7.camel@dan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1306110336.25049.7.camel@dan>
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


* Dan Rosenberg <drosenberg@vsecurity.com> wrote:

> On Sun, 2011-05-22 at 16:49 -0700, Tony Luck wrote:
> > 
> > 
> > On Sun, May 22, 2011 at 11:45 AM, Dan Rosenberg
> > <drosenberg@vsecurity.com> wrote:
> >         1. Is it ok to assume the existence of rdtsc?  If not, what
> >         are other
> >         ways of gathering entropy early in the boot process?  If this
> >         is the
> >         approach that's going to be taken, system uptime potentially
> >         becomes
> >         useful for attackers.  Any thoughts on how to address this?
> >         
> > There is a cpuid bit to tell you whether the processor supports rdtsc.
> > 
> 
> This might be worth checking, but it also might just be easier to clearly 
> document in the Kconfig that the feature requires rdtsc.  I'll play with it a 
> bit.

All modern x86 boxes have an RDTSC so this not really a practical concern - 
other than not crashing old boxes that do not have an RDTSC.

In theory there's other sources of entropy: we could read out the RTC CMOS as 
well. We could also read the current CPU frequency and fan speeds - those have 
components of thermal noise as well. Obviously it's hard to read this out early 
during bootup, when system devices are not enumerated yet.

What would be very useful is to print out the bootup RDTSC value for several 
bootups. I've done this on a testbox here, with real full reboots inbetween, 
putting the RDTSC printout very close to where you'd sample it for kernel image 
randomization:

[    0.000000] RDTSC: 26615467048
[    0.000000] RDTSC: 26527108278
[    0.000000] RDTSC: 26464738628
[    0.000000] RDTSC: 26554778708
[    0.000000] RDTSC: 26441165788
[    0.000000] RDTSC: 26555252088
[    0.000000] RDTSC: 26431986988
[    0.000000] RDTSC: 26521303608
[    0.000000] RDTSC: 26497878018
[    0.000000] RDTSC: 26455546968
[    0.000000] RDTSC: 26467673718
[    0.000000] RDTSC: 26460404758
[    0.000000] RDTSC: 26496175038

Even visually there's *plenty* of real randomness in the bootup value of the 
cycle counter (look at the above pattern of numbers and squint), even during 
early bootup, on real hardware.

While the last few bits are non-random there's at least 10-20 bits of 
randomness on this (very simple) testbox - possibly more.

I've done a few tests on virtual hardware as well, KVM based:

[    0.000000] RDTSC: 208122033
[    0.000000] RDTSC: 200455104
[    0.000000] RDTSC: 207258945

As expected there's even more randmness on virtual hardware than on real 
hardware: virtual hardware will boot in a complex host CPU state and is so 
exposed to the non-determinisic CPU cache state.

So the cycle counter is plenty good for this.

[ I'd only worry about the cycle counter if a hardware platform is so 
  minimalistic that it boots up very quickly without exposing itself to natural 
  sources of entropy. Eventually we'll get such systems, but right now the 
  cycle counter is good enough. ]

Btw, we already rely on the cycle counter for early bootup randomness: 
boot_init_stack_canary() relies on it.

> > Sometime soon you'll have "rdrand" available (check a different cpuid bit).
> 
> This of course is highly preferable, but I'd rather implement a solution 
> that's widely supported in hardware today.  Perhaps further down the road it 
> could be switched.

Well, since entropy does not get reduced on addition of independent variables 
the right sequence is (pseudocode):

	rnd  = entropy_cycles();
	rnd += entropy_rdrand();
	rnd += entropy_RTC();
	rnd += entropy_system();

That way systems that do not have RDRAND will still have the other ones as 
fallback.

Of course in your prototype you can use RDTSC as a first step, just make it 
easy to add other sources.

Thanks,

	Ingo
