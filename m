Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755413Ab2IAJSq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Sep 2012 05:18:46 -0400
Received: from gn237.zone.eu ([217.146.67.237]:54739 "EHLO gn237.zone.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753315Ab2IAJRK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Sep 2012 05:17:10 -0400
From: Priit Laes <plaes@plaes.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Priit Laes <plaes@plaes.org>
Subject: [PATCH 14/14] staging: csr: Remove all leftover kernel version checks \o/
Date: Sat,  1 Sep 2012 12:06:10 +0300
Message-Id: <1346490370-32438-15-git-send-email-plaes@plaes.org>
X-Mailer: git-send-email 1.7.12
In-Reply-To: <1346490370-32438-1-git-send-email-plaes@plaes.org>
References: <1346490370-32438-1-git-send-email-plaes@plaes.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Priit Laes <plaes@plaes.org>
---
 drivers/staging/csr/csr_framework_ext.c    | 13 +------------
 drivers/staging/csr/csr_time.c             |  7 -------
 drivers/staging/csr/io.c                   | 19 -------------------
 drivers/staging/csr/monitor.c              |  4 ----
 drivers/staging/csr/sdio_mmc.c             | 20 --------------------
 drivers/staging/csr/sme_native.c           |  4 ----
 drivers/staging/csr/sme_sys.c              |  2 --
 drivers/staging/csr/ul_int.c               |  4 ----
 drivers/staging/csr/unifi_pdu_processing.c |  3 ---
 9 files changed, 1 insertion(+), 75 deletions(-)

diff --git a/drivers/staging/csr/csr_framework_ext.c b/drivers/staging/csr/csr_framework_ext.c
index 12e7ddf..f91a4bf 100644
--- a/drivers/staging/csr/csr_framework_ext.c
+++ b/drivers/staging/csr/csr_framework_ext.c
@@ -12,20 +12,9 @@
 #include <linux/version.h>
 #include <linux/kthread.h>
 #include <linux/module.h>
-
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2, 6, 34)
-#include <linux/slab.h>
-#endif
-
-#if LINUX_VERSION_CODE > KERNEL_VERSION(2, 6, 19)
 #include <linux/freezer.h>
-#endif
-#if LINUX_VERSION_CODE < KERNEL_VERSION(2, 6, 27)
-#include <asm/semaphore.h>
-#else
 #include <linux/semaphore.h>
-#endif
-
+#include <linux/slab.h>
 #include <linux/bitops.h>
 
 #include "csr_framework_ext.h"
diff --git a/drivers/staging/csr/csr_time.c b/drivers/staging/csr/csr_time.c
index 83586ca..2e315e1 100644
--- a/drivers/staging/csr/csr_time.c
+++ b/drivers/staging/csr/csr_time.c
@@ -10,13 +10,6 @@
 
 #include <linux/kernel.h>
 #include <linux/version.h>
-
-#if LINUX_VERSION_CODE < KERNEL_VERSION(2, 6, 33)
-#elif LINUX_VERSION_CODE < KERNEL_VERSION(2, 6, 16)
-#include <linux/autoconf.h>
-#include <linux/config.h>
-#endif
-
 #include <linux/time.h>
 #include <linux/module.h>
 
diff --git a/drivers/staging/csr/io.c b/drivers/staging/csr/io.c
index 75b4671..2f7505f 100644
--- a/drivers/staging/csr/io.c
+++ b/drivers/staging/csr/io.c
@@ -70,11 +70,7 @@ static int In_use[MAX_UNIFI_DEVS];
  * Mutex to prevent UDI clients to open the character device before the priv
  * is created and initialised.
  */
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2, 6, 37)
 DEFINE_SEMAPHORE(Unifi_instance_mutex);
-#else
-DECLARE_MUTEX(Unifi_instance_mutex);
-#endif
 /*
  * When the device is removed, unregister waits on Unifi_cleanup_wq
  * until all the UDI clients release the character device.
@@ -177,21 +173,6 @@ uf_register_netdev(unifi_priv_t *priv, int interfaceTag)
     /* The device is registed */
     interfacePriv->netdev_registered = 1;
 
