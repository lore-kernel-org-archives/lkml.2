Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759193Ab2CMAps (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 20:45:48 -0400
Received: from mail.windriver.com ([147.11.1.11]:48295 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758994Ab2CMAXk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 20:23:40 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Ben Hutchings <ben@decadent.org.uk>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 118/196] Staging: rtl8192su: Clean up in case of an error in module initialisation
Date: Mon, 12 Mar 2012 20:20:31 -0400
Message-Id: <1331598109-31424-73-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.9.3
In-Reply-To: <1331598109-31424-1-git-send-email-paul.gortmaker@windriver.com>
References: <1331597724-31358-1-git-send-email-paul.gortmaker@windriver.com>
 <1331598109-31424-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ben Hutchings <ben@decadent.org.uk>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit 9a3dfa0555130952517b9a9c3918729495aa709a upstream.

Currently various resources may be leaked in case of an error.

Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/staging/rtl8192su/r8192U_core.c |   43 ++++++++++++++++++++++++++-----
 1 file changed, 36 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/rtl8192su/r8192U_core.c b/drivers/staging/rtl8192su/r8192U_core.c
index 04f8516..9848d08 100644
--- a/drivers/staging/rtl8192su/r8192U_core.c
+++ b/drivers/staging/rtl8192su/r8192U_core.c
@@ -960,10 +960,11 @@ static int proc_get_stats_rx(char *page, char **start,
 	return len;
 }
 
-void rtl8192_proc_module_init(void)
+int rtl8192_proc_module_init(void)
 {
 	RT_TRACE(COMP_INIT, "Initializing proc filesystem");
 	rtl8192_proc=create_proc_entry(RTL819xU_MODULE_NAME, S_IFDIR, init_net.proc_net);
+	return rtl8192_proc ? 0 : -ENOMEM;
 }
 
 
@@ -7526,35 +7527,63 @@ static int __init rtl8192_usb_module_init(void)
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
 
 
-- 
1.7.9.3

