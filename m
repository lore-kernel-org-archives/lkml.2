Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752704Ab2GHXBr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jul 2012 19:01:47 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:55393 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752237Ab2GHXBq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jul 2012 19:01:46 -0400
Date: Sun, 8 Jul 2012 16:01:44 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: JoonSoo Kim <js1304@gmail.com>
cc: Fengguang Wu <fengguang.wu@intel.com>,
        Vegard Nossum <vegard.nossum@gmail.com>,
        Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@kernel.org>,
        Rus <rus@sfinxsoft.com>, Ben Hutchings <ben@decadent.org.uk>,
        Steven Rostedt <rostedt@goodmis.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: WARNING: __GFP_FS allocations with IRQs disabled
 (kmemcheck_alloc_shadow)
In-Reply-To: <CAAmzW4OD2_ODyeY7c1VMPajwzovOms5M8Vnw=XP=uGUyPogiJQ@mail.gmail.com>
Message-ID: <alpine.DEB.2.00.1207081558540.18461@chino.kir.corp.google.com>
References: <20120708040009.GA8363@localhost> <CAAmzW4OD2_ODyeY7c1VMPajwzovOms5M8Vnw=XP=uGUyPogiJQ@mail.gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 9 Jul 2012, JoonSoo Kim wrote:

> diff --git a/mm/slub.c b/mm/slub.c
> index 8c691fa..5d41cad 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -1324,8 +1324,14 @@ static struct page *allocate_slab(struct
> kmem_cache *s, gfp_t flags, int node)
>                 && !(s->flags & (SLAB_NOTRACK | DEBUG_DEFAULT_FLAGS))) {
>                 int pages = 1 << oo_order(oo);
> 
> +               if (flags & __GFP_WAIT)
> +                       local_irq_enable();
> +
>                 kmemcheck_alloc_shadow(page, oo_order(oo), flags, node);
> 
> +               if (flags & __GFP_WAIT)
> +                       local_irq_disable();
> +
>                 /*
>                  * Objects from caches that have a constructor don't get
>                  * cleared when they're allocated, so we need to do it here.

This patch is suboptimal when the branch is taken since you just disabled 
irqs and now are immediately reenabling them and then disabling them 
again.  (And your patch is also whitespace damaged, has no changelog, and 
isn't signed off so it can't be applied.)

The correct fix is what I proposed at 
http://marc.info/?l=linux-kernel&m=133754837703630 and was awaiting 
testing.  If Rus, Steven, or Fengguang could test this then we could add 
it as a stable backport as well.
