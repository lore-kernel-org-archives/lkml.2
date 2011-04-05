Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753775Ab1DEX4r (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Apr 2011 19:56:47 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:53839 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752469Ab1DEX4o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Apr 2011 19:56:44 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6307"; a="84178493"
From: Stephen Boyd <sboyd@codeaurora.org>
To: Russell King <linux@arm.linux.org.uk>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Saravana Kannan <skannan@codeaurora.org>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mattias Wallin <Mattias.Wallin@stericsson.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCHv5 2/3] ARM: Allow machines to override __delay()
Date: Tue,  5 Apr 2011 16:56:39 -0700
Message-Id: <1302047800-26720-3-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.7.5.rc0.131.gfa38c
In-Reply-To: <1302047800-26720-1-git-send-email-sboyd@codeaurora.org>
References: <1302047800-26720-1-git-send-email-sboyd@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some machines want to implement their own __delay() routine based
on fixed rate timers. Expose functionality to set the __delay()
routine at runtime. This should allow two machines with different
__delay() routines to happily co-exist within the same kernel
with minimal overhead.

Russell expressed concern that using a timer based __delay()
would cause problems when an iomapped device isn't mapped in
prior to a delay call being made (see
http://article.gmane.org/gmane.linux.ports.arm.kernel/78543 for
more info). We can sidestep that issue with this approach since
the __delay() routine _should_ only be pointed to a timer based
delay once the timer has been properly mapped. Up until that
point __delay() and udelay() will use delay_loop() which is
always safe to call.

This patch is inspired by x86's delay.c

Reviewed-by: Saravana Kannan <skannan@codeaurora.org>
Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---
 arch/arm/include/asm/delay.h |    7 +++++++
 arch/arm/lib/delay.c         |   14 +++++++++++---
 2 files changed, 18 insertions(+), 3 deletions(-)

diff --git a/arch/arm/include/asm/delay.h b/arch/arm/include/asm/delay.h
index ccc5ed5..82ef82a 100644
--- a/arch/arm/include/asm/delay.h
+++ b/arch/arm/include/asm/delay.h
@@ -40,5 +40,12 @@ extern void __const_udelay(unsigned long);
 			__const_udelay((n) * ((2199023U*HZ)>>11))) :	\
 	  __udelay(n))
 
+extern void (*delay_fn)(unsigned long);
+
+static inline void set_delay_fn(void (*fn)(unsigned long))
+{
+	delay_fn = fn;
+}
+
 #endif /* defined(_ARM_DELAY_H) */
 
diff --git a/arch/arm/lib/delay.c b/arch/arm/lib/delay.c
index daca2be..42cda15 100644
--- a/arch/arm/lib/delay.c
+++ b/arch/arm/lib/delay.c
@@ -11,11 +11,9 @@
 #include <linux/delay.h>
 
 /*
- * loops = usecs * HZ * loops_per_jiffy / 1000000
- *
  * Oh, if only we had a cycle counter...
  */
-void __delay(unsigned long loops)
+static void delay_loop(unsigned long loops)
 {
 	asm volatile(
 	"1:	subs %0, %0, #1 \n"
@@ -24,6 +22,16 @@ void __delay(unsigned long loops)
 	: "r" (loops)
 	);
 }
+
+void (*delay_fn)(unsigned long) = delay_loop;
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

