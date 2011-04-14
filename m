Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933551Ab1DNRvF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 13:51:05 -0400
Received: from mail.windriver.com ([147.11.1.11]:38562 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933450Ab1DNRrW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 13:47:22 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, James Jones <jajones@nvidia.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 097/209] ARM: 6482/2: Fix find_next_zero_bit and related assembly
Date: Thu, 14 Apr 2011 13:42:07 -0400
Message-Id: <1302803039-9400-98-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1302803039-9400-1-git-send-email-paul.gortmaker@windriver.com>
References: <1302803039-9400-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: James Jones <jajones@nvidia.com>

  =====================================================================
  | This is a commit scheduled for the next v2.6.34 longterm release. |
  | If you see a problem with using this for longterm, please comment.|
  =====================================================================

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
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
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
1.7.4.4

