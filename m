Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752318Ab2CLRke (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 13:40:34 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:4019 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751363Ab2CLRkc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 13:40:32 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6647"; a="171735649"
From: Laura Abbott <lauraa@codeaurora.org>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        dave.martin@linaro.org, nicolas.pitre@linaro.org,
        catalin.marinas@arm.com
Cc: linux-arm-msm@vger.kernel.org, Laura Abbott <lauraa@codeaurora.org>
Subject: [PATCH] arm: Add unwinding support for memset and memzero.
Date: Mon, 12 Mar 2012 10:40:27 -0700
Message-Id: <1331574027-28542-1-git-send-email-lauraa@codeaurora.org>
X-Mailer: git-send-email 1.7.8.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Both memset and memzero lack unwinding annoations. If
an abort occurs trying to access the pointer, the backtrace
is incomplete. Add unwinding annotations to both functions
so we can actually get a useful backtrace.

Signed-off-by: Laura Abbott <lauraa@codeaurora.org>
---
 arch/arm/lib/memset.S  |    7 +++++--
 arch/arm/lib/memzero.S |    7 +++++--
 2 files changed, 10 insertions(+), 4 deletions(-)

diff --git a/arch/arm/lib/memset.S b/arch/arm/lib/memset.S
index 650d592..4379912 100644
--- a/arch/arm/lib/memset.S
+++ b/arch/arm/lib/memset.S
@@ -11,6 +11,7 @@
  */
 #include <linux/linkage.h>
 #include <asm/assembler.h>
+#include <asm/unwind.h>
 
 	.text
 	.align	5
@@ -29,6 +30,7 @@
  */
 
 ENTRY(memset)
+UNWIND(.fnstart)
 	ands	r3, r0, #3		@ 1 unaligned?
 	bne	1b			@ 1
 /*
@@ -41,7 +43,7 @@ ENTRY(memset)
 	blt	4f
 
 #if ! CALGN(1)+0
-
+UNWIND(.save {lr})
 /*
  * We need an extra register for this loop - save the return address and
  * use the LR
@@ -68,7 +70,7 @@ ENTRY(memset)
 	ldr	lr, [sp], #4
 
 #else
-
+UNWIND(.save {r4, r5, r6, r7, lr})
 /*
  * This version aligns the destination pointer in order to write
  * whole cache lines at once.
@@ -124,4 +126,5 @@ ENTRY(memset)
 	tst	r2, #1
 	strneb	r1, [r0], #1
 	mov	pc, lr
+UNWIND(.fnend)
 ENDPROC(memset)
diff --git a/arch/arm/lib/memzero.S b/arch/arm/lib/memzero.S
index 3fbdef5..26f9ce8 100644
--- a/arch/arm/lib/memzero.S
+++ b/arch/arm/lib/memzero.S
@@ -9,6 +9,7 @@
  */
 #include <linux/linkage.h>
 #include <asm/assembler.h>
+#include <asm/unwind.h>
 
 	.text
 	.align	5
@@ -31,6 +32,7 @@
  */
 
 ENTRY(__memzero)
+UNWIND(.fnstart)
 	mov	r2, #0			@ 1
 	ands	r3, r0, #3		@ 1 unaligned?
 	bne	1b			@ 1
@@ -41,7 +43,7 @@ ENTRY(__memzero)
 	blt	4f			@ 1 have < 16 bytes
 
 #if ! CALGN(1)+0
-
+UNWIND(.save {lr})
 /*
  * We need an extra register for this loop - save the return address and
  * use the LR
@@ -68,7 +70,7 @@ ENTRY(__memzero)
 	ldr	lr, [sp], #4		@ 1
 
 #else
-
+UNWIND(.save{r4, r5, r6, r7})
 /*
  * This version aligns the destination pointer in order to write
  * whole cache lines at once.
@@ -122,4 +124,5 @@ ENTRY(__memzero)
 	tst	r1, #1			@ 1 a byte left over
 	strneb	r2, [r0], #1		@ 1
 	mov	pc, lr			@ 1
+UNWIND(.fnend)
 ENDPROC(__memzero)
-- 
1.7.8.3

