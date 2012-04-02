Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753976Ab2DBL4W (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2012 07:56:22 -0400
Received: from mail.pripojeni.net ([178.22.112.14]:48083 "EHLO
	smtp.pripojeni.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752639Ab2DBLzL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2012 07:55:11 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: gregkh@linuxfoundation.org
Cc: alan@linux.intel.com, linux-kernel@vger.kernel.org, jirislaby@gmail.com
Subject: [PATCH 68/69] TTY: rfcomm/tty, remove work for tty_wakeup
Date: Mon,  2 Apr 2012 13:54:52 +0200
Message-Id: <1333367693-3244-69-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.7.9.2
In-Reply-To: <1333367693-3244-1-git-send-email-jslaby@suse.cz>
References: <1333367693-3244-1-git-send-email-jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

tty_wakeup is safe to be called from all contexts. No need to schedule
a work for that. Let us call it directly like in other drivers.

This allows us to kill another member of rfcomm_dev structure.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 net/bluetooth/rfcomm/tty.c |   22 +++-------------------
 1 file changed, 3 insertions(+), 19 deletions(-)

diff --git a/net/bluetooth/rfcomm/tty.c b/net/bluetooth/rfcomm/tty.c
index da4f545..0433d26 100644
--- a/net/bluetooth/rfcomm/tty.c
+++ b/net/bluetooth/rfcomm/tty.c
@@ -65,7 +65,6 @@ struct rfcomm_dev {
 
 	struct rfcomm_dlc	*dlc;
 	wait_queue_head_t       wait;
-	struct work_struct	wakeup_task;
 
 	struct device		*tty_dev;
 
@@ -81,8 +80,6 @@ static void rfcomm_dev_data_ready(struct rfcomm_dlc *dlc, struct sk_buff *skb);
 static void rfcomm_dev_state_change(struct rfcomm_dlc *dlc, int err);
 static void rfcomm_dev_modem_status(struct rfcomm_dlc *dlc, u8 v24_sig);
 
-static void rfcomm_tty_wakeup(struct work_struct *work);
-
 /* ---- Device functions ---- */
 
 /*
@@ -248,7 +245,6 @@ static int rfcomm_dev_add(struct rfcomm_dev_req *req, struct rfcomm_dlc *dlc)
 	tty_port_init(&dev->port);
 	dev->port.ops = &rfcomm_port_ops;
 	init_waitqueue_head(&dev->wait);
-	INIT_WORK(&dev->wakeup_task, rfcomm_tty_wakeup);
 
 	skb_queue_head_init(&dev->pending);
 
@@ -340,9 +336,10 @@ static inline unsigned int rfcomm_room(struct rfcomm_dlc *dlc)
 static void rfcomm_wfree(struct sk_buff *skb)
 {
 	struct rfcomm_dev *dev = (void *) skb->sk;
+	struct tty_struct *tty = dev->port.tty;
 	atomic_sub(skb->truesize, &dev->wmem_alloc);
-	if (test_bit(RFCOMM_TTY_ATTACHED, &dev->flags))
-		queue_work(system_nrt_wq, &dev->wakeup_task);
+	if (test_bit(RFCOMM_TTY_ATTACHED, &dev->flags) && tty)
+		tty_wakeup(tty);
 	tty_port_put(&dev->port);
 }
 
@@ -625,18 +622,6 @@ static void rfcomm_dev_modem_status(struct rfcomm_dlc *dlc, u8 v24_sig)
 }
 
 /* ---- TTY functions ---- */
-static void rfcomm_tty_wakeup(struct work_struct *work)
-{
-	struct rfcomm_dev *dev = container_of(work, struct rfcomm_dev,
-								wakeup_task);
-	struct tty_struct *tty = dev->port.tty;
-	if (!tty)
-		return;
-
-	BT_DBG("dev %p tty %p", dev, tty);
-	tty_wakeup(tty);
-}
-
 static void rfcomm_tty_copy_pending(struct rfcomm_dev *dev)
 {
 	struct tty_struct *tty = dev->port.tty;
@@ -753,7 +738,6 @@ static void rfcomm_tty_close(struct tty_struct *tty, struct file *filp)
 		rfcomm_dlc_close(dev->dlc, 0);
 
 		clear_bit(RFCOMM_TTY_ATTACHED, &dev->flags);
-		cancel_work_sync(&dev->wakeup_task);
 
 		rfcomm_dlc_lock(dev->dlc);
 		tty->driver_data = NULL;
-- 
1.7.9.2


