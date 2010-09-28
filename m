Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760697Ab0I1Ddx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Sep 2010 23:33:53 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:31779 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758089Ab0I1Ddu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Sep 2010 23:33:50 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6119"; a="55810525"
From: Stephen Boyd <sboyd@codeaurora.org>
To: Russell King <linux@arm.linux.org.uk>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-arm-msm@vger.kernel.org, Daniel Walker <dwalker@codeaurora.org>,
        Saravana Kannan <skannan@codeaurora.org>,
        Colin Cross <ccross@android.com>,
        Kevin Hilman <khilman@deeprootsystems.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>
Subject: [PATCH 1/3] [ARM] Translate delay.S into (mostly) C
Date: Mon, 27 Sep 2010 20:33:45 -0700
Message-Id: <1285644827-6846-2-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.7.3
In-Reply-To: <1285644827-6846-1-git-send-email-sboyd@codeaurora.org>
References: <1285644827-6846-1-git-send-email-sboyd@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In the next patch we're going to allow machines to override the
__delay() implementation at runtime so they can implement a timer
based __delay() routine. It's easier to do this using C, so lets
write udelay and friends in C.

We lose the #if 0 code, which according to Russell is used "to
make the delay loop more stable and predictable on older CPUs"
(see http://article.gmane.org/gmane.linux.kernel/888867 for more
info). We shouldn't be too worried though, since the next patch
adds functionality to allow a machine to set the __delay() loop
themselves, therefore allowing machines to resurrect the
commented out code if they need it.

bloat-o-meter shows an increase of 12 bytes. Further inspection
of the assembly shows GCC copying the loops_per_jiffy pointer and
the magic HZ value to the ends of __const_udelay() and _delay()
thus contributing an extra 4 and 8 bytes of data to each
function. These two values weren't taken into account in the
delay.S version since they weren't part of the function in nm's
eyes. This means we only really gained an extra 4 bytes due to
GCC's decision to duplicate the loops_per_jiffy pointer in
__const_udelay.

 $ scripts/bloat-o-meter vmlinux.orig vmlinux.new
 add/remove: 0/0 grow/shrink: 2/0 up/down: 12/0 (12)
 function                                     old     new   delta
 __udelay                                      48      56      +8
 __const_udelay                                40      44      +4

Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
Reviewed-by: Saravana Kannan <skannan@codeaurora.org>
---

So maybe we can make the magic HZ value into a #define? UDELAY_SCALAR?
UDELAY_MAGIC?

 arch/arm/include/asm/delay.h |    2 +-
 arch/arm/kernel/armksyms.c   |    4 --
 arch/arm/lib/delay.S         |   65 ------------------------------------------
 arch/arm/lib/delay.c         |   57 ++++++++++++++++++++++++++++++++++++
 4 files changed, 58 insertions(+), 70 deletions(-)
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
index 8214bfe..259e549 100644
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
index 0000000..5ee0adc
--- /dev/null
+++ b/arch/arm/lib/delay.c
@@ -0,0 +1,57 @@
+/*
+ *  Originally from linux/arch/arm/lib/delay.S
+ *
+ *  Copyright (C) 1995, 1996 Russell King
+ *  Copyright (c) 2010, Code Aurora Forum. All rights reserved.
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
+	if (loops)
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

