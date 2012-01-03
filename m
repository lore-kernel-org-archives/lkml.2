Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754648Ab2ACSjr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jan 2012 13:39:47 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:40289 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754582Ab2ACSjo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jan 2012 13:39:44 -0500
X-Authority-Analysis: v=2.0 cv=Pb19d1dd c=1 sm=0 a=mpMdnlmFKti1S5SNY1DT+A==:17 a=TRgVYD6ZyiEA:10 a=C7s-xEWy3xMA:10 a=Zx2FLkwYMp0A:10 a=kj9zAlcOel0A:10 a=VPW9pYw8AAAA:8 a=20KFwNOVAAAA:8 a=T5Ni6VkXAAAA:8 a=yQdBAQUQAAAA:8 a=Z4Rwk6OoAAAA:8 a=VwQbUJbxAAAA:8 a=n9Sqmae0AAAA:8 a=dFf6d0EZe61Hz7HnJQAA:9 a=jeYBqG3udeo-RhlbspsA:7 a=CjuIK1q_8ugA:10 a=y2xWDDzaQp4A:10 a=1vY5q33nLKwA:10 a=jEp0ucaQiEUA:10 a=IcxpeKGZWnEA:10 a=jbrJJM5MRmoA:10 a=z0jh1eRXt18A:10 a=mpMdnlmFKti1S5SNY1DT+A==:117
X-Cloudmark-Score: 0
X-Originating-IP: 65.28.92.85
Date: Tue, 03 Jan 2012 12:39:40 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
To: John W Linville <linville@tuxdriver.com>, torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, chaoming_li@realsil.com.cn,
        linux-wireless@vger.kernel.org
