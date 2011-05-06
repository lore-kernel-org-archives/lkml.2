Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932268Ab1EFAY7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 May 2011 20:24:59 -0400
Received: from kroah.org ([198.145.64.141]:36808 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932251Ab1EFAY4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 May 2011 20:24:56 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Thu May  5 17:22:10 2011
Message-Id: <20110506002210.885090560@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Thu, 05 May 2011 17:20:43 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Ben Hutchings <ben@decadent.org.uk>
Subject: [058/143] Staging: rtl8192su: Clean up in case of an error in module initialisation
In-Reply-To: <20110506002311.GA15354@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let us know.

------------------

From: Ben Hutchings <ben@decadent.org.uk>

commit 9a3dfa0555130952517b9a9c3918729495aa709a upstream.

Currently various resources may be leaked in case of an error.

Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/staging/rtl8192su/r8192U_core.c |   43 ++++++++++++++++++++++++++------
 1 file changed, 36 insertions(+), 7 deletions(-)

--- a/drivers/staging/rtl8192su/r8192U_core.c
+++ b/drivers/staging/rtl8192su/r8192U_core.c
@@ -959,10 +959,11 @@ static int proc_get_stats_rx(char *page,
 	return len;
 }
 
-void rtl8192_proc_module_init(void)
+int rtl8192_proc_module_init(void)
 {
 	RT_TRACE(COMP_INIT, "Initializing proc filesystem");
 	rtl8192_proc=create_proc_entry(RTL819xU_MODULE_NAME, S_IFDIR, init_net.proc_net);
+	return rtl8192_proc ? 0 : -ENOMEM;
 }
 
 
@@ -7564,35 +7565,63 @@ static int __init rtl8192_usb_module_ini
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
 
 


