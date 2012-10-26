Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752642Ab2JZAxZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 20:53:25 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:63244 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751075Ab2JZAxX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 20:53:23 -0400
X-AuditID: 9c930197-b7c4aae000004160-3b-5089deff9205
Date: Fri, 26 Oct 2012 09:58:51 +0900
From: Minchan Kim <minchan@kernel.org>
To: Christoph Lameter <cl@linux.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        John Stultz <john.stultz@linaro.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Android Kernel Team <kernel-team@android.com>,
        Robert Love <rlove@google.com>, Mel Gorman <mel@csn.ul.ie>,
        Hugh Dickins <hughd@google.com>, Dave Hansen <dave@linux.vnet.ibm.com>,
        Rik van Riel <riel@redhat.com>, Dave Chinner <david@fromorbit.com>,
        Neil Brown <neilb@suse.de>, Mike Hommey <mh@glandium.org>,
        Taras Glek <tglek@mozilla.com>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [RFC] Support volatile range for anon vma
Message-ID: <20121026005851.GD15767@bbox>
References: <1351133820-14096-1-git-send-email-minchan@kernel.org>
 <0000013a9881a86c-c0fb5823-b6e7-4bea-8707-f6b8eddae14d-000000@email.amazonses.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0000013a9881a86c-c0fb5823-b6e7-4bea-8707-f6b8eddae14d-000000@email.amazonses.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Christoph,

On Thu, Oct 25, 2012 at 03:19:27PM +0000, Christoph Lameter wrote:
> On Thu, 25 Oct 2012, Minchan Kim wrote:
> 
> >  #endif
> > +	/*
> > +	 * True if page in this vma is reclaimed.
> 
> What does that mean? All pages in the vma have been cleared out?

It means at least, more than one is reclaimed.
Comment should have been cleared.

> 
> > +	TTU_IGNORE_VOLATILE = (1 << 11),/* ignore volatile */
> >  };
> >  #define TTU_ACTION(x) ((x) & TTU_ACTION_MASK)
> >
> >  int try_to_unmap(struct page *, enum ttu_flags flags);
> >  int try_to_unmap_one(struct page *, struct vm_area_struct *,
> > -			unsigned long address, enum ttu_flags flags);
> > +			unsigned long address, enum ttu_flags flags,
> > +			bool *is_volatile);
> 
> You already pass a vma pointer in. Why do you need to pass a
> volatile flag in? Looks like unecessary churn.

You mean we can use vma->purged instead of is_volatile passing?
The is_volatile is just checking for that all of vmas share the page
are volatile ones. Then, vma->purged is just checking for that the page
is zapped in the vma. If one of vma share the page isn't volatile, we can't zap.

BTW, Christoph, what do you think about the goal of the patch which changes
munmap(2) to madvise(2) when user calls free(3) in user allocator like glibc?
I guess it would improve system performance very well.
But as I wrote down in description, downside of the patch is that we have to
age anon lru although we don't have swap. But gain via the patch is bigger than
loss via aging of anon lru when memory pressure happens. I don't see other downside
other than it. What do you think about it?
(I didn't implement anon lru aging in case of no-swap but it's trivial
once we decide)

Thanks for the review, Christoph

> 
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo@kvack.org.  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>

-- 
Kind regards,
Minchan Kim
