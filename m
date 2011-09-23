Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754681Ab1IWOcD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Sep 2011 10:32:03 -0400
Received: from mail09.linbit.com ([212.69.161.110]:39560 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754554Ab1IWObb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Sep 2011 10:31:31 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 08/10] drbd: Introduce protocol version 100 headers
Date: Fri, 23 Sep 2011 16:31:23 +0200
Message-Id: <1316788285-17433-9-git-send-email-philipp.reisner@linbit.com>
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
 drivers/block/drbd/drbd_int.h      |    8 ++++++++
 drivers/block/drbd/drbd_main.c     |   31 +++++++++++++++++++++++++------
 drivers/block/drbd/drbd_receiver.c |   14 ++++++++++++--
 include/linux/drbd.h               |    1 +
 4 files changed, 46 insertions(+), 8 deletions(-)

diff --git a/drivers/block/drbd/drbd_int.h b/drivers/block/drbd/drbd_int.h
index 9868518..7d679c5 100644
--- a/drivers/block/drbd/drbd_int.h
+++ b/drivers/block/drbd/drbd_int.h
@@ -307,6 +307,14 @@ struct p_header95 {
 	u32	  vol_n_len;	/* big endian: high byte = volume; remaining 24 bit = length */
 } __packed;
 
+struct p_header100 {
+	u32	  magic;
+	u16	  volume;
+	u16	  command;
+	u32	  length;
+	u32	  pad;
+} __packed;
+
 extern unsigned int drbd_header_size(struct drbd_tconn *tconn);
 
 /* these defines must not be changed without changing the protocol version */
diff --git a/drivers/block/drbd/drbd_main.c b/drivers/block/drbd/drbd_main.c
index 34cdb97..3310986 100644
--- a/drivers/block/drbd/drbd_main.c
+++ b/drivers/block/drbd/drbd_main.c
@@ -698,9 +698,15 @@ void drbd_thread_current_set_cpu(struct drbd_thread *thi)
  */
 unsigned int drbd_header_size(struct drbd_tconn *tconn)
 {
-	BUILD_BUG_ON(sizeof(struct p_header80) != sizeof(struct p_header95));
-	BUILD_BUG_ON(!IS_ALIGNED(sizeof(struct p_header80), 8));
-	return sizeof(struct p_header80);
+	if (tconn->agreed_pro_version >= 100) {
+		BUILD_BUG_ON(!IS_ALIGNED(sizeof(struct p_header100), 8));
+		return sizeof(struct p_header100);
+	} else {
+		BUILD_BUG_ON(sizeof(struct p_header80) !=
+			     sizeof(struct p_header95));
+		BUILD_BUG_ON(!IS_ALIGNED(sizeof(struct p_header80), 8));
+		return sizeof(struct p_header80);
+	}
 }
 
 static unsigned int prepare_header80(struct p_header80 *h, enum drbd_packet cmd, int size)
@@ -719,10 +725,23 @@ static unsigned int prepare_header95(struct p_header95 *h, enum drbd_packet cmd,
 	return sizeof(struct p_header95);
 }
 
-static unsigned int prepare_header(struct drbd_tconn *tconn, int vnr, void *buffer,
-				   enum drbd_packet cmd, int size)
+static unsigned int prepare_header100(struct p_header100 *h, enum drbd_packet cmd,
+				      int size, int vnr)
+{
+	h->magic = cpu_to_be32(DRBD_MAGIC_100);
+	h->volume = cpu_to_be16(vnr);
+	h->command = cpu_to_be16(cmd);
+	h->length = cpu_to_be32(size);
+	h->pad = 0;
+	return sizeof(struct p_header100);
+}
+
+static unsigned int prepare_header(struct drbd_tconn *tconn, int vnr,
+				   void *buffer, enum drbd_packet cmd, int size)
 {
-	if (tconn->agreed_pro_version >= 95)
+	if (tconn->agreed_pro_version >= 100)
+		return prepare_header100(buffer, cmd, size, vnr);
+	else if (tconn->agreed_pro_version >= 95)
 		return prepare_header95(buffer, cmd, size, vnr);
 	else
 		return prepare_header80(buffer, cmd, size);
diff --git a/drivers/block/drbd/drbd_receiver.c b/drivers/block/drbd/drbd_receiver.c
index 0b0f453..de09cc1 100644
--- a/drivers/block/drbd/drbd_receiver.c
+++ b/drivers/block/drbd/drbd_receiver.c
@@ -983,8 +983,18 @@ static int decode_header(struct drbd_tconn *tconn, void *header, struct packet_i
 {
 	unsigned int header_size = drbd_header_size(tconn);
 
-	if (header_size == sizeof(struct p_header95) &&
-	    *(__be16 *)header == cpu_to_be16(DRBD_MAGIC_BIG)) {
+	if (header_size == sizeof(struct p_header100) &&
+	    *(__be32 *)header == cpu_to_be32(DRBD_MAGIC_100)) {
+		struct p_header100 *h = header;
+		if (h->pad != 0) {
+			conn_err(tconn, "Header padding is not zero\n");
+			return -EINVAL;
+		}
+		pi->vnr = be16_to_cpu(h->volume);
+		pi->cmd = be16_to_cpu(h->command);
+		pi->size = be32_to_cpu(h->length);
+	} else if (header_size == sizeof(struct p_header95) &&
+		   *(__be16 *)header == cpu_to_be16(DRBD_MAGIC_BIG)) {
 		struct p_header95 *h = header;
 		u32 vol_n_len;
 
diff --git a/include/linux/drbd.h b/include/linux/drbd.h
index 60d3088..fe8d6ba 100644
--- a/include/linux/drbd.h
+++ b/include/linux/drbd.h
@@ -341,6 +341,7 @@ enum drbd_timeout_flag {
 
 #define DRBD_MAGIC 0x83740267
 #define DRBD_MAGIC_BIG 0x835a
+#define DRBD_MAGIC_100 0x8620ec20
 
 /* how I came up with this magic?
  * base64 decode "actlog==" ;) */
-- 
1.7.4.1

