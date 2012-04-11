Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933865Ab2DLAC5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 20:02:57 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:39063 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933804Ab2DKXQC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 19:16:02 -0400
Message-Id: <20120411231025.070051172@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Wed, 11 Apr 2012 16:10:58 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Stephen Boyd <sboyd@codeaurora.org>
Subject: [ 40/78] firmware_class: Split _request_firmware() into three functions, v2
In-Reply-To: <20120411231102.GA6404@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Rafael J. Wysocki" <rjw@sisk.pl>

commit 811fa4004485dec8977176bf605a5b0508ee206c upstream.

Split _request_firmware() into three functions,
_request_firmware_prepare() doing preparatory work that need not be
done under umhelper_sem, _request_firmware_cleanup() doing the
post-error cleanup and _request_firmware() carrying out the remaining
operations.

This change is requisite for moving the acquisition of umhelper_sem
from _request_firmware() to the callers, which is going to be done
subsequently.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Reviewed-by: Stephen Boyd <sboyd@codeaurora.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/base/firmware_class.c |   58 +++++++++++++++++++++++++++++-------------
 1 file changed, 41 insertions(+), 17 deletions(-)

--- a/drivers/base/firmware_class.c
+++ b/drivers/base/firmware_class.c
@@ -435,7 +435,7 @@ static void firmware_class_timeout(u_lon
 }
 
 static struct firmware_priv *
-fw_create_instance(struct firmware *firmware, const char *fw_name,
+fw_create_instance(const struct firmware *firmware, const char *fw_name,
 		   struct device *device, bool uevent, bool nowait)
 {
 	struct firmware_priv *fw_priv;
@@ -449,7 +449,7 @@ fw_create_instance(struct firmware *firm
 		goto err_out;
 	}
 
-	fw_priv->fw = firmware;
+	fw_priv->fw = (struct firmware *)firmware;
 	fw_priv->nowait = nowait;
 	strcpy(fw_priv->fw_id, fw_name);
 	init_completion(&fw_priv->completion);
@@ -510,13 +510,10 @@ static void fw_destroy_instance(struct f
 	device_unregister(f_dev);
 }
 
-static int _request_firmware(const struct firmware **firmware_p,
-			     const char *name, struct device *device,
-			     bool uevent, bool nowait)
+static int _request_firmware_prepare(const struct firmware **firmware_p,
+				     const char *name, struct device *device)
 {
-	struct firmware_priv *fw_priv;
 	struct firmware *firmware;
-	int retval = 0;
 
 	if (!firmware_p)
 		return -EINVAL;
@@ -533,10 +530,26 @@ static int _request_firmware(const struc
 		return 0;
 	}
 
+	return 1;
+}
+
+static void _request_firmware_cleanup(const struct firmware **firmware_p)
+{
+	release_firmware(*firmware_p);
+	*firmware_p = NULL;
+}
+
+static int _request_firmware(const struct firmware *firmware,
+			     const char *name, struct device *device,
+			     bool uevent, bool nowait)
+{
+	struct firmware_priv *fw_priv;
+	int retval;
+
 	retval = usermodehelper_read_trylock();
 	if (WARN_ON(retval)) {
 		dev_err(device, "firmware: %s will not be loaded\n", name);
-		goto out_nolock;
+		return retval;
 	}
 
 	if (uevent)
@@ -572,13 +585,6 @@ static int _request_firmware(const struc
 
 out:
 	usermodehelper_read_unlock();
-
-out_nolock:
-	if (retval) {
-		release_firmware(firmware);
-		*firmware_p = NULL;
-	}
-
 	return retval;
 }
 
@@ -601,7 +607,17 @@ int
 request_firmware(const struct firmware **firmware_p, const char *name,
                  struct device *device)
 {
-        return _request_firmware(firmware_p, name, device, true, false);
+	int ret;
+
+	ret = _request_firmware_prepare(firmware_p, name, device);
+	if (ret <= 0)
+		return ret;
+
+	ret = _request_firmware(*firmware_p, name, device, true, false);
+	if (ret)
+		_request_firmware_cleanup(firmware_p);
+
+	return ret;
 }
 
 /**
@@ -639,8 +655,16 @@ static int request_firmware_work_func(vo
 		return 0;
 	}
 
-	ret = _request_firmware(&fw, fw_work->name, fw_work->device,
+	ret = _request_firmware_prepare(&fw, fw_work->name, fw_work->device);
+	if (ret <= 0)
+		goto out;
+
+	ret = _request_firmware(fw, fw_work->name, fw_work->device,
 				fw_work->uevent, true);
+	if (ret)
+		_request_firmware_cleanup(&fw);
+
+ out:
 	fw_work->cont(fw, fw_work->context);
 
 	module_put(fw_work->module);


