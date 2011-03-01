Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755477Ab1CACfV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Feb 2011 21:35:21 -0500
Received: from dakia2.marvell.com ([65.219.4.35]:45246 "EHLO
	dakia2.marvell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753626Ab1CACfU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Feb 2011 21:35:20 -0500
X-Greylist: delayed 712 seconds by postgrey-1.27 at vger.kernel.org; Mon, 28 Feb 2011 21:35:20 EST
X-ASG-Debug-ID: 1298946207-082e62840001-xx1T2L
X-Barracuda-Envelope-From: bzhao@marvell.com
From: Bing Zhao <bzhao@marvell.com>
To: linux-kernel@vger.kernel.org
Cc: linux-wireless@vger.kernel.org,
        "John W. Linville" <linville@tuxdriver.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        Amitkumar Karwar <akarwar@marvell.com>,
        Kiran Divekar <dkiran@marvell.com>, Frank Huang <frankh@marvell.com>,
        Bing Zhao <bzhao@marvell.com>
X-ASG-Orig-Subj: [RFC] dynamic debug: add dynamic_hexdump_debug macro
Subject: [RFC] dynamic debug: add dynamic_hexdump_debug macro
Date: Mon, 28 Feb 2011 18:26:11 -0800
X-ASG-Orig-Subj: [RFC] dynamic debug: add dynamic_hexdump_debug macro
Message-Id: <1298946371-30192-1-git-send-email-bzhao@marvell.com>
X-Mailer: git-send-email 1.7.0.2
X-Barracuda-Connect: maili.marvell.com[10.68.76.51]
X-Barracuda-Start-Time: 1298946207
X-Barracuda-URL: http://10.68.76.222:80/cgi-mod/mark.cgi
X-Barracuda-Spam-Score: -1002.00
X-Barracuda-Spam-Status: No, SCORE=-1002.00 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=1000.0 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

dynamic_hexdump_debug(str, buf, len)

usage:
dynamic_hexdump_debug("mwifiex data: tx_buf:\n", tx_buf, 32);

Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 include/linux/dynamic_debug.h |   22 ++++++++++++++++++++++
 include/linux/printk.h        |   14 ++++++++++++++
 2 files changed, 36 insertions(+), 0 deletions(-)

diff --git a/include/linux/dynamic_debug.h b/include/linux/dynamic_debug.h
index 1c70028..a7296fb 100644
--- a/include/linux/dynamic_debug.h
+++ b/include/linux/dynamic_debug.h
@@ -64,6 +64,19 @@ extern int ddebug_remove_module(const char *mod_name);
 		dev_printk(KERN_DEBUG, dev, fmt, ##__VA_ARGS__);	\
 	} while (0)
 
+#define dynamic_hexdump_debug(str, buf, len)				\
+do {									\
+	static struct _ddebug descriptor				\
+	__used								\
+	__attribute__((section("__verbose"), aligned(8))) =		\
+	{ KBUILD_MODNAME, __func__, __FILE__, str, __LINE__,		\
+		_DPRINTK_FLAGS_DEFAULT };				\
+	if (unlikely(descriptor.enabled)) {				\
+		printk(KERN_DEBUG str);					\
+		print_hex_dump_bytes("", DUMP_PREFIX_OFFSET, buf, len);	\
+	}								\
+} while (0)
+
 #else
 
 static inline int ddebug_remove_module(const char *mod)
@@ -75,6 +88,15 @@ static inline int ddebug_remove_module(const char *mod)
 	do { if (0) printk(KERN_DEBUG pr_fmt(fmt), ##__VA_ARGS__); } while (0)
 #define dynamic_dev_dbg(dev, fmt, ...)					\
 	do { if (0) dev_printk(KERN_DEBUG, dev, fmt, ##__VA_ARGS__); } while (0)
+
+#define dynamic_hexdump_debug(str, buf, len)				\
+do {									\
+	if (0) {							\
+		printk(KERN_DEBUG str);					\
+		print_hex_dump_bytes("", DUMP_PREFIX_OFFSET, buf, len);	\
+	}								\
+} while (0)
+
 #endif
 
 #endif
diff --git a/include/linux/printk.h b/include/linux/printk.h
index ee048e7..c758131 100644
--- a/include/linux/printk.h
+++ b/include/linux/printk.h
@@ -299,4 +299,18 @@ static inline void print_hex_dump_bytes(const char *prefix_str, int prefix_type,
 
 #endif
 
+#if defined(DEBUG)
+#define hexdump_debug(str, buf, len) \
+do {									\
+	printk(KERN_DEBUG str);						\
+	print_hex_dump_bytes("", DUMP_PREFIX_OFFSET, buf, len);		\
+} while (0)
+#elif defined(CONFIG_DYNAMIC_DEBUG)
+#define hexdump_debug(str, buf, len) \
+	dynamic_hexdump_debug(str, buf, len)
+#else
+#define hexdump_debug(str, buf, len) \
+	no_printk(KERN_DEBUG str)
+#endif
+
 #endif
-- 
1.7.0.2

