Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754884Ab2BHOpM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Feb 2012 09:45:12 -0500
Received: from cantor2.suse.de ([195.135.220.15]:36430 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753487Ab2BHOpK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Feb 2012 09:45:10 -0500
Date: Wed, 8 Feb 2012 14:45:06 +0000
From: Mel Gorman <mgorman@suse.de>
To: Christoph Lameter <cl@linux.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Linux-MM <linux-mm@kvack.org>,
        Linux-Netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        David Miller <davem@davemloft.net>, Neil Brown <neilb@suse.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH 02/15] mm: sl[au]b: Add knowledge of PFMEMALLOC reserve
 pages
Message-ID: <20120208144506.GI5938@suse.de>
References: <1328568978-17553-1-git-send-email-mgorman@suse.de>
 <1328568978-17553-3-git-send-email-mgorman@suse.de>
 <alpine.DEB.2.00.1202071025050.30652@router.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1202071025050.30652@router.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 07, 2012 at 10:27:56AM -0600, Christoph Lameter wrote:
> On Mon, 6 Feb 2012, Mel Gorman wrote:
> 
> > Pages allocated from the reserve are returned with page->pfmemalloc
> > set and it is up to the caller to determine how the page should be
> > protected.  SLAB restricts access to any page with page->pfmemalloc set
> 
> pfmemalloc sounds like a page flag. If you would use one then the
> preservation of the flag by copying it elsewhere may not be necessary and
> the patches would be less invasive.

Using a page flag would simplify parts of the patch. The catch of course
is that it requires a page flag which are in tight supply and I do not
want to tie this to being 32-bit unnecessarily.

> Also you would not need to extend
> and modify many of the structures.
> 
 
Lets see;

o struct page size would be unaffected
o struct kmem_cache_cpu could be left alone even though it's a small saving
o struct slab also be left alone
o struct array_cache could be left alone although I would point out that
  it would make no difference in size as touched is changed to a bool to
  fit pfmemalloc in
o It would still be necessary to do the object pointer tricks in slab.c
  to avoid doing an excessive number of page lookups which is where much
  of the complexity is
o The virt_to_slab could be replaced by looking up the page flag instead
  and avoiding a level of indirection that would be pleasing
  to an int and placed with struct kmem_cache

I agree that parts of the patch would be simplier although the
complexity of storing pfmemalloc within the obj pointer would probably
remain. However, the downside of requiring a page flag is very high. In
the event we increase the number of page flags - great, I'll use one but
right now I do not think the use of page flag is justified.

-- 
Mel Gorman
SUSE Labs
