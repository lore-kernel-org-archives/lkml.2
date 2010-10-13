Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753158Ab0JMHQt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Oct 2010 03:16:49 -0400
Received: from freeflow.nu ([178.79.134.28]:46793 "EHLO freeflow.nu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753032Ab0JMHQr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Oct 2010 03:16:47 -0400
Message-ID: <4CB55CDD.9010908@kernel.org>
Date: Wed, 13 Oct 2010 10:16:45 +0300
From: Pekka Enberg <penberg@kernel.org>
User-Agent: Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10.6; en-US; rv:1.9.2.9) Gecko/20100915 Thunderbird/3.1.4
MIME-Version: 1.0
To: Mel Gorman <mel@csn.ul.ie>
CC: Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@cs.helsinki.fi>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        David Rientjes <rientjes@google.com>, npiggin@kernel.dk,
        yanmin_zhang@linux.intel.com
Subject: Re: [UnifiedV4 00/16] The Unified slab allocator (V4)
References: <20101005185725.088808842@linux.com> <AANLkTinPU4T59PvDH1wX2Rcy7beL=TvmHOZh_wWuBU-T@mail.gmail.com> <20101012182531.GH30667@csn.ul.ie>
In-Reply-To: <20101012182531.GH30667@csn.ul.ie>
Content-Type: multipart/mixed;
 boundary="------------070005060006040809030005"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------070005060006040809030005
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit

  On 10/12/10 9:25 PM, Mel Gorman wrote:
> On Wed, Oct 06, 2010 at 11:01:35AM +0300, Pekka Enberg wrote:
>> (Adding more people who've taken interest in slab performance in the
>> past to CC.)
>>
> I have not come even close to reviewing this yet but I made a start on
> putting it through a series of tests. It fails to build on ppc64
>
>    CC      mm/slub.o
> mm/slub.c:1477: warning: 'drain_alien_caches' declared inline after being called
> mm/slub.c:1477: warning: previous declaration of 'drain_alien_caches' was here

