Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757332Ab0EELWO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 May 2010 07:22:14 -0400
Received: from smtp.nokia.com ([192.100.122.230]:18350 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755224Ab0EELWM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 May 2010 07:22:12 -0400
From: Phil Carmody <ext-phil.2.carmody@nokia.com>
To: balbir@linux.vnet.ibm.com, nishimura@mxp.nes.nec.co.jp,
       kamezawa.hiroyu@jp.fujitsu.com
Cc: akpm@linux-foundation.org, kirill@shutemov.name, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] mm: remove unnecessary use of atomic
Date: Wed,  5 May 2010 14:21:48 +0300
Message-Id: <1273058509-16625-1-git-send-email-ext-phil.2.carmody@nokia.com>
X-Mailer: git-send-email 1.6.0.4
X-OriginalArrivalTime: 05 May 2010 11:21:34.0439 (UTC) FILETIME=[1EA32F70:01CAEC45]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Phil Carmody <ext-phil.2.carmody@nokia.com>

The bottom 4 hunks are atomically changing memory to which there
are no aliases as it's freshly allocated, so there's no need to
use atomic operations.

The other hunks are just atomic_read and atomic_set, and do not
involve any read-modify-write. The use of atomic_{read,set}
doesn't prevent a read/write or write/write race, so if a race
were possible (I'm not saying one is), then it would still be
there even with atomic_set.

See:
http://digitalvampire.org/blog/index.php/2007/05/13/atomic-cargo-cults/

Signed-off-by: Phil Carmody <ext-phil.2.carmody@nokia.com>
Acked-by: Kirill A. Shutemov <kirill@shutemov.name>
---
 mm/memcontrol.c |   14 +++++++-------
 1 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 6c755de..90e32b2 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -151,7 +151,7 @@ struct mem_cgroup_threshold {
 
 struct mem_cgroup_threshold_ary {
 	/* An array index points to threshold just below usage. */
-	atomic_t current_threshold;
+	int current_threshold;
 	/* Size of entries[] */
 	unsigned int size;
 	/* Array of thresholds */
@@ -3327,7 +3327,7 @@ static void __mem_cgroup_threshold(struct mem_cgroup *memcg, bool swap)
 	 * If it's not true, a threshold was crossed after last
 	 * call of __mem_cgroup_threshold().
 	 */
-	i = atomic_read(&t->current_threshold);
+	i = t->current_threshold;
 
 	/*
 	 * Iterate backward over array of thresholds starting from
@@ -3351,7 +3351,7 @@ static void __mem_cgroup_threshold(struct mem_cgroup *memcg, bool swap)
 		eventfd_signal(t->entries[i].eventfd, 1);
 
 	/* Update current_threshold */
-	atomic_set(&t->current_threshold, i - 1);
+	t->current_threshold = i - 1;
 unlock:
 	rcu_read_unlock();
 }
@@ -3429,7 +3429,7 @@ static int mem_cgroup_register_event(struct cgroup *cgrp, struct cftype *cft,
 			compare_thresholds, NULL);
 
 	/* Find current threshold */
-	atomic_set(&thresholds_new->current_threshold, -1);
+	thresholds_new->current_threshold = -1;
 	for (i = 0; i < size; i++) {
 		if (thresholds_new->entries[i].threshold < usage) {
 			/*
@@ -3437,7 +3437,7 @@ static int mem_cgroup_register_event(struct cgroup *cgrp, struct cftype *cft,
 			 * until rcu_assign_pointer(), so it's safe to increment
 			 * it here.
 			 */
-			atomic_inc(&thresholds_new->current_threshold);
+			++thresholds_new->current_threshold;
 		}
 	}
 
@@ -3508,7 +3508,7 @@ static int mem_cgroup_unregister_event(struct cgroup *cgrp, struct cftype *cft,
 	thresholds_new->size = size;
 
 	/* Copy thresholds and find current threshold */
-	atomic_set(&thresholds_new->current_threshold, -1);
+	thresholds_new->current_threshold = -1;
 	for (i = 0, j = 0; i < thresholds->size; i++) {
 		if (thresholds->entries[i].eventfd == eventfd)
 			continue;
@@ -3520,7 +3520,7 @@ static int mem_cgroup_unregister_event(struct cgroup *cgrp, struct cftype *cft,
 			 * until rcu_assign_pointer(), so it's safe to increment
 			 * it here.
 			 */
-			atomic_inc(&thresholds_new->current_threshold);
+			++thresholds_new->current_threshold;
 		}
 		j++;
 	}
-- 
1.6.0.4

