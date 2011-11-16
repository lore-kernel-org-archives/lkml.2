Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755721Ab1KPKSy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Nov 2011 05:18:54 -0500
Received: from he.sipsolutions.net ([78.46.109.217]:59341 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755467Ab1KPKSx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Nov 2011 05:18:53 -0500
Subject: [PATCH] tracing: add trace console
From: Johannes Berg <johannes@sipsolutions.net>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 16 Nov 2011 11:18:48 +0100
Message-ID: <1321438728.4773.16.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

As described in the Kconfig entry, logging printk
output is useful to correlate (existing) printk
debugging with (existing) tracing. The easiest way
to achieve this is to register a console that just
calls trace_printk(), which this module does.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 kernel/trace/Kconfig         |   13 ++++++++++
 kernel/trace/Makefile        |    2 +
 kernel/trace/trace-console.c |   55 +++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 70 insertions(+)

--- a/kernel/trace/Kconfig	2011-11-16 11:11:27.000000000 +0100
+++ b/kernel/trace/Kconfig	2011-11-16 11:11:35.000000000 +0100
@@ -368,6 +368,19 @@ config BLK_DEV_IO_TRACE
 
 	  If unsure, say N.
 
+config TRACE_CONSOLE
+	tristate "Support for a tracing console"
+	help
+	  Say M (or Y if you must, but this is not recommended) to be able
+	  to get a tracing console that puts every kernel message into the
+	  tracing infrastructure using trace_printk(). This is useful to
+	  correlate (existing) printk debugging with tracing. When using it
+	  remember to set the console level, e.g. with "dmesg -n8".
+
+	  The module is called trace-console.
+
+	  Say N if unsure.
+
 config KPROBE_EVENT
 	depends on KPROBES
 	depends on HAVE_REGS_AND_STACK_ACCESS_API
--- a/kernel/trace/Makefile	2011-11-16 11:11:27.000000000 +0100
+++ b/kernel/trace/Makefile	2011-11-16 11:11:35.000000000 +0100
@@ -62,4 +62,6 @@ ifeq ($(CONFIG_TRACING),y)
 obj-$(CONFIG_KGDB_KDB) += trace_kdb.o
 endif
 
+obj-$(CONFIG_TRACE_CONSOLE) += trace-console.o
+
 libftrace-y := ftrace.o
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ b/kernel/trace/trace-console.c	2011-11-16 11:11:35.000000000 +0100
@@ -0,0 +1,55 @@
+/*
+ * Copyright (c) 2011 Intel Corporation. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+ *
+ * The full GNU General Public License is included in this distribution in
+ * the file called COPYING.
+ *
+ * Author: Johannes Berg <johannes.berg@intel.com>
+ */
+#include <linux/init.h>
+#include <linux/module.h>
+#include <linux/console.h>
+
+MODULE_AUTHOR("Johannes Berg <johannes.berg@intel.com>");
+MODULE_DESCRIPTION("Console driver for tracing");
+MODULE_LICENSE("GPL");
+
+
+static void trace_msg(struct console *con, const char *msg, unsigned int len)
+{
+	trace_printk("%*s", len, msg);
+}
+
+static struct console traceconsole = {
+	.name	= "tracecon",
+	.flags	= CON_ENABLED,
+	.write	= trace_msg,
+};
+
+static int __init init_traceconsole(void)
+{
+	register_console(&traceconsole);
+	return 0;
+}
+
+static void __exit exit_traceconsole(void)
+{
+	unregister_console(&traceconsole);
+}
+
+module_init(init_traceconsole);
+module_exit(exit_traceconsole);


