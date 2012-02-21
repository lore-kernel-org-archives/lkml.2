Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755462Ab2BUOiN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Feb 2012 09:38:13 -0500
Received: from wildebeest.demon.nl ([80.101.103.228]:40518 "EHLO
	gnu.wildebeest.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753747Ab2BUOiM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Feb 2012 09:38:12 -0500
X-Greylist: delayed 1861 seconds by postgrey-1.27 at vger.kernel.org; Tue, 21 Feb 2012 09:38:12 EST
From: Mark Wielaard <mjw@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Mark Wielaard <mjw@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de> (maintainer:X86
	ARCHITECTURE...),
        Ingo Molnar <mingo@redhat.com> (maintainer:X86 ARCHITECTURE... 
	,commit_signer:11/25=44%),
        "H. Peter Anvin" <hpa@zytor.com> (maintainer:X86 ARCHITECTURE... 
	,commit_signer:4/25=16%),
        x86@kernel.org (maintainer:X86 ARCHITECTURE...),
        Andi Kleen <ak@linux.intel.com> (commit_signer:5/25=20%),
        Jan Beulich <jbeulich@suse.com> (commit_signer:5/25=20%),
        Frederic Weisbecker <fweisbec@gmail.com> (commit_signer:4/25=16%)
Subject: [PATCH] x86-64: Fix CFI data for common_interrupt
Date: Tue, 21 Feb 2012 15:06:13 +0100
Message-Id: <1329833177-13030-1-git-send-email-mjw@redhat.com>
X-Mailer: git-send-email 1.7.7.6
X-Spam-Score: -2.9 (--)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit eab9e6 "x86-64: Fix CFI data for interrupt frames" introduced
a DW_CFA_def_cfa_expression in the SAVE_ARGS_IRQ macro. To later define
the CFA using a simple register+offset rule both register and offset
need to be supplied. Just using CFI_DEF_CFA_REGISTER leaves the offset
undefined. So use CFI_DEF_CFA with reg+off explicitly at the end of
common_interrupt.

Signed-off-by: Mark Wielaard <mjw@redhat.com>
---
 arch/x86/kernel/entry_64.S |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
index 3fe8239..e00ef55 100644
--- a/arch/x86/kernel/entry_64.S
+++ b/arch/x86/kernel/entry_64.S
@@ -813,7 +813,7 @@ ret_from_intr:
 
 	/* Restore saved previous stack */
 	popq %rsi
-	CFI_DEF_CFA_REGISTER	rsi
+	CFI_DEF_CFA rsi,0	/* needed after def_cfa_expression */
 	leaq ARGOFFSET-RBP(%rsi), %rsp
 	CFI_DEF_CFA_REGISTER	rsp
 	CFI_ADJUST_CFA_OFFSET	RBP-ARGOFFSET
-- 
1.7.7.6

