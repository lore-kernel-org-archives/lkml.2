Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933568Ab2K0KMr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2012 05:12:47 -0500
Received: from david.siemens.de ([192.35.17.14]:31603 "EHLO david.siemens.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933401Ab2K0KMm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2012 05:12:42 -0500
From: Jan Kiszka <jan.kiszka@siemens.com>
To: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Cc: Jason Wessel <jason.wessel@windriver.com>,
        kgdb-bugreport@lists.sourceforge.net, Andi Kleen <andi@firstfloor.org>,
        Tom Tromey <tromey@redhat.com>, Michal Marek <mmarek@suse.cz>,
        linux-kbuild@vger.kernel.org
Subject: [PATCH v3 01/13] scripts/gdb: Add infrastructure
Date: Tue, 27 Nov 2012 11:11:32 +0100
Message-Id: <0bd1dbf8903835378b68dbd58a4e430e581a0b96.1354011091.git.jan.kiszka@siemens.com>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <cover.1354011091.git.jan.kiszka@siemens.com>
References: <cover.1354011091.git.jan.kiszka@siemens.com>
In-Reply-To: <cover.1354011091.git.jan.kiszka@siemens.com>
References: <cover.1354011091.git.jan.kiszka@siemens.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This provides the basic infrastructure to load kernel-specific python
helper scripts when debugging the kernel in gdb.

The loading mechanism is based on gdb loading for <objfile>-gdb.py when
opening <objfile>. Therefore, this places a corresponding link to the
main helper script into the output directory that contains vmlinux.

The main scripts will pull in submodules containing Linux specific gdb
commands and functions. To avoid polluting the source directory with
compiled python modules, we link to them from the object directory.

Due to gdb.parse_and_eval, we depend on gdb >= 7.1. We need to
pre-process the version string returned by gdb as some distros tend to
prefix it with their name.

This feature depends on CONFIG_DEBUG_INFO.

CC: Michal Marek <mmarek@suse.cz>
CC: linux-kbuild@vger.kernel.org
Signed-off-by: Jan Kiszka <jan.kiszka@siemens.com>
---
 Makefile                   |    5 ++++-
 scripts/Makefile           |    3 ++-
 scripts/gdb/Makefile       |    9 +++++++++
 scripts/gdb/utils.py       |   17 +++++++++++++++++
 scripts/gdb/vmlinux-gdb.py |   22 ++++++++++++++++++++++
 5 files changed, 54 insertions(+), 2 deletions(-)
 create mode 100644 scripts/gdb/Makefile
 create mode 100644 scripts/gdb/utils.py
 create mode 100644 scripts/gdb/vmlinux-gdb.py

diff --git a/Makefile b/Makefile
index 3d2fc46..c36bd78 100644
--- a/Makefile
+++ b/Makefile
@@ -774,6 +774,9 @@ endif
 ifdef CONFIG_BUILD_DOCSRC
 	$(Q)$(MAKE) $(build)=Documentation
 endif
+ifdef CONFIG_DEBUG_INFO
+	$(Q)ln -fsn $(srctree)/scripts/gdb/vmlinux-gdb.py
+endif
 	+$(call if_changed,link-vmlinux)
 
 # The actual objects are generated when descending, 
@@ -1013,7 +1016,7 @@ MRPROPER_FILES += .config .config.old .version .old_version $(version_h) \
 		  Module.symvers tags TAGS cscope* GPATH GTAGS GRTAGS GSYMS \
 		  signing_key.priv signing_key.x509 x509.genkey		\
 		  extra_certificates signing_key.x509.keyid		\
-		  signing_key.x509.signer
+		  signing_key.x509.signer vmlinux-gdb.py
 
 # clean - Delete most, but leave enough to build external modules
 #
diff --git a/scripts/Makefile b/scripts/Makefile
index 01e7adb..3204b91 100644
--- a/scripts/Makefile
+++ b/scripts/Makefile
@@ -37,6 +37,7 @@ subdir-$(CONFIG_MODVERSIONS) += genksyms
 subdir-y                     += mod
 subdir-$(CONFIG_SECURITY_SELINUX) += selinux
 subdir-$(CONFIG_DTC)         += dtc
+subdir-$(CONFIG_DEBUG_INFO)  += gdb
 
 # Let clean descend into subdirs
-subdir-	+= basic kconfig package selinux
+subdir-	+= basic kconfig package selinux gdb
diff --git a/scripts/gdb/Makefile b/scripts/gdb/Makefile
new file mode 100644
index 0000000..34ccd06
--- /dev/null
+++ b/scripts/gdb/Makefile
@@ -0,0 +1,9 @@
+always := gdb-scripts
+
+$(obj)/gdb-scripts:
+ifneq ($(KBUILD_SRC),)
+	$(Q)ln -fsn $(srctree)/$(obj)/*.py $(objtree)/$(obj)
+endif
+	@:
+
+clean-files := *.pyc $(if $(KBUILD_SRC),*.py)
diff --git a/scripts/gdb/utils.py b/scripts/gdb/utils.py
new file mode 100644
index 0000000..14e72ec
--- /dev/null
+++ b/scripts/gdb/utils.py
@@ -0,0 +1,17 @@
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
+import re
+
+gdb_version = re.sub("^[^0-9]*", "", gdb.VERSION)
diff --git a/scripts/gdb/vmlinux-gdb.py b/scripts/gdb/vmlinux-gdb.py
new file mode 100644
index 0000000..ff75a85
--- /dev/null
+++ b/scripts/gdb/vmlinux-gdb.py
@@ -0,0 +1,22 @@
+#
+# gdb helper commands and functions for Linux kernel debugging
+#
+#  loader module
+#
+# Copyright (c) 2012 Siemens AG
+#
+# Authors:
+#  Jan Kiszka <jan.kiszka@siemens.com>
+#
+# This work is licensed under the terms of the GNU GPL version 2.
+#
+
+import os
+
+sys.path = [ os.path.dirname(__file__) + "/scripts/gdb" ] + sys.path
+
+from utils import gdb_version
+
+if gdb_version < "7.1":
+	print "NOTE: gdb 7.1 or later required for Linux helper scripts " \
+	      "to work."
-- 
1.7.3.4

