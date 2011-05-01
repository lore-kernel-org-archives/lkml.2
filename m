Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758318Ab1EAN1O (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 May 2011 09:27:14 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:49901 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757488Ab1EANWh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 May 2011 09:22:37 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        patches@linaro.org, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Neil Brown <neilb@suse.de>
Subject: [PATCH tip/core/rcu 80/86] md,rcu: convert call_rcu(free_conf) to kfree_rcu()
Date: Sun,  1 May 2011 06:22:00 -0700
Message-Id: <1304256126-26015-80-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <20110501132142.GA25494@linux.vnet.ibm.com>
References: <20110501132142.GA25494@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lai Jiangshan <laijs@cn.fujitsu.com>

The rcu callback free_conf() just calls a kfree(),
so we use kfree_rcu() instead of the call_rcu(free_conf).

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Neil Brown <neilb@suse.de>
---
 drivers/md/linear.c |    8 +-------
 1 files changed, 1 insertions(+), 7 deletions(-)

diff --git a/drivers/md/linear.c b/drivers/md/linear.c
index abfb59a..6cd2c31 100644
--- a/drivers/md/linear.c
+++ b/drivers/md/linear.c
@@ -213,12 +213,6 @@ static int linear_run (mddev_t *mddev)
 	return md_integrity_register(mddev);
 }
 
-static void free_conf(struct rcu_head *head)
-{
-	linear_conf_t *conf = container_of(head, linear_conf_t, rcu);
-	kfree(conf);
-}
-
 static int linear_add(mddev_t *mddev, mdk_rdev_t *rdev)
 {
 	/* Adding a drive to a linear array allows the array to grow.
@@ -247,7 +241,7 @@ static int linear_add(mddev_t *mddev, mdk_rdev_t *rdev)
 	md_set_array_sectors(mddev, linear_size(mddev, 0, 0));
 	set_capacity(mddev->gendisk, mddev->array_sectors);
 	revalidate_disk(mddev->gendisk);
-	call_rcu(&oldconf->rcu, free_conf);
+	kfree_rcu(oldconf, rcu);
 	return 0;
 }
 
-- 
1.7.3.2

