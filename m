Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755183Ab2LKXMu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2012 18:12:50 -0500
Received: from www.linutronix.de ([62.245.132.108]:44889 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754006Ab2LKXMc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2012 18:12:32 -0500
From: Benedikt Spranger <b.spranger@linutronix.de>
To: linux-kernel@vger.kernel.org
Cc: hjk@hansjkoch.de, gregkh@linuxfoundation.org,
        Alexander.Frank@eberspaecher.com,
        Benedikt Spranger <b.spranger@linutronix.de>
Subject: [PATCH 2/2] uio: do not expose inode to uio open/release hooks
Date: Wed, 12 Dec 2012 00:12:02 +0100
Message-Id: <1355267523-19724-3-git-send-email-b.spranger@linutronix.de>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1355267523-19724-1-git-send-email-b.spranger@linutronix.de>
References: <1355267523-19724-1-git-send-email-b.spranger@linutronix.de>
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The inode parameter is unused by in kernel users of UIO. Also the inode
parameter makes it hard to resolve the existing open(), mmap() and close()
difficulty.

Signed-off-by: Benedikt Spranger <b.spranger@linutronix.de>
---
 Documentation/DocBook/uio-howto.tmpl |    4 ++--
 drivers/uio/uio.c                    |    4 ++--
 include/linux/uio_driver.h           |    4 ++--
 3 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/Documentation/DocBook/uio-howto.tmpl b/Documentation/DocBook/uio-howto.tmpl
index 59a886d..589992e 100644
--- a/Documentation/DocBook/uio-howto.tmpl
+++ b/Documentation/DocBook/uio-howto.tmpl
@@ -490,14 +490,14 @@ instead of the built-in one.
 </para></listitem>
 
 <listitem><para>
-<varname>int (*open)(struct uio_info *info, struct inode *inode)
+<varname>int (*open)(struct uio_info *info)
 </varname>: Optional. You might want to have your own
 <function>open()</function>, e.g. to enable interrupts only when your
 device is actually used.
 </para></listitem>
 
 <listitem><para>
-<varname>int (*release)(struct uio_info *info, struct inode *inode)
+<varname>int (*release)(struct uio_info *info)
 </varname>: Optional. If you define your own
 <function>release()</function>, you will probably also want a custom
 <function>release()</function> function.
diff --git a/drivers/uio/uio.c b/drivers/uio/uio.c
index 5110f36..bbffc38 100644
--- a/drivers/uio/uio.c
+++ b/drivers/uio/uio.c
@@ -465,7 +465,7 @@ static int uio_open(struct inode *inode, struct file *filep)
 	filep->private_data = listener;
 
 	if (idev->info->open) {
-		ret = idev->info->open(idev->info, inode);
+		ret = idev->info->open(idev->info);
 		if (ret)
 			goto err_infoopen;
 	}
@@ -496,7 +496,7 @@ static int uio_release(struct inode *inode, struct file *filep)
 	struct uio_device *idev = listener->dev;
 
 	if (idev->info->release)
-		ret = idev->info->release(idev->info, inode);
+		ret = idev->info->release(idev->info);
 
 	module_put(idev->owner);
 	kfree(listener);
diff --git a/include/linux/uio_driver.h b/include/linux/uio_driver.h
index 1ad4724..ad59ded 100644
--- a/include/linux/uio_driver.h
+++ b/include/linux/uio_driver.h
@@ -92,8 +92,8 @@ struct uio_info {
 	void			*priv;
 	irqreturn_t (*handler)(int irq, struct uio_info *dev_info);
 	int (*mmap)(struct uio_info *info, struct vm_area_struct *vma);
-	int (*open)(struct uio_info *info, struct inode *inode);
-	int (*release)(struct uio_info *info, struct inode *inode);
+	int (*open)(struct uio_info *info);
+	int (*release)(struct uio_info *info);
 	int (*irqcontrol)(struct uio_info *info, s32 irq_on);
 };
 
-- 
1.7.10.4

