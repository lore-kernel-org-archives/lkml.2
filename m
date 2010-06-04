Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753371Ab0FDHyn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jun 2010 03:54:43 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:37705 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752149Ab0FDHym (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jun 2010 03:54:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:subject:to:cc:date:message-id:user-agent:mime-version
         :content-type:content-transfer-encoding;
        b=YaQfXBNrOnxlv09gDYP0/f0MHTCF+4AkMPUR3NBlCXqwZCLivh/jvyiLvriF4GEZpv
         lDruOGFW8CoPFnKz7aFMH4nCeX8PVEqzEdOA3QZ/X4EbuT76mQkQozJHwdAIJSSdXkj8
         kBzYMso2XEbfcpEkJndxvzovcKzmlx+pDNJuU=
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 1/2] firmware loader: use statically initialized data attribute
To: Greg KH <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org
Date: Fri, 04 Jun 2010 00:54:37 -0700
Message-ID: <20100604075437.15861.14718.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is no reason why we are using a template for binary attribute
and copying it into per-firmware data before registering. Using the
original works as well.

Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
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

