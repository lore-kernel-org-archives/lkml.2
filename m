Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754384Ab0K3Ilw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Nov 2010 03:41:52 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:59159 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751327Ab0K3Ilw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Nov 2010 03:41:52 -0500
Message-ID: <4CF4B8BB.7050106@cn.fujitsu.com>
Date: Tue, 30 Nov 2010 16:41:31 +0800
From: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: Jens Axboe <axboe@kernel.dk>, Vivek Goyal <vgoyal@redhat.com>
CC: linux kernel mailing list <linux-kernel@vger.kernel.org>
Subject: [PATCH] cfq-iosched: Get rid of on_st flag
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2010-11-30 16:42:02,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2010-11-30 16:42:03,
	Serialize complete at 2010-11-30 16:42:03
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It's able to check whether a CFQ group on a service tree by
checking "cfqg->rb_node". There's no need to maintain an
extra flag here.

Signed-off-by: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
Acked-by: Vivek Goyal <vgoyal@redhat.com>
---
 block/cfq-iosched.c |    5 +----
 1 files changed, 1 insertions(+), 4 deletions(-)

diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index e18d316..5d0349d 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -179,7 +179,6 @@ struct cfq_group {
 	/* group service_tree key */
 	u64 vdisktime;
 	unsigned int weight;
-	bool on_st;
 
 	/* number of cfqq currently on this group */
 	int nr_cfqq;
@@ -863,7 +862,7 @@ cfq_group_service_tree_add(struct cfq_data *cfqd, struct cfq_group *cfqg)
 	struct rb_node *n;
 
 	cfqg->nr_cfqq++;
-	if (cfqg->on_st)
+	if (!RB_EMPTY_NODE(&cfqg->rb_node))
 		return;
 
 	/*
@@ -879,7 +878,6 @@ cfq_group_service_tree_add(struct cfq_data *cfqd, struct cfq_group *cfqg)
 		cfqg->vdisktime = st->min_vdisktime;
 
 	__cfq_group_service_tree_add(st, cfqg);
-	cfqg->on_st = true;
 	st->total_weight += cfqg->weight;
 }
 
@@ -896,7 +894,6 @@ cfq_group_service_tree_del(struct cfq_data *cfqd, struct cfq_group *cfqg)
 		return;
 
 	cfq_log_cfqg(cfqd, cfqg, "del_from_rr group");
-	cfqg->on_st = false;
 	st->total_weight -= cfqg->weight;
 	if (!RB_EMPTY_NODE(&cfqg->rb_node))
 		cfq_rb_erase(&cfqg->rb_node, st);
-- 
1.6.5.2


