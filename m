Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752159Ab1EJTnj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 May 2011 15:43:39 -0400
Received: from a.ns.miles-group.at ([95.130.255.143]:49852 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751546Ab1EJTnh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 May 2011 15:43:37 -0400
From: Richard Weinberger <richard@nod.at>
To: linux-kernel@vger.kernel.org
Cc: user-mode-linux-devel@lists.sourceforge.net,
        Richard Weinberger <richard@nod.at>
Subject: [PATCH 1/3] um: add earlyprintk support
Date: Tue, 10 May 2011 21:42:15 +0200
Message-Id: <1305056537-22299-1-git-send-email-richard@nod.at>
X-Mailer: git-send-email 1.7.4.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

User Mode Linux can also benefit from earlyprintk.
UML's earlyprintk writes kernel messages directly to stdout.

Signed-off-by: Richard Weinberger <richard@nod.at>
---
 arch/um/Kconfig.debug         |   10 ++++++++++
 arch/um/include/shared/os.h   |    1 +
 arch/um/kernel/Makefile       |    1 +
 arch/um/kernel/early_printk.c |   33 +++++++++++++++++++++++++++++++++
 arch/um/os-Linux/util.c       |    5 +++++
 5 files changed, 50 insertions(+), 0 deletions(-)
 create mode 100644 arch/um/kernel/early_printk.c

diff --git a/arch/um/Kconfig.debug b/arch/um/Kconfig.debug
index 8fce5e5..85c86edd 100644
--- a/arch/um/Kconfig.debug
+++ b/arch/um/Kconfig.debug
@@ -37,4 +37,14 @@ config DEBUG_STACK_USAGE
 	  stack seen so far.
 
 	  This option will slow down process creation and destruction somewhat.
+
+config EARLY_PRINTK
+	bool "Early printk"
+	default y
+	---help---
+	  Write kernel log output directly to stdout.
+
+	  This is useful for kernel debugging when your machine crashes very
+	  early before the console code is initialized.
+
 endmenu
diff --git a/arch/um/include/shared/os.h b/arch/um/include/shared/os.h
index c4617ba..745a1bc 100644
--- a/arch/um/include/shared/os.h
+++ b/arch/um/include/shared/os.h
@@ -238,6 +238,7 @@ extern int raw(int fd);
 extern void setup_machinename(char *machine_out);
 extern void setup_hostinfo(char *buf, int len);
 extern void os_dump_core(void) __attribute__ ((noreturn));
+extern void um_early_printk(const char *s, unsigned int n);
 
 /* time.c */
 extern void idle_sleep(unsigned long long nsecs);
diff --git a/arch/um/kernel/Makefile b/arch/um/kernel/Makefile
index 1119233..c4491c1 100644
--- a/arch/um/kernel/Makefile
+++ b/arch/um/kernel/Makefile
@@ -17,6 +17,7 @@ obj-y = config.o exec.o exitcode.o init_task.o irq.o ksyms.o mem.o \
 obj-$(CONFIG_BLK_DEV_INITRD) += initrd.o
 obj-$(CONFIG_GPROF)	+= gprof_syms.o
 obj-$(CONFIG_GCOV)	+= gmon_syms.o
+obj-$(CONFIG_EARLY_PRINTK) += early_printk.o
 
 USER_OBJS := config.o
 
diff --git a/arch/um/kernel/early_printk.c b/arch/um/kernel/early_printk.c
new file mode 100644
index 0000000..ec649bf
--- /dev/null
+++ b/arch/um/kernel/early_printk.c
@@ -0,0 +1,33 @@
+/*
+ * Copyright (C) 2011 Richard Weinberger <richrd@nod.at>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/kernel.h>
+#include <linux/console.h>
+#include <linux/init.h>
+#include "os.h"
+
+static void early_console_write(struct console *con, const char *s, unsigned int n)
+{
+	um_early_printk(s, n);
+}
+
+static struct console early_console = {
+	.name = "earlycon",
+	.write = early_console_write,
+	.flags = CON_BOOT,
+	.index = -1,
+};
+
+static int __init setup_early_printk(char *buf)
+{
+	register_console(&early_console);
+
+	return 0;
+}
+
+early_param("earlyprintk", setup_early_printk);
diff --git a/arch/um/os-Linux/util.c b/arch/um/os-Linux/util.c
index 6ea7797..cac25ad 100644
--- a/arch/um/os-Linux/util.c
+++ b/arch/um/os-Linux/util.c
@@ -118,3 +118,8 @@ void os_dump_core(void)
 
 	abort();
 }
+
+void um_early_printk(const char *s, unsigned int n)
+{
+	printf("%.*s", n, s);
+}
-- 
1.7.4.2

