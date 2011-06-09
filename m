Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757142Ab1FIIEf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jun 2011 04:04:35 -0400
Received: from cantor.suse.de ([195.135.220.2]:35156 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754661Ab1FIIDH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jun 2011 04:03:07 -0400
From: Mel Gorman <mgorman@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linux-MM <linux-mm@kvack.org>, Linux-Netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        David Miller <davem@davemloft.net>, Neil Brown <neilb@suse.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Mel Gorman <mgorman@suse.de>
Subject: [PATCH 11/14] mm: Micro-optimise slab to avoid a function call
Date: Thu,  9 Jun 2011 09:02:50 +0100
Message-Id: <1307606573-24704-12-git-send-email-mgorman@suse.de>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1307606573-24704-1-git-send-email-mgorman@suse.de>
References: <1307606573-24704-1-git-send-email-mgorman@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Getting and putting objects in SLAB currently requires a function call
but the bulk of the work is related to PFMEMALLOC reserves which are
only consumed when network-backed storage is critical. Use an inline
function to determine if the function call is required.

Signed-off-by: Mel Gorman <mgorman@suse.de>
---
 mm/slab.c |   28 ++++++++++++++++++++++++++--
 1 files changed, 26 insertions(+), 2 deletions(-)

diff --git a/mm/slab.c b/mm/slab.c
index 708da2f..3f49768 100644
--- a/mm/slab.c
+++ b/mm/slab.c
@@ -117,6 +117,8 @@
 #include	<linux/memory.h>
 #include	<linux/prefetch.h>
 
+#include	<net/sock.h>
+
 #include	<asm/cacheflush.h>
 #include	<asm/tlbflush.h>
 #include	<asm/page.h>
@@ -945,7 +947,7 @@ static void check_ac_pfmemalloc(struct kmem_cache *cachep,
 	ac->pfmemalloc = false;
 }
 
-static void *ac_get_obj(struct kmem_cache *cachep, struct array_cache *ac,
+static void *__ac_get_obj(struct kmem_cache *cachep, struct array_cache *ac,
 						gfp_t flags, bool force_refill)
 {
 	int i;
@@ -992,7 +994,20 @@ static void *ac_get_obj(struct kmem_cache *cachep, struct array_cache *ac,
 	return objp;
 }
 
-static void ac_put_obj(struct kmem_cache *cachep, struct array_cache *ac,
+static inline void *ac_get_obj(struct kmem_cache *cachep,
+			struct array_cache *ac, gfp_t flags, bool force_refill)
+{
+	void *objp;
+
+	if (unlikely(sk_memalloc_socks()))
+		objp = __ac_get_obj(cachep, ac, flags, force_refill);
+	else
+		objp = ac->entry[--ac->avail];
+
+	return objp;
+}
+
+static void *__ac_put_obj(struct kmem_cache *cachep, struct array_cache *ac,
 								void *objp)
 {
 	struct slab *slabp;
@@ -1005,6 +1020,15 @@ static void ac_put_obj(struct kmem_cache *cachep, struct array_cache *ac,
 			set_obj_pfmemalloc(&objp);
 	}
 
+	return objp;
+}
+
+static inline void ac_put_obj(struct kmem_cache *cachep, struct array_cache *ac,
+								void *objp)
+{
+	if (unlikely(sk_memalloc_socks()))
+		objp = __ac_put_obj(cachep, ac, objp);
+
 	ac->entry[ac->avail++] = objp;
 }
 
-- 
1.7.3.4

