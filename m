Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757470Ab0DOHaT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Apr 2010 03:30:19 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:58222 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757441Ab0DOH3t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Apr 2010 03:29:49 -0400
Subject: Re: [PATCH -v2] rmap: make anon_vma_prepare link in all the
 anon_vmas of a mergeable VMA
From: Peter Zijlstra <peterz@infradead.org>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Rik van Riel <riel@redhat.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Borislav Petkov <bp@alien8.de>, Johannes Weiner <hannes@cmpxchg.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Minchan Kim <minchan.kim@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       Nick Piggin <npiggin@suse.de>, Andrea Arcangeli <aarcange@redhat.com>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>, sgunderson@bigfoot.com
In-Reply-To: <20100413204149.D11C.A69D9226@jp.fujitsu.com>
References: <20100413194443.D116.A69D9226@jp.fujitsu.com>
	 <1271158226.4807.1107.camel@twins>
	 <20100413204149.D11C.A69D9226@jp.fujitsu.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 14 Apr 2010 16:27:08 +0200
Message-ID: <1271255228.32749.54.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-04-13 at 21:00 +0900, KOSAKI Motohiro wrote:
> > [ with the preemptible mmu_gather patches I introduce a refcount to
> >   the anon_vma, and then with atomic_inc_not_zero() we can add a
> >   guarantee that the returned anon_vma is alive ]
> 
> Indeed. refcount is best way. anon_vma DESTROY_BY_RCU stuff seems
> overengineering, I think. this is fastest, but anon_vma allocation is not
> (and was not) fork/exit bottleneck point. So, I guess most simply way is
> best. 

Well, that refcount stuff still relies on DESTROY_BY_RCU :-)

Anyway, it also looks like a lot of races are avoided by ordering the
rmap_add/remove calls wrt to adding/removing the page to/from the LRU.

Rmap calls come from LRU pages, and it looks like rmap state is only
changed for pages that are not on the LRU.

I still have to go through all that code again to make sure, but I
couldn't find a race between page_add_anon_rmap() and
page_lock_anon_vma() due to that.

If there is, we need to look at page_mapped() before page->mapping
because page_add_anon_rmap() first increments the mapcount and only then
adjusts the mapping, so the existing order in page_anon_lock_vma() can
end up dereferencing a long dead anon_vma.






