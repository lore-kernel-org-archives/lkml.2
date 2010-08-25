Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754727Ab0HYWQu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Aug 2010 18:16:50 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:59080 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751700Ab0HYWQq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Aug 2010 18:16:46 -0400
From: Ivan Gomez Castellanos <ivan.gomez@ti.com>
To: linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org, gregkh@suse.de
Cc: Hiroshi.DOYU@nokia.com, ameya.palande@nokia.com,
        felipe.contreras@nokia.com, omar.ramirez@ti.com, ohad@wizery.com,
        rene.sapiens@ti.com, nm@ti.com, ernesto@ti.com, x0095078@ti.com,
        Ivan Gomez Castellanos <ivan.gomez@ti.com>
Subject: [PATCH 06/11] staging: tidspbridge: Remove cfg_get_exec_file()
Date: Wed, 25 Aug 2010 17:08:59 -0500
Message-Id: <1282774144-11628-7-git-send-email-ivan.gomez@ti.com>
X-Mailer: git-send-email 1.7.0.3
In-Reply-To: <1282774144-11628-1-git-send-email-ivan.gomez@ti.com>
References: <1282774144-11628-1-git-send-email-ivan.gomez@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As the services directory is going to be removed, the cfg_get_exec_file
function has also to be removed.

This patch also avoids a possible NULL pointer dereference in function
cfg_get_exec_file(), when drv_datap is checked for NULL and then pass
drv_datap->base_img as argument to strlen().

Signed-off-by: Ivan Gomez Castellanos <ivan.gomez@ti.com>
---
 .../staging/tidspbridge/include/dspbridge/cfg.h    |   22 --------------
 drivers/staging/tidspbridge/rmgr/proc.c            |   27 ++++++++++++-----
 drivers/staging/tidspbridge/services/cfg.c         |   31 --------------------
 3 files changed, 19 insertions(+), 61 deletions(-)

diff --git a/drivers/staging/tidspbridge/include/dspbridge/cfg.h b/drivers/staging/tidspbridge/include/dspbridge/cfg.h
index 9a259a1..11f5bde 100644
--- a/drivers/staging/tidspbridge/include/dspbridge/cfg.h
+++ b/drivers/staging/tidspbridge/include/dspbridge/cfg.h
@@ -41,28 +41,6 @@
 extern int cfg_get_cd_version(u32 *version);
 
 /*
- *  ======== cfg_get_exec_file ========
- *  Purpose:
- *      Retreive the default executable, if any, for this board.
- *  Parameters:
- *      dev_node_obj: Handle to the dev_node who's driver we are querying.
- *      buf_size:       Size of buffer.
- *      str_exec_file:  Ptr to character buf to hold ExecFile.
- *  Returns:
- *      0:                Success.
- *      -EFAULT:  dev_node_obj is invalid or str_exec_file is invalid.
- *      -ENODATA: The resource is not available.
- *  Requires:
- *      CFG initialized.
- *  Ensures:
- *      0:    Not more than buf_size bytes were copied into str_exec_file,
- *                  and *str_exec_file contains default executable for this
- *                  devnode.
- */
-extern int cfg_get_exec_file(struct cfg_devnode *dev_node_obj,
-				    u32 buf_size, char *str_exec_file);
-
-/*
  *  ======== cfg_get_object ========
  *  Purpose:
  *      Retrieve the Driver Object handle From the Registry
diff --git a/drivers/staging/tidspbridge/rmgr/proc.c b/drivers/staging/tidspbridge/rmgr/proc.c
index 44c26e1..0a7e30b 100644
--- a/drivers/staging/tidspbridge/rmgr/proc.c
+++ b/drivers/staging/tidspbridge/rmgr/proc.c
@@ -393,18 +393,29 @@ static int get_exec_file(struct cfg_devnode *dev_node_obj,
 {
 	u8 dev_type;
 	s32 len;
+	struct drv_data *drv_datap = dev_get_drvdata(bridge);
 
 	dev_get_dev_type(hdev_obj, (u8 *) &dev_type);
+
+	if (!exec_file)
+		return -EFAULT;
+
 	if (dev_type == DSP_UNIT) {
-		return cfg_get_exec_file(dev_node_obj, size, exec_file);
-	} else if (dev_type == IVA_UNIT) {
-		if (iva_img) {
-			len = strlen(iva_img);
-			strncpy(exec_file, iva_img, len + 1);
-			return 0;
-		}
+		if (!drv_datap || !drv_datap->base_img)
+			return -EFAULT;
+
+		if (strlen(drv_datap->base_img) > size)
+			return -EINVAL;
+
+		strcpy(exec_file, drv_datap->base_img);
+	} else if (dev_type == IVA_UNIT && iva_img) {
+		len = strlen(iva_img);
+		strncpy(exec_file, iva_img, len + 1);
+	} else {
+		return -ENOENT;
 	}
-	return -ENOENT;
+
+	return 0;
 }
 
 /*
diff --git a/drivers/staging/tidspbridge/services/cfg.c b/drivers/staging/tidspbridge/services/cfg.c
index 587c71a..302eadd 100644
--- a/drivers/staging/tidspbridge/services/cfg.c
+++ b/drivers/staging/tidspbridge/services/cfg.c
@@ -31,37 +31,6 @@
 #include <dspbridge/drv.h>
 
 /*
- *  ======== cfg_get_exec_file ========
- *  Purpose:
- *      Retreive the default executable, if any, for this board.
- */
-int cfg_get_exec_file(struct cfg_devnode *dev_node_obj, u32 buf_size,
-			     char *str_exec_file)
-{
-	int status = 0;
-	struct drv_data *drv_datap = dev_get_drvdata(bridge);
-
-	if (!dev_node_obj)
-		status = -EFAULT;
-
-	else if (!str_exec_file || !drv_datap)
-		status = -EFAULT;
-
-	if (strlen(drv_datap->base_img) > buf_size)
-		status = -EINVAL;
-
-	if (!status && drv_datap->base_img)
-		strcpy(str_exec_file, drv_datap->base_img);
-
-	if (status)
-		pr_err("%s: Failed, status 0x%x\n", __func__, status);
-	DBC_ENSURE(((status == 0) &&
-		    (strlen(str_exec_file) <= buf_size))
-		   || (status != 0));
-	return status;
-}
-
-/*
  *  ======== cfg_get_object ========
  *  Purpose:
  *      Retrieve the Object handle from the Registry
-- 
1.7.0.3

