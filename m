Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754140Ab2FKMwR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2012 08:52:17 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:45915 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751193Ab2FKMwP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2012 08:52:15 -0400
From: Michal Nazarewicz <mina86@mina86.com>
To: Felipe Balbi <balbi@ti.com>, Alan Stern <stern@rowland.harvard.edu>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/3] usb: gadget: mass_storage: remove unused options
Date: Mon, 11 Jun 2012 14:52:01 +0200
Message-Id: <861e01f52f2b3ed8884f308226fd8dd2fcae26ea.1339418799.git.mina86@mina86.com>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <cover.1339418799.git.mina86@mina86.com>
References: <cover.1339418799.git.mina86@mina86.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This commit removes thread_name and lun_name_format fields from the
fsg_config structure.  Those fields are not used by any in-tree code
and their usefulness is rather theoretical.

Signed-off-by: Michal Nazarewicz <mina86@mina86.com>
---
 drivers/usb/gadget/f_mass_storage.c |   50 +++++++----------------------------
 1 files changed, 10 insertions(+), 40 deletions(-)

diff --git a/drivers/usb/gadget/f_mass_storage.c b/drivers/usb/gadget/f_mass_storage.c
index 6b6355c..3b2293f 100644
--- a/drivers/usb/gadget/f_mass_storage.c
+++ b/drivers/usb/gadget/f_mass_storage.c
@@ -75,25 +75,6 @@
  *	->nofua		Flag specifying that FUA flag in SCSI WRITE(10,12)
  *				commands for this LUN shall be ignored.
  *
- *	lun_name_format	A printf-like format for names of the LUN
- *				devices.  This determines how the
- *				directory in sysfs will be named.
- *				Unless you are using several MSFs in
- *				a single gadget (as opposed to single
- *				MSF in many configurations) you may
- *				leave it as NULL (in which case
- *				"lun%d" will be used).  In the format
- *				you can use "%d" to index LUNs for
- *				MSF's with more than one LUN.  (Beware
- *				that there is only one integer given
- *				as an argument for the format and
- *				specifying invalid format may cause
- *				unspecified behaviour.)
- *	thread_name	Name of the kernel thread process used by the
- *				MSF.  You can safely set it to NULL
- *				(in which case default "file-storage"
- *				will be used).
- *
  *	vendor_name
  *	product_name
  *	release		Information used as a reply to INQUIRY
@@ -155,15 +136,14 @@
  * a buffer from being used by more than one endpoint.
  *
  *
- * The pathnames of the backing files and the ro settings are
- * available in the attribute files "file" and "ro" in the lun<n> (or
- * to be more precise in a directory which name comes from
- * "lun_name_format" option!) subdirectory of the gadget's sysfs
- * directory.  If the "removable" option is set, writing to these
- * files will simulate ejecting/loading the medium (writing an empty
- * line means eject) and adjusting a write-enable tab.  Changes to the
- * ro setting are not allowed when the medium is loaded or if CD-ROM
- * emulation is being used.
+ * The pathnames of the backing files, the ro settings and nofua
+ * settings are available in the attribute files "file", "ro" and
+ * "nofua" in the lun<n> subdirectory of the gadget's sysfs directory.
+ * If the "removable" option is set, writing to these files will
+ * simulate ejecting/loading the medium (writing an empty line means
+ * eject) and adjusting a write-enable tab.  Changes to the ro setting
+ * are not allowed when the medium is loaded or if CD-ROM emulation is
+ * being used.
  *
  * When a LUN receive an "eject" SCSI request (Start/Stop Unit),
  * if the LUN is removable, the backing file is released to simulate
@@ -417,9 +397,6 @@ struct fsg_config {
 		char nofua;
 	} luns[FSG_MAX_LUNS];
 
-	const char		*lun_name_format;
-	const char		*thread_name;
-
 	/* Callback functions. */
 	const struct fsg_operations	*ops;
 	/* Gadget's private data. */
@@ -2792,11 +2769,7 @@ static struct fsg_common *fsg_common_init(struct fsg_common *common,
 		curlun->dev.parent = &gadget->dev;
 		/* curlun->dev.driver = &fsg_driver.driver; XXX */
 		dev_set_drvdata(&curlun->dev, &common->filesem);
-		dev_set_name(&curlun->dev,
-			     cfg->lun_name_format
-			   ? cfg->lun_name_format
-			   : "lun%d",
-			     i);
+		dev_set_name(&curlun->dev, "lun%d", i);
 
 		rc = device_register(&curlun->dev);
 		if (rc) {
@@ -2878,8 +2851,7 @@ buffhds_first_it:
 
 	/* Tell the thread to start working */
 	common->thread_task =
-		kthread_create(fsg_main_thread, common,
-			       cfg->thread_name ?: "file-storage");
+		kthread_create(fsg_main_thread, common, "file-storage");
 	if (IS_ERR(common->thread_task)) {
 		rc = PTR_ERR(common->thread_task);
 		goto error_release;
@@ -3175,8 +3147,6 @@ fsg_config_from_params(struct fsg_config *cfg,
 	}
 
 	/* Let MSF use defaults */
-	cfg->lun_name_format = 0;
-	cfg->thread_name = 0;
 	cfg->vendor_name = 0;
 	cfg->product_name = 0;
 	cfg->release = 0xffff;
-- 
1.7.7.3

