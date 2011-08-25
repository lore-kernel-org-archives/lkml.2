Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753869Ab1HYPJs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Aug 2011 11:09:48 -0400
Received: from mail09.linbit.com ([212.69.161.110]:34634 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753797Ab1HYPJn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Aug 2011 11:09:43 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 070/118] drbd: Converted drbd_wait_for_connect() from mdev to tconn
Date: Thu, 25 Aug 2011 17:08:06 +0200
Message-Id: <1314284934-17999-71-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1314284934-17999-1-git-send-email-philipp.reisner@linbit.com>
References: <1314284934-17999-1-git-send-email-philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
---
 drivers/block/drbd/drbd_receiver.c |   29 ++++++++++++++---------------
 1 files changed, 14 insertions(+), 15 deletions(-)

diff --git a/drivers/block/drbd/drbd_receiver.c b/drivers/block/drbd/drbd_receiver.c
index c59858a..83066a3 100644
--- a/drivers/block/drbd/drbd_receiver.c
+++ b/drivers/block/drbd/drbd_receiver.c
@@ -447,8 +447,7 @@ void drbd_wait_ee_list_empty(struct drbd_conf *mdev, struct list_head *head)
 
 /* see also kernel_accept; which is only present since 2.6.18.
  * also we want to log which part of it failed, exactly */
-static int drbd_accept(struct drbd_conf *mdev, const char **what,
-		struct socket *sock, struct socket **newsock)
+static int drbd_accept(const char **what, struct socket *sock, struct socket **newsock)
 {
 	struct sock *sk = sock->sk;
 	int err = 0;
@@ -650,51 +649,51 @@ out:
 	return sock;
 }
 
-static struct socket *drbd_wait_for_connect(struct drbd_conf *mdev)
+static struct socket *drbd_wait_for_connect(struct drbd_tconn *tconn)
 {
 	int timeo, err;
 	struct socket *s_estab = NULL, *s_listen;
 	const char *what;
 
-	if (!get_net_conf(mdev->tconn))
+	if (!get_net_conf(tconn))
 		return NULL;
 
 	what = "sock_create_kern";
-	err = sock_create_kern(((struct sockaddr *)mdev->tconn->net_conf->my_addr)->sa_family,
+	err = sock_create_kern(((struct sockaddr *)tconn->net_conf->my_addr)->sa_family,
 		SOCK_STREAM, IPPROTO_TCP, &s_listen);
 	if (err) {
 		s_listen = NULL;
 		goto out;
 	}
 
-	timeo = mdev->tconn->net_conf->try_connect_int * HZ;
+	timeo = tconn->net_conf->try_connect_int * HZ;
 	timeo += (random32() & 1) ? timeo / 7 : -timeo / 7; /* 28.5% random jitter */
 
 	s_listen->sk->sk_reuse    = 1; /* SO_REUSEADDR */
 	s_listen->sk->sk_rcvtimeo = timeo;
 	s_listen->sk->sk_sndtimeo = timeo;
-	drbd_setbufsize(s_listen, mdev->tconn->net_conf->sndbuf_size,
-			mdev->tconn->net_conf->rcvbuf_size);
+	drbd_setbufsize(s_listen, tconn->net_conf->sndbuf_size,
+			tconn->net_conf->rcvbuf_size);
 
 	what = "bind before listen";
 	err = s_listen->ops->bind(s_listen,
-			      (struct sockaddr *) mdev->tconn->net_conf->my_addr,
-			      mdev->tconn->net_conf->my_addr_len);
+			      (struct sockaddr *) tconn->net_conf->my_addr,
+			      tconn->net_conf->my_addr_len);
 	if (err < 0)
 		goto out;
 
-	err = drbd_accept(mdev, &what, s_listen, &s_estab);
+	err = drbd_accept(&what, s_listen, &s_estab);
 
 out:
 	if (s_listen)
 		sock_release(s_listen);
 	if (err < 0) {
 		if (err != -EAGAIN && err != -EINTR && err != -ERESTARTSYS) {
-			dev_err(DEV, "%s failed, err = %d\n", what, err);
-			drbd_force_state(mdev, NS(conn, C_DISCONNECTING));
+			conn_err(tconn, "%s failed, err = %d\n", what, err);
+			drbd_force_state(tconn->volume0, NS(conn, C_DISCONNECTING));
 		}
 	}
-	put_net_conf(mdev->tconn);
+	put_net_conf(tconn);
 
 	return s_estab;
 }
@@ -805,7 +804,7 @@ static int drbd_connect(struct drbd_conf *mdev)
 		}
 
 retry:
-		s = drbd_wait_for_connect(mdev);
+		s = drbd_wait_for_connect(mdev->tconn);
 		if (s) {
 			try = drbd_recv_fp(mdev, s);
 			drbd_socket_okay(mdev, &sock);
-- 
1.7.4.1

