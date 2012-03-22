Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031221Ab2CVV42 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2012 17:56:28 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:57572 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031205Ab2CVV4W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2012 17:56:22 -0400
Subject: [PATCH v6 1/7] mm/memcg: scanning_global_lru means mem_cgroup_disabled
To: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
From: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: Hugh Dickins <hughd@google.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Glauber Costa <glommer@parallels.com>
Date: Fri, 23 Mar 2012 01:56:16 +0400
Message-ID: <20120322215616.27814.40563.stgit@zurg>
In-Reply-To: <20120322214944.27814.42039.stgit@zurg>
References: <20120322214944.27814.42039.stgit@zurg>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hugh Dickins <hughd@google.com>

Although one has to admire the skill with which it has been concealed,
scanning_global_lru(mz) is actually just an interesting way to test
mem_cgroup_disabled().  Too many developer hours have been wasted on
confusing it with global_reclaim(): just use mem_cgroup_disabled().

Signed-off-by: Hugh Dickins <hughd@google.com>
Signed-off-by: Konstantin Khlebnikov <khlebnikov@openvz.org>
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Acked-by: Glauber Costa <glommer@parallels.com>
---
 mm/vmscan.c |   18 ++++--------------
 1 files changed, 4 insertions(+), 14 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 49f15ef..c684f44 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -164,26 +164,16 @@ static bool global_reclaim(struct scan_control *sc)
 {
 	return !sc->target_mem_cgroup;
 }
-
-static bool scanning_global_lru(struct mem_cgroup_zone *mz)
-{
-	return !mz->mem_cgroup;
-}
 #else
 static bool global_reclaim(struct scan_control *sc)
 {
 	return true;
 }
-
-static bool scanning_global_lru(struct mem_cgroup_zone *mz)
-{
-	return true;
-}
 #endif
 
 static struct zone_reclaim_stat *get_reclaim_stat(struct mem_cgroup_zone *mz)
 {
-	if (!scanning_global_lru(mz))
+	if (!mem_cgroup_disabled())
 		return mem_cgroup_get_reclaim_stat(mz->mem_cgroup, mz->zone);
 
 	return &mz->zone->reclaim_stat;
@@ -192,7 +182,7 @@ static struct zone_reclaim_stat *get_reclaim_stat(struct mem_cgroup_zone *mz)
 static unsigned long zone_nr_lru_pages(struct mem_cgroup_zone *mz,
 				       enum lru_list lru)
 {
-	if (!scanning_global_lru(mz))
+	if (!mem_cgroup_disabled())
 		return mem_cgroup_zone_nr_lru_pages(mz->mem_cgroup,
 						    zone_to_nid(mz->zone),
 						    zone_idx(mz->zone),
@@ -1806,7 +1796,7 @@ static int inactive_anon_is_low(struct mem_cgroup_zone *mz)
 	if (!total_swap_pages)
 		return 0;
 
-	if (!scanning_global_lru(mz))
+	if (!mem_cgroup_disabled())
 		return mem_cgroup_inactive_anon_is_low(mz->mem_cgroup,
 						       mz->zone);
 
@@ -1845,7 +1835,7 @@ static int inactive_file_is_low_global(struct zone *zone)
  */
 static int inactive_file_is_low(struct mem_cgroup_zone *mz)
 {
-	if (!scanning_global_lru(mz))
+	if (!mem_cgroup_disabled())
 		return mem_cgroup_inactive_file_is_low(mz->mem_cgroup,
 						       mz->zone);
 

