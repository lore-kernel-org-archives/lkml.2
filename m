Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754090Ab1IGQv1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Sep 2011 12:51:27 -0400
Received: from mail09.linbit.com ([212.69.161.110]:48572 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753347Ab1IGQp6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Sep 2011 12:45:58 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 02/14] drbd: Always use the same protocol version for the same peer
Date: Wed,  7 Sep 2011 16:17:29 +0200
Message-Id: <1315405061-1473-3-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1315405061-1473-1-git-send-email-philipp.reisner@linbit.com>
References: <1315405061-1473-1-git-send-email-philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andreas Gruenbacher <agruen@linbit.com>

There is no need to send protocol 80 headers to peers that understand
protocol 95 headers.  Make sure that we don't send protocol 95 headers
until we have agreed upon a protocol version with our peer, though.

Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
---
 drivers/block/drbd/drbd_main.c     |    2 +-
 drivers/block/drbd/drbd_receiver.c |    6 +++---
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/block/drbd/drbd_main.c b/drivers/block/drbd/drbd_main.c
index e36d32c..0028b60ca 100644
--- a/drivers/block/drbd/drbd_main.c
+++ b/drivers/block/drbd/drbd_main.c
@@ -706,7 +706,7 @@ static void prepare_header95(struct p_header95 *h, enum drbd_packet cmd, int siz
 static void _prepare_header(struct drbd_tconn *tconn, int vnr, struct p_header *h,
 			    enum drbd_packet cmd, int size)
 {
-	if (tconn->agreed_pro_version >= 100 || size > DRBD_MAX_SIZE_H80_PACKET)
+	if (tconn->agreed_pro_version >= 95)
 		prepare_header95(&h->h95, cmd, size, vnr);
 	else
 		prepare_header80(&h->h80, cmd, size);
diff --git a/drivers/block/drbd/drbd_receiver.c b/drivers/block/drbd/drbd_receiver.c
index 2253423..48e073a 100644
--- a/drivers/block/drbd/drbd_receiver.c
+++ b/drivers/block/drbd/drbd_receiver.c
@@ -819,9 +819,9 @@ static int drbd_connect(struct drbd_tconn *tconn)
 		return -2;
 
 	clear_bit(DISCARD_CONCURRENT, &tconn->flags);
-	tconn->agreed_pro_version = 99;
-	/* agreed_pro_version must be smaller than 100 so we send the old
-	   header (h80) in the first packet and in the handshake packet. */
+
+	/* Assume that the peer only understands protocol 80 until we know better.  */
+	tconn->agreed_pro_version = 80;
 
 	sock  = NULL;
 	msock = NULL;
-- 
1.7.4.1

