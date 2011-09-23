Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754719Ab1IWOdr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Sep 2011 10:33:47 -0400
Received: from mail09.linbit.com ([212.69.161.110]:39502 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753994Ab1IWOb3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Sep 2011 10:31:29 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 02/10] drbd: Introduce new primitives for sending commands
Date: Fri, 23 Sep 2011 16:31:17 +0200
Message-Id: <1316788285-17433-3-git-send-email-philipp.reisner@linbit.com>
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
 drivers/block/drbd/drbd_int.h  |    9 +++++
 drivers/block/drbd/drbd_main.c |   64 ++++++++++++++++++++++++++++++++++++++++
 2 files changed, 73 insertions(+), 0 deletions(-)

diff --git a/drivers/block/drbd/drbd_int.h b/drivers/block/drbd/drbd_int.h
index 912ee5e..d61819f 100644
--- a/drivers/block/drbd/drbd_int.h
+++ b/drivers/block/drbd/drbd_int.h
@@ -1903,6 +1903,15 @@ static inline int drbd_send_short_cmd(struct drbd_conf *mdev,
 	return drbd_send_cmd(mdev, &mdev->tconn->data, cmd, &h, sizeof(h));
 }
 
+extern void *conn_prepare_command(struct drbd_tconn *, struct drbd_socket *);
+extern void *drbd_prepare_command(struct drbd_conf *, struct drbd_socket *);
+extern int conn_send_command(struct drbd_tconn *, struct drbd_socket *,
+			     enum drbd_packet, unsigned int, void *,
+			     unsigned int);
+extern int drbd_send_command(struct drbd_conf *, struct drbd_socket *,
+			     enum drbd_packet, unsigned int, void *,
+			     unsigned int);
+
 extern int drbd_send_ping(struct drbd_tconn *tconn);
 extern int drbd_send_ping_ack(struct drbd_tconn *tconn);
 
diff --git a/drivers/block/drbd/drbd_main.c b/drivers/block/drbd/drbd_main.c
index 7d7b30c..c8384cd 100644
--- a/drivers/block/drbd/drbd_main.c
+++ b/drivers/block/drbd/drbd_main.c
@@ -765,6 +765,70 @@ int conn_send_cmd2(struct drbd_tconn *tconn, enum drbd_packet cmd, char *data,
 	return err;
 }
 
+void *conn_prepare_command(struct drbd_tconn *tconn, struct drbd_socket *sock)
+{
+	mutex_lock(&sock->mutex);
+	if (!sock->socket) {
+		mutex_unlock(&sock->mutex);
+		return NULL;
+	}
+	return sock->sbuf;
+}
+
+void *drbd_prepare_command(struct drbd_conf *mdev, struct drbd_socket *sock)
+{
+	return conn_prepare_command(mdev->tconn, sock);
+}
+
+static int __send_command(struct drbd_tconn *tconn, int vnr,
+			  struct drbd_socket *sock, enum drbd_packet cmd,
+			  unsigned int header_size, void *data,
+			  unsigned int size)
+{
+	int msg_flags;
+	int err;
+
+	/*
+	 * Called with @data == NULL and the size of the data blocks in @size
+	 * for commands that send data blocks.  For those commands, omit the
+	 * MSG_MORE flag: this will increase the likelihood that data blocks
+	 * which are page aligned on the sender will end up page aligned on the
+	 * receiver.
+	 */
+	msg_flags = data ? MSG_MORE : 0;
+
+	_prepare_header(tconn, vnr, sock->sbuf, cmd,
+			header_size - sizeof(struct p_header) + size);
+	err = drbd_send_all(tconn, sock->socket, sock->sbuf, header_size,
+			    msg_flags);
+	if (data && !err)
+		err = drbd_send_all(tconn, sock->socket, data, size, 0);
+	return err;
+}
+
+int conn_send_command(struct drbd_tconn *tconn, struct drbd_socket *sock,
+		      enum drbd_packet cmd, unsigned int header_size,
+		      void *data, unsigned int size)
+{
+	int err;
+
+	err = __send_command(tconn, 0, sock, cmd, header_size, data, size);
+	mutex_unlock(&sock->mutex);
+	return err;
+}
+
+int drbd_send_command(struct drbd_conf *mdev, struct drbd_socket *sock,
+		      enum drbd_packet cmd, unsigned int header_size,
+		      void *data, unsigned int size)
+{
+	int err;
+
+	err = __send_command(mdev->tconn, mdev->vnr, sock, cmd, header_size,
+			     data, size);
+	mutex_unlock(&sock->mutex);
+	return err;
+}
+
 int drbd_send_ping(struct drbd_tconn *tconn)
 {
 	struct p_header h;
-- 
1.7.4.1

