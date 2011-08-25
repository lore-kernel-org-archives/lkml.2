Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754001Ab1HYPKK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Aug 2011 11:10:10 -0400
Received: from mail09.linbit.com ([212.69.161.110]:32932 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753973Ab1HYPKH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Aug 2011 11:10:07 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 096/118] drbd: Consolidated the setup of the thread name into the framework
Date: Thu, 25 Aug 2011 17:08:32 +0200
Message-Id: <1314284934-17999-97-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1314284934-17999-1-git-send-email-philipp.reisner@linbit.com>
References: <1314284934-17999-1-git-send-email-philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
---
 drivers/block/drbd/drbd_main.c     |    3 +++
 drivers/block/drbd/drbd_receiver.c |    5 -----
 drivers/block/drbd/drbd_worker.c   |    2 --
 3 files changed, 3 insertions(+), 7 deletions(-)

diff --git a/drivers/block/drbd/drbd_main.c b/drivers/block/drbd/drbd_main.c
index b054b7b..4589be4 100644
--- a/drivers/block/drbd/drbd_main.c
+++ b/drivers/block/drbd/drbd_main.c
@@ -458,6 +458,9 @@ static int drbd_thread_setup(void *arg)
 	unsigned long flags;
 	int retval;
 
+	snprintf(current->comm, sizeof(current->comm), "drbd_%c_%s",
+		 thi->name[0], thi->mdev->tconn->name);
+
 restart:
 	retval = thi->function(thi);
 
diff --git a/drivers/block/drbd/drbd_receiver.c b/drivers/block/drbd/drbd_receiver.c
index 183e533..3fcc8dc 100644
--- a/drivers/block/drbd/drbd_receiver.c
+++ b/drivers/block/drbd/drbd_receiver.c
@@ -4230,11 +4230,8 @@ static int drbd_do_auth(struct drbd_tconn *tconn)
 int drbdd_init(struct drbd_thread *thi)
 {
 	struct drbd_conf *mdev = thi->mdev;
-	unsigned int minor = mdev_to_minor(mdev);
 	int h;
 
-	sprintf(current->comm, "drbd%d_receiver", minor);
-
 	dev_info(DEV, "receiver (re)started\n");
 
 	do {
@@ -4575,8 +4572,6 @@ int drbd_asender(struct drbd_thread *thi)
 	int ping_timeout_active = 0;
 	int empty;
 
-	sprintf(current->comm, "drbd%d_asender", mdev_to_minor(mdev));
-
 	current->policy = SCHED_RR;  /* Make this a realtime task! */
 	current->rt_priority = 2;    /* more important than all other tasks */
 
diff --git a/drivers/block/drbd/drbd_worker.c b/drivers/block/drbd/drbd_worker.c
index cac65f6..6f70962 100644
--- a/drivers/block/drbd/drbd_worker.c
+++ b/drivers/block/drbd/drbd_worker.c
@@ -1631,8 +1631,6 @@ int drbd_worker(struct drbd_thread *thi)
 	LIST_HEAD(work_list);
 	int intr = 0, i;
 
-	sprintf(current->comm, "drbd%d_worker", mdev_to_minor(mdev));
-
 	while (get_t_state(thi) == RUNNING) {
 		drbd_thread_current_set_cpu(thi);
 
-- 
1.7.4.1

