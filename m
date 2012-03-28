Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933106Ab2C1VYB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2012 17:24:01 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:40809 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758805Ab2C1VXL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2012 17:23:11 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: linux-kernel@vger.kernel.org
Subject: [PATCH v2 7/8] firmware_class: Reorganize fw_create_instance()
Date: Wed, 28 Mar 2012 23:25:16 +0200
User-Agent: KMail/1.13.6 (Linux/3.3.0+; KDE/4.6.0; x86_64; ; )
Cc: Stephen Boyd <sboyd@codeaurora.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Saravana Kannan <skannan@codeaurora.org>,
        Kay Sievers <kay.sievers@vrfy.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        Christian Lamparter <chunkeey@googlemail.com>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        alan@lxorguk.ukuu.org.uk,
        Linux PM mailing list <linux-pm@vger.kernel.org>
References: <201203032122.36745.chunkeey@googlemail.com> <201203260000.34377.rjw@sisk.pl> <201203282319.54708.rjw@sisk.pl>
In-Reply-To: <201203282319.54708.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201203282325.16902.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Boyd <sboyd@codeaurora.org>

Recent patches to split up the three phases of request_firmware()
lead to a casting away of const in fw_create_instance(). We can
avoid this cast by splitting up fw_create_instance() a bit.

Make _request_firmware_setup() return a struct fw_priv and use
that struct instead of passing struct firmware to
_request_firmware(). Move the uevent and device file creation
bits to the loading phase and rename the function to
_request_firmware_load() to better reflect its purpose.

Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 drivers/base/firmware_class.c |  135 +++++++++++++++++++-----------------------
 1 file changed, 62 insertions(+), 73 deletions(-)

Index: linux/drivers/base/firmware_class.c
===================================================================
--- linux.orig/drivers/base/firmware_class.c
+++ linux/drivers/base/firmware_class.c
@@ -440,21 +440,19 @@ static void firmware_class_timeout(u_lon
 }
 
 static struct firmware_priv *
