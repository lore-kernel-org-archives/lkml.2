Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761566Ab0J2Sog (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Oct 2010 14:44:36 -0400
Received: from mail.windriver.com ([147.11.1.11]:58540 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761551Ab0J2Sof (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Oct 2010 14:44:35 -0400
From: Jason Wessel <jason.wessel@windriver.com>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, kgdb-bugreport@lists.sourceforge.net,
        Jason Wessel <jason.wessel@windriver.com>
Subject: [PATCH 1/7] kdb: Add kdb kernel module sample
Date: Fri, 29 Oct 2010 13:43:35 -0500
Message-Id: <1288377821-24520-2-git-send-email-jason.wessel@windriver.com>
X-Mailer: git-send-email 1.6.4.rc1
In-Reply-To: <1288377821-24520-1-git-send-email-jason.wessel@windriver.com>
References: <1288377821-24520-1-git-send-email-jason.wessel@windriver.com>
X-OriginalArrivalTime: 29 Oct 2010 18:43:48.0269 (UTC) FILETIME=[392615D0:01CB7799]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add an example of how to add a dynamic kdb shell command via a kernel
module.

Signed-off-by: Jason Wessel <jason.wessel@windriver.com>
---
 Documentation/DocBook/kgdb.tmpl |   13 ++++++++-
 samples/Kconfig                 |    7 ++++
 samples/Makefile                |    2 +-
 samples/kdb/Makefile            |    1 +
 samples/kdb/kdb_hello.c         |   60 +++++++++++++++++++++++++++++++++++++++
 5 files changed, 81 insertions(+), 2 deletions(-)
 create mode 100644 samples/kdb/Makefile
 create mode 100644 samples/kdb/kdb_hello.c

diff --git a/Documentation/DocBook/kgdb.tmpl b/Documentation/DocBook/kgdb.tmpl
index 490d862..d71b57f 100644
--- a/Documentation/DocBook/kgdb.tmpl
+++ b/Documentation/DocBook/kgdb.tmpl
@@ -710,7 +710,18 @@ Task Addr       Pid   Parent [*] cpu State Thread     Command
         <listitem><para>A simple shell</para></listitem>
         <listitem><para>The kdb core command set</para></listitem>
         <listitem><para>A registration API to register additional kdb shell commands.</para>
-        <para>A good example of a self-contained kdb module is the "ftdump" command for dumping the ftrace buffer.  See: kernel/trace/trace_kdb.c</para></listitem>
+	<itemizedlist>
+        <listitem><para>A good example of a self-contained kdb module
+        is the "ftdump" command for dumping the ftrace buffer.  See:
+        kernel/trace/trace_kdb.c</para></listitem>
+        <listitem><para>For an example of how to dynamically register
+        a new kdb command you can build the kdb_hello.ko kernel module
+        from samples/kdb/kdb_hello.c.  To build this example you can
+        set CONFIG_SAMPLES=y and CONFIG_SAMPLE_KDB=m in your kernel
+        config.  Later run "modprobe kdb_hello" and the next time you
+        enter the kdb shell, you can run the "hello"
+        command.</para></listitem>
+	</itemizedlist></listitem>
         <listitem><para>The implementation for kdb_printf() which
         emits messages directly to I/O drivers, bypassing the kernel
         log.</para></listitem>
diff --git a/samples/Kconfig b/samples/Kconfig
index 954a1d5..e03cf0e 100644
--- a/samples/Kconfig
+++ b/samples/Kconfig
@@ -54,4 +54,11 @@ config SAMPLE_KFIFO
 
 	  If in doubt, say "N" here.
 
+config SAMPLE_KDB
+	tristate "Build kdb command exmaple -- loadable modules only"
+	depends on KGDB_KDB && m
+	help
+	  Build an example of how to dynamically add the hello
+	  command to the kdb shell.
+
 endif # SAMPLES
diff --git a/samples/Makefile b/samples/Makefile
index 76b3c34..f26c095 100644
--- a/samples/Makefile
+++ b/samples/Makefile
@@ -1,4 +1,4 @@
 # Makefile for Linux samples code
 
 obj-$(CONFIG_SAMPLES)	+= kobject/ kprobes/ tracepoints/ trace_events/ \
-			   hw_breakpoint/ kfifo/
+			   hw_breakpoint/ kfifo/ kdb/
diff --git a/samples/kdb/Makefile b/samples/kdb/Makefile
new file mode 100644
index 0000000..fbedf39
--- /dev/null
+++ b/samples/kdb/Makefile
@@ -0,0 +1 @@
+obj-$(CONFIG_SAMPLE_KDB) += kdb_hello.o
diff --git a/samples/kdb/kdb_hello.c b/samples/kdb/kdb_hello.c
new file mode 100644
index 0000000..c1c2fa0
--- /dev/null
+++ b/samples/kdb/kdb_hello.c
@@ -0,0 +1,60 @@
+/*
+ * Created by: Jason Wessel <jason.wessel@windriver.com>
+ *
+ * Copyright (c) 2010 Wind River Systems, Inc.  All Rights Reserved.
+ *
+ * This file is licensed under the terms of the GNU General Public
+ * License version 2. This program is licensed "as is" without any
+ * warranty of any kind, whether express or implied.
+ */
+
+#include <linux/module.h>
+#include <linux/kdb.h>
+
+/*
+ * All kdb shell command call backs receive argc and argv, where
+ * argv[0] is the command the end user typed
+ */
+static int kdb_hello_cmd(int argc, const char **argv)
+{
+	if (argc > 1)
+		return KDB_ARGCOUNT;
+
+	if (argc)
+		kdb_printf("Hello %s.\n", argv[1]);
+	else
+		kdb_printf("Hello world!\n");
+
+	return 0;
+}
+
+
+static int __init kdb_hello_cmd_init(void)
+{
+	/*
+	 * Registration of a dynamically added kdb command is done with
+	 * kdb_register() with the arguments being:
+	 *   1: The name of the shell command
+	 *   2: The function that processes the command
+	 *   3: Description of the usage of any arguments
+	 *   4: Descriptive text when you run help
+	 *   5: Number of characters to complete the command
+	 *      0 == type the whole command
+	 *      1 == match both "g" and "go" for example
+	 */
+	kdb_register("hello", kdb_hello_cmd, "[string]",
+		     "Say Hello World or Hello [string]", 0);
+	return 0;
+}
+
+static void __exit kdb_hello_cmd_exit(void)
+{
+	kdb_unregister("hello");
+}
+
+module_init(kdb_hello_cmd_init);
+module_exit(kdb_hello_cmd_exit);
+
+MODULE_AUTHOR("WindRiver");
+MODULE_DESCRIPTION("KDB example to add a hello command");
+MODULE_LICENSE("GPL");
-- 
1.6.3.3

