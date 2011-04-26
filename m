Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753506Ab1DZJuF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 05:50:05 -0400
Received: from cantor2.suse.de ([195.135.220.15]:56821 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753170Ab1DZJuB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 05:50:01 -0400
Date: Tue, 26 Apr 2011 19:49:47 +1000
From: NeilBrown <neilb@suse.de>
To: Mel Gorman <mgorman@suse.de>
Cc: Linux-MM <linux-mm@kvack.org>, Linux-Netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH 03/13] mm: Introduce __GFP_MEMALLOC to allow access to
 emergency reserves
Message-ID: <20110426194947.764e048a@notabene.brown>
In-Reply-To: <1303803414-5937-4-git-send-email-mgorman@suse.de>
References: <1303803414-5937-1-git-send-email-mgorman@suse.de>
	<1303803414-5937-4-git-send-email-mgorman@suse.de>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.22.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 26 Apr 2011 08:36:44 +0100 Mel Gorman <mgorman@suse.de> wrote:

> __GFP_MEMALLOC will allow the allocation to disregard the watermarks,
> much like PF_MEMALLOC. It allows one to pass along the memalloc state in
> object related allocation flags as opposed to task related flags, such
> as sk->sk_allocation. This removes the need for ALLOC_PFMEMALLOC as
> callers using __GFP_MEMALLOC can get the ALLOC_NO_WATERMARK flag which
> is now enough to identify allocations related to page reclaim.
> 
> Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Signed-off-by: Mel Gorman <mgorman@suse.de>
> ---
>  include/linux/gfp.h      |    4 +++-
>  include/linux/mm_types.h |    2 +-
>  mm/page_alloc.c          |   14 ++++++--------
>  mm/slab.c                |    2 +-
>  4 files changed, 11 insertions(+), 11 deletions(-)
> 
> diff --git a/include/linux/gfp.h b/include/linux/gfp.h
> index bfb8f93..4e011e7 100644
> --- a/include/linux/gfp.h
> +++ b/include/linux/gfp.h
> @@ -23,6 +23,7 @@ struct vm_area_struct;
>  #define ___GFP_REPEAT		0x400u
>  #define ___GFP_NOFAIL		0x800u
>  #define ___GFP_NORETRY		0x1000u
> +#define ___GFP_MEMALLOC		0x2000u
>  #define ___GFP_COMP		0x4000u
>  #define ___GFP_ZERO		0x8000u
>  #define ___GFP_NOMEMALLOC	0x10000u
> @@ -75,6 +76,7 @@ struct vm_area_struct;
>  #define __GFP_REPEAT	((__force gfp_t)___GFP_REPEAT)	/* See above */
>  #define __GFP_NOFAIL	((__force gfp_t)___GFP_NOFAIL)	/* See above */
>  #define __GFP_NORETRY	((__force gfp_t)___GFP_NORETRY) /* See above */
> +#define __GFP_MEMALLOC	((__force gfp_t)___GFP_MEMALLOC)/* Allow access to emergency reserves */
>  #define __GFP_COMP	((__force gfp_t)___GFP_COMP)	/* Add compound page metadata */
>  #define __GFP_ZERO	((__force gfp_t)___GFP_ZERO)	/* Return zeroed page on success */
>  #define __GFP_NOMEMALLOC ((__force gfp_t)___GFP_NOMEMALLOC) /* Don't use emergency reserves */

Having both "MEMALLOC" and  "NOMEMALLOC" seems ... unfortunate.

It appears that NOMEMALLOC over-rides MEMALLOC.  It might be good to document
this 

> +#define __GFP_MEMALLOC	((__force gfp_t)___GFP_MEMALLOC)/* Allow access to emergency reserves
                                                                   unless __GFP_NOMEMALLOC is set*/

>  #define __GFP_NOMEMALLOC ((__force gfp_t)___GFP_NOMEMALLOC) /* Don't use emergency reserves
                                                                  Overrides __GFP_MEMALLOC */

I suspect that it is never valid to set both.  So NOMEMALLOC is really
NO_PF_MEMALLOC, but making that change is probably just noise.

Maybe a
   WARN_ON((gfp_mask & __GFP_MEMALLOC) && (gfp_mask & __GFP_NOMEMALLOC));
might be wise?

NeilBrown.
