Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759208Ab1FAR1V (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 13:27:21 -0400
Received: from smtp107.prem.mail.ac4.yahoo.com ([76.13.13.46]:30923 "HELO
	smtp107.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S932108Ab1FAR0W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 13:26:22 -0400
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: bhGwA_0VM1kLsYLwJPyJrmpxcqaLhMYgl5Qz8a09mILQ2q_
 ENYT0fa6JYPefOAL7qouxKMlNkmxxf9lcW2x96CmmqQB7jm65FlKQpdgpFAS
 apfDkJMdqXSGfnVC9bulStTx0d8narj4jKrIC8uM1mbfiyEIbg1yxiiNhQLA
 mYO1AKWpcAya4pf1dDEvBIbjkN4z88jPaPlAGKkQWuPRV8rzRUPavGyvP2gL
 gu1v0wwmaAkXk6baf0JbeEoreSkO5Qnzc7rUDqJKrwHyGIMnU5BMUSvcuvKr
 Ggud3Emm5FjLeONdrCjmp01W88Mk_4gLCjVlO6bwC23NLzVfm
X-Yahoo-Newman-Property: ymail-3
Message-Id: <20110601172620.401153478@linux.com>
User-Agent: quilt/0.48-1
Date: Wed, 01 Jun 2011 12:25:58 -0500
From: Christoph Lameter <cl@linux.com>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: David Rientjes <rientjes@google.com>
Cc: Eric Dumazet <eric.dumazet@gmail.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>
Subject: [slubllv7 15/17] slub: fast release on full slab
References: <20110601172543.437240675@linux.com>
Content-Disposition: inline; filename=slab_alloc_fast_release
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make deactivation occur implicitly while checking out the current freelist.

This avoids one cmpxchg operation on a slab that is now fully in use.

Signed-off-by: Christoph Lameter <cl@linux.com>

---
 include/linux/slub_def.h |    1 +
 mm/slub.c                |   21 +++++++++++++++++++--
 2 files changed, 20 insertions(+), 2 deletions(-)

Index: linux-2.6/mm/slub.c
===================================================================
--- linux-2.6.orig/mm/slub.c	2011-05-31 14:27:17.792880073 -0500
+++ linux-2.6/mm/slub.c	2011-05-31 14:27:21.372880046 -0500
@@ -1977,9 +1977,21 @@ static void *__slab_alloc(struct kmem_ca
 		object = page->freelist;
 		counters = page->counters;
 		new.counters = counters;
-		new.inuse = page->objects;
 		VM_BUG_ON(!new.frozen);
 
+		/*
+		 * If there is no object left then we use this loop to
+		 * deactivate the slab which is simple since no objects
+		 * are left in the slab and therefore we do not need to
+		 * put the page back onto the partial list.
+		 *
+		 * If there are objects left then we retrieve them
+		 * and use them to refill the per cpu queue.
+		*/
+
+		new.inuse = page->objects;
+		new.frozen = object != NULL;
+
 	} while (!cmpxchg_double_slab(s, page,
 			object, counters,
 			NULL, new.counters,
@@ -1988,8 +2000,11 @@ static void *__slab_alloc(struct kmem_ca
 load_freelist:
 	VM_BUG_ON(!page->frozen);
 
-	if (unlikely(!object))
+	if (unlikely(!object)) {
+		c->page = NULL;
+		stat(s, DEACTIVATE_BYPASS);
 		goto new_slab;
+	}
 
 	stat(s, ALLOC_REFILL);
 
@@ -4684,6 +4699,7 @@ STAT_ATTR(DEACTIVATE_EMPTY, deactivate_e
 STAT_ATTR(DEACTIVATE_TO_HEAD, deactivate_to_head);
 STAT_ATTR(DEACTIVATE_TO_TAIL, deactivate_to_tail);
 STAT_ATTR(DEACTIVATE_REMOTE_FREES, deactivate_remote_frees);
+STAT_ATTR(DEACTIVATE_BYPASS, deactivate_bypass);
 STAT_ATTR(ORDER_FALLBACK, order_fallback);
 STAT_ATTR(CMPXCHG_DOUBLE_CPU_FAIL, cmpxchg_double_cpu_fail);
 STAT_ATTR(CMPXCHG_DOUBLE_FAIL, cmpxchg_double_fail);
@@ -4744,6 +4760,7 @@ static struct attribute *slab_attrs[] =
 	&deactivate_to_head_attr.attr,
 	&deactivate_to_tail_attr.attr,
 	&deactivate_remote_frees_attr.attr,
+	&deactivate_bypass_attr.attr,
 	&order_fallback_attr.attr,
 	&cmpxchg_double_fail_attr.attr,
 	&cmpxchg_double_cpu_fail_attr.attr,
Index: linux-2.6/include/linux/slub_def.h
===================================================================
--- linux-2.6.orig/include/linux/slub_def.h	2011-05-31 14:27:17.792880073 -0500
+++ linux-2.6/include/linux/slub_def.h	2011-05-31 14:27:21.382880050 -0500
@@ -32,6 +32,7 @@ enum stat_item {
 	DEACTIVATE_TO_HEAD,	/* Cpu slab was moved to the head of partials */
 	DEACTIVATE_TO_TAIL,	/* Cpu slab was moved to the tail of partials */
 	DEACTIVATE_REMOTE_FREES,/* Slab contained remotely freed objects */
+	DEACTIVATE_BYPASS,	/* Implicit deactivation */
 	ORDER_FALLBACK,		/* Number of times fallback was necessary */
 	CMPXCHG_DOUBLE_CPU_FAIL,/* Failure of this_cpu_cmpxchg_double */
 	CMPXCHG_DOUBLE_FAIL,	/* Number of times that cmpxchg double did not match */

