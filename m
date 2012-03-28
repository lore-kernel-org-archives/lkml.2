Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933002Ab2C1VXO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2012 17:23:14 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:40763 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758761Ab2C1VWg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2012 17:22:36 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: linux-kernel@vger.kernel.org
Subject: [PATCH v2 2/8] firmware_class: Split _request_firmware() into three functions, v2
Date: Wed, 28 Mar 2012 23:21:34 +0200
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
Message-Id: <201203282321.34628.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

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
---
 drivers/base/firmware_class.c |   58 +++++++++++++++++++++++++++++-------------
 1 file changed, 41 insertions(+), 17 deletions(-)

Index: linux/drivers/base/firmware_class.c
===================================================================
--- linux.orig/drivers/base/firmware_class.c
+++ linux/drivers/base/firmware_class.c
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

