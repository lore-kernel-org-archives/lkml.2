Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752941Ab0KWJvK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Nov 2010 04:51:10 -0500
Received: from gir.skynet.ie ([193.1.99.77]:55197 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752535Ab0KWJvI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Nov 2010 04:51:08 -0500
Date: Tue, 23 Nov 2010 09:50:53 +0000
From: Mel Gorman <mel@csn.ul.ie>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Minchan Kim <minchan.kim@gmail.com>, linux-mm <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>, Rik van Riel <riel@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Nick Piggin <npiggin@kernel.dk>
Subject: Re: [RFC 2/2] Prevent promotion of page in madvise_dontneed
Message-ID: <20101123095053.GG19571@csn.ul.ie>
References: <bdd6628e81c06f6871983c971d91160fca3f8b5e.1290349672.git.minchan.kim@gmail.com> <5d205f8a4df078b0da3681063bbf37382b02dd23.1290349672.git.minchan.kim@gmail.com> <20101122142109.2f3e168c.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20101122142109.2f3e168c.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 22, 2010 at 02:21:09PM -0800, Andrew Morton wrote:
> On Sun, 21 Nov 2010 23:30:24 +0900
> Minchan Kim <minchan.kim@gmail.com> wrote:
> 
> > Now zap_pte_range alwayas promotes pages which are pte_young &&
> > !VM_SequentialReadHint(vma). But in case of calling MADV_DONTNEED,
> > it's unnecessary since the page wouldn't use any more.
> > 
> > If the page is sharred by other processes and it's real working set
> 
> This patch doesn't actually do anything.  It passes variable `promote'
> all the way down to unmap_vmas(), but unmap_vmas() doesn't use that new
> variable.
> 
> Have a comment fixlet:
> 
> --- a/mm/memory.c~mm-prevent-promotion-of-page-in-madvise_dontneed-fix
> +++ a/mm/memory.c
> @@ -1075,7 +1075,7 @@ static unsigned long unmap_page_range(st
>   * @end_addr: virtual address at which to end unmapping
>   * @nr_accounted: Place number of unmapped pages in vm-accountable vma's here
>   * @details: details of nonlinear truncation or shared cache invalidation
> - * @promote: whether pages inclued vma would be promoted or not
> + * @promote: whether pages included in the vma should be promoted or not
>   *
>   * Returns the end address of the unmapping (restart addr if interrupted).
>   *
> _
> 
> Also, I'd suggest that we avoid introducing the term "promote". 

Promote also has special meaning for huge pages. Demoting or promoting a
page refers to changing its size. The same applies to the other patch -
s/demote/deactive/ s/promote/activate/ . Currently this is no confusion
within the VM but when Andrea's THP patches are merged, it'll become an
issue.

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
