Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932603Ab2ASRqO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jan 2012 12:46:14 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:59750 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756762Ab2ASRqL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jan 2012 12:46:11 -0500
X-Authority-Analysis: v=2.0 cv=Pb19d1dd c=1 sm=0 a=mpMdnlmFKti1S5SNY1DT+A==:17 a=TRgVYD6ZyiEA:10 a=d88mCWgvtBgA:10 a=Zx2FLkwYMp0A:10 a=kj9zAlcOel0A:10 a=VPW9pYw8AAAA:8 a=gu6fZOg2AAAA:8 a=yQdBAQUQAAAA:8 a=3nmAiFBrjoF6uEEtTS0A:9 a=S5yD-E_QgBcXJbFMuLAA:7 a=CjuIK1q_8ugA:10 a=y2xWDDzaQp4A:10 a=IcxpeKGZWnEA:10 a=mpMdnlmFKti1S5SNY1DT+A==:117
X-Cloudmark-Score: 0
X-Originating-IP: 65.28.92.85
Date: Thu, 19 Jan 2012 11:46:08 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
To: linux-kernel@vger.kernel.org
Cc: devel@driverdev.osuosl.org
Subject: [RFC] rtlwifi: Convert to asynchronous firmware load
Message-ID: <4f1856e0.Kbqusp/TbhaZTP+I%Larry.Finger@lwfinger.net>
User-Agent: Heirloom mailx 12.5 7/5/10
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch addresses two recent mail threads. The first, which was on LKML
(http://lkml.indiana.edu/hypermail/linux/kernel/1112.3/00965.html) was for a
WARNING that occurs after a suspend/resume cycle for rtl8192cu.

The scond mail thread (http://marc.info/?l=linux-wireless&m=132655490826766&w=2)
concerned changes in udev that break drivers that delay while firmware is loaded
on modprobe.

This patch converts all rtlwifi-based drivers to use the asynchronous firmware
loading mechanism. A completion queue entry is inititialized and the firmware
load is started with the device initialization. The firmware-loaded callback routine
issues a complete() call. The routine that uploads firmware to the device calls
wait_for_completion_interruptible_timeout() with a 5 sec timeout.

The current patch is working, but as this is my first usage of the completion
mechanism, I would like an expert to look it over. In particular, is it
sufficient and prudent to issue a complete() call when the driver is unloaded
so as to not leave a queue entry when the underlying struct is destroyed?

For the purists, yes, I know this is not a proper commit message. I will supply
one when the patch is actually submitted.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---

Index: wireless-testing-new/drivers/net/wireless/rtlwifi/pci.c
===================================================================
--- wireless-testing-new.orig/drivers/net/wireless/rtlwifi/pci.c
+++ wireless-testing-new/drivers/net/wireless/rtlwifi/pci.c
@@ -1777,6 +1777,7 @@ int __devinit rtl_pci_probe(struct pci_d
 	pci_set_drvdata(pdev, hw);
 
 	rtlpriv = hw->priv;
+	init_completion(&rtlpriv->firmware_load_complete);
 	pcipriv = (void *)rtlpriv->priv;
 	pcipriv->dev.pdev = pdev;
 
@@ -1925,6 +1926,9 @@ void rtl_pci_disconnect(struct pci_dev *
 	struct rtl_pci *rtlpci = rtl_pcidev(pcipriv);
 	struct rtl_mac *rtlmac = rtl_mac(rtlpriv);
 
+	/* Just in case fw load has not completed */
+	complete(&rtlpriv->firmware_load_complete);
+
 	clear_bit(RTL_STATUS_INTERFACE_START, &rtlpriv->status);
 
 	sysfs_remove_group(&pdev->dev.kobj, &rtl_attribute_group);
Index: wireless-testing-new/drivers/net/wireless/rtlwifi/rtl8192c/fw_common.c
===================================================================
--- wireless-testing-new.orig/drivers/net/wireless/rtlwifi/rtl8192c/fw_common.c
+++ wireless-testing-new/drivers/net/wireless/rtlwifi/rtl8192c/fw_common.c
@@ -257,10 +257,17 @@ int rtl92c_download_fw(struct ieee80211_
 	u32 fwsize;
 	enum version_8192c version = rtlhal->version;
 
-	if (!rtlhal->pfirmware)
+	/* hold at this point until firmware is available */
+	if (!wait_for_completion_interruptible_timeout(
+	    &rtlpriv->firmware_load_complete, HZ)) {
+		pr_err("Wait_for_completion timed out\n");
+		complete(&rtlpriv->firmware_load_complete);
+		return 1;
+	}
+
+	if (rtlpriv->max_fw_size == 0 || !rtlhal->pfirmware)
 		return 1;
 
-	pr_info("Loading firmware file %s\n", rtlpriv->cfg->fw_name);
 	pfwheader = (struct rtl92c_firmware_header *)rtlhal->pfirmware;
 	pfwdata = (u8 *) rtlhal->pfirmware;
 	fwsize = rtlhal->fwsize;
Index: wireless-testing-new/drivers/net/wireless/rtlwifi/rtl8192ce/sw.c
===================================================================
--- wireless-testing-new.orig/drivers/net/wireless/rtlwifi/rtl8192ce/sw.c
+++ wireless-testing-new/drivers/net/wireless/rtlwifi/rtl8192ce/sw.c
@@ -91,9 +91,7 @@ int rtl92c_init_sw_vars(struct ieee80211
 	int err;
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 	struct rtl_pci *rtlpci = rtl_pcidev(rtl_pcipriv(hw));
-	const struct firmware *firmware;
 	struct rtl_hal *rtlhal = rtl_hal(rtl_priv(hw));
-	char *fw_name = NULL;
 
 	rtl8192ce_bt_reg_init(hw);
 
@@ -165,26 +163,20 @@ int rtl92c_init_sw_vars(struct ieee80211
 	/* request fw */
 	if (IS_VENDOR_UMC_A_CUT(rtlhal->version) &&
 	    !IS_92C_SERIAL(rtlhal->version))
-		fw_name = "rtlwifi/rtl8192cfwU.bin";
+		rtlpriv->cfg->fw_name = "rtlwifi/rtl8192cfwU.bin";
 	else if (IS_81xxC_VENDOR_UMC_B_CUT(rtlhal->version))
-		fw_name = "rtlwifi/rtl8192cfwU_B.bin";
-	else
-		fw_name = rtlpriv->cfg->fw_name;
-	err = request_firmware(&firmware, fw_name, rtlpriv->io.dev);
+		rtlpriv->cfg->fw_name = "rtlwifi/rtl8192cfwU_B.bin";
+
+	rtlpriv->max_fw_size = 0x4000;
+	pr_info("Using firmware %s\n", rtlpriv->cfg->fw_name);
+	err = request_firmware_nowait(THIS_MODULE, 1, rtlpriv->cfg->fw_name,
+				      rtlpriv->io.dev, GFP_KERNEL, hw,
+				      rtl_fw_cb);
 	if (err) {
 		RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,
 			 "Failed to request firmware!\n");
 		return 1;
 	}
-	if (firmware->size > 0x4000) {
-		RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,
-			 "Firmware is too big!\n");
-		release_firmware(firmware);
-		return 1;
-	}
-	memcpy(rtlpriv->rtlhal.pfirmware, firmware->data, firmware->size);
-	rtlpriv->rtlhal.fwsize = firmware->size;
-	release_firmware(firmware);
 
 	return 0;
 }
Index: wireless-testing-new/drivers/net/wireless/rtlwifi/wifi.h
===================================================================
--- wireless-testing-new.orig/drivers/net/wireless/rtlwifi/wifi.h
+++ wireless-testing-new/drivers/net/wireless/rtlwifi/wifi.h
@@ -37,6 +37,7 @@
 #include <linux/etherdevice.h>
 #include <linux/vmalloc.h>
 #include <linux/usb.h>
+#include <linux/completion.h>
 #include <net/mac80211.h>
 #include "debug.h"
 
@@ -1614,6 +1615,8 @@ struct rtl_priv {
 	struct rtl_rate_priv *rate_priv;
 
 	struct rtl_debug dbg;
+	struct completion firmware_load_complete;
+	int max_fw_size;
 
 	/*
 	 *hal_cfg : for diff cards
Index: wireless-testing-new/drivers/net/wireless/rtlwifi/core.c
===================================================================
--- wireless-testing-new.orig/drivers/net/wireless/rtlwifi/core.c
+++ wireless-testing-new/drivers/net/wireless/rtlwifi/core.c
@@ -33,6 +33,31 @@
 #include "base.h"
 #include "ps.h"
 
+#include <linux/export.h>
+
+void rtl_fw_cb(const struct firmware *firmware, void *context)
+{
+	struct ieee80211_hw *hw = context;
+	struct rtl_priv *rtlpriv = rtl_priv(hw);
+
+	complete(&rtlpriv->firmware_load_complete);
+	if (!firmware) {
+		pr_err("Firmware %s not available\n", rtlpriv->cfg->fw_name);
+		rtlpriv->max_fw_size = 0;
+		return;
+	}
+	if (firmware->size > rtlpriv->max_fw_size) {
+		RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,
+			 "Firmware is too big!\n");
+		release_firmware(firmware);
+		return;
+	}
+	memcpy(rtlpriv->rtlhal.pfirmware, firmware->data, firmware->size);
+	rtlpriv->rtlhal.fwsize = firmware->size;
+	release_firmware(firmware);
+}
+EXPORT_SYMBOL(rtl_fw_cb);
+
 /*mutex for start & stop is must here. */
 static int rtl_op_start(struct ieee80211_hw *hw)
 {
Index: wireless-testing-new/drivers/net/wireless/rtlwifi/core.h
===================================================================
--- wireless-testing-new.orig/drivers/net/wireless/rtlwifi/core.h
+++ wireless-testing-new/drivers/net/wireless/rtlwifi/core.h
@@ -40,4 +40,6 @@
 #define RTL_SUPPORTED_CTRL_FILTER	0xFF
 
 extern const struct ieee80211_ops rtl_ops;
+void rtl_fw_cb(const struct firmware *firmware, void *context);
+
 #endif
Index: wireless-testing-new/drivers/net/wireless/rtlwifi/rtl8192cu/sw.c
===================================================================
--- wireless-testing-new.orig/drivers/net/wireless/rtlwifi/rtl8192cu/sw.c
+++ wireless-testing-new/drivers/net/wireless/rtlwifi/rtl8192cu/sw.c
@@ -53,7 +53,6 @@ MODULE_FIRMWARE("rtlwifi/rtl8192cufw.bin
 static int rtl92cu_init_sw_vars(struct ieee80211_hw *hw)
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
-	const struct firmware *firmware;
 	int err;
 
 	rtlpriv->dm.dm_initialgain_enable = 1;
@@ -61,29 +60,21 @@ static int rtl92cu_init_sw_vars(struct i
 	rtlpriv->dm.disable_framebursting = 0;
 	rtlpriv->dm.thermalvalue = 0;
 	rtlpriv->dbg.global_debuglevel = rtlpriv->cfg->mod_params->debug;
-	rtlpriv->rtlhal.pfirmware = vmalloc(0x4000);
+
+	/* for firmware buf */
+	rtlpriv->rtlhal.pfirmware = vzalloc(0x4000);
 	if (!rtlpriv->rtlhal.pfirmware) {
 		RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,
 			 "Can't alloc buffer for fw\n");
 		return 1;
 	}
-	/* request fw */
-	err = request_firmware(&firmware, rtlpriv->cfg->fw_name,
-			rtlpriv->io.dev);
-	if (err) {
-		RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,
-			 "Failed to request firmware!\n");
-		return 1;
-	}
-	if (firmware->size > 0x4000) {
-		RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,
-			 "Firmware is too big!\n");
-		release_firmware(firmware);
-		return 1;
-	}
-	memcpy(rtlpriv->rtlhal.pfirmware, firmware->data, firmware->size);
-	rtlpriv->rtlhal.fwsize = firmware->size;
-	release_firmware(firmware);
+
+	pr_info("Loading firmware %s\n", rtlpriv->cfg->fw_name);
+	rtlpriv->max_fw_size = 0x4000;
+	err = request_firmware_nowait(THIS_MODULE, 1,
+				      rtlpriv->cfg->fw_name, rtlpriv->io.dev,
+				      GFP_KERNEL, hw, rtl_fw_cb);
+
 
 	return 0;
 }
Index: wireless-testing-new/drivers/net/wireless/rtlwifi/rtl8192se/sw.c
===================================================================
--- wireless-testing-new.orig/drivers/net/wireless/rtlwifi/rtl8192se/sw.c
+++ wireless-testing-new/drivers/net/wireless/rtlwifi/rtl8192se/sw.c
@@ -86,12 +86,34 @@ static void rtl92s_init_aspm_vars(struct
 	rtlpci->const_support_pciaspm = 2;
 }
 
+static void rtl92se_fw_cb(const struct firmware *firmware, void *context)
+{
+	struct ieee80211_hw *hw = context;
+	struct rtl_priv *rtlpriv = rtl_priv(hw);
+	struct rt_firmware *pfirmware = NULL;
+
+	complete(&rtlpriv->firmware_load_complete);
+	if (!firmware) {
+		pr_err("Firmware not available\n");
+		rtlpriv->max_fw_size = 0;
+		return;
+	}
+	if (firmware->size > rtlpriv->max_fw_size) {
+		RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,
+			 "Firmware is too big!\n");
+		release_firmware(firmware);
+		return;
+	}
+	pfirmware = (struct rt_firmware *)rtlpriv->rtlhal.pfirmware;
+	memcpy(pfirmware->sz_fw_tmpbuffer, firmware->data, firmware->size);
+	pfirmware->sz_fw_tmpbufferlen = firmware->size;
+	release_firmware(firmware);
+}
+
 static int rtl92s_init_sw_vars(struct ieee80211_hw *hw)
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 	struct rtl_pci *rtlpci = rtl_pcidev(rtl_pcipriv(hw));
-	const struct firmware *firmware;
-	struct rt_firmware *pfirmware = NULL;
 	int err = 0;
 	u16 earlyrxthreshold = 7;
 
@@ -189,27 +211,18 @@ static int rtl92s_init_sw_vars(struct ie
 		return 1;
 	}
 
+	rtlpriv->max_fw_size = sizeof(struct rt_firmware);
 	pr_info("Driver for Realtek RTL8192SE/RTL8191SE\n"
 		"Loading firmware %s\n", rtlpriv->cfg->fw_name);
 	/* request fw */
-	err = request_firmware(&firmware, rtlpriv->cfg->fw_name,
-			rtlpriv->io.dev);
+	err = request_firmware_nowait(THIS_MODULE, 1, rtlpriv->cfg->fw_name,
+				      rtlpriv->io.dev, GFP_KERNEL, hw,
+				      rtl92se_fw_cb);
 	if (err) {
 		RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,
 			 "Failed to request firmware!\n");
 		return 1;
 	}
-	if (firmware->size > sizeof(struct rt_firmware)) {
-		RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,
-			 "Firmware is too big!\n");
-		release_firmware(firmware);
-		return 1;
-	}
-
-	pfirmware = (struct rt_firmware *)rtlpriv->rtlhal.pfirmware;
-	memcpy(pfirmware->sz_fw_tmpbuffer, firmware->data, firmware->size);
-	pfirmware->sz_fw_tmpbufferlen = firmware->size;
-	release_firmware(firmware);
 
 	return err;
 }
