Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933748Ab1ERTPm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 May 2011 15:15:42 -0400
Received: from mx1.redhat.com ([209.132.183.28]:5520 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933631Ab1ERTN3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 May 2011 15:13:29 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: linux-kernel@vger.kernel.org, jaxboe@fusionio.com
Cc: dpshah@google.com, vgoyal@redhat.com
Subject: [PATCH 01/14] blk-throttle: Use task_subsys_state() to determine a task's blkio_cgroup
Date: Wed, 18 May 2011 15:13:13 -0400
Message-Id: <1305746006-5837-2-git-send-email-vgoyal@redhat.com>
In-Reply-To: <1305746006-5837-1-git-send-email-vgoyal@redhat.com>
References: <1305746006-5837-1-git-send-email-vgoyal@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currentlly we first map the task to cgroup and then cgroup to
blkio_cgroup. There is a more direct way to get to blkio_cgroup
from task using task_subsys_state(). Use that.

The real reason for the fix is that it also avoids a race in generic
cgroup code. During remount/umount rebind_subsystems() is called and
it can do following with and rcu protection.

cgrp->subsys[i] = NULL;

That means if somebody got hold of cgroup under rcu and then it tried
to do cgroup->subsys[] to get to blkio_cgroup, it would get NULL which
is wrong. I was running into this race condition with ltp running on a
upstream derived kernel and that lead to crash.

So ideally we should also fix cgroup generic code to wait for rcu
grace period before setting pointer to NULL. Li Zefan is not very keen
on introducing synchronize_wait() as he thinks it will slow
down moun/remount/umount operations.

So for the time being atleast fix the kernel crash by taking a more
direct route to blkio_cgroup.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 block/blk-cgroup.c   |    7 +++++++
 block/blk-cgroup.h   |    3 +++
 block/blk-throttle.c |    9 ++++-----
 block/cfq-iosched.c  |   11 +++++------
 4 files changed, 19 insertions(+), 11 deletions(-)

diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
index f0605ab..471fdcc 100644
--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -114,6 +114,13 @@ struct blkio_cgroup *cgroup_to_blkio_cgroup(struct cgroup *cgroup)
 }
 EXPORT_SYMBOL_GPL(cgroup_to_blkio_cgroup);
 
+struct blkio_cgroup *task_blkio_cgroup(struct task_struct *tsk)
+{
+	return container_of(task_subsys_state(tsk, blkio_subsys_id),
+			    struct blkio_cgroup, css);
+}
+EXPORT_SYMBOL_GPL(task_blkio_cgroup);
+
 static inline void
 blkio_update_group_weight(struct blkio_group *blkg, unsigned int weight)
 {
diff --git a/block/blk-cgroup.h b/block/blk-cgroup.h
index 10919fa..c774930 100644
--- a/block/blk-cgroup.h
+++ b/block/blk-cgroup.h
@@ -291,6 +291,7 @@ static inline void blkiocg_set_start_empty_time(struct blkio_group *blkg) {}
 #if defined(CONFIG_BLK_CGROUP) || defined(CONFIG_BLK_CGROUP_MODULE)
 extern struct blkio_cgroup blkio_root_cgroup;
 extern struct blkio_cgroup *cgroup_to_blkio_cgroup(struct cgroup *cgroup);
+extern struct blkio_cgroup *task_blkio_cgroup(struct task_struct *tsk);
 extern void blkiocg_add_blkio_group(struct blkio_cgroup *blkcg,
 	struct blkio_group *blkg, void *key, dev_t dev,
 	enum blkio_policy_id plid);
@@ -314,6 +315,8 @@ void blkiocg_update_io_remove_stats(struct blkio_group *blkg,
 struct cgroup;
 static inline struct blkio_cgroup *
 cgroup_to_blkio_cgroup(struct cgroup *cgroup) { return NULL; }
+static inline struct blkio_cgroup *
+task_blkio_cgroup(struct task_struct *tsk) { return NULL; }
 
 static inline void blkiocg_add_blkio_group(struct blkio_cgroup *blkcg,
 		struct blkio_group *blkg, void *key, dev_t dev,
diff --git a/block/blk-throttle.c b/block/blk-throttle.c
index 0475a22..252a81a 100644
--- a/block/blk-throttle.c
+++ b/block/blk-throttle.c
@@ -160,9 +160,8 @@ static void throtl_put_tg(struct throtl_grp *tg)
 }
 
 static struct throtl_grp * throtl_find_alloc_tg(struct throtl_data *td,
-			struct cgroup *cgroup)
+			struct blkio_cgroup *blkcg)
 {
-	struct blkio_cgroup *blkcg = cgroup_to_blkio_cgroup(cgroup);
 	struct throtl_grp *tg = NULL;
 	void *key = td;
 	struct backing_dev_info *bdi = &td->queue->backing_dev_info;
@@ -229,12 +228,12 @@ done:
 
 static struct throtl_grp * throtl_get_tg(struct throtl_data *td)
 {
-	struct cgroup *cgroup;
 	struct throtl_grp *tg = NULL;
+	struct blkio_cgroup *blkcg;
 
 	rcu_read_lock();
-	cgroup = task_cgroup(current, blkio_subsys_id);
-	tg = throtl_find_alloc_tg(td, cgroup);
+	blkcg = task_blkio_cgroup(current);
+	tg = throtl_find_alloc_tg(td, blkcg);
 	if (!tg)
 		tg = &td->root_tg;
 	rcu_read_unlock();
diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index 5b52011..ab7a9e6 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -1014,10 +1014,9 @@ void cfq_update_blkio_group_weight(void *key, struct blkio_group *blkg,
 	cfqg->needs_update = true;
 }
 
-static struct cfq_group *
-cfq_find_alloc_cfqg(struct cfq_data *cfqd, struct cgroup *cgroup, int create)
+static struct cfq_group * cfq_find_alloc_cfqg(struct cfq_data *cfqd,
+		struct blkio_cgroup *blkcg, int create)
 {
-	struct blkio_cgroup *blkcg = cgroup_to_blkio_cgroup(cgroup);
 	struct cfq_group *cfqg = NULL;
 	void *key = cfqd;
 	int i, j;
@@ -1079,12 +1078,12 @@ done:
  */
 static struct cfq_group *cfq_get_cfqg(struct cfq_data *cfqd, int create)
 {
-	struct cgroup *cgroup;
+	struct blkio_cgroup *blkcg;
 	struct cfq_group *cfqg = NULL;
 
 	rcu_read_lock();
-	cgroup = task_cgroup(current, blkio_subsys_id);
-	cfqg = cfq_find_alloc_cfqg(cfqd, cgroup, create);
+	blkcg = task_blkio_cgroup(current);
+	cfqg = cfq_find_alloc_cfqg(cfqd, blkcg, create);
 	if (!cfqg && create)
 		cfqg = &cfqd->root_group;
 	rcu_read_unlock();
-- 
1.7.1

