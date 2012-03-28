Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933180Ab2C1Wwf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2012 18:52:35 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:45002 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759021Ab2C1Wv5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2012 18:51:57 -0400
From: Tejun Heo <tj@kernel.org>
To: axboe@kernel.dk
Cc: vgoyal@redhat.com, ctalbott@google.com, rni@google.com,
        linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
        containers@lists.linux-foundation.org, Tejun Heo <tj@kernel.org>
Subject: [PATCH 12/21] cfq: collapse cfq.h into cfq-iosched.c
Date: Wed, 28 Mar 2012 15:51:22 -0700
Message-Id: <1332975091-10950-13-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1332975091-10950-1-git-send-email-tj@kernel.org>
References: <1332975091-10950-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

block/cfq.h contains some functions which interact with blkcg;
however, this is only part of it and cfq-iosched.c already has quite
some #ifdef CONFIG_CFQ_GROUP_IOSCHED.  With conf/stat handling being
moved to specific policies, having these relay functions isolated in
cfq.h doesn't make much sense.  Collapse cfq.h into cfq-iosched.c for
now.  Let's split blkcg support properly later if necessary.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 block/cfq-iosched.c |  114 ++++++++++++++++++++++++++++++++++++++++++++++++-
 block/cfq.h         |  118 ---------------------------------------------------
 2 files changed, 113 insertions(+), 119 deletions(-)
 delete mode 100644 block/cfq.h

diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index 119e061..2e13e9e 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -15,7 +15,6 @@
 #include <linux/ioprio.h>
 #include <linux/blktrace_api.h>
 #include "blk.h"
-#include "cfq.h"
 
 static struct blkio_policy_type blkio_policy_cfq;
 
@@ -367,6 +366,9 @@ CFQ_CFQQ_FNS(wait_busy);
 #undef CFQ_CFQQ_FNS
 
 #ifdef CONFIG_CFQ_GROUP_IOSCHED