Index: wireless-testing-new/drivers/net/wireless/rtlwifi/usb.c
===================================================================
--- wireless-testing-new.orig/drivers/net/wireless/rtlwifi/usb.c
+++ wireless-testing-new/drivers/net/wireless/rtlwifi/usb.c
@@ -664,15 +664,17 @@ static int rtl_usb_start(struct ieee8021
 	struct rtl_usb *rtlusb = rtl_usbdev(rtl_usbpriv(hw));
 
 	err = rtlpriv->cfg->ops->hw_init(hw);
-	rtl_init_rx_config(hw);
+	if (!err) {
+		rtl_init_rx_config(hw);
 
-	/* Enable software */
-	SET_USB_START(rtlusb);
-	/* should after adapter start and interrupt enable. */
-	set_hal_start(rtlhal);
+		/* Enable software */
+		SET_USB_START(rtlusb);
+		/* should after adapter start and interrupt enable. */
+		set_hal_start(rtlhal);
 
-	/* Start bulk IN */
-	_rtl_usb_receive(hw);
+		/* Start bulk IN */
+		_rtl_usb_receive(hw);
+	}
 
 	return err;
 }
@@ -949,6 +951,7 @@ int __devinit rtl_usb_probe(struct usb_i
 		return -ENOMEM;
 	}
 	rtlpriv = hw->priv;
