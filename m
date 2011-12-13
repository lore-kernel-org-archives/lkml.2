Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754530Ab1LMD5N (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 22:57:13 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:63469 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754081Ab1LMD5L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 22:57:11 -0500
Message-ID: <1323748626.2583.41.camel@edumazet-laptop>
Subject: Re: [Slub allocator] There are chances that
 kmem_cache_cpu->freelist gets lost if the process happens to be rescheduled
 to a differenet cpu before the local_irq_save() completes in __slab_alloc()
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Christoph Lameter <cl@linux.com>
Cc: zhihua che <zhihua.che@gmail.com>, linux-kernel@vger.kernel.org,
        Pekka Enberg <penberg@cs.helsinki.fi>
Date: Tue, 13 Dec 2011 04:57:06 +0100
In-Reply-To: <1323711558.2583.11.camel@edumazet-laptop>
References: <CABexPfFR1n=_JdCYLDRcVsPRcqt5FGmhSjoeZP8CLBMRO_CxfA@mail.gmail.com>
	 <1323702586.1765.14.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
	 <alpine.DEB.2.00.1112120922020.28410@router.home>
	 <1323711558.2583.11.camel@edumazet-laptop>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 8bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le lundi 12 décembre 2011 à 18:39 +0100, Eric Dumazet a écrit :
> Le lundi 12 décembre 2011 à 09:50 -0600, Christoph Lameter a écrit :
> 
> > Correct. Issue was introduced in 2.6.39.
> > 
> > Acked-by: Christoph Lameter <cl@linux.com>
> > 
> 
> Indeed, I reproduced the leak with hackbench and lot of threads.
> 
> Thanks
> 
> [PATCH] slub: fix a possible memleak in __slab_alloc()
> 
> Zhihua Che reported a possible memleak in slub allocator on
> CONFIG_PREEMPT=y builds.
> 
> It is possible current thread migrates right before disabling irqs in
> __slab_alloc(). We must check again c->freelist, and perform a normal
> allocation instead of scratching c->freelist.
> 
> Many thanks to Zhihua Che for spotting this bug, introduced in 2.6.39
> 
> Reported-by: zhihua che <zhihua.che@gmail.com>
> Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
> Acked-by: Christoph Lameter <cl@linux.com>
> CC: Pekka Enberg <penberg@cs.helsinki.fi>
> CC: stable@vger.kernel.org
> ---
>  mm/slub.c |    6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/mm/slub.c b/mm/slub.c
> index ed3334d..923d238 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -2166,6 +2166,12 @@ redo:
>  		goto new_slab;
>  	}
>  
> +#ifdef CONFIG_PREEMPT
> +	object = c->freelist;
> +	if (object)
> +		goto load_freelist;
> +#endif
> +
>  	stat(s, ALLOC_SLOWPATH);
>  
>  	do {
> 

Thinking again about the issue, I believe its not a CONFIG_PREEMPT only
one.

We can be interrupted and the IRQ handler can free an object an populate
freelist too. So the check must always be done.

Thanks

[PATCH v2] slub: fix a possible memleak in __slab_alloc()

Zhihua Che reported a possible memleak in slub allocator on
CONFIG_PREEMPT=y builds.

It is possible current thread migrates right before disabling irqs in
__slab_alloc(). We must check again c->freelist, and perform a normal
allocation instead of scratching c->freelist.

Many thanks to Zhihua Che for spotting this bug, introduced in 2.6.39

V2: Its also possible an IRQ freed one (or several) object(s) and
populated c->freelist, so its not a CONFIG_PREEMPT only problem.

Reported-by: zhihua che <zhihua.che@gmail.com>
Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
CC: Christoph Lameter <cl@linux.com>
CC: Pekka Enberg <penberg@cs.helsinki.fi>
---
 mm/slub.c |    5 +++++
 1 file changed, 5 insertions(+)

diff --git a/mm/slub.c b/mm/slub.c
index ed3334d..1a919f0 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -2166,6 +2166,11 @@ redo:
 		goto new_slab;
 	}
 
+	/* must check again c->freelist in case of cpu migration or IRQ */
+	object = c->freelist;
+	if (object)
+		goto load_freelist;
+
 	stat(s, ALLOC_SLOWPATH);
 
 	do {


