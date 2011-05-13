Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759114Ab1EMBZR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 May 2011 21:25:17 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:28919 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759089Ab1EMBZQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 May 2011 21:25:16 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6344"; a="90929161"
From: Laura Abbott <lauraa@codeaurora.org>
To: linux@arm.linux.org.uk
Cc: Laura Abbott <lauraa@codeaurora.org>,
        linux-arm-kernel@lists.infradead.org (open list:ARM PORT),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH] arm: Add unwinding support for division functions
Date: Thu, 12 May 2011 18:24:53 -0700
Message-Id: <1305249893-3427-1-git-send-email-lauraa@codeaurora.org>
X-Mailer: git-send-email 1.7.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The software division functions never had unwinding annotations
added. Currently, when a division by zero occurs the backtrace shown
will stop at Ldiv0 or some completely unrelated function. Add
unwinding annotations in hopes of getting a more useful backtrace
when a division by zero occurs.

Signed-off-by: Laura Abbott <lauraa@codeaurora.org>
---
 arch/arm/lib/lib1funcs.S |   27 +++++++++++++++++++++------
 1 files changed, 21 insertions(+), 6 deletions(-)

diff --git a/arch/arm/lib/lib1funcs.S b/arch/arm/lib/lib1funcs.S
index 6dc0648..63b75df 100644
--- a/arch/arm/lib/lib1funcs.S
+++ b/arch/arm/lib/lib1funcs.S
@@ -35,7 +35,7 @@ Boston, MA 02111-1307, USA.  */
 
 #include <linux/linkage.h>
 #include <asm/assembler.h>
-
+#include <asm/unwind.h>
 
 .macro ARM_DIV_BODY dividend, divisor, result, curbit
 
@@ -207,6 +207,7 @@ Boston, MA 02111-1307, USA.  */
 
 ENTRY(__udivsi3)
 ENTRY(__aeabi_uidiv)
+UNWIND(.fnstart)
 
 	subs	r2, r1, #1
 	moveq	pc, lr
@@ -230,10 +231,12 @@ ENTRY(__aeabi_uidiv)
 	mov	r0, r0, lsr r2
 	mov	pc, lr
 
+UNWIND(.fnend)
 ENDPROC(__udivsi3)
 ENDPROC(__aeabi_uidiv)
 
 ENTRY(__umodsi3)
+UNWIND(.fnstart)
 
 	subs	r2, r1, #1			@ compare divisor with 1
 	bcc	Ldiv0
@@ -247,10 +250,12 @@ ENTRY(__umodsi3)
 
 	mov	pc, lr
 
+UNWIND(.fnend)
 ENDPROC(__umodsi3)
 
 ENTRY(__divsi3)
 ENTRY(__aeabi_idiv)
+UNWIND(.fnstart)
 
 	cmp	r1, #0
 	eor	ip, r0, r1			@ save the sign of the result.
@@ -287,10 +292,12 @@ ENTRY(__aeabi_idiv)
 	rsbmi	r0, r0, #0
 	mov	pc, lr
 
+UNWIND(.fnend)
 ENDPROC(__divsi3)
 ENDPROC(__aeabi_idiv)
 
 ENTRY(__modsi3)
+UNWIND(.fnstart)
 
 	cmp	r1, #0
 	beq	Ldiv0
@@ -310,11 +317,14 @@ ENTRY(__modsi3)
 	rsbmi	r0, r0, #0
 	mov	pc, lr
 
+UNWIND(.fnend)
 ENDPROC(__modsi3)
 
 #ifdef CONFIG_AEABI
 
 ENTRY(__aeabi_uidivmod)
+UNWIND(.fnstart)
+UNWIND(.save {r0, r1, ip, lr}	)
 
 	stmfd	sp!, {r0, r1, ip, lr}
 	bl	__aeabi_uidiv
@@ -323,10 +333,12 @@ ENTRY(__aeabi_uidivmod)
 	sub	r1, r1, r3
 	mov	pc, lr
 
+UNWIND(.fnend)
 ENDPROC(__aeabi_uidivmod)
 
 ENTRY(__aeabi_idivmod)
-
+UNWIND(.fnstart)
+UNWIND(.save {r0, r1, ip, lr}	)
 	stmfd	sp!, {r0, r1, ip, lr}
 	bl	__aeabi_idiv
 	ldmfd	sp!, {r1, r2, ip, lr}
@@ -334,15 +346,18 @@ ENTRY(__aeabi_idivmod)
 	sub	r1, r1, r3
 	mov	pc, lr
 
+UNWIND(.fnend)
 ENDPROC(__aeabi_idivmod)
 
 #endif
 
-Ldiv0:
-
+ENTRY(Ldiv0)
+UNWIND(.fnstart)
+UNWIND(.pad #4)
+UNWIND(.save {lr})
 	str	lr, [sp, #-8]!
 	bl	__div0
 	mov	r0, #0			@ About as wrong as it could be.
 	ldr	pc, [sp], #8
-
-
+UNWIND(.fnend)
+ENDPROC(Ldiv0)
-- 
1.7.3.3

