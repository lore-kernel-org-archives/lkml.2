Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756730Ab2HSDDU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Aug 2012 23:03:20 -0400
Received: from mga02.intel.com ([134.134.136.20]:64945 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754025Ab2HSC5r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Aug 2012 22:57:47 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.77,792,1336374000"; 
   d="scan'208";a="182422081"
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org
Cc: x86@kernel.org, mmarek@suse.cz, linux-kbuild@vger.kernel.org,
        JBeulich@suse.com, akpm@linux-foundation.org,
        Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 67/74] Kbuild, lto: Add Link Time Optimization support
Date: Sat, 18 Aug 2012 19:57:03 -0700
Message-Id: <1345345030-22211-68-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1345345030-22211-1-git-send-email-andi@firstfloor.org>
References: <1345345030-22211-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

With LTO gcc will do whole program optimizations for
the whole kernel and each module. This increases compile time,
but can generate faster code.

LTO allows gcc to inline functions between different files and
do various other optimization across the whole binary.

It might also trigger bugs due to more aggressive optimization.
It allows gcc to drop unused code. It also allows it to check
types over the whole program.

This adds the basic Kbuild plumbing for LTO:

- In Kbuild add a new scripts/Makefile.lto that checks
the tool chain (note the checks may not be fully bulletproof)
and when the tests pass sets the LTO options
Currently LTO is very finicky about the tool chain.
- Add a new LDFINAL variable that controls the final link
for vmlinux or module. In this case we call gcc-ld instead
of ld, to run the LTO step.
- For slim LTO builds (object files containing no backup
executable) force AR to gcc-ar
- Theoretically LTO should pass through compiler options from
the compiler to the link step, but this doesn't work for all options.
So the Makefile sets most of these options manually.
- Kconfigs:
Since LTO with allyesconfig needs more than 4G of memory (~8G)
and has the potential to makes people's system swap to death.
I used a nested config that ensures that a simple
allyesconfig disables LTO. It has to be explicitely
enabled.
- Some depencies on other Kconfigs:
MODVERSIONS, GCOV, FUNCTION_TRACER, single chain WCHAN are
incompatible with LTO currently. MODVERSIONS should be fixable,
but the others require setting special compiler options
for specific files, which LTO currently doesn't support.
I also disable strict copy user checks because they trigger
errors with LTO.

For more information see Documentation/lto-build

Thanks to HJ Lu, Joe Mario, Honza Hubicka, Richard Guenther,
Don Zickus, Changlong Xie who helped with this project
(and probably some more who I forgot, sorry)

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 Makefile                 |    9 +++++-
 arch/x86/Kconfig         |    2 +-
 arch/x86/Kconfig.debug   |    2 +-
 init/Kconfig             |   58 ++++++++++++++++++++++++++++++++++++++
 kernel/gcov/Kconfig      |    2 +-
 scripts/Makefile.lto     |   69 ++++++++++++++++++++++++++++++++++++++++++++++
 scripts/Makefile.modpost |    2 +-
 scripts/link-vmlinux.sh  |    4 +-
 8 files changed, 141 insertions(+), 7 deletions(-)
 create mode 100644 scripts/Makefile.lto

diff --git a/Makefile b/Makefile
index 9cc77ac..b80c080 100644
--- a/Makefile
+++ b/Makefile
@@ -326,9 +326,14 @@ include $(srctree)/scripts/Kbuild.include
 
 AS		= $(CROSS_COMPILE)as
 LD		= $(CROSS_COMPILE)ld
+LDFINAL	= $(LD)
 CC		= $(CROSS_COMPILE)gcc
 CPP		= $(CC) -E
+ifdef CONFIG_LTO_SLIM
+AR		= $(CROSS_COMPILE)gcc-ar
+else
 AR		= $(CROSS_COMPILE)ar
+endif
 NM		= $(CROSS_COMPILE)nm
 STRIP		= $(CROSS_COMPILE)strip
 OBJCOPY		= $(CROSS_COMPILE)objcopy
