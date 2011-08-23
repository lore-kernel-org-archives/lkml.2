Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755258Ab1HWI7j (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Aug 2011 04:59:39 -0400
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:43797 "EHLO
	ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754957Ab1HWI4z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Aug 2011 04:56:55 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AlsEAN5pU055LIxDgWdsb2JhbABBmQ2PGhUBARYmJYFAAQEFJy8jEAgYMTkDGxm/SYZIBKQl
From: Dave Chinner <david@fromorbit.com>
To: linux-kernel@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, khlebnikov@openvz.org
Subject: [PATCH 07/13] Use atomic-long operations instead of looping around cmpxchg().
Date: Tue, 23 Aug 2011 18:56:20 +1000
Message-Id: <1314089786-20535-8-git-send-email-david@fromorbit.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1314089786-20535-1-git-send-email-david@fromorbit.com>
References: <1314089786-20535-1-git-send-email-david@fromorbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Konstantin Khlebnikov <khlebnikov@openvz.org>

Signed-off-by: Konstantin Khlebnikov <khlebnikov@openvz.org>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
---
 include/linux/fs.h       |    2 +-
 include/linux/shrinker.h |    2 +-
 mm/vmscan.c              |   17 +++++++----------
 3 files changed, 9 insertions(+), 12 deletions(-)

diff --git a/include/linux/fs.h b/include/linux/fs.h
index 958c025..2651059 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -394,8 +394,8 @@ struct inodes_stat_t {
 #include <linux/semaphore.h>
 #include <linux/fiemap.h>
 #include <linux/rculist_bl.h>
-#include <linux/shrinker.h>
 #include <linux/atomic.h>
+#include <linux/shrinker.h>
 
 #include <asm/byteorder.h>
 
diff --git a/include/linux/shrinker.h b/include/linux/shrinker.h
index ab6c572..02b5b6b 100644
--- a/include/linux/shrinker.h
+++ b/include/linux/shrinker.h
@@ -43,7 +43,7 @@ struct shrinker {
 
 	/* These are for internal use */
 	struct list_head list;
-	long nr;	/* objs pending delete */
+	atomic_long_t nr_pending;	/* objs pending delete */
 };
 
 #define DEFAULT_SEEKS 2 /* A good number if you don't know better. */
diff --git a/mm/vmscan.c b/mm/vmscan.c
index e32ce2d..534ed34 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -184,7 +184,7 @@ static unsigned long zone_nr_lru_pages(struct zone *zone,
  */
 void register_shrinker(struct shrinker *shrinker)
 {
-	shrinker->nr = 0;
+	atomic_long_set(&shrinker->nr_pending, 0);
 	down_write(&shrinker_rwsem);
 	list_add_tail(&shrinker->list, &shrinker_list);
 	up_write(&shrinker_rwsem);
@@ -252,9 +252,7 @@ unsigned long shrink_slab(struct shrink_control *sc,
 		 * and zero it so that other concurrent shrinker invocations
 		 * don't also do this scanning work.
 		 */
-		do {
-			nr = shrinker->nr;
-		} while (cmpxchg(&shrinker->nr, nr, 0) != nr);
+		nr = atomic_long_xchg(&shrinker->nr_pending, 0);
 
 		total_scan = nr;
 		max_pass = shrinker->count_objects(shrinker, sc);
@@ -318,12 +316,11 @@ unsigned long shrink_slab(struct shrink_control *sc,
 		 * manner that handles concurrent updates. If we exhausted the
 		 * scan, there is no need to do an update.
 		 */
-		do {
-			nr = shrinker->nr;
-			new_nr = total_scan + nr;
-			if (total_scan <= 0)
-				break;
-		} while (cmpxchg(&shrinker->nr, nr, new_nr) != nr);
+		if (total_scan > 0)
+			new_nr = atomic_long_add_return(total_scan,
+							&shrinker->nr_pending);
+		else
+			new_nr = atomic_long_read(&shrinker->nr_pending);
 
 		trace_mm_shrink_slab_end(shrinker, freed, nr, new_nr);
 	}
-- 
1.7.5.4

