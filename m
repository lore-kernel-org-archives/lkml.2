Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752259Ab1AZJzH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jan 2011 04:55:07 -0500
Received: from nwd2mail10.analog.com ([137.71.25.55]:62136 "EHLO
	nwd2mail10.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751159Ab1AZJzG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jan 2011 04:55:06 -0500
X-IronPort-AV: E=Sophos;i="4.60,379,1291611600"; 
   d="scan'208";a="28045140"
From: Bob Liu <lliubbo@gmail.com>
To: linux-kernel@vger.kernel.org
CC: chrisw@sous-sol.org, tomas.winkler@intel.com, johannes.berg@intel.com,
        dmitry.torokhov@gmail.com, gregkh@suse.de, Bob Liu <lliubbo@gmail.com>
Subject: [PATCH] firmware_classs: change val uevent's type to bool
Date: Wed, 26 Jan 2011 18:00:04 +0800
Message-ID: <1296036004-15644-1-git-send-email-lliubbo@gmail.com>
X-Mailer: git-send-email 1.6.3.3
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some place in firmware_class.c using "int uevent" define, but others use "bool
uevent".
This patch replace all int uevent define to bool and fix a place missing
uevent check.

Signed-off-by: Bob Liu <lliubbo@gmail.com>
---
 drivers/base/firmware_class.c |   10 +++++-----
 include/linux/firmware.h      |    4 ++--
 2 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/base/firmware_class.c b/drivers/base/firmware_class.c
index 40af43e..9ef8941 100644
--- a/drivers/base/firmware_class.c
+++ b/drivers/base/firmware_class.c
@@ -463,7 +463,8 @@ fw_create_instance(struct firmware *firmware, const char *fw_name,
 	f_dev->parent = device;
 	f_dev->class = &firmware_class;
 
-	dev_set_uevent_suppress(f_dev, true);
+	if (uevent)
+		dev_set_uevent_suppress(f_dev, true);
 
 	/* Need to pin this module until class device is destroyed */
 	__module_get(THIS_MODULE);
@@ -593,8 +594,7 @@ int
 request_firmware(const struct firmware **firmware_p, const char *name,
                  struct device *device)
 {
-        int uevent = 1;
-        return _request_firmware(firmware_p, name, device, uevent, false);
+        return _request_firmware(firmware_p, name, device, true, false);
 }
 
 /**
@@ -618,7 +618,7 @@ struct firmware_work {
 	struct device *device;
 	void *context;
 	void (*cont)(const struct firmware *fw, void *context);
-	int uevent;
+	bool uevent;
 };
 
 static int request_firmware_work_func(void *arg)
@@ -661,7 +661,7 @@ static int request_firmware_work_func(void *arg)
  **/
 int
 request_firmware_nowait(
-	struct module *module, int uevent,
+	struct module *module, bool uevent,
 	const char *name, struct device *device, gfp_t gfp, void *context,
 	void (*cont)(const struct firmware *fw, void *context))
 {
diff --git a/include/linux/firmware.h b/include/linux/firmware.h
index 53d1e6c..21b3e75 100644
--- a/include/linux/firmware.h
+++ b/include/linux/firmware.h
@@ -39,7 +39,7 @@ struct builtin_fw {
 int request_firmware(const struct firmware **fw, const char *name,
 		     struct device *device);
 int request_firmware_nowait(
-	struct module *module, int uevent,
+	struct module *module, bool uevent,
 	const char *name, struct device *device, gfp_t gfp, void *context,
 	void (*cont)(const struct firmware *fw, void *context));
 
@@ -52,7 +52,7 @@ static inline int request_firmware(const struct firmware **fw,
 	return -EINVAL;
 }
 static inline int request_firmware_nowait(
-	struct module *module, int uevent,
+	struct module *module, bool uevent,
 	const char *name, struct device *device, gfp_t gfp, void *context,
 	void (*cont)(const struct firmware *fw, void *context))
 {
-- 
1.6.3.3