Subject: [PATCH] rtl8192cu: Fix WARNING on suspend/resume
Message-ID: <4f034b6c.ypfAbSdXSgMHtfqa%Larry.Finger@lwfinger.net>
User-Agent: Heirloom mailx 12.5 7/5/10
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A recent LKML thread (http://lkml.indiana.edu/hypermail/linux/kernel/1112.3/00965.html)
discusses warnings that occur during a suspend/resume cycle. The driver
attempts to read the firmware file before userspace is ready, leading to the
following warning:

WARNING: at drivers/base/firmware_class.c:537 _request_firmware+0x3f6/0x420()

For rtl8192cu, the problem is fixed by storing the firmware in a global buffer
rather than one allocated per device. The usage count is increased when
suspending and decreased when resuming. This way, the firmware is retained
through a suspend/resume cycle, and does not have to be reread.

This patch should fix the bug reported in
https://bugzilla.redhat.com/show_bug.cgi?id=771002.

Note: This patch also touches rtl8192ce as the "firmware" loaded message
is now printed in the wrong place.

Reported-by: Mohammed Arafa <bugzilla@in-egypt.net>
Reported-by: Dave Jones <davej@redhat.com>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Stable <stable@vger.kernel.org>
---

John/Linus,

This patch should be pushed in V3.2 (if possible).

There will be similar patches for rtl8192{ce,se,de}, but as they do not
trigger a warning, I'll save them for later.

Larry
---

Index: wireless-testing-new/drivers/net/wireless/rtlwifi/rtl8192c/fw_common.c
===================================================================
--- wireless-testing-new.orig/drivers/net/wireless/rtlwifi/rtl8192c/fw_common.c
+++ wireless-testing-new/drivers/net/wireless/rtlwifi/rtl8192c/fw_common.c
@@ -265,7 +265,6 @@ int rtl92c_download_fw(struct ieee80211_
 	if (!rtlhal->pfirmware)
 		return 1;
 
-	pr_info("Loading firmware file %s\n", rtlpriv->cfg->fw_name);
 	pfwheader = (struct rtl92c_firmware_header *)rtlhal->pfirmware;
 	pfwdata = (u8 *) rtlhal->pfirmware;
 	fwsize = rtlhal->fwsize;
Index: wireless-testing-new/drivers/net/wireless/rtlwifi/rtl8192ce/sw.c
===================================================================
--- wireless-testing-new.orig/drivers/net/wireless/rtlwifi/rtl8192ce/sw.c
+++ wireless-testing-new/drivers/net/wireless/rtlwifi/rtl8192ce/sw.c
@@ -186,6 +186,7 @@ int rtl92c_init_sw_vars(struct ieee80211
 	memcpy(rtlpriv->rtlhal.pfirmware, firmware->data, firmware->size);
 	rtlpriv->rtlhal.fwsize = firmware->size;
 	release_firmware(firmware);
+	pr_info("rtl8192ce: Loaded firmware file %s\n", rtlpriv->cfg->fw_name);
 
 	return 0;
 }
Index: wireless-testing-new/drivers/net/wireless/rtlwifi/rtl8192cu/sw.c
===================================================================
--- wireless-testing-new.orig/drivers/net/wireless/rtlwifi/rtl8192cu/sw.c
+++ wireless-testing-new/drivers/net/wireless/rtlwifi/rtl8192cu/sw.c
@@ -43,6 +43,8 @@
 #include "hw.h"
 #include <linux/vmalloc.h>
 #include <linux/module.h>
+#include <linux/atomic.h>
+#include <linux/types.h>
 
 MODULE_AUTHOR("Georgia		<georgia@realtek.com>");
 MODULE_AUTHOR("Ziv Huang	<ziv_huang@realtek.com>");
@@ -51,6 +53,10 @@ MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("Realtek 8192C/8188C 802.11n USB wireless");
 MODULE_FIRMWARE("rtlwifi/rtl8192cufw.bin");
 
+static char *rtl8192cu_firmware;		/* pointer to firmware */
+static int firmware_size;
+static atomic_t usage_count;
+
 static int rtl92cu_init_sw_vars(struct ieee80211_hw *hw)
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
@@ -62,12 +68,21 @@ static int rtl92cu_init_sw_vars(struct i
 	rtlpriv->dm.disable_framebursting = 0;
 	rtlpriv->dm.thermalvalue = 0;
 	rtlpriv->dbg.global_debuglevel = rtlpriv->cfg->mod_params->debug;
-	rtlpriv->rtlhal.pfirmware = vmalloc(0x4000);
-	if (!rtlpriv->rtlhal.pfirmware) {
+
+	if (rtl8192cu_firmware) {
+		/* firmware already loaded - true for suspend/resume
+		 * and multiple instances of the device */
+		rtlpriv->rtlhal.pfirmware = rtl8192cu_firmware;
+		rtlpriv->rtlhal.fwsize = firmware_size;
+		return 0;
+	}
+	rtl8192cu_firmware = vzalloc(0x4000);
+	if (!rtl8192cu_firmware) {
 		RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,
 			 ("Can't alloc buffer for fw.\n"));
 		return 1;
 	}
+
 	/* request fw */
 	err = request_firmware(&firmware, rtlpriv->cfg->fw_name,
 			rtlpriv->io.dev);
@@ -82,9 +97,14 @@ static int rtl92cu_init_sw_vars(struct i
 		release_firmware(firmware);
 		return 1;
 	}
-	memcpy(rtlpriv->rtlhal.pfirmware, firmware->data, firmware->size);
+	pr_info("rtl8192cu: Loaded firmware from file %s\n",
+		rtlpriv->cfg->fw_name);
+	memcpy(rtl8192cu_firmware, firmware->data, firmware->size);
+	firmware_size = firmware->size;
 	rtlpriv->rtlhal.fwsize = firmware->size;
+	rtlpriv->rtlhal.pfirmware = rtl8192cu_firmware;
 	release_firmware(firmware);
+	atomic_inc(&usage_count);
 
 	return 0;
 }
@@ -93,12 +113,30 @@ static void rtl92cu_deinit_sw_vars(struc
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 
-	if (rtlpriv->rtlhal.pfirmware) {
-		vfree(rtlpriv->rtlhal.pfirmware);
+	atomic_dec(&usage_count);
+	if (!atomic_read(&usage_count) && rtlpriv->rtlhal.pfirmware) {
+		vfree(rtl8192cu_firmware);
+		rtl8192cu_firmware = NULL;
 		rtlpriv->rtlhal.pfirmware = NULL;
 	}
 }
 
+#ifdef CONFIG_PM
+static int rtl8192cu_usb_suspend(struct usb_interface *pusb_intf,
+				 pm_message_t message)
+{
+	/* Increase usage_count to Save loaded fw across suspend/resume */
+	atomic_inc(&usage_count);
+	return 0;
+}
+
+static int rtl8192cu_usb_resume(struct usb_interface *pusb_intf)
+{
+	atomic_dec(&usage_count);	/* after resume, decrease usage count */
+	return 0;
+}
+#endif
+
 static struct rtl_hal_ops rtl8192cu_hal_ops = {
 	.init_sw_vars = rtl92cu_init_sw_vars,
 	.deinit_sw_vars = rtl92cu_deinit_sw_vars,
@@ -375,9 +413,9 @@ static struct usb_driver rtl8192cu_drive
 	.id_table = rtl8192c_usb_ids,
 
 #ifdef CONFIG_PM
-	/* .suspend = rtl_usb_suspend, */
-	/* .resume = rtl_usb_resume, */
-	/* .reset_resume = rtl8192c_resume, */
+	.suspend = rtl8192cu_usb_suspend,
+	.resume = rtl8192cu_usb_resume,
+	.reset_resume = rtl8192cu_usb_resume,
 #endif /* CONFIG_PM */
 #ifdef CONFIG_AUTOSUSPEND
 	.supports_autosuspend = 1,
