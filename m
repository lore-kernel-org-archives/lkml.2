Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754482Ab1HYPWz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Aug 2011 11:22:55 -0400
Received: from mail09.linbit.com ([212.69.161.110]:34594 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753795Ab1HYPJn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Aug 2011 11:09:43 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 069/118] drbd: Converted drbd_try_connect() from mdev to tconn
Date: Thu, 25 Aug 2011 17:08:05 +0200
Message-Id: <1314284934-17999-70-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1314284934-17999-1-git-send-email-philipp.reisner@linbit.com>
References: <1314284934-17999-1-git-send-email-philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
---
 drivers/block/drbd/drbd_receiver.c |   32 ++++++++++++++++----------------
 1 files changed, 16 insertions(+), 16 deletions(-)

diff --git a/drivers/block/drbd/drbd_receiver.c b/drivers/block/drbd/drbd_receiver.c
index 78a05ec..c59858a 100644
--- a/drivers/block/drbd/drbd_receiver.c
+++ b/drivers/block/drbd/drbd_receiver.c
@@ -572,7 +572,7 @@ static void drbd_setbufsize(struct socket *sock, unsigned int snd,
 	}
 }
 
-static struct socket *drbd_try_connect(struct drbd_conf *mdev)
+static struct socket *drbd_try_connect(struct drbd_tconn *tconn)
 {
 	const char *what;
 	struct socket *sock;
@@ -580,11 +580,11 @@ static struct socket *drbd_try_connect(struct drbd_conf *mdev)
 	int err;
 	int disconnect_on_error = 1;
 
-	if (!get_net_conf(mdev->tconn))
+	if (!get_net_conf(tconn))
 		return NULL;
 
 	what = "sock_create_kern";
-	err = sock_create_kern(((struct sockaddr *)mdev->tconn->net_conf->my_addr)->sa_family,
+	err = sock_create_kern(((struct sockaddr *)tconn->net_conf->my_addr)->sa_family,
 		SOCK_STREAM, IPPROTO_TCP, &sock);
 	if (err < 0) {
 		sock = NULL;
@@ -592,9 +592,9 @@ static struct socket *drbd_try_connect(struct drbd_conf *mdev)
 	}
 
 	sock->sk->sk_rcvtimeo =
-	sock->sk->sk_sndtimeo =  mdev->tconn->net_conf->try_connect_int*HZ;
-	drbd_setbufsize(sock, mdev->tconn->net_conf->sndbuf_size,
-			mdev->tconn->net_conf->rcvbuf_size);
+	sock->sk->sk_sndtimeo =  tconn->net_conf->try_connect_int*HZ;
+	drbd_setbufsize(sock, tconn->net_conf->sndbuf_size,
+			tconn->net_conf->rcvbuf_size);
 
        /* explicitly bind to the configured IP as source IP
 	*  for the outgoing connections.
@@ -603,9 +603,9 @@ static struct socket *drbd_try_connect(struct drbd_conf *mdev)
 	* Make sure to use 0 as port number, so linux selects
 	*  a free one dynamically.
 	*/
-	memcpy(&src_in6, mdev->tconn->net_conf->my_addr,
-	       min_t(int, mdev->tconn->net_conf->my_addr_len, sizeof(src_in6)));
-	if (((struct sockaddr *)mdev->tconn->net_conf->my_addr)->sa_family == AF_INET6)
+	memcpy(&src_in6, tconn->net_conf->my_addr,
+	       min_t(int, tconn->net_conf->my_addr_len, sizeof(src_in6)));
+	if (((struct sockaddr *)tconn->net_conf->my_addr)->sa_family == AF_INET6)
 		src_in6.sin6_port = 0;
 	else
 		((struct sockaddr_in *)&src_in6)->sin_port = 0; /* AF_INET & AF_SCI */
@@ -613,7 +613,7 @@ static struct socket *drbd_try_connect(struct drbd_conf *mdev)
 	what = "bind before connect";
 	err = sock->ops->bind(sock,
 			      (struct sockaddr *) &src_in6,
-			      mdev->tconn->net_conf->my_addr_len);
+			      tconn->net_conf->my_addr_len);
 	if (err < 0)
 		goto out;
 
@@ -622,8 +622,8 @@ static struct socket *drbd_try_connect(struct drbd_conf *mdev)
 	disconnect_on_error = 0;
 	what = "connect";
 	err = sock->ops->connect(sock,
-				 (struct sockaddr *)mdev->tconn->net_conf->peer_addr,
-				 mdev->tconn->net_conf->peer_addr_len, 0);
+				 (struct sockaddr *)tconn->net_conf->peer_addr,
+				 tconn->net_conf->peer_addr_len, 0);
 
 out:
 	if (err < 0) {
@@ -641,12 +641,12 @@ out:
 			disconnect_on_error = 0;
 			break;
 		default:
-			dev_err(DEV, "%s failed, err = %d\n", what, err);
+			conn_err(tconn, "%s failed, err = %d\n", what, err);
 		}
 		if (disconnect_on_error)
-			drbd_force_state(mdev, NS(conn, C_DISCONNECTING));
+			drbd_force_state(tconn->volume0, NS(conn, C_DISCONNECTING));
 	}
-	put_net_conf(mdev->tconn);
+	put_net_conf(tconn);
 	return sock;
 }
 
@@ -774,7 +774,7 @@ static int drbd_connect(struct drbd_conf *mdev)
 	do {
 		for (try = 0;;) {
 			/* 3 tries, this should take less than a second! */
-			s = drbd_try_connect(mdev);
+			s = drbd_try_connect(mdev->tconn);
 			if (s || ++try >= 3)
 				break;
 			/* give the other side time to call bind() & listen() */
-- 
1.7.4.1

