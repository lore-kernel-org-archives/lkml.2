Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752866Ab0KNELb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Nov 2010 23:11:31 -0500
Received: from mail-pv0-f174.google.com ([74.125.83.174]:60743 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752412Ab0KNELZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Nov 2010 23:11:25 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=uo9vWXGdPjNYu3O4uEVRtobUEbXjOhsfxRESm41xW+Miy/TK1ZV07E7UJ15ujXSxw5
         vbQ44cuVpnFgr5buH8ym6JW7HJUW0Gm3KZCDKHNVKbHeIjMVM31fzXmORdPQyJEQPuvU
         O3kQFJexTjvhIL1Qotmy66ivm7+On7XHRoF/s=
From: Hai Shan <haishan.bai@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Hai Shan <shan.hai@windriver.com>
Subject: [PATCH] Fix float to unsigned conversion failure with SPE enabled
Date: Sun, 14 Nov 2010 12:11:03 +0800
Message-Id: <1289707863-1768-2-git-send-email-shan.hai@windriver.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1289707863-1768-1-git-send-email-shan.hai@windriver.com>
References: <1289707863-1768-1-git-send-email-shan.hai@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed the failure on converting minus float to unsigned int with SPE enabled

Signed-off-by: Hai Shan <shan.hai@windriver.com>
---
 arch/powerpc/math-emu/math_efp.c |   17 +++++++++++++----
 1 files changed, 13 insertions(+), 4 deletions(-)

diff --git a/arch/powerpc/math-emu/math_efp.c b/arch/powerpc/math-emu/math_efp.c
index 41f4ef3..338a128 100644
--- a/arch/powerpc/math-emu/math_efp.c
+++ b/arch/powerpc/math-emu/math_efp.c
@@ -320,7 +320,9 @@ int do_spe_mathemu(struct pt_regs *regs)
 			} else {
 				_FP_ROUND_ZERO(1, SB);
 			}
-			FP_TO_INT_S(vc.wp[1], SB, 32, ((func & 0x3) != 0));
+			/* SB_s: convert from minus float to unsigned int */
+			FP_TO_INT_S(vc.wp[1], SB, 32, 
+					((func & 0x3) != 0) || SB_s);
 			goto update_regs;
 
 		default:
@@ -458,7 +460,11 @@ cmp_s:
 			} else {
 				_FP_ROUND_ZERO(2, DB);
 			}
-			FP_TO_INT_D(vc.wp[1], DB, 32, ((func & 0x3) != 0));
+			/* DB_s: convert from minus long double to 
+			 * unsigned long long
+			 */
+			FP_TO_INT_D(vc.wp[1], DB, 32, 
+					((func & 0x3) != 0) || DB_s);
 			goto update_regs;
 
 		default:
@@ -589,8 +595,11 @@ cmp_d:
 				_FP_ROUND_ZERO(1, SB0);
 				_FP_ROUND_ZERO(1, SB1);
 			}
-			FP_TO_INT_S(vc.wp[0], SB0, 32, ((func & 0x3) != 0));
-			FP_TO_INT_S(vc.wp[1], SB1, 32, ((func & 0x3) != 0));
+			/* SB*_s: convert from minus float to unsigned int */
+			FP_TO_INT_S(vc.wp[0], SB0, 32, 
+					((func & 0x3) != 0) || SB0_s);
+			FP_TO_INT_S(vc.wp[1], SB1, 32, 
+					((func & 0x3) != 0) || SB1_s);
 			goto update_regs;
 
 		default:
-- 
1.7.0.4

