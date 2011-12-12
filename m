Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751892Ab1LLPJv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 10:09:51 -0500
Received: from mail-vx0-f174.google.com ([209.85.220.174]:38784 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750790Ab1LLPJt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 10:09:49 -0500
Message-ID: <1323702586.1765.14.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
Subject: Re: [Slub allocator] There are chances that
 kmem_cache_cpu->freelist gets lost if the process happens to be rescheduled
 to a differenet cpu before the local_irq_save() completes in __slab_alloc()
From: Eric Dumazet <eric.dumazet@gmail.com>
To: zhihua che <zhihua.che@gmail.com>
Cc: linux-kernel@vger.kernel.org, Christoph Lameter <cl@linux-foundation.org>
Date: Mon, 12 Dec 2011 16:09:46 +0100
In-Reply-To: <CABexPfFR1n=_JdCYLDRcVsPRcqt5FGmhSjoeZP8CLBMRO_CxfA@mail.gmail.com>
References: <CABexPfFR1n=_JdCYLDRcVsPRcqt5FGmhSjoeZP8CLBMRO_CxfA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 8bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le lundi 12 décembre 2011 à 22:28 +0800, zhihua che a écrit :
> Hi, everyone
> 
>         I'm reading code of version 3.1.5 and I guess I come across a
> memory leak involving with slub allocating process. I image a case
> like below.
> 
>         Process p0 running on cpu0 is requesting a small piece of
> memory by calling slab_alloc(). It finds that the c0->freelist is null
> and resorts to __slab_alloc(), where c0 is a pointer of kmem_cache_cpu
> corresponding to cpu0. Unfortunately, scheduling happens right the
> moment and p0 is now running on a different cpu1. P0 then disables the
> local interrupts of cpu1 at the beginning of __slab_alloc() (line
> 2057),  and retrieves a different pointer of kmem_cache_cpu, c1,
> corresponding to cpu1(line 2064). P0 continues executing to line 2116
> where c1->freelist is assigned a new value while there is no any check
> to it before at all!!! So I think there are chances that memory leak
> could happen if scheduling happens right before line 2057.
> 
> 2057 local_irq_disable();  /* scheduling happens before here */
> 
> 2064 c = this_cpu_ptr(s->cpu_slab);
> 
> 2114 load_freelist:
> 2115         VM_BUG_ON(!page->frozen);
> 2116         c->freelist = get_freepointer(s, object);  /* memory leak
> happens here */
> 
>          I wonder if I think in a wrong way.
> 
>          Furthermore, I find in the earlier version like 2.6.38.8, the
> local interrupts have been disabled in slab_alloc() before the control
> enters the __slab_alloc(), so I think the memory leak is not present
> in the earlier versions.
> --

Hi

CC Christoph Lameter on this one

Another bug from this lockless stuff I am afraid.

We miss a deactivate_slab() call or just deliver object if c->freelist
is not null (and NUMA node matches)

Untested patch :

diff --git a/mm/slub.c b/mm/slub.c
index ed3334d..923d238 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -2166,6 +2166,12 @@ redo:
 		goto new_slab;
 	}
 
+#ifdef CONFIG_PREEMPT
+	object = c->freelist;
+	if (object)
+		goto load_freelist;
+#endif
+
 	stat(s, ALLOC_SLOWPATH);
 
 	do {


