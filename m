Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423441Ab2LFMrk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2012 07:47:40 -0500
Received: from www.linutronix.de ([62.245.132.108]:51740 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423421Ab2LFMri (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2012 07:47:38 -0500
From: Benedikt Spranger <b.spranger@linutronix.de>
To: linux-kernel@vger.kernel.org
Cc: hjk@hansjkoch.de, gregkh@linuxfoundation.org,
        Alexander.Frank@eberspaecher.com,
        Benedikt Spranger <b.spranger@linutronix.de>
Subject: [PATCH 2/2] uio: avoid module unloding of in module created UIO devices
Date: Thu,  6 Dec 2012 13:44:57 +0100
Message-Id: <1354797897-23423-3-git-send-email-b.spranger@linutronix.de>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1354797897-23423-1-git-send-email-b.spranger@linutronix.de>
References: <1354797897-23423-1-git-send-email-b.spranger@linutronix.de>
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A kernel module can create a uio device. Get a reference to the module, if the
UIO device is in use. Otherwise the device can be removed and a uio write or an
access to am mmaped memory can cause a kernel Oops or other strange effects.

Signed-off-by: Benedikt Spranger <b.spranger@linutronix.de>
---
 drivers/uio/uio.c          |    8 ++++++++
 include/linux/uio_driver.h |    1 +
 2 files changed, 9 insertions(+)

diff --git a/drivers/uio/uio.c b/drivers/uio/uio.c
index b96499a..3b62da0 100644
--- a/drivers/uio/uio.c
+++ b/drivers/uio/uio.c
@@ -446,6 +446,7 @@ static void uio_release_listener(struct kref *kref)
 		idev->info->release(idev->info);
 
 	module_put(idev->owner);
+	module_put(idev->info->owner);
 	kfree(listener);
 }
 
@@ -468,6 +469,11 @@ static int uio_open(struct inode *inode, struct file *filep)
 		goto out;
 	}
 
+	if (!try_module_get(idev->info->owner)) {
+		ret = -ENODEV;
+		goto err_get_module;
+	}
+
 	listener = kmalloc(sizeof(*listener), GFP_KERNEL);
 	if (!listener) {
 		ret = -ENOMEM;
@@ -493,6 +499,8 @@ err_infoopen:
 
 err_alloc_listener:
 	module_put(idev->owner);
+err_get_module:
+	module_put(idev->owner);
 
 out:
 	return ret;
diff --git a/include/linux/uio_driver.h b/include/linux/uio_driver.h
index 1bc6493..2862de23 100644
--- a/include/linux/uio_driver.h
+++ b/include/linux/uio_driver.h
@@ -95,6 +95,7 @@ struct uio_info {
 	int (*open)(struct uio_info *info);
 	void (*release)(struct uio_info *info);
 	int (*irqcontrol)(struct uio_info *info, s32 irq_on);
+	struct module		*owner;
 };
 
 extern int __must_check
-- 
1.7.10.4

