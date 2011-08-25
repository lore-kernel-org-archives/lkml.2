Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752692Ab1HYPjT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Aug 2011 11:39:19 -0400
Received: from mail09.linbit.com ([212.69.161.110]:32913 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753012Ab1HYPI7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Aug 2011 11:08:59 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 004/118] drbd: Get rid of BE_DRBD_MAGIC and BE_DRBD_MAGIC_BIG
Date: Thu, 25 Aug 2011 17:07:00 +0200
Message-Id: <1314284934-17999-5-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1314284934-17999-1-git-send-email-philipp.reisner@linbit.com>
References: <1314284934-17999-1-git-send-email-philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andreas Gruenbacher <agruen@linbit.com>

Converting the constants happens at compile time.

Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
---
 drivers/block/drbd/drbd_main.c     |   14 +++++++-------
 drivers/block/drbd/drbd_receiver.c |    8 ++++----
 include/linux/drbd.h               |    2 --
 3 files changed, 11 insertions(+), 13 deletions(-)

diff --git a/drivers/block/drbd/drbd_main.c b/drivers/block/drbd/drbd_main.c
index 0c16620..2cd132a 100644
--- a/drivers/block/drbd/drbd_main.c
+++ b/drivers/block/drbd/drbd_main.c
@@ -1841,7 +1841,7 @@ int _drbd_send_cmd(struct drbd_conf *mdev, struct socket *sock,
 	ERR_IF(!h) return false;
 	ERR_IF(!size) return false;
 
-	h->magic   = BE_DRBD_MAGIC;
+	h->magic   = cpu_to_be32(DRBD_MAGIC);
 	h->command = cpu_to_be16(cmd);
 	h->length  = cpu_to_be16(size-sizeof(struct p_header80));
 
@@ -1889,7 +1889,7 @@ int drbd_send_cmd2(struct drbd_conf *mdev, enum drbd_packets cmd, char *data,
 	struct p_header80 h;
 	int ok;
 
-	h.magic   = BE_DRBD_MAGIC;
+	h.magic   = cpu_to_be32(DRBD_MAGIC);
 	h.command = cpu_to_be16(cmd);
 	h.length  = cpu_to_be16(size);
 
@@ -2477,7 +2477,7 @@ int drbd_send_drequest_csum(struct drbd_conf *mdev,
 	p.block_id = ID_SYNCER /* unused */;
 	p.blksize  = cpu_to_be32(size);
 
-	p.head.magic   = BE_DRBD_MAGIC;
+	p.head.magic   = cpu_to_be32(DRBD_MAGIC);
 	p.head.command = cpu_to_be16(cmd);
 	p.head.length  = cpu_to_be16(sizeof(p) - sizeof(struct p_header80) + digest_size);
 
@@ -2682,12 +2682,12 @@ int drbd_send_dblock(struct drbd_conf *mdev, struct drbd_request *req)
 		crypto_hash_digestsize(mdev->integrity_w_tfm) : 0;
 
 	if (req->size <= DRBD_MAX_SIZE_H80_PACKET) {
-		p.head.h80.magic   = BE_DRBD_MAGIC;
+		p.head.h80.magic   = cpu_to_be32(DRBD_MAGIC);
 		p.head.h80.command = cpu_to_be16(P_DATA);
 		p.head.h80.length  =
 			cpu_to_be16(sizeof(p) - sizeof(union p_header) + dgs + req->size);
 	} else {
-		p.head.h95.magic   = BE_DRBD_MAGIC_BIG;
+		p.head.h95.magic   = cpu_to_be16(DRBD_MAGIC_BIG);
 		p.head.h95.command = cpu_to_be16(P_DATA);
 		p.head.h95.length  =
 			cpu_to_be32(sizeof(p) - sizeof(union p_header) + dgs + req->size);
@@ -2767,12 +2767,12 @@ int drbd_send_block(struct drbd_conf *mdev, enum drbd_packets cmd,
 		crypto_hash_digestsize(mdev->integrity_w_tfm) : 0;
 
 	if (e->size <= DRBD_MAX_SIZE_H80_PACKET) {
-		p.head.h80.magic   = BE_DRBD_MAGIC;
+		p.head.h80.magic   = cpu_to_be32(DRBD_MAGIC);
 		p.head.h80.command = cpu_to_be16(cmd);
 		p.head.h80.length  =
 			cpu_to_be16(sizeof(p) - sizeof(struct p_header80) + dgs + e->size);
 	} else {
-		p.head.h95.magic   = BE_DRBD_MAGIC_BIG;
+		p.head.h95.magic   = cpu_to_be16(DRBD_MAGIC_BIG);
 		p.head.h95.command = cpu_to_be16(cmd);
 		p.head.h95.length  =
 			cpu_to_be32(sizeof(p) - sizeof(struct p_header80) + dgs + e->size);
diff --git a/drivers/block/drbd/drbd_receiver.c b/drivers/block/drbd/drbd_receiver.c
index 5ed9619..69eec69 100644
--- a/drivers/block/drbd/drbd_receiver.c
+++ b/drivers/block/drbd/drbd_receiver.c
@@ -712,7 +712,7 @@ static enum drbd_packets drbd_recv_fp(struct drbd_conf *mdev, struct socket *soc
 
 	rr = drbd_recv_short(mdev, sock, h, sizeof(*h), 0);
 
-	if (rr == sizeof(*h) && h->magic == BE_DRBD_MAGIC)
+	if (rr == sizeof(*h) && h->magic == cpu_to_be32(DRBD_MAGIC))
 		return be16_to_cpu(h->command);
 
 	return 0xffff;
@@ -935,10 +935,10 @@ static int drbd_recv_header(struct drbd_conf *mdev, enum drbd_packets *cmd, unsi
 		return false;
 	}
 
-	if (likely(h->h80.magic == BE_DRBD_MAGIC)) {
+	if (likely(h->h80.magic == cpu_to_be32(DRBD_MAGIC))) {
 		*cmd = be16_to_cpu(h->h80.command);
 		*packet_size = be16_to_cpu(h->h80.length);
-	} else if (h->h95.magic == BE_DRBD_MAGIC_BIG) {
+	} else if (h->h95.magic == cpu_to_be16(DRBD_MAGIC_BIG)) {
 		*cmd = be16_to_cpu(h->h95.command);
 		*packet_size = be32_to_cpu(h->h95.length);
 	} else {
@@ -4623,7 +4623,7 @@ int drbd_asender(struct drbd_thread *thi)
 		}
 
 		if (received == expect && cmd == NULL) {
-			if (unlikely(h->magic != BE_DRBD_MAGIC)) {
+			if (unlikely(h->magic != cpu_to_be32(DRBD_MAGIC))) {
 				dev_err(DEV, "magic?? on meta m: 0x%08x c: %d l: %d\n",
 				    be32_to_cpu(h->magic),
 				    be16_to_cpu(h->command),
diff --git a/include/linux/drbd.h b/include/linux/drbd.h
index 9e5f560..d282028 100644
--- a/include/linux/drbd.h
+++ b/include/linux/drbd.h
@@ -334,9 +334,7 @@ enum drbd_timeout_flag {
 #define UUID_JUST_CREATED ((__u64)4)
 
 #define DRBD_MAGIC 0x83740267
-#define BE_DRBD_MAGIC __constant_cpu_to_be32(DRBD_MAGIC)
 #define DRBD_MAGIC_BIG 0x835a
-#define BE_DRBD_MAGIC_BIG __constant_cpu_to_be16(DRBD_MAGIC_BIG)
 
 /* these are of type "int" */
 #define DRBD_MD_INDEX_INTERNAL -1
-- 
1.7.4.1

