Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752226Ab2HUHt3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 03:49:29 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:50050 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751312Ab2HUHt1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 03:49:27 -0400
Date: Tue, 21 Aug 2012 09:49:21 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org, mmarek@suse.cz,
        linux-kbuild@vger.kernel.org, JBeulich@suse.com,
        akpm@linux-foundation.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: RFC: Link Time Optimization support for the kernel
Message-ID: <20120821074921.GA10809@gmail.com>
References: <1345345030-22211-1-git-send-email-andi@firstfloor.org>
 <20120820074835.GA6710@gmail.com>
 <20120820101044.GE16230@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120820101044.GE16230@one.firstfloor.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Andi Kleen <andi@firstfloor.org> wrote:

> On Mon, Aug 20, 2012 at 09:48:35AM +0200, Ingo Molnar wrote:
> > 
> > * Andi Kleen <andi@firstfloor.org> wrote:
> > 
> > > This rather large patchkit enables gcc Link Time Optimization (LTO) 
> > > support for the kernel. 
> > > 
> > > With LTO gcc will do whole program optimizations for
> > > the whole kernel and each module. This increases compile time,
> > > but can generate faster code.
> > 
> > By how much does it increase compile time?
> 
> All numbers are preliminary at this point. I miss both some 
> code quality and compile time improvements that it could do, 
> to work around some issues that are fixable.
> 
> Compile time:
> 
> Compilation slowdown depends on the largest binary size.  I 
> see between 50% and 4x.  The 4x case is mainly for allyes (so 
> unlikely); a normal distro build, which is mostly modular, or 
> a defconfig like build is more towards the 50%.
> 
> Currently I have to disable slim LTO, which essentially means 
> everything is compiled twice. Once that's fixed it should 
> compile faster for the normal case too (although it will be 
> still slower than non LTO)

The other hope would be that if LTO is used by a high-profile 
project like the Linux kernel then the compiler folks might look 
at it and improve it.

> A lot of the overhead on the larger builds is also some 
> specific gcc code that I'm working with the gcc developers on 
> to improve. So the 4x extreme case will hopefully go down.
> 
> The large builds also currently suffer from too much memory 
> consumption. That will hopefully improve too, as gcc improves.

Are there any LTO build files left around, blowing up the size 
of the build tree?

> I wouldn't expect anyone using it for day to day kernel hacking
> (I understand that 50% are annoying for that). It's more like a
>  "release build" mode.
> 
> The performance is currently also missing some improvements 
> due to workarounds.
> 
> Performance:
> 
> Hackbench goes about 5% faster, so the scheduler benefits. 
> Kbuild is not changing much. Various network benchmarks over 
> loopback go faster too (best case seen 18%+), so the network 
> stack seems to benefit. A lot of micro benchmarks go faster, 
> sometimes larger numbers. There are some minor regressions.
> 
> A lot of benchmarking on larger workloads is still 
> outstanding. But the existing numbers are promising I believe. 
> Things will still change, it's still early.
> 
> I would welcome any benchmarking from other people.
> 
> I also expect gcc to do more LTO optimizations in the future, 
> so we'll hopefully see more gains over time. Essentially it 
> gives more power to the compiler.
> 
> Long term it would also help the kernel source organization. 
> For example there's no reason with LTO to have gigantic 
> includes with large inlines, because cross file inlining works 
> in a efficient way without reparsing.

Can the current implementation of LTO optimize to the level of 
inlining? A lot of our include file hell situation results from 
the desire to declare structures publicly so that inlined 
functions can use them directly.

If data structures could be encapsulated/internalized to 
subsystems and only global functions are exposed to other 
subsystems [which are then LTO optimized] then our include
file dependencies could become a *lot* simpler.

Thanks,

	Ingo
