Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753925Ab2DBL4U (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2012 07:56:20 -0400
Received: from mail.pripojeni.net ([178.22.112.14]:48067 "EHLO
	smtp.pripojeni.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752518Ab2DBLzL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2012 07:55:11 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: gregkh@linuxfoundation.org
Cc: alan@linux.intel.com, linux-kernel@vger.kernel.org, jirislaby@gmail.com,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>, linux390@de.ibm.com,
        linux-s390@vger.kernel.org
Subject: [PATCH 24/69] TTY: con3215, centralize allocation
Date: Mon,  2 Apr 2012 13:54:08 +0200
Message-Id: <1333367693-3244-25-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.7.9.2
In-Reply-To: <1333367693-3244-1-git-send-email-jslaby@suse.cz>
References: <1333367693-3244-1-git-send-email-jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are two copies of allocations of device information. One of them
is totally broken. See:
raw->cdev = cdev;
raw->inbuf = (char *) raw + sizeof(struct raw3215_info);
memset(raw, 0, sizeof(struct raw3215_info));

It suggests that this path was never executed. The code uses both
raw->cdev and raw->inbuf all over. And it is NULL due to the memset
here, so it would panic immediately. I believe nobody used that driver
without being a system console.

Either way, let us fix it by moving the allocations (and
initializations) to a single place. This will save us some double
initializations later too.

And while at it, initialize the timer properly -- once, at the
allocation.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: linux390@de.ibm.com
Cc: linux-s390@vger.kernel.org
---
 drivers/s390/char/con3215.c |   74 +++++++++++++++++++++++--------------------
 1 file changed, 39 insertions(+), 35 deletions(-)

diff --git a/drivers/s390/char/con3215.c b/drivers/s390/char/con3215.c
index 4f9f1dc..7e30f85 100644
--- a/drivers/s390/char/con3215.c
+++ b/drivers/s390/char/con3215.c
@@ -324,10 +324,7 @@ static inline void raw3215_try_io(struct raw3215_info *raw)
 			}
 		} else if (!(raw->flags & RAW3215_TIMER_RUNS)) {
 			/* delay small writes */
-			init_timer(&raw->timer);
 			raw->timer.expires = RAW3215_TIMEOUT + jiffies;
-			raw->timer.data = (unsigned long) raw;
-			raw->timer.function = raw3215_timeout;
 			add_timer(&raw->timer);
 			raw->flags |= RAW3215_TIMER_RUNS;
 		}
@@ -648,6 +645,35 @@ static void raw3215_shutdown(struct raw3215_info *raw)
 	spin_unlock_irqrestore(get_ccwdev_lock(raw->cdev), flags);
 }
 
+static struct raw3215_info *raw3215_alloc_info(void)
+{
+	struct raw3215_info *info;
+
+	info = kzalloc(sizeof(struct raw3215_info), GFP_KERNEL | GFP_DMA);
+	if (!info)
+		return NULL;
+
+	info->buffer = kzalloc(RAW3215_BUFFER_SIZE, GFP_KERNEL | GFP_DMA);
+	info->inbuf = kzalloc(RAW3215_INBUF_SIZE, GFP_KERNEL | GFP_DMA);
+	if (!info->buffer || !info->inbuf) {
+		kfree(info);
+		return NULL;
+	}
+
+	setup_timer(&info->timer, raw3215_timeout, (unsigned long)info);
+	init_waitqueue_head(&info->empty_wait);
+	tasklet_init(&info->tlet, raw3215_wakeup, (unsigned long)info);
+
+	return info;
+}
+
+static void raw3215_free_info(struct raw3215_info *raw)
+{
+	kfree(raw->inbuf);
+	kfree(raw->buffer);
+	kfree(raw);
+}
+
 static int raw3215_probe (struct ccw_device *cdev)
 {
 	struct raw3215_info *raw;
@@ -656,11 +682,15 @@ static int raw3215_probe (struct ccw_device *cdev)
 	/* Console is special. */
 	if (raw3215[0] && (raw3215[0] == dev_get_drvdata(&cdev->dev)))
 		return 0;
-	raw = kmalloc(sizeof(struct raw3215_info) +
-		      RAW3215_INBUF_SIZE, GFP_KERNEL|GFP_DMA);
+
+	raw = raw3215_alloc_info();
 	if (raw == NULL)
 		return -ENOMEM;
 
+	raw->cdev = cdev;
+	dev_set_drvdata(&cdev->dev, raw);
+	cdev->handler = raw3215_irq;
+
 	spin_lock(&raw3215_device_lock);
 	for (line = 0; line < NR_3215; line++) {
 		if (!raw3215[line]) {
@@ -670,28 +700,10 @@ static int raw3215_probe (struct ccw_device *cdev)
 	}
 	spin_unlock(&raw3215_device_lock);
 	if (line == NR_3215) {
-		kfree(raw);
+		raw3215_free_info(raw);
 		return -ENODEV;
 	}
 
-	raw->cdev = cdev;
-	raw->inbuf = (char *) raw + sizeof(struct raw3215_info);
-	memset(raw, 0, sizeof(struct raw3215_info));
-	raw->buffer = kmalloc(RAW3215_BUFFER_SIZE,
-				       GFP_KERNEL|GFP_DMA);
-	if (raw->buffer == NULL) {
-		spin_lock(&raw3215_device_lock);
-		raw3215[line] = NULL;
-		spin_unlock(&raw3215_device_lock);
-		kfree(raw);
-		return -ENOMEM;
-	}
-	init_waitqueue_head(&raw->empty_wait);
-	tasklet_init(&raw->tlet, raw3215_wakeup, (unsigned long) raw);
-
-	dev_set_drvdata(&cdev->dev, raw);
-	cdev->handler = raw3215_irq;
-
 	return 0;
 }
 
@@ -703,8 +715,7 @@ static void raw3215_remove (struct ccw_device *cdev)
 	raw = dev_get_drvdata(&cdev->dev);
 	if (raw) {
 		dev_set_drvdata(&cdev->dev, NULL);
-		kfree(raw->buffer);
-		kfree(raw);
+		raw3215_free_info(raw);
 	}
 }
 
@@ -897,23 +908,16 @@ static int __init con3215_init(void)
 	if (IS_ERR(cdev))
 		return -ENODEV;
 
-	raw3215[0] = raw = (struct raw3215_info *)
-		kzalloc(sizeof(struct raw3215_info), GFP_KERNEL | GFP_DMA);
-	raw->buffer = kzalloc(RAW3215_BUFFER_SIZE, GFP_KERNEL | GFP_DMA);
-	raw->inbuf = kzalloc(RAW3215_INBUF_SIZE, GFP_KERNEL | GFP_DMA);
+	raw3215[0] = raw = raw3215_alloc_info();
 	raw->cdev = cdev;
 	dev_set_drvdata(&cdev->dev, raw);
 	cdev->handler = raw3215_irq;
 
 	raw->flags |= RAW3215_FIXED;
-	init_waitqueue_head(&raw->empty_wait);
-	tasklet_init(&raw->tlet, raw3215_wakeup, (unsigned long) raw);
 
 	/* Request the console irq */
 	if (raw3215_startup(raw) != 0) {
-		kfree(raw->inbuf);
-		kfree(raw->buffer);
-		kfree(raw);
+		raw3215_free_info(raw);
 		raw3215[0] = NULL;
 		return -ENODEV;
 	}
-- 
1.7.9.2


