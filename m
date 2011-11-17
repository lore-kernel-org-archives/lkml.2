Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754268Ab1KQWjN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Nov 2011 17:39:13 -0500
Received: from mga09.intel.com ([134.134.136.24]:12670 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753496Ab1KQWhh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Nov 2011 17:37:37 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="77077672"
From: "H. Peter Anvin" <hpa@linux.intel.com>
To: linux-kernel@vger.kernel.org, kbuild@vger.kernel.org,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>
Cc: "H.J. Lu" <hjl.tools@gmail.com>, David Woodhouse <dwmw2@infradead.org>,
        Michal Marek <mmarek@suse.cz>, Sam Ravnborg <sam@ravnborg.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        "H. Peter Anvin" <hpa@linux.intel.com>
Subject: [PATCH 2/8] kbuild: Add support for an "archheaders" target
Date: Thu, 17 Nov 2011 14:37:20 -0800
Message-Id: <1321569446-20433-3-git-send-email-hpa@linux.intel.com>
X-Mailer: git-send-email 1.7.6.4
In-Reply-To: <1321569446-20433-1-git-send-email-hpa@linux.intel.com>
References: <1321569446-20433-1-git-send-email-hpa@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "H. Peter Anvin" <hpa@linux.intel.com>

Add support for an "archheaders" target.  This target can generate
files that need to be installed for user space by "make
headers_install" or "make headers_install_all".

In order to support "make headers_install_all", it must be able to run
without the tree having to be configured first.

Cc: David Woodhouse <dwmw2@infradead.org>
Cc: Sam Ravnborg <sam@ravnborg.org>
Cc: Michal Marek <mmarek@suse.cz>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 Documentation/kbuild/makefiles.txt |   50 +++++++++++++++++++++++-------------
 Makefile                           |    9 ++++--
 scripts/headers.sh                 |    1 +
 3 files changed, 39 insertions(+), 21 deletions(-)

diff --git a/Documentation/kbuild/makefiles.txt b/Documentation/kbuild/makefiles.txt
index f47cdef..ab0a984 100644
--- a/Documentation/kbuild/makefiles.txt
+++ b/Documentation/kbuild/makefiles.txt
@@ -33,14 +33,15 @@ This document describes the Linux kernel Makefiles.
 
 	=== 6 Architecture Makefiles
 	   --- 6.1 Set variables to tweak the build to the architecture
-	   --- 6.2 Add prerequisites to archprepare:
-	   --- 6.3 List directories to visit when descending
-	   --- 6.4 Architecture-specific boot images
-	   --- 6.5 Building non-kbuild targets
-	   --- 6.6 Commands useful for building a boot image
-	   --- 6.7 Custom kbuild commands
-	   --- 6.8 Preprocessing linker scripts
-	   --- 6.9 Generic header files
+	   --- 6.2 Add prerequisites to archheaders:
+	   --- 6.3 Add prerequisites to archprepare:
+	   --- 6.4 List directories to visit when descending
+	   --- 6.5 Architecture-specific boot images
+	   --- 6.6 Building non-kbuild targets
+	   --- 6.7 Commands useful for building a boot image
+	   --- 6.8 Custom kbuild commands
+	   --- 6.9 Preprocessing linker scripts
+	   --- 6.10 Generic header files
 
 	=== 7 Kbuild syntax for exported headers
 		--- 7.1 header-y
@@ -252,7 +253,7 @@ more details, with real examples.
 	This will create a library lib.a based on delay.o. For kbuild to
 	actually recognize that there is a lib.a being built, the directory
 	shall be listed in libs-y.
-	See also "6.3 List directories to visit when descending".
+	See also "6.4 List directories to visit when descending".
 
 	Use of lib-y is normally restricted to lib/ and arch/*/lib.
 
@@ -974,7 +975,20 @@ When kbuild executes, the following steps are followed (roughly):
 	$(KBUILD_ARFLAGS) set by the top level Makefile to "D" (deterministic
 	mode) if this option is supported by $(AR).
 
---- 6.2 Add prerequisites to archprepare:
+--- 6.2 Add prerequisites to archheaders:
+
+	The archheaders: rule is used to generate header files that
+	may be installed into user space by "make header_install" or
+	"make headers_install_all".  In order to support
+	"make headers_install_all", this target has to be able to run
+	on an unconfigured tree, or a tree configured for another
+	architecture.
+
+	It is run before "make archprepare" when run on the
+	architecture itself.
+
+
+--- 6.3 Add prerequisites to archprepare:
 
 	The archprepare: rule is used to list prerequisites that need to be
 	built before starting to descend down in the subdirectories.
@@ -990,7 +1004,7 @@ When kbuild executes, the following steps are followed (roughly):
 	generating offset header files.
 
 
---- 6.3 List directories to visit when descending
+--- 6.4 List directories to visit when descending
 
 	An arch Makefile cooperates with the top Makefile to define variables
 	which specify how to build the vmlinux file.  Note that there is no
@@ -1019,7 +1033,7 @@ When kbuild executes, the following steps are followed (roughly):
 		drivers-$(CONFIG_OPROFILE)  += arch/sparc64/oprofile/
 
 
---- 6.4 Architecture-specific boot images
+--- 6.5 Architecture-specific boot images
 
 	An arch Makefile specifies goals that take the vmlinux file, compress
 	it, wrap it in bootstrapping code, and copy the resulting files
@@ -1070,7 +1084,7 @@ When kbuild executes, the following steps are followed (roughly):
 
 	When "make" is executed without arguments, bzImage will be built.
 
---- 6.5 Building non-kbuild targets
+--- 6.6 Building non-kbuild targets
 
     extra-y
 
@@ -1090,7 +1104,7 @@ When kbuild executes, the following steps are followed (roughly):
 	shall be built, but shall not be linked as part of built-in.o.
 
 
---- 6.6 Commands useful for building a boot image
+--- 6.7 Commands useful for building a boot image
 
 	Kbuild provides a few macros that are useful when building a
 	boot image.
@@ -1112,7 +1126,7 @@ When kbuild executes, the following steps are followed (roughly):
 	always be built.
 	Assignments to $(targets) are without $(obj)/ prefix.
 	if_changed may be used in conjunction with custom commands as
-	defined in 6.7 "Custom kbuild commands".
+	defined in 6.8 "Custom kbuild commands".
 
 	Note: It is a typical mistake to forget the FORCE prerequisite.
 	Another common pitfall is that whitespace is sometimes
@@ -1171,7 +1185,7 @@ When kbuild executes, the following steps are followed (roughly):
 		$(obj)/%.dtb: $(src)/%.dts
 			$(call cmd,dtc)
 
---- 6.7 Custom kbuild commands
+--- 6.8 Custom kbuild commands
 
 	When kbuild is executing with KBUILD_VERBOSE=0, then only a shorthand
 	of a command is normally displayed.
@@ -1198,7 +1212,7 @@ When kbuild executes, the following steps are followed (roughly):
 	will be displayed with "make KBUILD_VERBOSE=0".
 
 
---- 6.8 Preprocessing linker scripts
+--- 6.9 Preprocessing linker scripts
 
 	When the vmlinux image is built, the linker script
 	arch/$(ARCH)/kernel/vmlinux.lds is used.
@@ -1228,7 +1242,7 @@ When kbuild executes, the following steps are followed (roughly):
 	The kbuild infrastructure for *lds file are used in several
 	architecture-specific files.
 
---- 6.9 Generic header files
+--- 6.10 Generic header files
 
 	The directory include/asm-generic contains the header files
 	that may be shared between individual architectures.
diff --git a/Makefile b/Makefile
index dab8610..e5e0e07 100644
--- a/Makefile
+++ b/Makefile
@@ -442,7 +442,7 @@ asm-generic:
 
 no-dot-config-targets := clean mrproper distclean \
 			 cscope gtags TAGS tags help %docs check% coccicheck \
-			 include/linux/version.h headers_% \
+			 include/linux/version.h headers_% archheaders \
 			 kernelversion %src-pkg
 
 config-targets := 0
@@ -979,7 +979,7 @@ prepare1: prepare2 include/linux/version.h include/generated/utsrelease.h \
                    include/config/auto.conf
 	$(cmd_crmodverdir)
 
-archprepare: prepare1 scripts_basic
+archprepare: archheaders prepare1 scripts_basic
 
 prepare0: archprepare FORCE
 	$(Q)$(MAKE) $(build)=.
@@ -1046,8 +1046,11 @@ hdr-inst := -rR -f $(srctree)/scripts/Makefile.headersinst obj
 # If we do an all arch process set dst to asm-$(hdr-arch)
 hdr-dst = $(if $(KBUILD_HEADERS), dst=include/asm-$(hdr-arch), dst=include/asm)
 
+PHONY += archheaders
+archheaders:
+
 PHONY += __headers
-__headers: include/linux/version.h scripts_basic asm-generic FORCE
+__headers: include/linux/version.h scripts_basic asm-generic archheaders FORCE
 	$(Q)$(MAKE) $(build)=scripts build_unifdef
 
 PHONY += headers_install_all
diff --git a/scripts/headers.sh b/scripts/headers.sh
index 978b42b..af1ed88 100755
--- a/scripts/headers.sh
+++ b/scripts/headers.sh
@@ -7,6 +7,7 @@ set -e
 do_command()
 {
 	if [ -f ${srctree}/arch/$2/include/asm/Kbuild ]; then
+		make ARCH=$2 KBUILD_HEADERS=$1 archheaders
 		make ARCH=$2 KBUILD_HEADERS=$1 headers_$1
 	else
 		printf "Ignoring arch: %s\n" ${arch}
-- 
1.7.6.4

