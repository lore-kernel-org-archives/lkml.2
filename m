Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751431Ab1AIIb2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Jan 2011 03:31:28 -0500
Received: from pfepb.post.tele.dk ([195.41.46.236]:34955 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750998Ab1AIIb1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Jan 2011 03:31:27 -0500
Date: Sun, 9 Jan 2011 09:31:25 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: lkml <linux-kernel@vger.kernel.org>,
        linux-kbuild <linux-kbuild@vger.kernel.org>,
        linux arch <linux-arch@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>,
        Guan Xuetao <guanxuetao@mprc.pku.edu.cn>,
        Michal Marek <mmarek@suse.cz>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: [PATCH 1/2] kbuild: asm-generic support
Message-ID: <20110109083125.GA17045@merkur.ravnborg.org>
References: <20110108130302.GA21698@merkur.ravnborg.org> <20110109082851.GA10463@merkur.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110109082851.GA10463@merkur.ravnborg.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From a7928ed5ab8b1f8f1b1b2bd8a9cb59819f46a522 Mon Sep 17 00:00:00 2001
From: Sam Ravnborg <sam@ravnborg.org>
Date: Sun, 9 Jan 2011 09:13:22 +0100
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

The original inspiration for this came from the unicor32
patchset - although is used a different method.

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
Cc: Guan Xuetao <guanxuetao@mprc.pku.edu.cn>
Cc: Arnd Bergmann <arnd@arndb.de>
---
 .gitignore                         |    1 +
 Documentation/kbuild/makefiles.txt |   31 +++++++++++++++++
 Makefile                           |   15 ++++++--
 include/asm-generic/Kbuild.asm     |   66 ++++++++++++++++++------------------
 scripts/Makefile.headersinst       |   19 +++++++++--
 scripts/asm-generic.sh             |   23 ++++++++++++
 6 files changed, 115 insertions(+), 40 deletions(-)
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
index 0ef00bd..7763786 100644
--- a/Documentation/kbuild/makefiles.txt
+++ b/Documentation/kbuild/makefiles.txt
@@ -1250,6 +1250,37 @@ See subsequent chapter for the syntax of the Kbuild file.
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
+	of the set of exported headers.
+
+	--- 7.5 generic-export-y
+
+	List of generic headers to be exported if the architecture
+	does not have their own variants.
+
+		Example:
+			#include/asm-generic/Kbuild.asm
+			generic-export-y += termios.h
+
+	See "generic-y" for a description of how an architectue
+	define which headers are used from the generic set.
 
 === 8 Kbuild Variables
 
diff --git a/Makefile b/Makefile
index 74b2555..9eeb44e 100644
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
+		  arch/*/include/generated
 MRPROPER_FILES += .config .config.old .version .old_version             \
                   include/linux/version.h                               \
 		  Module.symvers tags TAGS cscope*
diff --git a/include/asm-generic/Kbuild.asm b/include/asm-generic/Kbuild.asm
index c5d2e5d..a9e89f3 100644
--- a/include/asm-generic/Kbuild.asm
+++ b/include/asm-generic/Kbuild.asm
@@ -1,45 +1,45 @@
 ifneq ($(wildcard $(srctree)/arch/$(SRCARCH)/include/asm/kvm.h \
 		  $(srctree)/include/asm-$(SRCARCH)/kvm.h),)
-header-y  += kvm.h
+generic-export-y  += kvm.h
 endif
 
 ifneq ($(wildcard $(srctree)/arch/$(SRCARCH)/include/asm/kvm_para.h \
 		  $(srctree)/include/asm-$(SRCARCH)/kvm_para.h),)
-header-y  += kvm_para.h
+generic-export-y  += kvm_para.h
 endif
 
 ifneq ($(wildcard $(srctree)/arch/$(SRCARCH)/include/asm/a.out.h \
 		  $(srctree)/include/asm-$(SRCARCH)/a.out.h),)
-header-y += a.out.h
+generic-export-y += a.out.h
 endif
 
-header-y += auxvec.h
-header-y += bitsperlong.h
-header-y += byteorder.h
-header-y += errno.h
-header-y += fcntl.h
-header-y += ioctl.h
-header-y += ioctls.h
-header-y += ipcbuf.h
-header-y += mman.h
-header-y += msgbuf.h
-header-y += param.h
-header-y += poll.h
-header-y += posix_types.h
-header-y += ptrace.h
-header-y += resource.h
-header-y += sembuf.h
-header-y += setup.h
-header-y += shmbuf.h
-header-y += sigcontext.h
-header-y += siginfo.h
-header-y += signal.h
-header-y += socket.h
-header-y += sockios.h
-header-y += stat.h
-header-y += statfs.h
-header-y += swab.h
-header-y += termbits.h
-header-y += termios.h
-header-y += types.h
-header-y += unistd.h
+generic-export-y += auxvec.h
+generic-export-y += bitsperlong.h
+generic-export-y += byteorder.h
+generic-export-y += errno.h
+generic-export-y += fcntl.h
+generic-export-y += ioctl.h
+generic-export-y += ioctls.h
+generic-export-y += ipcbuf.h
+generic-export-y += mman.h
+generic-export-y += msgbuf.h
+generic-export-y += param.h
+generic-export-y += poll.h
+generic-export-y += posix_types.h
+generic-export-y += ptrace.h
+generic-export-y += resource.h
+generic-export-y += sembuf.h
+generic-export-y += setup.h
+generic-export-y += shmbuf.h
+generic-export-y += sigcontext.h
+generic-export-y += siginfo.h
+generic-export-y += signal.h
+generic-export-y += socket.h
+generic-export-y += sockios.h
+generic-export-y += stat.h
+generic-export-y += statfs.h
+generic-export-y += swab.h
+generic-export-y += termbits.h
+generic-export-y += termios.h
+generic-export-y += types.h
+generic-export-y += unistd.h
diff --git a/scripts/Makefile.headersinst b/scripts/Makefile.headersinst
index f89cb87..3a630c2 100644
--- a/scripts/Makefile.headersinst
+++ b/scripts/Makefile.headersinst
@@ -14,6 +14,7 @@ kbuild-file := $(srctree)/$(obj)/Kbuild
 include $(kbuild-file)
 
 _dst := $(if $(destination-y),$(destination-y),$(_dst))
+_src := $(srctree)/$(obj)
 
 include scripts/Kbuild.include
 
@@ -27,10 +28,17 @@ header-y      := $(filter-out %/, $(header-y))
 install-file  := $(install)/.install
 check-file    := $(install)/.check
 
+# generic-export-y list all generic headers to be exported
+# generic-y list all files an architecture uses from asm-generic
+# Use this to build a list of headers which require a wrapper
+wrapper-files := $(filter $(generic-export-y), $(generic-y))
+
 # all headers files for this dir
-all-files     := $(header-y) $(objhdr-y)
-input-files   := $(addprefix $(srctree)/$(obj)/,$(header-y)) \
+header-y      := $(filter-out $(wrapper-files), $(header-y))
+all-files     := $(header-y) $(objhdr-y) $(generic-y)
+input-files   := $(addprefix $(_src)/,$(header-y)) \
                  $(addprefix $(objtree)/$(obj)/,$(objhdr-y))
+
 output-files  := $(addprefix $(install)/, $(all-files))
 
 # Work out what needs to be removed
@@ -47,8 +55,12 @@ quiet_cmd_install = INSTALL $(printdir) ($(words $(all-files))\
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
 
@@ -69,7 +81,8 @@ __headersinst: $(subdirs) $(install-file)
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
index 0000000..bc04f08
--- /dev/null
+++ b/scripts/asm-generic.sh
@@ -0,0 +1,23 @@
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
+files=$( cat ${srctree}/arch/$1/include/asm/Kbuild | \
+          grep -v ^# | grep generic-y | cut -d '=' -f 2)
+
+gendir=arch/$1/include/generated/asm
+mkdir -p ${gendir}
+
+# create include files for each file used form asm-generic
+for F in ${files}; do
+	echo "#include <asm-generic/$F>" > ${gendir}/$F
+done
-- 
1.6.0.6

