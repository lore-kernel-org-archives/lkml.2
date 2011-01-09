Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752551Ab1AIT3L (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Jan 2011 14:29:11 -0500
Received: from pfepa.post.tele.dk ([195.41.46.235]:47246 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751288Ab1AIT3J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Jan 2011 14:29:09 -0500
Date: Sun, 9 Jan 2011 20:29:07 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: lkml <linux-kernel@vger.kernel.org>,
        linux-kbuild <linux-kbuild@vger.kernel.org>,
        linux arch <linux-arch@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>,
        Guan Xuetao <guanxuetao@mprc.pku.edu.cn>,
        Michal Marek <mmarek@suse.cz>
Subject: [PATCH 1/2] kbuild: asm-generic support
Message-ID: <20110109192907.GA12403@merkur.ravnborg.org>
References: <20110108130302.GA21698@merkur.ravnborg.org> <20110109192707.GA12387@merkur.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110109192707.GA12387@merkur.ravnborg.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 1c33973f2e4a099eadfb1a37cd3a28a3c8d3202f Mon Sep 17 00:00:00 2001
From: Sam Ravnborg <sam@ravnborg.org>
Date: Sun, 9 Jan 2011 19:45:40 +0100
Subject: [PATCH 1/2] kbuild: asm-generic support

There is an increasing amount of header files
shared between individual architectures in asm-generic.
To avoid a lot of dummy wrapper files that just
include the corresponding file in asm-generic provide
some basic support in kbuild for this.

With the following patch an architecture can maintain
a list of files in the file arch/$(ARCH)/include/asm/Kbuild

To use a generic file just add:

        generic-y += <name-of-header-file.h>

For each file listed kbuild will generate the necessary
wrapper in arch/$(ARCH)/include/generated/asm.

When installing userspace headers a wrapper is likewise created.

The original inspiration for this came from the unicore32
patchset - although is used a different method.

The patch includes several improvements from Arnd Bergmann.

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
Cc: Guan Xuetao <guanxuetao@mprc.pku.edu.cn>
Cc: Arnd Bergmann <arnd@arndb.de>
---
 .gitignore                         |    1 +
 Documentation/kbuild/makefiles.txt |   36 ++++++++++++++++++++++++++++++++++++
 Makefile                           |   15 +++++++++++----
 scripts/Makefile.headersinst       |   18 +++++++++++++++---
 scripts/asm-generic.sh             |   33 +++++++++++++++++++++++++++++++++
 5 files changed, 96 insertions(+), 7 deletions(-)
 create mode 100644 scripts/asm-generic.sh

diff --git a/.gitignore b/.gitignore
index 8faa6c0..e3cfd57 100644
--- a/.gitignore
+++ b/.gitignore
@@ -56,6 +56,7 @@ modules.builtin
 include/config
 include/linux/version.h
 include/generated
+arch/*/include/generated
 
 # stgit generated dirs
 patches-*
diff --git a/Documentation/kbuild/makefiles.txt b/Documentation/kbuild/makefiles.txt
index 0ef00bd..bc79a3d 100644
--- a/Documentation/kbuild/makefiles.txt
+++ b/Documentation/kbuild/makefiles.txt
@@ -40,11 +40,13 @@ This document describes the Linux kernel Makefiles.
 	   --- 6.6 Commands useful for building a boot image
 	   --- 6.7 Custom kbuild commands
 	   --- 6.8 Preprocessing linker scripts
+	   --- 6.9 Generic header files
 
 	=== 7 Kbuild syntax for exported headers
 		--- 7.1 header-y
 		--- 7.2 objhdr-y
 		--- 7.3 destination-y
+		--- 7.4 generic-y
 
 	=== 8 Kbuild Variables
 	=== 9 Makefile language
@@ -1194,6 +1196,14 @@ When kbuild executes, the following steps are followed (roughly):
 	The kbuild infrastructure for *lds file are used in several
 	architecture-specific files.
 
+--- 6.9 Generic header files
+
+	The directory include/asm-generic contains the header files
+	that may be shared between individual architectures.
+	The recommended approach how to use a generic header file is
+	to list the file in the Kbuild file.
+	See "7.4 generic-y" for further info on syntax etc.
+
 === 7 Kbuild syntax for exported headers
 
 The kernel include a set of headers that is exported to userspace.
@@ -1250,6 +1260,32 @@ See subsequent chapter for the syntax of the Kbuild file.
 	In the example above all exported headers in the Kbuild file
 	will be located in the directory "include/linux" when exported.
 
+	--- 7.4 generic-y
+
+	If an architecture uses a verbatim copy of a header from
+	include/asm-generic then this is listed in the file
+	arch/$(ARCH)/include/asm/Kbuild like this:
+
+		Example:
+			#arch/x86/include/asm/Kbuild
+			generic-y += termios.h
+			generic-y += rtc.h
+
+	During the prepare phase of the build a wrapper include
+	file is generated in the directory:
+
+		arch/$(ARCH)/include/generated/asm
+
+	When a header is exported where the architecture uses
+	the generic header a similar wrapper is generated as part
+	of the set of exported headers in the directory:
+
+		usr/include/asm
+
+	The generated wrapper will in both cases look like the following:
+
+		Example: termios.h
+			#include <asm-generic/termios.h>
 
 === 8 Kbuild Variables
 
diff --git a/Makefile b/Makefile
index 74b2555..263eb65 100644
--- a/Makefile
+++ b/Makefile
@@ -344,7 +344,8 @@ CFLAGS_GCOV	= -fprofile-arcs -ftest-coverage
 
 # Use LINUXINCLUDE when you must reference the include/ directory.
 # Needed to be compatible with the O= option
-LINUXINCLUDE    := -I$(srctree)/arch/$(hdr-arch)/include -Iinclude \
+LINUXINCLUDE    := -I$(srctree)/arch/$(hdr-arch)/include \
+                   -Iarch/$(hdr-arch)/include/generated -Iinclude \
                    $(if $(KBUILD_SRC), -I$(srctree)/include) \
                    -include include/generated/autoconf.h
 
@@ -411,6 +412,11 @@ ifneq ($(KBUILD_SRC),)
 	    $(srctree) $(objtree) $(VERSION) $(PATCHLEVEL)
 endif
 
+# Support for using generic headers in asm-generic
+PHONY += asm-generic
+asm-generic:
+	$(Q)$(CONFIG_SHELL) $(srctree)/scripts/asm-generic.sh $(SRCARCH)
+
 # To make sure we do not include .config for any of the *config targets
 # catch them early, and hand them over to scripts/kconfig/Makefile
 # It is allowed to specify more targets when calling make, including
@@ -942,7 +948,7 @@ ifneq ($(KBUILD_SRC),)
 endif
 
 # prepare2 creates a makefile if using a separate output directory
-prepare2: prepare3 outputmakefile
+prepare2: prepare3 outputmakefile asm-generic
 
 prepare1: prepare2 include/linux/version.h include/generated/utsrelease.h \
                    include/config/auto.conf
@@ -1016,7 +1022,7 @@ hdr-inst := -rR -f $(srctree)/scripts/Makefile.headersinst obj
 hdr-dst = $(if $(KBUILD_HEADERS), dst=include/asm-$(hdr-arch), dst=include/asm)
 
 PHONY += __headers
-__headers: include/linux/version.h scripts_basic FORCE
+__headers: include/linux/version.h scripts_basic asm-generic FORCE
 	$(Q)$(MAKE) $(build)=scripts scripts/unifdef
 
 PHONY += headers_install_all
@@ -1131,7 +1137,8 @@ CLEAN_FILES +=	vmlinux System.map \
                 .tmp_kallsyms* .tmp_version .tmp_vmlinux* .tmp_System.map
 
 # Directories & files removed with 'make mrproper'
-MRPROPER_DIRS  += include/config usr/include include/generated
+MRPROPER_DIRS  += include/config usr/include include/generated          \
+                  arch/*/include/generated
 MRPROPER_FILES += .config .config.old .version .old_version             \
                   include/linux/version.h                               \
 		  Module.symvers tags TAGS cscope*
diff --git a/scripts/Makefile.headersinst b/scripts/Makefile.headersinst
index f89cb87..7960b19 100644
--- a/scripts/Makefile.headersinst
+++ b/scripts/Makefile.headersinst
@@ -14,6 +14,7 @@ kbuild-file := $(srctree)/$(obj)/Kbuild
 include $(kbuild-file)
 
 _dst := $(if $(destination-y),$(destination-y),$(_dst))
+_src := $(srctree)/$(obj)
 
 include scripts/Kbuild.include
 
@@ -27,10 +28,16 @@ header-y      := $(filter-out %/, $(header-y))
 install-file  := $(install)/.install
 check-file    := $(install)/.check
 
+# generic-y list all files an architecture uses from asm-generic
+# Use this to build a list of headers which require a wrapper
+wrapper-files := $(filter $(header-y), $(generic-y))
+
 # all headers files for this dir
-all-files     := $(header-y) $(objhdr-y)
-input-files   := $(addprefix $(srctree)/$(obj)/,$(header-y)) \
+header-y      := $(filter-out $(generic-y), $(header-y))
+all-files     := $(header-y) $(objhdr-y) $(wrapper-files)
+input-files   := $(addprefix $(_src)/,$(header-y)) \
                  $(addprefix $(objtree)/$(obj)/,$(objhdr-y))
+
 output-files  := $(addprefix $(install)/, $(all-files))
 
 # Work out what needs to be removed
@@ -47,8 +54,12 @@ quiet_cmd_install = INSTALL $(printdir) ($(words $(all-files))\
       cmd_install = \
         $(PERL) $< $(srctree)/$(obj) $(install) $(SRCARCH) $(header-y); \
         $(PERL) $< $(objtree)/$(obj) $(install) $(SRCARCH) $(objhdr-y); \
+        for F in $(wrapper-files); do                                   \
+                echo "\#include <asm-generic/$$F>" > $(install)/$$F;    \
+        done;                                                           \
         touch $@
 
+
 quiet_cmd_remove = REMOVE  $(unwanted)
       cmd_remove = rm -f $(unwanted-file)
 
@@ -69,7 +80,8 @@ __headersinst: $(subdirs) $(install-file)
 	@:
 
 targets += $(install-file)
-$(install-file): scripts/headers_install.pl $(input-files) FORCE
+$(install-file): scripts/headers_install.pl \
+                 $(input-files) FORCE
 	$(if $(unwanted),$(call cmd,remove),)
 	$(if $(wildcard $(dir $@)),,$(shell mkdir -p $(dir $@)))
 	$(call if_changed,install)
diff --git a/scripts/asm-generic.sh b/scripts/asm-generic.sh
new file mode 100644
index 0000000..d28127f
--- /dev/null
+++ b/scripts/asm-generic.sh
@@ -0,0 +1,33 @@
+#!/bin/sh
+#
+# include/asm-generic contains a lot of files that are used
+# verbatim by several architectures.
+#
+# This scripts read the file arch/$(ARCH)/include/asm/Kbuild
+# and for each file listed in this file with generic-y create
+# a small wrapper file in arch/$(ARCH)/include/generated/
+
+# read list of header files form Kbuild
+# The file has make syntax which looks like this:
+#
+# generic-y += <filename>
+
+srcdir=${srctree}/arch/$1/include/asm
+gendir=arch/$1/include/generated/asm
+
+# Read the list of files (note that the list uses make syntax)
+files=$( cat ${srcdir}/Kbuild | \
+          grep -v ^# | grep generic-y | cut -d '=' -f 2)
+
+mkdir -p ${gendir}
+
+# create include files for each file used form asm-generic
+for F in ${files}; do
+	if [ -f ${srcdir}/$F ]; then
+		echo "ERROR: ${srcdir}/$F exists"
+		echo "$F is also listed as generic-y in ${srcdir}/Kbuild"
+		echo "Did you forget to remove the file?"
+		exit 1
+	fi
+	echo "#include <asm-generic/$F>" > ${gendir}/$F
+done
-- 
1.6.0.6

