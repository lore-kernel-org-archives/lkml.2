Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933438Ab2K0KMP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2012 05:12:15 -0500
Received: from goliath.siemens.de ([192.35.17.28]:23771 "EHLO
	goliath.siemens.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933503Ab2K0KMG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2012 05:12:06 -0500
From: Jan Kiszka <jan.kiszka@siemens.com>
To: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Cc: Jason Wessel <jason.wessel@windriver.com>,
        kgdb-bugreport@lists.sourceforge.net, Andi Kleen <andi@firstfloor.org>,
        Tom Tromey <tromey@redhat.com>
Subject: [PATCH v3 02/13] scripts/gdb: Add container_of helper and convenience function
Date: Tue, 27 Nov 2012 11:11:33 +0100
Message-Id: <6f3dc2946a817ab7e39eb1fdcf9d15a8af2817b6.1354011091.git.jan.kiszka@siemens.com>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <cover.1354011091.git.jan.kiszka@siemens.com>
References: <cover.1354011091.git.jan.kiszka@siemens.com>
In-Reply-To: <cover.1354011091.git.jan.kiszka@siemens.com>
References: <cover.1354011091.git.jan.kiszka@siemens.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Provide an internal helper with container_of semantics. As type lookups
are very slow in gdb-python and we need a type "long" for this, cache
the reference to this type object. Then export the helper also as a
convenience function form use at the gdb command line.

Signed-off-by: Jan Kiszka <jan.kiszka@siemens.com>
---
 scripts/gdb/utils.py       |   41 +++++++++++++++++++++++++++++++++++++++++
 scripts/gdb/vmlinux-gdb.py |    2 ++
 2 files changed, 43 insertions(+), 0 deletions(-)

diff --git a/scripts/gdb/utils.py b/scripts/gdb/utils.py
index 14e72ec..f97ef79 100644
--- a/scripts/gdb/utils.py
+++ b/scripts/gdb/utils.py
@@ -15,3 +15,44 @@ import gdb
 import re
 
 gdb_version = re.sub("^[^0-9]*", "", gdb.VERSION)
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
index ff75a85..42774d3 100644
--- a/scripts/gdb/vmlinux-gdb.py
+++ b/scripts/gdb/vmlinux-gdb.py
@@ -20,3 +20,5 @@ from utils import gdb_version
 if gdb_version < "7.1":
 	print "NOTE: gdb 7.1 or later required for Linux helper scripts " \
 	      "to work."
+else:
+	import utils
-- 
1.7.3.4

