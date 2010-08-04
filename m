Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758199Ab0HDDCi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Aug 2010 23:02:38 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:6437 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756298Ab0HDDCg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Aug 2010 23:02:36 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6063"; a="49659538"
From: Stephen Boyd <sboyd@codeaurora.org>
To: linux-arm-kernel@lists.infradead.org
Cc: Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org
Subject: [PATCH] ARM: uaccess: Implement strict user copy checks
Date: Tue,  3 Aug 2010 20:02:30 -0700
Message-Id: <1280890950-19174-1-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.7.2.1.6.g61bf12
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is mostly a copy from the s390 implementation (which copied
from x86 and sparc), except we print a warning if the Kconfig
option is disabled.

Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---
 arch/arm/Kconfig.debug         |   14 ++++++++++++++
 arch/arm/include/asm/uaccess.h |   14 ++++++++++++++
 arch/arm/lib/Makefile          |    3 ++-
 arch/arm/lib/usercopy.c        |   25 +++++++++++++++++++++++++
 4 files changed, 55 insertions(+), 1 deletions(-)
 create mode 100644 arch/arm/lib/usercopy.c

diff --git a/arch/arm/Kconfig.debug b/arch/arm/Kconfig.debug
index 91344af..2cc0cdc 100644
--- a/arch/arm/Kconfig.debug
+++ b/arch/arm/Kconfig.debug
@@ -128,4 +128,18 @@ config DEBUG_S3C_UART
 	  The uncompressor code port configuration is now handled
 	  by CONFIG_S3C_LOWLEVEL_UART_PORT.
 
+config DEBUG_STRICT_USER_COPY_CHECKS
+	bool "Strict user copy size checks"
+	depends on DEBUG_KERNEL
+	help
+	  Enabling this option turns a certain set of sanity checks for user
+	  copy operations into compile time errors.
+
+	  The copy_from_user() etc checks are there to help test if there
+	  are sufficient security checks on the length argument of
+	  the copy operation, by having gcc prove that the argument is
+	  within bounds.
+
+	  If unsure, or if you run an older (pre 4.4) gcc, say N.
+
 endmenu
diff --git a/arch/arm/include/asm/uaccess.h b/arch/arm/include/asm/uaccess.h
index 33e4a48..3153e1a 100644
--- a/arch/arm/include/asm/uaccess.h
+++ b/arch/arm/include/asm/uaccess.h
@@ -401,8 +401,22 @@ extern unsigned long __must_check __clear_user_std(void __user *addr, unsigned l
 extern unsigned long __must_check __strncpy_from_user(char *to, const char __user *from, unsigned long count);
 extern unsigned long __must_check __strnlen_user(const char __user *s, long n);
 
+extern void copy_from_user_overflow(void)
+#ifdef CONFIG_DEBUG_STRICT_USER_COPY_CHECKS
+	__compiletime_error("copy_from_user() buffer size is not provably correct")
+#else
+	__compiletime_warning("copy_from_user() buffer size is not provably correct")
+#endif
+;
+
 static inline unsigned long __must_check copy_from_user(void *to, const void __user *from, unsigned long n)
 {
+	unsigned int sz = __compiletime_object_size(to);
+
+	if (unlikely(sz != -1 && sz < n)) {
+		copy_from_user_overflow();
+		return n;
+	}
 	if (access_ok(VERIFY_READ, from, n))
 		n = __copy_from_user(to, from, n);
 	else /* security hole - plug it */
diff --git a/arch/arm/lib/Makefile b/arch/arm/lib/Makefile
index 59ff42d..561cf3d 100644
--- a/arch/arm/lib/Makefile
+++ b/arch/arm/lib/Makefile
@@ -13,7 +13,8 @@ lib-y		:= backtrace.o changebit.o csumipv6.o csumpartial.o   \
 		   testchangebit.o testclearbit.o testsetbit.o        \
 		   ashldi3.o ashrdi3.o lshrdi3.o muldi3.o             \
 		   ucmpdi2.o lib1funcs.o div64.o sha1.o               \
-		   io-readsb.o io-writesb.o io-readsl.o io-writesl.o
+		   io-readsb.o io-writesb.o io-readsl.o io-writesl.o \
+		   usercopy.o
 
 mmu-y	:= clear_user.o copy_page.o getuser.o putuser.o
 
diff --git a/arch/arm/lib/usercopy.c b/arch/arm/lib/usercopy.c
new file mode 100644
index 0000000..e57e6e2
--- /dev/null
+++ b/arch/arm/lib/usercopy.c
@@ -0,0 +1,25 @@
+/*
+ * Copyright (c) 2009-2010, Code Aurora Forum. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 and
+ * only version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
+ * 02110-1301, USA.
+ */
+#include <linux/module.h>
+#include <linux/bug.h>
+
+void copy_from_user_overflow(void)
+{
+	WARN(1, "Buffer overflow detected!\n");
+}
+EXPORT_SYMBOL(copy_from_user_overflow);
-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

