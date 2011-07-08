Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754241Ab1GHR0q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jul 2011 13:26:46 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:55538 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751352Ab1GHR0p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jul 2011 13:26:45 -0400
Date: Fri, 8 Jul 2011 18:25:41 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org,
        Daniel Walker <dwalker@codeaurora.org>,
        Jonathan Corbet <corbet@lwn.net>, Mel Gorman <mel@csn.ul.ie>,
        Chunsang Jeong <chunsang.jeong@linaro.org>,
        Jesse Barker <jesse.barker@linaro.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        linux-kernel@vger.kernel.org, Michal Nazarewicz <mina86@mina86.com>,
        linaro-mm-sig@lists.linaro.org, linux-mm@kvack.org,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Ankita Garg <ankita@in.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        linux-media@vger.kernel.org
Subject: Re: [PATCH 6/8] drivers: add Contiguous Memory Allocator
Message-ID: <20110708172541.GM4812@n2100.arm.linux.org.uk>
References: <1309851710-3828-1-git-send-email-m.szyprowski@samsung.com> <201107051427.44899.arnd@arndb.de> <20110705123035.GD8286@n2100.arm.linux.org.uk> <201107051558.39344.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201107051558.39344.arnd@arndb.de>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 05, 2011 at 03:58:39PM +0200, Arnd Bergmann wrote:
> Ah, sorry I missed that patch on the mailing list, found it now in
> your for-next branch.

I've been searching for this email to reply to for the last day or
so...

> If I'm reading your "ARM: DMA: steal memory for DMA coherent mappings"
> correctly, the idea is to have a per-platform compile-time amount
> of memory that is reserved purely for coherent allocations and
> taking out of the buddy allocator, right?

Yes, because every time I've looked at taking out memory mappings in
the first level page tables, it's always been a major issue.

We have a method where we can remove first level mappings on
uniprocessor systems in the ioremap code just fine - we use that so
that systems can setup section and supersection mappings.  They can
tear them down as well - and we update other tasks L1 page tables
when they get switched in.

This, however, doesn't work on SMP, because if you have a DMA allocation
(which is permitted from IRQ context) you must have some way of removing
the L1 page table entries from all CPUs TLBs and the page tables currently
in use and any future page tables which those CPUs may switch to.

The easy bit is "future page tables" - that can be done in the same way
as the ioremap() code does with a generation number, checked when a new
page table is switched in.  The problem is the current CPUs, and as we
know trying to call smp_call_function() with IRQs disabled is not
permitted due to deadlock.

So, in a SMP system, there is no safe way to remove L1 page table entries
from IRQ context.  That means if memory is mapped for the buddy allocators
using L1 page table entries, then it is fixed for that application on a
SMP system.

However, that's not really what I wanted to find this email for.  That
is I'm dropping the "ARM: DMA: steal memory for DMA coherent mappings"
patch for this merge window because - as I found out yesterday - it
prevents the Assabet platform booting, and so would be a regression.

Plus, I have a report of a regression with the streaming DMA API
speculative prefetch fixes causing the IOP ADMA raid5 async offload
stuff to explode - which may result in the streaming DMA API fixes
being reverted (which will leave ARMv6+ vulnerable to data corruption.)
As I have no time to work through the RAID5 code, async_tx code, and
IOP ADMA code to get to the bottom of it (because of this flood of
patches) I think a revert is looking likely - either that or I'll have
to tell the bug reporter to go away, which really isn't on.  It's on
LKML if anyone's interested in trying to diagnose it, the
"PROBLEM: ARM-dma-mapping-fix-for-speculative-prefetching cause OOPS"
thread.
