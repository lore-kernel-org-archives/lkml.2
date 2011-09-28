Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753973Ab1I1JVl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 05:21:41 -0400
Received: from mail09.linbit.com ([212.69.161.110]:50236 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751713Ab1I1JVk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 05:21:40 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: Kyle Moffett <kyle@moffetthome.net>, linux-kernel@vger.kernel.org,
        Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 9/9] drbd: Removed outdated comments and code that envisioned VNRs in header 95
Date: Wed, 28 Sep 2011 11:21:38 +0200
Message-Id: <1317201698-7776-1-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <201109281120.07349.philipp.reisner@linbit.com>
References: <201109281120.07349.philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andreas Gruenbacher <agruen@linbit.com>

Since have now header 100, that has space for 16 bit volume numbers,
the high byte of the length in header 95 is no longer reserved for
8 bit volume numbers.

Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
---
 drivers/block/drbd/drbd_int.h      |    2 +-
 drivers/block/drbd/drbd_main.c     |    2 +-
 drivers/block/drbd/drbd_receiver.c |    5 ++---
 3 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/block/drbd/drbd_int.h b/drivers/block/drbd/drbd_int.h
index 2fcf370..8f67093 100644
--- a/drivers/block/drbd/drbd_int.h
+++ b/drivers/block/drbd/drbd_int.h
@@ -304,7 +304,7 @@ struct p_header80 {
 struct p_header95 {
 	u16	  magic;	/* use DRBD_MAGIC_BIG here */
 	u16	  command;
-	u32	  length;	/* Use only 24 bits of that. Ignore the highest 8 bit. */
+	u32	  length;
 } __packed;
 
 struct p_header100 {
diff --git a/drivers/block/drbd/drbd_main.c b/drivers/block/drbd/drbd_main.c
index 2c75a03..6afcfab 100644
--- a/drivers/block/drbd/drbd_main.c
+++ b/drivers/block/drbd/drbd_main.c
@@ -721,7 +721,7 @@ static unsigned int prepare_header95(struct p_header95 *h, enum drbd_packet cmd,
 {
 	h->magic   = cpu_to_be16(DRBD_MAGIC_BIG);
 	h->command = cpu_to_be16(cmd);
-	h->length  = cpu_to_be32(size);
+	h->length = cpu_to_be32(size);
 	return sizeof(struct p_header95);
 }
 
diff --git a/drivers/block/drbd/drbd_receiver.c b/drivers/block/drbd/drbd_receiver.c
index 80bbc55..7539253 100644
--- a/drivers/block/drbd/drbd_receiver.c
+++ b/drivers/block/drbd/drbd_receiver.c
@@ -996,10 +996,9 @@ static int decode_header(struct drbd_tconn *tconn, void *header, struct packet_i
 	} else if (header_size == sizeof(struct p_header95) &&
 		   *(__be16 *)header == cpu_to_be16(DRBD_MAGIC_BIG)) {
 		struct p_header95 *h = header;
-
 		pi->cmd = be16_to_cpu(h->command);
-		pi->size = be32_to_cpu(h->length) & 0x00ffffff;
-		pi->vnr  = 0;
+		pi->size = be32_to_cpu(h->length);
+		pi->vnr = 0;
 	} else if (header_size == sizeof(struct p_header80) &&
 		   *(__be32 *)header == cpu_to_be32(DRBD_MAGIC)) {
 		struct p_header80 *h = header;
-- 
1.7.4.1

