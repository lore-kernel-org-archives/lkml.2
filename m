Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751336Ab3AHFoh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2013 00:44:37 -0500
Received: from mail-pa0-f54.google.com ([209.85.220.54]:51993 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751153Ab3AHFoc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2013 00:44:32 -0500
From: Harvey Yang <harvey.huawei.yang@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Matt Mooney <mfm@muteddisk.com>, linux-usb@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Harvey Yang <harvey.huawei.yang@gmail.com>
Subject: [PATCH 1/2] staging: usbip: use interrupt safe spinlock to avoid potential deadlock.
Date: Tue,  8 Jan 2013 13:49:01 +0800
Message-Id: <1357624142-7178-2-git-send-email-harvey.huawei.yang@gmail.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1357624142-7178-1-git-send-email-harvey.huawei.yang@gmail.com>
References: <1357624142-7178-1-git-send-email-harvey.huawei.yang@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Harvey Yang <harvey.huawei.yang@gmail.com>
---
 drivers/staging/usbip/stub_dev.c    |   34 +++++++++++++++++-----------------
 drivers/staging/usbip/stub_rx.c     |    4 ++--
 drivers/staging/usbip/usbip_event.c |    6 ++++--
 3 files changed, 23 insertions(+), 21 deletions(-)

diff --git a/drivers/staging/usbip/stub_dev.c b/drivers/staging/usbip/stub_dev.c
index ee36415..d36c69e 100644
--- a/drivers/staging/usbip/stub_dev.c
+++ b/drivers/staging/usbip/stub_dev.c
@@ -67,9 +67,9 @@ static ssize_t show_status(struct device *dev, struct device_attribute *attr,
 		return -ENODEV;
 	}
 
-	spin_lock(&sdev->ud.lock);
+	spin_lock_irq(&sdev->ud.lock);
 	status = sdev->ud.status;
-	spin_unlock(&sdev->ud.lock);
+	spin_unlock_irq(&sdev->ud.lock);
 
 	return snprintf(buf, PAGE_SIZE, "%d\n", status);
 }
@@ -97,39 +97,39 @@ static ssize_t store_sockfd(struct device *dev, struct device_attribute *attr,
 	if (sockfd != -1) {
 		dev_info(dev, "stub up\n");
 
-		spin_lock(&sdev->ud.lock);
+		spin_lock_irq(&sdev->ud.lock);
 
 		if (sdev->ud.status != SDEV_ST_AVAILABLE) {
 			dev_err(dev, "not ready\n");
-			spin_unlock(&sdev->ud.lock);
+			spin_unlock_irq(&sdev->ud.lock);
 			return -EINVAL;
 		}
 
 		socket = sockfd_to_socket(sockfd);
 		if (!socket) {
-			spin_unlock(&sdev->ud.lock);
+			spin_unlock_irq(&sdev->ud.lock);
 			return -EINVAL;
 		}
 		sdev->ud.tcp_socket = socket;
 
-		spin_unlock(&sdev->ud.lock);
+		spin_unlock_irq(&sdev->ud.lock);
 
 		sdev->ud.tcp_rx = kthread_get_run(stub_rx_loop, &sdev->ud, "stub_rx");
 		sdev->ud.tcp_tx = kthread_get_run(stub_tx_loop, &sdev->ud, "stub_tx");
 
-		spin_lock(&sdev->ud.lock);
+		spin_lock_irq(&sdev->ud.lock);
 		sdev->ud.status = SDEV_ST_USED;
-		spin_unlock(&sdev->ud.lock);
+		spin_unlock_irq(&sdev->ud.lock);
 
 	} else {
 		dev_info(dev, "stub down\n");
 
-		spin_lock(&sdev->ud.lock);
+		spin_lock_irq(&sdev->ud.lock);
 		if (sdev->ud.status != SDEV_ST_USED) {
-			spin_unlock(&sdev->ud.lock);
+			spin_unlock_irq(&sdev->ud.lock);
 			return -EINVAL;
 		}
-		spin_unlock(&sdev->ud.lock);
+		spin_unlock_irq(&sdev->ud.lock);
 
 		usbip_event_add(&sdev->ud, SDEV_EVENT_DOWN);
 	}
@@ -241,9 +241,9 @@ static void stub_device_reset(struct usbip_device *ud)
 	ret = usb_lock_device_for_reset(udev, sdev->interface);
 	if (ret < 0) {
 		dev_err(&udev->dev, "lock for reset\n");
-		spin_lock(&ud->lock);
+		spin_lock_irq(&ud->lock);
 		ud->status = SDEV_ST_ERROR;
-		spin_unlock(&ud->lock);
+		spin_unlock_irq(&ud->lock);
 		return;
 	}
 
@@ -251,7 +251,7 @@ static void stub_device_reset(struct usbip_device *ud)
 	ret = usb_reset_device(udev);
 	usb_unlock_device(udev);
 
-	spin_lock(&ud->lock);
+	spin_lock_irq(&ud->lock);
 	if (ret) {
 		dev_err(&udev->dev, "device reset\n");
 		ud->status = SDEV_ST_ERROR;
@@ -259,14 +259,14 @@ static void stub_device_reset(struct usbip_device *ud)
 		dev_info(&udev->dev, "device reset\n");
 		ud->status = SDEV_ST_AVAILABLE;
 	}
-	spin_unlock(&ud->lock);
+	spin_unlock_irq(&ud->lock);
 }
 
 static void stub_device_unusable(struct usbip_device *ud)
 {
-	spin_lock(&ud->lock);
+	spin_lock_irq(&ud->lock);
 	ud->status = SDEV_ST_ERROR;
-	spin_unlock(&ud->lock);
+	spin_unlock_irq(&ud->lock);
 }
 
 /**
diff --git a/drivers/staging/usbip/stub_rx.c b/drivers/staging/usbip/stub_rx.c
index 0572a15..e7458e1 100644
--- a/drivers/staging/usbip/stub_rx.c
+++ b/drivers/staging/usbip/stub_rx.c
@@ -307,12 +307,12 @@ static int valid_request(struct stub_device *sdev, struct usbip_header *pdu)
 	int valid = 0;
 
 	if (pdu->base.devid == sdev->devid) {
-		spin_lock(&ud->lock);
+		spin_lock_irq(&ud->lock);
 		if (ud->status == SDEV_ST_USED) {
 			/* A request is valid. */
 			valid = 1;
 		}
-		spin_unlock(&ud->lock);
+		spin_unlock_irq(&ud->lock);
 	}
 
 	return valid;
diff --git a/drivers/staging/usbip/usbip_event.c b/drivers/staging/usbip/usbip_event.c
index d332a34..82123be 100644
--- a/drivers/staging/usbip/usbip_event.c
+++ b/drivers/staging/usbip/usbip_event.c
@@ -105,10 +105,12 @@ EXPORT_SYMBOL_GPL(usbip_stop_eh);
 
 void usbip_event_add(struct usbip_device *ud, unsigned long event)
 {
-	spin_lock(&ud->lock);
+	unsigned long flags;
+
+	spin_lock_irqsave(&ud->lock, flags);
 	ud->event |= event;
 	wake_up(&ud->eh_waitq);
-	spin_unlock(&ud->lock);
+	spin_unlock_irqrestore(&ud->lock, flags);
 }
 EXPORT_SYMBOL_GPL(usbip_event_add);
 
-- 
1.7.1

