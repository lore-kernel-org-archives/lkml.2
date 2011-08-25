Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754456Ab1HYPUD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Aug 2011 11:20:03 -0400
Received: from mail09.linbit.com ([212.69.161.110]:34634 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753866Ab1HYPJs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Aug 2011 11:09:48 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 079/118] drbd: Removed unused mdev argument from drbd_recv_short() and drbd_socket_okay()
Date: Thu, 25 Aug 2011 17:08:15 +0200
Message-Id: <1314284934-17999-80-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1314284934-17999-1-git-send-email-philipp.reisner@linbit.com>
References: <1314284934-17999-1-git-send-email-philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
---
 drivers/block/drbd/drbd_receiver.c |   25 +++++++++++--------------
 1 files changed, 11 insertions(+), 14 deletions(-)

diff --git a/drivers/block/drbd/drbd_receiver.c b/drivers/block/drbd/drbd_receiver.c
index 55538d7..2e1972e 100644
--- a/drivers/block/drbd/drbd_receiver.c
+++ b/drivers/block/drbd/drbd_receiver.c
@@ -476,8 +476,7 @@ out:
 	return err;
 }
 
-static int drbd_recv_short(struct drbd_conf *mdev, struct socket *sock,
-		    void *buf, size_t size, int flags)
+static int drbd_recv_short(struct socket *sock, void *buf, size_t size, int flags)
 {
 	mm_segment_t oldfs;
 	struct kvec iov = {
@@ -710,7 +709,7 @@ static enum drbd_packet drbd_recv_fp(struct drbd_conf *mdev, struct socket *sock
 	struct p_header80 *h = &mdev->tconn->data.rbuf.header.h80;
 	int rr;
 
-	rr = drbd_recv_short(mdev, sock, h, sizeof(*h), 0);
+	rr = drbd_recv_short(sock, h, sizeof(*h), 0);
 
 	if (rr == sizeof(*h) && h->magic == cpu_to_be32(DRBD_MAGIC))
 		return be16_to_cpu(h->command);
@@ -720,10 +719,9 @@ static enum drbd_packet drbd_recv_fp(struct drbd_conf *mdev, struct socket *sock
 
 /**
  * drbd_socket_okay() - Free the socket if its connection is not okay
- * @mdev:	DRBD device.
  * @sock:	pointer to the pointer to the socket.
  */
-static int drbd_socket_okay(struct drbd_conf *mdev, struct socket **sock)
+static int drbd_socket_okay(struct socket **sock)
 {
 	int rr;
 	char tb[4];
@@ -731,7 +729,7 @@ static int drbd_socket_okay(struct drbd_conf *mdev, struct socket **sock)
 	if (!*sock)
 		return false;
 
-	rr = drbd_recv_short(mdev, *sock, tb, 4, MSG_DONTWAIT | MSG_PEEK);
+	rr = drbd_recv_short(*sock, tb, 4, MSG_DONTWAIT | MSG_PEEK);
 
 	if (rr > 0 || rr == -EAGAIN) {
 		return true;
@@ -795,8 +793,8 @@ static int drbd_connect(struct drbd_conf *mdev)
 
 		if (sock && msock) {
 			schedule_timeout_interruptible(mdev->tconn->net_conf->ping_timeo*HZ/10);
-			ok = drbd_socket_okay(mdev, &sock);
-			ok = drbd_socket_okay(mdev, &msock) && ok;
+			ok = drbd_socket_okay(&sock);
+			ok = drbd_socket_okay(&msock) && ok;
 			if (ok)
 				break;
 		}
@@ -805,8 +803,8 @@ retry:
 		s = drbd_wait_for_connect(mdev->tconn);
 		if (s) {
 			try = drbd_recv_fp(mdev, s);
-			drbd_socket_okay(mdev, &sock);
-			drbd_socket_okay(mdev, &msock);
+			drbd_socket_okay(&sock);
+			drbd_socket_okay(&msock);
 			switch (try) {
 			case P_HAND_SHAKE_S:
 				if (sock) {
@@ -841,8 +839,8 @@ retry:
 		}
 
 		if (sock && msock) {
-			ok = drbd_socket_okay(mdev, &sock);
-			ok = drbd_socket_okay(mdev, &msock) && ok;
+			ok = drbd_socket_okay(&sock);
+			ok = drbd_socket_okay(&msock) && ok;
 			if (ok)
 				break;
 		}
@@ -4605,8 +4603,7 @@ int drbd_asender(struct drbd_thread *thi)
 		if (signal_pending(current))
 			continue;
 
-		rv = drbd_recv_short(mdev, mdev->tconn->meta.socket,
-				     buf, expect-received, 0);
+		rv = drbd_recv_short(mdev->tconn->meta.socket, buf, expect-received, 0);
 		clear_bit(SIGNAL_ASENDER, &mdev->tconn->flags);
 
 		flush_signals(current);
-- 
1.7.4.1

