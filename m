Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932289Ab1IAMuJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Sep 2011 08:50:09 -0400
Received: from mail09.linbit.com ([212.69.161.110]:55662 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932211Ab1IAMtQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Sep 2011 08:49:16 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 17/18] drbd: add forgotten spin_unlock
Date: Thu,  1 Sep 2011 14:49:04 +0200
Message-Id: <1314881345-6420-18-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1314881345-6420-1-git-send-email-philipp.reisner@linbit.com>
References: <1314881345-6420-1-git-send-email-philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lars Ellenberg <lars.ellenberg@linbit.com>

somehow a "goto abort" was introduced with commit
  drbd: Extracted is_valid_transition() out of sanitize_state()
which left drbd_req_state still holding the spin lock.

Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
---
 drivers/block/drbd/drbd_state.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/block/drbd/drbd_state.c b/drivers/block/drbd/drbd_state.c
index c6a659b..3ca535e 100644
--- a/drivers/block/drbd/drbd_state.c
+++ b/drivers/block/drbd/drbd_state.c
@@ -181,8 +181,10 @@ drbd_req_state(struct drbd_conf *mdev, union drbd_state mask,
 	os = mdev->state;
 	ns = sanitize_state(mdev, apply_mask_val(os, mask, val), NULL);
 	rv = is_valid_transition(os, ns);
-	if (rv < SS_SUCCESS)
+	if (rv < SS_SUCCESS) {
+		spin_unlock_irqrestore(&mdev->tconn->req_lock, flags);
 		goto abort;
+	}
 
 	if (cl_wide_st_chg(mdev, os, ns)) {
 		rv = is_valid_state(mdev, ns);
-- 
1.7.4.1

