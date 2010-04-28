Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754855Ab0D1PRL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Apr 2010 11:17:11 -0400
Received: from mx1.redhat.com ([209.132.183.28]:24086 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754282Ab0D1PRI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Apr 2010 11:17:08 -0400
Date: Wed, 28 Apr 2010 16:46:26 +0200
From: Andrea Arcangeli <aarcange@redhat.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Mel Gorman <mel@csn.ul.ie>, Linux-MM <linux-mm@kvack.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Minchan Kim <minchan.kim@gmail.com>, Christoph Lameter <cl@linux.com>,
       Rik van Riel <riel@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 3/3] mm,migration: Remove straggling migration PTEs
 when page tables are being moved after the VMA has already moved
Message-ID: <20100428144626.GP510@random.random>
References: <1272403852-10479-1-git-send-email-mel@csn.ul.ie>
 <1272403852-10479-4-git-send-email-mel@csn.ul.ie>
 <20100428173054.7b6716cf.kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100428173054.7b6716cf.kamezawa.hiroyu@jp.fujitsu.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 28, 2010 at 05:30:54PM +0900, KAMEZAWA Hiroyuki wrote:
> On Tue, 27 Apr 2010 22:30:52 +0100
> Mel Gorman <mel@csn.ul.ie> wrote:
> 
> > During exec(), a temporary stack is setup and moved later to its final
> > location. There is a race between migration and exec whereby a migration
> > PTE can be placed in the temporary stack. When this VMA is moved under the
> > lock, migration no longer knows where the PTE is, fails to remove the PTE
> > and the migration PTE gets copied to the new location.  This later causes
> > a bug when the migration PTE is discovered but the page is not locked.
> > 
> > This patch handles the situation by removing the migration PTE when page
> > tables are being moved in case migration fails to find them. The alternative
> > would require significant modification to vma_adjust() and the locks taken
> > to ensure a VMA move and page table copy is atomic with respect to migration.
> > 
> > Signed-off-by: Mel Gorman <mel@csn.ul.ie>
> 
> Here is my final proposal (before going vacation.)
> 
> I think this is very simple. The biggest problem is when move_page_range
> fails, setup_arg_pages pass it all to exit() ;)
> 
> ==
> From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> 
> This is an band-aid patch for avoiding unmap->remap of stack pages
> while it's udner exec(). At exec, pages for stack is moved by
> setup_arg_pages(). Under this, (vma,page)<->address relationship
> can be in broken state.
> Moreover, if moving ptes fails, pages with not-valid-rmap remains
> in the page table and objrmap for the page is completely broken
> until exit() frees all up.
> 
> This patch adds vma->broken_rmap. If broken_rmap != 0, vma_address()
> returns -EFAULT always and try_to_unmap() fails.
> (IOW, the pages for stack are pinned until setup_arg_pages() ends.)
> 
> And this prevents page migration because the page's mapcount never
> goes to 0 until exec() fixes it up.

I don't get it, I don't see the pinning and returning -EFAULT is not
solution for things that cannot fail (i.e. remove_migration_ptes and
split_huge_page). Plus there's no point to return failure to rmap_walk
when we can just stop the rmap_walk with the proper lock.
