Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754725Ab2IAJRQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Sep 2012 05:17:16 -0400
Received: from gn237.zone.eu ([217.146.67.237]:54696 "EHLO gn237.zone.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752854Ab2IAJRI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Sep 2012 05:17:08 -0400
From: Priit Laes <plaes@plaes.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Priit Laes <plaes@plaes.org>
Subject: [PATCH 10/14] staging: csr: drv.c: Remove KERNEL_VERSION checks and associated defines
Date: Sat,  1 Sep 2012 12:06:06 +0300
Message-Id: <1346490370-32438-11-git-send-email-plaes@plaes.org>
X-Mailer: git-send-email 1.7.12
In-Reply-To: <1346490370-32438-1-git-send-email-plaes@plaes.org>
References: <1346490370-32438-1-git-send-email-plaes@plaes.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Priit Laes <plaes@plaes.org>
---
 drivers/staging/csr/drv.c | 43 ++++++++-----------------------------------
 1 file changed, 8 insertions(+), 35 deletions(-)

diff --git a/drivers/staging/csr/drv.c b/drivers/staging/csr/drv.c
index b2c27f4..4f7fe52 100644
--- a/drivers/staging/csr/drv.c
+++ b/drivers/staging/csr/drv.c
@@ -124,11 +124,7 @@ static void udi_set_log_filter(ul_client_t *pcli,
 
 
 /* Mutex to protect access to  priv->sme_cli */
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2, 6, 37)
 DEFINE_SEMAPHORE(udi_mutex);
-#else
-DECLARE_MUTEX(udi_mutex);
-#endif
 
 s32 CsrHipResultToStatus(CsrResult csrResult)
 {
@@ -1980,18 +1976,6 @@ uf_sme_queue_message(unifi_priv_t *priv, u8 *buffer, int length)
 } /* uf_sme_queue_message() */
 #endif
 
-
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,27)
-#define UF_DEVICE_CREATE(_class, _parent, _devno, _priv, _fmt, _args)       \
-    device_create(_class, _parent, _devno, _priv, _fmt, _args)
-#elif LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,26)
-#define UF_DEVICE_CREATE(_class, _parent, _devno, _priv, _fmt, _args)       \
-    device_create_drvdata(_class, _parent, _devno, _priv, _fmt, _args)
-#else
-#define UF_DEVICE_CREATE(_class, _parent, _devno, _priv, _fmt, _args)       \
-    device_create(_class, _parent, _devno, _fmt, _args)
-#endif
-
 /*
  ****************************************************************************
  *
@@ -2009,17 +1993,6 @@ static struct file_operations unifi_fops = {
     .poll       = unifi_poll,
 };
 
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,27)
-#define UF_DEVICE_CREATE(_class, _parent, _devno, _priv, _fmt, _args)       \
-    device_create(_class, _parent, _devno, _priv, _fmt, _args)
-#elif LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,26)
-#define UF_DEVICE_CREATE(_class, _parent, _devno, _priv, _fmt, _args)       \
-    device_create_drvdata(_class, _parent, _devno, _priv, _fmt, _args)
-#else
-#define UF_DEVICE_CREATE(_class, _parent, _devno, _priv, _fmt, _args)       \
-    device_create(_class, _parent, _devno, _fmt, _args)
-#endif
-
 static dev_t unifi_first_devno;
 static struct class *unifi_class;
 
@@ -2042,11 +2015,11 @@ int uf_create_device_nodes(unifi_priv_t *priv, int bus_id)
     }
 
 #ifdef SDIO_EXPORTS_STRUCT_DEVICE
-    if (!UF_DEVICE_CREATE(unifi_class, priv->unifi_device,
-                          devno, priv, "unifi%d", bus_id)) {
+    if (!device_create(unifi_class, priv->unifi_device,
+                       devno, priv, "unifi%d", bus_id)) {
 #else
-    priv->unifi_device = UF_DEVICE_CREATE(unifi_class, NULL,
-                                          devno, priv, "unifi%d", bus_id);
+    priv->unifi_device = device_create(unifi_class, NULL,
+                                       devno, priv, "unifi%d", bus_id);
     if (priv->unifi_device == NULL) {
 #endif /* SDIO_EXPORTS_STRUCT_DEVICE */
 
@@ -2068,13 +2041,13 @@ int uf_create_device_nodes(unifi_priv_t *priv, int bus_id)
         return r;
     }
 
-    if (!UF_DEVICE_CREATE(unifi_class,
+    if (!device_create(unifi_class,
 #ifdef SDIO_EXPORTS_STRUCT_DEVICE
-                          priv->unifi_device,
+                       priv->unifi_device,
 #else
-                          NULL,
+                       NULL,
 #endif /* SDIO_EXPORTS_STRUCT_DEVICE */
-                          devno, priv, "unifiudi%d", bus_id)) {
+                       devno, priv, "unifiudi%d", bus_id)) {
         device_destroy(unifi_class, priv->unifi_cdev.dev);
         cdev_del(&priv->unifiudi_cdev);
         cdev_del(&priv->unifi_cdev);
-- 
1.7.12

