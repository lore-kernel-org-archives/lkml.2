Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758136Ab1JFChd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Oct 2011 22:37:33 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:46890 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754174Ab1JFChb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Oct 2011 22:37:31 -0400
Message-ID: <4E8D1465.207@lwfinger.net>
Date: Wed, 05 Oct 2011 21:37:25 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110929 Thunderbird/7.0.1
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>
CC: =?UTF-8?B?5p2O5pyd5piO?= <chaoming_li@realsil.com.cn>,
        linux-wireless@vger.kernel.org,
        "'LKML'" <linux-kernel@vger.kernel.org>
Subject: Re: =?UTF-8?B?562U5aSNOiDnrZTlpI06IOetlOWkjTogMy4xLXJjNisgcnRsODE=?=
 =?UTF-8?B?OTJzZSBpc3N1ZQ==?=
References: <CD4D8CF16C39438E82FE8241C9AF80F4@realsil.com.cn> <20110921185816.GA2036@gere.osrc.amd.com> <791179BCE62F4954AB936E6CAC9CA977@realsil.com.cn> <4E7AAB8B.40900@lwfinger.net> <20110922075115.GA17640@liondog.tnic> <6452E68488784D0EA32E4BDF1B941EFB@realsil.com.cn> <20110923103339.GA26078@gere.osrc.amd.com> <4E7CB504.4060904@lwfinger.net> <20110928131823.GA2693@gere.osrc.amd.com> <4E83D092.7010405@lwfinger.net> <20111005151533.GA18592@gere.osrc.amd.com>
In-Reply-To: <20111005151533.GA18592@gere.osrc.amd.com>
Content-Type: multipart/mixed;
 boundary="------------080708050201040904080201"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------080708050201040904080201
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/05/2011 10:15 AM, Borislav Petkov wrote:

> Ok, I can cautiosly say now that after a couple days of running the
> Realtek version that the box runs just fine, no hiccups whatsoever.
>
> Larry, you said in an earlier mail that you've gone through the
> rtl8192se changes and weren't optimistic with the attached diff you sent
> me. What about the rtlwifi changes, is there something in Realtek's
> version which is missing upstream that would cause the sluggishness?

I have been going though the differences between the 06/20/2011 and 08/16/2011 
drivers and making those changes to the kernel drivers. Could you please apply 
the 5 attached patches to the wireless-testing tree and see if your sluggishness 
is fixed?

Thanks,

Larry


--------------080708050201040904080201
Content-Type: text/x-patch;
 name="0001-rtlwifi-Change-PCI-drivers-to-use-the-new-PM-framewo.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="0001-rtlwifi-Change-PCI-drivers-to-use-the-new-PM-framewo.pa";
 filename*1="tch"

>From 7888163e5f25feb9825349e346759f7c884dd074 Mon Sep 17 00:00:00 2001
From: Larry Finger <Larry.Finger@lwfinger.net>
Date: Wed, 5 Oct 2011 10:50:24 -0500
Subject: [PATCH 1/5] rtlwifi: Change PCI drivers to use the new PM framework
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---
 drivers/net/wireless/rtlwifi/pci.c          |   19 ++++---------------
 drivers/net/wireless/rtlwifi/pci.h          |    4 ++--
 drivers/net/wireless/rtlwifi/rtl8192ce/sw.c |   16 ++++++++++------
 drivers/net/wireless/rtlwifi/rtl8192de/sw.c |   16 ++++++++++------
 drivers/net/wireless/rtlwifi/rtl8192se/sw.c |   16 ++++++++++------
 5 files changed, 36 insertions(+), 35 deletions(-)

diff --git a/drivers/net/wireless/rtlwifi/pci.c b/drivers/net/wireless/rtlwifi/pci.c
index 9983fa1..5380f3b 100644
--- a/drivers/net/wireless/rtlwifi/pci.c
+++ b/drivers/net/wireless/rtlwifi/pci.c
@@ -1993,36 +1993,25 @@ call rtl_mac_stop() from the mac80211
 suspend function first, So there is
 no need to call hw_disable here.
 ****************************************/
-int rtl_pci_suspend(struct pci_dev *pdev, pm_message_t state)
+int rtl_pci_suspend(struct device *dev)
 {
+	struct pci_dev *pdev = to_pci_dev(dev);
 	struct ieee80211_hw *hw = pci_get_drvdata(pdev);
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 
 	rtlpriv->cfg->ops->hw_suspend(hw);
 	rtl_deinit_rfkill(hw);
 
-	pci_save_state(pdev);
-	pci_disable_device(pdev);
-	pci_set_power_state(pdev, PCI_D3hot);
 	return 0;
 }
 EXPORT_SYMBOL(rtl_pci_suspend);
 
