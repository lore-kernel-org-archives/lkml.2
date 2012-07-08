Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751376Ab2GHQMa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jul 2012 12:12:30 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:45718 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750836Ab2GHQM3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jul 2012 12:12:29 -0400
MIME-Version: 1.0
In-Reply-To: <20120708040009.GA8363@localhost>
References: <20120708040009.GA8363@localhost>
Date: Mon, 9 Jul 2012 01:12:28 +0900
Message-ID: <CAAmzW4OD2_ODyeY7c1VMPajwzovOms5M8Vnw=XP=uGUyPogiJQ@mail.gmail.com>
Subject: Re: WARNING: __GFP_FS allocations with IRQs disabled (kmemcheck_alloc_shadow)
From: JoonSoo Kim <js1304@gmail.com>
To: Fengguang Wu <fengguang.wu@intel.com>
Cc: Vegard Nossum <vegard.nossum@gmail.com>, Christoph Lameter <cl@linux.com>,
        Pekka Enberg <penberg@kernel.org>,
        Linux Memory Management List <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/7/8 Fengguang Wu <fengguang.wu@intel.com>:
> Hi Vegard,
>
> This warning code is triggered for the attached config:
>
> __lockdep_trace_alloc():
>         /*
>          * Oi! Can't be having __GFP_FS allocations with IRQs disabled.
>          */
>         if (DEBUG_LOCKS_WARN_ON(irqs_disabled_flags(flags)))
>                 return;
>
> Where the irq is possibly disabled at the beginning of __slab_alloc():
>
>         local_irq_save(flags);

Currently, in slub code, kmemcheck_alloc_shadow is always invoked with
irq_disabled.
I think that something like below is needed.

diff --git a/mm/slub.c b/mm/slub.c
index 8c691fa..5d41cad 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -1324,8 +1324,14 @@ static struct page *allocate_slab(struct
kmem_cache *s, gfp_t flags, int node)
                && !(s->flags & (SLAB_NOTRACK | DEBUG_DEFAULT_FLAGS))) {
                int pages = 1 << oo_order(oo);

+               if (flags & __GFP_WAIT)
+                       local_irq_enable();
+
                kmemcheck_alloc_shadow(page, oo_order(oo), flags, node);

+               if (flags & __GFP_WAIT)
+                       local_irq_disable();
+
                /*
                 * Objects from caches that have a constructor don't get
                 * cleared when they're allocated, so we need to do it here.
-- 
1.7.0.4
