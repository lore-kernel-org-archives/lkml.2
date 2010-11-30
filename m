Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754661Ab0K3Iht (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Nov 2010 03:37:49 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:50381 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754465Ab0K3Ihs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Nov 2010 03:37:48 -0500
Message-ID: <4CF4B7C6.7080600@cn.fujitsu.com>
Date: Tue, 30 Nov 2010 16:37:26 +0800
From: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: Jens Axboe <axboe@kernel.dk>, Vivek Goyal <vgoyal@redhat.com>
CC: linux kernel mailing list <linux-kernel@vger.kernel.org>
Subject: [PATCH] cfq-iosched: Get rid of st->active
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2010-11-30 16:37:57,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2010-11-30 16:37:58,
	Serialize complete at 2010-11-30 16:37:58
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When a cfq group is running, it won't be dequeued from service tree, so
there's no need to store the active one in st->active. Just gid rid of it.

Signed-off-by: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
Acked-by: Vivek Goyal <vgoyal@redhat.com>
---
 block/cfq-iosched.c |   15 +--------------
 1 files changed, 1 insertions(+), 14 deletions(-)

diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index 73a5862..e18d316 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -87,7 +87,6 @@ struct cfq_rb_root {
 	unsigned count;
 	unsigned total_weight;
 	u64 min_vdisktime;
-	struct rb_node *active;
 };
 #define CFQ_RB_ROOT	(struct cfq_rb_root) { .rb = RB_ROOT, .left = NULL, \
 			.count = 0, .min_vdisktime = 0, }
@@ -563,11 +562,6 @@ static void update_min_vdisktime(struct cfq_rb_root *st)
 	u64 vdisktime = st->min_vdisktime;
 	struct cfq_group *cfqg;
 
-	if (st->active) {
-		cfqg = rb_entry_cfqg(st->active);
-		vdisktime = cfqg->vdisktime;
-	}
-
 	if (st->left) {
 		cfqg = rb_entry_cfqg(st->left);
 		vdisktime = min_vdisktime(vdisktime, cfqg->vdisktime);
@@ -894,9 +888,6 @@ cfq_group_service_tree_del(struct cfq_data *cfqd, struct cfq_group *cfqg)
 {
 	struct cfq_rb_root *st = &cfqd->grp_service_tree;
 
-	if (st->active == &cfqg->rb_node)
-		st->active = NULL;
-
 	BUG_ON(cfqg->nr_cfqq < 1);
 	cfqg->nr_cfqq--;
 
@@ -1095,7 +1086,7 @@ static void cfq_put_cfqg(struct cfq_group *cfqg)
 	if (!atomic_dec_and_test(&cfqg->ref))
 		return;
 	for_each_cfqg_st(cfqg, i, j, st)
-		BUG_ON(!RB_EMPTY_ROOT(&st->rb) || st->active != NULL);
+		BUG_ON(!RB_EMPTY_ROOT(&st->rb));
 	kfree(cfqg);
 }
 
@@ -1687,9 +1678,6 @@ __cfq_slice_expired(struct cfq_data *cfqd, struct cfq_queue *cfqq,
 	if (cfqq == cfqd->active_queue)
 		cfqd->active_queue = NULL;
 
-	if (&cfqq->cfqg->rb_node == cfqd->grp_service_tree.active)
-		cfqd->grp_service_tree.active = NULL;
-
 	if (cfqd->active_cic) {
 		put_io_context(cfqd->active_cic->ioc);
 		cfqd->active_cic = NULL;
@@ -2199,7 +2187,6 @@ static struct cfq_group *cfq_get_next_cfqg(struct cfq_data *cfqd)
 	if (RB_EMPTY_ROOT(&st->rb))
 		return NULL;
 	cfqg = cfq_rb_first_group(st);
-	st->active = &cfqg->rb_node;
 	update_min_vdisktime(st);
 	return cfqg;
 }
-- 
1.6.5.2



