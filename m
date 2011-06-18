Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752525Ab1FRTGj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Jun 2011 15:06:39 -0400
Received: from a.ns.miles-group.at ([95.130.255.143]:33349 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752486Ab1FRTGh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Jun 2011 15:06:37 -0400
From: Richard Weinberger <richard@nod.at>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, user-mode-linux-devel@lists.sourceforge.net,
        Richard Weinberger <richard@nod.at>
Subject: [PATCH v2] um: Clean up delay functions
Date: Sat, 18 Jun 2011 21:06:23 +0200
Message-Id: <1308423983-7031-1-git-send-email-richard@nod.at>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Both sys-i386 and sys-x86_64 support now ndelay().
The delay functions are based on arch/x86/lib/delay.c.

Signed-off-by: Richard Weinberger <richard@nod.at>
---
 arch/um/include/asm/delay.h |   10 +++----
 arch/um/sys-i386/delay.c    |   59 ++++++++++++++++++++++++++++++++----------
 arch/um/sys-x86_64/delay.c  |   54 ++++++++++++++++++++++++++++++--------
 3 files changed, 91 insertions(+), 32 deletions(-)

diff --git a/arch/um/include/asm/delay.h b/arch/um/include/asm/delay.h
index c71e32b..8a5576d 100644
--- a/arch/um/include/asm/delay.h
+++ b/arch/um/include/asm/delay.h
@@ -1,20 +1,18 @@
 #ifndef __UM_DELAY_H
 #define __UM_DELAY_H
 
-#define MILLION 1000000
-
 /* Undefined on purpose */
 extern void __bad_udelay(void);
+extern void __bad_ndelay(void);
 
 extern void __udelay(unsigned long usecs);
+extern void __ndelay(unsigned long usecs);
 extern void __delay(unsigned long loops);
 
 #define udelay(n) ((__builtin_constant_p(n) && (n) > 20000) ? \
 	__bad_udelay() : __udelay(n))
 
-/* It appears that ndelay is not used at all for UML, and has never been
- * implemented. */
-extern void __unimplemented_ndelay(void);
-#define ndelay(n) __unimplemented_ndelay()
+#define ndelay(n) ((__builtin_constant_p(n) && (n) > 20000) ? \
+	__bad_ndelay() : __ndelay(n))
 
 #endif
diff --git a/arch/um/sys-i386/delay.c b/arch/um/sys-i386/delay.c
index d623e07..f3fe1a6 100644
--- a/arch/um/sys-i386/delay.c
+++ b/arch/um/sys-i386/delay.c
@@ -1,29 +1,60 @@
+/*
+ * Copyright (C) 2011 Richard Weinberger <richrd@nod.at>
+ * Mostly copied from arch/x86/lib/delay.c
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
 #include <linux/module.h>
 #include <linux/kernel.h>
 #include <linux/delay.h>
 #include <asm/param.h>
 
-void __delay(unsigned long time)
+void __delay(unsigned long loops)
 {
-	/* Stolen from the i386 __loop_delay */
-	int d0;
-	__asm__ __volatile__(
-		"\tjmp 1f\n"
+	asm volatile(
+		"test %0,%0\n"
+		"jz 3f\n"
+		"jmp 1f\n"
+
 		".align 16\n"
-		"1:\tjmp 2f\n"
+		"1: jmp 2f\n"
+
 		".align 16\n"
-		"2:\tdecl %0\n\tjns 2b"
-		:"=&a" (d0)
-		:"0" (time));
+		"2: dec %0\n"
+		" jnz 2b\n"
+		"3: dec %0\n"
+
+		: /* we don't need output */
+		: "a" (loops)
+	);
 }
+EXPORT_SYMBOL(__delay);
 
-void __udelay(unsigned long usecs)
+inline void __const_udelay(unsigned long xloops)
 {
-	int i, n;
+	int d0;
 
-	n = (loops_per_jiffy * HZ * usecs) / MILLION;
-        for(i=0;i<n;i++)
-                cpu_relax();
+	xloops *= 4;
+	asm("mull %%edx"
+		: "=d" (xloops), "=&a" (d0)
+		: "1" (xloops), "0"
+		(loops_per_jiffy * (HZ/4)));
+
+	__delay(++xloops);
 }
+EXPORT_SYMBOL(__const_udelay);
 
+void __udelay(unsigned long usecs)
+{
+	__const_udelay(usecs * 0x000010c7); /* 2**32 / 1000000 (rounded up) */
+}
 EXPORT_SYMBOL(__udelay);
+
+void __ndelay(unsigned long nsecs)
+{
+	__const_udelay(nsecs * 0x00005); /* 2**32 / 1000000000 (rounded up) */
+}
+EXPORT_SYMBOL(__ndelay);
diff --git a/arch/um/sys-x86_64/delay.c b/arch/um/sys-x86_64/delay.c
index dee5be6..f3fe1a6 100644
--- a/arch/um/sys-x86_64/delay.c
+++ b/arch/um/sys-x86_64/delay.c
@@ -1,30 +1,60 @@
 /*
- * Copyright 2003 PathScale, Inc.
- * Copied from arch/x86_64
+ * Copyright (C) 2011 Richard Weinberger <richrd@nod.at>
+ * Mostly copied from arch/x86/lib/delay.c
  *
- * Licensed under the GPL
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
  */
 
 #include <linux/module.h>
+#include <linux/kernel.h>
 #include <linux/delay.h>
-#include <asm/processor.h>
 #include <asm/param.h>
 
 void __delay(unsigned long loops)
 {
-	unsigned long i;
+	asm volatile(
+		"test %0,%0\n"
+		"jz 3f\n"
+		"jmp 1f\n"
 
-        for(i = 0; i < loops; i++)
-                cpu_relax();
+		".align 16\n"
+		"1: jmp 2f\n"
+
+		".align 16\n"
+		"2: dec %0\n"
+		" jnz 2b\n"
+		"3: dec %0\n"
+
+		: /* we don't need output */
+		: "a" (loops)
+	);
 }
+EXPORT_SYMBOL(__delay);
 
-void __udelay(unsigned long usecs)
+inline void __const_udelay(unsigned long xloops)
 {
-	unsigned long i, n;
+	int d0;
 
-	n = (loops_per_jiffy * HZ * usecs) / MILLION;
-        for(i=0;i<n;i++)
-                cpu_relax();
+	xloops *= 4;
+	asm("mull %%edx"
+		: "=d" (xloops), "=&a" (d0)
+		: "1" (xloops), "0"
+		(loops_per_jiffy * (HZ/4)));
+
+	__delay(++xloops);
 }
+EXPORT_SYMBOL(__const_udelay);
 
+void __udelay(unsigned long usecs)
+{
+	__const_udelay(usecs * 0x000010c7); /* 2**32 / 1000000 (rounded up) */
+}
 EXPORT_SYMBOL(__udelay);
+
+void __ndelay(unsigned long nsecs)
+{
+	__const_udelay(nsecs * 0x00005); /* 2**32 / 1000000000 (rounded up) */
+}
+EXPORT_SYMBOL(__ndelay);
-- 
1.7.5.4