-fw_create_instance(const struct firmware *firmware, const char *fw_name,
+fw_create_instance(struct firmware *firmware, const char *fw_name,
 		   struct device *device, bool uevent, bool nowait)
 {
 	struct firmware_priv *fw_priv;
 	struct device *f_dev;
-	int error;
 
 	fw_priv = kzalloc(sizeof(*fw_priv) + strlen(fw_name) + 1 , GFP_KERNEL);
 	if (!fw_priv) {
 		dev_err(device, "%s: kmalloc failed\n", __func__);
-		error = -ENOMEM;
-		goto err_out;
+		return ERR_PTR(-ENOMEM);
 	}
 
-	fw_priv->fw = (struct firmware *)firmware;
+	fw_priv->fw = firmware;
 	fw_priv->nowait = nowait;
 	strcpy(fw_priv->fw_id, fw_name);
 	init_completion(&fw_priv->completion);
@@ -468,74 +466,37 @@ fw_create_instance(const struct firmware
 	f_dev->parent = device;
 	f_dev->class = &firmware_class;
 
-	dev_set_uevent_suppress(f_dev, true);
-
-	/* Need to pin this module until class device is destroyed */
-	__module_get(THIS_MODULE);
-
-	error = device_add(f_dev);
-	if (error) {
-		dev_err(device, "%s: device_register failed\n", __func__);
-		goto err_put_dev;
-	}
-
-	error = device_create_bin_file(f_dev, &firmware_attr_data);
-	if (error) {
-		dev_err(device, "%s: sysfs_create_bin_file failed\n", __func__);
-		goto err_del_dev;
-	}
-
-	error = device_create_file(f_dev, &dev_attr_loading);
-	if (error) {
-		dev_err(device, "%s: device_create_file failed\n", __func__);
-		goto err_del_bin_attr;
-	}
-
-	if (uevent)
-		dev_set_uevent_suppress(f_dev, false);
-
 	return fw_priv;
-
-err_del_bin_attr:
-	device_remove_bin_file(f_dev, &firmware_attr_data);
-err_del_dev:
-	device_del(f_dev);
-err_put_dev:
-	put_device(f_dev);
-err_out:
-	return ERR_PTR(error);
 }
 
-static void fw_destroy_instance(struct firmware_priv *fw_priv)
-{
-	struct device *f_dev = &fw_priv->dev;
-
-	device_remove_file(f_dev, &dev_attr_loading);
-	device_remove_bin_file(f_dev, &firmware_attr_data);
-	device_unregister(f_dev);
-}
-
-static int _request_firmware_prepare(const struct firmware **firmware_p,
-				     const char *name, struct device *device)
+static struct firmware_priv *
+_request_firmware_prepare(const struct firmware **firmware_p, const char *name,
+			  struct device *device, bool uevent, bool nowait)
 {
 	struct firmware *firmware;
+	struct firmware_priv *fw_priv;
 
 	if (!firmware_p)
-		return -EINVAL;
+		return ERR_PTR(-EINVAL);
 
 	*firmware_p = firmware = kzalloc(sizeof(*firmware), GFP_KERNEL);
 	if (!firmware) {
 		dev_err(device, "%s: kmalloc(struct firmware) failed\n",
 			__func__);
-		return -ENOMEM;
+		return ERR_PTR(-ENOMEM);
 	}
 
 	if (fw_get_builtin_firmware(firmware, name)) {
 		dev_dbg(device, "firmware: using built-in firmware %s\n", name);
-		return 0;
+		return NULL;
 	}
 
-	return 1;
+	fw_priv = fw_create_instance(firmware, name, device, uevent, nowait);
+	if (IS_ERR(fw_priv)) {
+		release_firmware(firmware);
+		*firmware_p = NULL;
+	}
+	return fw_priv;
 }
 
 static void _request_firmware_cleanup(const struct firmware **firmware_p)
@@ -544,21 +505,38 @@ static void _request_firmware_cleanup(co
 	*firmware_p = NULL;
 }
 
-static int _request_firmware(const struct firmware *firmware,
-			     const char *name, struct device *device,
-			     bool uevent, bool nowait, long timeout)
+static int _request_firmware_load(struct firmware_priv *fw_priv, bool uevent,
+				  long timeout)
 {
-	struct firmware_priv *fw_priv;
 	int retval = 0;
+	struct device *f_dev = &fw_priv->dev;
+
+	dev_set_uevent_suppress(f_dev, true);
 
-	if (uevent)
-		dev_dbg(device, "firmware: requesting %s\n", name);
+	/* Need to pin this module until class device is destroyed */
+	__module_get(THIS_MODULE);
 
-	fw_priv = fw_create_instance(firmware, name, device, uevent, nowait);
-	if (IS_ERR(fw_priv))
-		return PTR_ERR(fw_priv);
+	retval = device_add(f_dev);
+	if (retval) {
+		dev_err(f_dev, "%s: device_register failed\n", __func__);
+		goto err_put_dev;
+	}
+
+	retval = device_create_bin_file(f_dev, &firmware_attr_data);
+	if (retval) {
+		dev_err(f_dev, "%s: sysfs_create_bin_file failed\n", __func__);
+		goto err_del_dev;
+	}
+
+	retval = device_create_file(f_dev, &dev_attr_loading);
+	if (retval) {
+		dev_err(f_dev, "%s: device_create_file failed\n", __func__);
+		goto err_del_bin_attr;
+	}
 
 	if (uevent) {
+		dev_set_uevent_suppress(f_dev, false);
+		dev_dbg(f_dev, "firmware: requesting %s\n", fw_priv->fw_id);
 		if (timeout != MAX_SCHEDULE_TIMEOUT)
 			mod_timer(&fw_priv->timeout,
 				  round_jiffies_up(jiffies + timeout));
@@ -577,7 +555,13 @@ static int _request_firmware(const struc
 	fw_priv->fw = NULL;
 	mutex_unlock(&fw_lock);
 
-	fw_destroy_instance(fw_priv);
+	device_remove_file(f_dev, &dev_attr_loading);
+err_del_bin_attr:
+	device_remove_bin_file(f_dev, &firmware_attr_data);
+err_del_dev:
+	device_del(f_dev);
+err_put_dev:
+	put_device(f_dev);
 	return retval;
 }
 
@@ -600,17 +584,19 @@ int
 request_firmware(const struct firmware **firmware_p, const char *name,
                  struct device *device)
 {
+	struct firmware_priv *fw_priv;
 	int ret;
 
-	ret = _request_firmware_prepare(firmware_p, name, device);
-	if (ret <= 0)
-		return ret;
+	fw_priv = _request_firmware_prepare(firmware_p, name, device, true,
+					    false);
+	if (IS_ERR_OR_NULL(fw_priv))
+		return PTR_RET(fw_priv);
 
 	ret = usermodehelper_read_trylock();
 	if (WARN_ON(ret)) {
 		dev_err(device, "firmware: %s will not be loaded\n", name);
 	} else {
-		ret = _request_firmware(*firmware_p, name, device, true, false,
+		ret = _request_firmware_load(fw_priv, true,
 					firmware_loading_timeout());
 		usermodehelper_read_unlock();
 	}
@@ -648,6 +634,7 @@ static int request_firmware_work_func(vo
 {
 	struct firmware_work *fw_work = arg;
 	const struct firmware *fw;
+	struct firmware_priv *fw_priv;
 	long timeout;
 	int ret;
 
@@ -656,14 +643,16 @@ static int request_firmware_work_func(vo
 		return 0;
 	}
 
-	ret = _request_firmware_prepare(&fw, fw_work->name, fw_work->device);
-	if (ret <= 0)
+	fw_priv = _request_firmware_prepare(&fw, fw_work->name, fw_work->device,
+			fw_work->uevent, true);
+	if (IS_ERR_OR_NULL(fw_priv)) {
+		ret = PTR_RET(fw_priv);
 		goto out;
+	}
 
 	timeout = usermodehelper_read_lock_wait(firmware_loading_timeout());
 	if (timeout) {
-		ret = _request_firmware(fw, fw_work->name, fw_work->device,
-					fw_work->uevent, true, timeout);
+		ret = _request_firmware_load(fw_priv, fw_work->uevent, timeout);
 		usermodehelper_read_unlock();
 	} else {
 		dev_dbg(fw_work->device, "firmware: %s loading timed out\n",

