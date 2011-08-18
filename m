Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752749Ab1HRTAV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Aug 2011 15:00:21 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:49908 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751127Ab1HRTAT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Aug 2011 15:00:19 -0400
Date: Thu, 18 Aug 2011 20:00:19 +0100
To: richard@nod.at
Subject: Subject: [PATCH 08/91] um: switch {rt_,}sigreturn() to
 set_current_blocked()
Cc: user-mode-linux-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
User-Agent: Heirloom mailx 12.5 7/5/10
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <E1Qu7pD-0007TQ-6T@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


same story as on x86 native...

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 arch/um/sys-i386/signal.c   |   12 ++----------
 arch/um/sys-x86_64/signal.c |    6 +-----
 2 files changed, 3 insertions(+), 15 deletions(-)

diff --git a/arch/um/sys-i386/signal.c b/arch/um/sys-i386/signal.c
index 89a4662..4403b48 100644
--- a/arch/um/sys-i386/signal.c
+++ b/arch/um/sys-i386/signal.c
@@ -458,11 +458,7 @@ long sys_sigreturn(struct pt_regs regs)
 		goto segfault;
 
 	sigdelsetmask(&set, ~_BLOCKABLE);
-
-	spin_lock_irq(&current->sighand->siglock);
-	current->blocked = set;
-	recalc_sigpending();
-	spin_unlock_irq(&current->sighand->siglock);
+	set_current_blocked(&set);
 
 	if (copy_sc_from_user(&current->thread.regs, sc))
 		goto segfault;
@@ -489,11 +485,7 @@ long sys_rt_sigreturn(struct pt_regs regs)
 		goto segfault;
 
 	sigdelsetmask(&set, ~_BLOCKABLE);
-
-	spin_lock_irq(&current->sighand->siglock);
-	current->blocked = set;
-	recalc_sigpending();
-	spin_unlock_irq(&current->sighand->siglock);
+	set_current_blocked(&set);
 
 	if (copy_sc_from_user(&current->thread.regs, &uc->uc_mcontext))
 		goto segfault;
diff --git a/arch/um/sys-x86_64/signal.c b/arch/um/sys-x86_64/signal.c
index b6b65c7..581b64d 100644
--- a/arch/um/sys-x86_64/signal.c
+++ b/arch/um/sys-x86_64/signal.c
@@ -270,11 +270,7 @@ long sys_rt_sigreturn(struct pt_regs *regs)
 		goto segfault;
 
 	sigdelsetmask(&set, ~_BLOCKABLE);
-
-	spin_lock_irq(&current->sighand->siglock);
-	current->blocked = set;
-	recalc_sigpending();
-	spin_unlock_irq(&current->sighand->siglock);
+	set_current_blocked(&set);
 
 	if (copy_sc_from_user(&current->thread.regs, &uc->uc_mcontext,
 			      &frame->fpstate))
-- 
1.7.2.5


