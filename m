Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754803Ab1BCXsm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Feb 2011 18:48:42 -0500
Received: from wolverine01.qualcomm.com ([199.106.114.254]:29863 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754383Ab1BCXsj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Feb 2011 18:48:39 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6245"; a="73123027"
From: Stephen Boyd <sboyd@codeaurora.org>
To: Greg KH <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, Arnd Bergmann <arnd@arndb.de>,
        Daniel Walker <dwalker@codeaurora.org>
Subject: [PATCHv2 3/3] hvc_dcc: Simplify assembly for v6 and v7 ARM
Date: Thu,  3 Feb 2011 15:48:36 -0800
Message-Id: <1296776916-21018-4-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.7.4.2.g597a6
In-Reply-To: <1296776916-21018-1-git-send-email-sboyd@codeaurora.org>
References: <20110203221742.GA4159@kroah.com>
 <1296776916-21018-1-git-send-email-sboyd@codeaurora.org>
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

Acked-by: Tony Lindgren <tony@atomide.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Acked-by: Nicolas Pitre <nicolas.pitre@linaro.org>
Cc: Daniel Walker <dwalker@codeaurora.org>
Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---
 drivers/tty/hvc/hvc_dcc.c |   24 ------------------------
 1 files changed, 0 insertions(+), 24 deletions(-)

diff --git a/drivers/tty/hvc/hvc_dcc.c b/drivers/tty/hvc/hvc_dcc.c
index ad23cc8..435f6fa 100644
--- a/drivers/tty/hvc/hvc_dcc.c
+++ b/drivers/tty/hvc/hvc_dcc.c
@@ -40,19 +40,6 @@ static inline u32 __dcc_getstatus(void)
 }
 
 
-#if defined(CONFIG_CPU_V7)
-static inline char __dcc_getchar(void)
-{
-	char __c;
-
-	asm volatile("get_wait:	mrc p14, 0, pc, c0, c1, 0                  \n\
-			bne get_wait                                       \n\
-			mrc p14, 0, %0, c0, c5, 0	@ read comms data reg"
-		: "=r" (__c) : : "cc");
-
-	return __c;
-}
-#else
 static inline char __dcc_getchar(void)
 {
 	char __c;
@@ -62,24 +49,13 @@ static inline char __dcc_getchar(void)
 
 	return __c;
 }
-#endif
 
-#if defined(CONFIG_CPU_V7)
-static inline void __dcc_putchar(char c)
-{
-	asm volatile("put_wait:	mrc p14, 0, pc, c0, c1, 0         \n\
-			bcs put_wait                              \n\
-			mcr p14, 0, %0, c0, c5, 0                   "
-	: : "r" (c) : "cc");
-}
-#else
 static inline void __dcc_putchar(char c)
 {
 	asm volatile("mcr p14, 0, %0, c0, c5, 0	@ write a char"
 		: /* no output register */
 		: "r" (c));
 }
-#endif
 
 static int hvc_dcc_put_chars(uint32_t vt, const char *buf, int count)
 {
-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

