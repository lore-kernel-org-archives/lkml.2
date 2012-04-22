Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753120Ab2DVVWc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Apr 2012 17:22:32 -0400
Received: from smtp.snhosting.dk ([87.238.248.203]:62320 "EHLO
	smtp.domainteam.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753074Ab2DVVW1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Apr 2012 17:22:27 -0400
Date: Sun, 22 Apr 2012 23:22:20 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: linux arch <linux-arch@vger.kernel.org>,
        linux-kbuild <linux-kbuild@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>
Cc: Michal Marek <mmarek@suse.cz>
Subject: [RFC] move link of vmlinux to a script
Message-ID: <20120422212220.GA6537@merkur.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The part of the top-level Makefile that links the
final vmlinux has accumulated a lot of cruft over
times and the makefile code is unreadable for
any normal human.

This is an attempt to clean up the situation, by
moving all the logic to a shell script.
In reality we almost never rely on the Makefile
logic to avoid a few steps in the link - and
the process is serialized in any case.
So the drawbacks by moving this to a shell script
are small compared to the added readability.

Known issues:
- sparc32 is broken by this. I will address the
  sparc32 bits before I do any final submission.

All the link magic is moved to a shell script:

    scripts/link-vmlinux.sh

To do so a few varialbles had to be exported
form the top-level Makefile.

"um" has a local definition of the linker
macro. I found no better way than to hardcode this
in the script. It looks ugly - and alternatives are
welcome!

If you apply the patch you can use:

   make V=L  (capital L)

to debug the script.
The default is the non-verbose output.

My shell script foo is limited, so expect to
find something sub-optimal in the script.

	Sam

 b/Makefile                |  211 +---------------------------------------
 b/arch/um/Makefile        |   11 --
 b/scripts/link-vmlinux.sh |  238 ++++++++++++++++++++++++++++++++++++++++++++++
 scripts/mksysmap          |   45 --------
 4 files changed, 250 insertions(+), 255 deletions(-)

diff --git a/Makefile b/Makefile
index f6578f4..ca0b407 100644
--- a/Makefile
+++ b/Makefile
@@ -341,7 +341,6 @@ AWK		= awk
 GENKSYMS	= scripts/genksyms/genksyms
 INSTALLKERNEL  := installkernel
 DEPMOD		= /sbin/depmod
-KALLSYMS	= scripts/kallsyms
 PERL		= perl
 CHECK		= sparse
 
@@ -727,187 +726,16 @@ libs-y1		:= $(patsubst %/, %/lib.a, $(libs-y))
 libs-y2		:= $(patsubst %/, %/built-in.o, $(libs-y))
 libs-y		:= $(libs-y1) $(libs-y2)
 
-# Build vmlinux
-# ---------------------------------------------------------------------------
-# vmlinux is built from the objects selected by $(vmlinux-init) and
-# $(vmlinux-main). Most are built-in.o files from top-level directories
-# in the kernel tree, others are specified in arch/$(ARCH)/Makefile.
-# Ordering when linking is important, and $(vmlinux-init) must be first.
-#
-# vmlinux
-#   ^
-#   |
-#   +-< $(vmlinux-init)
-#   |   +--< init/version.o + more
-#   |
-#   +--< $(vmlinux-main)
-#   |    +--< driver/built-in.o mm/built-in.o + more
-#   |
-#   +-< kallsyms.o (see description in CONFIG_KALLSYMS section)
-#
-# vmlinux version (uname -v) cannot be updated during normal
-# descending-into-subdirs phase since we do not yet know if we need to
-# update vmlinux.
-# Therefore this step is delayed until just before final link of vmlinux -
-# except in the kallsyms case where it is done just before adding the
-# symbols to the kernel.
-#
-# System.map is generated to document addresses of all kernel symbols
-
-vmlinux-init := $(head-y) $(init-y)
-vmlinux-main := $(core-y) $(libs-y) $(drivers-y) $(net-y)
-vmlinux-all  := $(vmlinux-init) $(vmlinux-main)
-vmlinux-lds  := arch/$(SRCARCH)/kernel/vmlinux.lds
-export KBUILD_VMLINUX_OBJS := $(vmlinux-all)
-
-# Rule to link vmlinux - also used during CONFIG_KALLSYMS
-# May be overridden by arch/$(ARCH)/Makefile
-quiet_cmd_vmlinux__ ?= LD      $@
-      cmd_vmlinux__ ?= $(LD) $(LDFLAGS) $(LDFLAGS_vmlinux) -o $@ \
-      -T $(vmlinux-lds) $(vmlinux-init)                          \
-      --start-group $(vmlinux-main) --end-group                  \
-      $(filter-out $(vmlinux-lds) $(vmlinux-init) $(vmlinux-main) vmlinux.o FORCE ,$^)
-
-# Generate new vmlinux version
-quiet_cmd_vmlinux_version = GEN     .version
-      cmd_vmlinux_version = set -e;                     \
-	if [ ! -r .version ]; then			\
-	  rm -f .version;				\
-	  echo 1 >.version;				\
-	else						\
-	  mv .version .old_version;			\
-	  expr 0$$(cat .old_version) + 1 >.version;	\
-	fi;						\
-	$(MAKE) $(build)=init
-
-# Generate System.map
-quiet_cmd_sysmap = SYSMAP
-      cmd_sysmap = $(CONFIG_SHELL) $(srctree)/scripts/mksysmap
-
-# Link of vmlinux
-# If CONFIG_KALLSYMS is set .version is already updated
-# Generate System.map and verify that the content is consistent
-# Use + in front of the vmlinux_version rule to silent warning with make -j2
-# First command is ':' to allow us to use + in front of the rule
-define rule_vmlinux__
-	:
-	$(if $(CONFIG_KALLSYMS),,+$(call cmd,vmlinux_version))
-
-	$(call cmd,vmlinux__)
-	$(Q)echo 'cmd_$@ := $(cmd_vmlinux__)' > $(@D)/.$(@F).cmd
-
-	$(Q)$(if $($(quiet)cmd_sysmap),                                      \
-	  echo '  $($(quiet)cmd_sysmap)  System.map' &&)                     \
-	$(cmd_sysmap) $@ System.map;                                         \
-	if [ $$? -ne 0 ]; then                                               \
-		rm -f $@;                                                    \
-		/bin/false;                                                  \
-	fi;
-	$(verify_kallsyms)
-endef
-
-
-ifdef CONFIG_KALLSYMS
-# Generate section listing all symbols and add it into vmlinux $(kallsyms.o)
-# It's a three stage process:
-# o .tmp_vmlinux1 has all symbols and sections, but __kallsyms is
-#   empty
-#   Running kallsyms on that gives us .tmp_kallsyms1.o with
-#   the right size - vmlinux version (uname -v) is updated during this step
-# o .tmp_vmlinux2 now has a __kallsyms section of the right size,
-#   but due to the added section, some addresses have shifted.
-#   From here, we generate a correct .tmp_kallsyms2.o
-# o The correct .tmp_kallsyms2.o is linked into the final vmlinux.
-# o Verify that the System.map from vmlinux matches the map from
-#   .tmp_vmlinux2, just in case we did not generate kallsyms correctly.
-# o If 'make KALLSYMS_EXTRA_PASS=1" was used, do an extra pass using
-#   .tmp_vmlinux3 and .tmp_kallsyms3.o.  This is only meant as a
-#   temporary bypass to allow the kernel to be built while the
-#   maintainers work out what went wrong with kallsyms.
-
-last_kallsyms := 2
-
-ifdef KALLSYMS_EXTRA_PASS
-ifneq ($(KALLSYMS_EXTRA_PASS),0)
-last_kallsyms := 3
-endif
-endif
-
-kallsyms.o := .tmp_kallsyms$(last_kallsyms).o
-
-define verify_kallsyms
-	$(Q)$(if $($(quiet)cmd_sysmap),                                      \
-	  echo '  $($(quiet)cmd_sysmap)  .tmp_System.map' &&)                \
-	  $(cmd_sysmap) .tmp_vmlinux$(last_kallsyms) .tmp_System.map
-	$(Q)cmp -s System.map .tmp_System.map ||                             \
-		(echo Inconsistent kallsyms data;                            \
-		 echo This is a bug - please report about it;                \
-		 echo Try "make KALLSYMS_EXTRA_PASS=1" as a workaround;      \
-		 rm .tmp_kallsyms* ; /bin/false )
-endef
-
-# Update vmlinux version before link
-# Use + in front of this rule to silent warning about make -j1
-# First command is ':' to allow us to use + in front of this rule
-cmd_ksym_ld = $(cmd_vmlinux__)
-define rule_ksym_ld
-	: 
-	+$(call cmd,vmlinux_version)
-	$(call cmd,vmlinux__)
-	$(Q)echo 'cmd_$@ := $(cmd_vmlinux__)' > $(@D)/.$(@F).cmd
-endef
-
-# Generate .S file with all kernel symbols
-quiet_cmd_kallsyms = KSYM    $@
-      cmd_kallsyms = $(NM) -n $< | $(KALLSYMS) \
-                     $(if $(CONFIG_KALLSYMS_ALL),--all-symbols) > $@
-
-.tmp_kallsyms1.o .tmp_kallsyms2.o .tmp_kallsyms3.o: %.o: %.S scripts FORCE
-	$(call if_changed_dep,as_o_S)
+# used by link-vmlinux.sh
+export KBUILD_VMLINUX_INIT := $(head-y) $(init-y)
+export KBUILD_VMLINUX_MAIN := $(core-y) $(libs-y) $(drivers-y) $(net-y)
+export KBUILD_LDS          := arch/$(SRCARCH)/kernel/vmlinux.lds
+export LDFLAGS_vmlinux
 
-.tmp_kallsyms%.S: .tmp_vmlinux% $(KALLSYMS)
-	$(call cmd,kallsyms)
+vmlinux-deps := $(KBUILD_LDS) $(KBUILD_VMLINUX_INIT) $(KBUILD_VMLINUX_MAIN)
 
-# .tmp_vmlinux1 must be complete except kallsyms, so update vmlinux version
-.tmp_vmlinux1: $(vmlinux-lds) $(vmlinux-all) FORCE
-	$(call if_changed_rule,ksym_ld)
-
-.tmp_vmlinux2: $(vmlinux-lds) $(vmlinux-all) .tmp_kallsyms1.o FORCE
-	$(call if_changed,vmlinux__)
-
-.tmp_vmlinux3: $(vmlinux-lds) $(vmlinux-all) .tmp_kallsyms2.o FORCE
-	$(call if_changed,vmlinux__)
-
-# Needs to visit scripts/ before $(KALLSYMS) can be used.
-$(KALLSYMS): scripts ;
-
-# Generate some data for debugging strange kallsyms problems
-debug_kallsyms: .tmp_map$(last_kallsyms)
-
-.tmp_map%: .tmp_vmlinux% FORCE
-	($(OBJDUMP) -h $< | $(AWK) '/^ +[0-9]/{print $$4 " 0 " $$2}'; $(NM) $<) | sort > $@
-
-.tmp_map3: .tmp_map2
-
-.tmp_map2: .tmp_map1
-
-endif # ifdef CONFIG_KALLSYMS
-
-# Do modpost on a prelinked vmlinux. The finally linked vmlinux has
-# relevant sections renamed as per the linker script.
-quiet_cmd_vmlinux-modpost = LD      $@
-      cmd_vmlinux-modpost = $(LD) $(LDFLAGS) -r -o $@                          \
-	 $(vmlinux-init) --start-group $(vmlinux-main) --end-group             \
-	 $(filter-out $(vmlinux-init) $(vmlinux-main) FORCE ,$^)
-define rule_vmlinux-modpost
-	:
-	+$(call cmd,vmlinux-modpost)
-	$(Q)$(MAKE) -f $(srctree)/scripts/Makefile.modpost $@
-	$(Q)echo 'cmd_$@ := $(cmd_vmlinux-modpost)' > $(dot-target).cmd
-endef
-
-# vmlinux image - including updated kernel symbols
-vmlinux: $(vmlinux-lds) $(vmlinux-init) $(vmlinux-main) vmlinux.o $(kallsyms.o) FORCE
+# vmlinux image
+vmlinux: scripts/link-vmlinux.sh scripts/kallsyms $(vmlinux-deps)
 ifdef CONFIG_HEADERS_CHECK
 	$(Q)$(MAKE) -f $(srctree)/Makefile headers_check
 endif
@@ -917,22 +745,11 @@ endif
 ifdef CONFIG_BUILD_DOCSRC
 	$(Q)$(MAKE) $(build)=Documentation
 endif
-	$(call vmlinux-modpost)
-	$(call if_changed_rule,vmlinux__)
-	$(Q)rm -f .old_version
-
-# build vmlinux.o first to catch section mismatch errors early
-ifdef CONFIG_KALLSYMS
-.tmp_vmlinux1: vmlinux.o
-endif
-
-modpost-init := $(filter-out init/built-in.o, $(vmlinux-init))
-vmlinux.o: $(modpost-init) $(vmlinux-main) FORCE
-	$(call if_changed_rule,vmlinux-modpost)
+	$(Q)$(CONFIG_SHELL) $<
 
 # The actual objects are generated when descending, 
 # make sure no implicit rule kicks in
-$(sort $(vmlinux-init) $(vmlinux-main)) $(vmlinux-lds): $(vmlinux-dirs) ;
+$(sort $(vmlinux-deps)): $(vmlinux-dirs) ;
 
 # Handle descending into subdirectories listed in $(vmlinux-dirs)
 # Preset locale variables to speed up the build process. Limit locale
@@ -1536,14 +1353,6 @@ quiet_cmd_depmod = DEPMOD  $(KERNELRELEASE)
 cmd_crmodverdir = $(Q)mkdir -p $(MODVERDIR) \
                   $(if $(KBUILD_MODULES),; rm -f $(MODVERDIR)/*)
 
-a_flags = -Wp,-MD,$(depfile) $(KBUILD_AFLAGS) $(AFLAGS_KERNEL) \
-	  $(KBUILD_AFLAGS_KERNEL)                              \
-	  $(NOSTDINC_FLAGS) $(LINUXINCLUDE) $(KBUILD_CPPFLAGS) \
-	  $(modkern_aflags) $(EXTRA_AFLAGS) $(AFLAGS_$(basetarget).o)
-
-quiet_cmd_as_o_S = AS      $@
-cmd_as_o_S       = $(CC) $(a_flags) -c -o $@ $<
-
 # read all saved command lines
 
 targets := $(wildcard $(sort $(targets)))
diff --git a/arch/um/Makefile b/arch/um/Makefile
index 55c0661..6decba4 100644
--- a/arch/um/Makefile
+++ b/arch/um/Makefile
@@ -121,15 +121,8 @@ LINK_WRAPS = -Wl,--wrap,malloc -Wl,--wrap,free -Wl,--wrap,calloc
 
 LD_FLAGS_CMDLINE = $(foreach opt,$(LDFLAGS),-Wl,$(opt))
 
-CFLAGS_vmlinux := $(LINK-y) $(LINK_WRAPS) $(LD_FLAGS_CMDLINE)
-define cmd_vmlinux__
-	$(CC) $(CFLAGS_vmlinux) -o $@ \
-	-Wl,-T,$(vmlinux-lds) $(vmlinux-init) \
-	-Wl,--start-group $(vmlinux-main) -Wl,--end-group \
-	-lutil \
-	$(filter-out $(vmlinux-lds) $(vmlinux-init) $(vmlinux-main) vmlinux.o \
-	FORCE ,$^) ; rm -f linux
-endef
+# used by link-vmlinux.sh
+export CFLAGS_vmlinux := $(LINK-y) $(LINK_WRAPS) $(LD_FLAGS_CMDLINE)
 
 # When cleaning we don't include .config, so we don't include
 # TT or skas makefiles and don't clean skas_ptregs.h.
diff --git a/scripts/link-vmlinux.sh b/scripts/link-vmlinux.sh
new file mode 100644
index 0000000..c5a46ae
--- /dev/null
+++ b/scripts/link-vmlinux.sh
@@ -0,0 +1,238 @@
+#!/bin/sh
+#
+# link vmlinux
+#
+# vmlinux is linked from the objects selected by $(KBUILD_VMLINUX_INIT) and
+# $(KBUILD_VMLINUX_MAIN). Most are built-in.o files from top-level directories
+# in the kernel tree, others are specified in arch/$(ARCH)/Makefile.
+# Ordering when linking is important, and $(KBUILD_VMLINUX_INIT) must be first.
+#
+# vmlinux
+#   ^
+#   |
+#   +-< $(KBUILD_VMLINUX_INIT)
+#   |   +--< init/version.o + more
+#   |
+#   +--< $(KBUILD_VMLINUX_MAIN)
+#   |    +--< driver/built-in.o mm/built-in.o + more
+#   |
+#   +-< ${kallsymso} (see description in KALLSYMS section)
+#
+# vmlinux version (uname -v) cannot be updated during normal
+# descending-into-subdirs phase since we do not yet know if we need to
+# update vmlinux.
+# Therefore this step is delayed until just before final link of vmlinux.
+#
+# System.map is generated to document addresses of all kernel symbols
+
+# We need access to CONFIG_ symbols
+source ./.config
+
+# Error out on error
+set -e
+
+# Link of vmlinux
+# $1 output file
+modpost_link()
+{
+	${LD} ${LDFLAGS} -r -o $1 ${KBUILD_VMLINUX_INIT}                     \
+		--start-group ${KBUILD_VMLINUX_MAIN} --end-group
+}
+
+# Link of vmlinux
+# $1 - optional extra .o files
+# $2 output file
+vmlinux_link()
+{
+	local lds=${srctree}/arch/${SRCARCH}/kernel/vmlinux.lds
+echo srcarch=${SRCARCH} CF=${CFLAGS_vmlinux}
+	if [ "${SRCARCH}" != "um" ]; then 
+		${LD} ${LDFLAGS} ${LDFLAGS_vmlinux} -o $2                    \
+			-T ${lds} ${KBUILD_VMLINUX_INIT}                     \
+			--start-group ${KBUILD_VMLINUX_MAIN} --end-group $1
+	else
+		${CC} ${CFLAGS_vmlinux} -o $2                                \
+			-Wl,-T,${lds} ${KBUILD_VMLINUX_INIT}                 \
+			-Wl,--start-group                                    \
+				 ${KBUILD_VMLINUX_MAIN}                      \
+			-Wl,--end-group                                      \
+			-lutil $1
+		rm -f linux
+	fi
+}
+
+
+# Create $2 .o file with all symbols from $1 .o file
+kallsyms()
+{
+	info KSYM $2
+	local kallsymopt;
+
+	if [ "${CONFIG_KALLSYMS_ALL}" != "" ]; then
+		kallsymopt=--all-symbols
+	fi
+
+	local aflags="${KBUILD_AFLAGS} ${AFLAGS_KERNEL} ${NOSTDINC_FLAGS} ${LINUXINCLUDE} ${KBUILD_CPPFLAGS} ${modkern_aflags}"
+	${NM} -n $1 | \
+		scripts/kallsyms ${kallsymopt} | \
+ 		${CC} ${aflags} -c -o $2 -x assembler-with-cpp -
+}
+
+# Based on the vmlinux file create the System.map file
+# System.map is used by module-init tools and some debugging
+# tools to retrieve the actual addresses of symbols in the kernel.
+# Generate System.map (actual filename passed as second argument)
+
+# $NM produces the following output:
+# f0081e80 T alloc_vfsmnt
+
+#   The second row specify the type of the symbol:
+#   A = Absolute
+#   B = Uninitialised data (.bss)
+#   C = Comon symbol
+#   D = Initialised data
+#   G = Initialised data for small objects
+#   I = Indirect reference to another symbol
+#   N = Debugging symbol
+#   R = Read only
+#   S = Uninitialised data for small objects
+#   T = Text code symbol
+#   U = Undefined symbol
+#   V = Weak symbol
+#   W = Weak symbol
+#   Corresponding small letters are local symbols
+
+# For System.map filter away:
+#   a - local absolute symbols
+#   U - undefined global symbols
+#   N - debugging symbols
+#   w - local weak symbols
+
+# readprofile starts reading symbols when _stext is found, and
+# continue until it finds a symbol which is not either of 'T', 't',
+# 'W' or 'w'. __crc_ are 'A' and placed in the middle
+# so we just ignore them to let readprofile continue to work.
+# (At least sparc64 has __crc_ in the middle).
+mksysmap()
+{
+	$NM -n $1 | \
+		grep -v '\( [aNUw] \)\|\(__crc_\)\|\( \$[adt]\)' > $2
+}
+
+
+# Delete output files in case of error
+trap cleanup SIGHUP SIGINT SIGQUIT SIGTERM ERR
+cleanup()
+{
+	rm -f vmlinux.o
+	rm -f .old_version
+	rm -f .tmp_vmlinux*
+	rm -f .tmp_kallsyms*
+	rm -f vmlinux
+	rm -f .tmp_System.map
+	rm -f System.map
+}
+
+# non-verbose output
+info()
+{
+	printf "  %-7s %s\n" $1 $2
+}
+
+# Use "make V=L" to debug this script
+case "${KBUILD_VERBOSE}" in
+*L*)
+	set -x
+	;;
+esac
+
+# Override MAKEFLAGS to avoid parrallel builds
+MAKEFLAGS='--no-print-directory -Rr'
+
+#link vmlinux.o
+info LD vmlinux.o
+modpost_link vmlinux.o
+
+# modpost vmlinux.o to check for section mismatches
+${MAKE} -f ${srctree}/scripts/Makefile.modpost vmlinux.o
+
+# Update version
+info GEN .version
+if [ ! -r .version ]; then
+	rm -f .version;
+	echo 1 >.version;
+else
+	mv .version .old_version;
+	expr 0$(cat .old_version) + 1 >.version;
+fi;
+
+# final build of init/
+${MAKE} -f ${srctree}/scripts/Makefile.build obj=init
+
+
+kallsymso=""
+kallsyms_vmlinux=""
+
+if [ "${CONFIG_KALLSYMS}" != "" ]; then
+
+	# kallsyms support
+	# Generate section listing all symbols and add it into vmlinux
+	# It's a three step process:
+	# 1)  Link .tmp_vmlinux1 so it has all symbols and sections,
+	#     but __kallsyms is empty.
+	#     Running kallsyms on that gives us .tmp_kallsyms1.o with
+	#     the right size
+	# 2)  Link .tmp_vmlinux2 so it now has a __kallsyms section of
+	#     the right size, but due to the added section, some
+	#     addresses have shifted.
+	#     From here, we generate a correct .tmp_kallsyms2.o
+	# 2a) We may use an extra pass as this has been necessary to
+	#     woraround some alignment related bugs.
+	#     KALLSYMS_EXTRA_PASS=1 is used to trigger this.
+	# 3)  The correct ${kallsymso} is linked into the final vmlinux.
+	#
+	# a)  Verify that the System.map from vmlinux matches the map from
+	#     ${kallsymso}.
+
+	kallsymso=.tmp_kallsyms2.o
+	kallsyms_vmlinux=.tmp_vmlinux2
+
+	# step 1
+	vmlinux_link "" .tmp_vmlinux1
+	kallsyms .tmp_vmlinux1 .tmp_kallsyms1.o
+
+	# step 2
+	vmlinux_link .tmp_kallsyms1.o .tmp_vmlinux2
+	kallsyms .tmp_vmlinux2 .tmp_kallsyms2.o
+
+	# step 2a
+	if [ "${KALLSYMS_EXTRA_PASS}" != "" ]; then
+		kallsymso=.tmp_kallsyms3.o
+		kallsyms_vmlinux=.tmp_vmlinux2
+
+		vmlinux_link .tmp_kallsyms2.o .tmp_vmlinux3
+
+		kallsyms .tmp_vmlinux3 .tmp_kallsyms3.o
+	fi
+fi
+
+vmlinux_link "${kallsymso}" vmlinux
+
+info SYSMAP System.map
+mksysmap vmlinux System.map
+
+# step a (see comment above)
+if [ "${CONFIG_KALLSYMS}" != "" ]; then
+	mksysmap ${kallsyms_vmlinux} .tmp_System.map
+
+	if [ $(cmp -s System.map .tmp_System.map) ]; then
+		echo Inconsistent kallsyms data
+		echo This is a bug - please report about it
+		echo echo Try "make KALLSYMS_EXTRA_PASS=1" as a workaround
+		cleanup
+		exit 1
+	fi
+fi
+
+# We made a new kernel - delete old version file
+rm -f .old_version
diff --git a/scripts/mksysmap b/scripts/mksysmap
deleted file mode 100644
index 6e133a0..0000000
--- a/scripts/mksysmap
+++ /dev/null
@@ -1,45 +0,0 @@
-#!/bin/sh -x
-# Based on the vmlinux file create the System.map file
-# System.map is used by module-init tools and some debugging
-# tools to retrieve the actual addresses of symbols in the kernel.
-#
-# Usage
-# mksysmap vmlinux System.map
-
-
-#####
-# Generate System.map (actual filename passed as second argument)
-
-# $NM produces the following output:
-# f0081e80 T alloc_vfsmnt
-
-#   The second row specify the type of the symbol:
-#   A = Absolute
-#   B = Uninitialised data (.bss)
-#   C = Comon symbol
-#   D = Initialised data
-#   G = Initialised data for small objects
-#   I = Indirect reference to another symbol
-#   N = Debugging symbol
-#   R = Read only
-#   S = Uninitialised data for small objects
-#   T = Text code symbol
-#   U = Undefined symbol
-#   V = Weak symbol
-#   W = Weak symbol
-#   Corresponding small letters are local symbols
-
-# For System.map filter away:
-#   a - local absolute symbols
-#   U - undefined global symbols
-#   N - debugging symbols
-#   w - local weak symbols
-
-# readprofile starts reading symbols when _stext is found, and
-# continue until it finds a symbol which is not either of 'T', 't',
-# 'W' or 'w'. __crc_ are 'A' and placed in the middle
-# so we just ignore them to let readprofile continue to work.
-# (At least sparc64 has __crc_ in the middle).
-
-$NM -n $1 | grep -v '\( [aNUw] \)\|\(__crc_\)\|\( \$[adt]\)' > $2
-
