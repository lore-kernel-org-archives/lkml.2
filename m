Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932501Ab0IGSYF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Sep 2010 14:24:05 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:19418 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932437Ab0IGSX6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Sep 2010 14:23:58 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6098"; a="53653572"
From: Stephen Boyd <sboyd@codeaurora.org>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Russell King <linux@arm.linux.org.uk>,
        Saravana Kannan <skannan@codeaurora.org>,
        Colin Cross <ccross@android.com>,
        Kevin Hilman <khilman@deeprootsystems.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>
Subject: [PATCH 2/3] [ARM] Allow machines to override __delay()
Date: Tue,  7 Sep 2010 11:23:53 -0700
Message-Id: <1283883834-4693-3-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.7.2.2.177.geec0d
In-Reply-To: <1283883834-4693-1-git-send-email-sboyd@codeaurora.org>
References: <1283883834-4693-1-git-send-email-sboyd@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some machines want to implement their own __delay() routine based
on fixed timers. Expose functionality to set the __delay()
routine at runtime. This should allow two machines with different
__delay() routines to happily co-exist within the same kernel
with minimal overhead.

Russell expressed concern that using a timer based __delay()
would cause problems where an iomapped device isn't mapped in
before a delay call was made (see
http://article.gmane.org/gmane.linux.ports.arm.kernel/78543 for
more info). We can sidestep that issue with this approach since
the __delay() routine _should_ only be pointed to a timer based
delay once the timer has been properly mapped. Up until that
point __delay() and udelay() will use delay_loop() which is
always safe to call.

This patch is inspired by x86's delay.c

Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
Reviewed-by: Saravana Kannan <skannan@codeaurora.org>
---
 arch/arm/include/asm/delay.h |    2 ++
 arch/arm/lib/delay.c         |   21 ++++++++++++++++++---
 2 files changed, 20 insertions(+), 3 deletions(-)

diff --git a/arch/arm/include/asm/delay.h b/arch/arm/include/asm/delay.h
index ccc5ed5..7c732b5 100644
--- a/arch/arm/include/asm/delay.h
+++ b/arch/arm/include/asm/delay.h
@@ -40,5 +40,7 @@ extern void __const_udelay(unsigned long);
 			__const_udelay((n) * ((2199023U*HZ)>>11))) :	\
 	  __udelay(n))
 
+extern void set_delay_fn(void (*fn)(unsigned long));
+
 #endif /* defined(_ARM_DELAY_H) */
 
diff --git a/arch/arm/lib/delay.c b/arch/arm/lib/delay.c
index 5ee0adc..b307fcc 100644
--- a/arch/arm/lib/delay.c
+++ b/arch/arm/lib/delay.c
@@ -3,6 +3,8 @@
  *
  *  Copyright (C) 1995, 1996 Russell King
  *  Copyright (c) 2010, Code Aurora Forum. All rights reserved.
+ *  Copyright (C) 1993 Linus Torvalds
+ *  Copyright (C) 1997 Martin Mares <mj@atrey.karlin.mff.cuni.cz>
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
@@ -12,11 +14,9 @@
 #include <linux/delay.h>
 
 /*
- * loops = usecs * HZ * loops_per_jiffy / 1000000
- *
  * Oh, if only we had a cycle counter...
  */
-void __delay(unsigned long loops)
+void delay_loop(unsigned long loops)
 {
 	asm volatile(
 	"1:	subs %0, %0, #1 \n"
@@ -25,6 +25,21 @@ void __delay(unsigned long loops)
 	: "r" (loops)
 	);
 }
+
+static void (*delay_fn)(unsigned long) = delay_loop;
+
+void set_delay_fn(void (*fn)(unsigned long))
+{
+	delay_fn = fn;
+}
+
+/*
+ * loops = usecs * HZ * loops_per_jiffy / 1000000
+ */
+void __delay(unsigned long loops)
+{
+	delay_fn(loops);
+}
 EXPORT_SYMBOL(__delay);
 
 /*
-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

