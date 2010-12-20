Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758268Ab0LTWUi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Dec 2010 17:20:38 -0500
Received: from wolverine01.qualcomm.com ([199.106.114.254]:33070 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758189Ab0LTWUg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Dec 2010 17:20:36 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6203"; a="67616906"
From: Stephen Boyd <sboyd@codeaurora.org>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Saravana Kannan <skannan@codeaurora.org>,
        Daniel Walker <dwalker@codeaurora.org>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        John Stultz <johnstul@us.ibm.com>,
        Brian Swetland <swetland@google.com>,
        =?UTF-8?q?Arve=20Hj=F8nnev=E5g?= <arve@android.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCHv4 1/4] ARM: Translate delay.S into (mostly) C
Date: Mon, 20 Dec 2010 14:20:30 -0800
Message-Id: <1292883633-19553-2-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.7.3.4.516.g15368e
In-Reply-To: <1292883633-19553-1-git-send-email-sboyd@codeaurora.org>
References: <1292883633-19553-1-git-send-email-sboyd@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We want to allow machines to override the __delay() implementation
at runtime so they can use a timer based __delay() routine. It's
easier to do this using C, so let's write udelay and friends in C.

We lose the #if 0 code, which according to Russell is used "to
make the delay loop more stable and predictable on older CPUs"
(see http://article.gmane.org/gmane.linux.kernel/888867 for more
info). We shouldn't be too worried though, since we'll soon add
functionality allowing a machine to set the __delay() loop
themselves, thus allowing machines to resurrect the commented out
code should they need it.

Nico expressed concern that fixed lpj cmdlines will break due to
compiler optimizations. That doesn't seem to be the case since
before and after this patch I get the same lpj value when running
my CPU at 19.2 MHz. That should be sufficiently slow enough to
cover any machine running Linux.

Reviewed-by: Saravana Kannan <skannan@codeaurora.org>
Acked-by: Nicolas Pitre <nicolas.pitre@linaro.org>
Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---

This will break builds when you switch back and forth without this patch.
You need to rm arch/arm/lib/.delay.o.cmd if you ever build a kernel
before this patch after you've built with this patch.

 arch/arm/include/asm/delay.h |    2 +-
 arch/arm/kernel/armksyms.c   |    4 --
 arch/arm/lib/delay.S         |   65 ------------------------------------------
 arch/arm/lib/delay.c         |   56 ++++++++++++++++++++++++++++++++++++
 4 files changed, 57 insertions(+), 70 deletions(-)
 delete mode 100644 arch/arm/lib/delay.S
 create mode 100644 arch/arm/lib/delay.c

diff --git a/arch/arm/include/asm/delay.h b/arch/arm/include/asm/delay.h
index b2deda1..ccc5ed5 100644
--- a/arch/arm/include/asm/delay.h
+++ b/arch/arm/include/asm/delay.h
@@ -8,7 +8,7 @@
 
 #include <asm/param.h>	/* HZ */
 
-extern void __delay(int loops);
+extern void __delay(unsigned long loops);
 
 /*
  * This function intentionally does not exist; if you see references to
diff --git a/arch/arm/kernel/armksyms.c b/arch/arm/kernel/armksyms.c
index e5e1e538..220dce6 100644
--- a/arch/arm/kernel/armksyms.c
+++ b/arch/arm/kernel/armksyms.c
@@ -52,10 +52,6 @@ extern void fpundefinstr(void);
 
 EXPORT_SYMBOL(__backtrace);
 
-	/* platform dependent support */
-EXPORT_SYMBOL(__udelay);
-EXPORT_SYMBOL(__const_udelay);
-
 	/* networking */
 EXPORT_SYMBOL(csum_partial);
 EXPORT_SYMBOL(csum_partial_copy_from_user);
