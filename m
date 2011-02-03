Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754734Ab1BCXsl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Feb 2011 18:48:41 -0500
Received: from wolverine02.qualcomm.com ([199.106.114.251]:12177 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754378Ab1BCXsi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Feb 2011 18:48:38 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6245"; a="72915107"
From: Stephen Boyd <sboyd@codeaurora.org>
To: Greg KH <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, Arnd Bergmann <arnd@arndb.de>,
        Daniel Walker <dwalker@codeaurora.org>
Subject: [PATCHv2 1/3] hvc_dcc: Fix bad code generation by marking assembly volatile
Date: Thu,  3 Feb 2011 15:48:34 -0800
Message-Id: <1296776916-21018-2-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.7.4.2.g597a6
In-Reply-To: <1296776916-21018-1-git-send-email-sboyd@codeaurora.org>
References: <20110203221742.GA4159@kroah.com>
 <1296776916-21018-1-git-send-email-sboyd@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Without marking the asm __dcc_getstatus() volatile my compiler
decides it can cache the value of __ret in a register and then
check the value of it continually in hvc_dcc_put_chars() (I had
to replace get_wait/put_wait with 1 and fixup the branch
otherwise my disassembler barfed on __dcc_(get|put)char).

00000000 <hvc_dcc_put_chars>:
   0:   ee103e11        mrc     14, 0, r3, cr0, cr1, {0}
   4:   e3a0c000        mov     ip, #0  ; 0x0
   8:   e2033202        and     r3, r3, #536870912      ; 0x20000000
   c:   ea000006        b       2c <hvc_dcc_put_chars+0x2c>
  10:   e3530000        cmp     r3, #0  ; 0x0
  14:   1afffffd        bne     10 <hvc_dcc_put_chars+0x10>
  18:   e7d1000c        ldrb    r0, [r1, ip]
  1c:   ee10fe11        mrc     14, 0, pc, cr0, cr1, {0}
  20:   2afffffd        bcs     1c <hvc_dcc_put_chars+0x1c>
  24:   ee000e15        mcr     14, 0, r0, cr0, cr5, {0}
  28:   e28cc001        add     ip, ip, #1      ; 0x1
  2c:   e15c0002        cmp     ip, r2
  30:   bafffff6        blt     10 <hvc_dcc_put_chars+0x10>
  34:   e1a00002        mov     r0, r2
  38:   e12fff1e        bx      lr

As you can see, the value of the mrc is checked against
DCC_STATUS_TX (bit 29) and then stored in r3 for later use.
Marking the asm volatile produces the following:

00000000 <hvc_dcc_put_chars>:
   0:   e3a03000        mov     r3, #0  ; 0x0
   4:   ea000007        b       28 <hvc_dcc_put_chars+0x28>
   8:   ee100e11        mrc     14, 0, r0, cr0, cr1, {0}
   c:   e3100202        tst     r0, #536870912  ; 0x20000000
  10:   1afffffc        bne     8 <hvc_dcc_put_chars+0x8>
  14:   e7d10003        ldrb    r0, [r1, r3]
  18:   ee10fe11        mrc     14, 0, pc, cr0, cr1, {0}
  1c:   2afffffd        bcs     18 <hvc_dcc_put_chars+0x18>
  20:   ee000e15        mcr     14, 0, r0, cr0, cr5, {0}
  24:   e2833001        add     r3, r3, #1      ; 0x1
  28:   e1530002        cmp     r3, r2
  2c:   bafffff5        blt     8 <hvc_dcc_put_chars+0x8>
  30:   e1a00002        mov     r0, r2
  34:   e12fff1e        bx      lr

which looks better and actually works. Mark all the inline
assembly in this file as volatile since we don't want the
compiler to optimize away these statements or move them around
in any way.

Acked-by: Tony Lindgren <tony@atomide.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Acked-by: Nicolas Pitre <nicolas.pitre@linaro.org>
Cc: Daniel Walker <dwalker@codeaurora.org>
Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---
 drivers/tty/hvc/hvc_dcc.c |   11 +++++------
 1 files changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/tty/hvc/hvc_dcc.c b/drivers/tty/hvc/hvc_dcc.c
index 6470f63..155ec10 100644
--- a/drivers/tty/hvc/hvc_dcc.c
+++ b/drivers/tty/hvc/hvc_dcc.c
@@ -33,8 +33,7 @@
 static inline u32 __dcc_getstatus(void)
 {
 	u32 __ret;
-
-	asm("mrc p14, 0, %0, c0, c1, 0	@ read comms ctrl reg"
+	asm volatile("mrc p14, 0, %0, c0, c1, 0	@ read comms ctrl reg"
 		: "=r" (__ret) : : "cc");
 
 	return __ret;
@@ -46,7 +45,7 @@ static inline char __dcc_getchar(void)
 {
 	char __c;
 
-	asm("get_wait:	mrc p14, 0, pc, c0, c1, 0                          \n\
+	asm volatile("get_wait:	mrc p14, 0, pc, c0, c1, 0                  \n\
 			bne get_wait                                       \n\
 			mrc p14, 0, %0, c0, c5, 0	@ read comms data reg"
 		: "=r" (__c) : : "cc");
@@ -58,7 +57,7 @@ static inline char __dcc_getchar(void)
 {
 	char __c;
 
-	asm("mrc p14, 0, %0, c0, c5, 0	@ read comms data reg"
+	asm volatile("mrc p14, 0, %0, c0, c5, 0	@ read comms data reg"
 		: "=r" (__c));
 
 	return __c;
@@ -68,7 +67,7 @@ static inline char __dcc_getchar(void)
 #if defined(CONFIG_CPU_V7)
 static inline void __dcc_putchar(char c)
 {
-	asm("put_wait:	mrc p14, 0, pc, c0, c1, 0                 \n\
+	asm volatile("put_wait:	mrc p14, 0, pc, c0, c1, 0         \n\
 			bcs put_wait                              \n\
 			mcr p14, 0, %0, c0, c5, 0                   "
 	: : "r" (c) : "cc");
@@ -76,7 +75,7 @@ static inline void __dcc_putchar(char c)
 #else
 static inline void __dcc_putchar(char c)
 {
-	asm("mcr p14, 0, %0, c0, c5, 0	@ write a char"
+	asm volatile("mcr p14, 0, %0, c0, c5, 0	@ write a char"
 		: /* no output register */
 		: "r" (c));
 }
-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

