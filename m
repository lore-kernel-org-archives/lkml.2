Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934593Ab0HEWgd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 18:36:33 -0400
Received: from kroah.org ([198.145.64.141]:37706 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760860Ab0HEWY1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 18:24:27 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Dmitry Torokhov <dtor@mail.ru>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 07/28] firmware loader: use statically initialized data attribute
Date: Thu,  5 Aug 2010 15:23:57 -0700
Message-Id: <1281047058-23716-7-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.2
In-Reply-To: <20100805213314.GB13744@kroah.com>
References: <20100805213314.GB13744@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dmitry Torokhov <dmitry.torokhov@gmail.com>

There is no reason why we are using a template for binary attribute
and copying it into per-firmware data before registering. Using the
original works as well.

Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/base/firmware_class.c |    9 +++------
 1 files changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/base/firmware_class.c b/drivers/base/firmware_class.c
index 3f093b0..fb29c64 100644
--- a/drivers/base/firmware_class.c
+++ b/drivers/base/firmware_class.c
@@ -87,7 +87,6 @@ static DEFINE_MUTEX(fw_lock);
 
 struct firmware_priv {
 	struct completion completion;
-	struct bin_attribute attr_data;
 	struct firmware *fw;
 	unsigned long status;
 	struct page **pages;
@@ -420,8 +419,8 @@ out:
 	return retval;
 }
 
-static struct bin_attribute firmware_attr_data_tmpl = {
-	.attr = {.name = "data", .mode = 0644},
+static struct bin_attribute firmware_attr_data = {
+	.attr = { .name = "data", .mode = 0644 },
 	.size = 0,
 	.read = firmware_data_read,
 	.write = firmware_data_write,
@@ -452,7 +451,6 @@ static int fw_register_device(struct device **dev_p, const char *fw_name,
 
 	strcpy(fw_priv->fw_id, fw_name);
 	init_completion(&fw_priv->completion);
-	fw_priv->attr_data = firmware_attr_data_tmpl;
 	fw_priv->timeout.function = firmware_class_timeout;
 	fw_priv->timeout.data = (u_long) fw_priv;
 	init_timer(&fw_priv->timeout);
@@ -498,8 +496,7 @@ static int fw_setup_device(struct firmware *fw, struct device **dev_p,
 	fw_priv->nowait = nowait;
 
 	fw_priv->fw = fw;
-	sysfs_bin_attr_init(&fw_priv->attr_data);
-	retval = sysfs_create_bin_file(&f_dev->kobj, &fw_priv->attr_data);
+	retval = sysfs_create_bin_file(&f_dev->kobj, &firmware_attr_data);
 	if (retval) {
 		dev_err(device, "%s: sysfs_create_bin_file failed\n", __func__);
 		goto error_unreg;
-- 
1.7.2

