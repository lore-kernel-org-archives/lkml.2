Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751938Ab0DJTiH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Apr 2010 15:38:07 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45999 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751703Ab0DJTiD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Apr 2010 15:38:03 -0400
Message-ID: <4BC0D347.3080905@redhat.com>
Date: Sat, 10 Apr 2010 15:36:39 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc12 Lightning/1.0b2pre Thunderbird/3.0.1
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Borislav Petkov <bp@alien8.de>, Johannes Weiner <hannes@cmpxchg.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Minchan Kim <minchan.kim@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       Nick Piggin <npiggin@suse.de>, Andrea Arcangeli <aarcange@redhat.com>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>, sgunderson@bigfoot.com
Subject: Re: [PATCH -v2] rmap: make anon_vma_prepare link in all the anon_vmas
 of a mergeable VMA
References: <20100409191425.GB10780@a1.tnic> <alpine.LFD.2.00.1004091227310.3558@i5.linux-foundation.org> <20100409204328.GG28964@cmpxchg.org> <alpine.LFD.2.00.1004091546350.3558@i5.linux-foundation.org> <alpine.LFD.2.00.1004091638290.3558@i5.linux-foundation.org> <20100410003110.GI28964@cmpxchg.org> <alpine.LFD.2.00.1004091730130.3558@i5.linux-foundation.org> <20100410072714.GA9246@liondog.tnic> <20100410112639.GA24708@a1.tnic> <alpine.LFD.2.00.1004100821340.3558@i5.linux-foundation.org> <20100410163828.GA25579@a1.tnic> <alpine.LFD.2.00.1004100947400.3558@i5.linux-foundation.org> <alpine.LFD.2.00.1004101101180.3558@i5.linux-foundation.org>
In-Reply-To: <alpine.LFD.2.00.1004101101180.3558@i5.linux-foundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/10/2010 02:21 PM, Linus Torvalds wrote:

> Maybe I'm crazy, but something started bothering me. And I started
> wondering: when is the 'page->mapping' of an anonymous page actually
> cleared?
>
> The thing is, the mapping of an anonymous page is actually cleared only
> when the page is _freed_, in "free_hot_cold_page()".

Which is also where they are removed from the LRU.
The plot thickens...

> Now, let's think about that. And in particular, let's think about how that
> relates to the freeing of the 'anon_vma' that the page->mapping points to.
>
> The way the anon_vma is freed is when the mapping is torn down, and we do
> roughly:
>
> 	tlb = tlb_gather_mmu(mm,..)
> 	..
> 	unmap_vmas(&tlb, vma ..
> 	..
> 	free_pgtables()
> 	..
> 	tlb_finish_mmu(tlb, start, end);

Looks like we should move the anon_vma freeing from free_pgtables
over to remove_vma?

This code is just below the tlb_finish_mmu in exit_mmap:

         /*
          * Walk the list again, actually closing and freeing it,
          * with preemption enabled, without holding any MM locks.
          */
         while (vma)
                 vma = remove_vma(vma);

This comment in free_pgtables is a little suspect:

                 /*
                  * Hide vma from rmap and truncate_pagecache before freeing
                  * pgtables
                  */
                 unlink_anon_vmas(vma);
                 unlink_file_vma(vma);

After all, the rmap code will quickly notice that there either are
no page tables, or the page tables no longer have anything in them.

It looks like we may have had this use-after-free bug in the VM for
quite a while...  I am not entirely sure what exposed the bug, but
I can see how it works.

