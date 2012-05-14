Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755075Ab2ENHsN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 03:48:13 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:3862 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754210Ab2ENHsL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 03:48:11 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Mon, 14 May 2012 00:47:11 -0700
From: Hiroshi DOYU <hdoyu@nvidia.com>
To: <hdoyu@nvidia.com>
CC: <joe@perches.com>, <linux-tegra@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Randy Dunlap <rdunlap@xenotime.net>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        "David S. Miller" <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/2] driver core: Add dev_*_ratelimited() family
Date: Mon, 14 May 2012 10:47:57 +0300
Message-ID: <1336981680-15297-1-git-send-email-hdoyu@nvidia.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <20120514.104512.775373956832728793.hdoyu@nvidia.com>
References: <20120514.104512.775373956832728793.hdoyu@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add dev_*_ratelimited() family, dev_* version of pr_*_ratelimited().

Using Joe Perches's proposal/implementation.

Signed-off-by: Hiroshi DOYU <hdoyu@nvidia.com>
Cc: Joe Perches <joe@perches.com>
---
 include/linux/device.h |   27 +++++++++++++++++++++++++++
 1 files changed, 27 insertions(+), 0 deletions(-)

diff --git a/include/linux/device.h b/include/linux/device.h
index 8b9d03a..d3aafdb 100644
--- a/include/linux/device.h
+++ b/include/linux/device.h
@@ -23,6 +23,7 @@
 #include <linux/mutex.h>
 #include <linux/pm.h>
 #include <linux/atomic.h>
+#include <linux/ratelimit.h>
 #include <asm/device.h>
 
 struct device;
@@ -937,6 +938,32 @@ int _dev_info(const struct device *dev, const char *fmt, ...)
 
 #endif
 
+#define dev_level_ratelimited(dev_level, dev, fmt, ...)			\
+do {									\
+	static DEFINE_RATELIMIT_STATE(_rs,				\
+				      DEFAULT_RATELIMIT_INTERVAL,	\
+				      DEFAULT_RATELIMIT_BURST);		\
+	if (__ratelimit(&_rs))						\
+		dev_level(dev, fmt, ##__VA_ARGS__);			\
+} while (0)
+
+#define dev_emerg_ratelimited(dev, fmt, ...)				\
+	dev_level_ratelimited(dev_emerg, dev, fmt, ##__VA_ARGS__)
+#define dev_alert_ratelimited(dev, fmt, ...)				\
+	dev_level_ratelimited(dev_alert, dev, fmt, ##__VA_ARGS__)
+#define dev_crit_ratelimited(dev, fmt, ...)				\
+	dev_level_ratelimited(dev_crit, dev, fmt, ##__VA_ARGS__)
+#define dev_err_ratelimited(dev, fmt, ...)				\
+	dev_level_ratelimited(dev_err, dev, fmt, ##__VA_ARGS__)
+#define dev_warn_ratelimited(dev, fmt, ...)				\
+	dev_level_ratelimited(dev_warn, dev, fmt, ##__VA_ARGS__)
+#define dev_notice_ratelimited(dev, fmt, ...)				\
+	dev_level_ratelimited(dev_notice, dev, fmt, ##__VA_ARGS__)
+#define dev_info_ratelimited(dev, fmt, ...)				\
+	dev_level_ratelimited(dev_info, dev, fmt, ##__VA_ARGS__)
+#define dev_dbg_ratelimited(dev, fmt, ...)				\
+	dev_level_ratelimited(dev_dbg, dev, fmt, ##__VA_ARGS__)
+
 /*
  * Stupid hackaround for existing uses of non-printk uses dev_info
  *
-- 
1.7.5.4

