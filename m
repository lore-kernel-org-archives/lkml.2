Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754761Ab0HYWRN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Aug 2010 18:17:13 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:60926 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752151Ab0HYWRJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Aug 2010 18:17:09 -0400
From: Ivan Gomez Castellanos <ivan.gomez@ti.com>
To: linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org, gregkh@suse.de
Cc: Hiroshi.DOYU@nokia.com, ameya.palande@nokia.com,
        felipe.contreras@nokia.com, omar.ramirez@ti.com, ohad@wizery.com,
        rene.sapiens@ti.com, nm@ti.com, ernesto@ti.com, x0095078@ti.com,
        Ivan Gomez Castellanos <ivan.gomez@ti.com>
Subject: [PATCH 09/11] staging: tidspbridge: Remove cfg_set_object()
Date: Wed, 25 Aug 2010 17:09:02 -0500
Message-Id: <1282774144-11628-10-git-send-email-ivan.gomez@ti.com>
X-Mailer: git-send-email 1.7.0.3
In-Reply-To: <1282774144-11628-1-git-send-email-ivan.gomez@ti.com>
References: <1282774144-11628-1-git-send-email-ivan.gomez@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As the services directory is going to be removed, the cfg_set_object
function has also to be removed.

Since the driver object handle is retrieved from the drv_data structure,
then the word "Registry" is replaced by "driver data" in the comments.

Signed-off-by: Ivan Gomez Castellanos <ivan.gomez@ti.com>
---
 .../staging/tidspbridge/include/dspbridge/cfg.h    |   17 -----------
 drivers/staging/tidspbridge/rmgr/drv.c             |   24 +++++++++++++---
 drivers/staging/tidspbridge/rmgr/mgr.c             |   20 +++++++++++--
 drivers/staging/tidspbridge/services/cfg.c         |   29 --------------------
 4 files changed, 36 insertions(+), 54 deletions(-)

diff --git a/drivers/staging/tidspbridge/include/dspbridge/cfg.h b/drivers/staging/tidspbridge/include/dspbridge/cfg.h
index e1ae1bc..238215b 100644
--- a/drivers/staging/tidspbridge/include/dspbridge/cfg.h
+++ b/drivers/staging/tidspbridge/include/dspbridge/cfg.h
@@ -78,21 +78,4 @@ extern void cfg_get_perf_value(bool *enable_perf);
 extern int cfg_get_zl_file(struct cfg_devnode *dev_node_obj,
 				  u32 buf_size, char *str_zl_file_name);
 
-/*
- *  ======== CFG_SetDrvObject ========
- *  Purpose:
- *      Store the Driver Object handle.
- *  Parameters:
- *      value:          Arbitrary value to store.
- *      dw_type          Type of Object to Store
- *  Returns:
- *      0:        Success.
- *      -EPERM:      Internal Error.
- *  Requires:
- *      CFG initialized.
- *  Ensures:
- *      0:        The Private u32 was successfully set.
- */
-extern int cfg_set_object(u32 value, u8 dw_type);
-
 #endif /* CFG_ */
diff --git a/drivers/staging/tidspbridge/rmgr/drv.c b/drivers/staging/tidspbridge/rmgr/drv.c
index fc1f49b..519053f 100644
--- a/drivers/staging/tidspbridge/rmgr/drv.c
+++ b/drivers/staging/tidspbridge/rmgr/drv.c
@@ -309,6 +309,7 @@ int drv_create(struct drv_object **drv_obj)
 {
 	int status = 0;
 	struct drv_object *pdrv_object = NULL;
+	struct drv_data *drv_datap = dev_get_drvdata(bridge);
 
 	DBC_REQUIRE(drv_obj != NULL);
 	DBC_REQUIRE(refs > 0);
@@ -335,9 +336,16 @@ int drv_create(struct drv_object **drv_obj)
 	} else {
 		status = -ENOMEM;
 	}
