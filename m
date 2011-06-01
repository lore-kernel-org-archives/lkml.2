Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759346Ab1FAR2t (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 13:28:49 -0400
Received: from smtp109.prem.mail.ac4.yahoo.com ([76.13.13.92]:28797 "HELO
	smtp109.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1759147Ab1FAR0R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 13:26:17 -0400
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: q7VZreoVM1mzsb02TnYrjiHd81OWm1J.NI4D1m2w6cVY7Dg
 UzhvsIY_451EMsvVlhWiw4WGIbzs_24TV.faGzThHykx_ufDqX4Q3fcfnWn.
 OUydc4if.Js2BWwaHDM0ymmtH3mrRGgxszBWhnGJTEmv9042m1cmWFgnNTW3
 zMG1JTlLiSlLUP9NijAwUkGUOtMCZ4AJjDQinsfITsdjrMBF4zE3NqlJ9sVD
 fVREXimO5AziOaBCd46tY5FosRJpx4NhRhGJCqCrGR8e5nSmrToA.XJ39lch
 jPrj72PbULI1syQsNqyX0tW8DqSdoyKYrfWcPsVjRYJOoFzjc
X-Yahoo-Newman-Property: ymail-3
Message-Id: <20110601172615.286693377@linux.com>
User-Agent: quilt/0.48-1
Date: Wed, 01 Jun 2011 12:25:49 -0500
From: Christoph Lameter <cl@linux.com>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: David Rientjes <rientjes@google.com>
Cc: Eric Dumazet <eric.dumazet@gmail.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>
Subject: [slubllv7 06/17] slub: Add cmpxchg_double_slab()
References: <20110601172543.437240675@linux.com>
Content-Disposition: inline; filename=cmpxchg_double_slab
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a function that operates on the second doubleword in the page struct
and manipulates the object counters, the freelist and the frozen attribute.

Signed-off-by: Christoph Lameter <cl@linux.com>

---
 include/linux/slub_def.h |    1 
 mm/slub.c                |   65 +++++++++++++++++++++++++++++++++++++++++++----
 2 files changed, 61 insertions(+), 5 deletions(-)

Index: linux-2.6/mm/slub.c
===================================================================
--- linux-2.6.orig/mm/slub.c	2011-05-31 11:57:59.622937422 -0500
+++ linux-2.6/mm/slub.c	2011-05-31 12:03:16.652935392 -0500
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
 #define __OBJECT_POISON		0x80000000UL /* Poison object */
+#define __CMPXCHG_DOUBLE	0x40000000UL /* Use cmpxchg_double */
 
 static int kmem_size = sizeof(struct kmem_cache);
 
@@ -338,6 +342,37 @@ static inline int oo_objects(struct kmem
 	return x.x & OO_MASK;
 }
 
+static inline bool cmpxchg_double_slab(struct kmem_cache *s, struct page *page,
+		void *freelist_old, unsigned long counters_old,
+		void *freelist_new, unsigned long counters_new,
+		const char *n)
+{
+#ifdef CONFIG_CMPXCHG_DOUBLE
+	if (s->flags & __CMPXCHG_DOUBLE) {
+		if (cmpxchg_double(&page->freelist,
+			freelist_old, counters_old,
+			freelist_new, counters_new))
+		return 1;
+	} else
+#endif
+	{
+		if (page->freelist == freelist_old && page->counters == counters_old) {
+			page->freelist = freelist_new;
+			page->counters = counters_new;
+			return 1;
+		}
+	}
+
+	cpu_relax();
+	stat(s, CMPXCHG_DOUBLE_FAIL);
+
+#ifdef SLUB_DEBUG_CMPXCHG
+	printk(KERN_INFO "%s %s: cmpxchg double redo ", n, s->name);
+#endif
+
+	return 0;
+}
+
 #ifdef CONFIG_SLUB_DEBUG
 /*
  * Determine a map of object in use on a page.
@@ -2600,6 +2635,12 @@ static int kmem_cache_open(struct kmem_c
 		}
 	}
 
+#ifdef CONFIG_CMPXCHG_DOUBLE
+	if (system_has_cmpxchg_double() && (s->flags & SLAB_DEBUG_FLAGS) == 0)
+		/* Enable fast mode */
+		s->flags |= __CMPXCHG_DOUBLE;
+#endif
+
 	/*
 	 * The larger the object size is, the more pages we want on the partial
 	 * list to avoid pounding the page allocator excessively.
@@ -4252,8 +4293,10 @@ static ssize_t sanity_checks_store(struc
 				const char *buf, size_t length)
 {
 	s->flags &= ~SLAB_DEBUG_FREE;
-	if (buf[0] == '1')
+	if (buf[0] == '1') {
+		s->flags &= ~__CMPXCHG_DOUBLE;
 		s->flags |= SLAB_DEBUG_FREE;
+	}
 	return length;
 }
 SLAB_ATTR(sanity_checks);
@@ -4267,8 +4310,10 @@ static ssize_t trace_store(struct kmem_c
 							size_t length)
 {
 	s->flags &= ~SLAB_TRACE;
-	if (buf[0] == '1')
+	if (buf[0] == '1') {
+		s->flags &= ~__CMPXCHG_DOUBLE;
 		s->flags |= SLAB_TRACE;
+	}
 	return length;
 }
 SLAB_ATTR(trace);
@@ -4285,8 +4330,10 @@ static ssize_t red_zone_store(struct kme
 		return -EBUSY;
 
 	s->flags &= ~SLAB_RED_ZONE;
-	if (buf[0] == '1')
+	if (buf[0] == '1') {
+		s->flags &= ~__CMPXCHG_DOUBLE;
 		s->flags |= SLAB_RED_ZONE;
+	}
 	calculate_sizes(s, -1);
 	return length;
 }
@@ -4304,8 +4351,10 @@ static ssize_t poison_store(struct kmem_
 		return -EBUSY;
 
 	s->flags &= ~SLAB_POISON;
-	if (buf[0] == '1')
+	if (buf[0] == '1') {
+		s->flags &= ~__CMPXCHG_DOUBLE;
 		s->flags |= SLAB_POISON;
+	}
 	calculate_sizes(s, -1);
 	return length;
 }
@@ -4323,8 +4372,10 @@ static ssize_t store_user_store(struct k
 		return -EBUSY;
 
 	s->flags &= ~SLAB_STORE_USER;
-	if (buf[0] == '1')
+	if (buf[0] == '1') {
+		s->flags &= ~__CMPXCHG_DOUBLE;
 		s->flags |= SLAB_STORE_USER;
+	}
 	calculate_sizes(s, -1);
 	return length;
 }
@@ -4497,6 +4548,8 @@ STAT_ATTR(DEACTIVATE_TO_HEAD, deactivate
 STAT_ATTR(DEACTIVATE_TO_TAIL, deactivate_to_tail);
 STAT_ATTR(DEACTIVATE_REMOTE_FREES, deactivate_remote_frees);
 STAT_ATTR(ORDER_FALLBACK, order_fallback);
+STAT_ATTR(CMPXCHG_DOUBLE_CPU_FAIL, cmpxchg_double_cpu_fail);
+STAT_ATTR(CMPXCHG_DOUBLE_FAIL, cmpxchg_double_fail);
 #endif
 
 static struct attribute *slab_attrs[] = {
@@ -4554,6 +4607,8 @@ static struct attribute *slab_attrs[] =
 	&deactivate_to_tail_attr.attr,
 	&deactivate_remote_frees_attr.attr,
 	&order_fallback_attr.attr,
+	&cmpxchg_double_fail_attr.attr,
+	&cmpxchg_double_cpu_fail_attr.attr,
 #endif
 #ifdef CONFIG_FAILSLAB
 	&failslab_attr.attr,
Index: linux-2.6/include/linux/slub_def.h
===================================================================
--- linux-2.6.orig/include/linux/slub_def.h	2011-05-31 11:50:01.762940481 -0500
+++ linux-2.6/include/linux/slub_def.h	2011-05-31 11:58:01.742937411 -0500
@@ -33,6 +33,7 @@ enum stat_item {
 	DEACTIVATE_REMOTE_FREES,/* Slab contained remotely freed objects */
 	ORDER_FALLBACK,		/* Number of times fallback was necessary */
 	CMPXCHG_DOUBLE_CPU_FAIL,/* Failure of this_cpu_cmpxchg_double */
+	CMPXCHG_DOUBLE_FAIL,	/* Number of times that cmpxchg double did not match */
 	NR_SLUB_STAT_ITEMS };
 
 struct kmem_cache_cpu {

