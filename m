Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755436Ab0LLX4w (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Dec 2010 18:56:52 -0500
Received: from one.firstfloor.org ([213.235.205.2]:36688 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755871Ab0LLXsK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Dec 2010 18:48:10 -0500
From: Andi Kleen <andi@firstfloor.org>
References: <201012131244.547034648@firstfloor.org>
In-Reply-To: <201012131244.547034648@firstfloor.org>
To: jajones@nvidia.com, nicolas.pitre@linaro.org, swarren@nvidia.com,
        rmk+kernel@arm.linux.org.uk, gregkh@suse.de, ak@linux.intel.com,
        linux-kernel@vger.kernel.org, stable@kernel.org
Subject: [PATCH] [183/223] ARM: 6482/2: Fix find_next_zero_bit and related assembly
Message-Id: <20101212234808.8DA66B27BF@basil.firstfloor.org>
Date: Mon, 13 Dec 2010 00:48:08 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: James Jones <jajones@nvidia.com>

commit 0e91ec0c06d2cd15071a6021c94840a50e6671aa upstream.

The find_next_bit, find_first_bit, find_next_zero_bit
and find_first_zero_bit functions were not properly
clamping to the maxbit argument at the bit level. They
were instead only checking maxbit at the byte level.
To fix this, add a compare and a conditional move
instruction to the end of the common bit-within-the-
byte code used by all the functions and be sure not to
clobber the maxbit argument before it is used.

Reviewed-by: Nicolas Pitre <nicolas.pitre@linaro.org>
Tested-by: Stephen Warren <swarren@nvidia.com>
Signed-off-by: James Jones <jajones@nvidia.com>
Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 arch/arm/lib/findbit.S |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

Index: linux/arch/arm/lib/findbit.S
===================================================================
--- linux.orig/arch/arm/lib/findbit.S
+++ linux/arch/arm/lib/findbit.S
@@ -174,8 +174,8 @@ ENDPROC(_find_next_bit_be)
  */
 .L_found:
 #if __LINUX_ARM_ARCH__ >= 5
-		rsb	r1, r3, #0
-		and	r3, r3, r1
+		rsb	r0, r3, #0
+		and	r3, r3, r0
 		clz	r3, r3
 		rsb	r3, r3, #31
 		add	r0, r2, r3
@@ -190,5 +190,7 @@ ENDPROC(_find_next_bit_be)
 		addeq	r2, r2, #1
 		mov	r0, r2
 #endif
+		cmp	r1, r0			@ Clamp to maxbit
+		movlo	r0, r1
 		mov	pc, lr
 
