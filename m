Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754468Ab1HYPWl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Aug 2011 11:22:41 -0400
Received: from mail09.linbit.com ([212.69.161.110]:34620 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753803Ab1HYPJo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Aug 2011 11:09:44 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 071/118] drbd: Started to separated connection flags (tconn) from block device flags (mdev)
Date: Thu, 25 Aug 2011 17:08:07 +0200
Message-Id: <1314284934-17999-72-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1314284934-17999-1-git-send-email-philipp.reisner@linbit.com>
References: <1314284934-17999-1-git-send-email-philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
---
 drivers/block/drbd/drbd_int.h  |   10 +++++++---
 drivers/block/drbd/drbd_main.c |    8 ++++----
 2 files changed, 11 insertions(+), 7 deletions(-)

diff --git a/drivers/block/drbd/drbd_int.h b/drivers/block/drbd/drbd_int.h
index 1ecde6f..b325b0a 100644
--- a/drivers/block/drbd/drbd_int.h
+++ b/drivers/block/drbd/drbd_int.h
@@ -753,7 +753,7 @@ enum {
 #define EE_WAS_ERROR           (1<<__EE_WAS_ERROR)
 #define EE_HAS_DIGEST          (1<<__EE_HAS_DIGEST)
 
-/* global flag bits */
+/* flag bits per mdev */
 enum {
 	CREATE_BARRIER,		/* next P_DATA is preceded by a P_BARRIER */
 	SIGNAL_ASENDER,		/* whether asender wants to be interrupted */
@@ -781,8 +781,6 @@ enum {
 	GO_DISKLESS,		/* Disk is being detached, on io-error or admin request. */
 	WAS_IO_ERROR,		/* Local disk failed returned IO error */
 	RESYNC_AFTER_NEG,       /* Resync after online grow after the attach&negotiate finished. */
-	NET_CONGESTED,		/* The data socket is congested */
-
 	CONFIG_PENDING,		/* serialization of (re)configuration requests.
 				 * if set, also prevents the device from dying */
 	DEVICE_DYING,		/* device became unconfigured,
@@ -909,10 +907,16 @@ struct fifo_buffer {
 	unsigned int size;
 };
 
+/* flag bits per tconn */
+enum {
+	NET_CONGESTED,		/* The data socket is congested */
+};
+
 struct drbd_tconn {			/* is a resource from the config file */
 	char *name;			/* Resource name */
 	struct list_head all_tconn;	/* List of all drbd_tconn, prot by global_state_lock */
 	struct drbd_conf *volume0;	/* TODO: Remove me again */
+	unsigned long flags;
 
 	struct net_conf *net_conf;	/* protected by get_net_conf() and put_net_conf() */
 	atomic_t net_cnt;		/* Users of net_conf */
diff --git a/drivers/block/drbd/drbd_main.c b/drivers/block/drbd/drbd_main.c
index 0e2969d..45b8f67 100644
--- a/drivers/block/drbd/drbd_main.c
+++ b/drivers/block/drbd/drbd_main.c
@@ -1370,7 +1370,7 @@ static void drbd_update_congested(struct drbd_conf *mdev)
 {
 	struct sock *sk = mdev->tconn->data.socket->sk;
 	if (sk->sk_wmem_queued > sk->sk_sndbuf * 4 / 5)
-		set_bit(NET_CONGESTED, &mdev->flags);
+		set_bit(NET_CONGESTED, &mdev->tconn->flags);
 }
 
 /* The idea of sendpage seems to be to put some kind of reference
@@ -1443,7 +1443,7 @@ static int _drbd_send_page(struct drbd_conf *mdev, struct page *page,
 		offset += sent;
 	} while (len > 0 /* THINK && mdev->cstate >= C_CONNECTED*/);
 	set_fs(oldfs);
-	clear_bit(NET_CONGESTED, &mdev->flags);
+	clear_bit(NET_CONGESTED, &mdev->tconn->flags);
 
 	ok = (len == 0);
 	if (likely(ok))
@@ -1706,7 +1706,7 @@ int drbd_send(struct drbd_conf *mdev, struct socket *sock,
 	} while (sent < size);
 
 	if (sock == mdev->tconn->data.socket)
-		clear_bit(NET_CONGESTED, &mdev->flags);
+		clear_bit(NET_CONGESTED, &mdev->tconn->flags);
 
 	if (rv <= 0) {
 		if (rv != -EAGAIN) {
@@ -2173,7 +2173,7 @@ static int drbd_congested(void *congested_data, int bdi_bits)
 			reason = 'b';
 	}
 
-	if (bdi_bits & (1 << BDI_async_congested) && test_bit(NET_CONGESTED, &mdev->flags)) {
+	if (bdi_bits & (1 << BDI_async_congested) && test_bit(NET_CONGESTED, &mdev->tconn->flags)) {
 		r |= (1 << BDI_async_congested);
 		reason = reason == 'b' ? 'a' : 'n';
 	}
-- 
1.7.4.1

