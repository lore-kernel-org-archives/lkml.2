Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752802Ab2BTASY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Feb 2012 19:18:24 -0500
Received: from terminus.zytor.com ([198.137.202.10]:57329 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751760Ab2BTASX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Feb 2012 19:18:23 -0500
From: "H. Peter Anvin" <hpa@zytor.com>
To: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Cc: mingo@kernel.org, tglx@linutronix.de, hpa@zytor.com,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        hjl.tools@gmail.com
Subject: [PATCH 21/30] x32: Export setup/restore_sigcontext from signal.c
Date: Sun, 19 Feb 2012 16:07:59 -0800
Message-Id: <1329696488-16970-22-git-send-email-hpa@zytor.com>
X-Mailer: git-send-email 1.7.6.5
In-Reply-To: <1329696488-16970-1-git-send-email-hpa@zytor.com>
References: <1329696488-16970-1-git-send-email-hpa@zytor.com>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Sun, 19 Feb 2012 16:18:18 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "H. Peter Anvin" <hpa@zytor.com>

Export setup_sigcontext() and restore_sigcontext() from signal.c, so
we can use the 64-bit versions verbatim for x32.

Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
 arch/x86/include/asm/sighandling.h |    5 +++++
 arch/x86/kernel/signal.c           |   10 ++++------
 2 files changed, 9 insertions(+), 6 deletions(-)

diff --git a/arch/x86/include/asm/sighandling.h b/arch/x86/include/asm/sighandling.h
index 843e299..ada93b3 100644
--- a/arch/x86/include/asm/sighandling.h
+++ b/arch/x86/include/asm/sighandling.h
@@ -16,4 +16,9 @@
 
 void signal_fault(struct pt_regs *regs, void __user *frame, char *where);
 
+int restore_sigcontext(struct pt_regs *regs, struct sigcontext __user *sc,
+		       unsigned long *pax);
+int setup_sigcontext(struct sigcontext __user *sc, void __user *fpstate,
+		     struct pt_regs *regs, unsigned long mask);
+
 #endif /* _ASM_X86_SIGHANDLING_H */
diff --git a/arch/x86/kernel/signal.c b/arch/x86/kernel/signal.c
index c432dc0..450fb25 100644
--- a/arch/x86/kernel/signal.c
+++ b/arch/x86/kernel/signal.c
@@ -60,9 +60,8 @@
 	regs->seg = GET_SEG(seg) | 3;			\
 } while (0)
 
-static int
-restore_sigcontext(struct pt_regs *regs, struct sigcontext __user *sc,
-		   unsigned long *pax)
+int restore_sigcontext(struct pt_regs *regs, struct sigcontext __user *sc,
+		       unsigned long *pax)
 {
 	void __user *buf;
 	unsigned int tmpflags;
@@ -117,9 +116,8 @@ restore_sigcontext(struct pt_regs *regs, struct sigcontext __user *sc,
 	return err;
 }
 
-static int
-setup_sigcontext(struct sigcontext __user *sc, void __user *fpstate,
-		 struct pt_regs *regs, unsigned long mask)
+int setup_sigcontext(struct sigcontext __user *sc, void __user *fpstate,
+		     struct pt_regs *regs, unsigned long mask)
 {
 	int err = 0;
 
-- 
1.7.6.5

