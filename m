Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756377Ab0IBPul (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Sep 2010 11:50:41 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:53807 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756156Ab0IBPsK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Sep 2010 11:48:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=hF9Bn9KY2uC1nzd+RMpYXKc3dssyMyAzAIFk09Ek6+pCuMqdA0Ua4xwA9tw3+ph4wm
         /F9Y3sI+zEM473mWRY/gx974PZC1kmY1IPHUurKKdP55MWrZLkrqLramE2E23sj/MRXl
         vSrYT4rRTLHWqvSDggSsLtilnLilDqd27CGzc=
From: Namhyung Kim <namhyung@gmail.com>
To: Roland McGrath <roland@redhat.com>, Oleg Nesterov <oleg@redhat.com>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org,
        Ralf Baechle <ralf@linux-mips.org>
Subject: [PATCH v2 15/24] ptrace: cleanup arch_ptrace() on MIPS
Date: Fri,  3 Sep 2010 00:46:22 +0900
Message-Id: <1283442391-23612-16-git-send-email-namhyung@gmail.com>
X-Mailer: git-send-email 1.7.2.2
In-Reply-To: <1283442391-23612-1-git-send-email-namhyung@gmail.com>
References: <1283442391-23612-1-git-send-email-namhyung@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use new 'addrp', 'datavp' and 'datalp' variables in order to remove
unnecessary castings.

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
Cc: Ralf Baechle <ralf@linux-mips.org>
---
 arch/mips/kernel/ptrace.c |   22 +++++++++++-----------
 1 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/arch/mips/kernel/ptrace.c b/arch/mips/kernel/ptrace.c
index 26c29dd..2465ed1 100644
--- a/arch/mips/kernel/ptrace.c
+++ b/arch/mips/kernel/ptrace.c
@@ -259,6 +259,9 @@ long arch_ptrace(struct task_struct *child, long request,
 		 unsigned long addr, unsigned long data)
 {
 	int ret;
+	void __user *addrp = (void __user *) addr;
+	void __user *datavp = (void __user *) data;
+	unsigned long __user *datalp = (void __user *) data;
 
 	switch (request) {
 	/* when I and D space are separate, these will need to be fixed. */
@@ -387,7 +390,7 @@ long arch_ptrace(struct task_struct *child, long request,
 			ret = -EIO;
 			goto out;
 		}
-		ret = put_user(tmp, (unsigned long __user *) data);
+		ret = put_user(tmp, datalp);
 		break;
 	}
 
@@ -479,34 +482,31 @@ long arch_ptrace(struct task_struct *child, long request,
 		}
 
 	case PTRACE_GETREGS:
-		ret = ptrace_getregs(child, (__s64 __user *) data);
+		ret = ptrace_getregs(child, datavp);
 		break;
 
 	case PTRACE_SETREGS:
-		ret = ptrace_setregs(child, (__s64 __user *) data);
+		ret = ptrace_setregs(child, datavp);
 		break;
 
 	case PTRACE_GETFPREGS:
-		ret = ptrace_getfpregs(child, (__u32 __user *) data);
+		ret = ptrace_getfpregs(child, datavp);
 		break;
 
 	case PTRACE_SETFPREGS:
-		ret = ptrace_setfpregs(child, (__u32 __user *) data);
+		ret = ptrace_setfpregs(child, datavp);
 		break;
 
 	case PTRACE_GET_THREAD_AREA:
-		ret = put_user(task_thread_info(child)->tp_value,
-				(unsigned long __user *) data);
+		ret = put_user(task_thread_info(child)->tp_value, datalp);
 		break;
 
 	case PTRACE_GET_WATCH_REGS:
-		ret = ptrace_get_watch_regs(child,
-					(struct pt_watch_regs __user *) addr);
+		ret = ptrace_get_watch_regs(child, addrp);
 		break;
 
 	case PTRACE_SET_WATCH_REGS:
-		ret = ptrace_set_watch_regs(child,
-					(struct pt_watch_regs __user *) addr);
+		ret = ptrace_set_watch_regs(child, addrp);
 		break;
 
 	default:
-- 
1.7.2.2

