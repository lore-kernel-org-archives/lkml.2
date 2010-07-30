Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760677Ab0G3TSs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jul 2010 15:18:48 -0400
Received: from mail.windriver.com ([147.11.1.11]:33960 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756216Ab0G3TSW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jul 2010 15:18:22 -0400
From: Jason Wessel <jason.wessel@windriver.com>
To: linux-kernel@vger.kernel.org
Cc: kgdb-bugreport@lists.sourceforge.net, mingo@elte.hu,
        Jason Wessel <jason.wessel@windriver.com>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH 09/15] arm,kgdb: Add ability to trap into debugger on notify_die
Date: Fri, 30 Jul 2010 14:17:30 -0500
Message-Id: <1280517456-1167-10-git-send-email-jason.wessel@windriver.com>
X-Mailer: git-send-email 1.6.4.rc1
In-Reply-To: <1280517456-1167-1-git-send-email-jason.wessel@windriver.com>
References: <1280517456-1167-1-git-send-email-jason.wessel@windriver.com>
X-OriginalArrivalTime: 30 Jul 2010 19:17:46.0970 (UTC) FILETIME=[E4B7EBA0:01CB301B]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that ARM implements the notify die handlers, add the ability for
the kernel debugger to receive the notifications.

Signed-off-by: Jason Wessel <jason.wessel@windriver.com>
CC: Russell King <linux@arm.linux.org.uk>
CC: linux-arm-kernel@lists.infradead.org
---
 arch/arm/kernel/kgdb.c |   34 ++++++++++++++++++++++++++++++++++
 1 files changed, 34 insertions(+), 0 deletions(-)

diff --git a/arch/arm/kernel/kgdb.c b/arch/arm/kernel/kgdb.c
index cf846ca..778c2f7 100644
--- a/arch/arm/kernel/kgdb.c
+++ b/arch/arm/kernel/kgdb.c
@@ -10,6 +10,7 @@
  *           Deepak Saxena <dsaxena@plexity.net>
  */
 #include <linux/irq.h>
+#include <linux/kdebug.h>
 #include <linux/kgdb.h>
 #include <asm/traps.h>
 
@@ -180,6 +181,33 @@ void kgdb_roundup_cpus(unsigned long flags)
        local_irq_disable();
 }
 
+static int __kgdb_notify(struct die_args *args, unsigned long cmd)
+{
+	struct pt_regs *regs = args->regs;
+
+	if (kgdb_handle_exception(1, args->signr, cmd, regs))
+		return NOTIFY_DONE;
+	return NOTIFY_STOP;
+}
+static int
+kgdb_notify(struct notifier_block *self, unsigned long cmd, void *ptr)
+{
+	unsigned long flags;
+	int ret;
+
+	local_irq_save(flags);
+	ret = __kgdb_notify(ptr, cmd);
+	local_irq_restore(flags);
+
+	return ret;
+}
+
+static struct notifier_block kgdb_notifier = {
+	.notifier_call	= kgdb_notify,
+	.priority	= -INT_MAX,
+};
+
+
 /**
  *	kgdb_arch_init - Perform any architecture specific initalization.
  *
@@ -188,6 +216,11 @@ void kgdb_roundup_cpus(unsigned long flags)
  */
 int kgdb_arch_init(void)
 {
+	int ret = register_die_notifier(&kgdb_notifier);
+
+	if (ret != 0)
+		return ret;
+
 	register_undef_hook(&kgdb_brkpt_hook);
 	register_undef_hook(&kgdb_compiled_brkpt_hook);
 
@@ -204,6 +237,7 @@ void kgdb_arch_exit(void)
 {
 	unregister_undef_hook(&kgdb_brkpt_hook);
 	unregister_undef_hook(&kgdb_compiled_brkpt_hook);
+	unregister_die_notifier(&kgdb_notifier);
 }
 
 /*
-- 
1.6.4.rc1

