Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753794Ab2KEQKR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 11:10:17 -0500
Received: from thoth.sbs.de ([192.35.17.2]:23914 "EHLO thoth.sbs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752998Ab2KEQJ1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 11:09:27 -0500
From: Jan Kiszka <jan.kiszka@siemens.com>
To: linux-kernel@vger.kernel.org
Cc: Jason Wessel <jason.wessel@windriver.com>,
        kgdb-bugreport@lists.sourceforge.net, Andi Kleen <andi@firstfloor.org>
Subject: [PATCH 02/13] scripts/gdb: Add container_of helper and convenience function
Date: Mon,  5 Nov 2012 17:08:55 +0100
Message-Id: <00ecc4dccf572094587e9c3bef1f523d141dd0da.1352131730.git.jan.kiszka@siemens.com>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <cover.1352131729.git.jan.kiszka@siemens.com>
References: <cover.1352131729.git.jan.kiszka@siemens.com>
In-Reply-To: <cover.1352131729.git.jan.kiszka@siemens.com>
References: <cover.1352131729.git.jan.kiszka@siemens.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Provide an internal helper with container_of semantics. As type lookups
are very slow in gdb-python and we need a type "long" for this, cache
the reference to this type object. Then export the helper also as a
convenience function form use at the gdb command line.

Signed-off-by: Jan Kiszka <jan.kiszka@siemens.com>
---
 scripts/gdb/utils.py       |   55 ++++++++++++++++++++++++++++++++++++++++++++
 scripts/gdb/vmlinux-gdb.py |    2 +
 2 files changed, 57 insertions(+), 0 deletions(-)
 create mode 100644 scripts/gdb/utils.py

diff --git a/scripts/gdb/utils.py b/scripts/gdb/utils.py
new file mode 100644
index 0000000..74682c3
--- /dev/null
+++ b/scripts/gdb/utils.py
@@ -0,0 +1,55 @@
+#
+# gdb helper commands and functions for Linux kernel debugging
+#
+#  common utilities
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
+long_type = None
+
+def get_type(type_name):
+	t = gdb.lookup_type(type_name)
+	if t == None:
+		raise gdb.GdbError("cannot resolve type '%s'" % type_name)
+	return t
+
+def get_long_type():
+	global long_type
+	if long_type == None:
+		long_type = get_type("long")
+	return long_type
+
+
+def offset_of(typeobj, field):
+	element = gdb.Value(0).cast(typeobj)
+	return int(str(element[field].address).split()[0], 16)
+
+def container_of(ptr, typeobj, member):
+	return (ptr.cast(get_long_type()) -
+		offset_of(typeobj, member)).cast(typeobj)
+
+
+class ContainerOf(gdb.Function):
+	__doc__ = "Return pointer to containing data structure.\n" \
+		  "\n" \
+		  "$container_of(PTR, \"TYPE\", \"ELEMENT\"): Given PTR, return a pointer to the\n" \
+		  "data structure of the type TYPE in which PTR is the address of ELEMENT.\n" \
+		  "Note that TYPE and ELEMENT have to be quoted as strings."
+
+	def __init__(self):
+		super(ContainerOf, self).__init__("container_of")
+
+	def invoke(self, ptr, typename, elementname):
+		return container_of(ptr,
+				    gdb.lookup_type(typename.string()).pointer(),
+				    elementname.string())
+
+ContainerOf()
diff --git a/scripts/gdb/vmlinux-gdb.py b/scripts/gdb/vmlinux-gdb.py
index 00df617..62c30b8 100644
--- a/scripts/gdb/vmlinux-gdb.py
+++ b/scripts/gdb/vmlinux-gdb.py
@@ -18,3 +18,5 @@ sys.path = [ os.path.dirname(__file__) + "/scripts/gdb" ] + sys.path
 if not gdb.VERSION >= "7.1":
 	print "NOTE: gdb 7.1 or later required for Linux helper scripts " \
 	      "to work."
+else:
+	import utils
-- 
1.7.3.4

