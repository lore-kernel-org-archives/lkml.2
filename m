Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933455Ab1DNRvC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 13:51:02 -0400
Received: from mail.windriver.com ([147.11.1.11]:38564 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933452Ab1DNRrW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 13:47:22 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Will Deacon <will.deacon@arm.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 096/209] ARM: 6489/1: thumb2: fix incorrect optimisation in usracc
Date: Thu, 14 Apr 2011 13:42:06 -0400
Message-Id: <1302803039-9400-97-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1302803039-9400-1-git-send-email-paul.gortmaker@windriver.com>
References: <1302803039-9400-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Will Deacon <will.deacon@arm.com>

  =====================================================================
  | This is a commit scheduled for the next v2.6.34 longterm release. |
  | If you see a problem with using this for longterm, please comment.|
  =====================================================================

commit 1142b71d85894dcff1466dd6c871ea3c89e0352c upstream.

Commit 8b592783 added a Thumb-2 variant of usracc which, when it is
called with \rept=2, calls usraccoff once with an offset of 0 and
secondly with a hard-coded offset of 4 in order to avoid incrementing
the pointer again. If \inc != 4 then we will store the data to the wrong
offset from \ptr. Luckily, the only caller that passes \rept=2 to this
function is __clear_user so we haven't been actively corrupting user data.

This patch fixes usracc to pass \inc instead of #4 to usraccoff
when it is called a second time.

Reported-by: Tony Thompson <tony.thompson@arm.com>
Acked-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 arch/arm/include/asm/assembler.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/arm/include/asm/assembler.h b/arch/arm/include/asm/assembler.h
index 6e8f05c..d757555 100644
--- a/arch/arm/include/asm/assembler.h
+++ b/arch/arm/include/asm/assembler.h
@@ -215,7 +215,7 @@
 	@ Slightly optimised to avoid incrementing the pointer twice
 	usraccoff \instr, \reg, \ptr, \inc, 0, \cond, \abort
 	.if	\rept == 2
-	usraccoff \instr, \reg, \ptr, \inc, 4, \cond, \abort
+	usraccoff \instr, \reg, \ptr, \inc, \inc, \cond, \abort
 	.endif
 
 	add\cond \ptr, #\rept * \inc
-- 
1.7.4.4

