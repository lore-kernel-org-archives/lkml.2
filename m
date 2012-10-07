Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755107Ab2JGXpn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Oct 2012 19:45:43 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:38207 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753003Ab2JGXWH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Oct 2012 19:22:07 -0400
Message-Id: <20121007225836.802125341@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 07 Oct 2012 23:58:49 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Anisse Astier <anisse@astier.eu>,
        Li Chaoming <chaoming_li@realsil.com.cn>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [ 015/108] rtlwifi: rtl8192ce: Log message that B_CUT device may not work
In-Reply-To: <20121007225834.673681075@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Larry Finger <Larry.Finger@lwfinger.net>

commit 022e1d0680c7b4366017393417b8758be5abcee8 upstream.

There are a number of problems that occur for the latest version
of the Realtek RTL8188CE device with the in-kernel driver. These
include selection of the wrong firmware, and system lockup. A full
fix is known, but is too invasive for inclusion in stable. This patch
fixes the problem with loading the wrong firmware, and logs a message
that the device may not work for kernels 3.6 and older.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Anisse Astier <anisse@astier.eu>
Cc: Li Chaoming <chaoming_li@realsil.com.cn>
Tested-by: Anisse Astier <anisse@astier.eu>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
[bwh: Backported to 3.2: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
--- a/drivers/net/wireless/rtlwifi/rtl8192ce/def.h
+++ b/drivers/net/wireless/rtlwifi/rtl8192ce/def.h
@@ -117,6 +117,7 @@
 
 #define CHIP_VER_B			BIT(4)
 #define CHIP_92C_BITMASK		BIT(0)
+#define CHIP_UNKNOWN			BIT(7)
 #define CHIP_92C_1T2R			0x03
 #define CHIP_92C			0x01
 #define CHIP_88C			0x00
--- a/drivers/net/wireless/rtlwifi/rtl8192ce/hw.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192ce/hw.c
@@ -1001,8 +1001,16 @@ static enum version_8192c _rtl92ce_read_
 		version = (value32 & TYPE_ID) ? VERSION_A_CHIP_92C :
 			   VERSION_A_CHIP_88C;
 	} else {
-		version = (value32 & TYPE_ID) ? VERSION_B_CHIP_92C :
-			   VERSION_B_CHIP_88C;
+		version = (enum version_8192c) (CHIP_VER_B |
+				((value32 & TYPE_ID) ? CHIP_92C_BITMASK : 0) |
+				((value32 & VENDOR_ID) ? CHIP_VENDOR_UMC : 0));
+		if ((!IS_CHIP_VENDOR_UMC(version)) && (value32 &
+		     CHIP_VER_RTL_MASK)) {
+			version = (enum version_8192c)(version |
+				   ((((value32 & CHIP_VER_RTL_MASK) == BIT(12))
+				   ? CHIP_VENDOR_UMC_B_CUT : CHIP_UNKNOWN) |
+				   CHIP_VENDOR_UMC));
+		}
 	}
 
 	switch (version) {
--- a/drivers/net/wireless/rtlwifi/rtl8192ce/sw.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192ce/sw.c
@@ -165,12 +165,14 @@ int rtl92c_init_sw_vars(struct ieee80211
 
 	/* request fw */
 	if (IS_VENDOR_UMC_A_CUT(rtlhal->version) &&
-	    !IS_92C_SERIAL(rtlhal->version))
+	    !IS_92C_SERIAL(rtlhal->version)) {
 		fw_name = "rtlwifi/rtl8192cfwU.bin";
-	else if (IS_81xxC_VENDOR_UMC_B_CUT(rtlhal->version))
+	} else if (IS_81xxC_VENDOR_UMC_B_CUT(rtlhal->version)) {
 		fw_name = "rtlwifi/rtl8192cfwU_B.bin";
-	else
+		pr_info("****** This B_CUT device may not work with kernels 3.6 and earlier\n");
+	} else {
 		fw_name = rtlpriv->cfg->fw_name;
+	}
 	err = request_firmware(&firmware, fw_name, rtlpriv->io.dev);
 	if (err) {
 		RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,


