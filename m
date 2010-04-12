Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753021Ab0DLQvS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Apr 2010 12:51:18 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50738 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752291Ab0DLQvQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Apr 2010 12:51:16 -0400
Date: Mon, 12 Apr 2010 09:46:07 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Rik van Riel <riel@redhat.com>
cc: Peter Zijlstra <peterz@infradead.org>, Borislav Petkov <bp@alien8.de>,
       Johannes Weiner <hannes@cmpxchg.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Minchan Kim <minchan.kim@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       Nick Piggin <npiggin@suse.de>, Andrea Arcangeli <aarcange@redhat.com>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>, sgunderson@bigfoot.com
Subject: Re: [PATCH -v2] rmap: make anon_vma_prepare link in all the anon_vmas
 of a mergeable VMA
In-Reply-To: <4BC34501.5060401@redhat.com>
Message-ID: <alpine.LFD.2.00.1004120941310.26679@i5.linux-foundation.org>
References: <20100409191425.GB10780@a1.tnic>  <alpine.LFD.2.00.1004091227310.3558@i5.linux-foundation.org>  <20100409204328.GG28964@cmpxchg.org>  <alpine.LFD.2.00.1004091546350.3558@i5.linux-foundation.org>  <alpine.LFD.2.00.1004091638290.3558@i5.linux-foundation.org>
  <20100410003110.GI28964@cmpxchg.org>  <alpine.LFD.2.00.1004091730130.3558@i5.linux-foundation.org>  <20100410072714.GA9246@liondog.tnic> <20100410112639.GA24708@a1.tnic>  <alpine.LFD.2.00.1004100821340.3558@i5.linux-foundation.org>  <20100410163828.GA25579@a1.tnic>
  <alpine.LFD.2.00.1004100947400.3558@i5.linux-foundation.org>  <alpine.LFD.2.00.1004101101180.3558@i5.linux-foundation.org>  <1271083207.4807.18.camel@twins>  <4BC33A02.8000307@redhat.com> <1271088103.20295.3383.camel@laptop> <4BC34501.5060401@redhat.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 12 Apr 2010, Rik van Riel wrote:

> On 04/12/2010 12:01 PM, Peter Zijlstra wrote:
> 
> > @@ -864,15 +889,8 @@ void page_remove_rmap(struct page *page)
> >   		__dec_zone_page_state(page, NR_FILE_MAPPED);
> >   		mem_cgroup_update_file_mapped(page, -1);
> >   	}
> > -	/*
> > -	 * It would be tidy to reset the PageAnon mapping here,
> > -	 * but that might overwrite a racing page_add_anon_rmap
> > -	 * which increments mapcount after us but sets mapping
> > -	 * before us: so leave the reset to free_hot_cold_page,
> > -	 * and remember that it's only reliable while mapped.
> > -	 * Leaving it set also helps swapoff to reinstate ptes
> > -	 * faster for those pages still in swapcache.
> > -	 */
> > +
> > +	page->mapping = NULL;
> >   }
> 
> That would be a bug for file pages :)
> 
> I could see how it could work for anonymous memory, though.

I think it's scary for anonymous pages too. The _common_ case of 
page_remove_rmap() is from unmap/exit, which holds no locks on the page 
what-so-ever. So assuming the page could be reachable some other way (swap 
cache etc), I think the above is pretty scary. 

Also do note that the bug we've been chasing has _always_ had that test 
for "page_mapped(page)". See my other email about why the unmapped case 
isn't even interesting, because it's so easy to see how page->mapping can 
be stale for unmapped pages.

It's the _mapped_ case that is interesting, not the unmapped one. So 
setting page->mapping to NULL when unmapping is perhaps a nice consistency 
issue ("never have stale pointers"), but it's missing the fact that it's 
not really the case we care about.

			Linus
