Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965384Ab2I1Ve3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 17:34:29 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:55300 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031321Ab2I1U1Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 16:27:24 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Anisse Astier <anisse@astier.eu>,
        Li Chaoming <chaoming_li@realsil.com.cn>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [ 108/218] rtlwifi: rtl8192ce: Log message that B_CUT device may not work
Date: Fri, 28 Sep 2012 13:15:25 -0700
Message-Id: <20120928201513.986440637@linuxfoundation.org>
X-Mailer: git-send-email 1.7.12.1.428.g652398a
In-Reply-To: <20120928201501.208384923@linuxfoundation.org>
References: <20120928201501.208384923@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/rtlwifi/rtl8192ce/def.h |    1 +
 drivers/net/wireless/rtlwifi/rtl8192ce/hw.c  |   12 ++++++++++--
 drivers/net/wireless/rtlwifi/rtl8192ce/sw.c  |    6 ++++--
 3 files changed, 15 insertions(+), 4 deletions(-)

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
@@ -995,8 +995,16 @@ static enum version_8192c _rtl92ce_read_
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
@@ -162,10 +162,12 @@ int rtl92c_init_sw_vars(struct ieee80211
 
 	/* request fw */
 	if (IS_VENDOR_UMC_A_CUT(rtlhal->version) &&
-	    !IS_92C_SERIAL(rtlhal->version))
+	    !IS_92C_SERIAL(rtlhal->version)) {
 		rtlpriv->cfg->fw_name = "rtlwifi/rtl8192cfwU.bin";
-	else if (IS_81xxC_VENDOR_UMC_B_CUT(rtlhal->version))
+	} else if (IS_81xxC_VENDOR_UMC_B_CUT(rtlhal->version)) {
 		rtlpriv->cfg->fw_name = "rtlwifi/rtl8192cfwU_B.bin";
+		pr_info("****** This B_CUT device may not work with kernels 3.6 and earlier\n");
+	}
 
 	rtlpriv->max_fw_size = 0x4000;
 	pr_info("Using firmware %s\n", rtlpriv->cfg->fw_name);


