Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757016Ab1DOUw4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Apr 2011 16:52:56 -0400
Received: from smtp102.prem.mail.ac4.yahoo.com ([76.13.13.41]:30200 "HELO
	smtp102.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755403Ab1DOUrt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Apr 2011 16:47:49 -0400
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: n49c.vcVM1ngm68faaUdYKct6bwYEmo24Pdu1VKnAJRhnPV
 ZvpMeWE2ohGjwAoHS8AwSNBbCfmy1AqdBuAP9iihJluKV8zpNsB5nN7v6zTt
 XhMN6BBP02WXzUBtoAGfbR9nNmmOpuZyMke0QGKF.Kk59drclBE4nZgcEvxJ
 cI_gI8sj9fMa_FzerZf40h8GBMHdSp2BblmAmSpDBwRTUEdLrZHSviXhB1Ui
 8d0ONCqjDaYT09Zes7vJb74RRfDMRihyayamviVZdFNOaDMmNfeFBN95XWy0
 izN9JmrWZcaWBENmD4FojCpdjmYXA79wWOh_KcH7xPMBLGbPMb5iaSYgGR.2
 3EYZofEmm6fvVwPQSE47.GiGY
X-Yahoo-Newman-Property: ymail-3
Message-Id: <20110415204747.802064570@linux.com>
User-Agent: quilt/0.48-1
Date: Fri, 15 Apr 2011 15:47:33 -0500
From: Christoph Lameter <cl@linux.com>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: David Rientjes <rientjes@google.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Eric Dumazet <eric.dumazet@gmail.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: linux-kernel@vger.kernel.org
Subject: [slubllv3 03/21] slub: Eliminate repeated use of c->page through a new page variable
References: <20110415204730.326790555@linux.com>
Content-Disposition: inline; filename=avoid_c_page
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

__slab_alloc is full of "c->page" repeats. Lets just use one local variable
named "page" for this. Also avoids the need to a have another variable
called "new".

Signed-off-by: Christoph Lameter <cl@linux.com>

---
 mm/slub.c |   41 ++++++++++++++++++++++-------------------
 1 file changed, 22 insertions(+), 19 deletions(-)

Index: linux-2.6/mm/slub.c
===================================================================
--- linux-2.6.orig/mm/slub.c	2011-03-30 14:30:24.000000000 -0500
+++ linux-2.6/mm/slub.c	2011-03-30 14:30:51.000000000 -0500
@@ -1790,7 +1790,7 @@ static void *__slab_alloc(struct kmem_ca
 			  unsigned long addr, struct kmem_cache_cpu *c)
 {
 	void **object;
-	struct page *new;
+	struct page *page;
 #ifdef CONFIG_CMPXCHG_LOCAL
 	unsigned long flags;
 
@@ -1808,28 +1808,30 @@ static void *__slab_alloc(struct kmem_ca
 	/* We handle __GFP_ZERO in the caller */
 	gfpflags &= ~__GFP_ZERO;
 
-	if (!c->page)
+	page = c->page;
+	if (!page)
 		goto new_slab;
 
-	slab_lock(c->page);
+	slab_lock(page);
 	if (unlikely(!node_match(c, node)))
 		goto another_slab;
 
 	stat(s, ALLOC_REFILL);
 
 load_freelist:
-	object = c->page->freelist;
+	object = page->freelist;
 	if (unlikely(!object))
 		goto another_slab;
 	if (kmem_cache_debug(s))
 		goto debug;
 
 	c->freelist = get_freepointer(s, object);
-	c->page->inuse = c->page->objects;
-	c->page->freelist = NULL;
-	c->node = page_to_nid(c->page);
+	page->inuse = page->objects;
+	page->freelist = NULL;
+	c->node = page_to_nid(page);
+
 unlock_out:
-	slab_unlock(c->page);
+	slab_unlock(page);
 #ifdef CONFIG_CMPXCHG_LOCAL
 	c->tid = next_tid(c->tid);
 	local_irq_restore(flags);
@@ -1841,9 +1843,9 @@ another_slab:
 	deactivate_slab(s, c);
 
 new_slab:
-	new = get_partial(s, gfpflags, node);
-	if (new) {
-		c->page = new;
+	page = get_partial(s, gfpflags, node);
+	if (page) {
+		c->page = page;
 		stat(s, ALLOC_FROM_PARTIAL);
 		goto load_freelist;
 	}
@@ -1852,19 +1854,20 @@ new_slab:
 	if (gfpflags & __GFP_WAIT)
 		local_irq_enable();
 
-	new = new_slab(s, gfpflags, node);
+	page = new_slab(s, gfpflags, node);
 
 	if (gfpflags & __GFP_WAIT)
 		local_irq_disable();
 
-	if (new) {
+	if (page) {
 		c = __this_cpu_ptr(s->cpu_slab);
 		stat(s, ALLOC_SLAB);
 		if (c->page)
 			flush_slab(s, c);
-		slab_lock(new);
-		__SetPageSlubFrozen(new);
-		c->page = new;
+
+		slab_lock(page);
+		__SetPageSlubFrozen(page);
+		c->page = page;
 		goto load_freelist;
 	}
 	if (!(gfpflags & __GFP_NOWARN) && printk_ratelimit())
@@ -1874,11 +1877,11 @@ new_slab:
 #endif
 	return NULL;
 debug:
-	if (!alloc_debug_processing(s, c->page, object, addr))
+	if (!alloc_debug_processing(s, page, object, addr))
 		goto another_slab;
 
-	c->page->inuse++;
-	c->page->freelist = get_freepointer(s, object);
+	page->inuse++;
+	page->freelist = get_freepointer(s, object);
 	c->node = NUMA_NO_NODE;
 	goto unlock_out;
 }

