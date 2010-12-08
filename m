Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756347Ab0LHArz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 19:47:55 -0500
Received: from kroah.org ([198.145.64.141]:58538 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756311Ab0LHArv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 19:47:51 -0500
X-Mailbox-Line: From gregkh@clark.site Tue Dec  7 16:44:33 2010
Message-Id: <20101208004433.190676196@clark.site>
User-Agent: quilt/0.48-11.2
Date: Tue, 07 Dec 2010 16:44:35 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>
Subject: [089/127] ARM: 6489/1: thumb2: fix incorrect optimisation in usracc
In-Reply-To: <20101208004456.GA23578@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

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

---
 arch/arm/include/asm/assembler.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

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


