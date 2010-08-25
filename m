Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752900Ab0HYXb3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Aug 2010 19:31:29 -0400
Received: from tex.lwn.net ([70.33.254.29]:53961 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752508Ab0HYXb2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Aug 2010 19:31:28 -0400
Date: Wed, 25 Aug 2010 17:31:25 -0600
From: Jonathan Corbet <corbet@lwn.net>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Michal Nazarewicz <m.nazarewicz@samsung.com>, linux-mm@kvack.org,
        Daniel Walker <dwalker@codeaurora.org>,
        FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Pawel Osciak <p.osciak@samsung.com>,
        Russell King <linux@arm.linux.org.uk>,
        Zach Pfeffer <zpfeffer@codeaurora.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org, Mel Gorman <mel@csn.ul.ie>
Subject: Re: [PATCH/RFCv4 0/6] The Contiguous Memory Allocator framework
Message-ID: <20100825173125.0855a6b0@bike.lwn.net>
In-Reply-To: <20100825155814.25c783c7.akpm@linux-foundation.org>
References: <cover.1282286941.git.m.nazarewicz@samsung.com>
	<1282310110.2605.976.camel@laptop>
	<20100825155814.25c783c7.akpm@linux-foundation.org>
Organization: LWN.net
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.21.6; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 25 Aug 2010 15:58:14 -0700
Andrew Morton <akpm@linux-foundation.org> wrote:

> > If you want guarantees you can free stuff, why not add constraints to
> > the page allocation type and only allow MIGRATE_MOVABLE pages inside a
> > certain region, those pages are easily freed/moved aside to satisfy
> > large contiguous allocations.  
> 
> That would be good.  Although I expect that the allocation would need
> to be 100% rock-solid reliable, otherwise the end user has a
> non-functioning device.  Could generic core VM provide the required level
> of service?

The original OLPC has a camera controller which requires three contiguous,
image-sized buffers in memory.  That system is a little memory constrained
(OK, it's desperately short of memory), so, in the past, the chances of
being able to allocate those buffers anytime some kid decides to start
taking pictures was poor.  Thus, cafe_ccic.c has an option to snag the
memory at initialization time and never let go even if you threaten its
family.  Hell hath no fury like a little kid whose new toy^W educational
tool stops taking pictures.

That, of course, is not a hugely efficient use of memory on a
memory-constrained system.  If the VM could reliably satisfy those
allocation requestss, life would be wonderful.  Seems difficult.  But it
would be a nicer solution than CMA, which, to a great extent, is really
just a standardized mechanism for grabbing memory and never letting go.

> It would help (a lot) if we could get more attention and buyin and
> fedback from the potential clients of this code.  rmk's feedback is
> valuable.  Have we heard from the linux-media people?  What other
> subsystems might use it?  ieee1394 perhaps?  Please help identify
> specific subsystems and I can perhaps help to wake people up.

If this code had been present when I did the Cafe driver, I would have used
it.  I think it could be made useful to a number of low-end camera drivers
if the videobuf layer were made to talk to it in a way which Just Works.

With a bit of tweaking, I think it could be made useful in other
situations: the viafb driver, for example, really needs an allocator for
framebuffer memory and it seems silly to create one from scratch.  Of
course, there might be other possible solutions, like adding a "zones"
concept to LMB^W memblock.

The problem which is being addressed here is real.

That said, the complexity of the solution still bugs me a bit, and the core
idea is still to take big chunks of memory out of service for specific
needs.  It would be far better if the VM could just provide big chunks on
demand.  Perhaps compaction and the pressures of making transparent huge
pages work will get us there, but I'm not sure we're there yet.

jon
