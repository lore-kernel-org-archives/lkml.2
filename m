Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753726Ab0EUIie (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 May 2010 04:38:34 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:34443 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753114Ab0EUIic (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 May 2010 04:38:32 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-sh@vger.kernel.org, Paul Mundt <lethal@linux-sh.org>,
       uclinux-dist-devel@blackfin.uclinux.org, linux-kernel@vger.kernel.org,
       David Howells <dhowells@redhat.com>, Oleg Nesterov <oleg@redhat.com>,
       Roland McGrath <roland@redhat.com>
Subject: [PATCH v2] ptrace: unify FDPIC implementations
Date: Fri, 21 May 2010 04:42:25 -0400
Message-Id: <1274431345-22366-1-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1266280229-18469-1-git-send-email-vapier@gentoo.org>
References: <1266280229-18469-1-git-send-email-vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Blackfin/FRV/SuperH guys all have the same exact FDPIC ptrace code in
their arch handlers (since they were probably copied & pasted).  Since
these ptrace interfaces are an arch independent aspect of the FDPIC code,
unify them in the common ptrace code so new FDPIC ports don't need to copy
and paste this fundamental stuff yet again.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
Acked-by: Roland McGrath <roland@redhat.com>
Acked-by: David Howells <dhowells@redhat.com>
Acked-by: Paul Mundt <lethal@linux-sh.org>
---
v2
	- rebased onto latest mainline

 arch/blackfin/kernel/ptrace.c |   33 +++++++++------------------------
 arch/frv/kernel/ptrace.c      |   20 --------------------
 arch/sh/kernel/ptrace_32.c    |   23 -----------------------
 kernel/ptrace.c               |   20 ++++++++++++++++++++
 4 files changed, 29 insertions(+), 67 deletions(-)

diff --git a/arch/blackfin/kernel/ptrace.c b/arch/blackfin/kernel/ptrace.c
index 43eb969..6ec7768 100644
--- a/arch/blackfin/kernel/ptrace.c
+++ b/arch/blackfin/kernel/ptrace.c
@@ -292,28 +292,6 @@ long arch_ptrace(struct task_struct *child, long request, long addr, long data)
 			break;
 		}
 
-#ifdef CONFIG_BINFMT_ELF_FDPIC
-	case PTRACE_GETFDPIC: {
-		unsigned long tmp = 0;
-
-		switch (addr) {
-		case_PTRACE_GETFDPIC_EXEC:
-		case PTRACE_GETFDPIC_EXEC:
-			tmp = child->mm->context.exec_fdpic_loadmap;
-			break;
-		case_PTRACE_GETFDPIC_INTERP:
-		case PTRACE_GETFDPIC_INTERP:
-			tmp = child->mm->context.interp_fdpic_loadmap;
-			break;
-		default:
-			break;
-		}
-
-		ret = put_user(tmp, datap);
-		break;
-	}
-#endif
-
 		/* when I and D space are separate, this will have to be fixed. */
 	case PTRACE_POKEDATA:
 		pr_debug("ptrace: PTRACE_PEEKDATA\n");
@@ -357,8 +335,14 @@ long arch_ptrace(struct task_struct *child, long request, long addr, long data)
 	case PTRACE_PEEKUSR:
 		switch (addr) {
 #ifdef CONFIG_BINFMT_ELF_FDPIC	/* backwards compat */
-		case PT_FDPIC_EXEC:   goto case_PTRACE_GETFDPIC_EXEC;
-		case PT_FDPIC_INTERP: goto case_PTRACE_GETFDPIC_INTERP;
+		case PT_FDPIC_EXEC:
+			request = PTRACE_GETFDPIC;
+			addr = PTRACE_GETFDPIC_EXEC;
+			goto case_default;
+		case PT_FDPIC_INTERP:
+			request = PTRACE_GETFDPIC;
+			addr = PTRACE_GETFDPIC_INTERP;
+			goto case_default;
 #endif
 		default:
 			ret = get_reg(child, addr, datap);
@@ -385,6 +369,7 @@ long arch_ptrace(struct task_struct *child, long request, long addr, long data)
 					     0, sizeof(struct pt_regs),
 					     (const void __user *)data);
 
+	case_default:
 	default:
 		ret = ptrace_request(child, request, addr, data);
 		break;
diff --git a/arch/frv/kernel/ptrace.c b/arch/frv/kernel/ptrace.c
index 60eeed3..fac0289 100644
--- a/arch/frv/kernel/ptrace.c
+++ b/arch/frv/kernel/ptrace.c
@@ -344,26 +344,6 @@ long arch_ptrace(struct task_struct *child, long request, long addr, long data)
 					     0, sizeof(child->thread.user->f),
 					     (const void __user *)data);
 
-	case PTRACE_GETFDPIC:
-		tmp = 0;
-		switch (addr) {
-		case PTRACE_GETFDPIC_EXEC:
-			tmp = child->mm->context.exec_fdpic_loadmap;
-			break;
-		case PTRACE_GETFDPIC_INTERP:
-			tmp = child->mm->context.interp_fdpic_loadmap;
-			break;
-		default:
-			break;
-		}
-
-		ret = 0;
-		if (put_user(tmp, (unsigned long *) data)) {
-			ret = -EFAULT;
-			break;
-		}
-		break;
-
 	default:
 		ret = ptrace_request(child, request, addr, data);
 		break;
diff --git a/arch/sh/kernel/ptrace_32.c b/arch/sh/kernel/ptrace_32.c
index 7759a9a..75b74b2 100644
--- a/arch/sh/kernel/ptrace_32.c
+++ b/arch/sh/kernel/ptrace_32.c
@@ -436,29 +436,6 @@ long arch_ptrace(struct task_struct *child, long request, long addr, long data)
 					     0, sizeof(struct pt_dspregs),
 					     (const void __user *)data);
 #endif
-#ifdef CONFIG_BINFMT_ELF_FDPIC
-	case PTRACE_GETFDPIC: {
-		unsigned long tmp = 0;
-
-		switch (addr) {
-		case PTRACE_GETFDPIC_EXEC:
-			tmp = child->mm->context.exec_fdpic_loadmap;
-			break;
-		case PTRACE_GETFDPIC_INTERP:
-			tmp = child->mm->context.interp_fdpic_loadmap;
-			break;
-		default:
-			break;
-		}
-
-		ret = 0;
-		if (put_user(tmp, datap)) {
-			ret = -EFAULT;
-			break;
-		}
-		break;
-	}
-#endif
 	default:
 		ret = ptrace_request(child, request, addr, data);
 		break;
diff --git a/kernel/ptrace.c b/kernel/ptrace.c
index 42ad8ae..3ecb0a1 100644
--- a/kernel/ptrace.c
+++ b/kernel/ptrace.c
@@ -596,6 +596,26 @@ int ptrace_request(struct task_struct *child, long request,
 		ret = ptrace_detach(child, data);
 		break;
 
+#ifdef CONFIG_BINFMT_ELF_FDPIC
+	case PTRACE_GETFDPIC: {
+		unsigned long tmp = 0;
+
+		switch (addr) {
+		case PTRACE_GETFDPIC_EXEC:
+			tmp = child->mm->context.exec_fdpic_loadmap;
+			break;
+		case PTRACE_GETFDPIC_INTERP:
+			tmp = child->mm->context.interp_fdpic_loadmap;
+			break;
+		default:
+			break;
+		}
+
+		ret = put_user(tmp, (unsigned long __user *) data);
+		break;
+	}
+#endif
+
 #ifdef PTRACE_SINGLESTEP
 	case PTRACE_SINGLESTEP:
 #endif
-- 
1.7.1

