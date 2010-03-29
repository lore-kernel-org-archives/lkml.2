Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754267Ab0C2P51 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Mar 2010 11:57:27 -0400
Received: from he.sipsolutions.net ([78.46.109.217]:32991 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754094Ab0C2P5Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Mar 2010 11:57:25 -0400
Subject: [PATCH] firmware class: export nowait to userspace
From: Johannes Berg <johannes@sipsolutions.net>
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Tomas Winkler <tomasw@gmail.com>,
       Greg KH <greg@kroah.com>, David Woodhouse <dwmw2@infradead.org>
In-Reply-To: <ac3eb2511003112129i2274b018m7e059f348d5f983a@mail.gmail.com>
References: <1268347174.4142.11.camel@jlt3.sipsolutions.net>
	 <1268348199.4142.33.camel@jlt3.sipsolutions.net>
	 <ac3eb2511003112021o647a288dr453836bb94460af4@mail.gmail.com>
	 <1268369163.4828.1.camel@jlt3.sipsolutions.net>
	 <ac3eb2511003112129i2274b018m7e059f348d5f983a@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 29 Mar 2010 17:57:20 +0200
Message-ID: <1269878240.4131.45.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.29.91 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

When we use request_firmware_nowait(), userspace may
not want to answer negatively right away when for
example it is answering from an initrd only, but
with request_firmware() it has to in order to not
delay the kernel boot until the request times out.

This allows userspace to differentiate between the
two in order to be able to reply negatively to async
requests only when all filesystems have been mounted
and have been checked for the requested firmware file.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
Oops, changed the patch but forgot to resend.

 drivers/base/firmware_class.c |   16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

--- wireless-testing.orig/drivers/base/firmware_class.c	2010-03-23 06:14:21.000000000 +0100
+++ wireless-testing/drivers/base/firmware_class.c	2010-03-29 17:56:14.000000000 +0200
@@ -49,6 +49,7 @@ struct firmware_priv {
 	int page_array_size;
 	const char *vdata;
 	struct timer_list timeout;
+	bool nowait;
 };
 
 #ifdef CONFIG_FW_LOADER
@@ -111,6 +112,8 @@ static int firmware_uevent(struct device
 		return -ENOMEM;
 	if (add_uevent_var(env, "TIMEOUT=%i", loading_timeout))
 		return -ENOMEM;
+	if (add_uevent_var(env, "ASYNC=%d", fw_priv->nowait))
+		return -ENOMEM;
 
 	return 0;
 }
@@ -426,7 +429,7 @@ error_kfree:
 
 static int fw_setup_device(struct firmware *fw, struct device **dev_p,
 			   const char *fw_name, struct device *device,
-			   int uevent)
+			   int uevent, bool nowait)
 {
 	struct device *f_dev;
 	struct firmware_priv *fw_priv;
@@ -442,6 +445,8 @@ static int fw_setup_device(struct firmwa
 
 	fw_priv = dev_get_drvdata(f_dev);
 
+	fw_priv->nowait = nowait;
+
 	fw_priv->fw = fw;
 	sysfs_bin_attr_init(&fw_priv->attr_data);
 	retval = sysfs_create_bin_file(&f_dev->kobj, &fw_priv->attr_data);
@@ -469,7 +474,7 @@ out:
 
 static int
 _request_firmware(const struct firmware **firmware_p, const char *name,
-		 struct device *device, int uevent)
+		 struct device *device, int uevent, bool nowait)
 {
 	struct device *f_dev;
 	struct firmware_priv *fw_priv;
@@ -502,7 +507,8 @@ _request_firmware(const struct firmware
 	if (uevent)
 		dev_info(device, "firmware: requesting %s\n", name);
 
-	retval = fw_setup_device(firmware, &f_dev, name, device, uevent);
+	retval = fw_setup_device(firmware, &f_dev, name, device,
+				 uevent, nowait);
 	if (retval)
 		goto error_kfree_fw;
 
@@ -559,7 +565,7 @@ request_firmware(const struct firmware *
                  struct device *device)
 {
         int uevent = 1;
-        return _request_firmware(firmware_p, name, device, uevent);
+        return _request_firmware(firmware_p, name, device, uevent, false);
 }
 
 /**
@@ -605,7 +611,7 @@ request_firmware_work_func(void *arg)
 		return 0;
 	}
 	ret = _request_firmware(&fw, fw_work->name, fw_work->device,
-		fw_work->uevent);
+		fw_work->uevent, true);
 
 	fw_work->cont(fw, fw_work->context);
 


