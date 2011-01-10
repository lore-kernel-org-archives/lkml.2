Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754331Ab1AJSLv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jan 2011 13:11:51 -0500
Received: from service87.mimecast.com ([94.185.240.25]:37185 "HELO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751908Ab1AJSLu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jan 2011 13:11:50 -0500
Subject: [PATCH] kmemleak: Reduce verbosity when memory allocation fails
To: linux-kernel@vger.kernel.org
From: Catalin Marinas <catalin.marinas@arm.com>
Cc: Toralf =?utf-8?q?F=C3=B6rster?= <toralf.foerster@gmx.de>,
        Pekka Enberg <penberg@cs.helsinki.fi>, "Ted Ts'o" <tytso@mit.edu>,
        David Rientjes <rientjes@google.com>
Date: Mon, 10 Jan 2011 18:11:33 +0000
Message-ID: <20110110181133.14995.12364.stgit@e102109-lin.cambridge.arm.com>
User-Agent: StGit/0.15-103-g0e84
MIME-Version: 1.0
X-OriginalArrivalTime: 10 Jan 2011 18:11:44.0346 (UTC) FILETIME=[D68E7BA0:01CBB0F1]
X-MC-Unique: 111011018114700401
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch changes the kmemleak verbosity to avoid dumping the stack
trace when memory allocation for the kmemleak internal metadata fails.
It also passes __GFP_NOWARN to the slab allocator.

Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Reported-by: Toralf Förster <toralf.foerster@gmx.de>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: David Rientjes <rientjes@google.com>
Cc: Ted Ts'o <tytso@mit.edu>
---
 mm/kmemleak.c |   12 +++++++-----
 1 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/mm/kmemleak.c b/mm/kmemleak.c
index bd9bc21..eee8e31 100644
--- a/mm/kmemleak.c
+++ b/mm/kmemleak.c
@@ -113,7 +113,8 @@
 #define BYTES_PER_POINTER	sizeof(void *)
 
 /* GFP bitmask for kmemleak internal allocations */
-#define GFP_KMEMLEAK_MASK	(GFP_KERNEL | GFP_ATOMIC)
+#define gfp_kmemleak_mask(gfp)	((gfp) & (GFP_KERNEL | GFP_ATOMIC) | \
+				 __GFP_NOWARN)
 
 /* scanning area inside a memory block */
 struct kmemleak_scan_area {
@@ -511,9 +512,10 @@ static struct kmemleak_object *create_object(unsigned long ptr, size_t size,
 	struct kmemleak_object *object;
 	struct prio_tree_node *node;
 
-	object = kmem_cache_alloc(object_cache, gfp & GFP_KMEMLEAK_MASK);
+	object = kmem_cache_alloc(object_cache, gfp_kmemleak_mask(gfp));
 	if (!object) {
-		kmemleak_stop("Cannot allocate a kmemleak_object structure\n");
+		pr_warning("Cannot allocate a kmemleak_object structure\n");
+		kmemleak_disable();
 		return NULL;
 	}
 
@@ -734,9 +736,9 @@ static void add_scan_area(unsigned long ptr, size_t size, gfp_t gfp)
 		return;
 	}
 
-	area = kmem_cache_alloc(scan_area_cache, gfp & GFP_KMEMLEAK_MASK);
+	area = kmem_cache_alloc(scan_area_cache, gfp_kmemleak_mask(gfp));
 	if (!area) {
-		kmemleak_warn("Cannot allocate a scan area\n");
+		pr_warning("Cannot allocate a scan area\n");
 		goto out;
 	}
 


