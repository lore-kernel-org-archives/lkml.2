Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756745Ab1EFSJi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 May 2011 14:09:38 -0400
Received: from smtp110.prem.mail.ac4.yahoo.com ([76.13.13.93]:23061 "HELO
	smtp110.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755910Ab1EFSHA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 May 2011 14:07:00 -0400
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: nrhmIV8VM1k.H2BaeHAhhdZoU.GrVpJ2TieMXICahwyPakc
 0XCiQESCmJAtYDaUDjZIEA_u8P426jfBccuDSnnyrR8VciW.CwhIwsFwU6TV
 CrIJ93WNsufkrpnYx2k6haqpTh97qic.FVqTgu0P1G61fqgk4R3OSyE3THeL
 VKd6waOXU21mB6JpVSOFYj1iIV_izxNJGh1N4PqdFQlMFyJJqAoD6njkTEZi
 SJeE7zY6FYCje9vSyFwOdgKhuAaBs0ruOhJ.pN2rAfIbJ.XlPs_9A7hCg7Tw
 vFC1jDW.VuXGemRfXC435dLjaMKwoJiHNZpcZ6j_oml3XJSb4uhkZNFzUhZA
 fVX8g93Bf6vJr_axmejT2dU6N
X-Yahoo-Newman-Property: ymail-3
Message-Id: <20110506180658.788426827@linux.com>
User-Agent: quilt/0.48-1
Date: Fri, 06 May 2011 13:05:49 -0500
From: Christoph Lameter <cl@linux.com>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: David Rientjes <rientjes@google.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Eric Dumazet <eric.dumazet@gmail.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: linux-kernel@vger.kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>
Subject: [slubllv4 08/16] slub: Pass kmem_cache struct to lock and freeze slab
References: <20110506180541.990069206@linux.com>
Content-Disposition: inline; filename=pass_kmem_cache_to_lock_and_freeze
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We need more information about the slab for the cmpxchg implementation.

Signed-off-by: Christoph Lameter <cl@linux.com>

---
 mm/slub.c |   13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

Index: linux-2.6/mm/slub.c
===================================================================
--- linux-2.6.orig/mm/slub.c	2011-04-28 15:53:45.000000000 -0500
+++ linux-2.6/mm/slub.c	2011-04-28 15:53:50.000000000 -0500
@@ -1424,8 +1424,8 @@ static inline void remove_partial(struct
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
@@ -1437,7 +1437,8 @@ static inline int lock_and_freeze_slab(s
 /*
  * Try to allocate a partial slab from a specific node.
  */
-static struct page *get_partial_node(struct kmem_cache_node *n)
+static struct page *get_partial_node(struct kmem_cache *s,
+					struct kmem_cache_node *n)
 {
 	struct page *page;
 
@@ -1452,7 +1453,7 @@ static struct page *get_partial_node(str
 
 	spin_lock(&n->list_lock);
 	list_for_each_entry(page, &n->partial, lru)
-		if (lock_and_freeze_slab(n, page))
+		if (lock_and_freeze_slab(s, n, page))
 			goto out;
 	page = NULL;
 out:
@@ -1503,7 +1504,7 @@ static struct page *get_any_partial(stru
 
 		if (n && cpuset_zone_allowed_hardwall(zone, flags) &&
 				n->nr_partial > s->min_partial) {
-			page = get_partial_node(n);
+			page = get_partial_node(s, n);
 			if (page) {
 				put_mems_allowed();
 				return page;
@@ -1523,7 +1524,7 @@ static struct page *get_partial(struct k
 	struct page *page;
 	int searchnode = (node == NUMA_NO_NODE) ? numa_node_id() : node;
 
-	page = get_partial_node(get_node(s, searchnode));
+	page = get_partial_node(s, get_node(s, searchnode));
 	if (page || node != NUMA_NO_NODE)
 		return page;
 

