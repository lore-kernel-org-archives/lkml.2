Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752350Ab2HTKKr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 06:10:47 -0400
Received: from one.firstfloor.org ([213.235.205.2]:59228 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751357Ab2HTKKq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 06:10:46 -0400
Date: Mon, 20 Aug 2012 12:10:44 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
        x86@kernel.org, mmarek@suse.cz, linux-kbuild@vger.kernel.org,
        JBeulich@suse.com, akpm@linux-foundation.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: RFC: Link Time Optimization support for the kernel
Message-ID: <20120820101044.GE16230@one.firstfloor.org>
References: <1345345030-22211-1-git-send-email-andi@firstfloor.org> <20120820074835.GA6710@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120820074835.GA6710@gmail.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 20, 2012 at 09:48:35AM +0200, Ingo Molnar wrote:
> 
> * Andi Kleen <andi@firstfloor.org> wrote:
> 
> > This rather large patchkit enables gcc Link Time Optimization (LTO) 
> > support for the kernel. 
> > 
> > With LTO gcc will do whole program optimizations for
> > the whole kernel and each module. This increases compile time,
> > but can generate faster code.
> 
> By how much does it increase compile time?

All numbers are preliminary at this point. I miss both some code
quality and compile time improvements that it could do, to work
around some issues that are fixable.

Compile time:

Compilation slowdown depends on the largest binary size.  I see between 
50% and 4x.  The 4x case is mainly for allyes (so unlikely); a normal
distro build, which is mostly modular, or a defconfig like build is more
towards the 50%. 

Currently I have to disable slim LTO, which essentially means everything
is compiled twice. Once that's fixed it should compile faster for
the normal case too (although it will be still slower than non LTO)

A lot of the overhead on the larger builds is also some specific 
gcc code that I'm working with the gcc developers on to improve.
So the 4x extreme case will hopefully go down.

The large builds also currently suffer from too much memory
consumption. That will hopefully improve too, as gcc improves.

I wouldn't expect anyone using it for day to day kernel hacking
(I understand that 50% are annoying for that). It's more like a
 "release build" mode.

The performance is currently also missing some improvements due
to workarounds.

Performance:

Hackbench goes about 5% faster, so the scheduler benefits. Kbuild
is not changing much. Various network benchmarks over loopback
go faster too (best case seen 18%+), so the network stack seems to 
benefit. A lot of micro benchmarks go faster, sometimes larger numbers. 
There are some minor regressions.

A lot of benchmarking on larger workloads is still outstanding.
But the existing numbers are promising I believe. Things will still
change, it's still early. 

I would welcome any benchmarking from other people.

I also expect gcc to do more LTO optimizations in the future, so we'll
hopefully see more gains over time. Essentially it gives more
power to the compiler.

Long term it would also help the kernel source organization. For example
there's no reason with LTO to have gigantic includes with large inlines,
because cross file inlining works in a efficient way without reparsing.

In theory (but that's not realized today) the automatic repartitioning of
compilation units could improve compile time with lots of small files

-Andi
