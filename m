Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753509Ab2KEQJl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 11:09:41 -0500
Received: from goliath.siemens.de ([192.35.17.28]:19200 "EHLO
	goliath.siemens.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753014Ab2KEQJ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 11:09:28 -0500
From: Jan Kiszka <jan.kiszka@siemens.com>
To: linux-kernel@vger.kernel.org
Cc: Jason Wessel <jason.wessel@windriver.com>,
        kgdb-bugreport@lists.sourceforge.net, Andi Kleen <andi@firstfloor.org>
Subject: [PATCH 03/13] scripts/gdb: Add lx-symbols command
Date: Mon,  5 Nov 2012 17:08:56 +0100
Message-Id: <7460a48e8c633aa7a86cf7901e780dd825a65f31.1352131730.git.jan.kiszka@siemens.com>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <cover.1352131729.git.jan.kiszka@siemens.com>
References: <cover.1352131729.git.jan.kiszka@siemens.com>
In-Reply-To: <cover.1352131729.git.jan.kiszka@siemens.com>
References: <cover.1352131729.git.jan.kiszka@siemens.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is probably the most useful helper when debugging kernel modules:
lx-symbols will first reload vmlinux. Then it searches recursively for
*.ko files in the specified paths and the current directory. Finally it
walks the kernel's module list, issuing the necessary add-symbol-file
command for each loaded module so that gdb know which module symbol
correspond to which address.

In addition, the command installs a silent breakpoint in the
sys_init_module function at the point where the module was loaded but
not yet initialized. The breakpoint handler will try to load symbols
from the module files found during lx-symbols execution. This way,
breakpoints can be set to module initialization functions, and there is
usually no need to explicitly call lx-symbols after (re-)loading a
module.

Signed-off-by: Jan Kiszka <jan.kiszka@siemens.com>
---
 scripts/gdb/symbols.py     |  133 ++++++++++++++++++++++++++++++++++++++++++++
 scripts/gdb/vmlinux-gdb.py |    1 +
 2 files changed, 134 insertions(+), 0 deletions(-)
 create mode 100644 scripts/gdb/symbols.py

diff --git a/scripts/gdb/symbols.py b/scripts/gdb/symbols.py
new file mode 100644
index 0000000..ddba327
--- /dev/null
+++ b/scripts/gdb/symbols.py
@@ -0,0 +1,133 @@
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
+	module_files = []
+	breakpoint = None
+
+	class _LoadModuleBreakpoint(gdb.Breakpoint):
+		def __init__(self, spec, gdb_command):
+			super(LinuxSymbols._LoadModuleBreakpoint,
+			      self).__init__(spec, internal = True)
+			self.silent = True
+			self.gdb_command = gdb_command
+
+		def stop(self):
+			module = gdb.parse_and_eval("mod")
+			self.gdb_command._load_module_symbols(module)
+			return False
+
+	def __init__(self):
+		super(LinuxSymbols, self).__init__("lx-symbols",
+						   gdb.COMMAND_FILES,
+						   gdb.COMPLETE_FILENAME)
+
+	def _load_module_symbols(self, module):
+		module_name = module['name'].string()
+		module_addr = str(module['module_core'])
+		module_pattern = ".*/" + \
+			string.replace(module_name, "_", r"[_\-]") + r"\.ko$"
+		module_path = ""
+		for name in self.module_files:
+			if re.match(module_pattern, name):
+				module_path = name
+				break
+
+		if module_path:
+			print "loading @" + module_addr + ": " + module_path
+			if gdb.VERSION >= "7.2":
+				gdb.execute("add-symbol-file " + \
+					    module_path + " " + module_addr,
+					    to_string = True)
+			else:
+				gdb.execute("add-symbol-file " + \
+					    module_path + " " + module_addr)
+		else:
+			print "no module object found for '" + \
+			      module_name + "'"
+
+	def _find_breakpoint_location(self):
+		breakpoint_match = \
+			"^[0-9]*[\t]*blocking_notifier_call_chain\(" \
+			"&module_notify_list,$"
+
+		src = gdb.execute("list sys_init_module", to_string = True)
+		done = False
+		lineno = None
+		while not done:
+			src = gdb.execute("list", to_string = True)
+			for line in src.splitlines():
+				if re.match(breakpoint_match, line):
+					done = True
+					lineno = line.split()[0]
+					break
+				elif re.match("^[0-9]*\t}$", line):
+					done = True
+					break
+		return lineno
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
+		self.module_files = []
+		paths = arg.split()
+		paths.append(os.getcwd())
+		for path in paths:
+			print "scanning for modules in " + path
+			for root, dirs, files in os.walk(path):
+				for name in files:
+					if re.match(r".*\.ko$", name):
+						self.module_files.append(
+							root + "/" + name)
+
+		module_type = gdb.lookup_type("struct module").pointer()
+
+		while entry != modules.address:
+			module = container_of(entry, module_type, "list")
+			self._load_module_symbols(module)
+			entry = entry['next']
+
+		if gdb.VERSION < "7.2":
+			print "Note: symbol update on module loading not " \
+			      "supported with this gdb version"
+		elif self.breakpoint == None:
+			lineno = self._find_breakpoint_location()
+			if lineno != None:
+				self.breakpoint = self._LoadModuleBreakpoint(
+					lineno, self)
+			else:
+				print "unable to detect breakpoint location " \
+				      "of load module completion"
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

