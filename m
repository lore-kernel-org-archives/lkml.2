Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933573Ab2K0KMR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2012 05:12:17 -0500
Received: from thoth.sbs.de ([192.35.17.2]:17507 "EHLO thoth.sbs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933499Ab2K0KMG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2012 05:12:06 -0500
From: Jan Kiszka <jan.kiszka@siemens.com>
To: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Cc: Jason Wessel <jason.wessel@windriver.com>,
        kgdb-bugreport@lists.sourceforge.net, Andi Kleen <andi@firstfloor.org>,
        Tom Tromey <tromey@redhat.com>,
        "David S. Miller" <davem@davemloft.net>, sparclinux@vger.kernel.org
Subject: [PATCH v3 12/13] scripts/gdb: Add internal helper and convenience function for per-cpu lookup
Date: Tue, 27 Nov 2012 11:11:43 +0100
Message-Id: <00ab9e8af1c5131ad20462253766b14d2eb2144a.1354011091.git.jan.kiszka@siemens.com>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <cover.1354011091.git.jan.kiszka@siemens.com>
References: <cover.1354011091.git.jan.kiszka@siemens.com>
In-Reply-To: <cover.1354011091.git.jan.kiszka@siemens.com>
References: <cover.1354011091.git.jan.kiszka@siemens.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
index 1a9b293..0243304 100644
--- a/scripts/gdb/vmlinux-gdb.py
+++ b/scripts/gdb/vmlinux-gdb.py
@@ -25,3 +25,4 @@ else:
 	import symbols
 	import dmesg
 	import task
+	import percpu
-- 
1.7.3.4

