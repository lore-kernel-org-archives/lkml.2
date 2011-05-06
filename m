Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756164Ab1EFJnd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 May 2011 05:43:33 -0400
Received: from hera.kernel.org ([140.211.167.34]:59772 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755312Ab1EFJnb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 May 2011 05:43:31 -0400
Date: Fri, 6 May 2011 09:43:03 GMT
From: tip-bot for Frederic Weisbecker <fweisbec@gmail.com>
Message-ID: <tip-925f83c085e1bb08435556c5b4844a60de002e31@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        linuxppc-dev@lists.ozlabs.org, fweisbec@gmail.com, stable@kernel.org,
        tglx@linutronix.de, mingo@elte.hu, prasad@linux.vnet.ibm.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, fweisbec@gmail.com, stable@kernel.org,
        tglx@linutronix.de, mingo@elte.hu, prasad@linux.vnet.ibm.com
In-Reply-To: <1304639598-4707-1-git-send-email-fweisbec@gmail.com>
References: <1304639598-4707-1-git-send-email-fweisbec@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] hw_breakpoints, powerpc: Fix CONFIG_HAVE_HW_BREAKPOINT off-case in ptrace_set_debugreg()
Git-Commit-ID: 925f83c085e1bb08435556c5b4844a60de002e31
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 06 May 2011 09:43:05 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  925f83c085e1bb08435556c5b4844a60de002e31
Gitweb:     http://git.kernel.org/tip/925f83c085e1bb08435556c5b4844a60de002e31
Author:     Frederic Weisbecker <fweisbec@gmail.com>
AuthorDate: Fri, 6 May 2011 01:53:18 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 6 May 2011 11:24:46 +0200

hw_breakpoints, powerpc: Fix CONFIG_HAVE_HW_BREAKPOINT off-case in ptrace_set_debugreg()

We make use of ptrace_get_breakpoints() / ptrace_put_breakpoints() to
protect ptrace_set_debugreg() even if CONFIG_HAVE_HW_BREAKPOINT if off.
However in this case, these APIs are not implemented.

To fix this, push the protection down inside the relevant ifdef.
Best would be to export the code inside
CONFIG_HAVE_HW_BREAKPOINT into a standalone function to cleanup
the ifdefury there and call the breakpoint ref API inside. But
as it is more invasive, this should be rather made in an -rc1.

Fixes this build error:

  arch/powerpc/kernel/ptrace.c:1594: error: implicit declaration of function 'ptrace_get_breakpoints' make[2]: ***

Reported-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LPPC <linuxppc-dev@lists.ozlabs.org>
Cc: Prasad <prasad@linux.vnet.ibm.com>
Cc: v2.6.33.. <stable@kernel.org>
Link: http://lkml.kernel.org/r/1304639598-4707-1-git-send-email-fweisbec@gmail.com
Signed-off-by: Ingo Molnar <mingo@elte.hu>
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
