Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932159Ab1HVKSF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Aug 2011 06:18:05 -0400
Received: from mailhub.sw.ru ([195.214.232.25]:31608 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756775Ab1HVKRk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Aug 2011 06:17:40 -0400
Subject: [PATCH 2/2] vmscan: use atomic-long for shrinker batching
To: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>
From: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: linux-kernel@vger.kernel.org
Date: Mon, 22 Aug 2011 14:17:27 +0300
Message-ID: <20110822101727.19462.55289.stgit@zurg>
In-Reply-To: <20110822101721.19462.63082.stgit@zurg>
References: <20110822101721.19462.63082.stgit@zurg>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use atomic-long operations instead of looping around cmpxchg().

Signed-off-by: Konstantin Khlebnikov <khlebnikov@openvz.org>
---
 include/linux/shrinker.h |    2 +-
 mm/vmscan.c              |   17 +++++++----------
 2 files changed, 8 insertions(+), 11 deletions(-)

diff --git a/include/linux/shrinker.h b/include/linux/shrinker.h
index 790651b..ac6b8ee 100644
--- a/include/linux/shrinker.h
+++ b/include/linux/shrinker.h
@@ -34,7 +34,7 @@ struct shrinker {
 
 	/* These are for internal use */
 	struct list_head list;
-	long nr;	/* objs pending delete */
+	atomic_long_t nr_in_batch; /* objs pending delete */
 };
 #define DEFAULT_SEEKS 2 /* A good number if you don't know better. */
 extern void register_shrinker(struct shrinker *);
diff --git a/mm/vmscan.c b/mm/vmscan.c
index f174561..e31c3e2 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -184,7 +184,7 @@ static unsigned long zone_nr_lru_pages(struct zone *zone,
  */
 void register_shrinker(struct shrinker *shrinker)
 {
-	shrinker->nr = 0;
+	atomic_long_set(&shrinker->nr_in_batch, 0);
 	down_write(&shrinker_rwsem);
 	list_add_tail(&shrinker->list, &shrinker_list);
 	up_write(&shrinker_rwsem);
@@ -265,9 +265,7 @@ unsigned long shrink_slab(struct shrink_control *shrink,
 		 * and zero it so that other concurrent shrinker invocations
 		 * don't also do this scanning work.
 		 */
-		do {
-			nr = shrinker->nr;
-		} while (cmpxchg(&shrinker->nr, nr, 0) != nr);
+		nr = atomic_long_xchg(&shrinker->nr_in_batch, 0);
 
 		total_scan = nr;
 		delta = (4 * nr_pages_scanned) / shrinker->seeks;
@@ -329,12 +327,11 @@ unsigned long shrink_slab(struct shrink_control *shrink,
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
+					&shrinker->nr_in_batch);
+		else
+			new_nr = atomic_long_read(&shrinker->nr_in_batch);
 
 		trace_mm_shrink_slab_end(shrinker, shrink_ret, nr, new_nr);
 	}

