Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933589Ab0HJWBg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Aug 2010 18:01:36 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:61934 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932959Ab0HJWB2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Aug 2010 18:01:28 -0400
Subject: Re: [PATCH] lib/scatterlist: Hook sg_kmalloc into kmemleak (v2)
From: Catalin Marinas <catalin.marinas@arm.com>
To: Jens Axboe <jaxboe@fusionio.com>
Cc: linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>,
        Chris Wilson <chris@chris-wilson.co.uk>
In-Reply-To: <1280220298-9641-1-git-send-email-chris@chris-wilson.co.uk>
References: <1280220298-9641-1-git-send-email-chris@chris-wilson.co.uk>
Content-Type: text/plain; charset="UTF-8"
Organization: ARM Limited
Date: Tue, 10 Aug 2010 23:01:12 +0100
Message-ID: <1281477672.8973.20.camel@e102109-lin.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 10 Aug 2010 22:01:14.0056 (UTC) FILETIME=[8CBDBC80:01CB38D7]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jens,

On Tue, 2010-07-27 at 09:44 +0100, Chris Wilson wrote:
> kmemleak ignores page_alloc() and so believes the final sub-page
> allocation using the plain kmalloc is decoupled and lost. This leads to
> lots of false-positives with code that uses scatterlists.
> 
> The options seem to be either to tell kmemleak that the kmalloc is not
> leaked or to notify kmemleak of the page allocations. The danger of the
> first approach is that we may hide a real leak, so choose the latter
> approach (of which I am not sure of the downsides).
> 
> v2: Added comments on the suggestion of Catalin.
> 
> Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
> Cc: Tejun Heo <tj@kernel.org>
> Cc: Jens Axboe <jaxboe@fusionio.com>
> Cc: Catalin Marinas <catalin.marinas@arm.com>

Since you are the author of lib/scatterlist.c would you (or Tejun) mind
ack'ing this patch? Thanks.

> ---
>  lib/scatterlist.c |   21 ++++++++++++++++-----
>  1 files changed, 16 insertions(+), 5 deletions(-)
> 
> diff --git a/lib/scatterlist.c b/lib/scatterlist.c
> index 9afa25b..fc85552 100644
> --- a/lib/scatterlist.c
> +++ b/lib/scatterlist.c
> @@ -115,17 +115,28 @@ EXPORT_SYMBOL(sg_init_one);
>   */
>  static struct scatterlist *sg_kmalloc(unsigned int nents, gfp_t gfp_mask)
>  {
> -       if (nents == SG_MAX_SINGLE_ALLOC)
> -               return (struct scatterlist *) __get_free_page(gfp_mask);
> -       else
> +       if (nents == SG_MAX_SINGLE_ALLOC) {
> +               /* kmemleak doesn't track page allocations as they are not
> +                * commonly used (in a raw form) for kernel data structures.
> +                * As we chain together a list of pages and then a normal
> +                * kmalloc (tracked by kmemleak), in order to for that last
> +                * allocation not to become decoupled (and thus a
> +                * false-positive) we need to inform kmemleak of all the
> +                * intermediate allocations.
> +                */
> +               void *ptr = (void *) __get_free_page(gfp_mask);
> +               kmemleak_alloc(ptr, PAGE_SIZE, 1, gfp_mask);
> +               return ptr;
> +       } else
>                 return kmalloc(nents * sizeof(struct scatterlist), gfp_mask);
>  }
> 
>  static void sg_kfree(struct scatterlist *sg, unsigned int nents)
>  {
> -       if (nents == SG_MAX_SINGLE_ALLOC)
> +       if (nents == SG_MAX_SINGLE_ALLOC) {
> +               kmemleak_free(sg);
>                 free_page((unsigned long) sg);
> -       else
> +       } else
>                 kfree(sg);
>  }

-- 
Catalin

