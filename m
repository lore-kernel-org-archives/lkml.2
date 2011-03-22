Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756201Ab1CVBLJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Mar 2011 21:11:09 -0400
Received: from smtp-out.google.com ([74.125.121.67]:46071 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754880Ab1CVBLC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Mar 2011 21:11:02 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
	b=vddwGrUmfg6ErfQ28vblmJMgIGLZNYtVowe0VycuWGDaDZSvWxYwgVniU1V78AKAz
	VK7iqblnzXTyNJUVU5EFw==
From: Chad Talbott <ctalbott@google.com>
To: jaxboe@fusionio.com, vgoyal@redhat.com
Cc: linux-kernel@vger.kernel.org, mrubin@google.com, teravest@google.com,
        Chad Talbott <ctalbott@google.com>
Subject: [PATCH 3/3] cfq-iosched: Fair cross-group preemption (stats)
Date: Mon, 21 Mar 2011 18:10:45 -0700
Message-Id: <1300756245-12380-4-git-send-email-ctalbott@google.com>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <1300756245-12380-1-git-send-email-ctalbott@google.com>
References: <1300756245-12380-1-git-send-email-ctalbott@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add three counters to monitor the cross-group preemption behavior.

preempt_count:
  counts the number of times this group preempted another

preempt_active:
  counts the number of times this group issued an IO but
  was already the active group

preempt_throttle:
  number of times this group would have preempted another if it hadn't
  already used up its assigned weight

Signed-off-by: Chad Talbott <ctalbott@google.com>
---
 block/blk-cgroup.c  |   46 ++++++++++++++++++++++++++++++++++++++++++++++
 block/blk-cgroup.h  |   18 ++++++++++++++++++
 block/cfq-iosched.c |   20 +++++++++++++++++---
 3 files changed, 81 insertions(+), 3 deletions(-)

diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
index f2c553e..41ee61c 100644
--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -347,6 +347,25 @@ void blkiocg_set_start_empty_time(struct blkio_group *blkg)
 }
 EXPORT_SYMBOL_GPL(blkiocg_set_start_empty_time);
 
+void blkiocg_update_preempt_stats(struct blkio_group *blkg,
+			enum stat_type which, bool direction, bool sync)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&blkg->stats_lock, flags);
+	switch (which) {
+	case BLKIO_STAT_PREEMPT_COUNT:
+	case BLKIO_STAT_PREEMPT_ACTIVE:
+	case BLKIO_STAT_PREEMPT_THROTTLE:
+		blkio_add_stat(blkg->stats.stat_arr[which], 1, direction, sync);
+		break;
+	default:
+		BUG();
+	}
+	spin_unlock_irqrestore(&blkg->stats_lock, flags);
+}
+EXPORT_SYMBOL_GPL(blkiocg_update_preempt_stats);
+
 void blkiocg_update_dequeue_stats(struct blkio_group *blkg,
 			unsigned long dequeue)
 {
@@ -1193,6 +1212,15 @@ static int blkiocg_file_read_map(struct cgroup *cgrp, struct cftype *cft,
 		case BLKIO_PROP_empty_time:
 			return blkio_read_blkg_stats(blkcg, cft, cb,
 						BLKIO_STAT_EMPTY_TIME, 0);
+		case BLKIO_PROP_preempt_count:
+			return blkio_read_blkg_stats(blkcg, cft, cb,
+						BLKIO_STAT_PREEMPT_COUNT, 0);
+		case BLKIO_PROP_preempt_active:
+			return blkio_read_blkg_stats(blkcg, cft, cb,
+						BLKIO_STAT_PREEMPT_ACTIVE, 0);
+		case BLKIO_PROP_preempt_throttle:
+			return blkio_read_blkg_stats(blkcg, cft, cb,
+						BLKIO_STAT_PREEMPT_THROTTLE, 0);
 #endif
 		default:
 			BUG();
@@ -1443,6 +1471,24 @@ struct cftype blkio_files[] = {
 				BLKIO_PROP_dequeue),
 		.read_map = blkiocg_file_read_map,
 	},
+	{
+		.name = "preempt_count",
+		.private = BLKIOFILE_PRIVATE(BLKIO_POLICY_PROP,
+				BLKIO_PROP_preempt_count),
+		.read_map = blkiocg_file_read_map,
+	},
+	{
+		.name = "preempt_active",
+		.private = BLKIOFILE_PRIVATE(BLKIO_POLICY_PROP,
+				BLKIO_PROP_preempt_active),
+		.read_map = blkiocg_file_read_map,
+	},
+	{
+		.name = "preempt_throttle",
+		.private = BLKIOFILE_PRIVATE(BLKIO_POLICY_PROP,
+				BLKIO_PROP_preempt_throttle),
+		.read_map = blkiocg_file_read_map,
+	},
 #endif
 };
 
