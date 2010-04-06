Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753224Ab0DFJvt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Apr 2010 05:51:49 -0400
Received: from f0.cmpxchg.org ([85.214.51.133]:56639 "EHLO cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752127Ab0DFJvn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Apr 2010 05:51:43 -0400
Date: Tue, 6 Apr 2010 11:51:35 +0200
From: Johannes Weiner <hannes@cmpxchg.org>
To: Taras Glek <tglek@mozilla.com>
Cc: Wu Fengguang <fengguang.wu@intel.com>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
Subject: Re: Downsides to madvise/fadvise(willneed) for application startup
Message-ID: <20100406095135.GB5183@cmpxchg.org>
References: <4BBA6776.5060804@mozilla.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BBA6776.5060804@mozilla.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 05, 2010 at 03:43:02PM -0700, Taras Glek wrote:
> Hello,
> I am working on improving Mozilla startup times. It turns out that page 
> faults(caused by lack of cooperation between user/kernelspace) are the 
> main cause of slow startup. I need some insights from someone who 
> understands linux vm behavior.
> 
> Current Situation:
> The dynamic linker mmap()s  executable and data sections of our 
> executable but it doesn't call madvise().
> By default page faults trigger 131072byte reads. To make matters worse, 
> the compile-time linker + gcc lay out code in a manner that does not 
> correspond to how the resulting executable will be executed(ie the 
> layout is basically random). This means that during startup 15-40mb 
> binaries are read in basically random fashion. Even if one orders the 
> binary optimally, throughput is still suboptimal due to the puny readahead.
> 
> IO Hints:
> Fortunately when one specifies madvise(WILLNEED) pagefaults trigger 2mb 
> reads and a binary that tends to take 110 page faults(ie program stops 
> execution and waits for disk) can be reduced down to 6. This has the 
> potential to double application startup of large apps without any clear 
> downsides. Suse ships their glibc with a dynamic linker patch to 
> fadvise() dynamic libraries(not sure why they switched from doing 
> madvise before).
> 
> I filed a glibc bug about this at 
> http://sourceware.org/bugzilla/show_bug.cgi?id=11431 . Uli commented 
> with his concern about wasting memory resources. What is the impact of 
> madvise(WILLNEED) or the fadvise equivalent on systems under memory 
> pressure? Does the kernel simply start ignoring these hints?

It will throttle based on memory pressure.  In idle situations it will
eat your file cache, however, to satisfy the request.

Now, the file cache should be much bigger than the amount of unneeded
pages you prefault with the hint over the whole library, so I guess the
benefit of prefaulting the right pages outweighs the downside of evicting
some cache for unused library pages.

Still, it's a workaround for deficits in the demand-paging/readahead
heuristics and thus a bit ugly, I feel.  Maybe Wu can help.

> Also, once an application is started is it reasonable to keep it 
> madvise(WILLNEED)ed or should the madvise flags be reset?

It's a one-time operation that starts immediate readahead, no permanent
changes are done.

> Perhaps the kernel could monitor the page-in patterns to increase the 
> readahead sizes? This may already happen, I've noticed that a handful of 
> pagefaults trigger > 131072bytes of IO, perhaps this just needs tweaking.

CCd the man :-)

> Thanks,
> Taras Glek
> 
> PS. For more details on this issue see my blog at 
> https://blog.mozilla.com/tglek/
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
