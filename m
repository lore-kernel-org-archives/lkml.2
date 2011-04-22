Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756032Ab1DVPxx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Apr 2011 11:53:53 -0400
Received: from pfepa.post.tele.dk ([195.41.46.235]:57861 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755430Ab1DVPxv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Apr 2011 11:53:51 -0400
Date: Fri, 22 Apr 2011 17:53:49 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Michal Marek <mmarek@suse.cz>
Cc: lkml <linux-kernel@vger.kernel.org>,
        linux-kbuild <linux-kbuild@vger.kernel.org>,
        linux arch <linux-arch@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>,
        Guan Xuetao <guanxuetao@mprc.pku.edu.cn>
Subject: [PATCH v3] kbuild: asm-generic support
Message-ID: <20110422155349.GA9579@merkur.ravnborg.org>
References: <20110108130302.GA21698@merkur.ravnborg.org> <20110109192707.GA12387@merkur.ravnborg.org> <20110109192907.GA12403@merkur.ravnborg.org> <4D2F24CD.5040101@suse.cz> <20110113170131.GA28377@merkur.ravnborg.org> <20110114144354.GA23611@sepie.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110114144354.GA23611@sepie.suse.cz>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 34d0b72a343dd63c1c1b049e4ba6931f0dbcbc3f Mon Sep 17 00:00:00 2001
From: Sam Ravnborg <sam@ravnborg.org>
Date: Fri, 22 Apr 2011 14:45:13 +0200
Subject: [PATCH] kbuild: asm-generic support

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
patchset - although a different method is used.

The patch includes several improvements from Arnd Bergmann.
Michael Marek contributed Makefile.asm-generic.

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
Cc: Guan Xuetao <guanxuetao@mprc.pku.edu.cn>
Cc: Arnd Bergmann <arnd@arndb.de>
---

Hi Mikael.

It took me a while to get back to this.
I used your Makefile.asm-generic almost verbatim.

Only change was that we always need to create the output directory.

	Sam

 .gitignore                         |    1 +
 Documentation/kbuild/makefiles.txt |   36 ++++++++++++++++++++++++++++++++++++
 Makefile                           |   15 +++++++++++----
 scripts/Makefile.asm-generic       |   23 +++++++++++++++++++++++
 scripts/Makefile.headersinst       |   18 +++++++++++++++---
 5 files changed, 86 insertions(+), 7 deletions(-)
 create mode 100644 scripts/Makefile.asm-generic

diff --git a/.gitignore b/.gitignore
index 5d56a3f..9dacde0 100644
--- a/.gitignore
+++ b/.gitignore
@@ -57,6 +57,7 @@ modules.builtin
 include/config
 include/linux/version.h
 include/generated
+arch/*/include/generated
 
 # stgit generated dirs
 patches-*
diff --git a/Documentation/kbuild/makefiles.txt b/Documentation/kbuild/makefiles.txt
index 5d145bb..7f2b8e7 100644
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
@@ -1209,6 +1211,14 @@ When kbuild executes, the following steps are followed (roughly):
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
@@ -1265,6 +1275,32 @@ See subsequent chapter for the syntax of the Kbuild file.
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
index b967b96..30b3852 100644
--- a/Makefile
+++ b/Makefile
@@ -349,7 +349,8 @@ CFLAGS_GCOV	= -fprofile-arcs -ftest-coverage
 
 # Use LINUXINCLUDE when you must reference the include/ directory.
 # Needed to be compatible with the O= option
-LINUXINCLUDE    := -I$(srctree)/arch/$(hdr-arch)/include -Iinclude \
+LINUXINCLUDE    := -I$(srctree)/arch/$(hdr-arch)/include \
+                   -Iarch/$(hdr-arch)/include/generated -Iinclude \
                    $(if $(KBUILD_SRC), -I$(srctree)/include) \
                    -include include/generated/autoconf.h
 
@@ -416,6 +417,11 @@ ifneq ($(KBUILD_SRC),)
 	    $(srctree) $(objtree) $(VERSION) $(PATCHLEVEL)
 endif
 
+# Support for using generic headers in asm-generic
+PHONY += asm-generic
+asm-generic:
+	$(Q)$(MAKE) -f $(srctree)/scripts/Makefile.asm-generic obj=arch/$(SRCARCH)/include/generated/asm
+
 # To make sure we do not include .config for any of the *config targets
 # catch them early, and hand them over to scripts/kconfig/Makefile
 # It is allowed to specify more targets when calling make, including
@@ -947,7 +953,7 @@ ifneq ($(KBUILD_SRC),)
 endif
 
 # prepare2 creates a makefile if using a separate output directory
-prepare2: prepare3 outputmakefile
+prepare2: prepare3 outputmakefile asm-generic
 
 prepare1: prepare2 include/linux/version.h include/generated/utsrelease.h \
                    include/config/auto.conf
@@ -1021,7 +1027,7 @@ hdr-inst := -rR -f $(srctree)/scripts/Makefile.headersinst obj
 hdr-dst = $(if $(KBUILD_HEADERS), dst=include/asm-$(hdr-arch), dst=include/asm)
 
 PHONY += __headers
-__headers: include/linux/version.h scripts_basic FORCE
+__headers: include/linux/version.h scripts_basic asm-generic FORCE
 	$(Q)$(MAKE) $(build)=scripts build_unifdef
 
 PHONY += headers_install_all
@@ -1136,7 +1142,8 @@ CLEAN_FILES +=	vmlinux System.map \
                 .tmp_kallsyms* .tmp_version .tmp_vmlinux* .tmp_System.map
 
 # Directories & files removed with 'make mrproper'
-MRPROPER_DIRS  += include/config usr/include include/generated
+MRPROPER_DIRS  += include/config usr/include include/generated          \
+                  arch/*/include/generated
 MRPROPER_FILES += .config .config.old .version .old_version             \
                   include/linux/version.h                               \
 		  Module.symvers tags TAGS cscope* GPATH GTAGS GRTAGS GSYMS
diff --git a/scripts/Makefile.asm-generic b/scripts/Makefile.asm-generic
new file mode 100644
index 0000000..a687cb6
--- /dev/null
+++ b/scripts/Makefile.asm-generic
@@ -0,0 +1,23 @@
+# include/asm-generic contains a lot of files that are used
+# verbatim by several architectures.
+#
+# This Makefile reads the file arch/$(SRCARCH)/include/asm/Kbuild
+# and for each file listed in this file with generic-y creates
+# a small wrapper file in $(obj) (arch/$(SRCARCH)/include/generated/asm)
+
+kbuild-file := $(srctree)/arch/$(SRCARCH)/include/asm/Kbuild
+include $(kbuild-file)
+
+include scripts/Kbuild.include
+
+# Create output directory if not already present
+_dummy := $(shell [ -d $(obj) ] || mkdir -p $(obj))
+
+quiet_cmd_wrap = WRAP    $@
+cmd_wrap = echo "\#include <asm-generic/$*.h>" >$@
+
+all: $(patsubst %, $(obj)/%, $(generic-y))
+
+$(obj)/%.h:
+	$(call cmd,wrap)
+
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
-- 
1.6.0.6

