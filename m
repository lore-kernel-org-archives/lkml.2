Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754692Ab0HYWRH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Aug 2010 18:17:07 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:39333 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752151Ab0HYWRD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Aug 2010 18:17:03 -0400
From: Ivan Gomez Castellanos <ivan.gomez@ti.com>
To: linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org, gregkh@suse.de
Cc: Hiroshi.DOYU@nokia.com, ameya.palande@nokia.com,
        felipe.contreras@nokia.com, omar.ramirez@ti.com, ohad@wizery.com,
        rene.sapiens@ti.com, nm@ti.com, ernesto@ti.com, x0095078@ti.com,
        Ivan Gomez Castellanos <ivan.gomez@ti.com>
Subject: [PATCH 08/11] staging: tidspbridge: Remove cfg_set_dev_object()
Date: Wed, 25 Aug 2010 17:09:01 -0500
Message-Id: <1282774144-11628-9-git-send-email-ivan.gomez@ti.com>
X-Mailer: git-send-email 1.7.0.3
In-Reply-To: <1282774144-11628-1-git-send-email-ivan.gomez@ti.com>
References: <1282774144-11628-1-git-send-email-ivan.gomez@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As the services directory is going to be removed, the cfg_set_dev_object
function has also to be removed.

Signed-off-by: Ivan Gomez Castellanos <ivan.gomez@ti.com>
---
 .../staging/tidspbridge/include/dspbridge/cfg.h    |   19 ------------
 drivers/staging/tidspbridge/pmgr/dev.c             |   28 ++++++++++--------
 drivers/staging/tidspbridge/services/cfg.c         |   30 --------------------
 3 files changed, 16 insertions(+), 61 deletions(-)

diff --git a/drivers/staging/tidspbridge/include/dspbridge/cfg.h b/drivers/staging/tidspbridge/include/dspbridge/cfg.h
index 834b25b..e1ae1bc 100644
--- a/drivers/staging/tidspbridge/include/dspbridge/cfg.h
+++ b/drivers/staging/tidspbridge/include/dspbridge/cfg.h
@@ -79,25 +79,6 @@ extern int cfg_get_zl_file(struct cfg_devnode *dev_node_obj,
 				  u32 buf_size, char *str_zl_file_name);
 
 /*
- *  ======== cfg_set_dev_object ========
- *  Purpose:
- *      Store the Device Object handle for a given devnode.
- *  Parameters:
- *      dev_node_obj:   Platform's dev_node handle we are storing value with.
- *      value:    Arbitrary value to store.
- *  Returns:
- *      0:                Success.
- *      -EFAULT:  dev_node_obj is invalid.
- *      -EPERM:              Internal Error.
- *  Requires:
- *      CFG initialized.
- *  Ensures:
- *      0:    The Private u32 was successfully set.
- */
-extern int cfg_set_dev_object(struct cfg_devnode *dev_node_obj,
-				     u32 value);
-
-/*
  *  ======== CFG_SetDrvObject ========
  *  Purpose:
  *      Store the Driver Object handle.
diff --git a/drivers/staging/tidspbridge/pmgr/dev.c b/drivers/staging/tidspbridge/pmgr/dev.c
index 8077bdc..b0bcbd9 100644
--- a/drivers/staging/tidspbridge/pmgr/dev.c
+++ b/drivers/staging/tidspbridge/pmgr/dev.c
@@ -898,6 +898,7 @@ int dev_start_device(struct cfg_devnode *dev_node_obj)
 	char bridge_file_name[CFG_MAXSEARCHPATHLEN] = "UMA";
 	int status;
 	struct mgr_object *hmgr_obj = NULL;
+	struct drv_data *drv_datap = dev_get_drvdata(bridge);
 
 	DBC_REQUIRE(refs > 0);
 
@@ -906,24 +907,27 @@ int dev_start_device(struct cfg_devnode *dev_node_obj)
 				   dev_node_obj);
 	if (!status) {
 		/* Store away the hdev_obj with the DEVNODE */
-		status = cfg_set_dev_object(dev_node_obj, (u32) hdev_obj);
+		if (!drv_datap || !dev_node_obj) {
+			status = -EFAULT;
+			pr_err("%s: Failed, status 0x%x\n", __func__, status);
+		} else if (!(strcmp((char *)dev_node_obj, "TIOMAP1510"))) {
+			drv_datap->dev_object = (void *) hdev_obj;
+		}
+		if (!status) {
+			/* Create the Manager Object */
+			status = mgr_create(&hmgr_obj, dev_node_obj);
+			if (status && !(strcmp((char *)dev_node_obj,
+							"TIOMAP1510"))) {
+				/* Ensure the device extension is NULL */
+				drv_datap->dev_object = NULL;
+			}
+		}
 		if (status) {
 			/* Clean up */
 			dev_destroy_device(hdev_obj);
 			hdev_obj = NULL;
 		}
 	}
-	if (!status) {
-		/* Create the Manager Object */
-		status = mgr_create(&hmgr_obj, dev_node_obj);
-	}
-	if (status) {
-		if (hdev_obj)
-			dev_destroy_device(hdev_obj);
-
-		/* Ensure the device extension is NULL */
-		cfg_set_dev_object(dev_node_obj, 0L);
-	}
 
 	return status;
 }
diff --git a/drivers/staging/tidspbridge/services/cfg.c b/drivers/staging/tidspbridge/services/cfg.c
index 94d8ebe..5517201 100644
--- a/drivers/staging/tidspbridge/services/cfg.c
+++ b/drivers/staging/tidspbridge/services/cfg.c
@@ -31,36 +31,6 @@
 #include <dspbridge/drv.h>
 
 /*
- *  ======== cfg_set_dev_object ========
- *  Purpose:
- *      Store the Device Object handle and dev_node pointer for a given devnode.
- */
-int cfg_set_dev_object(struct cfg_devnode *dev_node_obj, u32 value)
-{
-	int status = 0;
-	struct drv_data *drv_datap = dev_get_drvdata(bridge);
-
-	if (!drv_datap) {
-		pr_err("%s: Failed, status 0x%x\n", __func__, status);
-		return -EPERM;
-	}
-
-	if (!dev_node_obj)
-		status = -EFAULT;
-
-	if (!status) {
-		/* Store the Bridge device object in the Registry */
-
-		if (!(strcmp((char *)dev_node_obj, "TIOMAP1510")))
-			drv_datap->dev_object = (void *) value;
-	}
-	if (status)
-		pr_err("%s: Failed, status 0x%x\n", __func__, status);
-
-	return status;
-}
-
-/*
  *  ======== cfg_set_object ========
  *  Purpose:
  *      Store the Driver Object handle
-- 
1.7.0.3