-#if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,28)
-#ifdef CONFIG_NET_SCHED
-    /*
-     * IMPORTANT:
-     * uf_install_qdisc() holds the network device lock, we can not
-     * install the qdisk before the network device is registered.
-     */
-    r = uf_install_qdisc(priv->netdev[interfaceTag]);
-    if (r) {
-        unifi_error(priv, "Failed to install qdisc\n");
-        return r;
-    }
-#endif /* CONFIG_NET_SCHED */
-#endif /* LINUX_VERSION_CODE */
-
 #ifdef CSR_SUPPORT_SME
     /*
      * Register the inet handler; it notifies us for changes in the IP address.
diff --git a/drivers/staging/csr/monitor.c b/drivers/staging/csr/monitor.c
index 628782a..239fe7c 100644
--- a/drivers/staging/csr/monitor.c
+++ b/drivers/staging/csr/monitor.c
@@ -192,11 +192,7 @@ netrx_radiotap(unifi_priv_t *priv,
 
 
     skb->dev = dev;
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,22)
     skb->mac_header = skb->data;
-#else
-    skb->mac.raw = skb->data;
-#endif
     skb->pkt_type = PACKET_OTHERHOST;
     skb->protocol = __constant_htons(ETH_P_80211_RAW);
     memset(skb->cb, 0, sizeof(skb->cb));
diff --git a/drivers/staging/csr/sdio_mmc.c b/drivers/staging/csr/sdio_mmc.c
index d3fd57c..be3dd34 100644
--- a/drivers/staging/csr/sdio_mmc.c
+++ b/drivers/staging/csr/sdio_mmc.c
@@ -31,7 +31,6 @@ struct wake_lock unifi_sdio_wake_lock; /* wakelock to prevent suspend while resu
 
 static CsrSdioFunctionDriver *sdio_func_drv;
 
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,32)
 #ifdef CONFIG_PM
 static int uf_sdio_mmc_power_event(struct notifier_block *this, unsigned long event, void *ptr);
 #endif
@@ -45,7 +44,6 @@ static int uf_sdio_mmc_power_event(struct notifier_block *this, unsigned long ev
  * returning immediately (at least on x86).
  */
 static int card_is_powered = 1;
-#endif /* 2.6.32 */
 
 /* MMC uses ENOMEDIUM to indicate card gone away */
 
@@ -637,7 +635,6 @@ CsrSdioFunctionIdle(CsrSdioFunction *function)
 CsrResult
 CsrSdioPowerOn(CsrSdioFunction *function)
 {
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,32)
     struct sdio_func *func = (struct sdio_func *)function->priv;
     struct mmc_host *host = func->card->host;
 
@@ -649,7 +646,6 @@ CsrSdioPowerOn(CsrSdioFunction *function)
         printk(KERN_INFO "SDIO: Skip power on; card is already powered.\n");
     }
     _sdio_release_host(func);
-#endif /* 2.6.32 */
 
     return CSR_RESULT_SUCCESS;
 } /* CsrSdioPowerOn() */
@@ -667,7 +663,6 @@ CsrSdioPowerOn(CsrSdioFunction *function)
 void
 CsrSdioPowerOff(CsrSdioFunction *function)
 {
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,32)
     struct sdio_func *func = (struct sdio_func *)function->priv;
     struct mmc_host *host = func->card->host;
 
@@ -679,7 +674,6 @@ CsrSdioPowerOff(CsrSdioFunction *function)
         printk(KERN_INFO "SDIO: Skip power off; card is already powered off.\n");
     }
     _sdio_release_host(func);
-#endif /* 2.6.32 */
 } /* CsrSdioPowerOff() */
 
 
@@ -897,7 +891,6 @@ csr_sdio_linux_install_irq(CsrSdioFunction *function)
     return r;
 } /* csr_sdio_linux_install_irq() */
 
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,32)
 #ifdef CONFIG_PM
 
 /*
@@ -1023,7 +1016,6 @@ uf_sdio_mmc_power_event(struct notifier_block *this, unsigned long event, void *
 }
 
 #endif /* CONFIG_PM */
-#endif /* 2.6.32 */
 
 /*
  * ---------------------------------------------------------------------------
@@ -1050,10 +1042,8 @@ uf_glue_sdio_probe(struct sdio_func *func,
     /* First of all claim the SDIO driver */
     sdio_claim_host(func);
 
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,32)
     /* Assume that the card is already powered */
     card_is_powered = 1;
-#endif
 
     /* Assumes one card per host, which is true for SDIO */
     instance = func->card->host->index;
@@ -1093,14 +1083,12 @@ uf_glue_sdio_probe(struct sdio_func *func,
     /* Pass context to the SDIO driver */
     sdio_set_drvdata(func, sdio_ctx);
 
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,32)
 #ifdef CONFIG_PM
     /* Register to get PM events */
     if (uf_sdio_mmc_register_pm_notifier(sdio_ctx) == NULL) {
         unifi_error(NULL, "%s: Failed to register for PM events\n", __FUNCTION__);
     }
 #endif
-#endif
 
     /* Register this device with the SDIO function driver */
     /* Call the main UniFi driver inserted handler */
