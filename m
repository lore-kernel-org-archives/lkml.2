Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754667Ab1IWOcA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Sep 2011 10:32:00 -0400
Received: from mail09.linbit.com ([212.69.161.110]:39581 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754558Ab1IWObb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Sep 2011 10:31:31 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 09/10] drbd: Remove volume numbers from struct p_header95
Date: Fri, 23 Sep 2011 16:31:24 +0200
Message-Id: <1316788285-17433-10-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1316788285-17433-1-git-send-email-philipp.reisner@linbit.com>
References: <1316788285-17433-1-git-send-email-philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andreas Gruenbacher <agruen@linbit.com>

Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
---
 drivers/block/drbd/drbd_int.h      |    2 +-
 drivers/block/drbd/drbd_main.c     |    6 +++---
 drivers/block/drbd/drbd_receiver.c |    7 ++-----
 3 files changed, 6 insertions(+), 9 deletions(-)

diff --git a/drivers/block/drbd/drbd_int.h b/drivers/block/drbd/drbd_int.h
index 7d679c5..8f67093 100644
--- a/drivers/block/drbd/drbd_int.h
+++ b/drivers/block/drbd/drbd_int.h
@@ -304,7 +304,7 @@ struct p_header80 {
 struct p_header95 {
 	u16	  magic;	/* use DRBD_MAGIC_BIG here */
 	u16	  command;
-	u32	  vol_n_len;	/* big endian: high byte = volume; remaining 24 bit = length */
+	u32	  length;
 } __packed;
 
 struct p_header100 {
diff --git a/drivers/block/drbd/drbd_main.c b/drivers/block/drbd/drbd_main.c
index 3310986..99b467e 100644
--- a/drivers/block/drbd/drbd_main.c
+++ b/drivers/block/drbd/drbd_main.c
@@ -717,11 +717,11 @@ static unsigned int prepare_header80(struct p_header80 *h, enum drbd_packet cmd,
 	return sizeof(struct p_header80);
 }
 
-static unsigned int prepare_header95(struct p_header95 *h, enum drbd_packet cmd, int size, int vnr)
+static unsigned int prepare_header95(struct p_header95 *h, enum drbd_packet cmd, int size)
 {
 	h->magic   = cpu_to_be16(DRBD_MAGIC_BIG);
 	h->command = cpu_to_be16(cmd);
-	h->vol_n_len = cpu_to_be32(vnr << 24 | size);
+	h->length = cpu_to_be32(size);
 	return sizeof(struct p_header95);
 }
 
@@ -742,7 +742,7 @@ static unsigned int prepare_header(struct drbd_tconn *tconn, int vnr,
 	if (tconn->agreed_pro_version >= 100)
 		return prepare_header100(buffer, cmd, size, vnr);
 	else if (tconn->agreed_pro_version >= 95)
-		return prepare_header95(buffer, cmd, size, vnr);
+		return prepare_header95(buffer, cmd, size);
 	else
 		return prepare_header80(buffer, cmd, size);
 }
diff --git a/drivers/block/drbd/drbd_receiver.c b/drivers/block/drbd/drbd_receiver.c
index de09cc1..7539253 100644
--- a/drivers/block/drbd/drbd_receiver.c
+++ b/drivers/block/drbd/drbd_receiver.c
@@ -996,12 +996,9 @@ static int decode_header(struct drbd_tconn *tconn, void *header, struct packet_i
 	} else if (header_size == sizeof(struct p_header95) &&
 		   *(__be16 *)header == cpu_to_be16(DRBD_MAGIC_BIG)) {
 		struct p_header95 *h = header;
-		u32 vol_n_len;
-
 		pi->cmd = be16_to_cpu(h->command);
-		vol_n_len = be32_to_cpu(h->vol_n_len);
-		pi->size = vol_n_len & 0x00ffffff;
-		pi->vnr  = vol_n_len >> 24;
+		pi->size = be32_to_cpu(h->length);
+		pi->vnr = 0;
 	} else if (header_size == sizeof(struct p_header80) &&
 		   *(__be32 *)header == cpu_to_be32(DRBD_MAGIC)) {
 		struct p_header80 *h = header;
-- 
1.7.4.1

