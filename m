Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754734Ab1LCBik (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Dec 2011 20:38:40 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:49271 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754094Ab1LCBhz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Dec 2011 20:37:55 -0500
X-Authority-Analysis: v=2.0 cv=bdLpoZzB c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=vhdKIqpQuCYA:10 a=3Iuw8lWLgoIA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=LuxQ-7HEAAAA:8 a=PuvxfXWCAAAA:8 a=pwlSjyV6AAAA:8 a=CjxXgO3LAAAA:8 a=37rDS-QxAAAA:8 a=1XWaLZrsAAAA:8 a=VwQbUJbxAAAA:8 a=meVymXHHAAAA:8 a=na7JmFnELkQSUYAU3l0A:9 a=FidwMjQ2yVJ1iJv1gswA:7 a=QEXdDO2ut3YA:10 a=Bm8BtE0CId0A:10 a=o70cNcPx40UA:10 a=_1CdXZwv0MQA:10 a=rC2wZJ5BpNYA:10 a=6uQODOVjHeUA:10 a=UTB_XpHje0EA:10 a=Zh68SRI7RUMA:10 a=jeBq3FmKZ4MA:10 a=mhVWX-WR6GG9nsnwJZcA:9 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-Id: <20111203013752.304050087@goodmis.org>
User-Agent: quilt/0.48-1
Date: Fri, 02 Dec 2011 20:37:02 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Hans Schillstrom <hans@schillstrom.com>,
        Christoph Lameter <cl@gentwo.org>,
        Pekka Enberg <penberg@cs.helsinki.fi>, Matt Mackall <mpm@selenic.com>,
        Sitsofe Wheeler <sitsofe@yahoo.com>, linux-mm@kvack.org,
        David Rientjes <rientjes@google.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 09/10] slab, lockdep: Annotate all slab caches
References: <20111203013653.090501690@goodmis.org>
Content-Disposition: inline; filename=0009-slab-lockdep-Annotate-all-slab-caches.patch
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="00GvhwF7k39YY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00GvhwF7k39YY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

From: Peter Zijlstra <a.p.zijlstra@chello.nl>

Currently we only annotate the kmalloc caches, annotate all of them.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Hans Schillstrom <hans@schillstrom.com>
Cc: Christoph Lameter <cl@gentwo.org>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Matt Mackall <mpm@selenic.com>
Cc: Sitsofe Wheeler <sitsofe@yahoo.com>
Cc: linux-mm@kvack.org
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Link: http://lkml.kernel.org/n/tip-10bey2cgpcvtbdkgigaoab8w@git.kernel.org
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 mm/slab.c |   52 ++++++++++++++++++++++++++++------------------------
 1 files changed, 28 insertions(+), 24 deletions(-)

diff --git a/mm/slab.c b/mm/slab.c
index 433b9a2..5251b99 100644
--- a/mm/slab.c
+++ b/mm/slab.c
@@ -606,6 +606,12 @@ int slab_is_available(void)
 	return g_cpucache_up >=3D EARLY;
 }
=20
+/*
+ * Guard access to the cache-chain.
+ */
+static DEFINE_MUTEX(cache_chain_mutex);
+static struct list_head cache_chain;
+
 #ifdef CONFIG_LOCKDEP
