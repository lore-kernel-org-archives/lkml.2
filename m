Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752093Ab1LGGdd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Dec 2011 01:33:33 -0500
Received: from faui40.informatik.uni-erlangen.de ([131.188.34.40]:59257 "EHLO
	faui40.informatik.uni-erlangen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751395Ab1LGGdb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Dec 2011 01:33:31 -0500
X-Greylist: delayed 471 seconds by postgrey-1.27 at vger.kernel.org; Wed, 07 Dec 2011 01:33:31 EST
Date: Wed, 7 Dec 2011 07:25:37 +0100
From: Christian Dietrich <christian.dietrich@informatik.uni-erlangen.de>
To: Michal Marek <mmarek@suse.cz>, linux-kbuild@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: vamos-dev@i4.informatik.uni-erlangen.de
Subject: [PATCH] kbuild: add Makefile snippet to list compiled files
Message-ID: <20111207062524.GA6570@faui49.informatik.uni-erlangen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To list the compilation units compiled by the current configuration the
scripts/Makefile.list can be executed. It supports:

- printing of all compilation units
- all directories considered for compilation units
- test if a given file is compiled by the configuration
- use a different auto.conf

Signed-off-by: Christian Dietrich <christian.dietrich@informatik.uni-erlangen.de>
---
 Hi,

 the following patch is a result of our research work at VAMOS[1],
 where we try to examine the perconditions under which a file is
 compiled into the linux kernel.

 While working on this, we needed a way to get all compilation units,
 which are compiled with the current configuration. And since this
 might be useful for others, I think it would be great to have this
 possibility in the mainline kernel.

 chris

 [1] http://vamos.informatik.uni-erlangen.de

 scripts/Makefile.list           |   48 ++++++++++++++++++++++
 scripts/Makefile.list_recursion |   83 +++++++++++++++++++++++++++++++++++++++
 2 files changed, 131 insertions(+), 0 deletions(-)
 create mode 100644 scripts/Makefile.list
 create mode 100644 scripts/Makefile.list_recursion

diff --git a/scripts/Makefile.list b/scripts/Makefile.list
new file mode 100644
index 0000000..725500b
--- /dev/null
+++ b/scripts/Makefile.list
@@ -0,0 +1,48 @@
+# -*- mode: makefile -*-#
+#===============================================
+# Listing files compiled by current configuration
+#
+# For retrieving a list of files compiled into the kernel with the current
+# configuration use (in a kernel source tree)
+# - make -f scripts/Makefile.list
+#   options:
+#     print_files - print all compiles files (default: "y")
+#     print_dirs  - print all directories considered for compilation (default: "")
+#
+# If you want to check if a file is compiled by the current configuration
+# - make -f scripts/Makefile.list compiled=kernel/sched.c
+#
+# You can also override, which auto.conf should be loaded, when the source
+# tree is traversed
+# - make -f scripts/Makefile.list auto_conf=another/path/to/auto.conf
+
+list:
+
+# We include the main Makefile to get a list of all considered
+# directories.
+include $(if $(KBUILD_SRC),$(srctree)/)Makefile
+
+list-dirs      := $(addprefix _list_, . $(vmlinux-alldirs))
+
+# Default value for print_files
+print_files ?= y
+
+PHONY += $(list-dirs) list
+$(list-dirs):
+ifeq ($(compiled),)
+	$(Q)$(MAKE) $(list) \
+		auto_conf=$(auto_conf) \
+		print_dirs=$(print_dirs) \
+		print_files=$(print_files) \
+		obj=$(patsubst _list_%,%,$@)
+else
+	$(Q)$(MAKE) $(list) \
+		auto_conf=$(auto_conf) \
+		compiled=$(patsubst %.c,%.o,$(compiled)) \
+		obj=$(patsubst _list_%,%,$@)
+endif
+
+list: $(list-dirs)
+
+list := -f $(if $(KBUILD_SRC),$(srctree)/)scripts/Makefile.list_recursion
+
diff --git a/scripts/Makefile.list_recursion b/scripts/Makefile.list_recursion
new file mode 100644
index 0000000..e448a06
--- /dev/null
+++ b/scripts/Makefile.list_recursion
@@ -0,0 +1,83 @@
+# This is the recursive part of scripts/Makefile.list
+# Have a look there if you are interested in modes of operation
+#==============================================================
+src := $(obj)
+
+PHONY := __list __find
+
+ifeq ($(compiled),)
+__list:
+else
+__find:
+endif
+
+# Read auto.conf if it exists, otherwise ignore
+ifeq ($(auto_conf),)
+-include include/config/auto.conf
+else
+include $(auto_conf)
+endif
+
+# The filename Kbuild has precedence over Makefile
+kbuild-dir := $(if $(filter /%,$(src)),$(src),$(srctree)/$(src))
+include $(if $(wildcard $(kbuild-dir)/Kbuild), $(kbuild-dir)/Kbuild, $(kbuild-dir)/Makefile)
+
+# Figure out what we need to build from the various variables
+# ==========================================================================
+
+__subdir-y	:= $(patsubst %/,%,$(filter %/, $(obj-y)))
+subdir-y	+= $(__subdir-y)
+__subdir-m	:= $(patsubst %/,%,$(filter %/, $(obj-m)))
+subdir-m	+= $(__subdir-m)
+__subdir-n	:= $(patsubst %/,%,$(filter %/, $(obj-n)))
+subdir-n	+= $(__subdir-n)
+__subdir-	:= $(patsubst %/,%,$(filter %/, $(obj-)))
+subdir-		+= $(__subdir-)
+
+# Subdirectories we need to descend into
+subdir-ym	:= $(sort $(subdir-y) $(subdir-m))
+subdir-ymn      := $(sort $(subdir-ym) $(subdir-n) $(subdir-))
+
+include scripts/Makefile.lib
+
+__list: $(subdir-ym)
+ifneq ($(print_dirs),)
+	@echo $(obj)/
+endif
+ifneq ($(print_files),)
+ifneq ($(strip $(real-objs-y)),)
+	@for a in $(real-objs-y); do \
+		echo $$a y; \
+	done
+endif
+ifneq ($(strip $(real-objs-m)),)
+	@for a in $(real-objs-m); do \
+		echo $$a m; \
+	done
+endif
+endif
+	@:
+
+__find: $(foreach dir,$(subdir-ym),$(if $(filter $(dir)%,$(compiled)), $(dir)))
+ifneq ($(filter $(compiled),$(real-objs-y)),)
+	@echo $(compiled) y
+endif
+ifneq ($(filter $(compiled),$(real-objs-m)),)
+	@echo $(compiled) m
+endif
+	@:
+
+
+list := -f $(if $(KBUILD_SRC),$(srctree)/)scripts/Makefile.list_recursion
+
+PHONY += $(subdir-ym)
+$(subdir-ym):
+ifeq ($(compiled),)
+	$(Q)$(MAKE) $(list) obj=$(patsubst _list_%,%,$@)
+else
+	$(Q)$(MAKE) $(list) compiled=$(compiled) obj=$(patsubst _list_%,%,$@)
+endif
+
+# Declare the contents of the .PHONY variable as phony.  We keep that
+# information in a variable se we can use it in if_changed and friends.
+.PHONY: $(PHONY)
-- 
1.7.1
