Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757619Ab1EaRMG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 May 2011 13:12:06 -0400
Received: from smtp107.prem.mail.ac4.yahoo.com ([76.13.13.46]:41950 "HELO
	smtp107.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753470Ab1EaRME (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 May 2011 13:12:04 -0400
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: o06pP_kVM1n21GXexuNfIKut9HzMqv_JdPdnCanKO0XDJV5
 Ic7urrXPVbIuXhHw6Y6u1W5DBMj3t3D2okpaXGr.8d459LVJJYbf4CP3S9g5
 naqkBV0EvqR2Sc0TtAD8UE.XkuQZ887AtSS6nrq5RM8rqpGdjMwbqgV6atrp
 rf8M1Grprh09uK7Ka8Gazqk6Ltou.7YHE8s0ZIh_zCK1aGvnkFcd6nV35Mja
 IMDNdxdxIJdWYkmXPy0wLTft5P4xKkFmPeF7XnHy8QLurG3fdZD4.E904Rkl
 Mj9Tv4eso1pl9FgRAM0jGoezRB7IzF4YpUyiZ0hyf7VRRZvxfydJ4fGzr5fi
 3fum1zt9OP2WKUX_..vrfxDQA
X-Yahoo-Newman-Property: ymail-3
Date: Tue, 31 May 2011 12:11:59 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: David Rientjes <rientjes@google.com>
cc: Pekka Enberg <penberg@cs.helsinki.fi>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [slubllv6 07/17] slub: explicit list_lock taking
In-Reply-To: <alpine.DEB.2.00.1105261410291.10790@chino.kir.corp.google.com>
Message-ID: <alpine.DEB.2.00.1105311205300.19928@router.home>
References: <20110526181442.789868308@linux.com> <20110526181505.440015365@linux.com> <alpine.DEB.2.00.1105261410291.10790@chino.kir.corp.google.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/Mixed; BOUNDARY="531368966-1511913363-1306444279=:10790"
Content-ID: <alpine.DEB.2.00.1105261413040.10790@chino.kir.corp.google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--531368966-1511913363-1306444279=:10790
Content-Type: TEXT/PLAIN; CHARSET=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Content-ID: <alpine.DEB.2.00.1105261413041.10790@chino.kir.corp.google.com>

On Thu, 26 May 2011, David Rientjes wrote:

> > -static void add_full(struct kmem_cache_node *n, struct page *page)
> > +static void add_full(struct kmem_cache *s,
> > +=09struct kmem_cache_node *n, struct page *page)
>
> This also needs an update to the CONFIG_SLUB_DEBUG=3Dn definition, not on=
ly
> for number of arguments but also the order:
>
> =09mm/slub.c:1781: error: too many arguments to function =E2=80=98add_ful=
l=E2=80=99
>
> and
>
> =09mm/slub.c:1781: warning: passing argument 1 of =E2=80=98add_full=E2=80=
=99 from incompatible pointer type
> =09mm/slub.c:1187: note: expected =E2=80=98struct kmem_cache_node *=E2=80=
=99 but argument is of type =E2=80=98struct kmem_cache *=E2=80=99
> =09mm/slub.c:1781: warning: passing argument 2 of =E2=80=98add_full=E2=80=
=99 from incompatible pointer type
> =09mm/slub.c:1187: note: expected =E2=80=98struct page *=E2=80=99 but arg=
ument is of type =E2=80=98struct kmem_cache_node *=E2=80=99

Correct.


Subject: slub: explicit list_lock taking

The allocator fastpath rework does change the usage of the list_lock.
Remove the list_lock processing from the functions that hide them from the
critical sections and move them into those critical sections.

This in turn simplifies the support functions (no __ variant needed anymore=
)
and simplifies the lock handling on bootstrap.

Inline add_partial since it becomes pretty simple.

Signed-off-by: Christoph Lameter <cl@linux.com>

---
 mm/slub.c |   89 ++++++++++++++++++++++++++++++++++-----------------------=
-----
 1 file changed, 49 insertions(+), 40 deletions(-)

Index: linux-2.6/mm/slub.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- linux-2.6.orig/mm/slub.c=092011-05-31 10:14:00.812977367 -0500
+++ linux-2.6/mm/slub.c=092011-05-31 10:14:03.852977349 -0500
@@ -916,26 +916,27 @@ static inline void slab_free_hook(struct

 /*
  * Tracking of fully allocated slabs for debugging purposes.
+ *
+ * list_lock must be held.
  */
-static void add_full(struct kmem_cache_node *n, struct page *page)
+static void add_full(struct kmem_cache *s,
+=09struct kmem_cache_node *n, struct page *page)
 {
-=09spin_lock(&n->list_lock);
+=09if (!(s->flags & SLAB_STORE_USER))
+=09=09return;
+
 =09list_add(&page->lru, &n->full);
-=09spin_unlock(&n->list_lock);
 }

+/*
+ * list_lock must be held.
+ */
 static void remove_full(struct kmem_cache *s, struct page *page)
 {
-=09struct kmem_cache_node *n;
-
 =09if (!(s->flags & SLAB_STORE_USER))
 =09=09return;

-=09n =3D get_node(s, page_to_nid(page));
-
-=09spin_lock(&n->list_lock);
 =09list_del(&page->lru);
-=09spin_unlock(&n->list_lock);
 }

 /* Tracking of the number of slabs for debugging purposes */
@@ -1060,8 +1061,13 @@ static noinline int free_debug_processin
 =09}

 =09/* Special debug activities for freeing objects */
-=09if (!page->frozen && !page->freelist)
+=09if (!page->frozen && !page->freelist) {
+=09=09struct kmem_cache_node *n =3D get_node(s, page_to_nid(page));
+
+=09=09spin_lock(&n->list_lock);
 =09=09remove_full(s, page);
+=09=09spin_unlock(&n->list_lock);
+=09}
 =09if (s->flags & SLAB_STORE_USER)
 =09=09set_track(s, object, TRACK_FREE, addr);
 =09trace(s, page, object, 0);
@@ -1170,7 +1176,8 @@ static inline int slab_pad_check(struct
 =09=09=09{ return 1; }
 static inline int check_object(struct kmem_cache *s, struct page *page,
 =09=09=09void *object, u8 val) { return 1; }
-static inline void add_full(struct kmem_cache_node *n, struct page *page) =
{}
+static inline void add_full(struct kmem_cache *s, struct kmem_cache_node *=
n,
+=09=09=09=09=09struct page *page) {}
 static inline unsigned long kmem_cache_flags(unsigned long objsize,
 =09unsigned long flags, const char *name,
 =09void (*ctor)(void *))
@@ -1420,38 +1427,33 @@ static __always_inline int slab_trylock(
 }

 /*
- * Management of partially allocated slabs
+ * Management of partially allocated slabs.
+ *
+ * list_lock must be held.
  */
-static void add_partial(struct kmem_cache_node *n,
+static inline void add_partial(struct kmem_cache_node *n,
 =09=09=09=09struct page *page, int tail)
 {
-=09spin_lock(&n->list_lock);
 =09n->nr_partial++;
 =09if (tail)
 =09=09list_add_tail(&page->lru, &n->partial);
 =09else
 =09=09list_add(&page->lru, &n->partial);
-=09spin_unlock(&n->list_lock);
 }

-static inline void __remove_partial(struct kmem_cache_node *n,
+/*
+ * list_lock must be held.
+ */
+static inline void remove_partial(struct kmem_cache_node *n,
 =09=09=09=09=09struct page *page)
 {
 =09list_del(&page->lru);
 =09n->nr_partial--;
 }

-static void remove_partial(struct kmem_cache *s, struct page *page)
-{
-=09struct kmem_cache_node *n =3D get_node(s, page_to_nid(page));
-
-=09spin_lock(&n->list_lock);
-=09__remove_partial(n, page);
-=09spin_unlock(&n->list_lock);
-}
-
 /*
- * Lock slab and remove from the partial list.
+ * Lock slab, remove from the partial list and put the object into the
+ * per cpu freelist.
  *
  * Must hold list_lock.
  */
@@ -1459,7 +1461,7 @@ static inline int lock_and_freeze_slab(s
 =09=09=09=09=09=09=09struct page *page)
 {
 =09if (slab_trylock(page)) {
-=09=09__remove_partial(n, page);
+=09=09remove_partial(n, page);
 =09=09return 1;
 =09}
 =09return 0;
@@ -1576,12 +1578,17 @@ static void unfreeze_slab(struct kmem_ca
 =09if (page->inuse) {

 =09=09if (page->freelist) {
+=09=09=09spin_lock(&n->list_lock);
 =09=09=09add_partial(n, page, tail);
+=09=09=09spin_unlock(&n->list_lock);
 =09=09=09stat(s, tail ? DEACTIVATE_TO_TAIL : DEACTIVATE_TO_HEAD);
 =09=09} else {
 =09=09=09stat(s, DEACTIVATE_FULL);
-=09=09=09if (kmem_cache_debug(s) && (s->flags & SLAB_STORE_USER))
-=09=09=09=09add_full(n, page);
+=09=09=09if (kmem_cache_debug(s) && (s->flags & SLAB_STORE_USER)) {
+=09=09=09=09spin_lock(&n->list_lock);
+=09=09=09=09add_full(s, n, page);
+=09=09=09=09spin_unlock(&n->list_lock);
+=09=09=09}
 =09=09}
 =09=09slab_unlock(page);
 =09} else {
@@ -1597,7 +1604,9 @@ static void unfreeze_slab(struct kmem_ca
 =09=09=09 * kmem_cache_shrink can reclaim any empty slabs from
 =09=09=09 * the partial list.
 =09=09=09 */
+=09=09=09spin_lock(&n->list_lock);
 =09=09=09add_partial(n, page, 1);
+=09=09=09spin_unlock(&n->list_lock);
 =09=09=09slab_unlock(page);
 =09=09} else {
 =09=09=09slab_unlock(page);
@@ -2099,7 +2108,11 @@ static void __slab_free(struct kmem_cach
 =09 * then add it.
 =09 */
 =09if (unlikely(!prior)) {
+=09=09struct kmem_cache_node *n =3D get_node(s, page_to_nid(page));
+
+=09=09spin_lock(&n->list_lock);
 =09=09add_partial(get_node(s, page_to_nid(page)), page, 1);
+=09=09spin_unlock(&n->list_lock);
 =09=09stat(s, FREE_ADD_PARTIAL);
 =09}

@@ -2113,7 +2126,11 @@ slab_empty:
 =09=09/*
 =09=09 * Slab still on the partial list.
 =09=09 */
-=09=09remove_partial(s, page);
+=09=09struct kmem_cache_node *n =3D get_node(s, page_to_nid(page));
+
+=09=09spin_lock(&n->list_lock);
+=09=09remove_partial(n, page);
+=09=09spin_unlock(&n->list_lock);
 =09=09stat(s, FREE_REMOVE_PARTIAL);
 =09}
 =09slab_unlock(page);
@@ -2395,7 +2412,6 @@ static void early_kmem_cache_node_alloc(
 {
 =09struct page *page;
 =09struct kmem_cache_node *n;
-=09unsigned long flags;

 =09BUG_ON(kmem_cache_node->size < sizeof(struct kmem_cache_node));

@@ -2422,14 +2438,7 @@ static void early_kmem_cache_node_alloc(
 =09init_kmem_cache_node(n, kmem_cache_node);
 =09inc_slabs_node(kmem_cache_node, node, page->objects);

-=09/*
-=09 * lockdep requires consistent irq usage for each lock
-=09 * so even though there cannot be a race this early in
-=09 * the boot sequence, we still disable irqs.
-=09 */
-=09local_irq_save(flags);
 =09add_partial(n, page, 0);
-=09local_irq_restore(flags);
 }

 static void free_kmem_cache_nodes(struct kmem_cache *s)
@@ -2713,7 +2722,7 @@ static void free_partial(struct kmem_cac
 =09spin_lock_irqsave(&n->list_lock, flags);
 =09list_for_each_entry_safe(page, h, &n->partial, lru) {
 =09=09if (!page->inuse) {
-=09=09=09__remove_partial(n, page);
+=09=09=09remove_partial(n, page);
 =09=09=09discard_slab(s, page);
 =09=09} else {
 =09=09=09list_slab_objects(s, page,
@@ -3051,7 +3060,7 @@ int kmem_cache_shrink(struct kmem_cache
 =09=09=09=09 * may have freed the last object and be
 =09=09=09=09 * waiting to release the slab.
 =09=09=09=09 */
-=09=09=09=09__remove_partial(n, page);
+=09=09=09=09remove_partial(n, page);
 =09=09=09=09slab_unlock(page);
 =09=09=09=09discard_slab(s, page);
 =09=09=09} else {
--531368966-1511913363-1306444279=:10790--
