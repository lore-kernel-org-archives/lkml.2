Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756336Ab1HaPLW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Aug 2011 11:11:22 -0400
Received: from mail09.linbit.com ([212.69.161.110]:59852 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756093Ab1HaPLN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Aug 2011 11:11:13 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 03/16] drbd: Use ping-timeout when waiting for missing ack packets
Date: Wed, 31 Aug 2011 17:10:55 +0200
Message-Id: <1314803468-1201-4-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1314803468-1201-1-git-send-email-philipp.reisner@linbit.com>
References: <1314803468-1201-1-git-send-email-philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andreas Gruenbacher <agruen@linbit.com>

When the node with the discard flag resolves write conflicts in
dual-primary mode, it may determine that its peer has sent ack packets
on the metadata socket which did not arrive, yet.  Wait for the next ack
with ping-timeout instead of a hard-coded 30 seconds.

Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
---
 drivers/block/drbd/drbd_receiver.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/block/drbd/drbd_receiver.c b/drivers/block/drbd/drbd_receiver.c
index 987af1a..07fc7c1 100644
--- a/drivers/block/drbd/drbd_receiver.c
+++ b/drivers/block/drbd/drbd_receiver.c
@@ -1713,11 +1713,12 @@ static int drbd_wait_peer_seq(struct drbd_conf *mdev, const u32 packet_seq)
 		}
 		p_seq = mdev->peer_seq;
 		spin_unlock(&mdev->peer_seq_lock);
-		timeout = schedule_timeout(30*HZ);
+		timeout = mdev->tconn->net_conf->ping_timeo*HZ/10;
+		timeout = schedule_timeout(timeout);
 		spin_lock(&mdev->peer_seq_lock);
 		if (timeout == 0 && p_seq == mdev->peer_seq) {
 			ret = -ETIMEDOUT;
-			dev_err(DEV, "ASSERT FAILED waited 30 seconds for sequence update, forcing reconnect\n");
+			dev_err(DEV, "Timed out waiting for missing ack packets; disconnecting\n");
 			break;
 		}
 	}
-- 
1.7.4.1

