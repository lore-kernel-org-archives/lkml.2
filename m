Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756819Ab1DOUuk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Apr 2011 16:50:40 -0400
Received: from smtp109.prem.mail.ac4.yahoo.com ([76.13.13.92]:25110 "HELO
	smtp109.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756761Ab1DOUrz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Apr 2011 16:47:55 -0400
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: zkaC0QwVM1k12XQnlHvWYtWxvbAFH.RpiKg4iKSlf7Pxkhz
 B39RtZBPebWZQd3FhbpcTV4XMkCP9cH9qVyqTVxyJkGNjB_XPcJwV3yi.p0p
 Wv5hJNd2TXSnOngPGHDhNjMBqQGxqQ36GQKZDdY84dVFSBWV2xtwqVacwjfo
 IK4n9kOenXwPAY0X0ZD8CBQ4iydmrs565qutw80_DQeRAFaI2wDw5Z_W7p.U
 iFQjivjZrZ4z9sTEcDzO8UZ7_LCLGhf6vk29nNNs_GD9iXOq2mPpk7RVXj9N
 yYIF0P91wpQSwC.TZmzkez1nPLachsPQ3yvkDGA3EqDToh5J9Y0hIAyMRWu8
 intNLZCtVXcvVdjWPv9SThSWR
X-Yahoo-Newman-Property: ymail-3
Message-Id: <20110415204753.595072920@linux.com>
User-Agent: quilt/0.48-1
Date: Fri, 15 Apr 2011 15:47:43 -0500
From: Christoph Lameter <cl@linux.com>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: David Rientjes <rientjes@google.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Eric Dumazet <eric.dumazet@gmail.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: linux-kernel@vger.kernel.org
Subject: [slubllv3 13/21] slub: Pass kmem_cache struct to lock and freeze slab
References: <20110415204730.326790555@linux.com>
Content-Disposition: inline; filename=pass_kmem_cache_to_lock_and_freeze
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We need more information about the slab for the cmpxchg implementation.

Signed-off-by: Christoph Lameter <cl@linux.com>

---
 mm/slub.c |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

Index: linux-2.6/mm/slub.c
===================================================================
--- linux-2.6.orig/mm/slub.c	2011-04-15 14:29:01.000000000 -0500
+++ linux-2.6/mm/slub.c	2011-04-15 14:29:35.000000000 -0500
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

