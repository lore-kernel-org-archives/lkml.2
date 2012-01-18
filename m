Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755299Ab2ARHD7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jan 2012 02:03:59 -0500
Received: from mail-ey0-f202.google.com ([209.85.215.202]:44624 "EHLO
	mail-ey0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751506Ab2ARHD6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jan 2012 02:03:58 -0500
From: Simon Glass <sjg@chromium.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Stephen Boyd <sboyd@codeaurora.org>, Simon Glass <sjg@chromium.org>
Subject: [PATCH v2] ARM: Adjust backtrace messages to line up with x86 kernel
Date: Tue, 17 Jan 2012 23:03:51 -0800
Message-Id: <1326870231-30987-1-git-send-email-sjg@chromium.org>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1326831362-28703-1-git-send-email-sjg@chromium.org>
References: <1326831362-28703-1-git-send-email-sjg@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It is nice to print the backtrace message on its own line, and also
regardless of the setting of CONFIG_ARM_UNWIND. This means that tools
which parse the backtrace don't need a special case for the first line.
It also makes it more like the x86 kernel output.

I believe we should also put KERN_EMERG at the start of this. Otherwise
it won't appear in console output (although it will appear in the logs
after a reboot).

Signed-off-by: Simon Glass <sjg@chromium.org>
---
Changes in v2:
- Fix typo and remove \n from non CONFIG_ARM_UNWIND path
- Remove __func__ from the unwind_backtrace() function

 arch/arm/kernel/traps.c  |    3 ++-
 arch/arm/kernel/unwind.c |    2 +-
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/arm/kernel/traps.c b/arch/arm/kernel/traps.c
index 99a5727..3d3cae2 100644
--- a/arch/arm/kernel/traps.c
+++ b/arch/arm/kernel/traps.c
@@ -165,6 +165,7 @@ static void dump_instr(const char *lvl, struct pt_regs *regs)
 #ifdef CONFIG_ARM_UNWIND
 static inline void dump_backtrace(struct pt_regs *regs, struct task_struct *tsk)
 {
+	printk(KERN_EMERG "Backtrace:\n");
 	unwind_backtrace(regs, tsk);
 }
 #else
@@ -173,7 +174,7 @@ static void dump_backtrace(struct pt_regs *regs, struct task_struct *tsk)
 	unsigned int fp, mode;
 	int ok = 1;
 
-	printk("Backtrace: ");
+	printk(KERN_EMERG "Backtrace: ");
 
 	if (!tsk)
 		tsk = current;
diff --git a/arch/arm/kernel/unwind.c b/arch/arm/kernel/unwind.c
index 00df012..451852a 100644
--- a/arch/arm/kernel/unwind.c
+++ b/arch/arm/kernel/unwind.c
@@ -410,7 +410,7 @@ void unwind_backtrace(struct pt_regs *regs, struct task_struct *tsk)
 	struct stackframe frame;
 	register unsigned long current_sp asm ("sp");
 
-	pr_debug("%s(regs = %p tsk = %p)\n", __func__, regs, tsk);
+	pr_debug("(regs = %p tsk = %p)\n", regs, tsk);
 
 	if (!tsk)
 		tsk = current;
-- 
1.7.7.3

