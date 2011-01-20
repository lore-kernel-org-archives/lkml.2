Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755336Ab1ATGRM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jan 2011 01:17:12 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:38842 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755319Ab1ATGRH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jan 2011 01:17:07 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=g88SYW9RyVZqZX5ULdIaU/vEn2Ll2ghV++6+i1rJOrXy6gtLJNDg8C96E25ryfUSxi
         +6QIXhFHH0pugV3oIMcxH/M2wKaM4f6DgJMrHnxARxnurjKSAHmD937POAnWSc9WR8HF
         P/EpVzec82o23hdnfkLaHieY82dKrhkVyUqIM=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, gregkh@suse.de,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [RFC 2/3]staging: ath6kl Remove CONFIG_HAS_WAKELOCK
Date: Wed, 19 Jan 2011 22:16:05 -0800
Message-Id: <1295504166-1042-2-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.6.5.GIT
In-Reply-To: <1295504166-1042-1-git-send-email-justinmattock@gmail.com>
References: <1295504166-1042-1-git-send-email-justinmattock@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch below removes CONFIG_HAS_WAKELOCK since it is no longer in the kernel.
Please let me know, if this is the proper way of doing this and/or more needs
to be done..

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 drivers/staging/ath6kl/os/linux/ar6000_android.c |   23 ------------------
 drivers/staging/ath6kl/os/linux/ar6000_pm.c      |   28 ----------------------
 2 files changed, 0 insertions(+), 51 deletions(-)

diff --git a/drivers/staging/ath6kl/os/linux/ar6000_android.c b/drivers/staging/ath6kl/os/linux/ar6000_android.c
index a588825..dbde05f 100644
--- a/drivers/staging/ath6kl/os/linux/ar6000_android.c
+++ b/drivers/staging/ath6kl/os/linux/ar6000_android.c
@@ -25,9 +25,6 @@
 #include <linux/vmalloc.h>
 #include <linux/fs.h>
 
-#ifdef CONFIG_HAS_WAKELOCK
-#include <linux/wakelock.h>
-#endif
 #ifdef CONFIG_HAS_EARLYSUSPEND
 #include <linux/earlysuspend.h>
 #endif
@@ -44,11 +41,6 @@ extern int bmienable;
 extern struct net_device *ar6000_devices[];
 extern char ifname[];
 
-#ifdef CONFIG_HAS_WAKELOCK
-extern struct wake_lock ar6k_wow_wake_lock;
-struct wake_lock ar6k_init_wake_lock;
-#endif
-
 const char def_ifname[] = "wlan0";
 module_param_string(fwpath, fwpath, sizeof(fwpath), 0644);
 module_param(enablelogcat, uint, 0644);
@@ -280,14 +272,8 @@ void android_release_firmware(const struct firmware *firmware)
 static A_STATUS ar6000_android_avail_ev(void *context, void *hif_handle)
 {
     A_STATUS ret;    
-#ifdef CONFIG_HAS_WAKELOCK
-    wake_lock(&ar6k_init_wake_lock);
-#endif
     ar6000_enable_mmchost_detect_change(0);
     ret = ar6000_avail_ev_p(context, hif_handle);
-#ifdef CONFIG_HAS_WAKELOCK
-    wake_unlock(&ar6k_init_wake_lock);
-#endif
     return ret;
 }
 
@@ -328,9 +314,6 @@ void android_module_init(OSDRV_CALLBACKS *osdrvCallbacks)
     bmienable = 1;
     if (ifname[0] == '\0')
         strcpy(ifname, def_ifname);
-#ifdef CONFIG_HAS_WAKELOCK
-    wake_lock_init(&ar6k_init_wake_lock, WAKE_LOCK_SUSPEND, "ar6k_init");
-#endif
 #ifdef CONFIG_HAS_EARLYSUSPEND
     ar6k_early_suspend.suspend = android_early_suspend;
     ar6k_early_suspend.resume  = android_late_resume;
@@ -349,9 +332,6 @@ void android_module_exit(void)
 #ifdef CONFIG_HAS_EARLYSUSPEND
     unregister_early_suspend(&ar6k_early_suspend);
 #endif
-#ifdef CONFIG_HAS_WAKELOCK
-    wake_lock_destroy(&ar6k_init_wake_lock);
-#endif
     ar6000_enable_mmchost_detect_change(1);
 }
 
