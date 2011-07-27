Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754131Ab1G0AhL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jul 2011 20:37:11 -0400
Received: from mga03.intel.com ([143.182.124.21]:31501 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753884Ab1G0AfZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jul 2011 20:35:25 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,272,1309762800"; 
   d="scan'208";a="31838829"
From: Andi Kleen <andi@firstfloor.org>
References: <20110726534.972201586@firstfloor.org>
In-Reply-To: <20110726534.972201586@firstfloor.org>
To: ben@decadent.org.uk, gregkh@suse.de, ak@linux.intel.com,
        linux-kernel@vger.kernel.org, stable@kernel.org, tim.bird@am.sony.com,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: [PATCH] [32/98] Staging: rtl8192su: Clean up in case of an error in module initialisation
Message-Id: <20110727003524.871262403FF@tassilo.jf.intel.com>
Date: Tue, 26 Jul 2011 17:35:24 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Ben Hutchings <ben@decadent.org.uk>

commit 9a3dfa0555130952517b9a9c3918729495aa709a upstream.

Currently various resources may be leaked in case of an error.

Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 drivers/staging/rtl8192su/r8192U_core.c |   43 ++++++++++++++++++++++++++------
 1 file changed, 36 insertions(+), 7 deletions(-)

Index: linux-2.6.35.y/drivers/staging/rtl8192su/r8192U_core.c
===================================================================
--- linux-2.6.35.y.orig/drivers/staging/rtl8192su/r8192U_core.c
+++ linux-2.6.35.y/drivers/staging/rtl8192su/r8192U_core.c
@@ -991,10 +991,11 @@ static int proc_get_stats_rx(char *page,
 	return len;
 }
 
-void rtl8192_proc_module_init(void)
+int rtl8192_proc_module_init(void)
 {
 	RT_TRACE(COMP_INIT, "Initializing proc filesystem");
 	rtl8192_proc=create_proc_entry(RTL819xU_MODULE_NAME, S_IFDIR, init_net.proc_net);
+	return rtl8192_proc ? 0 : -ENOMEM;
 }
 
 
@@ -7474,35 +7475,63 @@ static int __init rtl8192_usb_module_ini
 	ret = ieee80211_crypto_init();
 	if (ret) {
 		printk(KERN_ERR "ieee80211_crypto_init() failed %d\n", ret);
-		return ret;
+		goto fail_crypto;
 	}
 
 	ret = ieee80211_crypto_tkip_init();
 	if (ret) {
 		printk(KERN_ERR "ieee80211_crypto_tkip_init() failed %d\n",
 			ret);
-		return ret;
+		goto fail_crypto_tkip;
 	}
 
 	ret = ieee80211_crypto_ccmp_init();
 	if (ret) {
 		printk(KERN_ERR "ieee80211_crypto_ccmp_init() failed %d\n",
 			ret);
-		return ret;
+		goto fail_crypto_ccmp;
 	}
 
 	ret = ieee80211_crypto_wep_init();
 	if (ret) {
 		printk(KERN_ERR "ieee80211_crypto_wep_init() failed %d\n", ret);
-		return ret;
+		goto fail_crypto_wep;
 	}
 
 	printk(KERN_INFO "\nLinux kernel driver for RTL8192 based WLAN cards\n");
 	printk(KERN_INFO "Copyright (c) 2007-2008, Realsil Wlan\n");
 	RT_TRACE(COMP_INIT, "Initializing module");
 	RT_TRACE(COMP_INIT, "Wireless extensions version %d", WIRELESS_EXT);
-	rtl8192_proc_module_init();
-	return usb_register(&rtl8192_usb_driver);
+
+	ret = rtl8192_proc_module_init();
+	if (ret) {
+		pr_err("rtl8192_proc_module_init() failed %d\n", ret);
+		goto fail_proc;
+	}
+
+	ret = usb_register(&rtl8192_usb_driver);
+	if (ret) {
+		pr_err("usb_register() failed %d\n", ret);
+		goto fail_usb;
+	}
+
+	return 0;
+
+fail_usb:
+	rtl8192_proc_module_remove();
+fail_proc:
+	ieee80211_crypto_wep_exit();
+fail_crypto_wep:
+	ieee80211_crypto_ccmp_exit();
+fail_crypto_ccmp:
+	ieee80211_crypto_tkip_exit();
+fail_crypto_tkip:
+	ieee80211_crypto_deinit();
+fail_crypto:
+#ifdef CONFIG_IEEE80211_DEBUG
+	ieee80211_debug_exit();
+#endif
+	return ret;
 }
 
 