+	init_completion(&rtlpriv->firmware_load_complete);
 	SET_IEEE80211_DEV(hw, &intf->dev);
 	udev = interface_to_usbdev(intf);
 	usb_get_dev(udev);
@@ -1013,6 +1016,9 @@ void rtl_usb_disconnect(struct usb_inter
 
 	if (unlikely(!rtlpriv))
 		return;
+	/* In case firmware load has not yet completed, force completion here */
+	complete(&rtlpriv->firmware_load_complete);
+
 	/*ieee80211_unregister_hw will call ops_stop */
 	if (rtlmac->mac80211_registered == 1) {
 		ieee80211_unregister_hw(hw);
Index: wireless-testing-new/drivers/net/wireless/rtlwifi/rtl8192de/sw.c
===================================================================
--- wireless-testing-new.orig/drivers/net/wireless/rtlwifi/rtl8192de/sw.c
+++ wireless-testing-new/drivers/net/wireless/rtlwifi/rtl8192de/sw.c
@@ -91,7 +91,6 @@ static int rtl92d_init_sw_vars(struct ie
 	u8 tid;
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 	struct rtl_pci *rtlpci = rtl_pcidev(rtl_pcipriv(hw));
-	const struct firmware *firmware;
 	static int header_print;
 
 	rtlpriv->dm.dm_initialgain_enable = true;
@@ -167,6 +166,15 @@ static int rtl92d_init_sw_vars(struct ie
 	else if (rtlpriv->psc.reg_fwctrl_lps == 3)
 		rtlpriv->psc.fwctrl_psmode = FW_PS_DTIM_MODE;
 
+	/* for early mode */
+	rtlpriv->rtlhal.earlymode_enable = true;
+	for (tid = 0; tid < 8; tid++)
+		skb_queue_head_init(&rtlpriv->mac80211.skb_waitq[tid]);
+
+	/* Only load firmware for first MAC */
+	if (header_print)
+		return 0;
+
 	/* for firmware buf */
 	rtlpriv->rtlhal.pfirmware = vzalloc(0x8000);
 	if (!rtlpriv->rtlhal.pfirmware) {
@@ -175,33 +183,21 @@ static int rtl92d_init_sw_vars(struct ie
 		return 1;
 	}
 
-	if (!header_print) {
-		pr_info("Driver for Realtek RTL8192DE WLAN interface\n");
-		pr_info("Loading firmware file %s\n", rtlpriv->cfg->fw_name);
-		header_print++;
-	}
+	rtlpriv->max_fw_size = 0x8000;
+	pr_info("Driver for Realtek RTL8192DE WLAN interface\n");
+	pr_info("Loading firmware file %s\n", rtlpriv->cfg->fw_name);
+	header_print++;
+
 	/* request fw */
-	err = request_firmware(&firmware, rtlpriv->cfg->fw_name,
-			       rtlpriv->io.dev);
+	err = request_firmware_nowait(THIS_MODULE, 1, rtlpriv->cfg->fw_name,
+				      rtlpriv->io.dev, GFP_KERNEL, hw,
+				      rtl_fw_cb);
 	if (err) {
 		RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,
 			 "Failed to request firmware!\n");
 		return 1;
 	}
-	if (firmware->size > 0x8000) {
-		RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,
-			 "Firmware is too big!\n");
-		release_firmware(firmware);
-		return 1;
-	}
-	memcpy(rtlpriv->rtlhal.pfirmware, firmware->data, firmware->size);
-	rtlpriv->rtlhal.fwsize = firmware->size;
-	release_firmware(firmware);
 
-	/* for early mode */
-	rtlpriv->rtlhal.earlymode_enable = true;
-	for (tid = 0; tid < 8; tid++)
-		skb_queue_head_init(&rtlpriv->mac80211.skb_waitq[tid]);
 	return 0;
 }
 
Index: wireless-testing-new/drivers/net/wireless/rtlwifi/rtl8192de/fw.c
===================================================================
--- wireless-testing-new.orig/drivers/net/wireless/rtlwifi/rtl8192de/fw.c
+++ wireless-testing-new/drivers/net/wireless/rtlwifi/rtl8192de/fw.c
@@ -253,7 +253,10 @@ int rtl92d_download_fw(struct ieee80211_
 	bool fw_downloaded = false, fwdl_in_process = false;
 	unsigned long flags;
 
-	if (!rtlhal->pfirmware)
+	/* hold at this point until firmware is available */
+	wait_for_completion_interruptible(&rtlpriv->firmware_load_complete);
+
+	if (rtlpriv->max_fw_size == 0 || !rtlhal->pfirmware)
 		return 1;
 	fwsize = rtlhal->fwsize;
 	pfwheader = (u8 *) rtlhal->pfirmware;
Index: wireless-testing-new/drivers/net/wireless/rtlwifi/rtl8192se/fw.c
===================================================================
--- wireless-testing-new.orig/drivers/net/wireless/rtlwifi/rtl8192se/fw.c
+++ wireless-testing-new/drivers/net/wireless/rtlwifi/rtl8192se/fw.c
@@ -364,7 +364,10 @@ int rtl92s_download_fw(struct ieee80211_
 	u8 fwstatus = FW_STATUS_INIT;
 	bool rtstatus = true;
 
-	if (!rtlhal->pfirmware)
+	/* hold at this point until firmware is available */
+	wait_for_completion_interruptible(&rtlpriv->firmware_load_complete);
+
+	if (rtlpriv->max_fw_size == 0 || !rtlhal->pfirmware)
 		return 1;
 
 	firmware = (struct rt_firmware *)rtlhal->pfirmware;
Index: wireless-testing-new/drivers/net/wireless/rtlwifi/ps.c
===================================================================
--- wireless-testing-new.orig/drivers/net/wireless/rtlwifi/ps.c
+++ wireless-testing-new/drivers/net/wireless/rtlwifi/ps.c
@@ -47,7 +47,8 @@ bool rtl_ps_enable_nic(struct ieee80211_
 			 "Driver is already down!\n");
 
 	/*<2> Enable Adapter */
-	rtlpriv->cfg->ops->hw_init(hw);
+	if (rtlpriv->cfg->ops->hw_init(hw))
+		return 1;
 	RT_CLEAR_PS_LEVEL(ppsc, RT_RF_OFF_LEVL_HALT_NIC);
 
 	/*<3> Enable Interrupt */
Index: wireless-testing-new/drivers/net/wireless/rtlwifi/rtl8192se/hw.c
===================================================================
--- wireless-testing-new.orig/drivers/net/wireless/rtlwifi/rtl8192se/hw.c
+++ wireless-testing-new/drivers/net/wireless/rtlwifi/rtl8192se/hw.c
@@ -949,8 +949,10 @@ int rtl92se_hw_init(struct ieee80211_hw
 	rtstatus = rtl92s_download_fw(hw);
 	if (!rtstatus) {
 		RT_TRACE(rtlpriv, COMP_ERR, DBG_WARNING,
-			 "Failed to download FW. Init HW without FW now... Please copy FW into /lib/firmware/rtlwifi\n");
+			 "Failed to download FW. Init HW without FW now... "
+			 "Please copy FW into /lib/firmware/rtlwifi\n");
 		rtlhal->fw_ready = false;
+		return 1;
 	} else {
 		rtlhal->fw_ready = true;
 	}
