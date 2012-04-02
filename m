Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752509Ab2DBLzy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2012 07:55:54 -0400
Received: from mail.pripojeni.net ([178.22.112.14]:47990 "EHLO
	smtp.pripojeni.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752216Ab2DBLzH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2012 07:55:07 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: gregkh@linuxfoundation.org
Cc: alan@linux.intel.com, linux-kernel@vger.kernel.org, jirislaby@gmail.com
Subject: [PATCH 69/69] TTY: rfcomm/tty, use count from tty_port
Date: Mon,  2 Apr 2012 13:54:53 +0200
Message-Id: <1333367693-3244-70-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.7.9.2
In-Reply-To: <1333367693-3244-1-git-send-email-jslaby@suse.cz>
References: <1333367693-3244-1-git-send-email-jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This means converting an atomic counter to a counter protected by
lock. This is the first step needed to convert the rest of the code to
the tty_port helpers.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 net/bluetooth/rfcomm/tty.c |   30 +++++++++++++++++++++---------
 1 file changed, 21 insertions(+), 9 deletions(-)

diff --git a/net/bluetooth/rfcomm/tty.c b/net/bluetooth/rfcomm/tty.c
index 0433d26..d1820ff 100644
--- a/net/bluetooth/rfcomm/tty.c
+++ b/net/bluetooth/rfcomm/tty.c
@@ -54,7 +54,6 @@ struct rfcomm_dev {
 	char			name[12];
 	int			id;
 	unsigned long		flags;
-	atomic_t		opened;
 	int			err;
 
 	bdaddr_t		src;
@@ -240,8 +239,6 @@ static int rfcomm_dev_add(struct rfcomm_dev_req *req, struct rfcomm_dlc *dlc)
 	dev->flags = req->flags &
 		((1 << RFCOMM_RELEASE_ONHUP) | (1 << RFCOMM_REUSE_DLC));
 
-	atomic_set(&dev->opened, 0);
-
 	tty_port_init(&dev->port);
 	dev->port.ops = &rfcomm_port_ops;
 	init_waitqueue_head(&dev->wait);
@@ -311,12 +308,17 @@ free:
 
 static void rfcomm_dev_del(struct rfcomm_dev *dev)
 {
+	unsigned long flags;
 	BT_DBG("dev %p", dev);
 
 	BUG_ON(test_and_set_bit(RFCOMM_TTY_RELEASED, &dev->flags));
 
-	if (atomic_read(&dev->opened) > 0)
+	spin_lock_irqsave(&dev->port.lock, flags);
+	if (dev->port.count > 0) {
+		spin_unlock_irqrestore(&dev->port.lock, flags);
 		return;
+	}
+	spin_unlock_irqrestore(&dev->port.lock, flags);
 
 	spin_lock(&rfcomm_dev_lock);
 	list_del_init(&dev->list);
@@ -651,6 +653,7 @@ static int rfcomm_tty_open(struct tty_struct *tty, struct file *filp)
 	DECLARE_WAITQUEUE(wait, current);
 	struct rfcomm_dev *dev;
 	struct rfcomm_dlc *dlc;
+	unsigned long flags;
 	int err, id;
 
 	id = tty->index;
@@ -666,10 +669,14 @@ static int rfcomm_tty_open(struct tty_struct *tty, struct file *filp)
 		return -ENODEV;
 
 	BT_DBG("dev %p dst %s channel %d opened %d", dev, batostr(&dev->dst),
-				dev->channel, atomic_read(&dev->opened));
+				dev->channel, dev->port.count);
 
-	if (atomic_inc_return(&dev->opened) > 1)
+	spin_lock_irqsave(&dev->port.lock, flags);
+	if (++dev->port.count > 1) {
+		spin_unlock_irqrestore(&dev->port.lock, flags);
 		return 0;
+	}
+	spin_unlock_irqrestore(&dev->port.lock, flags);
 
 	dlc = dev->dlc;
 
@@ -724,13 +731,17 @@ static int rfcomm_tty_open(struct tty_struct *tty, struct file *filp)
 static void rfcomm_tty_close(struct tty_struct *tty, struct file *filp)
 {
 	struct rfcomm_dev *dev = (struct rfcomm_dev *) tty->driver_data;
+	unsigned long flags;
+
 	if (!dev)
 		return;
 
 	BT_DBG("tty %p dev %p dlc %p opened %d", tty, dev, dev->dlc,
-						atomic_read(&dev->opened));
+						dev->port.count);
 
-	if (atomic_dec_and_test(&dev->opened)) {
+	spin_lock_irqsave(&dev->port.lock, flags);
+	if (!--dev->port.count) {
+		spin_unlock_irqrestore(&dev->port.lock, flags);
 		if (dev->tty_dev->parent)
 			device_move(dev->tty_dev, NULL, DPM_ORDER_DEV_LAST);
 
@@ -751,7 +762,8 @@ static void rfcomm_tty_close(struct tty_struct *tty, struct file *filp)
 
 			tty_port_put(&dev->port);
 		}
-	}
+	} else
+		spin_unlock_irqrestore(&dev->port.lock, flags);
 
 	tty_port_put(&dev->port);
 }
-- 
1.7.9.2


