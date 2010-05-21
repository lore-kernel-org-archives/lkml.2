Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934368Ab0EURAk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 May 2010 13:00:40 -0400
Received: from kroah.org ([198.145.64.141]:39108 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934238Ab0EUQyU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 May 2010 12:54:20 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Dmitry Torokhov <dtor@mail.ru>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 13/38] firmware loader: rely on driver core to create class attribute
Date: Fri, 21 May 2010 09:53:43 -0700
Message-Id: <1274460848-11377-13-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.0.3
In-Reply-To: <20100521165106.GA11216@kroah.com>
References: <20100521165106.GA11216@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dmitry Torokhov <dmitry.torokhov@gmail.com>

Do not create 'timeout' attribute manually, let driver core do it for us.
This also ensures that attribute is cleaned up properly.

Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/base/firmware_class.c |   59 ++++++++++++++++------------------------
 1 files changed, 24 insertions(+), 35 deletions(-)

diff --git a/drivers/base/firmware_class.c b/drivers/base/firmware_class.c
index d45d1e1..d351e77 100644
--- a/drivers/base/firmware_class.c
+++ b/drivers/base/firmware_class.c
@@ -101,9 +101,26 @@ firmware_timeout_store(struct class *class,
 	return count;
 }
 
-static CLASS_ATTR(timeout, 0644, firmware_timeout_show, firmware_timeout_store);
+static struct class_attribute firmware_class_attrs[] = {
+	__ATTR(timeout, S_IWUSR | S_IRUGO,
+		firmware_timeout_show, firmware_timeout_store),
+	__ATTR_NULL
+};
 
-static void fw_dev_release(struct device *dev);
+static void fw_dev_release(struct device *dev)
+{
+	struct firmware_priv *fw_priv = dev_get_drvdata(dev);
+	int i;
+
+	for (i = 0; i < fw_priv->nr_pages; i++)
+		__free_page(fw_priv->pages[i]);
+	kfree(fw_priv->pages);
+	kfree(fw_priv->fw_id);
+	kfree(fw_priv);
+	kfree(dev);
+
+	module_put(THIS_MODULE);
+}
 
 static int firmware_uevent(struct device *dev, struct kobj_uevent_env *env)
 {
@@ -121,6 +138,7 @@ static int firmware_uevent(struct device *dev, struct kobj_uevent_env *env)
 
 static struct class firmware_class = {
 	.name		= "firmware",
+	.class_attrs	= firmware_class_attrs,
 	.dev_uevent	= firmware_uevent,
 	.dev_release	= fw_dev_release,
 };
@@ -370,21 +388,6 @@ static struct bin_attribute firmware_attr_data_tmpl = {
 	.write = firmware_data_write,
 };
 
-static void fw_dev_release(struct device *dev)
-{
-	struct firmware_priv *fw_priv = dev_get_drvdata(dev);
-	int i;
-
-	for (i = 0; i < fw_priv->nr_pages; i++)
-		__free_page(fw_priv->pages[i]);
-	kfree(fw_priv->pages);
-	kfree(fw_priv->fw_id);
-	kfree(fw_priv);
-	kfree(dev);
-
-	module_put(THIS_MODULE);
-}
-
 static void
 firmware_class_timeout(u_long data)
 {
@@ -689,26 +692,12 @@ request_firmware_nowait(
 	return 0;
 }
 
-static int __init
-firmware_class_init(void)
+static int __init firmware_class_init(void)
 {
-	int error;
-	error = class_register(&firmware_class);
-	if (error) {
-		printk(KERN_ERR "%s: class_register failed\n", __func__);
-		return error;
-	}
-	error = class_create_file(&firmware_class, &class_attr_timeout);
-	if (error) {
-		printk(KERN_ERR "%s: class_create_file failed\n",
-		       __func__);
-		class_unregister(&firmware_class);
-	}
-	return error;
-
+	return class_register(&firmware_class);
 }
-static void __exit
-firmware_class_exit(void)
+
+static void __exit firmware_class_exit(void)
 {
 	class_unregister(&firmware_class);
 }
-- 
1.7.0.3

