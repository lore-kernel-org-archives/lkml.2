Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754622Ab1IWObg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Sep 2011 10:31:36 -0400
Received: from mail09.linbit.com ([212.69.161.110]:39504 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754455Ab1IWOb2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Sep 2011 10:31:28 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 03/10] drbd: Introduce drbd_header_size()
Date: Fri, 23 Sep 2011 16:31:18 +0200
Message-Id: <1316788285-17433-4-git-send-email-philipp.reisner@linbit.com>
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
 drivers/block/drbd/drbd_int.h      |    2 ++
 drivers/block/drbd/drbd_main.c     |   14 ++++++++++++++
 drivers/block/drbd/drbd_receiver.c |    9 +++++----
 3 files changed, 21 insertions(+), 4 deletions(-)

diff --git a/drivers/block/drbd/drbd_int.h b/drivers/block/drbd/drbd_int.h
index d61819f..29db016 100644
--- a/drivers/block/drbd/drbd_int.h
+++ b/drivers/block/drbd/drbd_int.h
@@ -315,6 +315,8 @@ struct p_header {
 	u8	  payload[0];
 };
 
+extern unsigned int drbd_header_size(struct drbd_tconn *tconn);
+
 /*
  * short commands, packets without payload, plain p_header:
  *   P_PING
diff --git a/drivers/block/drbd/drbd_main.c b/drivers/block/drbd/drbd_main.c
index c8384cd..b291d73 100644
--- a/drivers/block/drbd/drbd_main.c
+++ b/drivers/block/drbd/drbd_main.c
@@ -689,6 +689,20 @@ void drbd_thread_current_set_cpu(struct drbd_thread *thi)
 }
 #endif
 
+/**
+ * drbd_header_size  -  size of a packet header
+ *
+ * The header size is a multiple of 8, so any payload following the header is
+ * word aligned on 64-bit architectures.  (The bitmap send and receive code
+ * relies on this.)
+ */
+unsigned int drbd_header_size(struct drbd_tconn *tconn)
+{
+	BUILD_BUG_ON(sizeof(struct p_header80) != sizeof(struct p_header95));
+	BUILD_BUG_ON(!IS_ALIGNED(sizeof(struct p_header80), 8));
+	return sizeof(struct p_header80);
+}
+
 static void prepare_header80(struct p_header80 *h, enum drbd_packet cmd, int size)
 {
 	h->magic   = cpu_to_be32(DRBD_MAGIC);
diff --git a/drivers/block/drbd/drbd_receiver.c b/drivers/block/drbd/drbd_receiver.c
index 6879082..ceca24f 100644
--- a/drivers/block/drbd/drbd_receiver.c
+++ b/drivers/block/drbd/drbd_receiver.c
@@ -998,7 +998,7 @@ static int drbd_recv_header(struct drbd_tconn *tconn, struct packet_info *pi)
 	struct p_header *h = tconn->data.rbuf;
 	int err;
 
-	err = drbd_recv_all_warn(tconn, h, sizeof(*h));
+	err = drbd_recv_all_warn(tconn, h, drbd_header_size(tconn));
 	if (err)
 		return err;
 
@@ -4845,7 +4845,8 @@ int drbd_asender(struct drbd_thread *thi)
 	int rv;
 	void *buf    = h;
 	int received = 0;
-	int expect   = sizeof(struct p_header);
+	unsigned int header_size = drbd_header_size(tconn);
+	int expect   = header_size;
 	int ping_timeout_active = 0;
 
 	current->policy = SCHED_RR;  /* Make this a realtime task! */
@@ -4929,7 +4930,7 @@ int drbd_asender(struct drbd_thread *thi)
 				goto disconnect;
 			}
 			expect = cmd->pkt_size;
-			if (pi.size != expect - sizeof(struct p_header)) {
+			if (pi.size != expect - header_size) {
 				conn_err(tconn, "Wrong packet size on meta (c: %d, l: %d)\n",
 					pi.cmd, pi.size);
 				goto reconnect;
@@ -4953,7 +4954,7 @@ int drbd_asender(struct drbd_thread *thi)
 
 			buf	 = h;
 			received = 0;
-			expect	 = sizeof(struct p_header);
+			expect	 = header_size;
 			cmd	 = NULL;
 		}
 	}
-- 
1.7.4.1

