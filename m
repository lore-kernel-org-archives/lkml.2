Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933666Ab1ERTNc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 May 2011 15:13:32 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39409 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933393Ab1ERTN3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 May 2011 15:13:29 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: linux-kernel@vger.kernel.org, jaxboe@fusionio.com
Cc: dpshah@google.com, vgoyal@redhat.com
Subject: [PATCH 04/14] cfq-iosched: Get rid of redundant function parameter "create"
Date: Wed, 18 May 2011 15:13:16 -0400
Message-Id: <1305746006-5837-5-git-send-email-vgoyal@redhat.com>
In-Reply-To: <1305746006-5837-1-git-send-email-vgoyal@redhat.com>
References: <1305746006-5837-1-git-send-email-vgoyal@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nobody seems to be using cfq_find_alloc_cfqg() function parameter "create".
Get rid of that.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 block/cfq-iosched.c |   18 +++++++++---------
 1 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index ab7a9e6..a905b55 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -1015,7 +1015,7 @@ void cfq_update_blkio_group_weight(void *key, struct blkio_group *blkg,
 }
 
 static struct cfq_group * cfq_find_alloc_cfqg(struct cfq_data *cfqd,
-		struct blkio_cgroup *blkcg, int create)
+		struct blkio_cgroup *blkcg)
 {
 	struct cfq_group *cfqg = NULL;
 	void *key = cfqd;
@@ -1030,7 +1030,7 @@ static struct cfq_group * cfq_find_alloc_cfqg(struct cfq_data *cfqd,
 		cfqg->blkg.dev = MKDEV(major, minor);
 		goto done;
 	}
-	if (cfqg || !create)
+	if (cfqg)
 		goto done;
 
 	cfqg = kzalloc_node(sizeof(*cfqg), GFP_ATOMIC, cfqd->queue->node);
@@ -1073,18 +1073,18 @@ done:
 }
 
 /*
- * Search for the cfq group current task belongs to. If create = 1, then also
- * create the cfq group if it does not exist. request_queue lock must be held.
+ * Search for the cfq group current task belongs to. request_queue lock must
+ * be held.
  */
-static struct cfq_group *cfq_get_cfqg(struct cfq_data *cfqd, int create)
+static struct cfq_group *cfq_get_cfqg(struct cfq_data *cfqd)
 {
 	struct blkio_cgroup *blkcg;
 	struct cfq_group *cfqg = NULL;
 
 	rcu_read_lock();
 	blkcg = task_blkio_cgroup(current);
-	cfqg = cfq_find_alloc_cfqg(cfqd, blkcg, create);
-	if (!cfqg && create)
+	cfqg = cfq_find_alloc_cfqg(cfqd, blkcg);
+	if (!cfqg)
 		cfqg = &cfqd->root_group;
 	rcu_read_unlock();
 	return cfqg;
@@ -1176,7 +1176,7 @@ void cfq_unlink_blkio_group(void *key, struct blkio_group *blkg)
 }
 
 #else /* GROUP_IOSCHED */
-static struct cfq_group *cfq_get_cfqg(struct cfq_data *cfqd, int create)
+static struct cfq_group *cfq_get_cfqg(struct cfq_data *cfqd)
 {
 	return &cfqd->root_group;
 }
@@ -2911,7 +2911,7 @@ cfq_find_alloc_queue(struct cfq_data *cfqd, bool is_sync,
 	struct cfq_group *cfqg;
 
 retry:
-	cfqg = cfq_get_cfqg(cfqd, 1);
+	cfqg = cfq_get_cfqg(cfqd);
 	cic = cfq_cic_lookup(cfqd, ioc);
 	/* cic always exists here */
 	cfqq = cic_to_cfqq(cic, is_sync);
-- 
1.7.1

