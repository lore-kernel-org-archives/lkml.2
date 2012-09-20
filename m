Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753472Ab2ITRud (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2012 13:50:33 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:61507 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752192Ab2ITRu2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2012 13:50:28 -0400
From: David Herrmann <dh.herrmann@googlemail.com>
To: linux-input@vger.kernel.org
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-kernel@vger.kernel.org,
        Bernie Thompson <bernie@plugable.com>,
        David Herrmann <dh.herrmann@googlemail.com>
Subject: [PATCH v2 3/3] input: evdev: use dynamic-minors if running out of static minors
Date: Thu, 20 Sep 2012 19:52:03 +0200
Message-Id: <1348163523-2062-4-git-send-email-dh.herrmann@googlemail.com>
X-Mailer: git-send-email 1.7.12
In-Reply-To: <1348163523-2062-1-git-send-email-dh.herrmann@googlemail.com>
References: <1348163523-2062-1-git-send-email-dh.herrmann@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When 32 devices were registered and we are running out of minor numbers,
then use the new dynamic-minor infrastructure to get more minor numbers.

This is fully backwards compatible, except devices with dynamic minors
might not be visible to old userspace programs. However, without this
patch these devices aren't visible, either, so this is no problem at all.

Signed-off-by: David Herrmann <dh.herrmann@googlemail.com>
---
 drivers/input/evdev.c | 95 ++++++++++++++++++++++++++++-----------------------
 1 file changed, 53 insertions(+), 42 deletions(-)

diff --git a/drivers/input/evdev.c b/drivers/input/evdev.c
index 6c58bff..2e8a0b1 100644
--- a/drivers/input/evdev.c
+++ b/drivers/input/evdev.c
@@ -12,6 +12,7 @@
 
 #define EVDEV_MINOR_BASE	64
 #define EVDEV_MINORS		32
+#define EVDEV_MINOR_MAX		(EVDEV_MINOR_BASE + EVDEV_MINORS - 1)
 #define EVDEV_MIN_BUFFER_SIZE	64U
 #define EVDEV_BUF_PACKETS	8
 
@@ -53,6 +54,7 @@ struct evdev_client {
 
 static struct evdev *evdev_table[EVDEV_MINORS];
 static DEFINE_MUTEX(evdev_table_mutex);
+static struct input_handler evdev_handler;
 
 static void evdev_pass_event(struct evdev_client *client,
 			     struct input_event *event,
@@ -287,23 +289,30 @@ static int evdev_open(struct inode *inode, struct file *file)
 {
 	struct evdev *evdev;
 	struct evdev_client *client;
-	int i = iminor(inode) - EVDEV_MINOR_BASE;
+	int i, minor = iminor(inode);
 	unsigned int bufsize;
 	int error;
+	struct input_handler *handler;
 
-	if (i >= EVDEV_MINORS)
-		return -ENODEV;
-
-	error = mutex_lock_interruptible(&evdev_table_mutex);
-	if (error)
-		return error;
-	evdev = evdev_table[i];
-	if (evdev)
+	i = minor - EVDEV_MINOR_BASE;
+	if (i >= EVDEV_MINORS) {
+		evdev = input_minor_get_data(minor);
+		handler = input_minor_get_handler(minor);
+		if (handler != &evdev_handler)
+			return -ENODEV;
 		get_device(&evdev->dev);
-	mutex_unlock(&evdev_table_mutex);
-
-	if (!evdev)
-		return -ENODEV;
+	} else {
+		error = mutex_lock_interruptible(&evdev_table_mutex);
+		if (error)
+			return error;
+		evdev = evdev_table[i];
+		if (evdev)
+			get_device(&evdev->dev);
+		mutex_unlock(&evdev_table_mutex);
+
+		if (!evdev)
+			return -ENODEV;
+	}
 
 	bufsize = evdev_compute_buffer_size(evdev->handle.dev);
 
@@ -915,24 +924,18 @@ static const struct file_operations evdev_fops = {
 	.llseek		= no_llseek,
 };
 
-static int evdev_install_chrdev(struct evdev *evdev)
-{
-	/*
-	 * No need to do any locking here as calls to connect and
-	 * disconnect are serialized by the input core
-	 */
-	evdev_table[evdev->minor] = evdev;
-	return 0;
-}
-
 static void evdev_remove_chrdev(struct evdev *evdev)
 {
 	/*
 	 * Lock evdev table to prevent race with evdev_open()
 	 */
-	mutex_lock(&evdev_table_mutex);
-	evdev_table[evdev->minor] = NULL;
-	mutex_unlock(&evdev_table_mutex);
+	if (evdev->minor > EVDEV_MINOR_MAX) {
+		input_minor_free(evdev->minor);
+	} else {
+		mutex_lock(&evdev_table_mutex);
+		evdev_table[evdev->minor] = NULL;
+		mutex_unlock(&evdev_table_mutex);
+	}
 }
 
 /*
@@ -973,19 +976,33 @@ static int evdev_connect(struct input_handler *handler, struct input_dev *dev,
 	int minor;
 	int error;
 
-	for (minor = 0; minor < EVDEV_MINORS; minor++)
-		if (!evdev_table[minor])
+	evdev = kzalloc(sizeof(struct evdev), GFP_KERNEL);
+	if (!evdev)
+		return -ENOMEM;
+
+	/*
+	 * No need to do any locking here as calls to connect and
+	 * disconnect are serialized by the input core
+	 */
+	for (minor = 0; minor < EVDEV_MINORS; minor++) {
+		if (!evdev_table[minor]) {
+			evdev_table[minor] = evdev;
+			evdev->dev.devt = MKDEV(INPUT_MAJOR,
+						EVDEV_MINOR_BASE + minor);
 			break;
+		}
+	}
 
 	if (minor == EVDEV_MINORS) {
-		pr_err("no more free evdev devices\n");
-		return -ENFILE;
+		minor = input_minor_alloc(handler, evdev);
+		if (minor < 0) {
+			pr_err("no more free evdev devices\n");
+			kfree(evdev);
+			return minor;
+		}
+		evdev->dev.devt = MKDEV(INPUT_MAJOR, minor);
 	}
 
-	evdev = kzalloc(sizeof(struct evdev), GFP_KERNEL);
-	if (!evdev)
-		return -ENOMEM;
-
 	INIT_LIST_HEAD(&evdev->client_list);
 	spin_lock_init(&evdev->client_lock);
 	mutex_init(&evdev->mutex);
@@ -1000,7 +1017,6 @@ static int evdev_connect(struct input_handler *handler, struct input_dev *dev,
 	evdev->handle.handler = handler;
 	evdev->handle.private = evdev;
 
-	evdev->dev.devt = MKDEV(INPUT_MAJOR, EVDEV_MINOR_BASE + minor);
 	evdev->dev.class = &input_class;
 	evdev->dev.parent = &dev->dev;
 	evdev->dev.release = evdev_free;
@@ -1010,21 +1026,16 @@ static int evdev_connect(struct input_handler *handler, struct input_dev *dev,
 	if (error)
 		goto err_free_evdev;
 
-	error = evdev_install_chrdev(evdev);
-	if (error)
-		goto err_unregister_handle;
-
 	error = device_add(&evdev->dev);
 	if (error)
-		goto err_cleanup_evdev;
+		goto err_unregister_handle;
 
 	return 0;
 
- err_cleanup_evdev:
-	evdev_cleanup(evdev);
  err_unregister_handle:
 	input_unregister_handle(&evdev->handle);
  err_free_evdev:
+	evdev_cleanup(evdev);
 	put_device(&evdev->dev);
 	return error;
 }
-- 
1.7.12

