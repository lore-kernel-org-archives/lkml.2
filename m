Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756255Ab0IBPsW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Sep 2010 11:48:22 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:64003 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752774Ab0IBPsT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Sep 2010 11:48:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=s0w/PomI1npZNThlYxY4exkRhkqkatSZ3+z9XVUhED4dpDeA7p1FIUM/K8Pxf+JITP
         PDW34/4cPYn+CibHD2BX84Cmpy4Q7QbNV2MUiXF1A2kaIbjrbRRO8slpML7I30Jhmh3r
         U8sqdffEVDzXy2b6GPk9b7pK/S1ektbMjMWWc=
From: Namhyung Kim <namhyung@gmail.com>
To: Roland McGrath <roland@redhat.com>, Oleg Nesterov <oleg@redhat.com>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org,
        David Howells <dhowells@redhat.com>,
        Koichi Yasutake <yasutake.koichi@jp.panasonic.com>
Subject: [PATCH v2 16/24] ptrace: cleanup arch_ptrace() on mn10300
Date: Fri,  3 Sep 2010 00:46:23 +0900
Message-Id: <1283442391-23612-17-git-send-email-namhyung@gmail.com>
X-Mailer: git-send-email 1.7.2.2
In-Reply-To: <1283442391-23612-1-git-send-email-namhyung@gmail.com>
References: <1283442391-23612-1-git-send-email-namhyung@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use new 'datap' variable in order to remove unnecessary castings.
Also remove checking @addr less than 0 because @addr is now unsigned.

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
Cc: David Howells <dhowells@redhat.com>
Cc: Koichi Yasutake <yasutake.koichi@jp.panasonic.com>
---
 arch/mn10300/kernel/ptrace.c |   17 ++++++++---------
 1 files changed, 8 insertions(+), 9 deletions(-)

diff --git a/arch/mn10300/kernel/ptrace.c b/arch/mn10300/kernel/ptrace.c
index ec4b414..5c0b07e 100644
--- a/arch/mn10300/kernel/ptrace.c
+++ b/arch/mn10300/kernel/ptrace.c
@@ -300,27 +300,26 @@ long arch_ptrace(struct task_struct *child, long request,
 {
 	unsigned long tmp;
 	int ret;
+	unsigned long __user *datap = (unsigned long __user *) data;
 
 	switch (request) {
 	/* read the word at location addr in the USER area. */
 	case PTRACE_PEEKUSR:
 		ret = -EIO;
-		if ((addr & 3) || addr < 0 ||
-		    addr > sizeof(struct user) - 3)
+		if ((addr & 3) || addr > sizeof(struct user) - 3)
 			break;
 
 		tmp = 0;  /* Default return condition */
 		if (addr < NR_PTREGS << 2)
 			tmp = get_stack_long(child,
 					     ptrace_regid_to_frame[addr]);
-		ret = put_user(tmp, (unsigned long *) data);
+		ret = put_user(tmp, datap);
 		break;
 
 		/* write the word at location addr in the USER area */
 	case PTRACE_POKEUSR:
 		ret = -EIO;
-		if ((addr & 3) || addr < 0 ||
-		    addr > sizeof(struct user) - 3)
+		if ((addr & 3) || addr > sizeof(struct user) - 3)
 			break;
 
 		ret = 0;
@@ -333,25 +332,25 @@ long arch_ptrace(struct task_struct *child, long request,
 		return copy_regset_to_user(child, &user_mn10300_native_view,
 					   REGSET_GENERAL,
 					   0, NR_PTREGS * sizeof(long),
-					   (void __user *)data);
+					   datap);
 
 	case PTRACE_SETREGS:	/* Set all integer regs in the child. */
 		return copy_regset_from_user(child, &user_mn10300_native_view,
 					     REGSET_GENERAL,
 					     0, NR_PTREGS * sizeof(long),
-					     (const void __user *)data);
+					     datap);
 
 	case PTRACE_GETFPREGS:	/* Get the child FPU state. */
 		return copy_regset_to_user(child, &user_mn10300_native_view,
 					   REGSET_FPU,
 					   0, sizeof(struct fpu_state_struct),
-					   (void __user *)data);
+					   datap);
 
 	case PTRACE_SETFPREGS:	/* Set the child FPU state. */
 		return copy_regset_from_user(child, &user_mn10300_native_view,
 					     REGSET_FPU,
 					     0, sizeof(struct fpu_state_struct),
-					     (const void __user *)data);
+					     datap);
 
 	default:
 		ret = ptrace_request(child, request, addr, data);
-- 
1.7.2.2

