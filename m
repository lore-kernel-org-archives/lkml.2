Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755457Ab0GIDWo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jul 2010 23:22:44 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57952 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751442Ab0GIDWm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jul 2010 23:22:42 -0400
Message-ID: <4C369571.5040504@ds.jp.nec.com>
Date: Thu, 08 Jul 2010 23:20:17 -0400
From: Munehiro Ikeda <m-ikeda@ds.jp.nec.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-2.fc11 Thunderbird/3.0.4
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, jens.axboe@oracle.com,
       Vivek Goyal <vgoyal@redhat.com>
CC: Munehiro Ikeda <m-ikeda@ds.jp.nec.com>, Ryo Tsuruta <ryov@valinux.co.jp>,
       taka@valinux.co.jp, kamezawa.hiroyu@jp.fujitsu.com,
       Andrea Righi <righi.andrea@gmail.com>,
       Gui Jianfeng <guijianfeng@cn.fujitsu.com>, akpm@linux-foundation.org,
       balbir@linux.vnet.ibm.com
Subject: [RFC][PATCH 09/11] blkiocg async: Functions to get cfqg from bio
References: <4C369009.80503@ds.jp.nec.com>
In-Reply-To: <4C369009.80503@ds.jp.nec.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Functions to get cfq_group from bio.
This patch contains only the functionality to get cfq_group from
bio. cfq_get_cfqg() is always called with bio==NULL and returns
cfq_group of current process at this point.  So CFQ actual behavior
is not changed yet.

Signed-off-by: Munehiro "Muuhh" Ikeda <m-ikeda@ds.jp.nec.com>
---
 block/cfq-iosched.c |   78 ++++++++++++++++++++++++++++++++++++++++++++++----
 1 files changed, 71 insertions(+), 7 deletions(-)

diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index cd4c0bd..68f76e9 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -14,6 +14,7 @@
 #include <linux/rbtree.h>
 #include <linux/ioprio.h>
 #include <linux/blktrace_api.h>
+#include <linux/blk-iotrack.h>
 #include "cfq.h"
 
 /*
@@ -1007,23 +1008,85 @@ done:
 }
 
 /*
- * Search for the cfq group current task belongs to. If create = 1, then also
- * create the cfq group if it does not exist. request_queue lock must be held.
+ * Body of searching for and alloc cfq group which is corresponding
+ * to cfqd and blockio-cgroup. If create = 1, then also create the
+ * cfq group if it does not exist. request_queue lock must be held.
  */
-static struct cfq_group *cfq_get_cfqg(struct cfq_data *cfqd, int create)
+static struct cfq_group *
+cfq_get_cfqg_blkcg(struct cfq_data *cfqd, struct blkio_cgroup *blkcg,
+			int create)
+{
+	struct cfq_group *cfqg = NULL;
+
+	cfqg = cfq_find_alloc_cfqg(cfqd, blkcg, create);
+	if (!cfqg && create)
+		cfqg = &cfqd->root_group;
+
+	return cfqg;
+}
+
+/*
+ * Search for the cfq group current task belongs to.
+ * If create = 1, then also create the cfq group if it does not
+ * exist.  request_queue lock must be held.
+ */
+static struct cfq_group *
+cfq_get_cfqg_current(struct cfq_data *cfqd, int create)
 {
 	struct cgroup *cgroup;
+	struct blkio_cgroup *blkcg;
 	struct cfq_group *cfqg = NULL;
 
 	rcu_read_lock();
+
 	cgroup = task_cgroup(current, blkio_subsys_id);
-	cfqg = cfq_find_alloc_cfqg(cfqd, cgroup, create);
-	if (!cfqg && create)
+	blkcg = cgroup_to_blkio_cgroup(cgroup);
+	cfqg = cfq_get_cfqg_blkcg(cfqd, blkcg, create);
+
+	rcu_read_unlock();
+
+	return cfqg;
+}
+
+/*
+ * Search for the cfq group corresponding to bio.
+ * If bio is for sync, the cfq group is one which current task
+ * belongs to.  If cfq group doesn't exist, it is created.
+ * request_queue lock must be held.
+ */
+static struct cfq_group *
+cfq_get_cfqg_bio(struct cfq_data *cfqd, struct bio *bio, int create)
+{
+	unsigned short blkcg_id;
+	struct blkio_cgroup *blkcg;
+	struct cfq_group *cfqg;
+
+	if (!bio || cfq_bio_sync(bio))
+		return cfq_get_cfqg_current(cfqd, create);
+
+	rcu_read_lock();
+
+	blkcg_id = blk_iotrack_cgroup_id(bio);
+	blkcg = blkiocg_id_to_blkcg(blkcg_id);
+	if (blkcg)
+		cfqg = cfq_get_cfqg_blkcg(cfqd, blkcg, create);
+	else
 		cfqg = &cfqd->root_group;
+
 	rcu_read_unlock();
 	return cfqg;
 }
 
+static inline struct cfq_group *
+cfq_get_cfqg(struct cfq_data *cfqd, struct bio *bio, int create)
+{
+#ifdef CONFIG_GROUP_IOSCHED_ASYNC
+	return cfq_get_cfqg_bio(cfqd, bio, create);
+#else
+	return cfq_get_cfqg_current(cfqd, create);
+#endif
+}
+
 static inline struct cfq_group *cfq_ref_get_cfqg(struct cfq_group *cfqg)
 {
 	atomic_inc(&cfqg->ref);
@@ -1109,7 +1172,8 @@ void cfq_unlink_blkio_group(void *key, struct blkio_group *blkg)
 }
 
 #else /* GROUP_IOSCHED */
-static struct cfq_group *cfq_get_cfqg(struct cfq_data *cfqd, int create)
+static struct cfq_group *
+cfq_get_cfqg(struct cfq_data *cfqd, struct bio *bio, int create)
 {
 	return &cfqd->root_group;
 }
@@ -2822,7 +2886,7 @@ cfq_find_alloc_queue(struct cfq_data *cfqd, bool is_sync,
 	struct cfq_group *cfqg;
 
 retry:
-	cfqg = cfq_get_cfqg(cfqd, 1);
+	cfqg = cfq_get_cfqg(cfqd, NULL, 1);
 	cic = cfq_cic_lookup(cfqd, ioc);
 	/* cic always exists here */
 	cfqq = cic_to_cfqq(cic, is_sync);
-- 
1.6.2.5

