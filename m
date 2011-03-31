Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755384Ab1CaU2x (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Mar 2011 16:28:53 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:52043 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752186Ab1CaU2v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Mar 2011 16:28:51 -0400
Subject: Re: [PATCH 05/12] mm: alloc_contig_range() added
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Michal Nazarewicz <mina86@mina86.com>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-media@vger.kernel.org,
        linux-mm@kvack.org, Kyungmin Park <kyungmin.park@samsung.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Ankita Garg <ankita@in.ibm.com>,
        Daniel Walker <dwalker@codeaurora.org>,
        Johan MOSSBERG <johan.xx.mossberg@stericsson.com>,
        Mel Gorman <mel@csn.ul.ie>, Pawel Osciak <pawel@osciak.com>
In-Reply-To: <op.vs7umufd3l0zgt@mnazarewicz-glaptop>
References: <1301577368-16095-1-git-send-email-m.szyprowski@samsung.com>
	 <1301577368-16095-6-git-send-email-m.szyprowski@samsung.com>
	 <1301587361.31087.1040.camel@nimitz>
	 <op.vs7umufd3l0zgt@mnazarewicz-glaptop>
Content-Type: text/plain; charset="ISO-8859-1"
Date: Thu, 31 Mar 2011 13:28:42 -0700
Message-ID: <1301603322.31087.1196.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-03-31 at 18:26 +0200, Michal Nazarewicz wrote:
> > On Thu, 2011-03-31 at 15:16 +0200, Marek Szyprowski wrote:
> >> +       ret = 0;
> >> +       while (!PageBuddy(pfn_to_page(start & (~0UL << ret))))
> >> +               if (WARN_ON(++ret >= MAX_ORDER))
> >> +                       return -EINVAL;
> 
> On Thu, 31 Mar 2011 18:02:41 +0200, Dave Hansen wrote:
> > Holy cow, that's dense.  Is there really no more straightforward way to
> > do that?
> 
> Which part exactly is dense?  What would be qualify as a more
> straightforward way?

I'm still not 100% sure what it's trying to do.  It looks like it
attempts to check all of "start"'s buddy pages.

unsigned long find_buddy(unsigned long pfn, int buddy)
{
	unsigned long page_idx = pfn & ((1 << MAX_ORDER) - 1); // You had a macro for this I think
	unsigned long buddy_idx = __find_buddy_index(page_idx, order);
	return page_idx + buddy_idx;
}

Is something like this equivalent?

int order;
for (order = 0; order <= MAX_ORDER; order++) {
	unsigned long buddy_pfn = find_buddy(start, order);
	struct page *buddy = pfn_to_page(buddy_pfn);
	if (PageBuddy(buddy)
		break;
	WARN();
	return -EINVAL;
}

I'm wondering also if you can share some code with __rmqueue().

> > In any case, please pull the ++ret bit out of the WARN_ON().  Some
> > people like to do:
> >
> > #define WARN_ON(...) do{}while(0)
> >
> > to save space on some systems.
> 
> I don't think that's the case.  Even if WARN_ON() decides not to print
> a warning, it will still return the value of the argument.  If not,
> a lot of code will brake.

Bah, sorry.  I'm confusing WARN_ON() and WARN().

-- Dave

