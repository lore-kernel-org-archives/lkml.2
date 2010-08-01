Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755894Ab0HAIUI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Aug 2010 04:20:08 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:35452 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752412Ab0HAIUA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Aug 2010 04:20:00 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Trond Myklebust <trond.myklebust@fys.uio.no>
Subject: Re: [PATCH 6/6] vmscan: Kick flusher threads to clean pages when reclaim is encountering dirty pages
Cc: kosaki.motohiro@jp.fujitsu.com, Andrew Morton <akpm@linux-foundation.org>,
        Mel Gorman <mel@csn.ul.ie>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
        Dave Chinner <david@fromorbit.com>,
        Chris Mason <chris.mason@oracle.com>, Nick Piggin <npiggin@suse.de>,
        Rik van Riel <riel@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>,
        Christoph Hellwig <hch@infradead.org>,
        Wu Fengguang <fengguang.wu@intel.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Andrea Arcangeli <aarcange@redhat.com>
In-Reply-To: <1280529653.12852.67.camel@heimdal.trondhjem.org>
References: <20100730150601.199c5618.akpm@linux-foundation.org> <1280529653.12852.67.camel@heimdal.trondhjem.org>
Message-Id: <20100801170115.4AFC.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Sun,  1 Aug 2010 17:19:56 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Trond,

> There is that, and then there are issues with the VM simply lying to the
> filesystems.
> 
> See https://bugzilla.kernel.org/show_bug.cgi?id=16056
> 
> Which basically boils down to the following: kswapd tells the filesystem
> that it is quite safe to do GFP_KERNEL allocations in pageouts and as
> part of try_to_release_page().
> 
> In the case of pageouts, it does set the 'WB_SYNC_NONE', 'nonblocking'
> and 'for_reclaim' flags in the writeback_control struct, and so the
> filesystem has at least some hint that it should do non-blocking i/o.
> 
> However if you trust the GFP_KERNEL flag in try_to_release_page() then
> the kernel can and will deadlock, and so I had to add in a hack
> specifically to tell the NFS client not to trust that flag if it comes
> from kswapd.

Can you please elaborate your issue more? vmscan logic is, briefly, below

	if (PageDirty(page))
		pageout(page)
	if (page_has_private(page)) {
		try_to_release_page(page, sc->gfp_mask))

So, I'm interest why nfs need to writeback at ->release_page again even
though pageout() call ->writepage and it was successfull.

In other word, an argument gfp_mask of try_to_release_page() is suspected
to pass kmalloc()/alloc_page() familiy. and page allocator have already care
PF_MEMALLOC flag.

So, My question is, What do you want additional work to VM folks?
Can you please share nfs design and what we should?


btw, Another question, Recently, Xiaotian Feng posted "swap over nfs -v21"
patch series. they have new reservation memory framework. Is this help you?