@@ -377,7 +382,7 @@ KERNELVERSION = $(VERSION)$(if $(PATCHLEVEL),.$(PATCHLEVEL)$(if $(SUBLEVEL),.$(S
 
 export VERSION PATCHLEVEL SUBLEVEL KERNELRELEASE KERNELVERSION
 export ARCH SRCARCH CONFIG_SHELL HOSTCC HOSTCFLAGS CROSS_COMPILE AS LD CC
-export CPP AR NM STRIP OBJCOPY OBJDUMP
+export CPP AR NM STRIP OBJCOPY OBJDUMP LDFINAL
 export MAKE AWK GENKSYMS INSTALLKERNEL PERL UTS_MACHINE
 export HOSTCXX HOSTCXXFLAGS LDFLAGS_MODULE CHECK CHECKFLAGS
 
@@ -647,6 +652,8 @@ ifeq ($(shell $(CONFIG_SHELL) $(srctree)/scripts/gcc-goto.sh $(CC)), y)
 	KBUILD_CFLAGS += -DCC_HAVE_ASM_GOTO
 endif
 
+include ${srctree}/scripts/Makefile.lto
+
 # Add user supplied CPPFLAGS, AFLAGS and CFLAGS as the last assignments
 # But warn user when we do so
 warn-assign = \
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 9382b09..2e2974f 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -540,7 +540,7 @@ config X86_32_IRIS
 
 config SCHED_OMIT_FRAME_POINTER
 	def_bool y
-	prompt "Single-depth WCHAN output"
+	prompt "Single-depth WCHAN output" if !LTO && !FRAME_POINTER
 	depends on X86
 	---help---
 	  Calculate simpler /proc/<PID>/wchan values. If this option
diff --git a/arch/x86/Kconfig.debug b/arch/x86/Kconfig.debug
index b322f12..7961491 100644
--- a/arch/x86/Kconfig.debug
+++ b/arch/x86/Kconfig.debug
@@ -294,7 +294,7 @@ config OPTIMIZE_INLINING
 
 config DEBUG_STRICT_USER_COPY_CHECKS
 	bool "Strict copy size checks"
-	depends on DEBUG_KERNEL && !TRACE_BRANCH_PROFILING
+	depends on DEBUG_KERNEL && !TRACE_BRANCH_PROFILING && !LTO
 	---help---
 	  Enabling this option turns a certain set of sanity checks for user
 	  copy operations into compile time failures.
diff --git a/init/Kconfig b/init/Kconfig
index a8785db..0b972ab 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -1135,6 +1135,63 @@ config CC_OPTIMIZE_FOR_SIZE
 
 	  If unsure, say Y.
 
+config LTO_MENU
+	bool "Enable gcc link time optimizations"
+	# Only tested on X86 for now. For other architectures you likely
+	# have to fix some things first, like adding asmlinkages etc.
+	depends on EXPERIMENTAL && X86
+	# lto does not support excluding flags for specific files
+	# right now. Can be removed if that is fixed.
+	depends on !FUNCTION_TRACER
+	help
+	  With this option gcc will do whole program optimizations for
+	  the whole kernel and module. This increases compile time, but can
+	  lead to better code. It allows gcc to inline functions between
+	  different files. It might also trigger bugs due to more
+	  aggressive optimization. It allows gcc to drop unused code.
+	  With this option gcc will also do some global checking over
+	  different source files.
+
+	  This requires a gcc 4.7 or later compiler and
+	  Linux binutils 2.21.51.0.3 or later.  It does not currently
+	  work with a FSF release of binutils or with gold.
+
+	  On larger configurations this may need more than 4GB of RAM.
+	  It will likely not work on those with a 32bit compiler. Also
+	  /tmp in tmpfs may lead to faster running out of RAM
+	  (in this case set the TMPDIR environment variable to a different
+	  directory directly on disk)
+
+	  When the toolchain support is not available this will (hopefully)
+	  be automatically disabled.
+
+	  For more information see Documentation/lto-build
+
+config LTO_DISABLE
+         bool "Disable LTO again"
+         depends on LTO_MENU
+         default n
+         help
+           This option is merely here so that allyesconfig or allmodconfig does
+           not enable LTO. If you want to actually use LTO do not enable.
+
+config LTO
+	bool
+	default y
+	depends on LTO_MENU && !LTO_DISABLE
+
+config LTO_DEBUG
+	bool "Enable LTO compile time debugging"
+	depends on LTO
+
+config LTO_SLIM
+	bool "Use slim lto"
+	# need to fix modpost for it
+	depends on LTO && BROKEN
+	help
+	  Do not generate all code twice. The object files will only contain
+	  LTO information. This lowers build time.
+
 config SYSCTL
 	bool
 
@@ -1566,6 +1623,7 @@ config MODULE_FORCE_UNLOAD
 
 config MODVERSIONS
 	bool "Module versioning support"
+	depends on !LTO
 	help
 	  Usually, you have to use modules compiled with your kernel.
 	  Saying Y here makes it sometimes possible to use modules
diff --git a/kernel/gcov/Kconfig b/kernel/gcov/Kconfig
index a920281..b9f6381 100644
--- a/kernel/gcov/Kconfig
+++ b/kernel/gcov/Kconfig
@@ -2,7 +2,7 @@ menu "GCOV-based kernel profiling"
 
 config GCOV_KERNEL
 	bool "Enable gcov-based kernel profiling"
-	depends on DEBUG_FS
+	depends on DEBUG_FS && !LTO
 	select CONSTRUCTORS if !UML
 	default n
 	---help---
diff --git a/scripts/Makefile.lto b/scripts/Makefile.lto
new file mode 100644
index 0000000..1321220
--- /dev/null
+++ b/scripts/Makefile.lto
@@ -0,0 +1,69 @@
+#
+# Support for gcc link time optimization
+#
+
+DISABLE_LTO :=
+LTO_CFLAGS :=
+
+export DISABLE_LTO
+export LTO_CFLAGS
+
+ifdef CONFIG_LTO
+ifeq ($(call cc-ifversion, -ge, 0407,y),y)
+ifneq ($(call cc-option,${LTO_CFLAGS},n),n)
+# We need HJ Lu's Linux binutils because mainline binutils does not
+# support mixing assembler and LTO code in the same ld -r object.
+# XXX check if the gcc plugin ld is the expected one too
+ifeq ($(call ld-ifversion,-ge,22710001,y),y)
+# should use -flto=jobserver, but we need a fix for http://gcc.gnu.org/PR50639
+        LTO_CFLAGS := -flto -fno-toplevel-reorder
+        LTO_FINAL_CFLAGS := -fuse-linker-plugin -flto=$(shell getconf _NPROCESSORS_ONLN) -fno-toplevel-reorder
+ifdef CONFIG_LTO_SLIM
+	# requires plugin ar passed and very recent HJ binutils
+        LTO_CFLAGS += -fno-fat-lto-objects
+endif
+	DISABLE_LTO := -fno-lto
+
+	LTO_FINAL_CFLAGS += ${LTO_CFLAGS} -fwhole-program  
+
+	# workaround for http://gcc.gnu.org/PR50602
+	LTO_FINAL_CFLAGS += $(filter -freg-struct-return,${KBUILD_CFLAGS})
+
+ifdef CONFIG_LTO_DEBUG
+	LTO_FINAL_CFLAGS += -dH -fdump-ipa-cgraph -fdump-ipa-inline-details # -Wl,-plugin-save-temps -save-temps
+	LTO_CFLAGS += 
+endif
+
+	# In principle gcc should pass through options in the object files,
+	# but it doesn't always work. So do it here manually
+	LTO_FINAL_CFLAGS += $(filter -g%,${KBUILD_CFLAGS})
+	LTO_FINAL_CFLAGS += $(filter -O%,${KBUILD_CFLAGS})
+	LTO_FINAL_CFLAGS += $(filter -f%,${KBUILD_CFLAGS})
+	#LTO_FINAL_CFLAGS += $(filter -fno-omit-frame-pointer, ${KBUILD_CFLAGS})
+	#LTO_FINAL_CFLAGS += $(filter -fno-strict-aliasing, ${KBUILD_CFLAGS})
+	#LTO_FINAL_CFLAGS += $(filter -fno-delete-null-pointer-checks, ${KBUILD_CFLAGS})
+	#LTO_FINAL_CFLAGS += $(filter -fno-strict-overflow, ${KBUILD_CFLAGS})
+	LTO_FINAL_CFLAGS += $(filter -m%,${KBUILD_CFLAGS})
+	LTO_FINAL_CFLAGS += $(filter -W%,${KBUILD_CFLAGS})
+
+	KBUILD_CFLAGS += ${LTO_CFLAGS}
+
+	#
+	# Don't pass all flags to the optimization stage
+	# We assume the compiler remembers those in the object files.
+	# Currently gcc is a little dumb in this and uses the flags
+	# from the first file, which implies that setting special
+	# flags on files does not work.
+	LDFINAL := ${CONFIG_SHELL} ${srctree}/scripts/gcc-ld \
+                  ${LTO_FINAL_CFLAGS}
+
+else
+        $(warning "WARNING: Too old linker version $(call ld-version) for kernel LTO. You need Linux binutils. CONFIG_LTO disabled.")
+endif
+else
+        $(warning "WARNING: Compiler/Linker does not support LTO/WHOPR with linker plugin. CONFIG_LTO disabled.")
+endif
+else
+        $(warning "WARNING: GCC $(call cc-version) too old for LTO/WHOPR. CONFIG_LTO disabled")
+endif
+endif
diff --git a/scripts/Makefile.modpost b/scripts/Makefile.modpost
index 08dce14..9d66a22 100644
--- a/scripts/Makefile.modpost
+++ b/scripts/Makefile.modpost
@@ -117,7 +117,7 @@ targets += $(modules:.ko=.mod.o)
 
 # Step 6), final link of the modules
 quiet_cmd_ld_ko_o = LD [M]  $@
-      cmd_ld_ko_o = $(LD) -r $(LDFLAGS)                                 \
+      cmd_ld_ko_o = $(LDFINAL) -r $(LDFLAGS)                            \
                              $(KBUILD_LDFLAGS_MODULE) $(LDFLAGS_MODULE) \
                              -o $@ $(filter-out FORCE,$^)
 
diff --git a/scripts/link-vmlinux.sh b/scripts/link-vmlinux.sh
index a05c49c..be65534 100644
--- a/scripts/link-vmlinux.sh
+++ b/scripts/link-vmlinux.sh
@@ -53,7 +53,7 @@ vmlinux_link()
 	local lds="${objtree}/${KBUILD_LDS}"
 
 	if [ "${SRCARCH}" != "um" ]; then
-		${LD} ${LDFLAGS} ${LDFLAGS_vmlinux} -o ${2}                  \
+		${LDFINAL} ${LDFLAGS} ${LDFLAGS_vmlinux} -o ${2}                  \
 			-T ${lds} ${KBUILD_VMLINUX_INIT}                     \
 			--start-group ${KBUILD_VMLINUX_MAIN} --end-group ${1}
 	else
@@ -196,7 +196,7 @@ if [ -n "${CONFIG_KALLSYMS}" ]; then
 	fi
 fi
 
-info LD vmlinux
+info LDFINAL vmlinux
 vmlinux_link "${kallsymso}" vmlinux
 
 if [ -n "${CONFIG_BUILDTIME_EXTABLE_SORT}" ]; then
-- 
1.7.7.6

