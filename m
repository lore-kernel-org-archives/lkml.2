Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757688Ab1EaRFW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 May 2011 13:05:22 -0400
Received: from smtp106.prem.mail.ac4.yahoo.com ([76.13.13.45]:22148 "HELO
	smtp106.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1757143Ab1EaRFV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 May 2011 13:05:21 -0400
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: GaW_JVkVM1nCoW4ub5njou47U8IY3Nt7ZTi_A7huY4jB4O6
 vAMBiKCBF9Ni3gF5NCH3ftpr_J6nDXRT2tRndKvJO4yXUBqUz7Y26n.Zceyd
 3OjICRGeb2o5hJPbeZkITj966I0tlePSm1BX8QDASwcvSQK2dLl9BwgMZTHq
 sYmuDyNIU7Y6yxzP5lhBer9siTyvRrkm6Bl0KUGzm8yMYMGGtl.gJnfgP_n4
 FK.0TZKStg5qEOIxeo2bhgH26AR8ifH3jrbPBUMDxzWfiOoZkDEl9MevSirh
 bJdBhy6MqREcsuJeNFp79g1YrJfsTWso.L_MwA.vtb_B7u39UspPiNHJbEWv
 Sw8hLEAZXiBcCCsdTC3RSwoy1
X-Yahoo-Newman-Property: ymail-3
Date: Tue, 31 May 2011 12:05:17 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: David Rientjes <rientjes@google.com>
cc: Pekka Enberg <penberg@cs.helsinki.fi>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [slubllv6 06/17] slub: Add cmpxchg_double_slab()
In-Reply-To: <alpine.DEB.2.00.1105261401160.10790@chino.kir.corp.google.com>
Message-ID: <alpine.DEB.2.00.1105311203330.19928@router.home>
References: <20110526181442.789868308@linux.com> <20110526181504.863758450@linux.com> <alpine.DEB.2.00.1105261401160.10790@chino.kir.corp.google.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/Mixed; BOUNDARY="531368966-1358618695-1306443737=:10790"
Content-ID: <alpine.DEB.2.00.1105261509030.10790@chino.kir.corp.google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--531368966-1358618695-1306443737=:10790
Content-Type: TEXT/PLAIN; CHARSET=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Content-ID: <alpine.DEB.2.00.1105261509031.10790@chino.kir.corp.google.com>

On Thu, 26 May 2011, David Rientjes wrote:

> > +static inline bool cmpxchg_double_slab(struct kmem_cache *s, struct pa=
ge *page,
> > +=09=09void *freelist_old, unsigned long counters_old,
> > +=09=09void *freelist_new, unsigned long counters_new,
> > +=09=09const char *n)
>
> This is defined only under CONFIG_SLUB_DEBUG, which is surely a mistake:
>
> =09mm/slub.c: In function =E2=80=98acquire_slab=E2=80=99:
> =09mm/slub.c:1460: error: implicit declaration of function =E2=80=98cmpxc=
hg_double_slab=E2=80=99

Ok.

> > +#ifdef CONFIG_CMPXCHG_DOUBLE
> > +=09if (system_has_cmpxchg_double() && (s->flags & SLAB_DEBUG_FLAGS) =
=3D=3D 0)
> > +=09=09/* Enable fast mode */
> > +=09=09s->flags |=3D __CMPXCHG_DOUBLE;
> > +#endif
> > +
>
> Not sure why this is excluded for SLAB_DEBUG_FLAGS?  If it really should
> be, then we should clear __CMPXCHG_DOUBLE if debugging features are
> enabled through sysfs as well.

Right. Fixed up patch follows:



Subject: slub: Add cmpxchg_double_slab()

Add a function that operates on the second doubleword in the page struct
and manipulates the object counters, the freelist and the frozen attribute.

Signed-off-by: Christoph Lameter <cl@linux.com>

---
 include/linux/slub_def.h |    1
 mm/slub.c                |   65 ++++++++++++++++++++++++++++++++++++++++++=
+----
 2 files changed, 61 insertions(+), 5 deletions(-)

Index: linux-2.6/mm/slub.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- linux-2.6.orig/mm/slub.c=092011-05-31 11:57:59.622937422 -0500
+++ linux-2.6/mm/slub.c=092011-05-31 12:03:16.652935392 -0500
@@ -131,6 +131,9 @@ static inline int kmem_cache_debug(struc
 /* Enable to test recovery from slab corruption on boot */
 #undef SLUB_RESILIENCY_TEST

+/* Enable to log cmpxchg failures */
+#undef SLUB_DEBUG_CMPXCHG
+
 /*
  * Mininum number of partial slabs. These will be left on the partial
  * lists even if they are empty. kmem_cache_shrink may reclaim them.
@@ -170,6 +173,7 @@ static inline int kmem_cache_debug(struc

 /* Internal SLUB flags */
 #define __OBJECT_POISON=09=090x80000000UL /* Poison object */
+#define __CMPXCHG_DOUBLE=090x40000000UL /* Use cmpxchg_double */

 static int kmem_size =3D sizeof(struct kmem_cache);

@@ -338,6 +342,37 @@ static inline int oo_objects(struct kmem
 =09return x.x & OO_MASK;
 }

+static inline bool cmpxchg_double_slab(struct kmem_cache *s, struct page *=
page,
+=09=09void *freelist_old, unsigned long counters_old,
+=09=09void *freelist_new, unsigned long counters_new,
+=09=09const char *n)
+{
+#ifdef CONFIG_CMPXCHG_DOUBLE
+=09if (s->flags & __CMPXCHG_DOUBLE) {
+=09=09if (cmpxchg_double(&page->freelist,
+=09=09=09freelist_old, counters_old,
+=09=09=09freelist_new, counters_new))
+=09=09return 1;
+=09} else
+#endif
+=09{
+=09=09if (page->freelist =3D=3D freelist_old && page->counters =3D=3D coun=
ters_old) {
+=09=09=09page->freelist =3D freelist_new;
+=09=09=09page->counters =3D counters_new;
+=09=09=09return 1;
+=09=09}
+=09}
+
+=09cpu_relax();
+=09stat(s, CMPXCHG_DOUBLE_FAIL);
+
+#ifdef SLUB_DEBUG_CMPXCHG
+=09printk(KERN_INFO "%s %s: cmpxchg double redo ", n, s->name);
+#endif
+
+=09return 0;
+}
+
 #ifdef CONFIG_SLUB_DEBUG
 /*
  * Determine a map of object in use on a page.
@@ -2600,6 +2635,12 @@ static int kmem_cache_open(struct kmem_c
 =09=09}
 =09}

+#ifdef CONFIG_CMPXCHG_DOUBLE
+=09if (system_has_cmpxchg_double() && (s->flags & SLAB_DEBUG_FLAGS) =3D=3D=
 0)
+=09=09/* Enable fast mode */
+=09=09s->flags |=3D __CMPXCHG_DOUBLE;
+#endif
+
 =09/*
 =09 * The larger the object size is, the more pages we want on the partial
 =09 * list to avoid pounding the page allocator excessively.
@@ -4252,8 +4293,10 @@ static ssize_t sanity_checks_store(struc
 =09=09=09=09const char *buf, size_t length)
 {
 =09s->flags &=3D ~SLAB_DEBUG_FREE;
-=09if (buf[0] =3D=3D '1')
+=09if (buf[0] =3D=3D '1') {
+=09=09s->flags &=3D ~__CMPXCHG_DOUBLE;
 =09=09s->flags |=3D SLAB_DEBUG_FREE;
+=09}
 =09return length;
 }
 SLAB_ATTR(sanity_checks);
@@ -4267,8 +4310,10 @@ static ssize_t trace_store(struct kmem_c
 =09=09=09=09=09=09=09size_t length)
 {
 =09s->flags &=3D ~SLAB_TRACE;
-=09if (buf[0] =3D=3D '1')
+=09if (buf[0] =3D=3D '1') {
+=09=09s->flags &=3D ~__CMPXCHG_DOUBLE;
 =09=09s->flags |=3D SLAB_TRACE;
+=09}
 =09return length;
 }
 SLAB_ATTR(trace);
@@ -4285,8 +4330,10 @@ static ssize_t red_zone_store(struct kme
 =09=09return -EBUSY;

 =09s->flags &=3D ~SLAB_RED_ZONE;
-=09if (buf[0] =3D=3D '1')
+=09if (buf[0] =3D=3D '1') {
+=09=09s->flags &=3D ~__CMPXCHG_DOUBLE;
 =09=09s->flags |=3D SLAB_RED_ZONE;
+=09}
 =09calculate_sizes(s, -1);
 =09return length;
 }
@@ -4304,8 +4351,10 @@ static ssize_t poison_store(struct kmem_
 =09=09return -EBUSY;

 =09s->flags &=3D ~SLAB_POISON;
-=09if (buf[0] =3D=3D '1')
+=09if (buf[0] =3D=3D '1') {
+=09=09s->flags &=3D ~__CMPXCHG_DOUBLE;
 =09=09s->flags |=3D SLAB_POISON;
+=09}
 =09calculate_sizes(s, -1);
 =09return length;
 }
@@ -4323,8 +4372,10 @@ static ssize_t store_user_store(struct k
 =09=09return -EBUSY;

 =09s->flags &=3D ~SLAB_STORE_USER;
-=09if (buf[0] =3D=3D '1')
+=09if (buf[0] =3D=3D '1') {
+=09=09s->flags &=3D ~__CMPXCHG_DOUBLE;
 =09=09s->flags |=3D SLAB_STORE_USER;
+=09}
 =09calculate_sizes(s, -1);
 =09return length;
 }
@@ -4497,6 +4548,8 @@ STAT_ATTR(DEACTIVATE_TO_HEAD, deactivate
 STAT_ATTR(DEACTIVATE_TO_TAIL, deactivate_to_tail);
 STAT_ATTR(DEACTIVATE_REMOTE_FREES, deactivate_remote_frees);
 STAT_ATTR(ORDER_FALLBACK, order_fallback);
+STAT_ATTR(CMPXCHG_DOUBLE_CPU_FAIL, cmpxchg_double_cpu_fail);
+STAT_ATTR(CMPXCHG_DOUBLE_FAIL, cmpxchg_double_fail);
 #endif

 static struct attribute *slab_attrs[] =3D {
@@ -4554,6 +4607,8 @@ static struct attribute *slab_attrs[] =3D
 =09&deactivate_to_tail_attr.attr,
 =09&deactivate_remote_frees_attr.attr,
 =09&order_fallback_attr.attr,
+=09&cmpxchg_double_fail_attr.attr,
+=09&cmpxchg_double_cpu_fail_attr.attr,
 #endif
 #ifdef CONFIG_FAILSLAB
 =09&failslab_attr.attr,
Index: linux-2.6/include/linux/slub_def.h
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- linux-2.6.orig/include/linux/slub_def.h=092011-05-31 11:50:01.762940481=
 -0500
+++ linux-2.6/include/linux/slub_def.h=092011-05-31 11:58:01.742937411 -050=
0
@@ -33,6 +33,7 @@ enum stat_item {
 =09DEACTIVATE_REMOTE_FREES,/* Slab contained remotely freed objects */
 =09ORDER_FALLBACK,=09=09/* Number of times fallback was necessary */
 =09CMPXCHG_DOUBLE_CPU_FAIL,/* Failure of this_cpu_cmpxchg_double */
+=09CMPXCHG_DOUBLE_FAIL,=09/* Number of times that cmpxchg double did not m=
atch */
 =09NR_SLUB_STAT_ITEMS };

 struct kmem_cache_cpu {
--531368966-1358618695-1306443737=:10790--
