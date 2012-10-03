Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754143Ab2JCLYF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2012 07:24:05 -0400
Received: from mout.web.de ([212.227.15.3]:65436 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753724Ab2JCLWP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2012 07:22:15 -0400
From: Jan Kiszka <jan.kiszka@web.de>
To: linux-kernel@vger.kernel.org
Cc: Jason Wessel <jason.wessel@windriver.com>,
        kgdb-bugreport@lists.sourceforge.net,
        "David S. Miller" <davem@davemloft.net>, sparclinux@vger.kernel.org
Subject: [PATCH 12/13] scripts/gdb: Add internal helper and convenience function for per-cpu lookup
Date: Wed,  3 Oct 2012 13:21:43 +0200
Message-Id: <f728c9c94781719585d7514a5ac748df702b5a50.1349263293.git.jan.kiszka@web.de>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <cover.1349263293.git.jan.kiszka@web.de>
References: <cover.1349263293.git.jan.kiszka@web.de>
In-Reply-To: <cover.1349263293.git.jan.kiszka@web.de>
References: <cover.1349263293.git.jan.kiszka@web.de>
X-Provags-ID: V02:K0:oTby3ISRQLMJriauk01Xu2r4HfDqPIdwyXrxWl7mT2J
 QfLOF8sD2H+h7bLBbnHkGoSCPjYgcoxRLsxVWWjn0LsXhybhgC
 +1Z7fRJdjoMmKTsHA8P8O0cGmlypL8MKaDzhH4JwoFpL09u9rh
 Ve84hxSUDEa0hEOzy9+dZAhTNDmd6uqpel8gT/YpkCFpMfHy+7
 SK/10gDfTeRfJRkE3ncKQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jan Kiszka <jan.kiszka@siemens.com>

This function allows to obtain a per-cpu variable, either of the current
or an explicitly specified CPU.

Note: sparc64 version is untested.

CC: "David S. Miller" <davem@davemloft.net>
CC: sparclinux@vger.kernel.org
Signed-off-by: Jan Kiszka <jan.kiszka@siemens.com>
---
 scripts/gdb/percpu.py      |   61 ++++++++++++++++++++++++++++++++++++++++++++
 scripts/gdb/vmlinux-gdb.py |    1 +
 2 files changed, 62 insertions(+), 0 deletions(-)
 create mode 100644 scripts/gdb/percpu.py

diff --git a/scripts/gdb/percpu.py b/scripts/gdb/percpu.py
new file mode 100644
index 0000000..6e24400
--- /dev/null
+++ b/scripts/gdb/percpu.py
@@ -0,0 +1,61 @@
+#
+# gdb helper commands and functions for Linux kernel debugging
+#
+#  per-cpu tools
+#
+# Copyright (c) 2011, 2012 Siemens AG
+#
+# Authors:
+#  Jan Kiszka <jan.kiszka@siemens.com>
+#
+# This work is licensed under the terms of the GNU GPL version 2.
+#
+
+import gdb
+
+from utils import *
+from task import *
+
+MAX_CPUS = 4096
+
+def get_current_cpu():
+	if get_gdbserver_type() == GDBSERVER_QEMU:
+		return gdb.selected_thread().num - 1
+	elif get_gdbserver_type() == GDBSERVER_KGDB:
+		tid = gdb.selected_thread().ptid[2]
+		if tid > (0x100000000 - MAX_CPUS - 2):
+			return 0x100000000 - tid - 2
+		else:
+			return get_thread_info(get_task_by_pid(tid))['cpu']
+	else:
+		raise gdb.GdbError("Sorry, obtaining the current CPU is "
+				   "not yet supported with this gdb server.")
+
+def per_cpu(var_name, cpu):
+	var = gdb.parse_and_eval("&" + var_name)
+	if cpu == -1:
+		cpu = get_current_cpu()
+	if is_target_arch("sparc:v9"):
+		offset = gdb.parse_and_eval("trap_block[" + str(cpu) +
+					    "].__per_cpu_base")
+	else:
+		offset = gdb.parse_and_eval("__per_cpu_offset[" + str(cpu) +
+					    "]")
+	pointer = var.cast(get_long_type()) + offset
+	return pointer.cast(var.type).dereference()
+
+
+class PerCpu(gdb.Function):
+	__doc__ = "Return per-cpu variable.\n" \
+		  "\n" \
+		  "$lx_per_cpu(\"VAR\"[, CPU]): Return the per-cpu variable called VAR for the\n" \
+		  "given CPU number. If CPU is omitted, the CPU of the current context is used.\n" \
+		  "Note that VAR has to be quoted as string."
+
+	def __init__(self):
+		super(PerCpu, self).__init__("lx_per_cpu")
+
+	def invoke(self, var_name, cpu = -1):
+		return per_cpu(var_name.string(), cpu)
+
+PerCpu()
diff --git a/scripts/gdb/vmlinux-gdb.py b/scripts/gdb/vmlinux-gdb.py
index deaf652..1d952b5 100644
--- a/scripts/gdb/vmlinux-gdb.py
+++ b/scripts/gdb/vmlinux-gdb.py
@@ -23,3 +23,4 @@ else:
 	import symbols
 	import dmesg
 	import task
+	import percpu
-- 
1.7.3.4

