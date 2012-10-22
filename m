Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932267Ab2JVA52 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Oct 2012 20:57:28 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:37855 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754740Ab2JVA5Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Oct 2012 20:57:25 -0400
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Al Viro <viro@ZenIV.linux.org.uk>, Dave Jones <davej@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-input@vger.kernel.org
Subject: [PATCH 2/2] Input: fix use-after-free introduced with dynamic minor changes
Date: Sun, 21 Oct 2012 17:57:20 -0700
Message-Id: <1350867440-6109-2-git-send-email-dmitry.torokhov@gmail.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1350867440-6109-1-git-send-email-dmitry.torokhov@gmail.com>
References: <20121021073928.GV2616@ZenIV.linux.org.uk>
 <1350867440-6109-1-git-send-email-dmitry.torokhov@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 7f8d4cad1e4e11a45d02bd6e024cc2812963c38a made evdev, joydev and
mousedev to embed struct cdev into their respective structures representing
input devices. Unfortunately character device structure may outlive the
parent structure unless we do not set it up as parent of character device
so that it will stay pinned until character device is freed.

Also, now that parent structure is pinned while character device exists
we do not need to pin and unpin it every time user opens or closes it.

Reported-by: Dave Jones <davej@redhat.com>
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
---
 drivers/input/evdev.c    | 3 +--
 drivers/input/joydev.c   | 3 +--
 drivers/input/mousedev.c | 3 +--
 3 files changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/input/evdev.c b/drivers/input/evdev.c
index 6ae2ac4..f0f8928 100644
--- a/drivers/input/evdev.c
+++ b/drivers/input/evdev.c
@@ -292,7 +292,6 @@ static int evdev_release(struct inode *inode, struct file *file)
 	kfree(client);
 
 	evdev_close_device(evdev);
-	put_device(&evdev->dev);
 
 	return 0;
 }
@@ -331,7 +330,6 @@ static int evdev_open(struct inode *inode, struct file *file)
 	file->private_data = client;
 	nonseekable_open(inode, file);
 
-	get_device(&evdev->dev);
 	return 0;
 
  err_free_client:
@@ -1001,6 +999,7 @@ static int evdev_connect(struct input_handler *handler, struct input_dev *dev,
 		goto err_free_evdev;
 
 	cdev_init(&evdev->cdev, &evdev_fops);
+	evdev->cdev.kobj.parent = &evdev->dev.kobj;
 	error = cdev_add(&evdev->cdev, evdev->dev.devt, 1);
 	if (error)
 		goto err_unregister_handle;
diff --git a/drivers/input/joydev.c b/drivers/input/joydev.c
index 63e5916..9c7526d 100644
--- a/drivers/input/joydev.c
+++ b/drivers/input/joydev.c
@@ -262,7 +262,6 @@ static int joydev_release(struct inode *inode, struct file *file)
 	kfree(client);
 
 	joydev_close_device(joydev);
-	put_device(&joydev->dev);
 
 	return 0;
 }
@@ -289,7 +288,6 @@ static int joydev_open(struct inode *inode, struct file *file)
 	file->private_data = client;
 	nonseekable_open(inode, file);
 
-	get_device(&joydev->dev);
 	return 0;
 
  err_free_client:
@@ -877,6 +875,7 @@ static int joydev_connect(struct input_handler *handler, struct input_dev *dev,
 		goto err_free_joydev;
 
 	cdev_init(&joydev->cdev, &joydev_fops);
+	joydev->cdev.kobj.parent = &joydev->dev.kobj;
 	error = cdev_add(&joydev->cdev, joydev->dev.devt, 1);
 	if (error)
 		goto err_unregister_handle;
diff --git a/drivers/input/mousedev.c b/drivers/input/mousedev.c
index a1b4c37..8f02e3d 100644
--- a/drivers/input/mousedev.c
+++ b/drivers/input/mousedev.c
@@ -523,7 +523,6 @@ static int mousedev_release(struct inode *inode, struct file *file)
 	kfree(client);
 
 	mousedev_close_device(mousedev);
-	put_device(&mousedev->dev);
 
 	return 0;
 }
@@ -558,7 +557,6 @@ static int mousedev_open(struct inode *inode, struct file *file)
 	file->private_data = client;
 	nonseekable_open(inode, file);
 
-	get_device(&mousedev->dev);
 	return 0;
 
  err_free_client:
@@ -892,6 +890,7 @@ static struct mousedev *mousedev_create(struct input_dev *dev,
 	}
 
 	cdev_init(&mousedev->cdev, &mousedev_fops);
+	mousedev->cdev.kobj.parent = &mousedev->dev.kobj;
 	error = cdev_add(&mousedev->cdev, mousedev->dev.devt, 1);
 	if (error)
 		goto err_unregister_handle;
-- 
1.7.11.7

