Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933101Ab2JYPq7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 11:46:59 -0400
Received: from mail.southpole.se ([193.12.106.18]:51626 "EHLO
	mail.southpole.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759910Ab2JYPq4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 11:46:56 -0400
From: Jonas Bonn <jonas@southpole.se>
To: viro@zeniv.linux.org.uk
Cc: linux-kernel@vger.kernel.org, Jonas Bonn <jonas@southpole.se>
Subject: [PATCH 1/2] openrisc: move sys_clone's stack determination to copy_thread
Date: Thu, 25 Oct 2012 17:46:38 +0200
Message-Id: <1351179999-8376-2-git-send-email-jonas@southpole.se>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1351179999-8376-1-git-send-email-jonas@southpole.se>
References: <1351179999-8376-1-git-send-email-jonas@southpole.se>
X-Assp-Version: 2.2.1(12265) on assp.southpole.se
X-Assp-Client-SSL: yes
X-Assp-Server-TLS: yes
X-Assp-ID: assp.southpole.se 80014-00029
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Jonas Bonn <jonas@southpole.se>
---
 arch/openrisc/kernel/process.c  |    6 +++++-
 arch/openrisc/kernel/sys_or32.c |    8 +-------
 2 files changed, 6 insertions(+), 8 deletions(-)

diff --git a/arch/openrisc/kernel/process.c b/arch/openrisc/kernel/process.c
index e0874b8..efbe4f8 100644
--- a/arch/openrisc/kernel/process.c
+++ b/arch/openrisc/kernel/process.c
@@ -170,7 +170,11 @@ copy_thread(unsigned long clone_flags, unsigned long usp,
 	} else {
 		*userregs = *regs;
 
-		userregs->sp = usp;
+		if (usp)
+			userregs->sp = usp;		/* clone */
+		else
+			userregs->sp = regs->sp;	/* fork/clone */
+
 		userregs->gpr[11] = 0;	/* Result from fork() */
 
 		kregs->gpr[20] = 0;	/* Userspace thread */
diff --git a/arch/openrisc/kernel/sys_or32.c b/arch/openrisc/kernel/sys_or32.c
index d6ddd3c..db46b82 100644
--- a/arch/openrisc/kernel/sys_or32.c
+++ b/arch/openrisc/kernel/sys_or32.c
@@ -46,12 +46,6 @@ asmlinkage long _sys_clone(unsigned long clone_flags, unsigned long newsp,
 {
 	long ret;
 
-	/* FIXME: Is alignment necessary? */
-	/* newsp = ALIGN(newsp, 4); */
-
-	if (!newsp)
-		newsp = regs->sp;
-
 	ret = do_fork(clone_flags, newsp, regs, 0, parent_tid, child_tid);
 
 	return ret;
@@ -60,7 +54,7 @@ asmlinkage long _sys_clone(unsigned long clone_flags, unsigned long newsp,
 asmlinkage int _sys_fork(struct pt_regs *regs)
 {
 #ifdef CONFIG_MMU
-	return do_fork(SIGCHLD, regs->sp, regs, 0, NULL, NULL);
+	return do_fork(SIGCHLD, 0, regs, 0, NULL, NULL);
 #else
 	return -EINVAL;
 #endif
-- 
1.7.9.5

