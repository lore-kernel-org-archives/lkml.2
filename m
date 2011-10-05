Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934285Ab1JEJj4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Oct 2011 05:39:56 -0400
Received: from mail09.linbit.com ([212.69.161.110]:56232 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934139Ab1JEJiK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Oct 2011 05:38:10 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 10/16] drbd: Introduce a "lockless" variant of drbd_send_protocoll()
Date: Wed,  5 Oct 2011 11:37:58 +0200
Message-Id: <1317807484-24628-11-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1317807484-24628-1-git-send-email-philipp.reisner@linbit.com>
References: <1317807484-24628-1-git-send-email-philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andreas Gruenbacher <agruen@linbit.com>

Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
---
 drivers/block/drbd/drbd_int.h  |    1 +
 drivers/block/drbd/drbd_main.c |   44 ++++++++++++++++++++++++++++++++-------
 2 files changed, 37 insertions(+), 8 deletions(-)

diff --git a/drivers/block/drbd/drbd_int.h b/drivers/block/drbd/drbd_int.h
index e6e4f4e..44f7726 100644
--- a/drivers/block/drbd/drbd_int.h
+++ b/drivers/block/drbd/drbd_int.h
@@ -1051,6 +1051,7 @@ extern int drbd_send(struct drbd_tconn *tconn, struct socket *sock,
 extern int drbd_send_all(struct drbd_tconn *, struct socket *, void *, size_t,
 			 unsigned);
 
+extern int __drbd_send_protocol(struct drbd_tconn *tconn);
 extern int drbd_send_protocol(struct drbd_tconn *tconn);
 extern int drbd_send_uuids(struct drbd_conf *mdev);
 extern int drbd_send_uuids_skip_initial_sync(struct drbd_conf *mdev);
diff --git a/drivers/block/drbd/drbd_main.c b/drivers/block/drbd/drbd_main.c
index 417c437..bcdd66d 100644
--- a/drivers/block/drbd/drbd_main.c
+++ b/drivers/block/drbd/drbd_main.c
@@ -757,14 +757,24 @@ static unsigned int prepare_header(struct drbd_tconn *tconn, int vnr,
 		return prepare_header80(buffer, cmd, size);
 }
 
+static void *__conn_prepare_command(struct drbd_tconn *tconn,
+				    struct drbd_socket *sock)
+{
+	if (!sock->socket)
+		return NULL;
+	return sock->sbuf + drbd_header_size(tconn);
+}
+
 void *conn_prepare_command(struct drbd_tconn *tconn, struct drbd_socket *sock)
 {
+	void *p;
+
 	mutex_lock(&sock->mutex);
-	if (!sock->socket) {
+	p = __conn_prepare_command(tconn, sock);
+	if (!p)
 		mutex_unlock(&sock->mutex);
-		return NULL;
-	}
-	return sock->sbuf + drbd_header_size(tconn);
+
+	return p;
 }
 
 void *drbd_prepare_command(struct drbd_conf *mdev, struct drbd_socket *sock)
@@ -798,13 +808,20 @@ static int __send_command(struct drbd_tconn *tconn, int vnr,
 	return err;
 }
 
+static int __conn_send_command(struct drbd_tconn *tconn, struct drbd_socket *sock,
+			       enum drbd_packet cmd, unsigned int header_size,
+			       void *data, unsigned int size)
+{
+	return __send_command(tconn, 0, sock, cmd, header_size, data, size);
+}
+
 int conn_send_command(struct drbd_tconn *tconn, struct drbd_socket *sock,
 		      enum drbd_packet cmd, unsigned int header_size,
 		      void *data, unsigned int size)
 {
 	int err;
 
-	err = __send_command(tconn, 0, sock, cmd, header_size, data, size);
+	err = __conn_send_command(tconn, sock, cmd, header_size, data, size);
 	mutex_unlock(&sock->mutex);
 	return err;
 }
@@ -893,7 +910,7 @@ int drbd_send_sync_param(struct drbd_conf *mdev)
 	return drbd_send_command(mdev, sock, cmd, size, NULL, 0);
 }
 
-int drbd_send_protocol(struct drbd_tconn *tconn)
+int __drbd_send_protocol(struct drbd_tconn *tconn)
 {
 	struct drbd_socket *sock;
 	struct p_protocol *p;
@@ -901,7 +918,7 @@ int drbd_send_protocol(struct drbd_tconn *tconn)
 	int size, cf;
 
 	sock = &tconn->data;
-	p = conn_prepare_command(tconn, sock);
+	p = __conn_prepare_command(tconn, sock);
 	if (!p)
 		return -EIO;
 
@@ -935,7 +952,18 @@ int drbd_send_protocol(struct drbd_tconn *tconn)
 		strcpy(p->integrity_alg, nc->integrity_alg);
 	rcu_read_unlock();
 
-	return conn_send_command(tconn, sock, P_PROTOCOL, size, NULL, 0);
+	return __conn_send_command(tconn, sock, P_PROTOCOL, size, NULL, 0);
+}
+
+int drbd_send_protocol(struct drbd_tconn *tconn)
+{
+	int err;
+
+	mutex_lock(&tconn->data.mutex);
+	err = __drbd_send_protocol(tconn);
+	mutex_unlock(&tconn->data.mutex);
+
+	return err;
 }
 
 int _drbd_send_uuids(struct drbd_conf *mdev, u64 uuid_flags)
-- 
1.7.4.1

