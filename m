Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751428Ab2CEVGd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2012 16:06:33 -0500
Received: from a.ns.miles-group.at ([95.130.255.143]:47834 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750868Ab2CEVGc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2012 16:06:32 -0500
From: Richard Weinberger <richard@nod.at>
To: jonas@southpole.se
Cc: linux@openrisc.net, linux-kernel@vger.kernel.org,
        Richard Weinberger <richard@nod.at>
Subject: [PATCH] OpenRISC: Handle r0 with care
Date: Mon,  5 Mar 2012 22:07:07 +0100
Message-Id: <1330981627-16121-1-git-send-email-richard@nod.at>
X-Mailer: git-send-email 1.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Depending on the OpenRISC implementation a rough task may able
to change r0 and corrupt other taks.
Handle this case by setting r0 to zero on each entry point.
Also ensure that r0 is really zero before jumping into _start.

Signed-off-by: Richard Weinberger <richard@nod.at>

diff --git a/arch/openrisc/kernel/entry.S b/arch/openrisc/kernel/entry.S
index d5f9c35..7c9c4f6 100644
--- a/arch/openrisc/kernel/entry.S
+++ b/arch/openrisc/kernel/entry.S
@@ -130,6 +130,7 @@ handler:							;\
 #define UNHANDLED_EXCEPTION(handler,vector)			\
 	.global	handler						;\
 handler:							;\
+	l.andi	r0,r0,0						;\
 	/* r1, EPCR, ESR already saved */			;\
 	l.sw    PT_GPR2(r1),r2					;\
 	l.sw    PT_GPR3(r1),r3					;\
@@ -185,8 +186,8 @@ handler:							;\
 /* ---[ 0x100: RESET exception ]----------------------------------------- */
 
 EXCEPTION_ENTRY(_tng_kernel_start)
+	l.andi r0,r0,0
 	l.jal	_start
-	 l.andi r0,r0,0
 
 /* ---[ 0x200: BUS exception ]------------------------------------------- */
 
@@ -976,6 +977,7 @@ ENTRY(_kernel_thread_helper)
 
 	.align 0x400
 ENTRY(_switch)
+	l.andi	r0,r0,0
 	/* We don't store SR as _switch only gets called in a context where
 	 * the SR will be the same going in and coming out... */
 
diff --git a/arch/openrisc/kernel/head.S b/arch/openrisc/kernel/head.S
index c75018d..c439324 100644
--- a/arch/openrisc/kernel/head.S
+++ b/arch/openrisc/kernel/head.S
@@ -152,6 +152,7 @@
  */
 
 #define EXCEPTION_HANDLE(handler)				\
+	l.andi	r0,r0,0						;\
 	EXCEPTION_T_STORE_GPR30					;\
 	l.mfspr r30,r0,SPR_ESR_BASE				;\
 	l.andi  r30,r30,SPR_SR_SM				;\
-- 
1.7.6

