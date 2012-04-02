Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754276Ab2DBL4f (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2012 07:56:35 -0400
Received: from mail.pripojeni.net ([178.22.112.14]:48123 "EHLO
	smtp.pripojeni.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752707Ab2DBLzO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2012 07:55:14 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: gregkh@linuxfoundation.org
Cc: alan@linux.intel.com, linux-kernel@vger.kernel.org, jirislaby@gmail.com
Subject: [PATCH 66/69] TTY: rfcomm/tty, add tty_port
Date: Mon,  2 Apr 2012 13:54:50 +0200
Message-Id: <1333367693-3244-67-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.7.9.2
In-Reply-To: <1333367693-3244-1-git-send-email-jslaby@suse.cz>
References: <1333367693-3244-1-git-send-email-jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

And use tty from there.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 net/bluetooth/rfcomm/tty.c |   25 +++++++++++++------------
 1 file changed, 13 insertions(+), 12 deletions(-)

diff --git a/net/bluetooth/rfcomm/tty.c b/net/bluetooth/rfcomm/tty.c
index 4bf54b3..97c2a08 100644
--- a/net/bluetooth/rfcomm/tty.c
+++ b/net/bluetooth/rfcomm/tty.c
@@ -48,6 +48,7 @@
 static struct tty_driver *rfcomm_tty_driver;
 
 struct rfcomm_dev {
+	struct tty_port		port;
 	struct list_head	list;
 	atomic_t		refcnt;
 
@@ -64,7 +65,6 @@ struct rfcomm_dev {
 	uint			modem_status;
 
 	struct rfcomm_dlc	*dlc;
-	struct tty_struct	*tty;
 	wait_queue_head_t       wait;
 	struct work_struct	wakeup_task;
 
@@ -252,6 +252,7 @@ static int rfcomm_dev_add(struct rfcomm_dev_req *req, struct rfcomm_dlc *dlc)
 
 	atomic_set(&dev->opened, 0);
 
+	tty_port_init(&dev->port);
 	init_waitqueue_head(&dev->wait);
 	INIT_WORK(&dev->wakeup_task, rfcomm_tty_wakeup);
 
@@ -440,8 +441,8 @@ static int rfcomm_release_dev(void __user *arg)
 		rfcomm_dlc_close(dev->dlc, 0);
 
 	/* Shut down TTY synchronously before freeing rfcomm_dev */
-	if (dev->tty)
-		tty_vhangup(dev->tty);
+	if (dev->port.tty)
+		tty_vhangup(dev->port.tty);
 
 	if (!test_bit(RFCOMM_RELEASE_ONHUP, &dev->flags))
 		rfcomm_dev_del(dev);
@@ -559,7 +560,7 @@ static void rfcomm_dev_data_ready(struct rfcomm_dlc *dlc, struct sk_buff *skb)
 		return;
 	}
 
-	tty = dev->tty;
+	tty = dev->port.tty;
 	if (!tty || !skb_queue_empty(&dev->pending)) {
 		skb_queue_tail(&dev->pending, skb);
 		return;
@@ -585,7 +586,7 @@ static void rfcomm_dev_state_change(struct rfcomm_dlc *dlc, int err)
 	wake_up_interruptible(&dev->wait);
 
 	if (dlc->state == BT_CLOSED) {
-		if (!dev->tty) {
+		if (!dev->port.tty) {
 			if (test_bit(RFCOMM_RELEASE_ONHUP, &dev->flags)) {
 				/* Drop DLC lock here to avoid deadlock
 				 * 1. rfcomm_dev_get will take rfcomm_dev_lock
@@ -605,7 +606,7 @@ static void rfcomm_dev_state_change(struct rfcomm_dlc *dlc, int err)
 				rfcomm_dlc_lock(dlc);
 			}
 		} else
-			tty_hangup(dev->tty);
+			tty_hangup(dev->port.tty);
 	}
 }
 
@@ -618,8 +619,8 @@ static void rfcomm_dev_modem_status(struct rfcomm_dlc *dlc, u8 v24_sig)
 	BT_DBG("dlc %p dev %p v24_sig 0x%02x", dlc, dev, v24_sig);
 
 	if ((dev->modem_status & TIOCM_CD) && !(v24_sig & RFCOMM_V24_DV)) {
-		if (dev->tty && !C_CLOCAL(dev->tty))
-			tty_hangup(dev->tty);
+		if (dev->port.tty && !C_CLOCAL(dev->port.tty))
+			tty_hangup(dev->port.tty);
 	}
 
 	dev->modem_status =
@@ -634,7 +635,7 @@ static void rfcomm_tty_wakeup(struct work_struct *work)
 {
 	struct rfcomm_dev *dev = container_of(work, struct rfcomm_dev,
 								wakeup_task);
-	struct tty_struct *tty = dev->tty;
+	struct tty_struct *tty = dev->port.tty;
 	if (!tty)
 		return;
 
@@ -644,7 +645,7 @@ static void rfcomm_tty_wakeup(struct work_struct *work)
 
 static void rfcomm_tty_copy_pending(struct rfcomm_dev *dev)
 {
-	struct tty_struct *tty = dev->tty;
+	struct tty_struct *tty = dev->port.tty;
 	struct sk_buff *skb;
 	int inserted = 0;
 
@@ -697,7 +698,7 @@ static int rfcomm_tty_open(struct tty_struct *tty, struct file *filp)
 
 	rfcomm_dlc_lock(dlc);
 	tty->driver_data = dev;
-	dev->tty = tty;
+	dev->port.tty = tty;
 	rfcomm_dlc_unlock(dlc);
 	set_bit(RFCOMM_TTY_ATTACHED, &dev->flags);
 
@@ -762,7 +763,7 @@ static void rfcomm_tty_close(struct tty_struct *tty, struct file *filp)
 
 		rfcomm_dlc_lock(dev->dlc);
 		tty->driver_data = NULL;
-		dev->tty = NULL;
+		dev->port.tty = NULL;
 		rfcomm_dlc_unlock(dev->dlc);
 
 		if (test_bit(RFCOMM_TTY_RELEASED, &dev->flags)) {
-- 
1.7.9.2


