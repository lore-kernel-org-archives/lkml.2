Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754378Ab1HYPSN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Aug 2011 11:18:13 -0400
Received: from mail09.linbit.com ([212.69.161.110]:34374 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753893Ab1HYPJw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Aug 2011 11:09:52 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 084/118] drbd: Converted decode_header() from mdev to tconn
Date: Thu, 25 Aug 2011 17:08:20 +0200
Message-Id: <1314284934-17999-85-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1314284934-17999-1-git-send-email-philipp.reisner@linbit.com>
References: <1314284934-17999-1-git-send-email-philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
---
 drivers/block/drbd/drbd_receiver.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/block/drbd/drbd_receiver.c b/drivers/block/drbd/drbd_receiver.c
index deb0837..66b35e9 100644
--- a/drivers/block/drbd/drbd_receiver.c
+++ b/drivers/block/drbd/drbd_receiver.c
@@ -930,7 +930,7 @@ out_release_sockets:
 	return -1;
 }
 
-static bool decode_header(struct drbd_conf *mdev, struct p_header *h, struct packet_info *pi)
+static bool decode_header(struct drbd_tconn *tconn, struct p_header *h, struct packet_info *pi)
 {
 	u32 vol_n_len;
 
@@ -943,7 +943,7 @@ static bool decode_header(struct drbd_conf *mdev, struct p_header *h, struct pac
 		pi->size = vol_n_len & 0x00ffffff;
 		pi->vnr  = vol_n_len >> 24;
 	} else {
-		dev_err(DEV, "magic?? on data m: 0x%08x c: %d l: %d\n",
+		conn_err(tconn, "magic?? on data m: 0x%08x c: %d l: %d\n",
 		    be32_to_cpu(h->h80.magic),
 		    be16_to_cpu(h->h80.command),
 		    be16_to_cpu(h->h80.length));
@@ -964,7 +964,7 @@ static int drbd_recv_header(struct drbd_conf *mdev, struct packet_info *pi)
 		return false;
 	}
 
-	r = decode_header(mdev, h, pi);
+	r = decode_header(mdev->tconn, h, pi);
 	mdev->tconn->last_received = jiffies;
 
 	return r;
@@ -4648,7 +4648,7 @@ int drbd_asender(struct drbd_thread *thi)
 		}
 
 		if (received == expect && cmd == NULL) {
-			if (!decode_header(mdev, h, &pi))
+			if (!decode_header(mdev->tconn, h, &pi))
 				goto reconnect;
 			cmd = get_asender_cmd(pi.cmd);
 			if (unlikely(cmd == NULL)) {
-- 
1.7.4.1