diff --git a/arch/arm/lib/delay.S b/arch/arm/lib/delay.S
deleted file mode 100644
index 8d6a876..0000000
--- a/arch/arm/lib/delay.S
+++ /dev/null
@@ -1,65 +0,0 @@
-/*
- *  linux/arch/arm/lib/delay.S
- *
- *  Copyright (C) 1995, 1996 Russell King
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
- */
-#include <linux/linkage.h>
-#include <asm/assembler.h>
-#include <asm/param.h>
-		.text
-
-.LC0:		.word	loops_per_jiffy
-.LC1:		.word	(2199023*HZ)>>11
-
-/*
- * r0  <= 2000
- * lpj <= 0x01ffffff (max. 3355 bogomips)
- * HZ  <= 1000
- */
-
-ENTRY(__udelay)
-		ldr	r2, .LC1
-		mul	r0, r2, r0
-ENTRY(__const_udelay)				@ 0 <= r0 <= 0x7fffff06
-		ldr	r2, .LC0
-		ldr	r2, [r2]		@ max = 0x01ffffff
-		mov	r0, r0, lsr #14		@ max = 0x0001ffff
-		mov	r2, r2, lsr #10		@ max = 0x00007fff
-		mul	r0, r2, r0		@ max = 2^32-1
-		movs	r0, r0, lsr #6
-		moveq	pc, lr
-
-/*
- * loops = r0 * HZ * loops_per_jiffy / 1000000
- *
- * Oh, if only we had a cycle counter...
- */
-
-@ Delay routine
-ENTRY(__delay)
-		subs	r0, r0, #1
-#if 0
-		movls	pc, lr
-		subs	r0, r0, #1
-		movls	pc, lr
-		subs	r0, r0, #1
-		movls	pc, lr
-		subs	r0, r0, #1
-		movls	pc, lr
-		subs	r0, r0, #1
-		movls	pc, lr
-		subs	r0, r0, #1
-		movls	pc, lr
-		subs	r0, r0, #1
-		movls	pc, lr
-		subs	r0, r0, #1
-#endif
-		bhi	__delay
-		mov	pc, lr
-ENDPROC(__udelay)
-ENDPROC(__const_udelay)
-ENDPROC(__delay)
diff --git a/arch/arm/lib/delay.c b/arch/arm/lib/delay.c
new file mode 100644
index 0000000..f92aca0
--- /dev/null
+++ b/arch/arm/lib/delay.c
@@ -0,0 +1,56 @@
+/*
+ *  Originally from linux/arch/arm/lib/delay.S
+ *
+ *  Copyright (C) 1995, 1996 Russell King
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+#include <linux/module.h>
+#include <linux/delay.h>
+
+/*
+ * loops = usecs * HZ * loops_per_jiffy / 1000000
+ *
+ * Oh, if only we had a cycle counter...
+ */
+void __delay(unsigned long loops)
+{
+	asm volatile(
+	"1:	subs %0, %0, #1 \n"
+	"	bhi 1b		\n"
+	: /* No output */
+	: "r" (loops)
+	);
+}
+EXPORT_SYMBOL(__delay);
+
+/*
+ * 0 <= xloops <= 0x7fffff06
+ * loops_per_jiffy <= 0x01ffffff (max. 3355 bogomips)
+ */
+void __const_udelay(unsigned long xloops)
+{
+	unsigned long lpj;
+	unsigned long loops;
+
+	xloops >>= 14;			/* max = 0x01ffffff */
+	lpj = loops_per_jiffy >> 10;	/* max = 0x0001ffff */
+	loops = lpj * xloops;		/* max = 0x00007fff */
+	loops >>= 6;			/* max = 2^32-1 */
+
+	if (likely(loops))
+		__delay(loops);
+}
+EXPORT_SYMBOL(__const_udelay);
+
+/*
+ * usecs  <= 2000
+ * HZ  <= 1000
+ */
+void __udelay(unsigned long usecs)
+{
+	__const_udelay(usecs * ((2199023*HZ)>>11));
+}
+EXPORT_SYMBOL(__udelay);
-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

