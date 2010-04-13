Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754492Ab0DMAle (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Apr 2010 20:41:34 -0400
Received: from f0.cmpxchg.org ([85.214.51.133]:47741 "EHLO cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754333Ab0DMAld (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Apr 2010 20:41:33 -0400
Date: Tue, 13 Apr 2010 02:41:17 +0200
From: Johannes Weiner <hannes@cmpxchg.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Borislav Petkov <bp@alien8.de>, Rik van Riel <riel@redhat.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Minchan Kim <minchan.kim@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       Nick Piggin <npiggin@suse.de>, Andrea Arcangeli <aarcange@redhat.com>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>, sgunderson@bigfoot.com
Subject: Re: [PATCH 4/4] anonvma: when setting up page->mapping, we need to pick the _oldest_ anonvma
Message-ID: <20100413004117.GD20163@cmpxchg.org>
References: <20100412072056.GA2432@liondog.tnic> <alpine.LFD.2.00.1004120854440.26679@i5.linux-foundation.org> <alpine.LFD.2.00.1004120906370.26679@i5.linux-foundation.org> <4BC36916.3080005@redhat.com> <20100412190002.GA8595@a1.tnic> <alpine.LFD.2.00.1004121201480.3714@i5.linux-foundation.org> <alpine.LFD.2.00.1004121320390.3683@i5.linux-foundation.org> <alpine.LFD.2.00.1004121322400.3683@i5.linux-foundation.org> <alpine.LFD.2.00.1004121323080.3683@i5.linux-foundation.org> <alpine.LFD.2.00.1004121323270.3683@i5.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1004121323270.3683@i5.linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 12, 2010 at 01:23:50PM -0700, Linus Torvalds wrote:
> 
> From: Linus Torvalds <torvalds@linux-foundation.org>
> Date: Mon, 12 Apr 2010 12:44:29 -0700
> Subject: [PATCH 4/4] anonvma: when setting up page->mapping, we need to pick the _oldest_ anonvma
> 
> Otherwise we might be mapping in a page in a new mapping, but that page
> (through the swapcache) would later be mapped into an old mapping too.
> The page->mapping must be the case that works for everybody, not just
> the mapping that happened to page it in first.
> 
> This can be improved in certain cases: if we know the page is private to
> just this particular mapping (for example, it's a new page, or it is the
> only swapcache entry), we could pick the top (most specific) anon_vma.
> 
> But that's a future optimization. Make it _work_ reliably first.
> 
> Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>

Acked-by: Johannes Weiner <hannes@cmpxchg.org>

Would you mind pasting that nice description of the error case from your
other email into that changelog?  I skimmed over the description but when
I read this patch several hours later, I had to go back to that previous
email to fully make sense of it.

> ---
>  mm/rmap.c |   15 +++++++++++++--
>  1 files changed, 13 insertions(+), 2 deletions(-)
> 
> diff --git a/mm/rmap.c b/mm/rmap.c
> index ee97d38..4bad326 100644
> --- a/mm/rmap.c
> +++ b/mm/rmap.c
> @@ -734,9 +734,20 @@ void page_move_anon_rmap(struct page *page,
>  static void __page_set_anon_rmap(struct page *page,
>  	struct vm_area_struct *vma, unsigned long address)
>  {
> -	struct anon_vma *anon_vma = vma->anon_vma;
> +	struct anon_vma_chain *avc;
> +	struct anon_vma *anon_vma;
> +
> +	BUG_ON(!vma->anon_vma);
> +
> +	/*
> +	 * We must use the _oldest_ possible anon_vma for the page mapping!

I think the key here is not that it's the oldest (past) but also the one with
the longest extent (future), so that it's bound to stay until the last possible
mapping for this page vanishes.

Maybe it's just me, but I doubt the comment as it is would help me understand
that code if I didn't already.

> +	 *
> +	 * So take the last AVC chain entry in the vma, which is the deepest
> +	 * ancestor, and use the anon_vma from that.
> +	 */
> +	avc = list_entry(vma->anon_vma_chain.prev, struct anon_vma_chain, same_vma);
> +	anon_vma = avc->anon_vma;
>  
> -	BUG_ON(!anon_vma);
>  	anon_vma = (void *) anon_vma + PAGE_MAPPING_ANON;
>  	page->mapping = (struct address_space *) anon_vma;
>  	page->index = linear_page_index(vma, address);

Hannes
