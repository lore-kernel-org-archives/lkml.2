Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751944Ab2LTJKF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2012 04:10:05 -0500
Received: from mail.windriver.com ([147.11.1.11]:51638 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751228Ab2LTJIw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2012 04:08:52 -0500
From: Tiejun Chen <tiejun.chen@windriver.com>
To: <benh@kernel.crashing.org>
CC: <linuxppc-dev@lists.ozlabs.org>, <linux-kernel@vger.kernel.org>,
        <jason.wessel@windriver.com>
Subject: [v1][PATCH 4/6] book3e/kgdb: Fix a single stgep case of lazy IRQ
Date: Thu, 20 Dec 2012 17:08:28 +0800
Message-ID: <1355994510-11934-5-git-send-email-tiejun.chen@windriver.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1355994510-11934-1-git-send-email-tiejun.chen@windriver.com>
References: <1355994510-11934-1-git-send-email-tiejun.chen@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When we're in kgdb_singlestep(), we have to work around to get
thread_info by copying from the kernel stack before calling
kgdb_handle_exception(), then copying it back afterwards.

But for PPC64, we have a lazy interrupt implementation. So after
copying thread info frome kernle stack, if we need to replay an
interrupt, we shouldn't restore that previous backup thread info
to make sure we can replay an interrupt lately with a proper
thread info.

This patch use __check_irq_replay() to guarantee this process.

Signed-off-by: Tiejun Chen <tiejun.chen@windriver.com>
---
 arch/powerpc/kernel/irq.c  |   10 ++++++++++
 arch/powerpc/kernel/kgdb.c |    3 ++-
 2 files changed, 12 insertions(+), 1 deletion(-)

diff --git a/arch/powerpc/kernel/irq.c b/arch/powerpc/kernel/irq.c
index 71413f4..30a9cb0 100644
--- a/arch/powerpc/kernel/irq.c
+++ b/arch/powerpc/kernel/irq.c
@@ -332,7 +332,17 @@ bool prep_irq_for_idle(void)
 	return true;
 }
 
+notrace unsigned int check_irq_replay(void)
+{
+	return __check_irq_replay();
+}
+#else
+notrace unsigned int check_irq_replay(void)
+{
+	return 0;
+}
 #endif /* CONFIG_PPC64 */
+EXPORT_SYMBOL(check_irq_replay);
 
 int arch_show_interrupts(struct seq_file *p, int prec)
 {
diff --git a/arch/powerpc/kernel/kgdb.c b/arch/powerpc/kernel/kgdb.c
index 516b44b..6a48db9 100644
--- a/arch/powerpc/kernel/kgdb.c
+++ b/arch/powerpc/kernel/kgdb.c
@@ -151,6 +151,7 @@ static int kgdb_handle_breakpoint(struct pt_regs *regs)
 	return 1;
 }
 
+extern notrace unsigned int check_irq_replay(void);
 static int kgdb_singlestep(struct pt_regs *regs)
 {
 	struct thread_info *thread_info, *exception_thread_info;
@@ -181,7 +182,7 @@ static int kgdb_singlestep(struct pt_regs *regs)
 
 	kgdb_handle_exception(0, SIGTRAP, 0, regs);
 
-	if (thread_info != exception_thread_info)
+	if ((thread_info != exception_thread_info) && (!check_irq_replay()))
 		/* Restore current_thread_info lastly. */
 		memcpy(exception_thread_info, backup_current_thread_info, sizeof *thread_info);
 
-- 
1.7.9.5

