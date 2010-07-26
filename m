Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755258Ab0GZVkG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jul 2010 17:40:06 -0400
Received: from mail.perches.com ([173.55.12.10]:2093 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752750Ab0GZVkD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jul 2010 17:40:03 -0400
From: Joe Perches <joe@perches.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next 1/4] include/net/cfg80211.h: Add wiphy_<level> printk equivalents
Date: Mon, 26 Jul 2010 14:39:57 -0700
Message-Id: <941bd7c4904abff516f2cabcbe1cc91ec7640ace.1280177971.git.joe@perches.com>
X-Mailer: git-send-email 1.7.2.19.g9a302
In-Reply-To: <cover.1280177971.git.joe@perches.com>
References: <cover.1280177971.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Simplify logging messages for wiphy devices

Signed-off-by: Joe Perches <joe@perches.com>
---
 include/net/cfg80211.h |   64 +++++++++++++++++++++++++++++++++++++++++++++++-
 1 files changed, 63 insertions(+), 1 deletions(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 4d1f19d..7fe774c 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -1416,7 +1416,7 @@ static inline struct device *wiphy_dev(struct wiphy *wiphy)
  *
  * @wiphy: The wiphy whose name to return
  */
-static inline const char *wiphy_name(struct wiphy *wiphy)
+static inline const char *wiphy_name(const struct wiphy *wiphy)
 {
 	return dev_name(&wiphy->dev);
 }
@@ -2420,4 +2420,66 @@ void cfg80211_cqm_rssi_notify(struct net_device *dev,
 			      enum nl80211_cqm_rssi_threshold_event rssi_event,
 			      gfp_t gfp);
 
+#ifdef __KERNEL__
+
+/* Logging, debugging and troubleshooting/diagnostic helpers. */
+
+/* wiphy_printk helpers, similar to dev_printk */
+
+#define wiphy_printk(level, wiphy, format, args...)		\
+	printk(level "%s: " format, wiphy_name(wiphy), ##args)
+#define wiphy_emerg(wiphy, format, args...)			\
+	wiphy_printk(KERN_EMERG, wiphy, format, ##args)
+#define wiphy_alert(wiphy, format, args...)			\
+	wiphy_printk(KERN_ALERT, wiphy, format, ##args)
+#define wiphy_crit(wiphy, format, args...)			\
+	wiphy_printk(KERN_CRIT, wiphy, format, ##args)
+#define wiphy_err(wiphy, format, args...)			\
+	wiphy_printk(KERN_ERR, wiphy, format, ##args)
+#define wiphy_warn(wiphy, format, args...)			\
+	wiphy_printk(KERN_WARNING, wiphy, format, ##args)
+#define wiphy_notice(wiphy, format, args...)			\
+	wiphy_printk(KERN_NOTICE, wiphy, format, ##args)
+#define wiphy_info(wiphy, format, args...)			\
+	wiphy_printk(KERN_INFO, wiphy, format, ##args)
+#define wiphy_debug(wiphy, format, args...)			\
+	wiphy_printk(KERN_DEBUG, wiphy, format, ##args)
+
+#if defined(DEBUG)
+#define wiphy_dbg(wiphy, format, args...)			\
+	wiphy_printk(KERN_DEBUG, wiphy, format, ##args)
+#elif defined(CONFIG_DYNAMIC_DEBUG)
+#define wiphy_dbg(wiphy, format, args...)			\
+	dynamic_pr_debug("%s: " format,	wiphy_name(dev), ##args)
+#else
+#define wiphy_dbg(wiphy, format, args...)				\
+({									\
+	if (0)								\
+		wiphy_printk(KERN_DEBUG, wiphy, format, ##args);	\
+	0;								\
+})
+#endif
+
+#if defined(VERBOSE_DEBUG)
+#define wiphy_vdbg	wiphy_dbg
+#else
+
+#define wiphy_vdbg(wiphy, format, args...)				\
+({									\
+	if (0)								\
+		wiphy_printk(KERN_DEBUG, wiphy, format, ##args);	\
+		0;							\
+})
+#endif
+
+/*
+ * wiphy_WARN() acts like wiphy_printk(), but with the key difference
+ * of using a WARN/WARN_ON to get the message out, including the
+ * file/line information and a backtrace.
+ */
+#define wiphy_WARN(wiphy, format, args...)			\
+	WARN(1, "wiphy: %s\n" format, wiphy_name(wiphy), ##args);
+
+#endif
+
 #endif /* __NET_CFG80211_H */
-- 
1.7.1

