Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752726Ab0DGCZH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Apr 2010 22:25:07 -0400
Received: from mga11.intel.com ([192.55.52.93]:11932 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751448Ab0DGCY6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Apr 2010 22:24:58 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.51,376,1267430400"; 
   d="scan'208";a="555621463"
Date: Wed, 7 Apr 2010 10:24:56 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Taras Glek <tglek@mozilla.com>, "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Downsides to madvise/fadvise(willneed) for application startup
Message-ID: <20100407022456.GA9468@localhost>
References: <4BBA6776.5060804@mozilla.com> <20100406095135.GB5183@cmpxchg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100406095135.GB5183@cmpxchg.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Taras,

On Tue, Apr 06, 2010 at 05:51:35PM +0800, Johannes Weiner wrote:
> On Mon, Apr 05, 2010 at 03:43:02PM -0700, Taras Glek wrote:
> > Hello,
> > I am working on improving Mozilla startup times. It turns out that page 
> > faults(caused by lack of cooperation between user/kernelspace) are the 
> > main cause of slow startup. I need some insights from someone who 
> > understands linux vm behavior.

How about improve Fedora (and other distros) to preload Mozilla (and
other apps the user run at the previous boot) with fadvise() at boot
time? This sounds like the most reasonable option.

As for the kernel readahead, I have a patchset to increase default
mmap read-around size from 128kb to 512kb (except for small memory
systems).  This should help your case as well.

> > Current Situation:
> > The dynamic linker mmap()s  executable and data sections of our 
> > executable but it doesn't call madvise().
> > By default page faults trigger 131072byte reads. To make matters worse, 
> > the compile-time linker + gcc lay out code in a manner that does not 
> > correspond to how the resulting executable will be executed(ie the 
> > layout is basically random). This means that during startup 15-40mb 
> > binaries are read in basically random fashion. Even if one orders the 
> > binary optimally, throughput is still suboptimal due to the puny readahead.
> > 
> > IO Hints:
> > Fortunately when one specifies madvise(WILLNEED) pagefaults trigger 2mb 
> > reads and a binary that tends to take 110 page faults(ie program stops 
> > execution and waits for disk) can be reduced down to 6. This has the 
> > potential to double application startup of large apps without any clear 
> > downsides.
> >
> > Suse ships their glibc with a dynamic linker patch to fadvise()
> > dynamic libraries(not sure why they switched from doing madvise
> > before).

This is interesting. I wonder how SuSE implements the policy.
Do you have the patch or some strace output that demonstrates the
fadvise() call?

> > I filed a glibc bug about this at 
> > http://sourceware.org/bugzilla/show_bug.cgi?id=11431 . Uli commented 
> > with his concern about wasting memory resources. What is the impact of 
> > madvise(WILLNEED) or the fadvise equivalent on systems under memory 
> > pressure? Does the kernel simply start ignoring these hints?
> 
> It will throttle based on memory pressure.  In idle situations it will
> eat your file cache, however, to satisfy the request.
> 
> Now, the file cache should be much bigger than the amount of unneeded
> pages you prefault with the hint over the whole library, so I guess the
> benefit of prefaulting the right pages outweighs the downside of evicting
> some cache for unused library pages.
> 
> Still, it's a workaround for deficits in the demand-paging/readahead
> heuristics and thus a bit ugly, I feel.  Maybe Wu can help.

Program page faults are inherently random, so the straightforward
solution would be to increase the mmap read-around size (for desktops
with reasonable large memory), rather than to improve program layout
or readahead heuristics :)

> > Also, once an application is started is it reasonable to keep it 
> > madvise(WILLNEED)ed or should the madvise flags be reset?
> 
> It's a one-time operation that starts immediate readahead, no permanent
> changes are done.

Right. The kernel regard WILLNEED as a readahead request from userspace.

> > Perhaps the kernel could monitor the page-in patterns to increase the 
> > readahead sizes? This may already happen, I've noticed that a handful of 
> > pagefaults trigger > 131072bytes of IO, perhaps this just needs tweaking.
> 
> CCd the man :-)

Thank you :)

Cheers,
Fengguang
