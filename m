Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760353Ab1EAN0Q (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 May 2011 09:26:16 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:54921 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757521Ab1EANWi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 May 2011 09:22:38 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        patches@linaro.org, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH tip/core/rcu 77/86] block,rcu: convert call_rcu(disk_free_ptbl_rcu_cb) to kfree_rcu()
Date: Sun,  1 May 2011 06:21:57 -0700
Message-Id: <1304256126-26015-77-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <20110501132142.GA25494@linux.vnet.ibm.com>
References: <20110501132142.GA25494@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lai Jiangshan <laijs@cn.fujitsu.com>

The rcu callback disk_free_ptbl_rcu_cb() just calls a kfree(),
so we use kfree_rcu() instead of the call_rcu(disk_free_ptbl_rcu_cb).

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Jens Axboe <axboe@kernel.dk>
---
 block/genhd.c |   10 +---------
 1 files changed, 1 insertions(+), 9 deletions(-)

diff --git a/block/genhd.c b/block/genhd.c
index b364bd0..df232ae 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -1018,14 +1018,6 @@ static const struct attribute_group *disk_attr_groups[] = {
 	NULL
 };
 
-static void disk_free_ptbl_rcu_cb(struct rcu_head *head)
-{
-	struct disk_part_tbl *ptbl =
-		container_of(head, struct disk_part_tbl, rcu_head);
-
-	kfree(ptbl);
-}
-
 /**
  * disk_replace_part_tbl - replace disk->part_tbl in RCU-safe way
  * @disk: disk to replace part_tbl for
@@ -1046,7 +1038,7 @@ static void disk_replace_part_tbl(struct gendisk *disk,
 
 	if (old_ptbl) {
 		rcu_assign_pointer(old_ptbl->last_lookup, NULL);
-		call_rcu(&old_ptbl->rcu_head, disk_free_ptbl_rcu_cb);
+		kfree_rcu(old_ptbl, rcu_head);
 	}
 }
 
-- 
1.7.3.2

