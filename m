Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752930Ab1HRTAd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Aug 2011 15:00:33 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:49911 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752781Ab1HRTA3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Aug 2011 15:00:29 -0400
Date: Thu, 18 Aug 2011 20:00:29 +0100
To: richard@nod.at
Subject: Subject: [PATCH 09/91] um: don't rely on sc.fpstate not having
 been reassigned prior to rt_sigreturn()
Cc: user-mode-linux-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
User-Agent: Heirloom mailx 12.5 7/5/10
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <E1Qu7pN-0007Th-6h@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


native rt_sigreturn() doesn't...

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 arch/um/sys-x86_64/signal.c |   13 ++++++++-----
 1 files changed, 8 insertions(+), 5 deletions(-)

diff --git a/arch/um/sys-x86_64/signal.c b/arch/um/sys-x86_64/signal.c
index 581b64d..ccfa554 100644
--- a/arch/um/sys-x86_64/signal.c
+++ b/arch/um/sys-x86_64/signal.c
@@ -44,10 +44,10 @@ void copy_sc(struct uml_pt_regs *regs, void *from)
 }
 
 static int copy_sc_from_user(struct pt_regs *regs,
-			     struct sigcontext __user *from,
-			     struct _fpstate __user *fpp)
+			     struct sigcontext __user *from)
 {
 	struct user_i387_struct fp;
+	void __user *buf;
 	int err = 0;
 
 #define GETREG(regs, regno, sc, regname)				\
@@ -78,7 +78,11 @@ static int copy_sc_from_user(struct pt_regs *regs,
 
 #undef GETREG
 
-	err = copy_from_user(&fp, fpp, sizeof(struct user_i387_struct));
+	err = __get_user(buf, &from->fpstate);
+	if (err)
+		return 1;
+
+	err = copy_from_user(&fp, buf, sizeof(struct user_i387_struct));
 	if (err)
 		return 1;
 
@@ -272,8 +276,7 @@ long sys_rt_sigreturn(struct pt_regs *regs)
 	sigdelsetmask(&set, ~_BLOCKABLE);
 	set_current_blocked(&set);
 
-	if (copy_sc_from_user(&current->thread.regs, &uc->uc_mcontext,
-			      &frame->fpstate))
+	if (copy_sc_from_user(&current->thread.regs, &uc->uc_mcontext))
 		goto segfault;
 
 	/* Avoid ERESTART handling */
-- 
1.7.2.5