Can you try the attached patch to see if it fixes the problem?
> mm/slub.c: In function `alloc_shared_caches':
> mm/slub.c:1748: error: `cpu_info' undeclared (first use in this function)
> mm/slub.c:1748: error: (Each undeclared identifier is reported only once
> mm/slub.c:1748: error: for each function it appears in.)
> mm/slub.c:1748: warning: type defaults to `int' in declaration of `type name'
> mm/slub.c:1748: warning: type defaults to `int' in declaration of `type name'
> mm/slub.c:1748: warning: type defaults to `int' in declaration of `type name'
> mm/slub.c:1748: warning: type defaults to `int' in declaration of `type name'
> mm/slub.c:1748: error: invalid type argument of `unary *'
> make[1]: *** [mm/slub.o] Error 1
> make: *** [mm] Error 2
>
> I didn't look closely yet but cpu_info is an arch-specific variable.
> Checking to see if there is a known fix yet before setting aside time to
> dig deeper.
Yeah, cpu_info.llc_shared_map is an x86ism. Christoph?

             Pekka


--------------070005060006040809030005
Content-Type: text/plain; x-mac-type="0"; x-mac-creator="0";
 name="0001-slub-Fix-drain_alien_cache-redeclaration.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="0001-slub-Fix-drain_alien_cache-redeclaration.patch"

>From 5e3e319b1c7a92fc58e6b7da0d20df823f93a9c8 Mon Sep 17 00:00:00 2001
From: Pekka Enberg <penberg@kernel.org>
Date: Wed, 13 Oct 2010 10:10:44 +0300
Subject: [PATCH] slub: Fix drain_alien_cache() redeclaration

This patch fixes drain_alien_caches() redeclaration that causes a compliation
warning on PPC:

  CC      mm/slub.o
mm/slub.c:1477: warning: 'drain_alien_caches' declared inline after being called
mm/slub.c:1477: warning: previous declaration of 'drain_alien_caches' was here

Reported-by: Mel Gorman <mel@csn.ul.ie>
Signed-off-by: Pekka Enberg <penberg@kernel.org>
---
 mm/slub.c |  102 +++++++++++++++++++++++++++++-------------------------------
 1 files changed, 49 insertions(+), 53 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index 9d9bb07..a23bf2b 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -1472,9 +1472,56 @@ static inline int drain_shared_cache(struct kmem_cache *s,
 	}
 	return n;
 }
+/*
+ * Alien caches which are also shared caches
+ */
+
+#ifdef CONFIG_NUMA
+
+static inline struct kmem_cache_queue *__alien_cache(struct kmem_cache *s,
+			struct kmem_cache_queue *q, int node)
+{
+	void *p = q;
+
+	p -= (node << s->alien_shift);
+
+	return (struct kmem_cache_queue *)p;
+}
+
+/* Given an allocation context determine the alien queue to use */
+static inline struct kmem_cache_queue *alien_cache(struct kmem_cache *s,
+		struct kmem_cache_cpu *c, int node)
+{
+	/* If the cache does not have any alien caches return NULL */
+	if (!c->q.shared || node == c->node)
+		return NULL;
+
+	/*
+	 * Map [0..(c->node - 1)] -> [1..c->node].
+	 *
+	 * This effectively removes the current node (which is serviced by
+	 * the shared cache) from the list and avoids hitting 0 (which would
+	 * result in accessing the shared queue used for the cpu cache).
+	 */
+	if (node < c->node)
+		node++;
 
-static void drain_alien_caches(struct kmem_cache *s,
-				struct kmem_cache_cpu *c);
+	return __alien_cache(s, c->q.shared, node);
+}
+
+static inline void drain_alien_caches(struct kmem_cache *s,
+					 struct kmem_cache_cpu *c)
+{
+	int node;
+
+	for_each_node_state(node, N_NORMAL_MEMORY)
+		drain_shared_cache(s, alien_cache(s, c, node));
+}
+
+#else
+static inline void drain_alien_caches(struct kmem_cache *s,
+				 struct kmem_cache_cpu *c) {}
+#endif
 
 /*
  * Drain all objects from a per cpu queue
@@ -1613,57 +1660,6 @@ struct kmem_cache_queue **shared_caches(struct kmem_cache *s, int node)
 	return caches;
 }
 
-/*
- * Alien caches which are also shared caches
- */
-
-#ifdef CONFIG_NUMA
-
-static inline struct kmem_cache_queue *__alien_cache(struct kmem_cache *s,
-			struct kmem_cache_queue *q, int node)
-{
-	void *p = q;
-
-	p -= (node << s->alien_shift);
-
-	return (struct kmem_cache_queue *)p;
-}
-
-/* Given an allocation context determine the alien queue to use */
-static inline struct kmem_cache_queue *alien_cache(struct kmem_cache *s,
-		struct kmem_cache_cpu *c, int node)
-{
-	/* If the cache does not have any alien caches return NULL */
-	if (!c->q.shared || node == c->node)
-		return NULL;
-
-	/*
-	 * Map [0..(c->node - 1)] -> [1..c->node].
-	 *
-	 * This effectively removes the current node (which is serviced by
-	 * the shared cache) from the list and avoids hitting 0 (which would
-	 * result in accessing the shared queue used for the cpu cache).
-	 */
-	if (node < c->node)
-		node++;
-
-	return __alien_cache(s, c->q.shared, node);
-}
-
-static inline void drain_alien_caches(struct kmem_cache *s,
-					 struct kmem_cache_cpu *c)
-{
-	int node;
-
-	for_each_node_state(node, N_NORMAL_MEMORY)
-		drain_shared_cache(s, alien_cache(s, c, node));
-}
-
-#else
-static inline void drain_alien_caches(struct kmem_cache *s,
-				 struct kmem_cache_cpu *c) {}
-#endif
-
 static struct kmem_cache *get_slab(size_t size, gfp_t flags);
 
 /* Map of cpus that have no siblings or where we have broken topolocy info */
-- 
1.7.1


--------------070005060006040809030005--
