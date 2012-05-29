Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753184Ab2E2HPK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2012 03:15:10 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:37455 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753116Ab2E2HPJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2012 03:15:09 -0400
From: Eyal Shapira <eyal@wizery.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: <linux-wireless@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-next@vger.kernel.org>, Luciano Coelho <coelho@ti.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH] wlcore: fix undefined symbols when CONFIG_PM is not defined
Date: Tue, 29 May 2012 00:15:03 -0700
Message-Id: <1338275703-28103-1-git-send-email-eyal@wizery.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <CAMuHMdVv+g=+A1HHNmWWcsFBQjRXNNA437V6-g80cYq7zRJ78g@mail.gmail.com>
References: <CAMuHMdVv+g=+A1HHNmWWcsFBQjRXNNA437V6-g80cYq7zRJ78g@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit 5063c201d7b799d6cb36d3edfc2c2c3db3b400e5
"wl12xx: add RX filters ACX commands" breaks the build
when CONFIG_PM isn't defined:

ERROR: "wl1271_rx_filter_get_fields_size"
[drivers/net/wireless/ti/wlcore/wlcore.ko] undefined!
ERROR: "wl1271_rx_filter_flatten_fields"
[drivers/net/wireless/ti/wlcore/wlcore.ko] undefined!

code in drivers/net/wireless/ti/wlcore/acx.c is using these
functions unconditionally while they are #ifdefed CONFIG_PM.
Fix it by ifdefing all relevant RX filters code with CONFIG_PM.

Reported-by: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Eyal Shapira <eyal@wizery.com>
---
Geert - Thanks!

 drivers/net/wireless/ti/wlcore/acx.c |    2 ++
 drivers/net/wireless/ti/wlcore/acx.h |    4 +++-
 drivers/net/wireless/ti/wlcore/rx.c  |    2 ++
 3 files changed, 7 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ti/wlcore/acx.c b/drivers/net/wireless/ti/wlcore/acx.c
index 0fd78a0..755b225 100644
--- a/drivers/net/wireless/ti/wlcore/acx.c
+++ b/drivers/net/wireless/ti/wlcore/acx.c
@@ -1715,6 +1715,7 @@ out:
 
 }
 
+#ifdef CONFIG_PM
 /* Set the global behaviour of RX filters - On/Off + default action */
 int wl1271_acx_default_rx_filter_enable(struct wl1271 *wl, bool enable,
 					enum rx_filter_action action)
@@ -1793,3 +1794,4 @@ out:
 	kfree(acx);
 	return ret;
 }
+#endif /* CONFIG_PM */
diff --git a/drivers/net/wireless/ti/wlcore/acx.h b/drivers/net/wireless/ti/wlcore/acx.h
index 8106b2e..e6a7486 100644
--- a/drivers/net/wireless/ti/wlcore/acx.h
+++ b/drivers/net/wireless/ti/wlcore/acx.h
@@ -1330,9 +1330,11 @@ int wl1271_acx_set_inconnection_sta(struct wl1271 *wl, u8 *addr);
 int wl1271_acx_fm_coex(struct wl1271 *wl);
 int wl12xx_acx_set_rate_mgmt_params(struct wl1271 *wl);
 int wl12xx_acx_config_hangover(struct wl1271 *wl);
+
+#ifdef CONFIG_PM
 int wl1271_acx_default_rx_filter_enable(struct wl1271 *wl, bool enable,
 					enum rx_filter_action action);
 int wl1271_acx_set_rx_filter(struct wl1271 *wl, u8 index, bool enable,
 			     struct wl12xx_rx_filter *filter);
-
+#endif /* CONFIG_PM */
 #endif /* __WL1271_ACX_H__ */
diff --git a/drivers/net/wireless/ti/wlcore/rx.c b/drivers/net/wireless/ti/wlcore/rx.c
index 1f1d948..d6a3c6b 100644
--- a/drivers/net/wireless/ti/wlcore/rx.c
+++ b/drivers/net/wireless/ti/wlcore/rx.c
@@ -279,6 +279,7 @@ void wl12xx_rx(struct wl1271 *wl, struct wl_fw_status *status)
 	wl12xx_rearm_rx_streaming(wl, active_hlids);
 }
 
+#ifdef CONFIG_PM
 int wl1271_rx_filter_enable(struct wl1271 *wl,
 			    int index, bool enable,
 			    struct wl12xx_rx_filter *filter)
@@ -314,3 +315,4 @@ void wl1271_rx_filter_clear_all(struct wl1271 *wl)
 		wl1271_rx_filter_enable(wl, i, 0, NULL);
 	}
 }
+#endif /* CONFIG_PM */
-- 
1.7.4.1

