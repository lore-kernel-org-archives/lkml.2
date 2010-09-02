Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756471Ab0IBPs4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Sep 2010 11:48:56 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:33315 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756445Ab0IBPsy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Sep 2010 11:48:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=UawpzQuT35ImliEz5o6cPlhqfPW9BL4yksuvAOHk1c55evNOgAeZZJxztprCiPzW/W
         aVNl3NrGpyy+bc5AsacBDHaU6tvG87G3JoTbuQrFZ4BKwmz/MEAQXa+jINzuZk6D5i2E
         bPrA7vyXaoriGkcn7mJ4sUlE8Kjro0KJM+z2g=
From: Namhyung Kim <namhyung@gmail.com>
To: Roland McGrath <roland@redhat.com>, Oleg Nesterov <oleg@redhat.com>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org,
        Jeff Dike <jdike@addtoit.com>
Subject: [PATCH v2 23/24] ptrace: cleanup arch_ptrace() on um
Date: Fri,  3 Sep 2010 00:46:30 +0900
Message-Id: <1283442391-23612-24-git-send-email-namhyung@gmail.com>
X-Mailer: git-send-email 1.7.2.2
In-Reply-To: <1283442391-23612-1-git-send-email-namhyung@gmail.com>
References: <1283442391-23612-1-git-send-email-namhyung@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove unnecessary castings using void pointer and fix copy_to_user()
return value. Also add missing __user markup on the argument of
arch_ptrctl().

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
Cc: Jeff Dike <jdike@addtoit.com>
---
 arch/um/kernel/ptrace.c     |   18 ++++++++----------
 arch/um/sys-x86_64/ptrace.c |    7 +++----
 2 files changed, 11 insertions(+), 14 deletions(-)

diff --git a/arch/um/kernel/ptrace.c b/arch/um/kernel/ptrace.c
index 963d82b..8b85c97 100644
--- a/arch/um/kernel/ptrace.c
+++ b/arch/um/kernel/ptrace.c
@@ -47,6 +47,7 @@ long arch_ptrace(struct task_struct *child, long request,
 {
 	int i, ret;
 	unsigned long __user *p = (void __user *)data;
+	void __user *vp = p;
 
 	switch (request) {
 	/* read word at location addr. */
@@ -108,24 +109,20 @@ long arch_ptrace(struct task_struct *child, long request,
 #endif
 #ifdef PTRACE_GETFPREGS
 	case PTRACE_GETFPREGS: /* Get the child FPU state. */
-		ret = get_fpregs((struct user_i387_struct __user *) data,
-				 child);
+		ret = get_fpregs(vp, child);
 		break;
 #endif
 #ifdef PTRACE_SETFPREGS
 	case PTRACE_SETFPREGS: /* Set the child FPU state. */
-	        ret = set_fpregs((struct user_i387_struct __user *) data,
-				 child);
+	        ret = set_fpregs(vp, child);
 		break;
 #endif
 	case PTRACE_GET_THREAD_AREA:
-		ret = ptrace_get_thread_area(child, addr,
-					     (struct user_desc __user *) data);
+		ret = ptrace_get_thread_area(child, addr, vp);
 		break;
 
 	case PTRACE_SET_THREAD_AREA:
-		ret = ptrace_set_thread_area(child, addr,
-					     (struct user_desc __user *) data);
+		ret = ptrace_set_thread_area(child, addr, datavp);
 		break;
 
 	case PTRACE_FAULTINFO: {
@@ -135,7 +132,8 @@ long arch_ptrace(struct task_struct *child, long request,
 		 * On i386, ptrace_faultinfo is smaller!
 		 */
 		ret = copy_to_user(p, &child->thread.arch.faultinfo,
-				   sizeof(struct ptrace_faultinfo));
+				   sizeof(struct ptrace_faultinfo)) ?
+			-EIO : 0;
 		break;
 	}
 
@@ -159,7 +157,7 @@ long arch_ptrace(struct task_struct *child, long request,
 #ifdef PTRACE_ARCH_PRCTL
 	case PTRACE_ARCH_PRCTL:
 		/* XXX Calls ptrace on the host - needs some SMP thinking */
-		ret = arch_prctl(child, data, (void *) addr);
+		ret = arch_prctl(child, data, (void __user *) addr);
 		break;
 #endif
 	default:
diff --git a/arch/um/sys-x86_64/ptrace.c b/arch/um/sys-x86_64/ptrace.c
index 67e6368..f436136 100644
--- a/arch/um/sys-x86_64/ptrace.c
+++ b/arch/um/sys-x86_64/ptrace.c
@@ -179,15 +179,14 @@ long subarch_ptrace(struct task_struct *child, long request,
 		    unsigned long addr, unsigned long data)
 {
 	int ret = -EIO;
+	void __user *datap = (void __user *) data;
 
 	switch (request) {
 	case PTRACE_GETFPXREGS: /* Get the child FPU state. */
-		ret = get_fpregs((struct user_i387_struct __user *) data,
-				 child);
+		ret = get_fpregs(datap, child);
 		break;
 	case PTRACE_SETFPXREGS: /* Set the child FPU state. */
-		ret = set_fpregs((struct user_i387_struct __user *) data,
-				 child);
+		ret = set_fpregs(datap, child);
 		break;
 	}
 
-- 
1.7.2.2

