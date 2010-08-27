Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752669Ab0H0IVy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Aug 2010 04:21:54 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:56880 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751551Ab0H0IVv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Aug 2010 04:21:51 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Fri, 27 Aug 2010 17:16:39 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Minchan Kim <minchan.kim@gmail.com>
Cc: =?UTF-8?B?TWljaGHFgg==?= Nazarewicz <m.nazarewicz@samsung.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Daniel Walker <dwalker@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        Jonathan Corbet <corbet@lwn.net>,
        Peter Zijlstra <peterz@infradead.org>,
        Pawel Osciak <p.osciak@samsung.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        linux-kernel@vger.kernel.org,
        FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, linux-mm@kvack.org,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Zach Pfeffer <zpfeffer@codeaurora.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Mel Gorman <mel@csn.ul.ie>, linux-media@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Marek Szyprowski <m.szyprowski@samsung.com>
Subject: Re: [PATCH/RFCv4 0/6] The Contiguous Memory Allocator framework
Message-Id: <20100827171639.83c8642c.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <AANLkTimB+s0tO=wrODAU4qCaZnCBoLZ2A9pGjR_jheOj@mail.gmail.com>
References: <cover.1282286941.git.m.nazarewicz@samsung.com>
	<1282310110.2605.976.camel@laptop>
	<20100825155814.25c783c7.akpm@linux-foundation.org>
	<20100826095857.5b821d7f.kamezawa.hiroyu@jp.fujitsu.com>
	<op.vh0wektv7p4s8u@localhost>
	<20100826115017.04f6f707.kamezawa.hiroyu@jp.fujitsu.com>
	<20100826124434.6089630d.kamezawa.hiroyu@jp.fujitsu.com>
	<AANLkTi=T1y+sQuqVTYgOkYvqrxdYB1bZmCpKafN5jPqi@mail.gmail.com>
	<20100826133028.39d731da.kamezawa.hiroyu@jp.fujitsu.com>
	<AANLkTimB+s0tO=wrODAU4qCaZnCBoLZ2A9pGjR_jheOj@mail.gmail.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.3 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 26 Aug 2010 18:36:24 +0900
Minchan Kim <minchan.kim@gmail.com> wrote:

> On Thu, Aug 26, 2010 at 1:30 PM, KAMEZAWA Hiroyuki
> <kamezawa.hiroyu@jp.fujitsu.com> wrote:
> > On Thu, 26 Aug 2010 13:06:28 +0900
> > Minchan Kim <minchan.kim@gmail.com> wrote:
> >
> >> On Thu, Aug 26, 2010 at 12:44 PM, KAMEZAWA Hiroyuki
> >> <kamezawa.hiroyu@jp.fujitsu.com> wrote:
> >> > On Thu, 26 Aug 2010 11:50:17 +0900
> >> > KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:
> >> >
> >> >> 128MB...too big ? But it's depend on config.
> >> >>
> >> >> IBM's ppc guys used 16MB section, and recently, a new interface to shrink
> >> >> the number of /sys files are added, maybe usable.
> >> >>
> >> >> Something good with this approach will be you can create "cma" memory
> >> >> before installing driver.
> >> >>
> >> >> But yes, complicated and need some works.
> >> >>
> >> > Ah, I need to clarify what I want to say.
> >> >
> >> > With compaction, it's helpful, but you can't get contiguous memory larger
> >> > than MAX_ORDER, I think. To get memory larger than MAX_ORDER on demand,
> >> > memory hot-plug code has almost all necessary things.
> >>
> >> True. Doesn't patch's idea of Christoph helps this ?
> >> http://lwn.net/Articles/200699/
> >>
> >
> > yes, I think so. But, IIRC,  it's own purpose of Chirstoph's work is
> > for removing zones. please be careful what's really necessary.
> 
> Ahh. Sorry for missing point.
> You're right. The patch can't help our problem.
> 
> How about changing following this?
> The thing is MAX_ORDER is static. But we want to avoid too big
> MAX_ORDER of whole zones to support devices which requires big
> allocation chunk.
> So let's add MAX_ORDER into each zone and then, each zone can have
> different max order.
> For example, while DMA[32], NORMAL, HIGHMEM can have normal size 11,
> MOVABLE zone could have a 15.
> 
> This approach has a big side effect?
> 

Hm...need to check hard coded MAX_ORDER usages...I don't think
side-effect is big. Hmm. But I think enlarging MAX_ORDER isn't an
important thing. A code which strips contiguous chunks of pages from
buddy allocator is a necessaty thing, as..

What I can think of at 1st is...
==
	int steal_pages(unsigned long start_pfn, unsigned long end_pfn)
	{
		/* Be careful mutal execution with memory hotplug, because reusing code */

		split [start_pfn, end_pfn) to pageblock_order
		
		for each pageblock in the range {
			Mark this block as MIGRATE_ISOLATE
			try-to-free pages in the range or
			migrate pages in the range to somewhere.
			/* Here all pages in the range are on buddy allocator
			and free and never be allocated by anyone else. */
		}

		please see __rmqueue_fallback(). it selects migration-type at 1st.
		Then, if you can pass start_migratetype of MIGLATE_ISOLATE,
		you can automatically strip all MIGRATE_ISOLATE pages from free_area[].

		return chunk of pages.
	}
==

Thanks,
-Kame



