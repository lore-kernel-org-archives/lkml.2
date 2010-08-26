Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753898Ab0HZOlZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Aug 2010 10:41:25 -0400
Received: from smtp107.prem.mail.ac4.yahoo.com ([76.13.13.46]:28138 "HELO
	smtp107.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753823Ab0HZOlX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Aug 2010 10:41:23 -0400
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: WtlvxwcVM1lO815XPO3yNjPQZZW0qeFJJnhscWG97RO_OXe
 89rnRW2f_rXQUQE.1H6.5EKn2MOSiADTT6xOCVmk2TKIKRiYHwmXussAeuqX
 UDQumOHoKRD8jGGbYYVYSos.88cKfEwyediVuu_R5AxX8fQlN.duycG.ZPXm
 S.y3usXnDUUPaV9tRELT2fR1CPXcolSzdfchiIEqjqbtdE5txWjhPTEZIuGE
 7LTZ3L1WehxlthsoD.9CEP9XxG9t4xEzcfQ--
X-Yahoo-Newman-Property: ymail-3
Date: Thu, 26 Aug 2010 09:41:19 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: David Rientjes <rientjes@google.com>
cc: Pekka Enberg <penberg@cs.helsinki.fi>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>
Subject: Re: linux-next: build failure after merge of the final tree (slab
 tree related)
In-Reply-To: <alpine.DEB.2.00.1008252014560.10986@chino.kir.corp.google.com>
Message-ID: <alpine.DEB.2.00.1008260938360.16331@router.home>
References: <20100824120714.8918f8de.sfr@canb.auug.org.au> <4C740450.3030000@cs.helsinki.fi> <20100825101320.bed89b2a.sfr@canb.auug.org.au> <4C74A01E.1060809@cs.helsinki.fi> <alpine.DEB.2.00.1008250905490.13026@router.home> <alpine.DEB.2.00.1008251656390.22018@chino.kir.corp.google.com>
 <alpine.DEB.2.00.1008252031560.32421@router.home> <alpine.DEB.2.00.1008252014560.10986@chino.kir.corp.google.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 25 Aug 2010, David Rientjes wrote:

> I'm really hoping that we can remove this hack soon when the percpu
> allocator can handle these allocations on UP without any specialized slab
> behavior.

So do I. Here is a slightly less hacky version through using
kmalloc_large instead:


Subject: Slub: UP bandaid

Since the percpu allocator does not provide early allocation in UP
mode (only in SMP configurations) use __get_free_page() to improvise
a compound page allocation that can be later freed via kfree().

Compound pages will be released when the cpu caches are resized.

Acked-by: David Rientjes <rientjes@google.com>
Signed-off-by: Christoph Lameter <cl@linux.com>
---
 mm/slub.c |   16 ++++++++++++++++
 1 file changed, 16 insertions(+)

Index: linux-2.6/mm/slub.c
===================================================================
--- linux-2.6.orig/mm/slub.c	2010-08-26 09:19:35.000000000 -0500
+++ linux-2.6/mm/slub.c	2010-08-26 09:36:29.000000000 -0500
@@ -2103,8 +2103,24 @@ init_kmem_cache_node(struct kmem_cache_n

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
+		s->cpu_slab = (__percpu void *)kmalloc_large(PAGE_SIZE << 1, GFP_NOWAIT);
+	else
+#endif

 	s->cpu_slab = alloc_percpu(struct kmem_cache_cpu);

