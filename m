Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031160Ab2ERXYI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 19:24:08 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:35668 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946468Ab2ERXEu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 19:04:50 -0400
Message-Id: <20120518211602.634480647@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Fri, 18 May 2012 14:16:34 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Chris Metcalf <cmetcalf@tilera.com>
Subject: [ 35/54] arch/tile: apply commit 74fca9da0 to the compat signal handling as well
In-Reply-To: <20120518212656.GA4992@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chris Metcalf <cmetcalf@tilera.com>

commit a134d228298c6aa9007205c6b81cae0cac0acb5d upstream.

This passes siginfo and mcontext to tilegx32 signal handlers that
don't have SA_SIGINFO set just as we have been doing for tilegx64.

Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/tile/kernel/compat_signal.c |   12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

--- a/arch/tile/kernel/compat_signal.c
+++ b/arch/tile/kernel/compat_signal.c
@@ -406,19 +406,17 @@ int compat_setup_rt_frame(int sig, struc
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


