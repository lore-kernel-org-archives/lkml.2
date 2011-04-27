Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933213Ab1D0QJS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 12:09:18 -0400
Received: from cantor2.suse.de ([195.135.220.15]:34946 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933146Ab1D0QIW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Apr 2011 12:08:22 -0400
From: Mel Gorman <mgorman@suse.de>
To: Linux-MM <linux-mm@kvack.org>, Linux-Netdev <netdev@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, David Miller <davem@davemloft.net>,
        Neil Brown <neilb@suse.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Mel Gorman <mgorman@suse.de>
Subject: [PATCH 10/13] mm: Micro-optimise slab to avoid a function call
Date: Wed, 27 Apr 2011 17:08:08 +0100
Message-Id: <1303920491-25302-11-git-send-email-mgorman@suse.de>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1303920491-25302-1-git-send-email-mgorman@suse.de>
References: <1303920491-25302-1-git-send-email-mgorman@suse.de>
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
index 342c7c7..1504096 100644
--- a/mm/slab.c
+++ b/mm/slab.c
@@ -116,6 +116,8 @@
 #include	<linux/kmemcheck.h>
 #include	<linux/memory.h>
 
+#include	<net/sock.h>
+
 #include	<asm/cacheflush.h>
 #include	<asm/tlbflush.h>
 #include	<asm/page.h>
@@ -944,7 +946,7 @@ static void check_ac_pfmemalloc(struct kmem_cache *cachep,
 	ac->pfmemalloc = false;
 }
 
-static void *ac_get_obj(struct kmem_cache *cachep, struct array_cache *ac,
+static void *__ac_get_obj(struct kmem_cache *cachep, struct array_cache *ac,
 						gfp_t flags, bool force_refill)
 {
 	int i;
@@ -991,7 +993,20 @@ static void *ac_get_obj(struct kmem_cache *cachep, struct array_cache *ac,
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
@@ -1004,6 +1019,15 @@ static void ac_put_obj(struct kmem_cache *cachep, struct array_cache *ac,
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