diff --git a/block/blk-cgroup.h b/block/blk-cgroup.h
index 0e9cd32..d2cbdcd 100644
--- a/block/blk-cgroup.h
+++ b/block/blk-cgroup.h
@@ -44,6 +44,14 @@ enum stat_type {
 	BLKIO_STAT_WAIT_TIME,
 	/* Number of IOs merged */
 	BLKIO_STAT_MERGED,
+#ifdef CONFIG_DEBUG_BLK_CGROUP
+	/* Number of IOs Added to active group */
+	BLKIO_STAT_PREEMPT_ACTIVE,
+	/* Number of cross-group preemptions */
+	BLKIO_STAT_PREEMPT_COUNT,
+	/* Number of cross-group preemptions disallowed by weight */
+	BLKIO_STAT_PREEMPT_THROTTLE,
+#endif
 	/* Number of IOs queued up */
 	BLKIO_STAT_QUEUED,
 	/* All the single valued stats go below this */
@@ -98,6 +106,9 @@ enum blkcg_file_name_prop {
 	BLKIO_PROP_idle_time,
 	BLKIO_PROP_empty_time,
 	BLKIO_PROP_dequeue,
+	BLKIO_PROP_preempt_count,
+	BLKIO_PROP_preempt_active,
+	BLKIO_PROP_preempt_throttle,
 };
 
 /* cgroup files owned by throttle policy */
@@ -271,6 +282,10 @@ void blkiocg_update_dequeue_stats(struct blkio_group *blkg,
 void blkiocg_update_set_idle_time_stats(struct blkio_group *blkg);
 void blkiocg_update_idle_time_stats(struct blkio_group *blkg);
 void blkiocg_set_start_empty_time(struct blkio_group *blkg);
+void blkiocg_update_preempt_stats(struct blkio_group *blkg,
+				enum stat_type which,
+				bool direction,
+				bool sync);
 
 #define BLKG_FLAG_FNS(name)						\
 static inline void blkio_mark_blkg_##name(				\
@@ -301,6 +316,9 @@ static inline void blkiocg_update_set_idle_time_stats(struct blkio_group *blkg)
 {}
 static inline void blkiocg_update_idle_time_stats(struct blkio_group *blkg) {}
 static inline void blkiocg_set_start_empty_time(struct blkio_group *blkg) {}
+static inline void blkiocg_update_preempt_stats(
+		struct blkio_group *blkg, enum stat_type which, bool direction,
+		bool sync) {}
 #endif
 
 #if defined(CONFIG_BLK_CGROUP) || defined(CONFIG_BLK_CGROUP_MODULE)
diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index dfcce80..0d55be3 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -1171,16 +1171,30 @@ cfq_group_should_preempt(struct cfq_queue *new_cfqq, struct cfq_queue *cfqq,
 	u64 grace_period;
 
 	/* in-group preemption is handled elsewhere */
-	if (new_cfqg == cfqg)
+	if (new_cfqg == cfqg) {
+		blkiocg_update_preempt_stats(&new_cfqg->blkg,
+			BLKIO_STAT_PREEMPT_ACTIVE,
+			rq_data_dir(rq), rq_is_sync(rq));
 		return false;
+	}
 
 	if (!(new_cfqg->class == BLKIO_RT_CLASS &&
 	      cfqg->class == BLKIO_BE_CLASS))
 		return false;
 
 	grace_period = cfq_scale_slice(cfqq->allocated_slice, cfqg);
-	return time_before64(new_cfqg->vdisktime,
-			     cfqg->vdisktime + grace_period);
+	if (time_before64(new_cfqg->vdisktime,
+			  cfqg->vdisktime + grace_period)) {
+		blkiocg_update_preempt_stats(&new_cfqg->blkg,
+			BLKIO_STAT_PREEMPT_COUNT,
+			rq_data_dir(rq), rq_is_sync(rq));
+		return true;
+	}
+
+	blkiocg_update_preempt_stats(&new_cfqg->blkg,
+		BLKIO_STAT_PREEMPT_THROTTLE,
+		rq_data_dir(rq), rq_is_sync(rq));
+	return false;
 }
 
 #else /* GROUP_IOSCHED */
-- 
1.7.3.1

