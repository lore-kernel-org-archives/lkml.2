Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755814Ab1EANrQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 May 2011 09:47:16 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:42811 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754417Ab1EANrP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 May 2011 09:47:15 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Mel Gorman <mgorman@suse.de>
Subject: Re: [RFC 6/8] In order putback lru core
Cc: kosaki.motohiro@jp.fujitsu.com, Minchan Kim <minchan.kim@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
        Christoph Lameter <cl@linux.com>, Johannes Weiner <jweiner@redhat.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Rik van Riel <riel@redhat.com>, Andrea Arcangeli <aarcange@redhat.com>
In-Reply-To: <20110428110623.GU4658@suse.de>
References: <51e7412097fa62f86656c77c1934e3eb96d5eef6.1303833417.git.minchan.kim@gmail.com> <20110428110623.GU4658@suse.de>
Message-Id: <20110501224844.75EC.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.56.05 [ja]
Date: Sun,  1 May 2011 22:47:11 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > +/* This structure is used for keeping LRU ordering of isolated page */
> > +struct pages_lru {
> > +        struct page *page;      /* isolated page */
> > +        struct page *prev_page; /* previous page of isolate page as LRU order */
> > +        struct page *next_page; /* next page of isolate page as LRU order */
> > +        struct list_head lru;
> > +};
> >  /*
> 
> So this thing has to be allocated from somewhere. We can't put it
> on the stack as we're already in danger there so we must be using
> kmalloc. In the reclaim paths, this should be avoided obviously.
> For compaction, we might hurt the compaction success rates if pages
> are pinned with control structures. It's something to be wary of.
> 
> At LSF/MM, I stated a preference for swapping the source and
> destination pages in the LRU. This unfortunately means that the LRU
> now contains a page in the process of being migrated to and the backout
> paths for migration failure become a lot more complex. Reclaim should
> be ok as it'll should fail to lock the page and recycle it in the list.
> This avoids allocations but I freely admit that I'm not in the position
> to implement such a thing right now :(

I like swaping to fake page. one way pointer might become dangerous. vmscan can
detect fake page and ignore it.

ie, 
is_fake_page(page)
{
	if (is_stack_addr((void*)page))
		return true;
	return false;
}

Also, I like to use stack rather than kmalloc in compaction.



