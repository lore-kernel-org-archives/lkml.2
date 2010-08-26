Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754156Ab0HZBfx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Aug 2010 21:35:53 -0400
Received: from smtp109.prem.mail.ac4.yahoo.com ([76.13.13.92]:37231 "HELO
	smtp109.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753656Ab0HZBfw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Aug 2010 21:35:52 -0400
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: uRvjbWEVM1nsS1nUBe4TjeFsvImOQU8jEtXsf9Jf3qmPOzG
 xa8_WfIy8EFfPAsgLkHaGQxSbXWBaYmVfqJnP_xWd7UIARStreSbL9mspT98
 E9u4KwpN80n9H6ffFKr6ECJf4CzIz1dA1yfZ4.3ijB1QwImufmcWNZv8HVZh
 5e0SYpfpf1OFzjCfE5x.Bu11s4hz02dDqSBcaFduY3AdoznV.ZwFDMan6zKl
 3bj2YUyYumb8e5mVfwWgOIrp2rjvdrXvqcA--
X-Yahoo-Newman-Property: ymail-3
Date: Wed, 25 Aug 2010 20:35:49 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: David Rientjes <rientjes@google.com>
cc: Pekka Enberg <penberg@cs.helsinki.fi>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>
Subject: Re: linux-next: build failure after merge of the final tree (slab
 tree related)
In-Reply-To: <alpine.DEB.2.00.1008251656390.22018@chino.kir.corp.google.com>
Message-ID: <alpine.DEB.2.00.1008252031560.32421@router.home>
References: <20100824120714.8918f8de.sfr@canb.auug.org.au> <4C740450.3030000@cs.helsinki.fi> <20100825101320.bed89b2a.sfr@canb.auug.org.au> <4C74A01E.1060809@cs.helsinki.fi> <alpine.DEB.2.00.1008250905490.13026@router.home>
 <alpine.DEB.2.00.1008251656390.22018@chino.kir.corp.google.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 25 Aug 2010, David Rientjes wrote:

> > +	 * Special hack for UP mode. allocpercpu() falls back to kmalloc
> > +	 * operations. So we cannot use that before the slab allocator is up
> > +	 * Simply get the smallest possible compound page. The page will be
> > +	 * released via kfree() when the cpu caches are resized later.
> > +	 */
> > +	if (slab_state < UP)
> > +		s->cpu_slab = (__percpu void *)__get_free_page(GFP_NOWAIT, 1);
>
> __get_free_pages() takes an order argument.

Right. Patch not refreshed after the last tinzy winzy change. Seems that I
got a bit rusty.

Subject: Slub: UP bandaid

Since the percpu allocator does not provide early allocation in UP
mode (only in SMP configurations) use __get_free_page() to improvise
a compound page allocation that can be later freed via kfree().

Compound pages will be released when the cpu caches are resized.

Signed-off-by: Christoph Lameter <cl@linux.com>



---
 mm/slub.c |   16 ++++++++++++++++
 1 file changed, 16 insertions(+)

Index: linux-2.6/mm/slub.c
===================================================================
--- linux-2.6.orig/mm/slub.c	2010-08-25 09:00:59.000000000 -0500
+++ linux-2.6/mm/slub.c	2010-08-25 10:59:30.000000000 -0500
@@ -2091,8 +2091,24 @@ init_kmem_cache_node(struct kmem_cache_n

 static inline int alloc_kmem_cache_cpus(struct kmem_cache *s)
 {
+#ifdef CONFIG_SMP
+	/*
+	 * Will use reserve that does not require slab operation during
+	 * early boot.
+	 */
 	BUILD_BUG_ON(PERCPU_DYNAMIC_EARLY_SIZE <
 			SLUB_PAGE_SHIFT * sizeof(struct kmem_cache_cpu));
+#else
+	/*
+	 * Special hack for UP mode. allocpercpu() falls back to kmalloc
+	 * operations. So we cannot use that before the slab allocator is up
+	 * Simply get the smallest possible compound page. The page will be
+	 * released via kfree() when the cpu caches are resized later.
+	 */
+	if (slab_state < UP)
+		s->cpu_slab = (__percpu void *)__get_free_pages(GFP_NOWAIT, 1);
+	else
+#endif

 	s->cpu_slab = alloc_percpu(struct kmem_cache_cpu);