=20
 /*
@@ -667,38 +673,41 @@ static void slab_set_debugobj_lock_classes(struct kme=
m_cache *cachep)
 		slab_set_debugobj_lock_classes_node(cachep, node);
 }
=20
-static void init_node_lock_keys(int q)
+static void init_lock_keys(struct kmem_cache *cachep, int node)
 {
-	struct cache_sizes *s =3D malloc_sizes;
+	struct kmem_list3 *l3;
=20
 	if (g_cpucache_up < LATE)
 		return;
=20
-	for (s =3D malloc_sizes; s->cs_size !=3D ULONG_MAX; s++) {
-		struct kmem_list3 *l3;
+	l3 =3D cachep->nodelists[node];
+	if (!l3 || OFF_SLAB(cachep))
+		return;
=20
-		l3 =3D s->cs_cachep->nodelists[q];
-		if (!l3 || OFF_SLAB(s->cs_cachep))
-			continue;
+	slab_set_lock_classes(cachep, &on_slab_l3_key, &on_slab_alc_key, node);
+}
=20
-		slab_set_lock_classes(s->cs_cachep, &on_slab_l3_key,
-				&on_slab_alc_key, q);
-	}
+static void init_node_lock_keys(int node)
+{
+	struct kmem_cache *cachep;
+
+	list_for_each_entry(cachep, &cache_chain, next)
+		init_lock_keys(cachep, node);
 }
=20
-static inline void init_lock_keys(void)
+static inline void init_cachep_lock_keys(struct kmem_cache *cachep)
 {
 	int node;
=20
 	for_each_node(node)
-		init_node_lock_keys(node);
+		init_lock_keys(cachep, node);
 }
 #else
-static void init_node_lock_keys(int q)
+static void init_node_lock_keys(int node)
 {
 }
=20
-static inline void init_lock_keys(void)
+static void init_cachep_lock_keys(struct kmem_cache *cachep)
 {
 }
=20
@@ -711,12 +720,6 @@ static void slab_set_debugobj_lock_classes(struct kmem=
_cache *cachep)
 }
 #endif
=20
-/*
- * Guard access to the cache-chain.
- */
-static DEFINE_MUTEX(cache_chain_mutex);
-static struct list_head cache_chain;
-
 static DEFINE_PER_CPU(struct delayed_work, slab_reap_work);
 static DEFINE_PER_CPU(struct list_head, slab_free_list);
 static DEFINE_LOCAL_IRQ_LOCK(slab_lock);
@@ -1728,14 +1731,13 @@ void __init kmem_cache_init_late(void)
=20
 	g_cpucache_up =3D LATE;
=20
-	/* Annotate slab for lockdep -- annotate the malloc caches */
-	init_lock_keys();
-
 	/* 6) resize the head arrays to their final sizes */
 	mutex_lock(&cache_chain_mutex);
-	list_for_each_entry(cachep, &cache_chain, next)
+	list_for_each_entry(cachep, &cache_chain, next) {
+		init_cachep_lock_keys(cachep);
 		if (enable_cpucache(cachep, GFP_NOWAIT))
 			BUG();
+	}
 	mutex_unlock(&cache_chain_mutex);
=20
 	/* Done! */
@@ -2546,6 +2548,8 @@ kmem_cache_create (const char *name, size_t size, siz=
e_t align,
 		slab_set_debugobj_lock_classes(cachep);
 	}
=20
+	init_cachep_lock_keys(cachep);
+
 	/* cache setup completed, link it into the list */
 	list_add(&cachep->next, &cache_chain);
 oops:
--=20
1.7.7.1



--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAABAgAGBQJO2X1wAAoJEIy3vGnGbaoAVekP/18ahp4JHcOI/wfnTbwH3wsc
3b7S9/U+dHtIwAr/aQ9QZgDs57SzndEu7ZUwokodYMgsSMX8xhii8Wd3FR9CBhDp
TCunVmraJaU9tE4tEJzwpaC2uxCTd6w3sA32z0PWSEfz8mH6Hf7NTDTO/VX6F0b0
Imj4jobVTdZ3b/fO1QQiSf4OfklSRhifKxf9A0efP7GvvW2GJs2/tDpQuRCEUEbF
j5H3cZElxojjcYcR2OGS7fV13DROPtPvAyiM0ipYrx9TVQ7BxBMjPAQR0DXObvuP
8NwfvmuWAvC6Nra5nu1wW5GVAC3xopsCoZNB4A6mC12XdV9Mni6YuF9bTktR7kRA
xo9uunExYJk4k63yYouX8FFu2LCuKF7HBwG3a7IAwYmmvybYUlrj3L7NUsjpDdGm
8VKOO5eyLbqGXtRod6Bx3owjvts82ddZbqG0EqQlqjBRh3+zkYH4HQzVoDBQq+Ao
MZ1nfaOUimhGoB8/IxHH8L1EieId2NT7M3D+bVJPJo+Pq0u0zQqHR9XZbVL3X+Q0
hF2OtIM3N4rpki8duDcl6iKxIJFA/IHOZe4v7oENGdrqWpqlm5Gnb2JxkbNdDoeu
RJOIbR/Udplj6qWzyBxZnlyplEBkF8l2ANZtu3FPgqNXIc0WUHt1/vsJyZDuctFv
lUDvfAh7y55sZjDQbsgs
=/YY4
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
