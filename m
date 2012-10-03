Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753018Ab2JCLV6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2012 07:21:58 -0400
Received: from mout.web.de ([212.227.15.3]:57709 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751735Ab2JCLV5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2012 07:21:57 -0400
From: Jan Kiszka <jan.kiszka@web.de>
To: linux-kernel@vger.kernel.org
Cc: Jason Wessel <jason.wessel@windriver.com>,
        kgdb-bugreport@lists.sourceforge.net
Subject: [PATCH 02/13] scripts/gdb: Add container_of helper and convenience function
Date: Wed,  3 Oct 2012 13:21:33 +0200
Message-Id: <8a52d25593769303ffce78c3c252a733ff44ce3a.1349263293.git.jan.kiszka@web.de>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <cover.1349263293.git.jan.kiszka@web.de>
References: <cover.1349263293.git.jan.kiszka@web.de>
In-Reply-To: <cover.1349263293.git.jan.kiszka@web.de>
References: <cover.1349263293.git.jan.kiszka@web.de>
X-Provags-ID: V02:K0:/I3caDTFhG7QoZKuCsTDNP9TA42POQelzX92Qt10rC7
 hJFCxOEAfaYbJK/8iawtUI6+Y0mDAsf/OZ3Ud+RygfOC0po6bs
 rbCep1uqJYLx35Nn3gqmc133Wqt9Q2cQuNlKXrdOAxMuz0mVox
 RduFoALmislPXgD9rRymzvQ/gwIbyhTkn7je0CXXsXRdvn9jP/
 g6O5OR/xqdaWr9jSWWBxg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jan Kiszka <jan.kiszka@siemens.com>

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
index 0000000..f770c5c
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
+	return int(str(element[field].address), 16)
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

