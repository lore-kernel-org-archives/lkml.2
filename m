Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750996Ab0EIUX5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 May 2010 16:23:57 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52345 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750772Ab0EIUXz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 May 2010 16:23:55 -0400
Date: Sun, 9 May 2010 13:20:52 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Mel Gorman <mel@csn.ul.ie>
cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux-MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
       Minchan Kim <minchan.kim@gmail.com>, Christoph Lameter <cl@linux.com>,
       Andrea Arcangeli <aarcange@redhat.com>, Rik van Riel <riel@redhat.com>,
       Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH 2/2] mm,migration: Fix race between shift_arg_pages and
 rmap_walk by guaranteeing rmap_walk finds PTEs created within the temporary
 stack
In-Reply-To: <alpine.LFD.2.00.1005091257110.3711@i5.linux-foundation.org>
Message-ID: <alpine.LFD.2.00.1005091309380.3711@i5.linux-foundation.org>
References: <1273188053-26029-1-git-send-email-mel@csn.ul.ie> <1273188053-26029-3-git-send-email-mel@csn.ul.ie> <alpine.LFD.2.00.1005061836110.901@i5.linux-foundation.org> <20100507105712.18fc90c4.kamezawa.hiroyu@jp.fujitsu.com>
 <alpine.LFD.2.00.1005061905230.901@i5.linux-foundation.org> <20100509192145.GI4859@csn.ul.ie> <alpine.LFD.2.00.1005091245000.3711@i5.linux-foundation.org> <alpine.LFD.2.00.1005091257110.3711@i5.linux-foundation.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sun, 9 May 2010, Linus Torvalds wrote:
> 
> Also - the thing is, we can easily choose to do this _just_ for the case 
> of shifting argument pages, which really is a special case (the generic 
> case of "mremap()" is a lot more complicated, and doesn't have the issue 
> with rmap because it's doing all the "new vma" setup etc).

Looking at the stack setup code, we have other things we probably might 
want to look at.

For example, we do that "mprotect_fixup()" to fix up possible vm_flags 
issues (notably whether execute bit is set or not), and that's absolutely 
something that we probably should do at the same time as moving the stack, 
so that we don't end up walking - and changing - the page tables _twice_.

So the stack setup really is a total special case, and it looks like we do 
some rather stupid things there. Havign a specialized routine that does 
just:

 - if we're moving things, fill in the new page tables (we know they are 
   dense, so my "stupid" routine actually does the right thing despite 
   being pretty simplistic) before moving.

 - if we're moving _or_ changing protections, do a

		for_each_page()
			move_andor_fix_protection()

   which kind of looks like the current "move_page_tables()", except we 
   know it doesn't need new allocations.

Hmm?

			Linus
