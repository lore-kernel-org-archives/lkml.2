Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754408Ab1EEXx1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 May 2011 19:53:27 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:42171 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754264Ab1EEXx0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 May 2011 19:53:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=wPX2Jd7ZTAdA4wTwe8n97yr6rfHN9aY/AHvsoEg6RFwpmJcEp639dxqLMmfpOMduGZ
         Y6OfapgajreCPbXXW2DECbHX2VPB3kbYptCJ/vVEBALDt+ZVX5YxuEMSINlkUbqYKg05
         zMJKXNpP2iG9f3tFvqPqM10tJW3D55GrOgaIA=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        LPPC <linuxppc-dev@lists.ozlabs.org>,
        Prasad <prasad@linux.vnet.ibm.com>, "v2.6.33.." <stable@kernel.org>
Subject: [PATCH] powerpc, hw_breakpoints: Fix CONFIG_HAVE_HW_BREAKPOINT off-case in ptrace_set_debugreg
Date: Fri,  6 May 2011 01:53:18 +0200
Message-Id: <1304639598-4707-1-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We make use of ptrace_get_breakpoints() / ptrace_put_breakpoints()
to protect ptrace_set_debugreg() even if CONFIG_HAVE_HW_BREAKPOINT
if off. However in this case, these APIs are not implemented.

To fix this, push the protection down inside the relevant ifdef.
Best would be to export the code inside CONFIG_HAVE_HW_BREAKPOINT
into a standalone function to cleanup the ifdefury there and call
the breakpoint ref API inside. But as it is more invasive, this
should be rather made in an -rc1.

Fixes:

arch/powerpc/kernel/ptrace.c:1594: error: implicit declaration of function 'ptrace_get_breakpoints'
make[2]: *** [arch/powerpc/kernel/ptrace.o] Error 1
make[1]: *** [arch/powerpc/kernel] Error 2
make: *** [sub-make] Error 2

Reported-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Prasad <prasad@linux.vnet.ibm.com>
Cc: v2.6.33.. <stable@kernel.org>
---
 arch/powerpc/kernel/ptrace.c |   15 +++++++++++----
 1 files changed, 11 insertions(+), 4 deletions(-)

diff --git a/arch/powerpc/kernel/ptrace.c b/arch/powerpc/kernel/ptrace.c
index 4edeeb3..a6ae1cf 100644
--- a/arch/powerpc/kernel/ptrace.c
+++ b/arch/powerpc/kernel/ptrace.c
@@ -933,12 +933,16 @@ int ptrace_set_debugreg(struct task_struct *task, unsigned long addr,
 	if (data && !(data & DABR_TRANSLATION))
 		return -EIO;
 #ifdef CONFIG_HAVE_HW_BREAKPOINT
+	if (ptrace_get_breakpoints(task) < 0)
+		return -ESRCH;
+
 	bp = thread->ptrace_bps[0];
 	if ((!data) || !(data & (DABR_DATA_WRITE | DABR_DATA_READ))) {
 		if (bp) {
 			unregister_hw_breakpoint(bp);
 			thread->ptrace_bps[0] = NULL;
 		}
+		ptrace_put_breakpoints(task);
 		return 0;
 	}
 	if (bp) {
@@ -948,9 +952,12 @@ int ptrace_set_debugreg(struct task_struct *task, unsigned long addr,
 					(DABR_DATA_WRITE | DABR_DATA_READ),
 							&attr.bp_type);
 		ret =  modify_user_hw_breakpoint(bp, &attr);
-		if (ret)
+		if (ret) {
+			ptrace_put_breakpoints(task);
 			return ret;
+		}
 		thread->ptrace_bps[0] = bp;
+		ptrace_put_breakpoints(task);
 		thread->dabr = data;
 		return 0;
 	}
@@ -965,9 +972,12 @@ int ptrace_set_debugreg(struct task_struct *task, unsigned long addr,
 							ptrace_triggered, task);
 	if (IS_ERR(bp)) {
 		thread->ptrace_bps[0] = NULL;
+		ptrace_put_breakpoints(task);
 		return PTR_ERR(bp);
 	}
 
+	ptrace_put_breakpoints(task);
+
 #endif /* CONFIG_HAVE_HW_BREAKPOINT */
 
 	/* Move contents to the DABR register */
@@ -1591,10 +1601,7 @@ long arch_ptrace(struct task_struct *child, long request,
 	}
 
 	case PTRACE_SET_DEBUGREG:
-		if (ptrace_get_breakpoints(child) < 0)
-			return -ESRCH;
 		ret = ptrace_set_debugreg(child, addr, data);
-		ptrace_put_breakpoints(child);
 		break;
 
 #ifdef CONFIG_PPC64
-- 
1.7.3.2

