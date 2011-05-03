Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753613Ab1ECOtj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 May 2011 10:49:39 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:53630 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753579Ab1ECOth (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 May 2011 10:49:37 -0400
X-Authority-Analysis: v=1.1 cv=pN6kzQkhXdmdOr6Akjoh3kGBD/S3UyPMKQp53EJY+ro= c=1 sm=0 a=3rvgeqzMqd0A:10 a=eXGYNRjPe1QA:10 a=Zx2FLkwYMp0A:10 a=kj9zAlcOel0A:10 a=mpMdnlmFKti1S5SNY1DT+A==:17 a=YYF7fsvRAAAA:8 a=yQdBAQUQAAAA:8 a=uCfhBVIf-awPjyu60ncA:9 a=eLKnsY0-i8td3frODvAA:7 a=CjuIK1q_8ugA:10 a=IcxpeKGZWnEA:10 a=mpMdnlmFKti1S5SNY1DT+A==:117
X-Cloudmark-Score: 0
X-Originating-IP: 65.28.92.85
Date: Tue, 03 May 2011 09:49:36 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
To: John W Linville <linville@tuxdriver.com>
Cc: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        chaoming_li@realsil.com.cn
Subject: [PATCH 12/12] rtlwifi: rtl8192se: Modify Kconfig and Makefile
 routines for new driver
Message-ID: <4dc01600.O4h1dvzo0KYqHbol%Larry.Finger@lwfinger.net>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Chaoming Li <chaoming_li@realsil.com.cn>

Modify rtlwifi routines for rtl8192se and set up Kconfig
and Makefile for new driver.

This patch also disables ASPM for the RTL8192SE to prevent some strange
crashes on LF's system.

Signed-off-by: Chaoming_Li <chaoming_li@realsil.com.cn>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---

Index: wireless-testing/drivers/net/wireless/rtlwifi/Kconfig
===================================================================
--- wireless-testing.orig/drivers/net/wireless/rtlwifi/Kconfig
+++ wireless-testing/drivers/net/wireless/rtlwifi/Kconfig
@@ -10,6 +10,17 @@ config RTL8192CE
 
 	If you choose to build it as a module, it will be called rtl8192ce
 
+config RTL8192SE
+	tristate "Realtek RTL8192SE/RTL8191SE PCIe Wireless Network Adapter"
+	depends on MAC80211 && EXPERIMENTAL
+	select FW_LOADER
+	select RTLWIFI
+	---help---
+	This is the driver for Realtek RTL8192SE/RTL8191SE 802.11n PCIe
+	wireless network adapters.
+
+	If you choose to build it as a module, it will be called rtl8192se
+
 config RTL8192CU
 	tristate "Realtek RTL8192CU/RTL8188CU USB Wireless Network Adapter"
 	depends on MAC80211 && USB && EXPERIMENTAL
@@ -24,10 +35,10 @@ config RTL8192CU
 
 config RTLWIFI
 	tristate
-	depends on RTL8192CE || RTL8192CU
+	depends on RTL8192CE || RTL8192CU || RTL8192SE
 	default m
 
 config RTL8192C_COMMON
 	tristate
-	depends on RTL8192CE || RTL8192CU
+	depends on RTL8192CE || RTL8192CU || RTL8192SE
 	default m
Index: wireless-testing/drivers/net/wireless/rtlwifi/Makefile
===================================================================
--- wireless-testing.orig/drivers/net/wireless/rtlwifi/Makefile
+++ wireless-testing/drivers/net/wireless/rtlwifi/Makefile
@@ -22,5 +22,6 @@ endif
 obj-$(CONFIG_RTL8192C_COMMON)	+= rtl8192c/
 obj-$(CONFIG_RTL8192CE)		+= rtl8192ce/
 obj-$(CONFIG_RTL8192CU)		+= rtl8192cu/
+obj-$(CONFIG_RTL8192SE)		+= rtl8192se/
 
 ccflags-y += -D__CHECK_ENDIAN__
Index: wireless-testing/drivers/net/wireless/rtlwifi/rtl8192se/Makefile
===================================================================
--- /dev/null
+++ wireless-testing/drivers/net/wireless/rtlwifi/rtl8192se/Makefile
@@ -0,0 +1,15 @@
+rtl8192se-objs :=		\
+		dm.o		\
+		fw.o		\
+		hw.o		\
+		led.o		\
+		phy.o		\
+		rf.o		\
+		sw.o		\
+		table.o		\
+		trx.o
+
+obj-$(CONFIG_RTL8192SE) += rtl8192se.o
+
+ccflags-y += -D__CHECK_ENDIAN__
+
Index: wireless-testing/drivers/net/wireless/rtlwifi/rtl8192se/sw.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/rtlwifi/rtl8192se/sw.c
+++ wireless-testing/drivers/net/wireless/rtlwifi/rtl8192se/sw.c
@@ -58,7 +58,7 @@ static void rtl92s_init_aspm_vars(struct
 	 * 4 - Always Enable ASPM without Clock Req.
 	 * set defult to RTL8192CE:3 RTL8192E:2
 	 * */
-	rtlpci->const_pci_aspm = 2;
+	rtlpci->const_pci_aspm = 0; /* changed from 2 due to crashes */
 
 	/*Setting for PCI-E device */
 	rtlpci->const_devicepci_aspm_setting = 0x03;
