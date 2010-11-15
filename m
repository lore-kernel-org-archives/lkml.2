Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758217Ab0KOTws (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Nov 2010 14:52:48 -0500
Received: from netnation.com ([204.174.223.2]:38652 "EHLO peace.netnation.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1757936Ab0KOTwr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Nov 2010 14:52:47 -0500
Date: Mon, 15 Nov 2010 11:52:46 -0800
From: Simon Kirby <sim@hostway.ca>
To: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Free memory never fully used, swapping
Message-ID: <20101115195246.GB17387@hostway.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

We're seeing cases on a number of servers where cache never fully grows
to use all available memory.  Sometimes we see servers with 4 GB of
memory that never seem to have less than 1.5 GB free, even with a
constantly-active VM.  In some cases, these servers also swap out while
this happens, even though they are constantly reading the working set
into memory.  We have been seeing this happening for a long time;
I don't think it's anything recent, and it still happens on 2.6.36.

I noticed that CONFIG_NUMA seems to enable some more complicated
reclaiming bits and figured it might help since most stock kernels seem
to ship with it now.  This seems to have helped, but it may just be
wishful thinking.  We still see this happening, though maybe to a lesser
degree.  (The following observations are with CONFIG_NUMA enabled.)

I was eyeballing "vmstat 1" and "watch -n.2 -d cat /proc/vmstat" at the
same time, and I can see distinctly that the page cache is growing nicely
until a sudden event where 400 MB is freed within 1 second, leaving
this particular box with 700 MB free again.  kswapd numbers increase in
/proc/vmstat, which leads me to believe that __alloc_pages_slowpath() has
been called, since it seems to be the thing that wakes up kswapd.

Previous patterns and watching of "vmstat 1" show that the swapping out
also seems to occur during the times that memory is quickly freed.

These are all x86_64, and so there is no highmem garbage going on. 
The only zones would be for DMA, right?  Is the combination of memory
fragmentation and large-order allocations the only thing that would be
causing this reclaim here?  Is there some easy bake knob for finding what
is causing the free memory jumps each time this happens?

Kernel config and munin graph of free memory here:

http://0x.ca/sim/ref/2.6.36/

I notice CONFIG_COMPACTION is still "EXPERIMENTAL".  Would it be worth
trying here?  It seems to enable defrag before reclaim, but that sounds
kind of ...complicated...

Cheers,

Simon-

procs -----------memory---------- ---swap-- -----io---- -system-- ----cpu----
 r  b   swpd   free   buff  cache   si   so    bi    bo   in   cs us sy id wa
 1  0  11496 401684  40364 2531844    0    0  4540   773 7890 16291 13  9 77  1
 3  0  11492 400180  40372 2534204    0    0  5572   699 8544 14856 25  9 66  1
 0  0  11492 394344  40372 2540796    0    0  5256   345 8239 16723 17  7 73  2
 0  0  11492 388524  40372 2546236    0    0  5216   393 8687 17289 14  9 76  1
 4  1  11684 716296  40244 2218612    0  220  6868  1837 11124 27368 28 20 51  0
 1  0  11732 753992  40248 2181468    0  120  5240   647 9542 15609 38 11 50  1
 1  0  11712 736864  40260 2197788    0    0  5872  9147 9838 16373 41 11 47  1
 0  0  11712 738096  40260 2196984    0    0  4628   493 7980 15536 22 10 67  1
 2  0  11712 733508  40260 2201756    0    0  4404   418 7265 16867 10  9 80  2
