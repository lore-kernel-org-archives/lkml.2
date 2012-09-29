Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964836Ab2I2NM5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Sep 2012 09:12:57 -0400
Received: from cantor2.suse.de ([195.135.220.15]:50021 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754241Ab2I2NMz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Sep 2012 09:12:55 -0400
Subject: [PATCH v2] kbuild: Fix gcc -x syntax
From: Jean Delvare <jdelvare@suse.de>
To: linux-kernel@vger.kernel.org
Cc: x86@kernel.org, Bernhard Walle <bernhard@bwalle.de>,
        Michal Marek <mmarek@suse.cz>, Ralf Baechle <ralf@linux-mips.org>
Content-Type: text/plain; charset="UTF-8"
Organization: Suse Linux
Date: Sat, 29 Sep 2012 15:13:28 +0200
Message-ID: <1348924408.6962.2.camel@amber.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The correct syntax for gcc -x is "gcc -x assembler", not
"gcc -xassembler". Even though the latter happens to work, the former
is what is documented in the manual page and thus what gcc wrappers
such as icecream do expect.

This isn't a cosmetic change. The missing space prevents icecream from
recognizing compilation tasks it can't handle, leading to silent kernel
miscompilations.

Besides me, credits go to Richard Guenther and Dirk Mueller for
investigating the miscompilation issue and tracking it down to this
incorrect -x parameter syntax.

Signed-off-by: Jean Delvare <jdelvare@suse.de>
Cc: stable@vger.kernel.org
Cc: Bernhard Walle <bernhard@bwalle.de>
Cc: Michal Marek <mmarek@suse.cz>
Cc: Ralf Baechle <ralf@linux-mips.org>
---
Changes since v1:
 * Found more occurrences of the same. These are probably less
   problematic in practice but let's fix them all still.

 arch/mips/Makefile                         |    2 +-
 arch/mips/kernel/Makefile                  |    2 +-
 arch/x86/Makefile                          |    2 +-
 scripts/Kbuild.include                     |   12 ++++++------
 scripts/gcc-version.sh                     |    6 +++---
 scripts/gcc-x86_32-has-stack-protector.sh  |    2 +-
 scripts/gcc-x86_64-has-stack-protector.sh  |    2 +-
 scripts/kconfig/check.sh                   |    2 +-
 scripts/kconfig/lxdialog/check-lxdialog.sh |    2 +-
 tools/perf/Makefile                        |    2 +-
 tools/power/cpupower/Makefile              |    2 +-
 11 files changed, 18 insertions(+), 18 deletions(-)

--- linux-3.6-rc7.orig/arch/mips/Makefile	2012-09-29 09:25:39.906995722 +0200
+++ linux-3.6-rc7/arch/mips/Makefile	2012-09-29 14:30:22.541600872 +0200
@@ -225,7 +225,7 @@ KBUILD_CPPFLAGS += -DDATAOFFSET=$(if $(d
 LDFLAGS			+= -m $(ld-emul)
 
 ifdef CONFIG_MIPS
-CHECKFLAGS += $(shell $(CC) $(KBUILD_CFLAGS) -dM -E -xc /dev/null | \
+CHECKFLAGS += $(shell $(CC) $(KBUILD_CFLAGS) -dM -E -x c /dev/null | \
 	egrep -vw '__GNUC_(|MINOR_|PATCHLEVEL_)_' | \
 	sed -e "s/^\#define /-D'/" -e "s/ /'='/" -e "s/$$/'/")
 ifdef CONFIG_64BIT
--- linux-3.6-rc7.orig/arch/mips/kernel/Makefile	2012-09-29 09:25:39.906995722 +0200
+++ linux-3.6-rc7/arch/mips/kernel/Makefile	2012-09-29 14:30:22.542600873 +0200
@@ -104,7 +104,7 @@ obj-$(CONFIG_MIPS_MACHINE)	+= mips_machi
 
 obj-$(CONFIG_OF)		+= prom.o
 
-CFLAGS_cpu-bugs64.o	= $(shell if $(CC) $(KBUILD_CFLAGS) -Wa,-mdaddi -c -o /dev/null -xc /dev/null >/dev/null 2>&1; then echo "-DHAVE_AS_SET_DADDI"; fi)
+CFLAGS_cpu-bugs64.o	= $(shell if $(CC) $(KBUILD_CFLAGS) -Wa,-mdaddi -c -o /dev/null -x c /dev/null >/dev/null 2>&1; then echo "-DHAVE_AS_SET_DADDI"; fi)
 
 obj-$(CONFIG_HAVE_STD_PC_SERIAL_PORT)	+= 8250-platform.o
 
--- linux-3.6-rc7.orig/arch/x86/Makefile	2012-09-29 09:25:39.907995723 +0200
+++ linux-3.6-rc7/arch/x86/Makefile	2012-09-29 14:30:22.542600873 +0200
@@ -92,7 +92,7 @@ endif
 ifdef CONFIG_X86_X32
 	x32_ld_ok := $(call try-run,\
 			/bin/echo -e '1: .quad 1b' | \
-			$(CC) $(KBUILD_AFLAGS) -c -xassembler -o "$$TMP" - && \
+			$(CC) $(KBUILD_AFLAGS) -c -x assembler -o "$$TMP" - && \
 			$(OBJCOPY) -O elf32-x86-64 "$$TMP" "$$TMPO" && \
 			$(LD) -m elf32_x86_64 "$$TMPO" -o "$$TMP",y,n)
         ifeq ($(x32_ld_ok),y)
--- linux-3.6-rc7.orig/scripts/Kbuild.include	2012-09-29 09:25:39.906995722 +0200
+++ linux-3.6-rc7/scripts/Kbuild.include	2012-09-29 14:30:22.543600874 +0200
@@ -98,24 +98,24 @@ try-run = $(shell set -e;		\
 # Usage: cflags-y += $(call as-option,-Wa$(comma)-isa=foo,)
 
 as-option = $(call try-run,\
-	$(CC) $(KBUILD_CFLAGS) $(1) -c -xassembler /dev/null -o "$$TMP",$(1),$(2))
+	$(CC) $(KBUILD_CFLAGS) $(1) -c -x assembler /dev/null -o "$$TMP",$(1),$(2))
 
 # as-instr
 # Usage: cflags-y += $(call as-instr,instr,option1,option2)
 
 as-instr = $(call try-run,\
-	printf "%b\n" "$(1)" | $(CC) $(KBUILD_AFLAGS) -c -xassembler -o "$$TMP" -,$(2),$(3))
+	printf "%b\n" "$(1)" | $(CC) $(KBUILD_AFLAGS) -c -x assembler -o "$$TMP" -,$(2),$(3))
 
 # cc-option
 # Usage: cflags-y += $(call cc-option,-march=winchip-c6,-march=i586)
 
 cc-option = $(call try-run,\
-	$(CC) $(KBUILD_CPPFLAGS) $(KBUILD_CFLAGS) $(1) -c -xc /dev/null -o "$$TMP",$(1),$(2))
+	$(CC) $(KBUILD_CPPFLAGS) $(KBUILD_CFLAGS) $(1) -c -x c /dev/null -o "$$TMP",$(1),$(2))
 
 # cc-option-yn
 # Usage: flag := $(call cc-option-yn,-march=winchip-c6)
 cc-option-yn = $(call try-run,\
-	$(CC) $(KBUILD_CPPFLAGS) $(KBUILD_CFLAGS) $(1) -c -xc /dev/null -o "$$TMP",y,n)
+	$(CC) $(KBUILD_CPPFLAGS) $(KBUILD_CFLAGS) $(1) -c -x c /dev/null -o "$$TMP",y,n)
 
 # cc-option-align
 # Prefix align with either -falign or -malign
@@ -125,7 +125,7 @@ cc-option-align = $(subst -functions=0,,
 # cc-disable-warning
 # Usage: cflags-y += $(call cc-disable-warning,unused-but-set-variable)
 cc-disable-warning = $(call try-run,\
-	$(CC) $(KBUILD_CPPFLAGS) $(KBUILD_CFLAGS) -W$(strip $(1)) -c -xc /dev/null -o "$$TMP",-Wno-$(strip $(1)))
+	$(CC) $(KBUILD_CPPFLAGS) $(KBUILD_CFLAGS) -W$(strip $(1)) -c -x c /dev/null -o "$$TMP",-Wno-$(strip $(1)))
 
 # cc-version
 # Usage gcc-ver := $(call cc-version)
@@ -143,7 +143,7 @@ cc-ifversion = $(shell [ $(call cc-versi
 # cc-ldoption
 # Usage: ldflags += $(call cc-ldoption, -Wl$(comma)--hash-style=both)
 cc-ldoption = $(call try-run,\
-	$(CC) $(1) -nostdlib -xc /dev/null -o "$$TMP",$(1),$(2))
+	$(CC) $(1) -nostdlib -x c /dev/null -o "$$TMP",$(1),$(2))
 
 # ld-option
 # Usage: LDFLAGS += $(call ld-option, -X)
--- linux-3.6-rc7.orig/scripts/gcc-version.sh	2012-09-29 14:51:40.429574745 +0200
+++ linux-3.6-rc7/scripts/gcc-version.sh	2012-09-29 14:51:48.507577172 +0200
@@ -22,10 +22,10 @@ if [ ${#compiler} -eq 0 ]; then
 	exit 1
 fi
 
-MAJOR=$(echo __GNUC__ | $compiler -E -xc - | tail -n 1)
-MINOR=$(echo __GNUC_MINOR__ | $compiler -E -xc - | tail -n 1)
+MAJOR=$(echo __GNUC__ | $compiler -E -x c - | tail -n 1)
+MINOR=$(echo __GNUC_MINOR__ | $compiler -E -x c - | tail -n 1)
 if [ "x$with_patchlevel" != "x" ] ; then
-	PATCHLEVEL=$(echo __GNUC_PATCHLEVEL__ | $compiler -E -xc - | tail -n 1)
+	PATCHLEVEL=$(echo __GNUC_PATCHLEVEL__ | $compiler -E -x c - | tail -n 1)
 	printf "%02d%02d%02d\\n" $MAJOR $MINOR $PATCHLEVEL
 else
 	printf "%02d%02d\\n" $MAJOR $MINOR
--- linux-3.6-rc7.orig/scripts/gcc-x86_32-has-stack-protector.sh	2012-09-29 14:51:40.429574745 +0200
+++ linux-3.6-rc7/scripts/gcc-x86_32-has-stack-protector.sh	2012-09-29 14:51:48.508577173 +0200
@@ -1,6 +1,6 @@
 #!/bin/sh
 
-echo "int foo(void) { char X[200]; return 3; }" | $* -S -xc -c -O0 -fstack-protector - -o - 2> /dev/null | grep -q "%gs"
+echo "int foo(void) { char X[200]; return 3; }" | $* -S -x c -c -O0 -fstack-protector - -o - 2> /dev/null | grep -q "%gs"
 if [ "$?" -eq "0" ] ; then
 	echo y
 else
--- linux-3.6-rc7.orig/scripts/gcc-x86_64-has-stack-protector.sh	2012-09-29 14:51:40.429574745 +0200
+++ linux-3.6-rc7/scripts/gcc-x86_64-has-stack-protector.sh	2012-09-29 14:51:48.508577173 +0200
@@ -1,6 +1,6 @@
 #!/bin/sh
 
-echo "int foo(void) { char X[200]; return 3; }" | $* -S -xc -c -O0 -mcmodel=kernel -fstack-protector - -o - 2> /dev/null | grep -q "%gs"
+echo "int foo(void) { char X[200]; return 3; }" | $* -S -x c -c -O0 -mcmodel=kernel -fstack-protector - -o - 2> /dev/null | grep -q "%gs"
 if [ "$?" -eq "0" ] ; then
 	echo y
 else
--- linux-3.6-rc7.orig/scripts/kconfig/check.sh	2012-09-29 14:51:40.430574747 +0200
+++ linux-3.6-rc7/scripts/kconfig/check.sh	2012-09-29 14:51:48.508577173 +0200
@@ -1,6 +1,6 @@
 #!/bin/sh
 # Needed for systems without gettext
-$* -xc -o /dev/null - > /dev/null 2>&1 << EOF
+$* -x c -o /dev/null - > /dev/null 2>&1 << EOF
 #include <libintl.h>
 int main()
 {
--- linux-3.6-rc7.orig/scripts/kconfig/lxdialog/check-lxdialog.sh	2012-09-29 14:51:40.430574747 +0200
+++ linux-3.6-rc7/scripts/kconfig/lxdialog/check-lxdialog.sh	2012-09-29 14:51:48.508577173 +0200
@@ -38,7 +38,7 @@ trap "rm -f $tmp" 0 1 2 3 15
 
 # Check if we can link to ncurses
 check() {
-        $cc -xc - -o $tmp 2>/dev/null <<'EOF'
+        $cc -x c - -o $tmp 2>/dev/null <<'EOF'
 #include CURSES_LOC
 main() {}
 EOF
--- linux-3.6-rc7.orig/tools/perf/Makefile	2012-09-29 14:51:40.430574747 +0200
+++ linux-3.6-rc7/tools/perf/Makefile	2012-09-29 14:51:48.509577174 +0200
@@ -62,7 +62,7 @@ ifeq ($(ARCH),x86_64)
 	ARCH := x86
 	IS_X86_64 := 0
 	ifeq (, $(findstring m32,$(EXTRA_CFLAGS)))
-		IS_X86_64 := $(shell echo __x86_64__ | ${CC} -E -xc - | tail -n 1)
+		IS_X86_64 := $(shell echo __x86_64__ | ${CC} -E -x c - | tail -n 1)
 	endif
 	ifeq (${IS_X86_64}, 1)
 		RAW_ARCH := x86_64
--- linux-3.6-rc7.orig/tools/power/cpupower/Makefile	2012-09-29 09:25:39.907995723 +0200
+++ linux-3.6-rc7/tools/power/cpupower/Makefile	2012-09-29 14:30:22.547600878 +0200
@@ -111,7 +111,7 @@ GMO_FILES = ${shell for HLANG in ${LANGU
 export CROSS CC AR STRIP RANLIB CFLAGS LDFLAGS LIB_OBJS
 
 # check if compiler option is supported
-cc-supports = ${shell if $(CC) ${1} -S -o /dev/null -xc /dev/null > /dev/null 2>&1; then echo "$(1)"; fi;}
+cc-supports = ${shell if $(CC) ${1} -S -o /dev/null -x c /dev/null > /dev/null 2>&1; then echo "$(1)"; fi;}
 
 # use '-Os' optimization if available, else use -O2
 OPTIMIZATION := $(call cc-supports,-Os,-O2)

-- 
Jean Delvare
Suse L3

