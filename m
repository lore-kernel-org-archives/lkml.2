Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933378Ab0HEOj4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 10:39:56 -0400
Received: from mail.windriver.com ([147.11.1.11]:41216 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933346Ab0HEOiv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 10:38:51 -0400
From: Jason Wessel <jason.wessel@windriver.com>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, kgdb-bugreport@lists.sourceforge.net,
        Jason Wessel <jason.wessel@windriver.com>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH 09/17] arm,kgdb: Add ability to trap into debugger on notify_die
Date: Thu,  5 Aug 2010 09:37:50 -0500
Message-Id: <1281019078-6636-10-git-send-email-jason.wessel@windriver.com>
X-Mailer: git-send-email 1.6.4.rc1
In-Reply-To: <1281019078-6636-9-git-send-email-jason.wessel@windriver.com>
References: <1281019078-6636-1-git-send-email-jason.wessel@windriver.com>
 <1281019078-6636-2-git-send-email-jason.wessel@windriver.com>
 <1281019078-6636-3-git-send-email-jason.wessel@windriver.com>
 <1281019078-6636-4-git-send-email-jason.wessel@windriver.com>
 <1281019078-6636-5-git-send-email-jason.wessel@windriver.com>
 <1281019078-6636-6-git-send-email-jason.wessel@windriver.com>
 <1281019078-6636-7-git-send-email-jason.wessel@windriver.com>
 <1281019078-6636-8-git-send-email-jason.wessel@windriver.com>
 <1281019078-6636-9-git-send-email-jason.wessel@windriver.com>
X-OriginalArrivalTime: 05 Aug 2010 14:38:18.0449 (UTC) FILETIME=[D8612C10:01CB34AB]
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
1.6.3.3

