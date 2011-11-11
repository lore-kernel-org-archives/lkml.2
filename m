Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756085Ab1KKKCH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Nov 2011 05:02:07 -0500
Received: from cantor2.suse.de ([195.135.220.15]:43312 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752085Ab1KKKCE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Nov 2011 05:02:04 -0500
Date: Fri, 11 Nov 2011 10:01:56 +0000
From: Mel Gorman <mgorman@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Minchan Kim <minchan.kim@gmail.com>, Jan Kara <jack@suse.cz>,
        Andy Isaacson <adi@hexapodia.org>,
        Johannes Weiner <jweiner@redhat.com>,
        Andrea Arcangeli <aarcange@redhat.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [PATCH] mm: Do not stall in synchronous compaction for THP
 allocations
Message-ID: <20111111100156.GI3083@suse.de>
References: <20111110100616.GD3083@suse.de>
 <20111110142202.GE3083@suse.de>
 <CAEwNFnCRCxrru5rBk7FpypqeL8nD=SY5W3-TaA7Ap5o4CgDSbg@mail.gmail.com>
 <20111110161331.GG3083@suse.de>
 <20111110151211.523fa185.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20111110151211.523fa185.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 10, 2011 at 03:12:11PM -0800, Andrew Morton wrote:
> On Thu, 10 Nov 2011 16:13:31 +0000
> Mel Gorman <mgorman@suse.de> wrote:
> 
> > This patch once again prevents sync migration for transparent
> > hugepage allocations as it is preferable to fail a THP allocation
> > than stall.
> 
> Who said?  ;)

Everyone who ever complained about stalls due to writing to USB :)

In the last few releases, we have squashed a number of stalls due
to writing pages from the end of the LRU but sync compaction is a
relatively recent new root cause of stalls.

> Presumably some people would prefer to get lots of
> huge pages for their 1000-hour compute job, and waiting a bit to get
> those pages is acceptable.
> 

A 1000-hour compute job will have its pages collapsed into hugepages by
khugepaged so they might not have the huge pages at the very beginning
but they get them. With khugepaged in place, there should be no need for
an additional tuneable.

> Do we have the accounting in place for us to be able to determine how
> many huge page allocation attempts failed due to this change?
> 

thp_fault_fallback is the big one. It is incremented if we fail to
	allocate a hugepage during fault in either
	do_huge_pmd_anonymous_page or do_huge_pmd_wp_page_fallback

thp_collapse_alloc_failed is also very interesting. It is incremented
	if khugepaged tried to collapse pages into a hugepage and
	failed the allocation

The user has the  option of monitoring their compute jobs hugepage
usage by reading /proc/PID/smaps and looking at the AnonHugePages
count for the large mappings of interest.

-- 
Mel Gorman
SUSE Labs
