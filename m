Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751478Ab0LRFQb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Dec 2010 00:16:31 -0500
Received: from wolverine01.qualcomm.com ([199.106.114.254]:10338 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751179Ab0LRFQ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Dec 2010 00:16:28 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6200"; a="67336980"
From: Stephen Boyd <sboyd@codeaurora.org>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, Tony Lindgren <tony@atomide.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Daniel Walker <dwalker@codeaurora.org>
Subject: [PATCH] hvc_dcc: Simplify assembly for v6 and v7 ARM
Date: Fri, 17 Dec 2010 21:16:25 -0800
Message-Id: <1292649385-28771-1-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.7.3.4.516.g15368e
In-Reply-To: <20101201192856.GA731@suse.de>
References: <20101201192856.GA731@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The inline assembly differences for v6 vs. v7 in the hvc_dcc
driver are purely optimizations. On a v7 processor, an mrc with
the pc sets the condition codes to the 28-31 bits of the register
being read. It just so happens that the TX/RX full bits the DCC
driver is testing for are high enough in the register to be put
into the condition codes. On a v6 processor, this "feature" isn't
implemented and thus we have to do the usual read, mask, test
operations to check for TX/RX full.

Since we already test the RX/TX full bits before calling
__dcc_getchar() and __dcc_putchar() we don't actually need to do
anything special for v7 over v6. The only difference is in
hvc_dcc_get_chars(). We would test RX full, poll RX full, and
then read a character from the buffer, whereas now we will test
RX full, read a character from the buffer, and then test RX full
again for the second iteration of the loop. It doesn't seem
possible for the buffer to go from full to empty between testing
the RX full and reading a character. Therefore, replace the v7
versions with the v6 versions and everything works the same.

While we're here, cleanup the for loops a bit and mark the inline
assembly as volatile. Not marking it volatile causes GCC to cache
the results of the status and RX buffer registers causing
lockups.

Cc: Tony Lindgren <tony@atomide.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Nicolas Pitre <nicolas.pitre@linaro.org>
Cc: Daniel Walker <dwalker@codeaurora.org>
Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---
 drivers/char/hvc_dcc.c |   43 +++++++------------------------------------
 1 files changed, 7 insertions(+), 36 deletions(-)

diff --git a/drivers/char/hvc_dcc.c b/drivers/char/hvc_dcc.c
index 6470f63..435f6fa 100644
--- a/drivers/char/hvc_dcc.c
+++ b/drivers/char/hvc_dcc.c
@@ -33,54 +33,29 @@
 static inline u32 __dcc_getstatus(void)
 {
 	u32 __ret;
-
-	asm("mrc p14, 0, %0, c0, c1, 0	@ read comms ctrl reg"
+	asm volatile("mrc p14, 0, %0, c0, c1, 0	@ read comms ctrl reg"
 		: "=r" (__ret) : : "cc");
 
 	return __ret;
 }
 
 
-#if defined(CONFIG_CPU_V7)
 static inline char __dcc_getchar(void)
 {
 	char __c;
 
-	asm("get_wait:	mrc p14, 0, pc, c0, c1, 0                          \n\
-			bne get_wait                                       \n\
-			mrc p14, 0, %0, c0, c5, 0	@ read comms data reg"
-		: "=r" (__c) : : "cc");
-
-	return __c;
-}
-#else
-static inline char __dcc_getchar(void)
-{
-	char __c;
-
-	asm("mrc p14, 0, %0, c0, c5, 0	@ read comms data reg"
+	asm volatile("mrc p14, 0, %0, c0, c5, 0	@ read comms data reg"
 		: "=r" (__c));
 
 	return __c;
 }
-#endif
 
-#if defined(CONFIG_CPU_V7)
-static inline void __dcc_putchar(char c)
-{
-	asm("put_wait:	mrc p14, 0, pc, c0, c1, 0                 \n\
-			bcs put_wait                              \n\
-			mcr p14, 0, %0, c0, c5, 0                   "
-	: : "r" (c) : "cc");
-}
-#else
 static inline void __dcc_putchar(char c)
 {
-	asm("mcr p14, 0, %0, c0, c5, 0	@ write a char"
+	asm volatile("mcr p14, 0, %0, c0, c5, 0	@ write a char"
 		: /* no output register */
 		: "r" (c));
 }
-#endif
 
 static int hvc_dcc_put_chars(uint32_t vt, const char *buf, int count)
 {
@@ -90,7 +65,7 @@ static int hvc_dcc_put_chars(uint32_t vt, const char *buf, int count)
 		while (__dcc_getstatus() & DCC_STATUS_TX)
 			cpu_relax();
 
-		__dcc_putchar((char)(buf[i] & 0xFF));
+		__dcc_putchar(buf[i]);
 	}
 
 	return count;
@@ -100,15 +75,11 @@ static int hvc_dcc_get_chars(uint32_t vt, char *buf, int count)
 {
 	int i;
 
-	for (i = 0; i < count; ++i) {
-		int c = -1;
-
+	for (i = 0; i < count; ++i)
 		if (__dcc_getstatus() & DCC_STATUS_RX)
-			c = __dcc_getchar();
-		if (c < 0)
+			buf[i] = __dcc_getchar();
+		else
 			break;
-		buf[i] = c;
-	}
 
 	return i;
 }
-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