@@ -1156,12 +1144,10 @@ uf_glue_sdio_remove(struct sdio_func *func)
         sdio_func_drv->removed(sdio_ctx);
     }
 
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,32)
 #ifdef CONFIG_PM
     /* Unregister for PM events */
     uf_sdio_mmc_unregister_pm_notifier(sdio_ctx);
 #endif
-#endif
 
     kfree(sdio_ctx);
 
@@ -1182,7 +1168,6 @@ static const struct sdio_device_id unifi_ids[] = {
 
 MODULE_DEVICE_TABLE(sdio, unifi_ids);
 
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,32)
 #ifdef CONFIG_PM
 
 /*
@@ -1252,16 +1237,13 @@ static struct dev_pm_ops unifi_pm_ops = {
 #define UNIFI_PM_OPS  NULL
 
 #endif /* CONFIG_PM */
-#endif /* 2.6.32 */
 
 static struct sdio_driver unifi_driver = {
     .probe      = uf_glue_sdio_probe,
     .remove     = uf_glue_sdio_remove,
     .name       = "unifi",
     .id_table	= unifi_ids,
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,32)
     .drv.pm     = UNIFI_PM_OPS,
-#endif /* 2.6.32 */
 };
 
 
@@ -1305,12 +1287,10 @@ CsrSdioFunctionDriverRegister(CsrSdioFunctionDriver *sdio_drv)
      */
     sdio_func_drv = sdio_drv;
 
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,32)
 #ifdef CONFIG_PM
     /* Initialise PM notifier list */
     INIT_LIST_HEAD(&uf_sdio_mmc_pm_notifiers.list);
 #endif
-#endif
 
     /* Register ourself with mmc_core */
     r = sdio_register_driver(&unifi_driver);
diff --git a/drivers/staging/csr/sme_native.c b/drivers/staging/csr/sme_native.c
index 229268f..b5733bd 100644
--- a/drivers/staging/csr/sme_native.c
+++ b/drivers/staging/csr/sme_native.c
@@ -24,11 +24,7 @@ uf_sme_init(unifi_priv_t *priv)
 {
     func_enter();
 
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2, 6, 37)
     sema_init(&priv->mlme_blocking_mutex, 1);
-#else
-    init_MUTEX(&priv->mlme_blocking_mutex);
-#endif
 
 #ifdef CSR_SUPPORT_WEXT
     {
diff --git a/drivers/staging/csr/sme_sys.c b/drivers/staging/csr/sme_sys.c
index f701ce3..1bf8c45 100644
--- a/drivers/staging/csr/sme_sys.c
+++ b/drivers/staging/csr/sme_sys.c
@@ -869,7 +869,6 @@ wifi_off(unifi_priv_t *priv)
     unifi_trace(priv, UDBG1, "wifi_off\n");
 
     /* Destroy the Traffic Analysis Module */
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,23)
     cancel_work_sync(&priv->ta_ind_work.task);
     cancel_work_sync(&priv->ta_sample_ind_work.task);
 #ifdef CSR_SUPPORT_WEXT
@@ -884,7 +883,6 @@ wifi_off(unifi_priv_t *priv)
             cancel_work_sync(&netpriv->send_m4_ready_task);
         }
     }
-#endif
     flush_workqueue(priv->unifi_workqueue);
 
     /* fw_init parameter can prevent power off UniFi, for debugging */
diff --git a/drivers/staging/csr/ul_int.c b/drivers/staging/csr/ul_int.c
index 46d3507..0fae6f4 100644
--- a/drivers/staging/csr/ul_int.c
+++ b/drivers/staging/csr/ul_int.c
@@ -44,11 +44,7 @@ ul_init_clients(unifi_priv_t *priv)
     int id;
     ul_client_t *ul_clients;
 
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2, 6, 37)
     sema_init(&priv->udi_logging_mutex, 1);
-#else
-    init_MUTEX(&priv->udi_logging_mutex);
-#endif
     priv->logging_client = NULL;
 
     ul_clients = priv->ul_clients;
diff --git a/drivers/staging/csr/unifi_pdu_processing.c b/drivers/staging/csr/unifi_pdu_processing.c
index 7c7e8d4..645fddd 100644
--- a/drivers/staging/csr/unifi_pdu_processing.c
+++ b/drivers/staging/csr/unifi_pdu_processing.c
@@ -23,9 +23,6 @@
 #include "csr_wifi_hip_conversions.h"
 #include "csr_time.h"
 #include "unifi_priv.h"
-#if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,13)
-#include <net/iw_handler.h>
-#endif
 #include <net/pkt_sched.h>
 
 #ifdef CSR_SUPPORT_SME
-- 
1.7.12

