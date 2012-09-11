Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759101Ab2IKWOL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2012 18:14:11 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:52180 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753702Ab2IKWOG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2012 18:14:06 -0400
From: raghu.prabhu13@gmail.com
To: xfs@oss.sgi.com
Cc: david@fromorbit.com, Raghavendra D Prabhu <rprabhu@wnohang.net>,
        Ben Myers <bpm@sgi.com> (supporter:XFS FILESYSTEM),
        Alex Elder <elder@kernel.org> (supporter:XFS FILESYSTEM),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH 1/3] Add ratelimited printk for different alert levels
Date: Wed, 12 Sep 2012 03:43:22 +0530
Message-Id: <ef779779fdfb84c7c1216b374216246d4de83233.1347396641.git.rprabhu@wnohang.net>
X-Mailer: git-send-email 1.7.12
In-Reply-To: <cover.1347396641.git.rprabhu@wnohang.net>
References: <cover.1347396641.git.rprabhu@wnohang.net>
In-Reply-To: <cover.1347396641.git.rprabhu@wnohang.net>
References: <cover.1347396641.git.rprabhu@wnohang.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Raghavendra D Prabhu <rprabhu@wnohang.net>

Ratelimited printk will be useful in printing xfs messages which are otherwise
not required to be printed always due to their high rate (to prevent kernel ring
buffer from overflowing), while at the same time required to be printed.

Signed-off-by: Raghavendra D Prabhu <rprabhu@wnohang.net>
---
 fs/xfs/xfs_message.h | 28 ++++++++++++++++++++++++++++
 1 file changed, 28 insertions(+)

diff --git a/fs/xfs/xfs_message.h b/fs/xfs/xfs_message.h
index 56dc0c1..87999a5 100644
--- a/fs/xfs/xfs_message.h
+++ b/fs/xfs/xfs_message.h
@@ -1,6 +1,8 @@
 #ifndef __XFS_MESSAGE_H
 #define __XFS_MESSAGE_H 1
 
+#include <linux/ratelimit.h>
+
 struct xfs_mount;
 
 extern __printf(2, 3)
@@ -30,6 +32,32 @@ void xfs_debug(const struct xfs_mount *mp, const char *fmt, ...)
 }
 #endif
 
+#define xfs_printk_ratelimited(xfs_printk, dev, fmt, ...)		\
+do {									\
+	static DEFINE_RATELIMIT_STATE(_rs,				\
+				      DEFAULT_RATELIMIT_INTERVAL,	\
+				      DEFAULT_RATELIMIT_BURST);		\
+	if (__ratelimit(&_rs))						\
+		xfs_printk(dev, fmt, ##__VA_ARGS__);			\
+} while (0)
+
+#define xfs_emerg_ratelimited(dev, fmt, ...)				\
+	xfs_printk_ratelimited(xfs_emerg, dev, fmt, ##__VA_ARGS__)
+#define xfs_alert_ratelimited(dev, fmt, ...)				\
+	xfs_printk_ratelimited(xfs_alert, dev, fmt, ##__VA_ARGS__)
+#define xfs_crit_ratelimited(dev, fmt, ...)				\
+	xfs_printk_ratelimited(xfs_crit, dev, fmt, ##__VA_ARGS__)
+#define xfs_err_ratelimited(dev, fmt, ...)				\
+	xfs_printk_ratelimited(xfs_err, dev, fmt, ##__VA_ARGS__)
+#define xfs_warn_ratelimited(dev, fmt, ...)				\
+	xfs_printk_ratelimited(xfs_warn, dev, fmt, ##__VA_ARGS__)
+#define xfs_notice_ratelimited(dev, fmt, ...)				\
+	xfs_printk_ratelimited(xfs_notice, dev, fmt, ##__VA_ARGS__)
+#define xfs_info_ratelimited(dev, fmt, ...)				\
+	xfs_printk_ratelimited(xfs_info, dev, fmt, ##__VA_ARGS__)
+#define xfs_dbg_ratelimited(dev, fmt, ...)				\
+	xfs_printk_ratelimited(xfs_dbg, dev, fmt, ##__VA_ARGS__)
+
 extern void assfail(char *expr, char *f, int l);
 
 extern void xfs_hex_dump(void *p, int length);
-- 
1.7.12

