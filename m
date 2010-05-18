Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758610Ab0ERSP1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 May 2010 14:15:27 -0400
Received: from mail-out.m-online.net ([212.18.0.9]:46363 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754149Ab0ERSPZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 May 2010 14:15:25 -0400
From: Andreas Schwab <schwab@linux-m68k.org>
To: linuxppc-dev@ozlabs.org
Subject: [PATCH] powerpc: Fix string library functions
CC: linux-kernel@vger.kernel.org
X-Yow: While I'm in LEVITTOWN I thought I'd like to see the NUCLEAR FAMILY!!
Date: Tue, 18 May 2010 20:15:21 +0200
Message-ID: <m2bpcdjcue.fsf@igel.home>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The powerpc strncmp implementation does not correctly handle a zero
length, despite the claim in 0119536cd314ef95553604208c25bc35581f7f0a
(Add hand-coded assembly strcmp).

Additionally, all the length arguments are size_t, not int, so use
PPC_LCMPI and eq instead of cmpwi and le throughout.

Signed-off-by: Andreas Schwab <schwab@linux-m68k.org>
---
 arch/powerpc/lib/string.S |   18 ++++++++++--------
 1 files changed, 10 insertions(+), 8 deletions(-)

diff --git a/arch/powerpc/lib/string.S b/arch/powerpc/lib/string.S
index 64e2e49..455881a 100644
--- a/arch/powerpc/lib/string.S
+++ b/arch/powerpc/lib/string.S
@@ -28,7 +28,7 @@ _GLOBAL(strcpy)
 /* This clears out any unused part of the destination buffer,
    just as the libc version does.  -- paulus */
 _GLOBAL(strncpy)
-	cmpwi	0,r5,0
+	PPC_LCMPI 0,r5,0
 	beqlr
 	mtctr	r5
 	addi	r6,r3,-1
@@ -39,7 +39,7 @@ _GLOBAL(strncpy)
 	bdnzf	2,1b		/* dec ctr, branch if ctr != 0 && !cr0.eq */
 	bnelr			/* if we didn't hit a null char, we're done */
 	mfctr	r5
-	cmpwi	0,r5,0		/* any space left in destination buffer? */
+	PPC_LCMPI 0,r5,0	/* any space left in destination buffer? */
 	beqlr			/* we know r0 == 0 here */
 2:	stbu	r0,1(r6)	/* clear it out if so */
 	bdnz	2b
@@ -70,8 +70,8 @@ _GLOBAL(strcmp)
 	blr
 
 _GLOBAL(strncmp)
-	PPC_LCMPI r5,0
-	beqlr
+	PPC_LCMPI 0,r5,0
+	beq-	2f
 	mtctr	r5
 	addi	r5,r3,-1
 	addi	r4,r4,-1
@@ -82,6 +82,8 @@ _GLOBAL(strncmp)
 	beqlr	1
 	bdnzt	eq,1b
 	blr
+2:	li	r3,0
+	blr
 
 _GLOBAL(strlen)
 	addi	r4,r3,-1
@@ -92,8 +94,8 @@ _GLOBAL(strlen)
 	blr
 
 _GLOBAL(memcmp)
-	cmpwi	0,r5,0
-	ble-	2f
+	PPC_LCMPI 0,r5,0
+	beq-	2f
 	mtctr	r5
 	addi	r6,r3,-1
 	addi	r4,r4,-1
@@ -106,8 +108,8 @@ _GLOBAL(memcmp)
 	blr
 
 _GLOBAL(memchr)
-	cmpwi	0,r5,0
-	ble-	2f
+	PPC_LCMPI 0,r5,0
+	beq-	2f
 	mtctr	r5
 	addi	r3,r3,-1
 1:	lbzu	r0,1(r3)
-- 
1.7.1

-- 
Andreas Schwab, schwab@linux-m68k.org
GPG Key fingerprint = 58CA 54C7 6D53 942B 1756  01D3 44D5 214B 8276 4ED5
"And now for something completely different."
