Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755840Ab2JCSN4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2012 14:13:56 -0400
Received: from gn237.zone.eu ([217.146.67.237]:39274 "EHLO gn237.zone.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752586Ab2JCSNz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2012 14:13:55 -0400
From: Priit Laes <plaes@plaes.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Priit Laes <plaes@plaes.org>
Subject: [PATCH v2] staging: csr: Replace wakelocks with wakeup interface
Date: Wed,  3 Oct 2012 21:12:30 +0300
Message-Id: <1349287950-7278-1-git-send-email-plaes@plaes.org>
X-Mailer: git-send-email 1.7.12
In-Reply-To: <1349284444-5860-1-git-send-email-plaes@plaes.org>
References: <1349284444-5860-1-git-send-email-plaes@plaes.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Wakelocks are an Android-specific API that never made into mainline.
Eventually power management wakeup interface appeared, therefore use
this interface instead.

Signed-off-by: Priit Laes <plaes@plaes.org>
---
 drivers/staging/csr/drv.c        |  8 ++++----
 drivers/staging/csr/sdio_mmc.c   | 23 +++++++----------------
 drivers/staging/csr/sme_sys.c    | 18 +++++++++---------
 drivers/staging/csr/unifi_priv.h |  8 --------
 4 files changed, 20 insertions(+), 37 deletions(-)

diff --git a/drivers/staging/csr/drv.c b/drivers/staging/csr/drv.c
index 2497580..262705a 100644
--- a/drivers/staging/csr/drv.c
+++ b/drivers/staging/csr/drv.c
@@ -67,6 +67,8 @@ int bh_priority = -1;
 int log_hip_signals = 0;
 #endif
 
+extern struct wakeup_source unifi_sdio_wakeup_source;
+
 MODULE_DESCRIPTION("CSR UniFi (SDIO)");
 
 module_param(buswidth,    int, S_IRUGO|S_IWUSR);
@@ -1330,11 +1332,9 @@ unifi_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 
             unifi_info(priv, "UniFi ready\n");
 
-#ifdef ANDROID_BUILD
-            /* Release the wakelock */
             unifi_trace(priv, UDBG1, "netdev_init: release wake lock\n");
-            wake_unlock(&unifi_sdio_wake_lock);
-#endif
+            __pm_relax(&unifi_sdio_wakeup_source);
+
 #ifdef CSR_NATIVE_SOFTMAC /* For softmac dev, force-enable the network interface rather than wait for a connected-ind */
             {
                 struct net_device *dev = priv->netdev[interfaceTag];
diff --git a/drivers/staging/csr/sdio_mmc.c b/drivers/staging/csr/sdio_mmc.c
index af3e40b..42625ae 100644
--- a/drivers/staging/csr/sdio_mmc.c
+++ b/drivers/staging/csr/sdio_mmc.c
@@ -25,9 +25,8 @@
 
 #include "unifi_priv.h"
 
-#ifdef ANDROID_BUILD
-struct wake_lock unifi_sdio_wake_lock; /* wakelock to prevent suspend while resuming */
-#endif
+/* To prevent suspend while resuming */
+static struct wakeup_source unifi_sdio_wakeup_source;
 
 static CsrSdioFunctionDriver *sdio_func_drv;
 
@@ -1097,11 +1096,9 @@ uf_glue_sdio_probe(struct sdio_func *func,
     /* We have finished, so release the SDIO driver */
     sdio_release_host(func);
 
-#ifdef ANDROID_BUILD
-    /* Take the wakelock */
+    /* Initialize wakeup event */
     unifi_trace(NULL, UDBG1, "probe: take wake lock\n");
-    wake_lock(&unifi_sdio_wake_lock);
-#endif
+    __pm_stay_awake(&unifi_sdio_wakeup_source);
 
     func_exit();
     return 0;
@@ -1212,10 +1209,8 @@ uf_glue_sdio_resume(struct device *dev)
 
     unifi_trace(NULL, UDBG1, "uf_glue_sdio_resume");
 
-#ifdef ANDROID_BUILD
     unifi_trace(NULL, UDBG1, "resume: take wakelock\n");
-    wake_lock(&unifi_sdio_wake_lock);
-#endif
+    __pm_stay_awake(&unifi_sdio_wakeup_source);
 
     func_exit();
     return 0;
@@ -1272,9 +1267,7 @@ CsrSdioFunctionDriverRegister(CsrSdioFunctionDriver *sdio_drv)
         return CSR_SDIO_RESULT_INVALID_VALUE;
     }
 
-#ifdef ANDROID_BUILD
-    wake_lock_init(&unifi_sdio_wake_lock, WAKE_LOCK_SUSPEND, "unifi_sdio_work");
-#endif
+    wakeup_source_init(&unifi_sdio_wakeup_source, "unifi_sdio_work");
 
     /* Save the registered driver description */
     /*
@@ -1306,9 +1299,7 @@ CsrSdioFunctionDriverUnregister(CsrSdioFunctionDriver *sdio_drv)
 {
     printk(KERN_INFO "UniFi: unregister from MMC sdio\n");
 
-#ifdef ANDROID_BUILD
-    wake_lock_destroy(&unifi_sdio_wake_lock);
-#endif
+    wakeup_source_remove(&unifi_sdio_wakeup_source);
     sdio_unregister_driver(&unifi_driver);
 
     sdio_func_drv = NULL;
diff --git a/drivers/staging/csr/sme_sys.c b/drivers/staging/csr/sme_sys.c
index 5b26c41..f2d5592 100644
--- a/drivers/staging/csr/sme_sys.c
+++ b/drivers/staging/csr/sme_sys.c
@@ -22,6 +22,8 @@
 #include "csr_wifi_sme_sef.h"
 #endif
 
+extern struct wakeup_source unifi_sdio_wakeup_source;
+
 /*
  * This file implements the SME SYS API and contains the following functions:
  * CsrWifiRouterCtrlMediaStatusReqHandler()
@@ -735,11 +737,11 @@ void CsrWifiRouterCtrlWifiOnReqHandler(void* drvpriv, CsrWifiFsmEvent* msg)
     if( priv->wol_suspend ) {
         unifi_trace(priv, UDBG1, "CsrWifiRouterCtrlWifiOnReqHandler: Don't reset mode\n");
     } else {
-#ifdef ANDROID_BUILD
+
         /* Take the wakelock while Wi-Fi On is in progress */
         unifi_trace(priv, UDBG1, "CsrWifiRouterCtrlWifiOnReqHandler: take wake lock\n");
-        wake_lock(&unifi_sdio_wake_lock);
-#endif
+        __pm_stay_awake(&unifi_sdio_wakeup_source);
+
         for (i=0; i<CSR_WIFI_NUM_INTERFACES; i++) {
             unifi_trace(priv, UDBG1, "CsrWifiRouterCtrlWifiOnReqHandler: Setting interface %d to NONE\n", i );
 
@@ -1172,11 +1174,10 @@ void CsrWifiRouterCtrlWifiOnResHandler(void* drvpriv, CsrWifiFsmEvent* msg)
 #endif
         unifi_info(priv, "UniFi ready\n");
 
-#ifdef ANDROID_BUILD
         /* Release the wakelock */
         unifi_trace(priv, UDBG1, "ready: release wake lock\n");
-        wake_unlock(&unifi_sdio_wake_lock);
-#endif
+        __pm_relax(&unifi_sdio_wakeup_source);
+
         /* Firmware initialisation is complete, so let the SDIO bus
          * clock be raised when convienent to the core.
          */
@@ -1812,11 +1813,10 @@ void CsrWifiRouterCtrlModeSetReqHandler(void* drvpriv, CsrWifiFsmEvent* msg)
             CsrWifiRouterCtrlVersions versions;
             int r;
 
-#ifdef ANDROID_BUILD
             /* Take the wakelock while switching patch */
             unifi_trace(priv, UDBG1, "patch switch: take wake lock\n");
-            wake_lock(&unifi_sdio_wake_lock);
-#endif
+            __pm_stay_awake(&unifi_sdio_wakeup_source);
+
             unifi_info(priv, "Resetting UniFi with %s patch\n", CSR_WIFI_HIP_IS_AP_FW(req->mode) ? "AP" : "STA");
 
             r = uf_request_firmware_files(priv, UNIFI_FW_STA);
diff --git a/drivers/staging/csr/unifi_priv.h b/drivers/staging/csr/unifi_priv.h
index aec8e28..331137b 100644
--- a/drivers/staging/csr/unifi_priv.h
+++ b/drivers/staging/csr/unifi_priv.h
@@ -42,10 +42,6 @@
 
 #include <linux/fs.h>
 
-#ifdef ANDROID_BUILD
-#include <linux/wakelock.h>
-#endif
-
 #include "csr_wifi_hip_unifi.h"
 #include "csr_wifi_hip_unifi_udi.h"
 #include "csr_wifi_router_lib.h"
@@ -65,10 +61,6 @@ typedef struct CsrWifiSmeApConfig CsrWifiSmeApConfig_t;
 #include "unifi_wext.h"
 #endif
 
-#ifdef ANDROID_BUILD
-extern struct wake_lock unifi_sdio_wake_lock;
-#endif
-
 #include "unifi_clients.h"
 
 #ifdef CSR_NATIVE_LINUX
-- 
1.7.12

