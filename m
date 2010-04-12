Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753874Ab0DLTa1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Apr 2010 15:30:27 -0400
Received: from casper.infradead.org ([85.118.1.10]:54853 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753753Ab0DLTa0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Apr 2010 15:30:26 -0400
Subject: Re: [PATCH -v2] rmap: make anon_vma_prepare link in all the
 anon_vmas of a mergeable VMA
From: Peter Zijlstra <peterz@infradead.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Rik van Riel <riel@redhat.com>, Borislav Petkov <bp@alien8.de>,
       Johannes Weiner <hannes@cmpxchg.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Minchan Kim <minchan.kim@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       Nick Piggin <npiggin@suse.de>, Andrea Arcangeli <aarcange@redhat.com>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>, sgunderson@bigfoot.com
In-Reply-To: <1271097638.4807.129.camel@twins>
References: <20100409191425.GB10780@a1.tnic>
	 <alpine.LFD.2.00.1004091227310.3558@i5.linux-foundation.org>
	 <20100409204328.GG28964@cmpxchg.org>
	 <alpine.LFD.2.00.1004091546350.3558@i5.linux-foundation.org>
	 <alpine.LFD.2.00.1004091638290.3558@i5.linux-foundation.org>
	 <20100410003110.GI28964@cmpxchg.org>
	 <alpine.LFD.2.00.1004091730130.3558@i5.linux-foundation.org>
	 <20100410072714.GA9246@liondog.tnic> <20100410112639.GA24708@a1.tnic>
	 <alpine.LFD.2.00.1004100821340.3558@i5.linux-foundation.org>
	 <20100410163828.GA25579@a1.tnic>
	 <alpine.LFD.2.00.1004100947400.3558@i5.linux-foundation.org>
	 <alpine.LFD.2.00.1004101101180.3558@i5.linux-foundation.org>
	 <1271083207.4807.18.camel@twins>  <4BC33A02.8000307@redhat.com>
	 <1271088103.20295.3383.camel@laptop> <4BC34501.5060401@redhat.com>
	 <alpine.LFD.2.00.1004120941310.26679@i5.linux-foundation.org>
	 <1271097638.4807.129.camel@twins>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 12 Apr 2010 21:30:21 +0200
Message-ID: <1271100621.20295.3397.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-04-12 at 20:40 +0200, Peter Zijlstra wrote:

Hmm, if interleaved like so

> struct anon_vma *page_lock_anon_vma(struct page *page)
> {
>         struct anon_vma *anon_vma;
>         unsigned long anon_mapping;

page_remove_rmap()
anon_vma_unlink()
  anon_vma_free()

So that the below will all observe the old page->mapping:

>         rcu_read_lock();
> again:
>         anon_mapping = (unsigned long)rcu_dereference(page->mapping);
>         if ((anon_mapping & PAGE_MAPPING_FLAGS) != PAGE_MAPPING_ANON)
>                 goto out;
>         anon_vma = (struct anon_vma *)(anon_mapping - PAGE_MAPPING_ANON);
> 
>         /*
>          * The RCU read lock ensures we can safely dereference anon_vma
>          * since it ensures the backing slab won't go away. It will however
>          * not guarantee it's the right object.
>          *
>          * First take the anon_vma->lock, this will, per anon_vma_unlink()
>          * avoid this anon_vma from being freed if it is a valid object.
>          */
>         spin_lock(&anon_vma->lock);
> 
>         /*
>          * Secondly, we have to re-read page->mapping, so ensure it
>          * has not changed, rely on spin_lock() being at least a
>          * compiler barrier to force the re-read.
>          */
>         if (unlikely(page_rmapping(page) != anon_vma)) {
>                 spin_unlock(&anon_vma->lock);
>                 goto again;
>         }

page_add_anon_rmap(), so that the page_mapped() test below would be
positive,

>         /*
>          * Ensure we read page->mapping before page->_mapcount,
>          * orders against atomic_add_negative() in page_remove_rmap().
>          */
>         smp_rmb();
> 
>         /*
>          * Finally check that the page is still mapped,
>          * if not, this can't possibly be the right anon_vma.
>          */
>         if (!page_mapped(page))
>                 goto unlock;

We could here return a non-valid and already freed anon_vma.

>         return anon_vma;
> 
> unlock:
>         spin_unlock(&anon_vma->lock);
> out:
>         rcu_read_unlock();
>         return NULL;
> }
> 
> 

