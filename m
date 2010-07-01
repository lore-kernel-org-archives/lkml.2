Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752076Ab0GABzd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jun 2010 21:55:33 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:41700 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751635Ab0GABzc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jun 2010 21:55:32 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [Intel-gfx] [PATCH] drm/i915: Selectively enable self-reclaim
Cc: kosaki.motohiro@jp.fujitsu.com, Chris Wilson <chris@chris-wilson.co.uk>,
       Dave Airlie <airlied@gmail.com>, earny@net4u.de,
       Roman Jarosz <kedgedev@gmail.com>, intel-gfx@lists.freedesktop.org,
       linux-kernel@vger.kernel.org, jcnengel@googlemail.com,
       "A. Boulan" <arnaud.boulan@libertysurf.fr>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       Pekka Enberg <penberg@cs.helsinki.fi>, A Rojas <nqn1976list@gmail.com>,
       rientjes@google.com, michael@reinelt.co.at, stable@kernel.org,
       Vefa Bicakci <bicave@superonline.com>
In-Reply-To: <AANLkTinLB5YtqsnFwWrP37i3Ucr4fOaQzVuDLnyWBRGQ@mail.gmail.com>
References: <AANLkTilwmuXlNYhlFkmpYHSmegPy3ws4x-YRFwkbk8Xm@mail.gmail.com> <AANLkTinLB5YtqsnFwWrP37i3Ucr4fOaQzVuDLnyWBRGQ@mail.gmail.com>
Message-Id: <20100701104934.DA30.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 8BIT
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Thu,  1 Jul 2010 10:55:29 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Wed, Jun 30, 2010 at 4:07 PM, Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
> >
> > That commit changes the page cache allocation to use
> >
> > +                                          mapping_gfp_mask (mapping) |
> > +                                          __GFP_COLD |
> > +                                          gfpmask);
> >
> > if I read it right. And the default mapping_gfp_mask() is
> > GFP_HIGHUSER_MOVABLE, so I think you get all of
> > (__GFP_WAIT | __GFP_IO | __GFP_FS | __GFP_HARDWALL | __GFP_HIGHMEM)
> > set by default.
> 
> .. and then I left out the one flag I _meant_ to have there, namely
> __GFP_MOVABLE.
> 
> > The old code didn't just play games with ~__GFP_NORETRY and change
> > that at runtime (which was buggy - no locking, no protection, no
> > nothing), it also initialized the gfp mask. And that code also got
> > removed:
> 
> In fact, I don't really see why we should use that mapping_gfp_mask()
> at all, since all allocations should be going through that
> i915_gem_object_get_pages() function anyway. So why not just change
> that function to ignore the default gfp mask for the mapping, and just
> use the mask that the o915 driver wants?
> 
> Btw, why did it want to mark the pages reclaimable?

I'm not GEM expert at all. but as far as I read following documentation,

http://lwn.net/Articles/283798/

GEM memory have pin and unpin state and unpined memory can be reclaimed.
but it's just guess. So, I wonder if your patch solve the issue. I don't imazine a memory 
state which "swap-out is safe, but compaction is unsafe".

Dave, if you have good documentation which we understand GEM memory management,
could you send us?

   - kosaki

> 
> Anyway, what I'm suggesting somebody who sees this test is just
> something like the patch below (whitespace-damage - I'm cutting and
> pasting, it's a trivial one-liner).  Does this change any behavior?
> Vefa?
> 
>                     Linus
> 
> ---
> diff --git a/drivers/gpu/drm/i915/i915_gem.c b/drivers/gpu/drm/i915/i915_gem.c
> index 9ded3da..ec8ed6b 100644
> --- a/drivers/gpu/drm/i915/i915_gem.c
> +++ b/drivers/gpu/drm/i915/i915_gem.c
> @@ -2239,7 +2239,7 @@ i915_gem_object_get_pages(struct drm_gem_object *obj,
>         mapping = inode->i_mapping;
>         for (i = 0; i < page_count; i++) {
>                 page = read_cache_page_gfp(mapping, i,
> -                                          mapping_gfp_mask (mapping) |
> +                                          GFP_HIGHMEM |
>                                            __GFP_COLD |
>                                            gfpmask);
>                 if (IS_ERR(page))
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/



