Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754906Ab0H0Jpo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Aug 2010 05:45:44 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:37671 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754886Ab0H0JpB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Aug 2010 05:45:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=G8Ghpefuy7jKc2oAfRgSxbZL4xdzIDl98rcrAyAv5lrdilk4AVxFBBnR4tKg2WSjZ6
         AE0PT+Dztx2Ezf6CgtDyWxqoN/cvfz/2l0XS3YvfT2NxdsdBOrFAiHJ5DZP7dO88edN9
         e7aXZ6XOqQ0g/Rc+0mt1k+3PDjUrdgzskEzN4=
From: Namhyung Kim <namhyung@gmail.com>
To: Roland McGrath <roland@redhat.com>, Oleg Nesterov <oleg@redhat.com>,
        Arnd Bergmann <arnd@arndb.de>
Cc: linux-kernel@vger.kernel.org, Jeff Dike <jdike@addtoit.com>
Subject: [RFC PATCH 41/43] ptrace, um: cleanup arch_ptrace()
Date: Fri, 27 Aug 2010 18:42:27 +0900
Message-Id: <1282902149-12991-42-git-send-email-namhyung@gmail.com>
X-Mailer: git-send-email 1.7.2.2
In-Reply-To: <1282902149-12991-1-git-send-email-namhyung@gmail.com>
References: <1282902149-12991-1-git-send-email-namhyung@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

remove unnecessary castings using void pointer and fix copy_to_user() return
value.

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
Cc: Jeff Dike <jdike@addtoit.com>
---
 arch/um/kernel/ptrace.c     |   23 +++++++++++------------
 arch/um/sys-x86_64/ptrace.c |    7 +++----
 2 files changed, 14 insertions(+), 16 deletions(-)

diff --git a/arch/um/kernel/ptrace.c b/arch/um/kernel/ptrace.c
index 963d82b..137a1bc 100644
--- a/arch/um/kernel/ptrace.c
+++ b/arch/um/kernel/ptrace.c
@@ -46,7 +46,7 @@ long arch_ptrace(struct task_struct *child, long request,
 		 unsigned long addr, unsigned long data)
 {
 	int i, ret;
-	unsigned long __user *p = (void __user *)data;
+	void __user *p = (void __user *)data;
 
 	switch (request) {
 	/* read word at location addr. */
@@ -78,12 +78,14 @@ long arch_ptrace(struct task_struct *child, long request,
 
 #ifdef PTRACE_GETREGS
 	case PTRACE_GETREGS: { /* Get all gp regs from the child. */
+		unsigned long tmp;
 		if (!access_ok(VERIFY_WRITE, p, MAX_REG_OFFSET)) {
 			ret = -EIO;
 			break;
 		}
 		for ( i = 0; i < MAX_REG_OFFSET; i += sizeof(long) ) {
-			__put_user(getreg(child, i), p);
+			tmp = getreg(child, i);
+			__copy_to_user(p, &tmp, sizeof(tmp));
 			p++;
 		}
 		ret = 0;
@@ -98,7 +100,7 @@ long arch_ptrace(struct task_struct *child, long request,
 			break;
 		}
 		for ( i = 0; i < MAX_REG_OFFSET; i += sizeof(long) ) {
-			__get_user(tmp, p);
+			__copy_from_user(&tmp, p, sizeof(tmp));
 			putreg(child, i, tmp);
 			p++;
 		}
@@ -108,24 +110,20 @@ long arch_ptrace(struct task_struct *child, long request,
 #endif
 #ifdef PTRACE_GETFPREGS
 	case PTRACE_GETFPREGS: /* Get the child FPU state. */
-		ret = get_fpregs((struct user_i387_struct __user *) data,
-				 child);
+		ret = get_fpregs(p, child);
 		break;
 #endif
 #ifdef PTRACE_SETFPREGS
 	case PTRACE_SETFPREGS: /* Set the child FPU state. */
-	        ret = set_fpregs((struct user_i387_struct __user *) data,
-				 child);
+	        ret = set_fpregs(p, child);
 		break;
 #endif
 	case PTRACE_GET_THREAD_AREA:
-		ret = ptrace_get_thread_area(child, addr,
-					     (struct user_desc __user *) data);
+		ret = ptrace_get_thread_area(child, addr, p);
 		break;
 
 	case PTRACE_SET_THREAD_AREA:
-		ret = ptrace_set_thread_area(child, addr,
-					     (struct user_desc __user *) data);
+		ret = ptrace_set_thread_area(child, addr, p);
 		break;
 
 	case PTRACE_FAULTINFO: {
@@ -135,7 +133,8 @@ long arch_ptrace(struct task_struct *child, long request,
 		 * On i386, ptrace_faultinfo is smaller!
 		 */
 		ret = copy_to_user(p, &child->thread.arch.faultinfo,
-				   sizeof(struct ptrace_faultinfo));
+				   sizeof(struct ptrace_faultinfo)) ?
+			-EIO : 0;
 		break;
 	}
 
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