-	/* Store the DRV Object in the Registry */
-	if (!status)
-		status = cfg_set_object((u32) pdrv_object, REG_DRV_OBJECT);
+	/* Store the DRV Object in the driver data */
+	if (!status) {
+		if (drv_datap) {
+			drv_datap->drv_object = (void *)pdrv_object;
+		} else {
+			status = -EPERM;
+			pr_err("%s: Failed to store DRV object\n", __func__);
+		}
+	}
+
 	if (!status) {
 		*drv_obj = pdrv_object;
 	} else {
@@ -374,6 +382,7 @@ int drv_destroy(struct drv_object *driver_obj)
 {
 	int status = 0;
 	struct drv_object *pdrv_object = (struct drv_object *)driver_obj;
+	struct drv_data *drv_datap = dev_get_drvdata(bridge);
 
 	DBC_REQUIRE(refs > 0);
 	DBC_REQUIRE(pdrv_object);
@@ -386,8 +395,13 @@ int drv_destroy(struct drv_object *driver_obj)
 	kfree(pdrv_object->dev_list);
 	kfree(pdrv_object->dev_node_string);
 	kfree(pdrv_object);
-	/* Update the DRV Object in Registry to be 0 */
-	(void)cfg_set_object(0, REG_DRV_OBJECT);
+	/* Update the DRV Object in the driver data */
+	if (drv_datap) {
+		drv_datap->drv_object = NULL;
+	} else {
+		status = -EPERM;
+		pr_err("%s: Failed to store DRV object\n", __func__);
+	}
 
 	return status;
 }
diff --git a/drivers/staging/tidspbridge/rmgr/mgr.c b/drivers/staging/tidspbridge/rmgr/mgr.c
index c6131c4..48702bb 100644
--- a/drivers/staging/tidspbridge/rmgr/mgr.c
+++ b/drivers/staging/tidspbridge/rmgr/mgr.c
@@ -58,6 +58,7 @@ int mgr_create(struct mgr_object **mgr_obj,
 {
 	int status = 0;
 	struct mgr_object *pmgr_obj = NULL;
+	struct drv_data *drv_datap = dev_get_drvdata(bridge);
 
 	DBC_REQUIRE(mgr_obj != NULL);
 	DBC_REQUIRE(refs > 0);
@@ -67,7 +68,14 @@ int mgr_create(struct mgr_object **mgr_obj,
 		status = dcd_create_manager(ZLDLLNAME, &pmgr_obj->hdcd_mgr);
 		if (!status) {
 			/* If succeeded store the handle in the MGR Object */
-			status = cfg_set_object((u32) pmgr_obj, REG_MGR_OBJECT);
+			if (drv_datap) {
+				drv_datap->mgr_object = (void *)pmgr_obj;
+			} else {
+				status = -EPERM;
+				pr_err("%s: Failed to store MGR object\n",
+								__func__);
+			}
+
 			if (!status) {
 				*mgr_obj = pmgr_obj;
 			} else {
@@ -94,6 +102,7 @@ int mgr_destroy(struct mgr_object *hmgr_obj)
 {
 	int status = 0;
 	struct mgr_object *pmgr_obj = (struct mgr_object *)hmgr_obj;
+	struct drv_data *drv_datap = dev_get_drvdata(bridge);
 
 	DBC_REQUIRE(refs > 0);
 	DBC_REQUIRE(hmgr_obj);
@@ -103,8 +112,13 @@ int mgr_destroy(struct mgr_object *hmgr_obj)
 		dcd_destroy_manager(hmgr_obj->hdcd_mgr);
 
 	kfree(pmgr_obj);
-	/* Update the Registry with NULL for MGR Object */
-	(void)cfg_set_object(0, REG_MGR_OBJECT);
+	/* Update the driver data with NULL for MGR Object */
+	if (drv_datap) {
+		drv_datap->mgr_object = NULL;
+	} else {
+		status = -EPERM;
+		pr_err("%s: Failed to store MGR object\n", __func__);
+	}
 
 	return status;
 }
diff --git a/drivers/staging/tidspbridge/services/cfg.c b/drivers/staging/tidspbridge/services/cfg.c
index 5517201..32bb934 100644
--- a/drivers/staging/tidspbridge/services/cfg.c
+++ b/drivers/staging/tidspbridge/services/cfg.c
@@ -30,32 +30,3 @@
 #include <dspbridge/cfg.h>
 #include <dspbridge/drv.h>
 
-/*
- *  ======== cfg_set_object ========
- *  Purpose:
- *      Store the Driver Object handle
- */
-int cfg_set_object(u32 value, u8 dw_type)
-{
-	int status = -EINVAL;
-	struct drv_data *drv_datap = dev_get_drvdata(bridge);
-
-	if (!drv_datap)
-		return -EPERM;
-
-	switch (dw_type) {
-	case (REG_DRV_OBJECT):
-		drv_datap->drv_object = (void *)value;
-		status = 0;
-		break;
-	case (REG_MGR_OBJECT):
-		drv_datap->mgr_object = (void *)value;
-		status = 0;
-		break;
-	default:
-		break;
-	}
-	if (status)
-		pr_err("%s: Failed, status 0x%x\n", __func__, status);
-	return status;
-}
-- 
1.7.0.3

