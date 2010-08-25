Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754720Ab0HYWQm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Aug 2010 18:16:42 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:60899 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752583Ab0HYWQj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Aug 2010 18:16:39 -0400
From: Ivan Gomez Castellanos <ivan.gomez@ti.com>
To: linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org, gregkh@suse.de
Cc: Hiroshi.DOYU@nokia.com, ameya.palande@nokia.com,
        felipe.contreras@nokia.com, omar.ramirez@ti.com, ohad@wizery.com,
        rene.sapiens@ti.com, nm@ti.com, ernesto@ti.com, x0095078@ti.com,
        Ivan Gomez Castellanos <ivan.gomez@ti.com>
Subject: [PATCH 05/11] staging: tidspbridge: Remove cfg_get_dev_object() and do a trivial cleanup
Date: Wed, 25 Aug 2010 17:08:58 -0500
Message-Id: <1282774144-11628-6-git-send-email-ivan.gomez@ti.com>
X-Mailer: git-send-email 1.7.0.3
In-Reply-To: <1282774144-11628-1-git-send-email-ivan.gomez@ti.com>
References: <1282774144-11628-1-git-send-email-ivan.gomez@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The cfg_get_dev_object function is only used in one place and because of
its simplicity, it can be removed.

The parameter *value can be left uninitialized if the strcmp() returns a
nonzero value, so in the function dev_remove_device(), the hdev_obj could
be used uninitialized and could be dereferenced in dev_destroy_device().
This patch fixes this issue, and also removes the dev_obj pointer which
is not used.

Signed-off-by: Ivan Gomez Castellanos <ivan.gomez@ti.com>
---
 .../staging/tidspbridge/include/dspbridge/cfg.h    |   21 ----------
 drivers/staging/tidspbridge/pmgr/dev.c             |   30 +++++++++++---
 drivers/staging/tidspbridge/services/cfg.c         |   41 --------------------
 3 files changed, 24 insertions(+), 68 deletions(-)

diff --git a/drivers/staging/tidspbridge/include/dspbridge/cfg.h b/drivers/staging/tidspbridge/include/dspbridge/cfg.h
index eea9000..9a259a1 100644
--- a/drivers/staging/tidspbridge/include/dspbridge/cfg.h
+++ b/drivers/staging/tidspbridge/include/dspbridge/cfg.h
@@ -41,27 +41,6 @@
 extern int cfg_get_cd_version(u32 *version);
 
 /*
- *  ======== cfg_get_dev_object ========
- *  Purpose:
- *      Retrieve the Device Object handle for a given devnode.
- *  Parameters:
- *      dev_node_obj:	Platform's dev_node handle from which to retrieve
- *      		value.
- *      value:          Ptr to location to store the value.
- *  Returns:
- *      0:                Success.
- *      -EFAULT: dev_node_obj is invalid or device_obj is invalid.
- *      -ENODATA: The resource is not available.
- *  Requires:
- *      CFG initialized.
- *  Ensures:
- *      0:    *value is set to the retrieved u32.
- *      else:       *value is set to 0L.
- */
-extern int cfg_get_dev_object(struct cfg_devnode *dev_node_obj,
-				     u32 *value);
-
-/*
  *  ======== cfg_get_exec_file ========
  *  Purpose:
  *      Retreive the default executable, if any, for this board.
diff --git a/drivers/staging/tidspbridge/pmgr/dev.c b/drivers/staging/tidspbridge/pmgr/dev.c
index 4ddf03d..7893f9a 100644
--- a/drivers/staging/tidspbridge/pmgr/dev.c
+++ b/drivers/staging/tidspbridge/pmgr/dev.c
@@ -85,6 +85,11 @@ struct dev_object {
 	struct node_mgr *hnode_mgr;
 };
 
+struct drv_ext {
+	struct list_head link;
+	char sz_string[MAXREGPATHLENGTH];
+};
+
 /*  ----------------------------------- Globals */
 static u32 refs;		/* Module reference count */
 
@@ -812,18 +817,31 @@ int dev_remove_device(struct cfg_devnode *dev_node_obj)
 {
 	struct dev_object *hdev_obj;	/* handle to device object */
 	int status = 0;
-	struct dev_object *dev_obj;
+	struct drv_data *drv_datap = dev_get_drvdata(bridge);
+
+	if (!drv_datap)
+		status = -ENODATA;
+
+	if (!dev_node_obj)
+		status = -EFAULT;
 
 	/* Retrieve the device object handle originaly stored with
 	 * the dev_node: */
-	status = cfg_get_dev_object(dev_node_obj, (u32 *) &hdev_obj);
 	if (!status) {
-		/* Remove the Processor List */
-		dev_obj = (struct dev_object *)hdev_obj;
-		/* Destroy the device object. */
-		status = dev_destroy_device(hdev_obj);
+		/* check the device string and then store dev object */
+		if (!strcmp((char *)((struct drv_ext *)dev_node_obj)->sz_string,
+								"TIOMAP1510")) {
+			hdev_obj = drv_datap->dev_object;
+			/* Destroy the device object. */
+			status = dev_destroy_device(hdev_obj);
+		} else {
+			status = -EPERM;
+		}
 	}
 
+	if (status)
+		pr_err("%s: Failed, status 0x%x\n", __func__, status);
+
 	return status;
 }
 
diff --git a/drivers/staging/tidspbridge/services/cfg.c b/drivers/staging/tidspbridge/services/cfg.c
index b9c3882..587c71a 100644
--- a/drivers/staging/tidspbridge/services/cfg.c
+++ b/drivers/staging/tidspbridge/services/cfg.c
@@ -30,47 +30,6 @@
 #include <dspbridge/cfg.h>
 #include <dspbridge/drv.h>
 
-struct drv_ext {
-	struct list_head link;
-	char sz_string[MAXREGPATHLENGTH];
-};
-
-/*
- *  ======== cfg_get_dev_object ========
- *  Purpose:
- *      Retrieve the Device Object handle for a given devnode.
- */
-int cfg_get_dev_object(struct cfg_devnode *dev_node_obj,
-			      u32 *value)
-{
-	int status = 0;
-	u32 dw_buf_size;
-	struct drv_data *drv_datap = dev_get_drvdata(bridge);
-
-	if (!drv_datap)
-		status = -EPERM;
-
-	if (!dev_node_obj)
-		status = -EFAULT;
-
-	if (!value)
-		status = -EFAULT;
-
-	dw_buf_size = sizeof(value);
-	if (!status) {
-
-		/* check the device string and then store dev object */
-		if (!
-		    (strcmp
-		     ((char *)((struct drv_ext *)dev_node_obj)->sz_string,
-		      "TIOMAP1510")))
-			*value = (u32)drv_datap->dev_object;
-	}
-	if (status)
-		pr_err("%s: Failed, status 0x%x\n", __func__, status);
-	return status;
-}
-
 /*
  *  ======== cfg_get_exec_file ========
  *  Purpose:
-- 
1.7.0.3

