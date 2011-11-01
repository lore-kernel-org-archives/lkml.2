Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755197Ab1KAPEx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Nov 2011 11:04:53 -0400
Received: from gir.skynet.ie ([193.1.99.77]:60833 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754853Ab1KAPEw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Nov 2011 11:04:52 -0400
Date: Tue, 1 Nov 2011 15:04:48 +0000
From: Mel Gorman <mel@csn.ul.ie>
To: Michal Nazarewicz <mina86@mina86.com>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
        linux-mm@kvack.org, linaro-mm-sig@lists.linaro.org,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Russell King <linux@arm.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Ankita Garg <ankita@in.ibm.com>,
        Daniel Walker <dwalker@codeaurora.org>, Arnd Bergmann <arnd@arndb.de>,
        Jesse Barker <jesse.barker@linaro.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Shariq Hasnain <shariq.hasnain@linaro.org>,
        Chunsang Jeong <chunsang.jeong@linaro.org>,
        Dave Hansen <dave@linux.vnet.ibm.com>
Subject: Re: [PATCH 2/9] mm: alloc_contig_freed_pages() added
Message-ID: <20111101150448.GD14998@csn.ul.ie>
References: <20111018122109.GB6660@csn.ul.ie>
 <809d0a2afe624c06505e0df51e7657f66aaf9007.1319428526.git.mina86@mina86.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <809d0a2afe624c06505e0df51e7657f66aaf9007.1319428526.git.mina86@mina86.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 23, 2011 at 09:05:05PM -0700, Michal Nazarewicz wrote:
> > On Thu, Oct 06, 2011 at 03:54:42PM +0200, Marek Szyprowski wrote:
> >> This commit introduces alloc_contig_freed_pages() function
> >> which allocates (ie. removes from buddy system) free pages
> >> in range. Caller has to guarantee that all pages in range
> >> are in buddy system.
> 
> On Tue, 18 Oct 2011 05:21:09 -0700, Mel Gorman <mel@csn.ul.ie> wrote:
> > Straight away, I'm wondering why you didn't use
> > mm/compaction.c#isolate_freepages()
> 
> Does the below look like a step in the right direction?
> 
> It basically moves isolate_freepages_block() to page_alloc.c (changing

For the purposes of review, have a separate patch for moving
isolate_freepages_block to another file that does not alter the
function in any way. When the function is updated in a follow-on patch,
it'll be far easier to see what has changed.

page_isolation.c may also be a better fit than page_alloc.c

As it is, the patch for isolate_freepages_block is almost impossible
to read because it's getting munged with existing code that is already
in page_alloc.c . About all I caught from it is that scannedp does
not have a type. It defaults to unsigned int but it's unnecessarily
obscure.

> it name to isolate_freepages_range()) and changes it so that depending
> on arguments it treats holes (either invalid PFN or non-free page) as
> errors so that CMA can use it.
> 

I haven't actually read the function because it's too badly mixed with
page_alloc.c code but this description fits what I'm looking for.

> It also accepts a range rather then just assuming a single pageblock
> thus the change moves range calculation in compaction.c from
> isolate_freepages_block() up to isolate_freepages().
> 
> The change also modifies spilt_free_page() so that it does not try to
> change pageblock's migrate type if current migrate type is ISOLATE or
> CMA.
> 

This is fine. Later, the flags that determine what happens to pageblocks
may be placed in compact_control.

> ---
>  include/linux/mm.h             |    1 -
>  include/linux/page-isolation.h |    4 +-
>  mm/compaction.c                |   73 +++--------------------
>  mm/internal.h                  |    5 ++
>  mm/page_alloc.c                |  128 +++++++++++++++++++++++++---------------
>  5 files changed, 95 insertions(+), 116 deletions(-)
> 

I confess I didn't read closely because of the mess in page_alloc.c but
the intent seems fine. Hopefully there will be a new version of CMA
posted that will be easier to review.

Thanks

-- 
Mel Gorman
SUSE Labs
