Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934374Ab0EURAv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 May 2010 13:00:51 -0400
Received: from kroah.org ([198.145.64.141]:39104 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934234Ab0EUQyU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 May 2010 12:54:20 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>,
       Kay Sievers <kay.sievers@vrfy.org>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 12/38] firmware class: export nowait to userspace
Date: Fri, 21 May 2010 09:53:42 -0700
Message-Id: <1274460848-11377-12-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.0.3
In-Reply-To: <20100521165106.GA11216@kroah.com>
References: <20100521165106.GA11216@kroah.com>
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
Cc: Kay Sievers <kay.sievers@vrfy.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/base/firmware_class.c |   16 +++++++++++-----
 1 files changed, 11 insertions(+), 5 deletions(-)

diff --git a/drivers/base/firmware_class.c b/drivers/base/firmware_class.c
index 8e6c62b..d45d1e1 100644
--- a/drivers/base/firmware_class.c
+++ b/drivers/base/firmware_class.c
@@ -50,6 +50,7 @@ struct firmware_priv {
 	int page_array_size;
 	const char *vdata;
 	struct timer_list timeout;
+	bool nowait;
 };
 
 #ifdef CONFIG_FW_LOADER
@@ -112,6 +113,8 @@ static int firmware_uevent(struct device *dev, struct kobj_uevent_env *env)
 		return -ENOMEM;
 	if (add_uevent_var(env, "TIMEOUT=%i", loading_timeout))
 		return -ENOMEM;
+	if (add_uevent_var(env, "ASYNC=%d", fw_priv->nowait))
+		return -ENOMEM;
 
 	return 0;
 }
@@ -441,7 +444,7 @@ error_kfree:
 
 static int fw_setup_device(struct firmware *fw, struct device **dev_p,
 			   const char *fw_name, struct device *device,
-			   int uevent)
+			   int uevent, bool nowait)
 {
 	struct device *f_dev;
 	struct firmware_priv *fw_priv;
@@ -457,6 +460,8 @@ static int fw_setup_device(struct firmware *fw, struct device **dev_p,
 
 	fw_priv = dev_get_drvdata(f_dev);
 
+	fw_priv->nowait = nowait;
+
 	fw_priv->fw = fw;
 	sysfs_bin_attr_init(&fw_priv->attr_data);
 	retval = sysfs_create_bin_file(&f_dev->kobj, &fw_priv->attr_data);
@@ -484,7 +489,7 @@ out:
 
 static int
 _request_firmware(const struct firmware **firmware_p, const char *name,
-		 struct device *device, int uevent)
+		 struct device *device, int uevent, bool nowait)
 {
 	struct device *f_dev;
 	struct firmware_priv *fw_priv;
@@ -516,7 +521,8 @@ _request_firmware(const struct firmware **firmware_p, const char *name,
 	if (uevent)
 		dev_dbg(device, "firmware: requesting %s\n", name);
 
-	retval = fw_setup_device(firmware, &f_dev, name, device, uevent);
+	retval = fw_setup_device(firmware, &f_dev, name, device,
+				 uevent, nowait);
 	if (retval)
 		goto error_kfree_fw;
 
@@ -573,7 +579,7 @@ request_firmware(const struct firmware **firmware_p, const char *name,
                  struct device *device)
 {
         int uevent = 1;
-        return _request_firmware(firmware_p, name, device, uevent);
+        return _request_firmware(firmware_p, name, device, uevent, false);
 }
 
 /**
@@ -619,7 +625,7 @@ request_firmware_work_func(void *arg)
 		return 0;
 	}
 	ret = _request_firmware(&fw, fw_work->name, fw_work->device,
-		fw_work->uevent);
+		fw_work->uevent, true);
 
 	fw_work->cont(fw, fw_work->context);
 
-- 
1.7.0.3