+
+#include "blk-cgroup.h"
+
 static inline struct cfq_group *blkg_to_cfqg(struct blkio_group *blkg)
 {
 	return blkg_to_pdata(blkg, &blkio_policy_cfq);
@@ -396,6 +398,82 @@ static inline void cfqg_put(struct cfq_group *cfqg)
 	blk_add_trace_msg((cfqd)->queue, "%s " fmt,			\
 			blkg_path(cfqg_to_blkg((cfqg))), ##args)	\
 
+static inline void cfq_blkiocg_update_io_add_stats(struct blkio_group *blkg,
+			struct blkio_policy_type *pol,
+			struct blkio_group *curr_blkg,
+			bool direction, bool sync)
+{
+	blkiocg_update_io_add_stats(blkg, pol, curr_blkg, direction, sync);
+}
+
+static inline void cfq_blkiocg_update_dequeue_stats(struct blkio_group *blkg,
+			struct blkio_policy_type *pol, unsigned long dequeue)
+{
+	blkiocg_update_dequeue_stats(blkg, pol, dequeue);
+}
+
+static inline void cfq_blkiocg_update_timeslice_used(struct blkio_group *blkg,
+			struct blkio_policy_type *pol, unsigned long time,
+			unsigned long unaccounted_time)
+{
+	blkiocg_update_timeslice_used(blkg, pol, time, unaccounted_time);
+}
+
+static inline void cfq_blkiocg_set_start_empty_time(struct blkio_group *blkg,
+			struct blkio_policy_type *pol)
+{
+	blkiocg_set_start_empty_time(blkg, pol);
+}
+
+static inline void cfq_blkiocg_update_io_remove_stats(struct blkio_group *blkg,
+			struct blkio_policy_type *pol, bool direction,
+			bool sync)
+{
+	blkiocg_update_io_remove_stats(blkg, pol, direction, sync);
+}
+
+static inline void cfq_blkiocg_update_io_merged_stats(struct blkio_group *blkg,
+			struct blkio_policy_type *pol, bool direction,
+			bool sync)
+{
+	blkiocg_update_io_merged_stats(blkg, pol, direction, sync);
+}
+
+static inline void cfq_blkiocg_update_idle_time_stats(struct blkio_group *blkg,
+			struct blkio_policy_type *pol)
+{
+	blkiocg_update_idle_time_stats(blkg, pol);
+}
+
+static inline void
+cfq_blkiocg_update_avg_queue_size_stats(struct blkio_group *blkg,
+			struct blkio_policy_type *pol)
+{
+	blkiocg_update_avg_queue_size_stats(blkg, pol);
+}
+
+static inline void
+cfq_blkiocg_update_set_idle_time_stats(struct blkio_group *blkg,
+			struct blkio_policy_type *pol)
+{
+	blkiocg_update_set_idle_time_stats(blkg, pol);
+}
+
+static inline void cfq_blkiocg_update_dispatch_stats(struct blkio_group *blkg,
+			struct blkio_policy_type *pol, uint64_t bytes,
+			bool direction, bool sync)
+{
+	blkiocg_update_dispatch_stats(blkg, pol, bytes, direction, sync);
+}
+
+static inline void cfq_blkiocg_update_completion_stats(struct blkio_group *blkg,
+			struct blkio_policy_type *pol, uint64_t start_time,
+			uint64_t io_start_time, bool direction, bool sync)
+{
+	blkiocg_update_completion_stats(blkg, pol, start_time, io_start_time,
+					direction, sync);
+}
+
 #else	/* CONFIG_CFQ_GROUP_IOSCHED */
 
 static inline struct cfq_group *blkg_to_cfqg(struct blkio_group *blkg) { return NULL; }
@@ -407,6 +485,40 @@ static inline void cfqg_put(struct cfq_group *cfqg) { }
 	blk_add_trace_msg((cfqd)->queue, "cfq%d " fmt, (cfqq)->pid, ##args)
 #define cfq_log_cfqg(cfqd, cfqg, fmt, args...)		do {} while (0)
 
+static inline void cfq_blkiocg_update_io_add_stats(struct blkio_group *blkg,
+			struct blkio_policy_type *pol,
+			struct blkio_group *curr_blkg, bool direction,
+			bool sync) { }
+static inline void cfq_blkiocg_update_dequeue_stats(struct blkio_group *blkg,
+			struct blkio_policy_type *pol, unsigned long dequeue) { }
+static inline void cfq_blkiocg_update_timeslice_used(struct blkio_group *blkg,
+			struct blkio_policy_type *pol, unsigned long time,
+			unsigned long unaccounted_time) { }
+static inline void cfq_blkiocg_set_start_empty_time(struct blkio_group *blkg,
+			struct blkio_policy_type *pol) { }
+static inline void cfq_blkiocg_update_io_remove_stats(struct blkio_group *blkg,
+			struct blkio_policy_type *pol, bool direction,
+			bool sync) { }
+static inline void cfq_blkiocg_update_io_merged_stats(struct blkio_group *blkg,
+			struct blkio_policy_type *pol, bool direction,
+			bool sync) { }
+static inline void cfq_blkiocg_update_idle_time_stats(struct blkio_group *blkg,
+			struct blkio_policy_type *pol) { }
+static inline void
+cfq_blkiocg_update_avg_queue_size_stats(struct blkio_group *blkg,
+					struct blkio_policy_type *pol) { }
+
+static inline void
+cfq_blkiocg_update_set_idle_time_stats(struct blkio_group *blkg,
+				       struct blkio_policy_type *pol) { }
+
+static inline void cfq_blkiocg_update_dispatch_stats(struct blkio_group *blkg,
+			struct blkio_policy_type *pol, uint64_t bytes,
+			bool direction, bool sync) { }
+static inline void cfq_blkiocg_update_completion_stats(struct blkio_group *blkg,
+			struct blkio_policy_type *pol, uint64_t start_time,
+			uint64_t io_start_time, bool direction, bool sync) { }
+
 #endif	/* CONFIG_CFQ_GROUP_IOSCHED */
 
 #define cfq_log(cfqd, fmt, args...)	\
diff --git a/block/cfq.h b/block/cfq.h
deleted file mode 100644
index c8b15ef..0000000
--- a/block/cfq.h
+++ /dev/null
@@ -1,118 +0,0 @@
-#ifndef _CFQ_H
-#define _CFQ_H
-#include "blk-cgroup.h"
-
-#ifdef CONFIG_CFQ_GROUP_IOSCHED
-static inline void cfq_blkiocg_update_io_add_stats(struct blkio_group *blkg,
-			struct blkio_policy_type *pol,
-			struct blkio_group *curr_blkg,
-			bool direction, bool sync)
-{
-	blkiocg_update_io_add_stats(blkg, pol, curr_blkg, direction, sync);
-}
-
-static inline void cfq_blkiocg_update_dequeue_stats(struct blkio_group *blkg,
-			struct blkio_policy_type *pol, unsigned long dequeue)
-{
-	blkiocg_update_dequeue_stats(blkg, pol, dequeue);
-}
-
-static inline void cfq_blkiocg_update_timeslice_used(struct blkio_group *blkg,
-			struct blkio_policy_type *pol, unsigned long time,
-			unsigned long unaccounted_time)
-{
-	blkiocg_update_timeslice_used(blkg, pol, time, unaccounted_time);
-}
-
-static inline void cfq_blkiocg_set_start_empty_time(struct blkio_group *blkg,
-			struct blkio_policy_type *pol)
-{
-	blkiocg_set_start_empty_time(blkg, pol);
-}
-
-static inline void cfq_blkiocg_update_io_remove_stats(struct blkio_group *blkg,
-			struct blkio_policy_type *pol, bool direction,
-			bool sync)
-{
-	blkiocg_update_io_remove_stats(blkg, pol, direction, sync);
-}
-
-static inline void cfq_blkiocg_update_io_merged_stats(struct blkio_group *blkg,
-			struct blkio_policy_type *pol, bool direction,
-			bool sync)
-{
-	blkiocg_update_io_merged_stats(blkg, pol, direction, sync);
-}
-
-static inline void cfq_blkiocg_update_idle_time_stats(struct blkio_group *blkg,
-			struct blkio_policy_type *pol)
-{
-	blkiocg_update_idle_time_stats(blkg, pol);
-}
-
-static inline void
-cfq_blkiocg_update_avg_queue_size_stats(struct blkio_group *blkg,
-			struct blkio_policy_type *pol)
-{
-	blkiocg_update_avg_queue_size_stats(blkg, pol);
-}
-
-static inline void
-cfq_blkiocg_update_set_idle_time_stats(struct blkio_group *blkg,
-			struct blkio_policy_type *pol)
-{
-	blkiocg_update_set_idle_time_stats(blkg, pol);
-}
-
-static inline void cfq_blkiocg_update_dispatch_stats(struct blkio_group *blkg,
-			struct blkio_policy_type *pol, uint64_t bytes,
-			bool direction, bool sync)
-{
-	blkiocg_update_dispatch_stats(blkg, pol, bytes, direction, sync);
-}
-
-static inline void cfq_blkiocg_update_completion_stats(struct blkio_group *blkg,
-			struct blkio_policy_type *pol, uint64_t start_time,
-			uint64_t io_start_time, bool direction, bool sync)
-{
-	blkiocg_update_completion_stats(blkg, pol, start_time, io_start_time,
-					direction, sync);
-}
-
-#else /* CFQ_GROUP_IOSCHED */
-static inline void cfq_blkiocg_update_io_add_stats(struct blkio_group *blkg,
-			struct blkio_policy_type *pol,
-			struct blkio_group *curr_blkg, bool direction,
-			bool sync) { }
-static inline void cfq_blkiocg_update_dequeue_stats(struct blkio_group *blkg,
-			struct blkio_policy_type *pol, unsigned long dequeue) { }
-static inline void cfq_blkiocg_update_timeslice_used(struct blkio_group *blkg,
-			struct blkio_policy_type *pol, unsigned long time,
-			unsigned long unaccounted_time) { }
-static inline void cfq_blkiocg_set_start_empty_time(struct blkio_group *blkg,
-			struct blkio_policy_type *pol) { }
-static inline void cfq_blkiocg_update_io_remove_stats(struct blkio_group *blkg,
-			struct blkio_policy_type *pol, bool direction,
-			bool sync) { }
-static inline void cfq_blkiocg_update_io_merged_stats(struct blkio_group *blkg,
-			struct blkio_policy_type *pol, bool direction,
-			bool sync) { }
-static inline void cfq_blkiocg_update_idle_time_stats(struct blkio_group *blkg,
-			struct blkio_policy_type *pol) { }
-static inline void
-cfq_blkiocg_update_avg_queue_size_stats(struct blkio_group *blkg,
-					struct blkio_policy_type *pol) { }
-
-static inline void
-cfq_blkiocg_update_set_idle_time_stats(struct blkio_group *blkg,
-				       struct blkio_policy_type *pol) { }
-
-static inline void cfq_blkiocg_update_dispatch_stats(struct blkio_group *blkg,
-			struct blkio_policy_type *pol, uint64_t bytes,
-			bool direction, bool sync) { }
-static inline void cfq_blkiocg_update_completion_stats(struct blkio_group *blkg,
-			struct blkio_policy_type *pol, uint64_t start_time,
-			uint64_t io_start_time, bool direction, bool sync) { }
-
-#endif /* CFQ_GROUP_IOSCHED */
-#endif
-- 
1.7.7.3

