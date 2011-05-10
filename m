Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752265Ab1EJTnz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 May 2011 15:43:55 -0400
Received: from a.ns.miles-group.at ([95.130.255.143]:49858 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752217Ab1EJTny (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 May 2011 15:43:54 -0400
From: Richard Weinberger <richard@nod.at>
To: linux-kernel@vger.kernel.org
Cc: user-mode-linux-devel@lists.sourceforge.net,
        Richard Weinberger <richard@nod.at>
Subject: [PATCH 3/3] um: print info about fatal segfaults
Date: Tue, 10 May 2011 21:42:17 +0200
Message-Id: <1305056537-22299-3-git-send-email-richard@nod.at>
X-Mailer: git-send-email 1.7.4.2
In-Reply-To: <1305056537-22299-1-git-send-email-richard@nod.at>
References: <1305056537-22299-1-git-send-email-richard@nod.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Print a short info about fatal segfaults like other archs do.

Signed-off-by: Richard Weinberger <richard@nod.at>
---
 arch/um/kernel/trap.c |   24 ++++++++++++++++++++++++
 1 files changed, 24 insertions(+), 0 deletions(-)

diff --git a/arch/um/kernel/trap.c b/arch/um/kernel/trap.c
index 637c650..b2e3d82 100644
--- a/arch/um/kernel/trap.c
+++ b/arch/um/kernel/trap.c
@@ -113,6 +113,27 @@ out_of_memory:
 	return 0;
 }
 
+static void show_segv_info(struct uml_pt_regs *regs)
+{
+	struct task_struct *tsk = current;
+	struct faultinfo *fi = UPT_FAULTINFO(regs);
+
+	if (!unhandled_signal(tsk, SIGSEGV))
+		return;
+
+	if (!printk_ratelimit())
+		return;
+
+	printk(KERN_INFO "%s%s[%d]: segfault at %lx ip %p sp %p error %x",
+		task_pid_nr(tsk) > 1 ? KERN_INFO : KERN_EMERG,
+		tsk->comm, task_pid_nr(tsk), FAULT_ADDRESS(*fi),
+		(void *)UPT_IP(regs), (void *)UPT_SP(regs),
+		fi->error_code);
+
+	print_vma_addr(KERN_CONT " in ", UPT_IP(regs));
+	printk(KERN_CONT "\n");
+}
+
 static void bad_segv(struct faultinfo fi, unsigned long ip)
 {
 	struct siginfo si;
@@ -141,6 +162,7 @@ void segv_handler(int sig, struct uml_pt_regs *regs)
 	struct faultinfo * fi = UPT_FAULTINFO(regs);
 
 	if (UPT_IS_USER(regs) && !SEGV_IS_FIXABLE(fi)) {
+		show_segv_info(regs);
 		bad_segv(*fi, UPT_IP(regs));
 		return;
 	}
@@ -202,6 +224,8 @@ unsigned long segv(struct faultinfo fi, unsigned long ip, int is_user,
 		      address, ip);
 	}
 
+	show_segv_info(regs);
+
 	if (err == -EACCES) {
 		si.si_signo = SIGBUS;
 		si.si_errno = 0;
-- 
1.7.4.2

