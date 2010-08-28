Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753425Ab0H1Nfx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Aug 2010 09:35:53 -0400
Received: from casper.infradead.org ([85.118.1.10]:43035 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751328Ab0H1Nfw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Aug 2010 09:35:52 -0400
Subject: Re: [PATCH/RFCv4 0/6] The Contiguous Memory Allocator framework
From: Peter Zijlstra <peterz@infradead.org>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Michal Nazarewicz <m.nazarewicz@samsung.com>, linux-mm@kvack.org,
        Daniel Walker <dwalker@codeaurora.org>,
        FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
        Jonathan Corbet <corbet@lwn.net>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Pawel Osciak <p.osciak@samsung.com>,
        Russell King <linux@arm.linux.org.uk>,
        Zach Pfeffer <zpfeffer@codeaurora.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org, Mel Gorman <mel@csn.ul.ie>
In-Reply-To: <201008281508.19756.hverkuil@xs4all.nl>
References: <cover.1282286941.git.m.nazarewicz@samsung.com>
	 <1282310110.2605.976.camel@laptop>
	 <20100825155814.25c783c7.akpm@linux-foundation.org>
	 <201008281508.19756.hverkuil@xs4all.nl>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Sat, 28 Aug 2010 15:34:46 +0200
Message-ID: <1283002486.1975.3479.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2010-08-28 at 15:08 +0200, Hans Verkuil wrote:

> > That would be good.  Although I expect that the allocation would need
> > to be 100% rock-solid reliable, otherwise the end user has a
> > non-functioning device.
> 
> Yes, indeed. And you have to be careful as well how you move pages around.
> Say that you have a capture and an output v4l device: the first one needs
> 64 MB contiguous memory and so it allocates that amount, moving pages around
> as needed. Once allocated that memory is pinned in place since it is needed
> for DMA. So if the output device also needs 64 MB, then you must have a
> guarantee that the first allocation didn't fragment the available contiguous
> memory.

Isn't the proposed CMA thing vulnerable to the exact same problem? If
you allow sharing of regions and plug some allocator in there you get
the same problem. If you can solve it there, you can solve it for any
kind of reservation scheme.

> I also wonder how expensive it is to move all the pages around. E.g. if you
> have a digital camera and want to make a hires picture, then it wouldn't
> do if it takes a second to move all the pages around making room for the
> captured picture. The CPUs in many SoCs are not very powerful compared to
> your average desktop.

Well, that's a trade-off, if you want to have the memory be usable for
anything else (which I understood people did want) then you have to pay
for cleaning it up when you need to use it.

As for the cost of compaction vs regular page-out of random page-cache
memory, compaction is actually cheaper, since it doesn't need to write
out dirty data, and page-out driven writeback sucks due to the
non-linear nature of it.

> And how would memory allocations in specific memory ranges (e.g. memory
> banks) work?

Make sure you reserve pageblocks in the desired range.

> Note also that these issues are not limited to embedded systems, also PCI(e)
> boards can sometimes require massive amounts of DMA-able memory. I have had
> this happen in the past with the ivtv driver with customers that had 15 or so
> capture cards in one box. And I'm sure it will happen in the future as well,
> esp. with upcoming 4k video formats.

I would sincerely hope PCI(e) devices come with an IOMMU (and all memory
lines wired up), really, any hardware that doesn't isn't worth the
silicon its engraved in. Just don't buy it.

