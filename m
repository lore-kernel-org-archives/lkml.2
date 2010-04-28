Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756063Ab0D1R6r (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Apr 2010 13:58:47 -0400
Received: from mx1.redhat.com ([209.132.183.28]:2255 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752939Ab0D1R6p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Apr 2010 13:58:45 -0400
Date: Wed, 28 Apr 2010 19:58:22 +0200
From: Andrea Arcangeli <aarcange@redhat.com>
To: Mel Gorman <mel@csn.ul.ie>
Cc: Linux-MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
       Minchan Kim <minchan.kim@gmail.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Christoph Lameter <cl@linux.com>, Rik van Riel <riel@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 2/3] mm,migration: Prevent rmap_walk_[anon|ksm] seeing
 the wrong VMA information
Message-ID: <20100428175822.GB510@random.random>
References: <1272403852-10479-1-git-send-email-mel@csn.ul.ie>
 <1272403852-10479-3-git-send-email-mel@csn.ul.ie>
 <20100427231007.GA510@random.random>
 <20100428091555.GB15815@csn.ul.ie>
 <20100428153525.GR510@random.random>
 <20100428155558.GI15815@csn.ul.ie>
 <20100428162305.GX510@random.random>
 <20100428173416.GJ15815@csn.ul.ie>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100428173416.GJ15815@csn.ul.ie>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 28, 2010 at 06:34:17PM +0100, Mel Gorman wrote:
> Well, in the easiest case, the details of the VMA (particularly vm_start
> and vm_pgoff) can confuse callers of vma_address during rmap_walk. In the
> case of migration, it will return other false positives or negatives.

false positives are fine ;). Only problems are false negatives...

> > After you fix vma_adjust to be as safe as expand_downards you've also
> > to take care of the rmap_walk that may run on a page->mapping =
> > anon_vma that isn't the vma->anon_vma and you're not taking that
> > anon_vma->lock of the shared page, when you change the vma
> > vm_pgoff/vm_start.
> 
> Is this not what the try-lock-different-vmas-or-backoff-and-retry logic
> in patch 2 is doing or am I missing something else?

yes exactly. This is why patch 2 can't be dropped, both for the
vma_adjust and the rmap_walk that are really two separate issues.

> How so? The old PTE should have been left in place, the page count of
> the page remain positive and migration not occur.

Right only problem is for remove_migration_ptes (and for both
split_huge_page rmap_walks). For migrate the only issue is the second
rmap_walk.

> Because the list could be very large, it would make more sense to
> introduce the shared lock if this is what was required.

Kind of agree, we'll see...
