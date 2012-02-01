Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932588Ab2BAVeT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 16:34:19 -0500
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:60477 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932550Ab2BAVKQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 16:10:16 -0500
X-Sasl-enc: wiLWigwAyYLmhO8coyrpIPSfa9Jag/KRZ29xAzS70gJg 1328130614
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Feb  1 13:00:48 2012
Message-Id: <20120201210047.951317160@clark.kroah.org>
User-Agent: quilt/0.51-15.1
Date: Wed, 01 Feb 2012 13:00:10 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk,
        =?UTF-8?q?Bj=C3=B8rn=20Mork?= <bjorn@mork.no>,
        Oliver Neukum <oneukum@suse.de>
Subject: [46/89] USB: cdc-wdm: use two mutexes to allow simultaneous read and write
In-Reply-To: <20120201210505.GA26028@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bjørn Mork <bjorn@mork.no>

commit e8537bd2c4f325a4796da33564ddcef9489b7feb upstream.

using a separate read and write mutex for locking is sufficient to make the
driver accept simultaneous read and write. This improves useability a lot.

Signed-off-by: Bjørn Mork <bjorn@mork.no>
Cc: Oliver Neukum <oneukum@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/class/cdc-wdm.c |   49 +++++++++++++++++++++++++++-----------------
 1 file changed, 31 insertions(+), 18 deletions(-)

--- a/drivers/usb/class/cdc-wdm.c
+++ b/drivers/usb/class/cdc-wdm.c
@@ -88,7 +88,8 @@ struct wdm_device {
 	int			count;
 	dma_addr_t		shandle;
 	dma_addr_t		ihandle;
-	struct mutex		lock;
+	struct mutex		wlock;
+	struct mutex		rlock;
 	wait_queue_head_t	wait;
 	struct work_struct	rxwork;
 	int			werr;
@@ -323,7 +324,7 @@ static ssize_t wdm_write
 	}
 
 	/* concurrent writes and disconnect */
-	r = mutex_lock_interruptible(&desc->lock);
+	r = mutex_lock_interruptible(&desc->wlock);
 	rv = -ERESTARTSYS;
 	if (r) {
 		kfree(buf);
@@ -386,7 +387,7 @@ static ssize_t wdm_write
 out:
 	usb_autopm_put_interface(desc->intf);
 outnp:
-	mutex_unlock(&desc->lock);
+	mutex_unlock(&desc->wlock);
 outnl:
 	return rv < 0 ? rv : count;
 }
@@ -399,7 +400,7 @@ static ssize_t wdm_read
 	struct wdm_device *desc = file->private_data;
 
 
-	rv = mutex_lock_interruptible(&desc->lock); /*concurrent reads */
+	rv = mutex_lock_interruptible(&desc->rlock); /*concurrent reads */
 	if (rv < 0)
 		return -ERESTARTSYS;
 
@@ -476,7 +477,7 @@ retry:
 	rv = cntr;
 
 err:
-	mutex_unlock(&desc->lock);
+	mutex_unlock(&desc->rlock);
 	return rv;
 }
 
@@ -542,7 +543,8 @@ static int wdm_open(struct inode *inode,
 	}
 	intf->needs_remote_wakeup = 1;
 
-	mutex_lock(&desc->lock);
+	/* using write lock to protect desc->count */
+	mutex_lock(&desc->wlock);
 	if (!desc->count++) {
 		desc->werr = 0;
 		desc->rerr = 0;
@@ -555,7 +557,7 @@ static int wdm_open(struct inode *inode,
 	} else {
 		rv = 0;
 	}
-	mutex_unlock(&desc->lock);
+	mutex_unlock(&desc->wlock);
 	usb_autopm_put_interface(desc->intf);
 out:
 	mutex_unlock(&wdm_mutex);
@@ -567,9 +569,11 @@ static int wdm_release(struct inode *ino
 	struct wdm_device *desc = file->private_data;
 
 	mutex_lock(&wdm_mutex);
-	mutex_lock(&desc->lock);
+
+	/* using write lock to protect desc->count */
+	mutex_lock(&desc->wlock);
 	desc->count--;
-	mutex_unlock(&desc->lock);
+	mutex_unlock(&desc->wlock);
 
 	if (!desc->count) {
 		dev_dbg(&desc->intf->dev, "wdm_release: cleanup");
@@ -667,7 +671,8 @@ next_desc:
 	desc = kzalloc(sizeof(struct wdm_device), GFP_KERNEL);
 	if (!desc)
 		goto out;
-	mutex_init(&desc->lock);
+	mutex_init(&desc->rlock);
+	mutex_init(&desc->wlock);
 	spin_lock_init(&desc->iuspin);
 	init_waitqueue_head(&desc->wait);
 	desc->wMaxCommand = maxcom;
@@ -781,10 +786,12 @@ static void wdm_disconnect(struct usb_in
 	/* to terminate pending flushes */
 	clear_bit(WDM_IN_USE, &desc->flags);
 	spin_unlock_irqrestore(&desc->iuspin, flags);
-	mutex_lock(&desc->lock);
+	mutex_lock(&desc->rlock);
+	mutex_lock(&desc->wlock);
 	kill_urbs(desc);
 	cancel_work_sync(&desc->rxwork);
-	mutex_unlock(&desc->lock);
+	mutex_unlock(&desc->wlock);
+	mutex_unlock(&desc->rlock);
 	wake_up_all(&desc->wait);
 	if (!desc->count)
 		cleanup(desc);
@@ -800,8 +807,10 @@ static int wdm_suspend(struct usb_interf
 	dev_dbg(&desc->intf->dev, "wdm%d_suspend\n", intf->minor);
 
 	/* if this is an autosuspend the caller does the locking */
-	if (!PMSG_IS_AUTO(message))
-		mutex_lock(&desc->lock);
+	if (!PMSG_IS_AUTO(message)) {
+		mutex_lock(&desc->rlock);
+		mutex_lock(&desc->wlock);
+	}
 	spin_lock_irq(&desc->iuspin);
 
 	if (PMSG_IS_AUTO(message) &&
@@ -817,8 +826,10 @@ static int wdm_suspend(struct usb_interf
 		kill_urbs(desc);
 		cancel_work_sync(&desc->rxwork);
 	}
-	if (!PMSG_IS_AUTO(message))
-		mutex_unlock(&desc->lock);
+	if (!PMSG_IS_AUTO(message)) {
+		mutex_unlock(&desc->wlock);
+		mutex_unlock(&desc->rlock);
+	}
 
 	return rv;
 }
@@ -856,7 +867,8 @@ static int wdm_pre_reset(struct usb_inte
 {
 	struct wdm_device *desc = usb_get_intfdata(intf);
 
-	mutex_lock(&desc->lock);
+	mutex_lock(&desc->rlock);
+	mutex_lock(&desc->wlock);
 	kill_urbs(desc);
 
 	/*
@@ -878,7 +890,8 @@ static int wdm_post_reset(struct usb_int
 	int rv;
 
 	rv = recover_from_urb_loss(desc);
-	mutex_unlock(&desc->lock);
+	mutex_unlock(&desc->wlock);
+	mutex_unlock(&desc->rlock);
 	return 0;
 }
 


