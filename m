Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754301Ab2JCLYr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2012 07:24:47 -0400
Received: from mout.web.de ([212.227.17.11]:49344 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753042Ab2JCLWA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2012 07:22:00 -0400
From: Jan Kiszka <jan.kiszka@web.de>
To: linux-kernel@vger.kernel.org
Cc: Jason Wessel <jason.wessel@windriver.com>,
        kgdb-bugreport@lists.sourceforge.net
Subject: [PATCH 03/13] scripts/gdb: Add lx-symbols command
Date: Wed,  3 Oct 2012 13:21:34 +0200
Message-Id: <4a908732afc40165be20f6f2b7eeff92c0f6883f.1349263293.git.jan.kiszka@web.de>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <cover.1349263293.git.jan.kiszka@web.de>
References: <cover.1349263293.git.jan.kiszka@web.de>
In-Reply-To: <cover.1349263293.git.jan.kiszka@web.de>
References: <cover.1349263293.git.jan.kiszka@web.de>
X-Provags-ID: V02:K0:0ZUarzZlUS38NQSamCD4DXlJ64MTGwn6s/R/U/QQqV2
 ju1CZdO6z2fWyQ9UUBhuSn7RiNa/9Mr/CYCOR+rh3ZgKtGuKxY
 k2krFyN7UzO64k31dPvGzPYfdVZq1iU1PUuCUcgh85vOGZQbqt
 ITildRGr9PUbKTppU7Ua87klnZ6JZsJaW+ELiu5As9oDcgKc4o
 E4njM2AnsxUajUZikBloA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jan Kiszka <jan.kiszka@siemens.com>

This is probably the most useful helper when debugging kernel modules:
lx-symbols will first reload vmlinux. Then it searches recursively for
*.ko files in the specified paths and the current directory. Finally it
walks the kernel's module list, issuing the necessary add-symbol-file
command for each loaded module so that gdb know which module symbol
correspond to which address.

Signed-off-by: Jan Kiszka <jan.kiszka@siemens.com>
---
 scripts/gdb/symbols.py     |   88 ++++++++++++++++++++++++++++++++++++++++++++
 scripts/gdb/vmlinux-gdb.py |    1 +
 2 files changed, 89 insertions(+), 0 deletions(-)
 create mode 100644 scripts/gdb/symbols.py

diff --git a/scripts/gdb/symbols.py b/scripts/gdb/symbols.py
new file mode 100644
index 0000000..dd13b0d
--- /dev/null
+++ b/scripts/gdb/symbols.py
@@ -0,0 +1,88 @@
+#
+# gdb helper commands and functions for Linux kernel debugging
+#
+#  load kernel and module symbols
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
+import os
+import re
+import string
+
+from utils import *
+
+class LinuxSymbols(gdb.Command):
+	__doc__ = "(Re-)load symbols of Linux kernel and currently loaded modules.\n" \
+		  "\n" \
+		  "The kernel (vmlinux) is taken from the current working directly. Modules (.ko)\n" \
+		  "are scanned recursively, starting in the same directory. Optionally, the module\n" \
+		  "search path can be extended by a space separated list of paths passed to the\n" \
+		  "lx-symbols command."
+
+	def __init__(self):
+		super(LinuxSymbols, self).__init__("lx-symbols",
+						   gdb.COMMAND_FILES,
+						   gdb.COMPLETE_FILENAME)
+
+	def invoke(self, arg, from_tty):
+		print "loading vmlinux"
+		gdb.execute("symbol-file vmlinux")
+
+		modules = gdb.parse_and_eval("modules")
+		entry = modules['next']
+		if entry == modules.address:
+			print "no modules found"
+			return
+
+		module_files = []
+		paths = arg.split()
+		paths.append(os.getcwd())
+		for path in paths:
+			print "scanning for modules in " + path
+			for root, dirs, files in os.walk(path):
+				for name in files:
+					if re.match(r".*\.ko$", name):
+						module_files.append(root + \
+								    "/" + name)
+
+		module_type = gdb.lookup_type("struct module").pointer()
+
+		while entry != modules.address:
+			module = container_of(entry, module_type, "list")
+			module_name = module['name'].string()
+			module_addr = str(module['module_core'])
+			module_pattern = ".*/" + \
+				string.replace(module_name, "_", r"[_\-]") + \
+				r"\.ko$"
+			module_path = ""
+			for name in module_files:
+				if re.match(module_pattern, name):
+					module_path = name
+					break
+
+			if module_path:
+				print "loading @" + module_addr + ": " + \
+				      module_path
+				if gdb.VERSION >= "7.2":
+					gdb.execute("add-symbol-file " + \
+						    module_path + " " + \
+						    module_addr,
+						    to_string = True)
+				else:
+					gdb.execute("add-symbol-file " + \
+						    module_path + " " + \
+						    module_addr)
+			else:
+				print "no module object found for '" + \
+				      module_name + "'"
+
+			entry = entry['next']
+
+LinuxSymbols()
diff --git a/scripts/gdb/vmlinux-gdb.py b/scripts/gdb/vmlinux-gdb.py
index 62c30b8..fa1d5e1 100644
--- a/scripts/gdb/vmlinux-gdb.py
+++ b/scripts/gdb/vmlinux-gdb.py
@@ -20,3 +20,4 @@ if not gdb.VERSION >= "7.1":
 	      "to work."
 else:
 	import utils
+	import symbols
-- 
1.7.3.4

