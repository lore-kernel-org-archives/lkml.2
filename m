Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932686Ab1ISWNQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Sep 2011 18:13:16 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:60724 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932258Ab1ISWNP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Sep 2011 18:13:15 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6474"; a="119911948"
From: Laura Abbott <lauraa@codeaurora.org>
To: linux@arm.linux.org.uk, catalin.marinas@arm.com
Cc: Laura Abbott <lauraa@codeaurora.org>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH] arm: Add unwinding annotations for 64bit division functions
Date: Mon, 19 Sep 2011 15:11:37 -0700
Message-Id: <1316470297-5063-1-git-send-email-lauraa@codeaurora.org>
X-Mailer: git-send-email 1.7.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The 64bit division functions never had unwinding annotations
added. This prevents a backtrace from being printed within
the function and if a division by 0 occurs. Add the annotations.

Signed-off-by: Laura Abbott <lauraa@codeaurora.org>
---
 arch/arm/lib/div64.S |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/arch/arm/lib/div64.S b/arch/arm/lib/div64.S
index faa7748..e55c484 100644
--- a/arch/arm/lib/div64.S
+++ b/arch/arm/lib/div64.S
@@ -13,6 +13,7 @@
  */
 
 #include <linux/linkage.h>
+#include <asm/unwind.h>
 
 #ifdef __ARMEB__
 #define xh r0
@@ -44,6 +45,7 @@
  */
 
 ENTRY(__do_div64)
+UNWIND(.fnstart)
 
 	@ Test for easy paths first.
 	subs	ip, r4, #1
@@ -189,7 +191,12 @@ ENTRY(__do_div64)
 	moveq	yh, xh
 	moveq	xh, #0
 	moveq	pc, lr
+UNWIND(.fnend)
 
+UNWIND(.fnstart)
+UNWIND(.pad #4)
+UNWIND(.save {lr})
+Ldiv0_64:
 	@ Division by 0:
 	str	lr, [sp, #-8]!
 	bl	__div0
@@ -200,4 +207,5 @@ ENTRY(__do_div64)
 	mov	xh, #0
 	ldr	pc, [sp], #8
 
+UNWIND(.fnend)
 ENDPROC(__do_div64)
-- 
1.7.3.3

