Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030893Ab2ERCzZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2012 22:55:25 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:40572 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1030729Ab2ERCwv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2012 22:52:51 -0400
Message-Id: <20120518023300.708921105@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Fri, 18 May 2012 03:33:41 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Chris Metcalf <cmetcalf@tilera.com>
Subject: [ 47/53] arch/tile: apply commit 74fca9da0 to the compat signal handling as
 well
In-Reply-To: <20120518023254.339945758@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.185
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chris Metcalf <cmetcalf@tilera.com>

commit a134d228298c6aa9007205c6b81cae0cac0acb5d upstream.

This passes siginfo and mcontext to tilegx32 signal handlers that
don't have SA_SIGINFO set just as we have been doing for tilegx64.

Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 arch/tile/kernel/compat_signal.c |   12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff --git a/arch/tile/kernel/compat_signal.c b/arch/tile/kernel/compat_signal.c
index 77763cc..cdef6e5 100644
--- a/arch/tile/kernel/compat_signal.c
+++ b/arch/tile/kernel/compat_signal.c
@@ -403,19 +403,17 @@ int compat_setup_rt_frame(int sig, struct k_sigaction *ka, siginfo_t *info,
 	 * Set up registers for signal handler.
 	 * Registers that we don't modify keep the value they had from
 	 * user-space at the time we took the signal.
+	 * We always pass siginfo and mcontext, regardless of SA_SIGINFO,
+	 * since some things rely on this (e.g. glibc's debug/segfault.c).
 	 */
 	regs->pc = ptr_to_compat_reg(ka->sa.sa_handler);
 	regs->ex1 = PL_ICS_EX1(USER_PL, 1); /* set crit sec in handler */
 	regs->sp = ptr_to_compat_reg(frame);
 	regs->lr = restorer;
 	regs->regs[0] = (unsigned long) usig;
-
-	if (ka->sa.sa_flags & SA_SIGINFO) {
-		/* Need extra arguments, so mark to restore caller-saves. */
-		regs->regs[1] = ptr_to_compat_reg(&frame->info);
-		regs->regs[2] = ptr_to_compat_reg(&frame->uc);
-		regs->flags |= PT_FLAGS_CALLER_SAVES;
-	}
+	regs->regs[1] = ptr_to_compat_reg(&frame->info);
+	regs->regs[2] = ptr_to_compat_reg(&frame->uc);
+	regs->flags |= PT_FLAGS_CALLER_SAVES;
 
 	/*
 	 * Notify any tracer that was single-stepping it.
-- 
1.7.10



