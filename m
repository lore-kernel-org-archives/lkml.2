Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932091Ab1FAR0V (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 13:26:21 -0400
Received: from smtp104.prem.mail.ac4.yahoo.com ([76.13.13.43]:47795 "HELO
	smtp104.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1759307Ab1FAR0S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 13:26:18 -0400
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: xkvNADIVM1lGJx1zsGZLDRvjnViYA8T.oKdEJPTGyLREYJx
 8Qem1HThindsKt1nw7yXjDlROF5Dwm63R9RrzLUNTwaPzp10NcS35W5IMHoL
 mN08puCj8.ldzVMBmrvy_mzhtS0J8JU92fN0CrS3BGks1Ggu4c8jTXR1dyCj
 fJoN8qWGsSgj85W0GN98ir6cZoZZv.0JiPVj1nn_1lApWJ0rDasrirKRy5Sa
 aSY1Y_z_n7FGI9dhcn76XiAByRglv08pxCbF.xw_XeLG0gXNCcCcYqJ4RHBL
 LysPxp0I_jah2jlShoC3994rPwycWzWpZZsuSVwjvUTmWUDRKIw--
X-Yahoo-Newman-Property: ymail-3
Message-Id: <20110601172616.411533478@linux.com>
User-Agent: quilt/0.48-1
Date: Wed, 01 Jun 2011 12:25:51 -0500
From: Christoph Lameter <cl@linux.com>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: David Rientjes <rientjes@google.com>
Cc: Eric Dumazet <eric.dumazet@gmail.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>
Subject: [slubllv7 08/17] slub: Pass kmem_cache struct to lock and freeze slab
References: <20110601172543.437240675@linux.com>
Content-Disposition: inline; filename=pass_kmem_cache_to_lock_and_freeze
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We need more information about the slab for the cmpxchg implementation.

Signed-off-by: Christoph Lameter <cl@linux.com>
Acked-by: David Rientjes <rientjes@google.com>

---
 mm/slub.c |   15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

Index: linux-2.6/mm/slub.c
===================================================================
--- linux-2.6.orig/mm/slub.c	2011-05-31 10:14:03.852977349 -0500
+++ linux-2.6/mm/slub.c	2011-05-31 10:14:06.172977333 -0500
@@ -1457,8 +1457,8 @@ static inline void remove_partial(struct
  *
  * Must hold list_lock.
  */
-static inline int lock_and_freeze_slab(struct kmem_cache_node *n,
-							struct page *page)
+static inline int lock_and_freeze_slab(struct kmem_cache *s,
+		struct kmem_cache_node *n, struct page *page)
 {
 	if (slab_trylock(page)) {
 		remove_partial(n, page);
@@ -1470,7 +1470,8 @@ static inline int lock_and_freeze_slab(s
 /*
  * Try to allocate a partial slab from a specific node.
  */
-static struct page *get_partial_node(struct kmem_cache_node *n)
+static struct page *get_partial_node(struct kmem_cache *s,
+					struct kmem_cache_node *n)
 {
 	struct page *page;
 
@@ -1485,7 +1486,7 @@ static struct page *get_partial_node(str
 
 	spin_lock(&n->list_lock);
 	list_for_each_entry(page, &n->partial, lru)
-		if (lock_and_freeze_slab(n, page))
+		if (lock_and_freeze_slab(s, n, page))
 			goto out;
 	page = NULL;
 out:
@@ -1536,7 +1537,7 @@ static struct page *get_any_partial(stru
 
 		if (n && cpuset_zone_allowed_hardwall(zone, flags) &&
 				n->nr_partial > s->min_partial) {
-			page = get_partial_node(n);
+			page = get_partial_node(s, n);
 			if (page) {
 				put_mems_allowed();
 				return page;
@@ -1556,7 +1557,7 @@ static struct page *get_partial(struct k
 	struct page *page;
 	int searchnode = (node == NUMA_NO_NODE) ? numa_node_id() : node;
 
-	page = get_partial_node(get_node(s, searchnode));
+	page = get_partial_node(s, get_node(s, searchnode));
 	if (page || node != NUMA_NO_NODE)
 		return page;
 
@@ -2081,7 +2082,7 @@ static void __slab_free(struct kmem_cach
 {
 	void *prior;
 	void **object = (void *)x;
-	unsigned long flags;
+	unsigned long uninitialized_var(flags);
 
 	local_irq_save(flags);
 	slab_lock(page);

