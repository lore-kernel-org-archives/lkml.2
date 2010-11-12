Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757329Ab0KLBR1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Nov 2010 20:17:27 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:6215 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754001Ab0KLBR0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Nov 2010 20:17:26 -0500
X-PGP-Universal: processed;
	by hqnvupgp04.nvidia.com on Thu, 11 Nov 2010 17:17:25 -0800
From: James Jones <jajones@nvidia.com>
To: Russell King <linux@arm.linux.org.uk>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        James Jones <jajones@nvidia.com>
Subject: [PATCH] ARM: Fix find_next_zero_bit and related assembly
Date: Thu, 11 Nov 2010 17:16:55 -0800
Message-Id: <1289524615-22484-1-git-send-email-jajones@nvidia.com>
X-Mailer: git-send-email 1.7.1
X-NVConfidentiality: public
X-OriginalArrivalTime: 12 Nov 2010 01:17:20.0096 (UTC) FILETIME=[5A43B600:01CB8207]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The find_next_bit, find_first_bit, find_next_zero_bit
and find_first_zero_bit functions were not properly
clamping to the maxbit argument at the bit level. They
were instead only checking maxbit at the byte level.
To fix this, add a compare and a conditional move
instruction to the end of the common bit-within-the-
byte code used by all the functions and be sure not to
clobber the maxbit argument before it is used.

Signed-off-by: James Jones <jajones@nvidia.com>
Tested-by: Stephen Warren <swarren@nvidia.com>
---
 arch/arm/lib/findbit.S |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/arm/lib/findbit.S b/arch/arm/lib/findbit.S
index 1e4cbd4..64f6bc1 100644
--- a/arch/arm/lib/findbit.S
+++ b/arch/arm/lib/findbit.S
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
 
-- 
1.7.1

