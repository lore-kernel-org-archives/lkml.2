Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758265Ab1EZSSY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 14:18:24 -0400
Received: from smtp109.prem.mail.ac4.yahoo.com ([76.13.13.92]:31511 "HELO
	smtp109.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1758237Ab1EZSPH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 14:15:07 -0400
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: vCwgTTIVM1nq6StgcCKBLIWb5mTPQNRhkfNfY9z0HSmW1ac
 ZNYCp0XsRFoVdYUAFucvkmFONmTW_zkG9_4o_cFSx_jjSUUY5w694vbQWKks
 qepjIBs9gfcMkUhbsZpQampAYJuoD2C5KHbLunQzLezbfX0vrsMLt3piHCpS
 defv2oIM.V6ynjCw8AXDUCWDOosGJIuyMS.u9_ayCNXQAK09mwHw3uAFe7HW
 dxn6rYDnf2t1w2NnfQ5pQPeDP3vvnaqneAYXGFUAyDyMKqxwn2PnCY.WgVlh
 arvwomvvyIwTKqSdeaUJQJscPi3aShzaI2EtjLE9IFrqqwNYA0j5yzE4PrTK
 CtCmo1yNoEeU3Q3xY8PMa8miS
X-Yahoo-Newman-Property: ymail-3
Message-Id: <20110526181504.863758450@linux.com>
User-Agent: quilt/0.48-1
Date: Thu, 26 May 2011 13:14:48 -0500
From: Christoph Lameter <cl@linux.com>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: David Rientjes <rientjes@google.com>
Cc: Eric Dumazet <eric.dumazet@gmail.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>
Subject: [slubllv6 06/17] slub: Add cmpxchg_double_slab()
References: <20110526181442.789868308@linux.com>
Content-Disposition: inline; filename=cmpxchg_double_slab
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a function that operates on the second doubleword in the page struct
and manipulates the object counters, the freelist and the frozen attribute.

Signed-off-by: Christoph Lameter <cl@linux.com>

---
 include/linux/slub_def.h |    1 +
 mm/slub.c                |   45 +++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 46 insertions(+)

Index: linux-2.6/mm/slub.c
===================================================================
--- linux-2.6.orig/mm/slub.c	2011-05-16 11:46:33.591463082 -0500
+++ linux-2.6/mm/slub.c	2011-05-16 11:46:51.181463060 -0500
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
 
@@ -354,6 +358,37 @@ static void get_map(struct kmem_cache *s
 		set_bit(slab_index(p, s, addr), map);
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
 /*
  * Debug settings:
  */
@@ -2596,6 +2631,12 @@ static int kmem_cache_open(struct kmem_c
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
@@ -4493,6 +4534,8 @@ STAT_ATTR(DEACTIVATE_TO_HEAD, deactivate
 STAT_ATTR(DEACTIVATE_TO_TAIL, deactivate_to_tail);
 STAT_ATTR(DEACTIVATE_REMOTE_FREES, deactivate_remote_frees);
 STAT_ATTR(ORDER_FALLBACK, order_fallback);
+STAT_ATTR(CMPXCHG_DOUBLE_CPU_FAIL, cmpxchg_double_cpu_fail);
+STAT_ATTR(CMPXCHG_DOUBLE_FAIL, cmpxchg_double_fail);
 #endif
 
 static struct attribute *slab_attrs[] = {
@@ -4550,6 +4593,8 @@ static struct attribute *slab_attrs[] =
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
--- linux-2.6.orig/include/linux/slub_def.h	2011-05-16 11:40:35.371463499 -0500
+++ linux-2.6/include/linux/slub_def.h	2011-05-16 11:46:51.181463060 -0500
@@ -33,6 +33,7 @@ enum stat_item {
 	DEACTIVATE_REMOTE_FREES,/* Slab contained remotely freed objects */
 	ORDER_FALLBACK,		/* Number of times fallback was necessary */
 	CMPXCHG_DOUBLE_CPU_FAIL,/* Failure of this_cpu_cmpxchg_double */
+	CMPXCHG_DOUBLE_FAIL,	/* Number of times that cmpxchg double did not match */
 	NR_SLUB_STAT_ITEMS };
 
 struct kmem_cache_cpu {

