Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934560Ab1ESTjF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 15:39:05 -0400
Received: from mx1.redhat.com ([209.132.183.28]:47662 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934413Ab1ESTik (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 15:38:40 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: linux-kernel@vger.kernel.org, jaxboe@fusionio.com, axboe@kernel.dk
Cc: dpshah@google.com, vgoyal@redhat.com
Subject: [PATCH 09/13] blk-throttle: Free up a group only after one rcu grace period
Date: Thu, 19 May 2011 15:38:27 -0400
Message-Id: <1305833911-7717-10-git-send-email-vgoyal@redhat.com>
In-Reply-To: <1305833911-7717-1-git-send-email-vgoyal@redhat.com>
References: <1305833911-7717-1-git-send-email-vgoyal@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Soon we will allow accessing a throtl_grp under rcu_read_lock(). Hence
start freeing up throtl_grp after one rcu grace period.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 block/blk-throttle.c |   22 +++++++++++++++++++++-
 1 files changed, 21 insertions(+), 1 deletions(-)

diff --git a/block/blk-throttle.c b/block/blk-throttle.c
index b9412d1..90ad407 100644
--- a/block/blk-throttle.c
+++ b/block/blk-throttle.c
@@ -78,6 +78,8 @@ struct throtl_grp {
 
 	/* Some throttle limits got updated for the group */
 	int limits_changed;
+
+	struct rcu_head rcu_head;
 };
 
 struct throtl_data
@@ -151,12 +153,30 @@ static inline struct throtl_grp *throtl_ref_get_tg(struct throtl_grp *tg)
 	return tg;
 }
 
+static void throtl_free_tg(struct rcu_head *head)
+{
+	struct throtl_grp *tg;
+
+	tg = container_of(head, struct throtl_grp, rcu_head);
+	kfree(tg);
+}
+
 static void throtl_put_tg(struct throtl_grp *tg)
 {
 	BUG_ON(atomic_read(&tg->ref) <= 0);
 	if (!atomic_dec_and_test(&tg->ref))
 		return;
-	kfree(tg);
+
+	/*
+	 * A group is freed in rcu manner. But having an rcu lock does not
+	 * mean that one can access all the fields of blkg and assume these
+	 * are valid. For example, don't try to follow throtl_data and
+	 * request queue links.
+	 *
+	 * Having a reference to blkg under an rcu allows acess to only
+	 * values local to groups like group stats and group rate limits
+	 */
+	call_rcu(&tg->rcu_head, throtl_free_tg);
 }
 
 static void throtl_init_group(struct throtl_grp *tg)
-- 
1.7.4.4

