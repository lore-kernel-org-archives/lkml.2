Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756004Ab1I2IQZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Sep 2011 04:16:25 -0400
Received: from mail09.linbit.com ([212.69.161.110]:43478 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755395Ab1I2IPh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Sep 2011 04:15:37 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 10/12] drbd: Rename drbd_pp_first_pages_or_try_alloc() to __drbd_alloc_pages()
Date: Thu, 29 Sep 2011 10:15:29 +0200
Message-Id: <1317284131-17464-11-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1317284131-17464-1-git-send-email-philipp.reisner@linbit.com>
References: <1317284131-17464-1-git-send-email-philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andreas Gruenbacher <agruen@linbit.com>

Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
---
 drivers/block/drbd/drbd_receiver.c |    9 +++++----
 1 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/block/drbd/drbd_receiver.c b/drivers/block/drbd/drbd_receiver.c
index 3003d9e..0e4e651 100644
--- a/drivers/block/drbd/drbd_receiver.c
+++ b/drivers/block/drbd/drbd_receiver.c
@@ -150,11 +150,12 @@ static void page_chain_add(struct page **head,
 	*head = chain_first;
 }
 
-static struct page *drbd_pp_first_pages_or_try_alloc(struct drbd_conf *mdev, int number)
+static struct page *__drbd_alloc_pages(struct drbd_conf *mdev,
+				       unsigned int number)
 {
 	struct page *page = NULL;
 	struct page *tmp = NULL;
-	int i = 0;
+	unsigned int i = 0;
 
 	/* Yes, testing drbd_pp_vacant outside the lock is racy.
 	 * So what. It saves a spin_lock. */
@@ -247,7 +248,7 @@ static struct page *drbd_pp_alloc(struct drbd_conf *mdev, unsigned number, bool
 	/* Yes, we may run up to @number over max_buffers. If we
 	 * follow it strictly, the admin will get it wrong anyways. */
 	if (atomic_read(&mdev->pp_in_use) < mdev->tconn->net_conf->max_buffers)
-		page = drbd_pp_first_pages_or_try_alloc(mdev, number);
+		page = __drbd_alloc_pages(mdev, number);
 
 	while (page == NULL) {
 		prepare_to_wait(&drbd_pp_wait, &wait, TASK_INTERRUPTIBLE);
@@ -255,7 +256,7 @@ static struct page *drbd_pp_alloc(struct drbd_conf *mdev, unsigned number, bool
 		drbd_kick_lo_and_reclaim_net(mdev);
 
 		if (atomic_read(&mdev->pp_in_use) < mdev->tconn->net_conf->max_buffers) {
-			page = drbd_pp_first_pages_or_try_alloc(mdev, number);
+			page = __drbd_alloc_pages(mdev, number);
 			if (page)
 				break;
 		}
-- 
1.7.4.1

