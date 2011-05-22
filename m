Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755675Ab1EVOvF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 May 2011 10:51:05 -0400
Received: from a.ns.miles-group.at ([95.130.255.143]:43789 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753382Ab1EVOux (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 May 2011 10:50:53 -0400
From: Richard Weinberger <richard@nod.at>
To: akpm@linux-foundation.org
Cc: user-mode-linux-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        Richard Weinberger <richard@nod.at>
Subject: [PATCH 5/7] um: print info about fatal segfaults
Date: Sun, 22 May 2011 16:48:34 +0200
Message-Id: <1306075716-20042-5-git-send-email-richard@nod.at>
X-Mailer: git-send-email 1.7.4.2
In-Reply-To: <1306075716-20042-1-git-send-email-richard@nod.at>
References: <1306075716-20042-1-git-send-email-richard@nod.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Print a short info about fatal segfaults like other archs do.

Signed-off-by: Richard Weinberger <richard@nod.at>
---
 arch/um/kernel/trap.c |   24 ++++++++++++++++++++++++
 1 files changed, 24 insertions(+), 0 deletions(-)

diff --git a/arch/um/kernel/trap.c b/arch/um/kernel/trap.c
index 637c650..8c7b882 100644
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
+	printk("%s%s[%d]: segfault at %lx ip %p sp %p error %x",
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

