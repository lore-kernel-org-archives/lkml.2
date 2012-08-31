Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751780Ab2HaJWI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2012 05:22:08 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:44658 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751667Ab2HaJWG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2012 05:22:06 -0400
From: Matthieu CASTET <castet.matthieu@free.fr>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        gregkh@suse.de
Cc: sboyd@codeaurora.org, arnd@arndb.de,
        Matthieu CASTET <castet.matthieu@free.fr>,
        Matthieu Castet <matthieu.castet@parrot.com>
Subject: [PATCH] hvc_dcc : add support to armv4 and armv5 core
Date: Fri, 31 Aug 2012 11:21:56 +0200
Message-Id: <1346404916-27616-1-git-send-email-castet.matthieu@free.fr>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Matthieu Castet <matthieu.castet@parrot.com>
---
 drivers/tty/hvc/hvc_dcc.c |   34 ++++++++++++++++++++++++++++++++++
 1 file changed, 34 insertions(+)

diff --git a/drivers/tty/hvc/hvc_dcc.c b/drivers/tty/hvc/hvc_dcc.c
index 44fbeba..489e9e5 100644
--- a/drivers/tty/hvc/hvc_dcc.c
+++ b/drivers/tty/hvc/hvc_dcc.c
@@ -26,6 +26,7 @@
 
 #include "hvc_console.h"
 
+#if defined(CONFIG_CPU_V6) || defined(CONFIG_CPU_V7)
 /* DCC Status Bits */
 #define DCC_STATUS_RX		(1 << 30)
 #define DCC_STATUS_TX		(1 << 29)
@@ -58,6 +59,39 @@ static inline void __dcc_putchar(char c)
 		: "r" (c));
 	isb();
 }
+#else
+/* DCC Status Bits */
+#define DCC_STATUS_RX		(1 << 0)
+#define DCC_STATUS_TX		(1 << 1)
+
+/* primitive JTAG1 protocol utilities */
+static inline u32 __dcc_getstatus(void)
+{
+	u32 ret;
+
+	asm __volatile__ ("mrc p14, 0, %0, c0, c0	@ read comms ctrl reg"
+		: "=r" (ret));
+
+	return ret;
+}
+
+static inline char __dcc_getchar(void)
+{
+	char c;
+
+	asm __volatile__ ("mrc p14, 0, %0, c1, c0	@ read comms data reg"
+		: "=r" (c));
+
+	return c;
+}
+
+static inline void __dcc_putchar(unsigned char c)
+{
+	asm __volatile__ ("mcr p14, 0, %0, c1, c0	@ write a char"
+		: /* no output register */
+		: "r" (c));
+}
+#endif
 
 static int hvc_dcc_put_chars(uint32_t vt, const char *buf, int count)
 {
-- 
1.7.10.4

