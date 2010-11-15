Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932327Ab0KOA5h (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Nov 2010 19:57:37 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:51837 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755188Ab0KOA5g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Nov 2010 19:57:36 -0500
Message-ID: <4CE0857B.20705@cn.fujitsu.com>
Date: Mon, 15 Nov 2010 08:57:31 +0800
From: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: Vivek Goyal <vgoyal@redhat.com>, Jens Axboe <axboe@kernel.dk>
CC: linux kernel mailing list <linux-kernel@vger.kernel.org>,
        Corrado Zoccolo <czoccolo@gmail.com>,
        Chad Talbott <ctalbott@google.com>, Nauman Rafique <nauman@google.com>,
        Divyesh Shah <dpshah@google.com>,
        Gui Jianfeng <guijianfeng@cn.fujitsu.com>
Subject: [RFC] [PATCH 6/8] cfq-iosched: Get rid of on_st flag
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2010-11-15 08:58:00,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2010-11-15 08:58:01,
	Serialize complete at 2010-11-15 08:58:01
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It's able to check whether a CFQ group on a service tree by
checking "entity->rb_node". There's no need to maintain an
extra flag here.


Signed-off-by: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
---
 block/cfq-iosched.c |    9 +--------
 1 files changed, 1 insertions(+), 8 deletions(-)

diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index 1b9b4b2..1df0928 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -103,7 +103,6 @@ struct io_sched_entity {
 	struct rb_node rb_node;
 	/* service_tree key */
 	u64 vdisktime;
-	bool on_st;
 	bool is_group_entity;
 	unsigned int weight;
 };
@@ -890,8 +889,6 @@ io_entity_service_tree_add(struct cfq_rb_root *st,
 	__io_entity_service_tree_add(st, io_entity);
 	st->count++;
 	st->total_weight += io_entity->weight;
-	if (io_entity->is_group_entity)
-		io_entity->on_st = true;
 }
 
 static void
@@ -903,7 +900,7 @@ cfq_group_service_tree_add(struct cfq_data *cfqd, struct cfq_group *cfqg)
 	struct io_sched_entity *__group_entity;
 
 	cfqg->nr_cfqq++;
-	if (group_entity->on_st)
+	if (!RB_EMPTY_NODE(&group_entity->rb_node))
 		return;
 
 	/*
@@ -936,8 +933,6 @@ io_entity_service_tree_del(struct cfq_rb_root *st,
 	if (!RB_EMPTY_NODE(&io_entity->rb_node)) {
 		__io_entity_service_tree_del(st, io_entity);
 		st->total_weight -= io_entity->weight;
-		if (io_entity->is_group_entity)
-			io_entity->on_st = false;
 		io_entity->service_tree = NULL;
 	}
 }
@@ -1070,7 +1065,6 @@ cfq_find_alloc_cfqg(struct cfq_data *cfqd, struct cgroup *cgroup, int create)
 	RB_CLEAR_NODE(&cfqg->group_entity.rb_node);
 
 	cfqg->group_entity.is_group_entity = true;
-	cfqg->group_entity.on_st = false;
 
 	/*
 	 * Take the initial reference that will be released on destroy
@@ -3972,7 +3966,6 @@ static void *cfq_init_queue(struct request_queue *q)
 	/* Give preference to root group over other groups */
 	cfqg->group_entity.weight = 2*BLKIO_WEIGHT_DEFAULT;
 	cfqg->group_entity.is_group_entity = true;
-	cfqg->group_entity.on_st = false;
 
 #ifdef CONFIG_CFQ_GROUP_IOSCHED
 	/*
-- 
1.6.5.2