-int rtl_pci_resume(struct pci_dev *pdev)
+int rtl_pci_resume(struct device *dev)
 {
-	int ret;
+	struct pci_dev *pdev = to_pci_dev(dev);
 	struct ieee80211_hw *hw = pci_get_drvdata(pdev);
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 
-	pci_set_power_state(pdev, PCI_D0);
-	ret = pci_enable_device(pdev);
-	if (ret) {
-		RT_ASSERT(false, ("ERR: <======\n"));
-		return ret;
-	}
-
-	pci_restore_state(pdev);
-
 	rtlpriv->cfg->ops->hw_resume(hw);
 	rtl_init_rfkill(hw);
 	return 0;
diff --git a/drivers/net/wireless/rtlwifi/pci.h b/drivers/net/wireless/rtlwifi/pci.h
index a24e505..ebe0b42 100644
--- a/drivers/net/wireless/rtlwifi/pci.h
+++ b/drivers/net/wireless/rtlwifi/pci.h
@@ -237,8 +237,8 @@ extern struct rtl_intf_ops rtl_pci_ops;
 int __devinit rtl_pci_probe(struct pci_dev *pdev,
 			    const struct pci_device_id *id);
 void rtl_pci_disconnect(struct pci_dev *pdev);
-int rtl_pci_suspend(struct pci_dev *pdev, pm_message_t state);
-int rtl_pci_resume(struct pci_dev *pdev);
+int rtl_pci_suspend(struct device *dev);
+int rtl_pci_resume(struct device *dev);
 
 static inline u8 pci_read8_sync(struct rtl_priv *rtlpriv, u32 addr)
 {
diff --git a/drivers/net/wireless/rtlwifi/rtl8192ce/sw.c b/drivers/net/wireless/rtlwifi/rtl8192ce/sw.c
index b7ecb9e..07a75d3 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192ce/sw.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192ce/sw.c
@@ -365,17 +365,21 @@ MODULE_PARM_DESC(ips, "Set to 0 to not use link power save (default 1)\n");
 MODULE_PARM_DESC(swlps, "Set to 1 to use SW control power save (default 0)\n");
 MODULE_PARM_DESC(fwlps, "Set to 1 to use FW control power save (default 1)\n");
 
+static const struct dev_pm_ops rtlwifi_pm_ops = {
+	.suspend = rtl_pci_suspend,
+	.resume = rtl_pci_resume,
+	.freeze = rtl_pci_suspend,
+	.thaw = rtl_pci_resume,
+	.poweroff = rtl_pci_suspend,
+	.restore = rtl_pci_resume,
+};
+
 static struct pci_driver rtl92ce_driver = {
 	.name = KBUILD_MODNAME,
 	.id_table = rtl92ce_pci_ids,
 	.probe = rtl_pci_probe,
 	.remove = rtl_pci_disconnect,
-
-#ifdef CONFIG_PM
-	.suspend = rtl_pci_suspend,
-	.resume = rtl_pci_resume,
-#endif
-
+	.driver.pm = &rtlwifi_pm_ops,
 };
 
 static int __init rtl92ce_module_init(void)
diff --git a/drivers/net/wireless/rtlwifi/rtl8192de/sw.c b/drivers/net/wireless/rtlwifi/rtl8192de/sw.c
index c681597..12042d8 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192de/sw.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192de/sw.c
@@ -385,17 +385,21 @@ MODULE_PARM_DESC(ips, "Set to 0 to not use link power save (default 1)\n");
 MODULE_PARM_DESC(swlps, "Set to 1 to use SW control power save (default 0)\n");
 MODULE_PARM_DESC(fwlps, "Set to 1 to use FW control power save (default 1)\n");
 
+static const struct dev_pm_ops rtlwifi_pm_ops = {
+	.suspend = rtl_pci_suspend,
+	.resume = rtl_pci_resume,
+	.freeze = rtl_pci_suspend,
+	.thaw = rtl_pci_resume,
+	.poweroff = rtl_pci_suspend,
+	.restore = rtl_pci_resume,
+};
+
 static struct pci_driver rtl92de_driver = {
 	.name = KBUILD_MODNAME,
 	.id_table = rtl92de_pci_ids,
 	.probe = rtl_pci_probe,
 	.remove = rtl_pci_disconnect,
-
-#ifdef CONFIG_PM
-	.suspend = rtl_pci_suspend,
-	.resume = rtl_pci_resume,
-#endif
-
+	.driver.pm = &rtlwifi_pm_ops,
 };
 
 /* add global spin lock to solve the problem that
diff --git a/drivers/net/wireless/rtlwifi/rtl8192se/sw.c b/drivers/net/wireless/rtlwifi/rtl8192se/sw.c
index 24bd331..80facb5 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192se/sw.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192se/sw.c
@@ -396,17 +396,21 @@ MODULE_PARM_DESC(ips, "Set to 0 to not use link power save (default 1)\n");
 MODULE_PARM_DESC(swlps, "Set to 1 to use SW control power save (default 0)\n");
 MODULE_PARM_DESC(fwlps, "Set to 1 to use FW control power save (default 1)\n");
 
+static const struct dev_pm_ops rtlwifi_pm_ops = {
+	.suspend = rtl_pci_suspend,
+	.resume = rtl_pci_resume,
+	.freeze = rtl_pci_suspend,
+	.thaw = rtl_pci_resume,
+	.poweroff = rtl_pci_suspend,
+	.restore = rtl_pci_resume,
+};
+
 static struct pci_driver rtl92se_driver = {
 	.name = KBUILD_MODNAME,
 	.id_table = rtl92se_pci_ids,
 	.probe = rtl_pci_probe,
 	.remove = rtl_pci_disconnect,
-
-#ifdef CONFIG_PM
-	.suspend = rtl_pci_suspend,
-	.resume = rtl_pci_resume,
-#endif
-
+	.driver.pm = &rtlwifi_pm_ops,
 };
 
 static int __init rtl92se_module_init(void)
-- 
1.7.6.4


--------------080708050201040904080201
Content-Type: text/x-patch;
 name="0002-rtlwifi-Update-to-new-Realtek-version-Part-I.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="0002-rtlwifi-Update-to-new-Realtek-version-Part-I.patch"

>From 18157ae7138110bf72540fac4c1fa16e09c81774 Mon Sep 17 00:00:00 2001
From: Chaoming Li <chaoming_li@realsil.com.cn>
Date: Wed, 5 Oct 2011 10:54:06 -0500
Subject: [PATCH 2/5] rtlwifi: Update to new Realtek version - Part I
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org

This patch incorporate the differences between the 06/20/2011 and
08/16/2011 Realtek releases of the rtlwifi driver.

The changes include:

1. Handling of IEEE80211_HW_CONNECTION_MONITOR.
2. Fix typo to get proper response to nullfunc frames.

Signed-off-by: Chaoming Li <chaoming_li@realsil.com.cn>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---
 drivers/net/wireless/rtlwifi/base.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/rtlwifi/base.c b/drivers/net/wireless/rtlwifi/base.c
index eafe980..a2704fb 100644
--- a/drivers/net/wireless/rtlwifi/base.c
+++ b/drivers/net/wireless/rtlwifi/base.c
@@ -311,6 +311,8 @@ static void _rtl_init_mac80211(struct ieee80211_hw *hw)
 	    IEEE80211_HW_RX_INCLUDES_FCS |
 	    IEEE80211_HW_BEACON_FILTER |
 	    IEEE80211_HW_AMPDU_AGGREGATION |
+	    IEEE80211_HW_CONNECTION_MONITOR |
+	    /* IEEE80211_HW_SUPPORTS_CQM_RSSI | */
 	    IEEE80211_HW_REPORTS_TX_ACK_STATUS | 0;
 
 	/* swlps or hwlps has been set in diff chip in init_sw_vars */
@@ -850,7 +852,7 @@ void rtl_get_tcb_desc(struct ieee80211_hw *hw,
 		 *So tcb_desc->hw_rate is just used for
 		 *special data and mgt frames
 		 */
-		if (info->control.rates[0].idx == 0 &&
+		if (info->control.rates[0].idx == 0 ||
 				ieee80211_is_nullfunc(fc)) {
 			tcb_desc->use_driver_rate = true;
 			tcb_desc->ratr_index = RATR_INX_WIRELESS_MC;
@@ -1138,7 +1140,7 @@ void rtl_watchdog_wq_callback(void *data)
 	}
 
 	/*
-	 *<3> to check if traffic busy, if
+	 *<2> to check if traffic busy, if
 	 * busytraffic we don't change channel
 	 */
 	if (mac->link_state >= MAC80211_LINKED) {
-- 
1.7.6.4


--------------080708050201040904080201
Content-Type: text/x-patch;
 name="0003-rtlwifi-rtl8192ce-Add-new-chip-revisions.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="0003-rtlwifi-rtl8192ce-Add-new-chip-revisions.patch"

>From a3c6b35d2d81c99707b1c36fc3b4d84eb461ff7f Mon Sep 17 00:00:00 2001
From: Larry Finger <Larry.Finger@lwfinger.net>
Date: Wed, 5 Oct 2011 11:05:36 -0500
Subject: [PATCH 3/5] rtlwifi: rtl8192ce: Add new chip revisions
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org

From: Chaoming Li <chaoming_li@realsil.com.cn>

This patch incorporate the differences between the 06/20/2011 and
08/16/2011 Realtek releases of the rtlwifi driver.

The changes include:

1. Adding new chip revisions including new firmware.

Signed-off-by: Chaoming Li <chaoming_li@realsil.com.cn>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---
 drivers/net/wireless/rtlwifi/rtl8192ce/def.h |   14 ++++++++++++++
 drivers/net/wireless/rtlwifi/rtl8192ce/sw.c  |   14 ++++++++++++--
 drivers/net/wireless/rtlwifi/rtl8192cu/def.h |    4 ----
 3 files changed, 26 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/rtlwifi/rtl8192ce/def.h b/drivers/net/wireless/rtlwifi/rtl8192ce/def.h
index 11f4319..a816459 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192ce/def.h
+++ b/drivers/net/wireless/rtlwifi/rtl8192ce/def.h
@@ -142,8 +142,22 @@ enum version_8192c {
 	VERSION_UNKNOWN = 0x88,
 };
 
+#define CUT_VERSION_MASK		(BIT(6)|BIT(7))
+#define CHIP_VENDOR_UMC			BIT(5)
+#define CHIP_VENDOR_UMC_B_CUT		BIT(6) /* Chip version for ECO */
+#define IS_VENDOR_UMC_A_CUT(version)	((IS_CHIP_VENDOR_UMC(version)) ? \
+	((GET_CVID_CUT_VERSION(version)) ? false : true) : false)
 #define IS_CHIP_VER_B(version)  ((version & CHIP_VER_B) ? true : false)
+#define IS_VENDOR_UMC_A_CUT(version)	((IS_CHIP_VENDOR_UMC(version)) ? \
+	((GET_CVID_CUT_VERSION(version)) ? false : true) : false)
 #define IS_92C_SERIAL(version)  ((version & CHIP_92C_BITMASK) ? true : false)
+#define IS_CHIP_VENDOR_UMC(version)		\
+	((version & CHIP_VENDOR_UMC) ? true : false)
+#define GET_CVID_CUT_VERSION(version)	((version) & CUT_VERSION_MASK)
+#define IS_81xxC_VENDOR_UMC_B_CUT(version)		\
+	((IS_CHIP_VENDOR_UMC(version)) ? \
+	((GET_CVID_CUT_VERSION(version) == CHIP_VENDOR_UMC_B_CUT) ?	\
+	true : false) : false)
 
 enum rtl819x_loopback_e {
 	RTL819X_NO_LOOPBACK = 0,
diff --git a/drivers/net/wireless/rtlwifi/rtl8192ce/sw.c b/drivers/net/wireless/rtlwifi/rtl8192ce/sw.c
index 07a75d3..f515bf7 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192ce/sw.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192ce/sw.c
@@ -92,6 +92,8 @@ int rtl92c_init_sw_vars(struct ieee80211_hw *hw)
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 	struct rtl_pci *rtlpci = rtl_pcidev(rtl_pcipriv(hw));
 	const struct firmware *firmware;
+	struct rtl_hal *rtlhal = rtl_hal(rtl_priv(hw));
+	char *fw_name = NULL;
 
 	rtl8192ce_bt_reg_init(hw);
 
@@ -159,8 +161,14 @@ int rtl92c_init_sw_vars(struct ieee80211_hw *hw)
 	}
 
 	/* request fw */
-	err = request_firmware(&firmware, rtlpriv->cfg->fw_name,
-			rtlpriv->io.dev);
+	if (IS_VENDOR_UMC_A_CUT(rtlhal->version) &&
+	    !IS_92C_SERIAL(rtlhal->version))
+		fw_name = "rtlwifi/rtl8192cfwU.bin";
+	else if (IS_81xxC_VENDOR_UMC_B_CUT(rtlhal->version))
+		fw_name = "rtlwifi/rtl8192cfwU_B.bin";
+	else
+		fw_name = rtlpriv->cfg->fw_name;
+	err = request_firmware(&firmware, fw_name, rtlpriv->io.dev);
 	if (err) {
 		RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,
 			 ("Failed to request firmware!\n"));
@@ -355,6 +363,8 @@ MODULE_AUTHOR("Larry Finger	<Larry.Finger@lwfinger.net>");
 MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("Realtek 8192C/8188C 802.11n PCI wireless");
 MODULE_FIRMWARE("rtlwifi/rtl8192cfw.bin");
+MODULE_FIRMWARE("rtlwifi/rtl8192cfwU.bin");
+MODULE_FIRMWARE("rtlwifi/rtl8192cfwU_B.bin");
 
 module_param_named(swenc, rtl92ce_mod_params.sw_crypto, bool, 0444);
 module_param_named(ips, rtl92ce_mod_params.inactiveps, bool, 0444);
diff --git a/drivers/net/wireless/rtlwifi/rtl8192cu/def.h b/drivers/net/wireless/rtlwifi/rtl8192cu/def.h
index c54940e..d097efb 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192cu/def.h
+++ b/drivers/net/wireless/rtlwifi/rtl8192cu/def.h
@@ -50,10 +50,6 @@
 #define IS_VENDOR_UMC(version)		\
 	(((version) & CHIP_VENDOR_UMC) ? true : false)
 
-#define IS_VENDOR_UMC_A_CUT(version)	\
-	(((version) & CHIP_VENDOR_UMC) ? (((version) & (BIT(6) | BIT(7))) ? \
-	false : true) : false)
-
 #define IS_VENDOR_8723_A_CUT(version)	\
 	(((version) & CHIP_VENDOR_UMC) ? (((version) & (BIT(6))) ? \
 	false : true) : false)
-- 
1.7.6.4


--------------080708050201040904080201
Content-Type: text/x-patch;
 name="0004-rtlwifi-rtl8192se-Updates-from-latest-Realtek-driver.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="0004-rtlwifi-rtl8192se-Updates-from-latest-Realtek-driver.pa";
 filename*1="tch"

>From 958afb7351d9ff1b48b4f53796db1abd78b4b350 Mon Sep 17 00:00:00 2001
From: Larry Finger <Larry.Finger@lwfinger.net>
Date: Wed, 5 Oct 2011 11:11:04 -0500
Subject: [PATCH 4/5] rtlwifi: rtl8192se: Updates from latest Realtek driver
 version - Part II
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org

From: Chaoming Li <chaoming_li@realsil.com.cn>

This patch incorporate the differences between the 06/20/2011 and
08/16/2011 Realtek releases of the rtl8192se driver.

The changes include:

1. Fixing some typos in register usage.
2. A change in the handling of decryption status for 802.11w packets.

Signed-off-by: Chaoming Li <chaoming_li@realsil.com.cn>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---
 drivers/net/wireless/rtlwifi/rtl8192se/hw.c  |   22 +++++-----
 drivers/net/wireless/rtlwifi/rtl8192se/reg.h |    1 +
 drivers/net/wireless/rtlwifi/rtl8192se/sw.c  |    1 +
 drivers/net/wireless/rtlwifi/rtl8192se/trx.c |   53 +++++++++++++++----------
 drivers/net/wireless/rtlwifi/wifi.h          |    1 +
 5 files changed, 46 insertions(+), 32 deletions(-)

Index: wireless-testing-new/drivers/net/wireless/rtlwifi/rtl8192se/hw.c
===================================================================
--- wireless-testing-new.orig/drivers/net/wireless/rtlwifi/rtl8192se/hw.c
+++ wireless-testing-new/drivers/net/wireless/rtlwifi/rtl8192se/hw.c
@@ -1382,7 +1382,7 @@ static void _rtl92se_power_domain_init(s
 	rtl_write_byte(rtlpriv, LDOA15_CTRL, 0x34);
 
 	/* Reset MAC-IO and CPU and Core Digital BIT10/11/15 */
-	tmpu1b = rtl_read_byte(rtlpriv, SYS_FUNC_EN + 1);
+	tmpu1b = rtl_read_byte(rtlpriv, REG_SYS_FUNC_EN + 1);
 
 	/* If IPS we need to turn LED on. So we not
 	 * not disable BIT 3/7 of reg3. */
@@ -1391,7 +1391,7 @@ static void _rtl92se_power_domain_init(s
 	else
 		tmpu1b &= 0x73;
 
-	rtl_write_byte(rtlpriv, SYS_FUNC_EN + 1, tmpu1b);
+	rtl_write_byte(rtlpriv, REG_SYS_FUNC_EN + 1, tmpu1b);
 	/* wait for BIT 10/11/15 to pull high automatically!! */
 	mdelay(1);
 
@@ -1428,15 +1428,15 @@ static void _rtl92se_power_domain_init(s
 	rtl_write_byte(rtlpriv, LDOA15_CTRL, (tmpu1b | BIT(0)));
 
 	/* Set Digital Vdd to Retention isolation Path. */
-	tmpu2b = rtl_read_word(rtlpriv, SYS_ISO_CTRL);
-	rtl_write_word(rtlpriv, SYS_ISO_CTRL, (tmpu2b | BIT(11)));
+	tmpu2b = rtl_read_word(rtlpriv, REG_SYS_ISO_CTRL);
+	rtl_write_word(rtlpriv, REG_SYS_ISO_CTRL, (tmpu2b | BIT(11)));
 
 
 	/* For warm reboot NIC disappera bug. */
-	tmpu2b = rtl_read_word(rtlpriv, SYS_FUNC_EN);
-	rtl_write_word(rtlpriv, SYS_FUNC_EN, (tmpu2b | BIT(13)));
+	tmpu2b = rtl_read_word(rtlpriv, REG_SYS_FUNC_EN);
+	rtl_write_word(rtlpriv, REG_SYS_FUNC_EN, (tmpu2b | BIT(13)));
 
-	rtl_write_byte(rtlpriv, SYS_ISO_CTRL + 1, 0x68);
+	rtl_write_byte(rtlpriv, REG_SYS_ISO_CTRL + 1, 0x68);
 
 	/* Enable AFE PLL Macro Block */
 	tmpu1b = rtl_read_byte(rtlpriv, AFE_PLL_CTRL);
@@ -1447,17 +1447,17 @@ static void _rtl92se_power_domain_init(s
 	mdelay(1);
 
 	/* Release isolation AFE PLL & MD */
-	rtl_write_byte(rtlpriv, SYS_ISO_CTRL, 0xA6);
+	rtl_write_byte(rtlpriv, REG_SYS_ISO_CTRL, 0xA6);
 
 	/* Enable MAC clock */
 	tmpu2b = rtl_read_word(rtlpriv, SYS_CLKR);
 	rtl_write_word(rtlpriv, SYS_CLKR, (tmpu2b | BIT(12) | BIT(11)));
 
 	/* Enable Core digital and enable IOREG R/W */
-	tmpu2b = rtl_read_word(rtlpriv, SYS_FUNC_EN);
-	rtl_write_word(rtlpriv, SYS_FUNC_EN, (tmpu2b | BIT(11)));
+	tmpu2b = rtl_read_word(rtlpriv, REG_SYS_FUNC_EN);
+	rtl_write_word(rtlpriv, REG_SYS_FUNC_EN, (tmpu2b | BIT(11)));
 	/* enable REG_EN */
-	rtl_write_word(rtlpriv, SYS_FUNC_EN, (tmpu2b | BIT(11) | BIT(15)));
+	rtl_write_word(rtlpriv, REG_SYS_FUNC_EN, (tmpu2b | BIT(11) | BIT(15)));
 
 	/* Switch the control path. */
 	tmpu2b = rtl_read_word(rtlpriv, SYS_CLKR);
Index: wireless-testing-new/drivers/net/wireless/rtlwifi/rtl8192se/reg.h
===================================================================
--- wireless-testing-new.orig/drivers/net/wireless/rtlwifi/rtl8192se/reg.h
+++ wireless-testing-new/drivers/net/wireless/rtlwifi/rtl8192se/reg.h
@@ -735,6 +735,7 @@
 #define	HWSET_MAX_SIZE_92S			128
 #define EFUSE_MAX_SECTION			16
 #define EFUSE_REAL_CONTENT_LEN			512
+#define EFUSE_OOB_PROTECT_BYTES			15
 
 #define RTL8190_EEPROM_ID			0x8129
 #define EEPROM_HPON				0x02
Index: wireless-testing-new/drivers/net/wireless/rtlwifi/rtl8192se/sw.c
===================================================================
--- wireless-testing-new.orig/drivers/net/wireless/rtlwifi/rtl8192se/sw.c
+++ wireless-testing-new/drivers/net/wireless/rtlwifi/rtl8192se/sw.c
@@ -304,6 +304,7 @@ static struct rtl_hal_cfg rtl92se_hal_cf
 	.maps[EFUSE_HWSET_MAX_SIZE] = HWSET_MAX_SIZE_92S,
 	.maps[EFUSE_MAX_SECTION_MAP] = EFUSE_MAX_SECTION,
 	.maps[EFUSE_REAL_CONTENT_SIZE] = EFUSE_REAL_CONTENT_LEN,
+	.maps[EFUSE_OOB_PROTECT_BYTES_LEN] = EFUSE_OOB_PROTECT_BYTES,
 
 	.maps[RWCAM] = REG_RWCAM,
 	.maps[WCAMI] = REG_WCAMI,
Index: wireless-testing-new/drivers/net/wireless/rtlwifi/rtl8192se/trx.c
===================================================================
--- wireless-testing-new.orig/drivers/net/wireless/rtlwifi/rtl8192se/trx.c
+++ wireless-testing-new/drivers/net/wireless/rtlwifi/rtl8192se/trx.c
@@ -124,18 +124,15 @@ static void _rtl92se_query_rxphystatus(s
 	u8 i, max_spatial_stream;
 	u32 rssi, total_rssi = 0;
 	bool in_powersavemode = false;
-	bool is_cck_rate;
+	bool is_cck = pstats->is_cck;
 
-	is_cck_rate = SE_RX_HAL_IS_CCK_RATE(pdesc);
 	pstats->packet_matchbssid = packet_match_bssid;
 	pstats->packet_toself = packet_toself;
-	pstats->is_cck = is_cck_rate;
 	pstats->packet_beacon = packet_beacon;
-	pstats->is_cck = is_cck_rate;
 	pstats->rx_mimo_signalquality[0] = -1;
 	pstats->rx_mimo_signalquality[1] = -1;
 
-	if (is_cck_rate) {
+	if (is_cck) {
 		u8 report, cck_highpwr;
 		cck_buf = (struct phy_sts_cck_8192s_t *)p_drvinfo;
 
@@ -246,9 +243,8 @@ static void _rtl92se_query_rxphystatus(s
 		pstats->rxpower = rx_pwr_all;
 		pstats->recvsignalpower = rx_pwr_all;
 
-		if (GET_RX_STATUS_DESC_RX_HT(pdesc) &&
-			GET_RX_STATUS_DESC_RX_MCS(pdesc) >= DESC92_RATEMCS8 &&
-		    GET_RX_STATUS_DESC_RX_MCS(pdesc) <= DESC92_RATEMCS15)
+		if (pstats->is_ht && pstats->rate >= DESC92_RATEMCS8 &&
+		    pstats->rate <= DESC92_RATEMCS15)
 			max_spatial_stream = 2;
 		else
 			max_spatial_stream = 1;
@@ -266,7 +262,7 @@ static void _rtl92se_query_rxphystatus(s
 		}
 	}
 
-	if (is_cck_rate)
+	if (is_cck)
 		pstats->signalstrength = (u8)(_rtl92se_signal_scale_mapping(hw,
 					 pwdb_all));
 	else if (rf_rx_num != 0)
@@ -518,6 +514,7 @@ bool rtl92se_rx_query_desc(struct ieee80
 {
 	struct rx_fwinfo *p_drvinfo;
 	u32 phystatus = (u32)GET_RX_STATUS_DESC_PHY_STATUS(pdesc);
+	struct ieee80211_hdr *hdr;
 
 	stats->length = (u16)GET_RX_STATUS_DESC_PKT_LEN(pdesc);
 	stats->rx_drvinfo_size = (u8)GET_RX_STATUS_DESC_DRVINFO_SIZE(pdesc) * 8;
@@ -530,8 +527,12 @@ bool rtl92se_rx_query_desc(struct ieee80
 	stats->rate = (u8)GET_RX_STATUS_DESC_RX_MCS(pdesc);
 	stats->shortpreamble = (u16)GET_RX_STATUS_DESC_SPLCP(pdesc);
 	stats->isampdu = (bool)(GET_RX_STATUS_DESC_PAGGR(pdesc) == 1);
+	stats->isfirst_ampdu = (bool) ((GET_RX_STATUS_DESC_PAGGR(pdesc) == 1)
+			       && (GET_RX_STATUS_DESC_FAGGR(pdesc) == 1));
 	stats->timestamp_low = GET_RX_STATUS_DESC_TSFL(pdesc);
 	stats->rx_is40Mhzpacket = (bool)GET_RX_STATUS_DESC_BW(pdesc);
+	stats->is_ht = (bool)GET_RX_STATUS_DESC_RX_HT(pdesc);
+	stats->is_cck = SE_RX_HAL_IS_CCK_RATE(pdesc);
 
 	if (stats->hwerror)
 		return false;
@@ -539,29 +540,39 @@ bool rtl92se_rx_query_desc(struct ieee80
 	rx_status->freq = hw->conf.channel->center_freq;
 	rx_status->band = hw->conf.channel->band;
 
-	if (GET_RX_STATUS_DESC_CRC32(pdesc))
-		rx_status->flag |= RX_FLAG_FAILED_FCS_CRC;
+	hdr = (struct ieee80211_hdr *)(skb->data + stats->rx_drvinfo_size
+	      + stats->rx_bufshift);
 
-	if (!GET_RX_STATUS_DESC_SWDEC(pdesc))
-		rx_status->flag |= RX_FLAG_DECRYPTED;
+	if (stats->crc)
+		rx_status->flag |= RX_FLAG_FAILED_FCS_CRC;
 
-	if (GET_RX_STATUS_DESC_BW(pdesc))
+	if (stats->rx_is40Mhzpacket)
 		rx_status->flag |= RX_FLAG_40MHZ;
 
-	if (GET_RX_STATUS_DESC_RX_HT(pdesc))
+	if (stats->is_ht)
 		rx_status->flag |= RX_FLAG_HT;
 
 	rx_status->flag |= RX_FLAG_MACTIME_MPDU;
 
-	if (stats->decrypted)
-		rx_status->flag |= RX_FLAG_DECRYPTED;
+	/* hw will set stats->decrypted true, if it finds the
+	 * frame is open data frame or mgmt frame,
+	 * hw will not decrypt robust managment frame
+	 * for IEEE80211w but still set stats->decrypted
+	 * true, so here we should set it back to undecrypted
+	 * for IEEE80211w frame, and mac80211 sw will help
+	 * to decrypt it */
+	if (stats->decrypted) {
+		if ((ieee80211_is_robust_mgmt_frame(hdr)) &&
+			(ieee80211_has_protected(hdr->frame_control)))
+			rx_status->flag &= ~RX_FLAG_DECRYPTED;
+		else
+			rx_status->flag |= RX_FLAG_DECRYPTED;
+	}
 
 	rx_status->rate_idx = rtlwifi_rate_mapping(hw,
-				(bool)GET_RX_STATUS_DESC_RX_HT(pdesc),
-				(u8)GET_RX_STATUS_DESC_RX_MCS(pdesc));
-
+			     stats->is_ht, stats->rate);
 
-	rx_status->mactime = GET_RX_STATUS_DESC_TSFL(pdesc);
+	rx_status->mactime = stats->timestamp_low;
 	if (phystatus) {
 		p_drvinfo = (struct rx_fwinfo *)(skb->data +
 						 stats->rx_bufshift);
Index: wireless-testing-new/drivers/net/wireless/rtlwifi/wifi.h
===================================================================
--- wireless-testing-new.orig/drivers/net/wireless/rtlwifi/wifi.h
+++ wireless-testing-new/drivers/net/wireless/rtlwifi/wifi.h
@@ -450,6 +450,7 @@ enum rtl_var_map {
 	EFUSE_HWSET_MAX_SIZE,
 	EFUSE_MAX_SECTION_MAP,
 	EFUSE_REAL_CONTENT_SIZE,
+	EFUSE_OOB_PROTECT_BYTES_LEN,
 
 	/*CAM map */
 	RWCAM,
@@ -1324,6 +1325,7 @@ struct rtl_stats {
 	s8 rx_mimo_signalquality[2];
 	bool packet_matchbssid;
 	bool is_cck;
+	bool is_ht;
 	bool packet_toself;
 	bool packet_beacon;	/*for rssi */
 	char cck_adc_pwdb[4];	/*for rx path selection */

--------------080708050201040904080201
Content-Type: text/x-patch;
 name="0005-rtlwifi-rtl8192de-Updates-from-latest-Reaktek-driver.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="0005-rtlwifi-rtl8192de-Updates-from-latest-Reaktek-driver.pa";
 filename*1="tch"

>From 319071578daa1e1a151d4488510c3b706e2803cd Mon Sep 17 00:00:00 2001
From: Larry Finger <Larry.Finger@lwfinger.net>
Date: Wed, 5 Oct 2011 11:14:37 -0500
Subject: [PATCH 5/5] rtlwifi: rtl8192de: Updates from latest Reaktek driver -
 Part III
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org

From: Chaoming Li <chaoming_li@realsil.com.cn>

This patch incorporate the differences between the 06/20/2011 and
08/16/2011 Realtek releases of the rtl8192de driver.

The changes include:

1. Update for new chip versions

Signed-off-by: Chaoming Li <chaoming_li@realsil.com.cn>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---
 drivers/net/wireless/rtlwifi/rtl8192de/def.h |  124 ++++++++++++++++----------
 drivers/net/wireless/rtlwifi/rtl8192de/hw.c  |   19 ++---
 2 files changed, 84 insertions(+), 59 deletions(-)

Index: wireless-testing-new/drivers/net/wireless/rtlwifi/rtl8192de/def.h
===================================================================
--- wireless-testing-new.orig/drivers/net/wireless/rtlwifi/rtl8192de/def.h
+++ wireless-testing-new/drivers/net/wireless/rtlwifi/rtl8192de/def.h
@@ -122,60 +122,99 @@
 #define	GET_C2H_CMD_FEEDBACK_CCX_SEQ(__pcmdfbhdr)	\
 	LE_BITS_TO_4BYTE(((__pcmdfbhdr) + 4), 20, 12)
 
-/*
- * 92D chip ver:
- * BIT8: IS 92D
- * BIT9: single phy
- * BIT10: C-cut
- * BIT11: D-cut
- */
-
-/* Chip specific */
-#define CHIP_92C			BIT(0)
-#define CHIP_92C_1T2R			BIT(1)
-#define CHIP_8723			BIT(2) /* RTL8723 With BT feature */
-#define CHIP_8723_DRV_REV		BIT(3) /* RTL8723 Driver Revised */
-#define NORMAL_CHIP			BIT(4)
-#define CHIP_VENDOR_UMC			BIT(5)
-#define CHIP_VENDOR_UMC_B_CUT		BIT(6) /* Chip version for ECO */
+enum version_8192d {
+	VERSION_TEST_CHIP_88C = 0x0000,
+	VERSION_TEST_CHIP_92C = 0x0020,
+	VERSION_TEST_UMC_CHIP_8723 = 0x0081,
+	VERSION_NORMAL_TSMC_CHIP_88C = 0x0008,
+	VERSION_NORMAL_TSMC_CHIP_92C = 0x0028,
+	VERSION_NORMAL_TSMC_CHIP_92C_1T2R = 0x0018,
+	VERSION_NORMAL_UMC_CHIP_88C_A_CUT = 0x0088,
+	VERSION_NORMAL_UMC_CHIP_92C_A_CUT = 0x00a8,
+	VERSION_NORMAL_UMC_CHIP_92C_1T2R_A_CUT = 0x0098,
+	VERSION_NORMAL_UMC_CHIP_8723_1T1R_A_CUT = 0x0089,
+	VERSION_NORMAL_UMC_CHIP_8723_1T1R_B_CUT = 0x1089,
+	VERSION_NORMAL_UMC_CHIP_88C_B_CUT = 0x1088,
+	VERSION_NORMAL_UMC_CHIP_92C_B_CUT = 0x10a8,
+	VERSION_NORMAL_UMC_CHIP_92C_1T2R_B_CUT = 0x1090,
+	VERSION_TEST_CHIP_92D_SINGLEPHY = 0x0022,
+	VERSION_TEST_CHIP_92D_DUALPHY = 0x0002,
+	VERSION_NORMAL_CHIP_92D_SINGLEPHY = 0x002a,
+	VERSION_NORMAL_CHIP_92D_DUALPHY = 0x000a,
+	VERSION_NORMAL_CHIP_92D_C_CUT_SINGLEPHY = 0x202a,
+	VERSION_NORMAL_CHIP_92D_C_CUT_DUALPHY = 0x200a,
+	VERSION_NORMAL_CHIP_92D_D_CUT_SINGLEPHY = 0x302a,
+	VERSION_NORMAL_CHIP_92D_D_CUT_DUALPHY = 0x300a,
+	VERSION_NORMAL_CHIP_92D_E_CUT_SINGLEPHY = 0x402a,
+	VERSION_NORMAL_CHIP_92D_E_CUT_DUALPHY = 0x400a,
+};
 
 /* for 92D */
-#define CHIP_92D			BIT(8)
 #define CHIP_92D_SINGLEPHY		BIT(9)
+#define C_CUT_VERSION			BIT(13)
+#define D_CUT_VERSION			((BIT(12)|BIT(13)))
+#define E_CUT_VERSION			BIT(14)
+
+/* Chip specific */
+#define CHIP_BONDING_IDENTIFIER(_value)	(((_value)>>22)&0x3)
+#define CHIP_BONDING_92C_1T2R			0x1
+#define CHIP_BONDING_88C_USB_MCARD		0x2
+#define CHIP_BONDING_88C_USB_HP			0x1
+
+/* [15:12] IC version(CUT): A-cut=0, B-cut=1, C-cut=2, D-cut=3 */
+/* [7] Manufacturer: TSMC=0, UMC=1 */
+/* [6:4] RF type: 1T1R=0, 1T2R=1, 2T2R=2 */
+/* [3] Chip type: TEST=0, NORMAL=1 */
+/* [2:0] IC type: 81xxC=0, 8723=1, 92D=2 */
+#define CHIP_8723			BIT(0)
+#define CHIP_92D			BIT(1)
+#define NORMAL_CHIP			BIT(3)
+#define RF_TYPE_1T1R			(~(BIT(4)|BIT(5)|BIT(6)))
+#define RF_TYPE_1T2R			BIT(4)
+#define RF_TYPE_2T2R			BIT(5)
+#define CHIP_VENDOR_UMC			BIT(7)
+#define B_CUT_VERSION			BIT(12)
+
+/* MASK */
+#define IC_TYPE_MASK			(BIT(0)|BIT(1)|BIT(2))
+#define CHIP_TYPE_MASK			BIT(3)
+#define RF_TYPE_MASK			(BIT(4)|BIT(5)|BIT(6))
+#define MANUFACTUER_MASK		BIT(7)
+#define ROM_VERSION_MASK		(BIT(11)|BIT(10)|BIT(9)|BIT(8))
+#define CUT_VERSION_MASK		(BIT(15)|BIT(14)|BIT(13)|BIT(12))
+
+
+/* Get element */
+#define GET_CVID_IC_TYPE(version)	((version) & IC_TYPE_MASK)
+#define GET_CVID_CHIP_TYPE(version)	((version) & CHIP_TYPE_MASK)
+#define GET_CVID_RF_TYPE(version)	((version) & RF_TYPE_MASK)
+#define GET_CVID_MANUFACTUER(version)	((version) & MANUFACTUER_MASK)
+#define GET_CVID_ROM_VERSION(version)	((version) & ROM_VERSION_MASK)
+#define GET_CVID_CUT_VERSION(version)	((version) & CUT_VERSION_MASK)
+
+#define IS_1T1R(version)		((GET_CVID_RF_TYPE(version)) ?	\
+					 false : true)
+#define IS_1T2R(version)		((GET_CVID_RF_TYPE(version) ==	\
+					 RF_TYPE_1T2R) ? true : false)
+#define IS_2T2R(version)		((GET_CVID_RF_TYPE(version) ==	\
+					 RF_TYPE_2T2R) ? true : false)
+
+#define IS_92D_SINGLEPHY(version)	((IS_92D(version)) ?		\
+				 (IS_2T2R(version) ? true : false) : false)
+#define IS_92D(version)			((GET_CVID_IC_TYPE(version) ==	\
+					 CHIP_92D) ? true : false)
+#define IS_92D_C_CUT(version)		((IS_92D(version)) ?		\
+				 ((GET_CVID_CUT_VERSION(version) ==	\
+				 0x2000) ? true : false) : false)
+#define IS_92D_D_CUT(version)			((IS_92D(version)) ?	\
+				 ((GET_CVID_CUT_VERSION(version) ==	\
+				 0x3000) ? true : false) : false)
+#define IS_92D_E_CUT(version)		((IS_92D(version)) ?		\
+				 ((GET_CVID_CUT_VERSION(version) ==	\
+				 0x4000) ? true : false) : false)
 #define CHIP_92D_C_CUT			BIT(10)
 #define CHIP_92D_D_CUT			BIT(11)
 
-enum version_8192d {
-	VERSION_TEST_CHIP_88C = 0x00,
-	VERSION_TEST_CHIP_92C = 0x01,
-	VERSION_NORMAL_TSMC_CHIP_88C = 0x10,
-	VERSION_NORMAL_TSMC_CHIP_92C = 0x11,
-	VERSION_NORMAL_TSMC_CHIP_92C_1T2R = 0x13,
-	VERSION_NORMAL_UMC_CHIP_88C_A_CUT = 0x30,
-	VERSION_NORMAL_UMC_CHIP_92C_A_CUT = 0x31,
-	VERSION_NORMAL_UMC_CHIP_92C_1T2R_A_CUT = 0x33,
-	VERSION_NORMA_UMC_CHIP_8723_1T1R_A_CUT = 0x34,
-	VERSION_NORMA_UMC_CHIP_8723_1T1R_B_CUT = 0x3c,
-	VERSION_NORMAL_UMC_CHIP_88C_B_CUT = 0x70,
-	VERSION_NORMAL_UMC_CHIP_92C_B_CUT = 0x71,
-	VERSION_NORMAL_UMC_CHIP_92C_1T2R_B_CUT = 0x73,
-	VERSION_TEST_CHIP_92D_SINGLEPHY = 0x300,
-	VERSION_TEST_CHIP_92D_DUALPHY = 0x100,
-	VERSION_NORMAL_CHIP_92D_SINGLEPHY = 0x310,
-	VERSION_NORMAL_CHIP_92D_DUALPHY = 0x110,
-	VERSION_NORMAL_CHIP_92D_C_CUT_SINGLEPHY = 0x710,
-	VERSION_NORMAL_CHIP_92D_C_CUT_DUALPHY = 0x510,
-	VERSION_NORMAL_CHIP_92D_D_CUT_SINGLEPHY = 0xB10,
-	VERSION_NORMAL_CHIP_92D_D_CUT_DUALPHY = 0x910,
-};
-
-#define IS_92D_SINGLEPHY(version)		\
-	((version & CHIP_92D_SINGLEPHY) ? true : false)
-#define IS_92D_C_CUT(version)			\
-	((version & CHIP_92D_C_CUT) ? true : false)
-#define IS_92D_D_CUT(version)			\
-	((version & CHIP_92D_D_CUT) ? true : false)
-
 enum rf_optype {
 	RF_OP_BY_SW_3WIRE = 0,
 	RF_OP_BY_FW,
Index: wireless-testing-new/drivers/net/wireless/rtlwifi/rtl8192de/hw.c
===================================================================
--- wireless-testing-new.orig/drivers/net/wireless/rtlwifi/rtl8192de/hw.c
+++ wireless-testing-new/drivers/net/wireless/rtlwifi/rtl8192de/hw.c
@@ -1608,17 +1608,16 @@ static void _rtl92de_read_txpower_info(s
 		tempval[0] = hwinfo[EEPROM_IQK_DELTA] & 0x03;
 		tempval[1] = (hwinfo[EEPROM_LCK_DELTA] & 0x0C) >> 2;
 		rtlefuse->txpwr_fromeprom = true;
-		if (IS_92D_D_CUT(rtlpriv->rtlhal.version)) {
+		if (IS_92D_D_CUT(rtlpriv->rtlhal.version) ||
+		    IS_92D_E_CUT(rtlpriv->rtlhal.version)) {
 			rtlefuse->internal_pa_5g[0] =
-				 !((hwinfo[EEPROM_TSSI_A_5G] &
-				 BIT(6)) >> 6);
+				!((hwinfo[EEPROM_TSSI_A_5G] & BIT(6)) >> 6);
 			rtlefuse->internal_pa_5g[1] =
-				 !((hwinfo[EEPROM_TSSI_B_5G] &
-				 BIT(6)) >> 6);
-			RT_TRACE(rtlpriv, COMP_INIT, DBG_LOUD,
+				!((hwinfo[EEPROM_TSSI_B_5G] & BIT(6)) >> 6);
+			RT_TRACE(rtlpriv, COMP_INIT, DBG_DMESG,
 				 ("Is D cut,Internal PA0 %d Internal PA1 %d\n",
-				  rtlefuse->internal_pa_5g[0],
-				  rtlefuse->internal_pa_5g[1]))
+				 rtlefuse->internal_pa_5g[0],
+				 rtlefuse->internal_pa_5g[1]))
 		}
 		rtlefuse->eeprom_c9 = hwinfo[EEPROM_RF_OPT6];
 		rtlefuse->eeprom_cc = hwinfo[EEPROM_RF_OPT7];

--------------080708050201040904080201--
