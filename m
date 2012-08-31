Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752381Ab2HaLrf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2012 07:47:35 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:37861 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751366Ab2HaLre (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2012 07:47:34 -0400
From: Matthieu CASTET <castet.matthieu@free.fr>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        gregkh@linuxfoundation.org
Cc: sboyd@codeaurora.org, arnd@arndb.de, alan@lxorguk.ukuu.org.uk,
        Matthieu CASTET <castet.matthieu@free.fr>,
        Matthieu Castet <matthieu.castet@parrot.com>
Subject: [PATCH v2] hvc_dcc : add support to armv4 and armv5 core
Date: Fri, 31 Aug 2012 13:47:25 +0200
Message-Id: <1346413645-4593-1-git-send-email-castet.matthieu@free.fr>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Matthieu Castet <matthieu.castet@parrot.com>
---
 drivers/tty/hvc/hvc_dcc.c |   83 +++++++++++++++++++++++++++++++++++++++++----
 1 file changed, 76 insertions(+), 7 deletions(-)

diff --git a/drivers/tty/hvc/hvc_dcc.c b/drivers/tty/hvc/hvc_dcc.c
index 44fbeba..5f8827f 100644
--- a/drivers/tty/hvc/hvc_dcc.c
+++ b/drivers/tty/hvc/hvc_dcc.c
@@ -27,10 +27,10 @@
 #include "hvc_console.h"
 
 /* DCC Status Bits */
-#define DCC_STATUS_RX		(1 << 30)
-#define DCC_STATUS_TX		(1 << 29)
+#define DCC_STATUS_RX_V6		(1 << 30)
+#define DCC_STATUS_TX_V6		(1 << 29)
 
-static inline u32 __dcc_getstatus(void)
+static inline u32 __dcc_getstatus_v6(void)
 {
 	u32 __ret;
 	asm volatile("mrc p14, 0, %0, c0, c1, 0	@ read comms ctrl reg"
@@ -40,7 +40,7 @@ static inline u32 __dcc_getstatus(void)
 }
 
 
-static inline char __dcc_getchar(void)
+static inline char __dcc_getchar_v6(void)
 {
 	char __c;
 
@@ -51,7 +51,7 @@ static inline char __dcc_getchar(void)
 	return __c;
 }
 
-static inline void __dcc_putchar(char c)
+static inline void __dcc_putchar_v6(char c)
 {
 	asm volatile("mcr p14, 0, %0, c0, c5, 0	@ write a char"
 		: /* no output register */
@@ -59,6 +59,69 @@ static inline void __dcc_putchar(char c)
 	isb();
 }
 
+static int hvc_dcc_put_chars_v6(uint32_t vt, const char *buf, int count)
+{
+	int i;
+
+	for (i = 0; i < count; i++) {
+		while (__dcc_getstatus_v6() & DCC_STATUS_TX_V6)
+			cpu_relax();
+
+		__dcc_putchar_v6(buf[i]);
+	}
+
+	return count;
+}
+
+static int hvc_dcc_get_chars_v6(uint32_t vt, char *buf, int count)
+{
+	int i;
+
+	for (i = 0; i < count; ++i)
+		if (__dcc_getstatus_v6() & DCC_STATUS_RX_V6)
+			buf[i] = __dcc_getchar_v6();
+		else
+			break;
+
+	return i;
+}
+
+static const struct hv_ops hvc_dcc_get_put_ops_v6 = {
+	.get_chars = hvc_dcc_get_chars_v6,
+	.put_chars = hvc_dcc_put_chars_v6,
+};
+
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
+
 static int hvc_dcc_put_chars(uint32_t vt, const char *buf, int count)
 {
 	int i;
@@ -93,14 +156,20 @@ static const struct hv_ops hvc_dcc_get_put_ops = {
 
 static int __init hvc_dcc_console_init(void)
 {
-	hvc_instantiate(0, 0, &hvc_dcc_get_put_ops);
+	if (cpu_architecture() >= CPU_ARCH_ARMv6)
+		hvc_instantiate(0, 0, &hvc_dcc_get_put_ops_v6);
+	else
+		hvc_instantiate(0, 0, &hvc_dcc_get_put_ops);
 	return 0;
 }
 console_initcall(hvc_dcc_console_init);
 
 static int __init hvc_dcc_init(void)
 {
-	hvc_alloc(0, 0, &hvc_dcc_get_put_ops, 128);
+	if (cpu_architecture() >= CPU_ARCH_ARMv6)
+		hvc_alloc(0, 0, &hvc_dcc_get_put_ops_v6, 128);
+	else
+		hvc_alloc(0, 0, &hvc_dcc_get_put_ops, 128);
 	return 0;
 }
 device_initcall(hvc_dcc_init);
-- 
1.7.10.4

