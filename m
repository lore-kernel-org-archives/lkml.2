Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755005Ab0H0Jt3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Aug 2010 05:49:29 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:52511 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754600Ab0H0Jnj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Aug 2010 05:43:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=vFrCt6mvdTlWOfjiv9YvWul4hjYif2PWKQDaCNITmEba31xyErehgkFW35i0IVq141
         2OVpB5PkDn/Ii8juKZKO3jolaSopllaJzBX0j1ry+vW3+8IeXYquKTIG+glF0Oo/KBe8
         n1xdz+/9sDZJnTEPz5r8cSwIwA0Rf5Vhe3H1U=
From: Namhyung Kim <namhyung@gmail.com>
To: Roland McGrath <roland@redhat.com>, Oleg Nesterov <oleg@redhat.com>,
        Arnd Bergmann <arnd@arndb.de>
Cc: linux-kernel@vger.kernel.org, David Howells <dhowells@redhat.com>
Subject: [RFC PATCH 15/43] ptrace, frv: cleanup arch_ptrace()
Date: Fri, 27 Aug 2010 18:42:01 +0900
Message-Id: <1282902149-12991-16-git-send-email-namhyung@gmail.com>
X-Mailer: git-send-email 1.7.2.2
In-Reply-To: <1282902149-12991-1-git-send-email-namhyung@gmail.com>
References: <1282902149-12991-1-git-send-email-namhyung@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

use new regno, datap variables in order to remove duplicated expressions and
unnecessary castings.

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
Cc: David Howells <dhowells@redhat.com>
---
 arch/frv/kernel/ptrace.c |   25 +++++++++++--------------
 1 files changed, 11 insertions(+), 14 deletions(-)

diff --git a/arch/frv/kernel/ptrace.c b/arch/frv/kernel/ptrace.c
index 3d87d1c..9d68f7f 100644
--- a/arch/frv/kernel/ptrace.c
+++ b/arch/frv/kernel/ptrace.c
@@ -259,6 +259,8 @@ long arch_ptrace(struct task_struct *child, long request,
 {
 	unsigned long tmp;
 	int ret;
+	int regno = addr >> 2;
+	unsigned long __user *datap = (unsigned long __user *) data;
 
 	switch (request) {
 		/* read the word at location addr in the USER area. */
@@ -269,9 +271,9 @@ long arch_ptrace(struct task_struct *child, long request,
 			break;
 
 		ret = 0;
-		switch (addr >> 2) {
+		switch (regno) {
 		case 0 ... PT__END - 1:
-			tmp = get_reg(child, addr >> 2);
+			tmp = get_reg(child, regno);
 			break;
 
 		case PT__END + 0:
@@ -300,7 +302,7 @@ long arch_ptrace(struct task_struct *child, long request,
 		}
 
 		if (ret == 0)
-			ret = put_user(tmp, (unsigned long *) data);
+			ret = put_user(tmp, datap);
 		break;
 	}
 
@@ -309,14 +311,9 @@ long arch_ptrace(struct task_struct *child, long request,
 		if (addr & 3)
 			break;
 
-		ret = 0;
-		switch (addr >> 2) {
+		switch (regno) {
 		case 0 ... PT__END - 1:
-			ret = put_reg(child, addr >> 2, data);
-			break;
-
-		default:
-			ret = -EIO;
+			ret = put_reg(child, regno, data);
 			break;
 		}
 		break;
@@ -325,25 +322,25 @@ long arch_ptrace(struct task_struct *child, long request,
 		return copy_regset_to_user(child, &user_frv_native_view,
 					   REGSET_GENERAL,
 					   0, sizeof(child->thread.user->i),
-					   (void __user *)data);
+					   datap);
 
 	case PTRACE_SETREGS:	/* Set all integer regs in the child. */
 		return copy_regset_from_user(child, &user_frv_native_view,
 					     REGSET_GENERAL,
 					     0, sizeof(child->thread.user->i),
-					     (const void __user *)data);
+					     datap);
 
 	case PTRACE_GETFPREGS:	/* Get the child FP/Media state. */
 		return copy_regset_to_user(child, &user_frv_native_view,
 					   REGSET_FPMEDIA,
 					   0, sizeof(child->thread.user->f),
-					   (void __user *)data);
+					   datap);
 
 	case PTRACE_SETFPREGS:	/* Set the child FP/Media state. */
 		return copy_regset_from_user(child, &user_frv_native_view,
 					     REGSET_FPMEDIA,
 					     0, sizeof(child->thread.user->f),
-					     (const void __user *)data);
+					     datap);
 
 	default:
 		ret = ptrace_request(child, request, addr, data);
-- 
1.7.2.2

