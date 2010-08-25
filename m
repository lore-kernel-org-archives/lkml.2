Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753252Ab0HYOHM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Aug 2010 10:07:12 -0400
Received: from smtp105.prem.mail.ac4.yahoo.com ([76.13.13.44]:26903 "HELO
	smtp105.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753047Ab0HYOHK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Aug 2010 10:07:10 -0400
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: RWaNI7kVM1m0UuYd3GXJcHzzjoLm5iy9D3J5RaNqQ7OW1.5
 _sq1V5_2aJLBbhBLSyLBKAS8fN2T5xStveOF4Pz8ifSmaYA.9fBE.LN_jyv7
 oTbn5XkuEN98GaeEZtWpT2BreqQi9M8.16Op66bmmCc1XyKHYQsWDnHHCkW7
 5oA0KVbp7Yr4SVllW.4nq5RWajiQ6_E8CPs.94cenIipUKI30OC6ooJD7Dq7
 AO7vTR3VJYdU_3ETx4DQkFB5rm_3kw.DpRQvMjAOWVYSSCYh7kddtI9Dh.Jn
 UJA--
X-Yahoo-Newman-Property: ymail-3
Date: Wed, 25 Aug 2010 09:07:07 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Pekka Enberg <penberg@cs.helsinki.fi>
cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>
Subject: Re: linux-next: build failure after merge of the final tree (slab
 tree related)
In-Reply-To: <4C74A01E.1060809@cs.helsinki.fi>
Message-ID: <alpine.DEB.2.00.1008250905490.13026@router.home>
References: <20100824120714.8918f8de.sfr@canb.auug.org.au> <4C740450.3030000@cs.helsinki.fi> <20100825101320.bed89b2a.sfr@canb.auug.org.au> <4C74A01E.1060809@cs.helsinki.fi>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 25 Aug 2010, Pekka Enberg wrote:

> I dropped slub cleanups from -next until we've resolved the UP boot time crash
> problem.
>

It works here with this patch. I'd rather see a general solution so that
we can use allocpercpu for bootstrapping any allocator without such
special bandaids.



Subject: Slub: UP bandaid

Since the percpu allocator does not provide early allocation in UP
mode (only in SMP configurations) use __get_free_page() to improvise
a compound page allocation that can be later freed via kfree().

Compound pages will be released when the cpu caches are resized.

Signed-off-by: Christoph Lameter <cl@linux.com>

---
 mm/slub.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

Index: linux-2.6/mm/slub.c
===================================================================
--- linux-2.6.orig/mm/slub.c	2010-08-24 20:07:12.766010774 -0500
+++ linux-2.6/mm/slub.c	2010-08-24 20:15:46.304130417 -0500
@@ -2064,8 +2064,24 @@

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
+		s->cpu_slab = (__percpu void *)__get_free_page(GFP_NOWAIT, 1);
+	else
+#endif

 	s->cpu_slab = alloc_percpu(struct kmem_cache_cpu);

