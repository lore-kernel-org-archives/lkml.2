Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752964Ab1IELqv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Sep 2011 07:46:51 -0400
Received: from mail09.linbit.com ([212.69.161.110]:60226 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752791Ab1IELqG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Sep 2011 07:46:06 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 38/54] drbd: decode_header(): Return 0 upon success and an error code otherwise
Date: Mon,  5 Sep 2011 13:45:29 +0200
Message-Id: <1315223145-20640-39-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1315223145-20640-1-git-send-email-philipp.reisner@linbit.com>
References: <1315223145-20640-1-git-send-email-philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andreas Gruenbacher <agruen@linbit.com>

Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
---
 drivers/block/drbd/drbd_receiver.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/block/drbd/drbd_receiver.c b/drivers/block/drbd/drbd_receiver.c
index 8000637..47c9c4d 100644
--- a/drivers/block/drbd/drbd_receiver.c
+++ b/drivers/block/drbd/drbd_receiver.c
@@ -948,7 +948,7 @@ out_release_sockets:
 	return -1;
 }
 
-static bool decode_header(struct drbd_tconn *tconn, struct p_header *h, struct packet_info *pi)
+static int decode_header(struct drbd_tconn *tconn, struct p_header *h, struct packet_info *pi)
 {
 	u32 vol_n_len;
 
@@ -966,9 +966,9 @@ static bool decode_header(struct drbd_tconn *tconn, struct p_header *h, struct p
 		    be32_to_cpu(h->h80.magic),
 		    be16_to_cpu(h->h80.command),
 		    be16_to_cpu(h->h80.length));
-		return false;
+		return -EINVAL;
 	}
-	return true;
+	return 0;
 }
 
 static int drbd_recv_header(struct drbd_tconn *tconn, struct packet_info *pi)
@@ -983,7 +983,7 @@ static int drbd_recv_header(struct drbd_tconn *tconn, struct packet_info *pi)
 		return false;
 	}
 
-	r = decode_header(tconn, h, pi);
+	r = !decode_header(tconn, h, pi);
 	tconn->last_received = jiffies;
 
 	return r;
@@ -4843,7 +4843,7 @@ int drbd_asender(struct drbd_thread *thi)
 		}
 
 		if (received == expect && cmd == NULL) {
-			if (!decode_header(tconn, h, &pi))
+			if (decode_header(tconn, h, &pi))
 				goto reconnect;
 			cmd = &asender_tbl[pi.cmd];
 			if (pi.cmd >= ARRAY_SIZE(asender_tbl) || !cmd) {
-- 
1.7.4.1

