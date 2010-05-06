Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759532Ab0EFSDS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 May 2010 14:03:18 -0400
Received: from e28smtp06.in.ibm.com ([122.248.162.6]:49189 "EHLO
	e28smtp06.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759458Ab0EFSDK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 May 2010 14:03:10 -0400
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>
Cc: Masami Hiramatsu <mhiramat@redhat.com>, Mel Gorman <mel@csn.ul.ie>,
       Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
       Randy Dunlap <rdunlap@xenotime.net>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Roland McGrath <roland@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Oleg Nesterov <oleg@redhat.com>, Mark Wielaard <mjw@redhat.com>,
       Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jim Keniston <jkenisto@linux.vnet.ibm.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       "Frank Ch. Eigler" <fche@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Date: Thu, 06 May 2010 23:33:06 +0530
Message-Id: <20100506180306.28877.6385.sendpatchset@localhost6.localdomain6>
In-Reply-To: <20100506180139.28877.81699.sendpatchset@localhost6.localdomain6>
References: <20100506180139.28877.81699.sendpatchset@localhost6.localdomain6>
Subject: [PATCH v3 7/10] samples: Uprobes samples
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

samples.patch

From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>

Uprobes Samples

This provides an example uprobes module in the samples directory.

To run this module run (as root)
 insmod uprobe_example.ko vaddr=<vaddr> pid=<pid>
	 Where <vaddr> is the address where we want to place the probe.
		<pid> is the pid of the process we are interested to probe.

 example: -
# cd samples/uprobes

[get the virtual address to place the probe.]
# vaddr=0x$(objdump -T /bin/bash |awk '/echo_builtin/ {print $1}')

[Run a bash shell in the background; have it echo 4 lines.]
# (sleep 10; echo 1; echo 2; echo 3; echo 4) &
[Probe calls echo_builtin() in the background bash process.]

# insmod uprobe_example.ko vaddr=$vaddr pid=$!
# sleep 10
# rmmod uprobe_example
# dmesg | tail -n 3
Registering uprobe on pid 10875, vaddr 0x45aa30
Unregistering uprobe on pid 10875, vaddr 0x45aa30
Probepoint was hit 4 times
#
[ Output shows that echo_builtin function was hit 4 times. ]

Signed-off-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
---

 samples/Kconfig                  |    7 +++
 samples/Makefile                 |    2 -
 samples/uprobes/Makefile         |   17 ++++++++
 samples/uprobes/uprobe_example.c |   83 ++++++++++++++++++++++++++++++++++++++
 4 files changed, 108 insertions(+), 1 deletions(-)
 create mode 100644 samples/uprobes/Makefile
 create mode 100644 samples/uprobes/uprobe_example.c


diff --git a/samples/Kconfig b/samples/Kconfig
index 8924f72..50b8b1c 100644
--- a/samples/Kconfig
+++ b/samples/Kconfig
@@ -44,4 +44,11 @@ config SAMPLE_HW_BREAKPOINT
 	help
 	  This builds kernel hardware breakpoint example modules.
 
+config SAMPLE_UPROBES
+	tristate "Build uprobes example -- loadable module only"
+	depends on UPROBES && m
+	help
+	  This builds uprobes example module.
+
+
 endif # SAMPLES
diff --git a/samples/Makefile b/samples/Makefile
index 0f15e6d..c8fe6f9 100644
--- a/samples/Makefile
+++ b/samples/Makefile
@@ -1,4 +1,4 @@
 # Makefile for Linux samples code
 
 obj-$(CONFIG_SAMPLES)	+= kobject/ kprobes/ tracepoints/ trace_events/ \
-			   hw_breakpoint/
+			   hw_breakpoint/ uprobes/
diff --git a/samples/uprobes/Makefile b/samples/uprobes/Makefile
new file mode 100644
index 0000000..f535f6f
--- /dev/null
+++ b/samples/uprobes/Makefile
@@ -0,0 +1,17 @@
+# builds the uprobes example kernel modules;
+# then to use one (as root):
+# insmod <module_name.ko> vaddr=<vaddr> pid=<pid>
+#
+#
+# example: -
+# vaddr=0x$(objdump -T /bin/bash |awk '/echo_builtin/ print $1}')
+# (sleep 10; echo 1; echo 2; echo 3; echo 4) &
+# insmod uprobe_example.ko vaddr=$vaddr pid=$!
+# sleep 10
+# rmmod uprobe_example
+# dmesg | tail -n 3
+#	Registering uprobe on pid 3920, vaddr 0x45aa30
+#	Unregistering uprobe on pid 3920, vaddr 0x45aa30
+#	Probepoint was hit 4 times
+
+obj-$(CONFIG_SAMPLE_UPROBES) += uprobe_example.o
diff --git a/samples/uprobes/uprobe_example.c b/samples/uprobes/uprobe_example.c
new file mode 100644
index 0000000..f625bae
--- /dev/null
+++ b/samples/uprobes/uprobe_example.c
@@ -0,0 +1,83 @@
+/*
+ * Uprobes Example
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
+ * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
+ *
+ * Copyright (C) IBM Corporation, 2008-2010
+ * Authors:
+ *	Srikar Dronamraju
+ *	Jim Keniston
+ */
+
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include <linux/init.h>
+#include <linux/uprobes.h>
+
+/*
+ * Usage: insmod uprobe_example.ko pid=<pid> vaddr=<address> [verbose=0]
+ * where <pid> identifies the probed process and <address> is the virtual
+ * address of the probed instruction.
+ */
+
+static int pid;
+module_param(pid, int, 0);
+MODULE_PARM_DESC(pid, "pid");
+
+static int verbose;
+module_param(verbose, int, 0);
+MODULE_PARM_DESC(verbose, "verbose");
+
+static long vaddr;
+module_param(vaddr, long, 0);
+MODULE_PARM_DESC(vaddr, "vaddr");
+
+static int nhits;
+static struct uprobe usp;
+
+static void uprobe_handler(struct uprobe *u, struct pt_regs *regs)
+{
+	nhits++;
+	if (verbose)
+		printk(KERN_INFO "Hit #%d on probepoint at %#lx\n",
+			nhits, u->vaddr);
+}
+
+int __init init_module(void)
+{
+	int ret;
+	usp.pid = pid;
+	usp.vaddr = vaddr;
+	usp.handler = uprobe_handler;
+	printk(KERN_INFO "Registering uprobe on pid %d, vaddr %#lx\n",
+		usp.pid, usp.vaddr);
+	ret = register_uprobe(&usp);
+	if (ret != 0) {
+		printk(KERN_ERR "register_uprobe() failed, returned %d\n", ret);
+		printk(KERN_ERR "Usage: insmod uprobe_example.ko pid=<pid> "
+						"vaddr=<address>\n");
+		return ret;
+	}
+	return 0;
+}
+
+void __exit cleanup_module(void)
+{
+	printk(KERN_INFO "Unregistering uprobe on pid %d, vaddr %#lx\n",
+		usp.pid, usp.vaddr);
+	printk(KERN_INFO "Probepoint was hit %d times\n", nhits);
+	unregister_uprobe(&usp);
+}
+MODULE_LICENSE("GPL");
