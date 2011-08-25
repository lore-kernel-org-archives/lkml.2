Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753892Ab1HYPJw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Aug 2011 11:09:52 -0400
Received: from mail09.linbit.com ([212.69.161.110]:34634 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753840Ab1HYPJq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Aug 2011 11:09:46 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 076/118] drbd: Converted helper functions for drbd_send() to tconn
Date: Thu, 25 Aug 2011 17:08:12 +0200
Message-Id: <1314284934-17999-77-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1314284934-17999-1-git-send-email-philipp.reisner@linbit.com>
References: <1314284934-17999-1-git-send-email-philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* drbd_update_congested()
* we_should_drop_the_connection()

Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
---
 drivers/block/drbd/drbd_main.c |   32 ++++++++++++++++----------------
 1 files changed, 16 insertions(+), 16 deletions(-)

diff --git a/drivers/block/drbd/drbd_main.c b/drivers/block/drbd/drbd_main.c
index 4c31410..1f9eac0 100644
--- a/drivers/block/drbd/drbd_main.c
+++ b/drivers/block/drbd/drbd_main.c
@@ -1343,34 +1343,34 @@ int drbd_send_ov_request(struct drbd_conf *mdev, sector_t sector, int size)
  * returns false if we should retry,
  * true if we think connection is dead
  */
-static int we_should_drop_the_connection(struct drbd_conf *mdev, struct socket *sock)
+static int we_should_drop_the_connection(struct drbd_tconn *tconn, struct socket *sock)
 {
 	int drop_it;
 	/* long elapsed = (long)(jiffies - mdev->last_received); */
 
-	drop_it =   mdev->tconn->meta.socket == sock
-		|| !mdev->tconn->asender.task
-		|| get_t_state(&mdev->tconn->asender) != RUNNING
-		|| mdev->state.conn < C_CONNECTED;
+	drop_it =   tconn->meta.socket == sock
+		|| !tconn->asender.task
+		|| get_t_state(&tconn->asender) != RUNNING
+		|| tconn->volume0->state.conn < C_CONNECTED;
 
 	if (drop_it)
 		return true;
 
-	drop_it = !--mdev->tconn->ko_count;
+	drop_it = !--tconn->ko_count;
 	if (!drop_it) {
-		dev_err(DEV, "[%s/%d] sock_sendmsg time expired, ko = %u\n",
-		       current->comm, current->pid, mdev->tconn->ko_count);
-		request_ping(mdev->tconn);
+		conn_err(tconn, "[%s/%d] sock_sendmsg time expired, ko = %u\n",
+			 current->comm, current->pid, tconn->ko_count);
+		request_ping(tconn);
 	}
 
 	return drop_it; /* && (mdev->state == R_PRIMARY) */;
 }
 
-static void drbd_update_congested(struct drbd_conf *mdev)
+static void drbd_update_congested(struct drbd_tconn *tconn)
 {
-	struct sock *sk = mdev->tconn->data.socket->sk;
+	struct sock *sk = tconn->data.socket->sk;
 	if (sk->sk_wmem_queued > sk->sk_sndbuf * 4 / 5)
-		set_bit(NET_CONGESTED, &mdev->tconn->flags);
+		set_bit(NET_CONGESTED, &tconn->flags);
 }
 
 /* The idea of sendpage seems to be to put some kind of reference
@@ -1421,14 +1421,14 @@ static int _drbd_send_page(struct drbd_conf *mdev, struct page *page,
 		return _drbd_no_send_page(mdev, page, offset, size, msg_flags);
 
 	msg_flags |= MSG_NOSIGNAL;
-	drbd_update_congested(mdev);
+	drbd_update_congested(mdev->tconn);
 	set_fs(KERNEL_DS);
 	do {
 		sent = mdev->tconn->data.socket->ops->sendpage(mdev->tconn->data.socket, page,
 							offset, len,
 							msg_flags);
 		if (sent == -EAGAIN) {
-			if (we_should_drop_the_connection(mdev,
+			if (we_should_drop_the_connection(mdev->tconn,
 							  mdev->tconn->data.socket))
 				break;
 			else
@@ -1674,7 +1674,7 @@ int drbd_send(struct drbd_conf *mdev, struct socket *sock,
 
 	if (sock == mdev->tconn->data.socket) {
 		mdev->tconn->ko_count = mdev->tconn->net_conf->ko_count;
-		drbd_update_congested(mdev);
+		drbd_update_congested(mdev->tconn);
 	}
 	do {
 		/* STRANGE
@@ -1688,7 +1688,7 @@ int drbd_send(struct drbd_conf *mdev, struct socket *sock,
  */
 		rv = kernel_sendmsg(sock, &msg, &iov, 1, size);
 		if (rv == -EAGAIN) {
-			if (we_should_drop_the_connection(mdev, sock))
+			if (we_should_drop_the_connection(mdev->tconn, sock))
 				break;
 			else
 				continue;
-- 
1.7.4.1

