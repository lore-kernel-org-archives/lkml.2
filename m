Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753804Ab1JLRvz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Oct 2011 13:51:55 -0400
Received: from mx1.redhat.com ([209.132.183.28]:22736 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751612Ab1JLRvy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Oct 2011 13:51:54 -0400
Date: Wed, 12 Oct 2011 19:51:48 +0200
From: Andrea Arcangeli <aarcange@redhat.com>
To: Hillf Danton <dhillf@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-mm@kvack.org,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] mm/huge_memory: Clean up typo when copying user highpage
Message-ID: <20111012175148.GA27460@redhat.com>
References: <CAJd=RBBuwmcV8srUyPGnKUp=RPKvsSd+4BbLrh--aHFGC5s7+g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJd=RBBuwmcV8srUyPGnKUp=RPKvsSd+4BbLrh--aHFGC5s7+g@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 12, 2011 at 10:39:36PM +0800, Hillf Danton wrote:
> Hi Andrea
> 
> When copying user highpage, the PAGE_SHIFT in the third parameter is a typo,
> I think, and is replaced with PAGE_SIZE.

That looks correct. I wonder how it was not noticed yet. Because it
can't go out of bound, it didn't risk to crash the kernel and it didn't
not risk to expose random data to the cowing task. So it shouldn't
have security implications as far as I can tell, but the app could
malfunction and crash (userland corruption only).

I grepped for other PAGE_SHIFT and PAGE_SIZE in the same file and
there seem to be no more of these... Pretty hard for this to go
unnoticed too, I guess the cows aren't as frequent enough to be
capable of triggering compaction failures. I added a
/sys/kernel/mm/transparent_hugepage/debug_cow exactly to catch bugs
like this very one, I guess nobody enabled debug_cow = 1 long
enough... If only I would have tested debug_cow = 1 with 0x00 0x01
0x02 0x03 for the whole 2M I should have noticed it...

> When configuring transparent hugepage, it depends on x86 and MMU.
> Would you please tippoint why other archs with MMU, say MIPS, are masked out?

Because nobody implemented it yet? Some archs may not make it in
hardware too, depends if you can mix large and small pages in the same
vma, then yes the arch could make it by adjusting the pmd size right
in the software pmd_t so that it matches an hardware soft-tlb filled
hash.

> Signed-off-by: Hillf Danton <dhillf@gmail.com>
> ---
> 
> --- a/mm/huge_memory.c	Sat Aug 13 11:45:14 2011
> +++ b/mm/huge_memory.c	Wed Oct 12 22:26:15 2011
> @@ -829,7 +829,7 @@ static int do_huge_pmd_wp_page_fallback(
> 
>  	for (i = 0; i < HPAGE_PMD_NR; i++) {
>  		copy_user_highpage(pages[i], page + i,
> -				   haddr + PAGE_SHIFT*i, vma);
> +				   haddr + PAGE_SIZE * i, vma);
>  		__SetPageUptodate(pages[i]);
>  		cond_resched();
>  	}

Reviewed-by: Andrea Arcangeli <aarcange@redhat.com>
