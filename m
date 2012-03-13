Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751087Ab2CMMGO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 08:06:14 -0400
Received: from mail-ee0-f74.google.com ([74.125.83.74]:50460 "EHLO
	mail-ee0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752744Ab2CMMEc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 08:04:32 -0400
From: Daniel Kurtz <djkurtz@chromium.org>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Joonyoung Shim <jy0922.shim@samsung.com>,
        Iiro Valkonen <iiro.valkonen@atmel.com>,
        Henrik Rydberg <rydberg@euromail.se>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Benson Leung <bleung@chromium.org>, Yufeng Shen <miletus@chromium.org>,
        Daniel Kurtz <djkurtz@chromium.org>
Subject: [PATCH 07/20] Input: atmel_mxt_ts - add backupnv sysfs entry
Date: Tue, 13 Mar 2012 20:04:10 +0800
Message-Id: <1331640263-18935-8-git-send-email-djkurtz@chromium.org>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1331640263-18935-1-git-send-email-djkurtz@chromium.org>
References: <1331640263-18935-1-git-send-email-djkurtz@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Writing to the object sysfs entry permits individual object table entries
to be modified in the device RAM at run time.  To permanently save
the settings, they must be written to Non-Volatile memory (NVM).
This patch adds a write-only sysfs entry to allow userspace to save
current settings to NVM, but restricts access to root.

Signed-off-by: Daniel Kurtz <djkurtz@chromium.org>
---
 drivers/input/touchscreen/atmel_mxt_ts.c |   19 +++++++++++++++++++
 1 files changed, 19 insertions(+), 0 deletions(-)

diff --git a/drivers/input/touchscreen/atmel_mxt_ts.c b/drivers/input/touchscreen/atmel_mxt_ts.c
index ac3dbb7..e988dc0 100644
--- a/drivers/input/touchscreen/atmel_mxt_ts.c
+++ b/drivers/input/touchscreen/atmel_mxt_ts.c
@@ -994,6 +994,23 @@ static ssize_t mxt_object_store(struct device *dev,
 	return count;
 }
 
+static ssize_t mxt_backupnv_store(struct device *dev,
+				  struct device_attribute *attr,
+				  const char *buf, size_t count)
+{
+	struct mxt_data *data = dev_get_drvdata(dev);
+	int ret;
+
+	/* Backup non-volatile memory */
+	ret = mxt_write_object(data, MXT_GEN_COMMAND_T6, MXT_COMMAND_BACKUPNV,
+			       MXT_BACKUP_VALUE);
+	if (ret)
+		return ret;
+	msleep(MXT_BACKUP_TIME);
+
+	return count;
+}
+
 static int mxt_load_fw(struct device *dev, const char *fn)
 {
 	struct mxt_data *data = dev_get_drvdata(dev);
@@ -1099,11 +1116,13 @@ static ssize_t mxt_update_fw_store(struct device *dev,
 	return count;
 }
 
+static DEVICE_ATTR(backupnv, S_IWUSR, NULL, mxt_backupnv_store);
 static DEVICE_ATTR(object, S_IRUGO | S_IWUSR, mxt_object_show,
 		   mxt_object_store);
 static DEVICE_ATTR(update_fw, S_IWUSR, NULL, mxt_update_fw_store);
 
 static struct attribute *mxt_attrs[] = {
+	&dev_attr_backupnv.attr,
 	&dev_attr_object.attr,
 	&dev_attr_update_fw.attr,
 	NULL
-- 
1.7.7.3

