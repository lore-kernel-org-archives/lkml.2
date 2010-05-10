Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755071Ab0EJOC7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 May 2010 10:02:59 -0400
Received: from gir.skynet.ie ([193.1.99.77]:43111 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754878Ab0EJOC6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 May 2010 10:02:58 -0400
Date: Mon, 10 May 2010 15:02:39 +0100
From: Mel Gorman <mel@csn.ul.ie>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux-MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
       Minchan Kim <minchan.kim@gmail.com>, Christoph Lameter <cl@linux.com>,
       Andrea Arcangeli <aarcange@redhat.com>, Rik van Riel <riel@redhat.com>,
       Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH 2/2] mm,migration: Fix race between shift_arg_pages and
	rmap_walk by guaranteeing rmap_walk finds PTEs created within the
	temporary stack
Message-ID: <20100510140239.GJ26611@csn.ul.ie>
References: <1273188053-26029-1-git-send-email-mel@csn.ul.ie> <1273188053-26029-3-git-send-email-mel@csn.ul.ie> <alpine.LFD.2.00.1005061836110.901@i5.linux-foundation.org> <20100507105712.18fc90c4.kamezawa.hiroyu@jp.fujitsu.com> <alpine.LFD.2.00.1005061905230.901@i5.linux-foundation.org> <20100509192145.GI4859@csn.ul.ie> <alpine.LFD.2.00.1005091245000.3711@i5.linux-foundation.org> <20100510094238.5781d6fc.kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20100510094238.5781d6fc.kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 10, 2010 at 09:42:38AM +0900, KAMEZAWA Hiroyuki wrote:
> On Sun, 9 May 2010 12:56:49 -0700 (PDT)
> Linus Torvalds <torvalds@linux-foundation.org> wrote:
> 
> > 
> > 
> > On Sun, 9 May 2010, Mel Gorman wrote:
> > > 
> > > It turns out not to be easy to the preallocating of PUDs, PMDs and PTEs
> > > move_page_tables() needs.  To avoid overallocating, it has to follow the same
> > > logic as move_page_tables duplicating some code in the process. The ugliest
> > > aspect of all is passing those pre-allocated pages back into move_page_tables
> > > where they need to be passed down to such functions as __pte_alloc. It turns
> > > extremely messy.
> > 
> > Umm. What?
> > 
> > That's crazy talk. I'm not talking about preallocating stuff in order to 
> > pass it in to move_page_tables(). I'm talking about just _creating_ the 
> > dang page tables early - preallocating them IN THE PROCESS VM SPACE.
> > 
> > IOW, a patch like this (this is a pseudo-patch, totally untested, won't 
> > compile, yadda yadda - you need to actually make the people who call 
> > "move_page_tables()" call that prepare function first etc etc)
> > 
> > Yeah, if we care about holes in the page tables, we can certainly copy 
> > more of the move_page_tables() logic, but it certainly doesn't matter for 
> > execve(). This just makes sure that the destination page tables exist 
> > first.
> > 
> IMHO, I think move_page_tables() itself should be implemented as your patch.
> 
> But, move_page_tables()'s failure is not a big problem. At failure,
> exec will abort and no page fault will occur later. What we have to do in
> this migration-patch-series is avoding inconsistent update of sets of
> [page, vma->vm_start, vma->pg_off, ptes] or "dont' migrate pages in exec's
> statk".
> 
> Considering cost, as Mel shows, "don't migrate pages in exec's stack" seems
> reasonable. But, I still doubt this check.
> 
> +static bool is_vma_temporary_stack(struct vm_area_struct *vma)
> +{
> +	int maybe_stack = vma->vm_flags & (VM_GROWSDOWN | VM_GROWSUP);
> +
> +	if (!maybe_stack)
> +		return false;
> +
> +	/* If only the stack is mapped, assume exec is in progress */
> +	if (vma->vm_mm->map_count == 1) -------------------(*)
> +		return true; 
> +
> +	return false;
> +}
> +
> 
> Mel, can (*) be safe even on a.out format (format other than ELFs) ?
> 

I felt it was safe because this happens before search_binary_handler is
called to find a handler to load the binary. Still, the suggestion to
use an impossible combination of VMA flags is more robust against any
future change.

> <SNIP>

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
