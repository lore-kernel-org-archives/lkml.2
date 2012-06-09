Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752720Ab2FIVEF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jun 2012 17:04:05 -0400
Received: from cpsmtpb-ews01.kpnxchange.com ([213.75.39.4]:3438 "EHLO
	cpsmtpb-ews01.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751366Ab2FIVED (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jun 2012 17:04:03 -0400
Message-ID: <1339275841.30984.24.camel@x61.thuisdomein>
Subject: [PATCH] parisc: remove unused header
From: Paul Bolle <pebolle@tiscali.nl>
To: "James E.J. Bottomley" <jejb@parisc-linux.org>,
        Helge Deller <deller@gmx.de>
Cc: linux-parisc@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Sat, 09 Jun 2012 23:04:01 +0200
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-OriginalArrivalTime: 09 Jun 2012 21:04:01.0697 (UTC) FILETIME=[65401110:01CD4683]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nothing uses compat_rt_sigframe.h anymore. Commit
f671c45df23005692daa200aba768c642fb14ef2 ("[PARISC] Arch-specific compat
signals") removed all includes of that header. It also basically copied
that entire header verbatim into signal32.h. It seems it was just
forgotten to also remove compat_rt_sigframe.h from the tree. Remove that
header now.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
Tested mostly by, again, prodding at the (history of the) tree with
various git commands.

 arch/parisc/include/asm/compat_rt_sigframe.h |   50 --------------------------
 1 files changed, 0 insertions(+), 50 deletions(-)
 delete mode 100644 arch/parisc/include/asm/compat_rt_sigframe.h

diff --git a/arch/parisc/include/asm/compat_rt_sigframe.h b/arch/parisc/include/asm/compat_rt_sigframe.h
deleted file mode 100644
index 81bec28..0000000
--- a/arch/parisc/include/asm/compat_rt_sigframe.h
+++ /dev/null
@@ -1,50 +0,0 @@
-#include<linux/compat.h>
-#include<linux/compat_siginfo.h>
-#include<asm/compat_ucontext.h>
-
-#ifndef _ASM_PARISC_COMPAT_RT_SIGFRAME_H
-#define _ASM_PARISC_COMPAT_RT_SIGFRAME_H
-
-/* In a deft move of uber-hackery, we decide to carry the top half of all
- * 64-bit registers in a non-portable, non-ABI, hidden structure.
- * Userspace can read the hidden structure if it *wants* but is never
- * guaranteed to be in the same place. Infact the uc_sigmask from the 
- * ucontext_t structure may push the hidden register file downards
- */
-struct compat_regfile {
-	/* Upper half of all the 64-bit registers that were truncated
-	   on a copy to a 32-bit userspace */
-	compat_int_t rf_gr[32];
-	compat_int_t rf_iasq[2];
-	compat_int_t rf_iaoq[2];
-	compat_int_t rf_sar;
-};
-
-#define COMPAT_SIGRETURN_TRAMP 4
-#define COMPAT_SIGRESTARTBLOCK_TRAMP 5 
-#define COMPAT_TRAMP_SIZE (COMPAT_SIGRETURN_TRAMP + COMPAT_SIGRESTARTBLOCK_TRAMP)
-
-struct compat_rt_sigframe {
-	/* XXX: Must match trampoline size in arch/parisc/kernel/signal.c 
-	        Secondary to that it must protect the ERESTART_RESTARTBLOCK
-		trampoline we left on the stack (we were bad and didn't 
-		change sp so we could run really fast.) */
-	compat_uint_t tramp[COMPAT_TRAMP_SIZE];
-	compat_siginfo_t info;
-	struct compat_ucontext uc;
-	/* Hidden location of truncated registers, *must* be last. */
-	struct compat_regfile regs; 
-};
-
-/*
- * The 32-bit ABI wants at least 48 bytes for a function call frame:
- * 16 bytes for arg0-arg3, and 32 bytes for magic (the only part of
- * which Linux/parisc uses is sp-20 for the saved return pointer...)
- * Then, the stack pointer must be rounded to a cache line (64 bytes).
- */
-#define SIGFRAME32		64
-#define FUNCTIONCALLFRAME32	48
-#define PARISC_RT_SIGFRAME_SIZE32					\
-	(((sizeof(struct compat_rt_sigframe) + FUNCTIONCALLFRAME32) + SIGFRAME32) & -SIGFRAME32)
-
-#endif
-- 
1.7.7.6

