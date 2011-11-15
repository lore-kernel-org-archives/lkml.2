Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756816Ab1KOADt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Nov 2011 19:03:49 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:50590 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752083Ab1KOADr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Nov 2011 19:03:47 -0500
Date: Mon, 14 Nov 2011 16:03:45 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Mel Gorman <mgorman@suse.de>
Cc: Minchan Kim <minchan.kim@gmail.com>, Jan Kara <jack@suse.cz>,
        Andy Isaacson <adi@hexapodia.org>,
        Johannes Weiner <jweiner@redhat.com>,
        Andrea Arcangeli <aarcange@redhat.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [PATCH] mm: Do not stall in synchronous compaction for THP
 allocations
Message-Id: <20111114160345.01e94987.akpm@linux-foundation.org>
In-Reply-To: <20111111100156.GI3083@suse.de>
References: <20111110100616.GD3083@suse.de>
	<20111110142202.GE3083@suse.de>
	<CAEwNFnCRCxrru5rBk7FpypqeL8nD=SY5W3-TaA7Ap5o4CgDSbg@mail.gmail.com>
	<20111110161331.GG3083@suse.de>
	<20111110151211.523fa185.akpm@linux-foundation.org>
	<20111111100156.GI3083@suse.de>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 11 Nov 2011 10:01:56 +0000
Mel Gorman <mgorman@suse.de> wrote:

> On Thu, Nov 10, 2011 at 03:12:11PM -0800, Andrew Morton wrote:
> > On Thu, 10 Nov 2011 16:13:31 +0000
> > Mel Gorman <mgorman@suse.de> wrote:
> > 
> > > This patch once again prevents sync migration for transparent
> > > hugepage allocations as it is preferable to fail a THP allocation
> > > than stall.
> > 
> > Who said?  ;)
> 
> Everyone who ever complained about stalls due to writing to USB :)

oh, here it is.  Who broke mesage threading?

> In the last few releases, we have squashed a number of stalls due
> to writing pages from the end of the LRU but sync compaction is a
> relatively recent new root cause of stalls.
> 
> > Presumably some people would prefer to get lots of
> > huge pages for their 1000-hour compute job, and waiting a bit to get
> > those pages is acceptable.
> > 
> 
> A 1000-hour compute job will have its pages collapsed into hugepages by
> khugepaged so they might not have the huge pages at the very beginning
> but they get them. With khugepaged in place, there should be no need for
> an additional tuneable.

OK...

> > Do we have the accounting in place for us to be able to determine how
> > many huge page allocation attempts failed due to this change?
> > 
> 
> thp_fault_fallback is the big one. It is incremented if we fail to
> 	allocate a hugepage during fault in either
> 	do_huge_pmd_anonymous_page or do_huge_pmd_wp_page_fallback
> 
> thp_collapse_alloc_failed is also very interesting. It is incremented
> 	if khugepaged tried to collapse pages into a hugepage and
> 	failed the allocation
> 
> The user has the  option of monitoring their compute jobs hugepage
> usage by reading /proc/PID/smaps and looking at the AnonHugePages
> count for the large mappings of interest.

Fair enough.  One slight problem though:

akpm:/usr/src/25> grep -r thp_collapse_alloc_failed Documentation 
akpm:/usr/src/25> 