@@ -395,9 +375,6 @@ void android_ar6k_check_wow_status(AR_SOFTC_T *ar, struct sk_buff *skb, A_BOOL i
         }
         if (needWake) {
             /* keep host wake up if there is any event and packate comming in*/
-#ifdef CONFIG_HAS_WAKELOCK
-            wake_lock_timeout(&ar6k_wow_wake_lock, 3*HZ);
-#endif
             if (wowledon) {
                 char buf[32];
                 int len = sprintf(buf, "on");
diff --git a/drivers/staging/ath6kl/os/linux/ar6000_pm.c b/drivers/staging/ath6kl/os/linux/ar6000_pm.c
index b937df9..13195d4 100644
--- a/drivers/staging/ath6kl/os/linux/ar6000_pm.c
+++ b/drivers/staging/ath6kl/os/linux/ar6000_pm.c
@@ -30,23 +30,12 @@
 #include <linux/platform_device.h>
 #include "wlan_config.h"
 
-#ifdef CONFIG_HAS_WAKELOCK
-#include <linux/wakelock.h>
-#endif
-
 #define WOW_ENABLE_MAX_INTERVAL 0
 #define WOW_SET_SCAN_PARAMS     0
 
 extern unsigned int wmitimeout;
 extern wait_queue_head_t arEvent;
 
-#ifdef CONFIG_PM
-#ifdef CONFIG_HAS_WAKELOCK
-struct wake_lock ar6k_suspend_wake_lock;
-struct wake_lock ar6k_wow_wake_lock;
-#endif
-#endif /* CONFIG_PM */
-
 #ifdef ANDROID_ENV
 extern void android_ar6k_check_wow_status(AR_SOFTC_T *ar, struct sk_buff *skb, A_BOOL isEvent);
 #endif
@@ -89,9 +78,6 @@ static void ar6000_wow_resume(AR_SOFTC_T *ar)
         A_UINT16 bg_period = (ar->scParams.bg_period==0) ? 60 : ar->scParams.bg_period;
         WMI_SET_HOST_SLEEP_MODE_CMD hostSleepMode = {TRUE, FALSE};
         ar->arWowState = WLAN_WOW_STATE_NONE;
-#ifdef CONFIG_HAS_WAKELOCK
-        wake_lock_timeout(&ar6k_wow_wake_lock, 3*HZ);
-#endif
         if (wmi_set_host_sleep_mode_cmd(ar->arWmi, &hostSleepMode)!=A_OK) {
             AR_DEBUG_PRINTF(ATH_DEBUG_ERR,("Fail to setup restore host awake\n"));
         }
@@ -267,9 +253,6 @@ A_STATUS ar6000_resume_ev(void *context)
     AR_SOFTC_T *ar = (AR_SOFTC_T *)context;
     A_UINT16 powerState = ar->arWlanPowerState;
 
-#ifdef CONFIG_HAS_WAKELOCK
-    wake_lock(&ar6k_suspend_wake_lock);
-#endif
     AR_DEBUG_PRINTF(ATH_DEBUG_PM, ("%s: enter previous state %d wowState %d\n", __func__, powerState, ar->arWowState));
     switch (powerState) {
     case WLAN_POWER_STATE_WOW:
@@ -287,9 +270,6 @@ A_STATUS ar6000_resume_ev(void *context)
         AR_DEBUG_PRINTF(ATH_DEBUG_ERR, ("Strange SDIO bus power mode!!\n"));
         break;
     }
-#ifdef CONFIG_HAS_WAKELOCK
-    wake_unlock(&ar6k_suspend_wake_lock);
-#endif
     return A_OK;
 }
 
@@ -704,10 +684,6 @@ void ar6000_pm_init()
 {
     A_REGISTER_MODULE_DEBUG_INFO(pm);
 #ifdef CONFIG_PM
-#ifdef CONFIG_HAS_WAKELOCK
-    wake_lock_init(&ar6k_suspend_wake_lock, WAKE_LOCK_SUSPEND, "ar6k_suspend");
-    wake_lock_init(&ar6k_wow_wake_lock, WAKE_LOCK_SUSPEND, "ar6k_wow");
-#endif
     /*
      * Register ar6000_pm_device into system.
      * We should also add platform_device into the first item of array
@@ -723,9 +699,5 @@ void ar6000_pm_exit()
 {
 #ifdef CONFIG_PM
     platform_driver_unregister(&ar6000_pm_device);
-#ifdef CONFIG_HAS_WAKELOCK
-    wake_lock_destroy(&ar6k_suspend_wake_lock);
-    wake_lock_destroy(&ar6k_wow_wake_lock);
-#endif
 #endif /* CONFIG_PM */
 }
-- 
1.6.5.GIT

