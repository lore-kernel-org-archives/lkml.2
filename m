Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755895Ab0LLXsM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Dec 2010 18:48:12 -0500
Received: from one.firstfloor.org ([213.235.205.2]:36657 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755861Ab0LLXsI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Dec 2010 18:48:08 -0500
From: Andi Kleen <andi@firstfloor.org>
References: <201012131244.547034648@firstfloor.org>
In-Reply-To: <201012131244.547034648@firstfloor.org>
To: will.deacon@arm.com, catalin.marinas@arm.com, rmk+kernel@arm.linux.org.uk,
        gregkh@suse.de, ak@linux.intel.com, linux-kernel@vger.kernel.org,
        stable@kernel.org
Subject: [PATCH] [182/223] ARM: 6489/1: thumb2: fix incorrect optimisation in usracc
Message-Id: <20101212234807.7D825B27BF@basil.firstfloor.org>
Date: Mon, 13 Dec 2010 00:48:07 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Will Deacon <will.deacon@arm.com>

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
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 arch/arm/include/asm/assembler.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux/arch/arm/include/asm/assembler.h
===================================================================
--- linux.orig/arch/arm/include/asm/assembler.h
+++ linux/arch/arm/include/asm/assembler.h
@@ -215,7 +215,7 @@
 	@ Slightly optimised to avoid incrementing the pointer twice
 	usraccoff \instr, \reg, \ptr, \inc, 0, \cond, \abort
 	.if	\rept == 2
-	usraccoff \instr, \reg, \ptr, \inc, 4, \cond, \abort
+	usraccoff \instr, \reg, \ptr, \inc, \inc, \cond, \abort
 	.endif
 
 	add\cond \ptr, #\rept * \inc
