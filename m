Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758115Ab0DGRBd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Apr 2010 13:01:33 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:32816 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753474Ab0DGRBc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Apr 2010 13:01:32 -0400
Date: Wed, 7 Apr 2010 09:56:24 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Rik van Riel <riel@redhat.com>
cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Borislav Petkov <bp@alien8.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Minchan Kim <minchan.kim@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       Nick Piggin <npiggin@suse.de>, Andrea Arcangeli <aarcange@redhat.com>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>, sgunderson@bigfoot.com,
       hannes@cmpxchg.org
Subject: Re: [PATCH -v2] rmap: make anon_vma_prepare link in all the anon_vmas
 of a mergeable VMA
In-Reply-To: <4BBCAA5B.7080603@redhat.com>
Message-ID: <alpine.LFD.2.00.1004070951330.3487@i5.linux-foundation.org>
References: <alpine.LFD.2.00.1004061609320.3487@i5.linux-foundation.org> <20100406195459.554265e7@annuminas.surriel.com> <20100407151357.FB7E.A69D9226@jp.fujitsu.com> <20100407105454.2e7ab9bf@annuminas.surriel.com> <alpine.LFD.2.00.1004070827140.3487@i5.linux-foundation.org>
 <4BBCAA5B.7080603@redhat.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 7 Apr 2010, Rik van Riel wrote:
> 
> You are right, the idea was to continue use the locking that
> the anon_vma code was already using, without introducing any
> new locking with the anon_vma patches.
> 
> However, it has become clear that this is no longer possible,
> due to the need to hold a secondary lock across anon_vma_clone,
> when we come from a code path that holds the mmap_sem for read.

I do wonder if we could possibly simplify this a _lot_ by just requiring 
that the anon_vma gets allocated at vma creation time (ie mmap), rather 
than doing it on-demand when we actually do the page fault.

That would make all of this crap happen under mmap_sem held for writing, 
and it would simplify the faulting code (which is the much more critical 
code) a lot.

And it would make all your locking problems go away. Now all anon_vma code 
really _would_ run with mmap_sem held exclusively, without any races.

When I tried to do a "fill in multiple page table entries in one go" 
patch, that annoying anon_vma issue was a problem as well. Allocating the 
anon_vma up-front would have simplified that code too.

I can't imagine that we ever really have mappings without an anon_vma in 
practice _anyway_, so why delay the allocation until page fault time?

Maybe I'm missing something subtle. 

			Linus
