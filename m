Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753460Ab1GBBs0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jul 2011 21:48:26 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:42485 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753126Ab1GBBsA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jul 2011 21:48:00 -0400
From: Arnaud Lacombe <lacombar@gmail.com>
To: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
        Michal Marek <mmarek@suse.cz>
Cc: Arnaud Lacombe <lacombar@gmail.com>
Subject: [RFC 6/7] kconfig: move ncurses checks to `scripts/kconfig/check.sh'
Date: Fri,  1 Jul 2011 21:47:38 -0400
Message-Id: <1309571259-15241-7-git-send-email-lacombar@gmail.com>
X-Mailer: git-send-email 1.7.3.4.574.g608b.dirty
In-Reply-To: <1309571259-15241-1-git-send-email-lacombar@gmail.com>
References: <1307387767-9237-1-git-send-email-lacombar@gmail.com>
 <1309571259-15241-1-git-send-email-lacombar@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

---
 scripts/kconfig/Makefile                   |   24 +-------
 scripts/kconfig/check.sh                   |   50 ++++++++++++++++
 scripts/kconfig/lxdialog/check-lxdialog.sh |   84 ----------------------------
 3 files changed, 54 insertions(+), 104 deletions(-)

diff --git a/scripts/kconfig/Makefile b/scripts/kconfig/Makefile
index 5021817..4e934f1 100644
--- a/scripts/kconfig/Makefile
+++ b/scripts/kconfig/Makefile
@@ -141,14 +141,6 @@ help:
 	@echo  '  listnewconfig   - List new options'
 	@echo  '  oldnoconfig     - Same as silentoldconfig but set new symbols to n (unset)'
 
-# lxdialog stuff
-check-lxdialog  := $(srctree)/$(src)/lxdialog/check-lxdialog.sh
-
-# Use recursively expanded variables so we do not call gcc unless
-# we really need to do so. (Do not call gcc as part of make mrproper)
-HOST_EXTRACFLAGS += $(shell $(CONFIG_SHELL) $(check-lxdialog) -ccflags) \
-                    -DLOCALE
-
 # ===========================================================================
 # Shared Makefile for the various kconfig executables:
 # conf:	  Used for defconfig, oldconfig and related targets
@@ -184,10 +176,12 @@ KC_CHECK := gettext
 
 ifeq ($(MAKECMDGOALS),nconfig)
 	hostprogs-y += nconf
+	KC_CHECK += ncurses
 endif
 
 ifeq ($(MAKECMDGOALS),menuconfig)
 	hostprogs-y += mconf
+	KC_CHECK += ncurses
 endif
 
 ifeq ($(MAKECMDGOALS),update-po-config)
@@ -211,26 +205,16 @@ clean-files	+= zconf.tab.c lex.zconf.c zconf.hash.c gconf.glade.h
 clean-files     += mconf qconf gconf nconf
 clean-files     += config.pot linux.pot
 
-# Check that we have the required ncurses stuff installed for lxdialog (menuconfig)
-PHONY += $(obj)/dochecklxdialog
-$(addprefix $(obj)/,$(lxdialog)): $(obj)/dochecklxdialog
-$(obj)/dochecklxdialog:
-	$(Q)$(CONFIG_SHELL) $(check-lxdialog) -check $(HOSTCC) $(HOST_EXTRACFLAGS) $(HOSTLOADLIBES_mconf)
-
-always := dochecklxdialog
-
 # generated files seem to need this to find local include files
 HOSTCFLAGS_lex.zconf.o	:= -I$(src)
 HOSTCFLAGS_zconf.tab.o	:= -I$(src)
 
 HOSTCFLAGS_gconf.o	= -Wno-missing-prototypes
 
-HOSTLOADLIBES_mconf   = $(shell $(CONFIG_SHELL) $(check-lxdialog) -ldflags $(HOSTCC))
-
-HOSTLOADLIBES_nconf	= -lmenu -lpanel -lncurses
-
+HOSTLOADLIBES_nconf	= -lmenu -lpanel
 
 need-check := $(addprefix $(obj)/,$(frontends-objs))
+need-check += $(addprefix $(obj)/,$(lxdialog))
 
 $(need-check): $(obj)/.tmp_check
 
diff --git a/scripts/kconfig/check.sh b/scripts/kconfig/check.sh
index 4456d63..ec551b7 100755
--- a/scripts/kconfig/check.sh
+++ b/scripts/kconfig/check.sh
@@ -47,6 +47,55 @@ check_gtk()
 	echo "HOSTLOADLIBES_gconf	+= $libs"   >> ${obj}/.tmp_check
 }
 
+check_ncurses()
+{
+	local cflags=""
+	local libs=""
+
+	ncurses_h="ncursesw/curses.h ncurses/ncurses.h ncurses/curses.h"
+	ncurses_h="${ncurses_h} ncurses.h curses.h"
+
+	for header in ${ncurses_h}; do
+		if echo "#include <${header}>" | \
+		    $HOSTCC -xc -E -c -o /dev/null - 2> /dev/null; then
+			cflags="-DCURSES_LOC=\"<$header>\""
+			break
+		fi
+	done
+
+	if [ -z "$cflags" ]; then
+		echo "  *"
+		echo "  * Unable to find the required ncurses header files."
+		echo "  * "
+		echo "  * Please install ncurses (ncurses-devel) and try again."
+		echo "  *"
+		false
+	fi
+
+	for ext in so a dylib ; do
+		for lib in ncursesw ncurses curses; do
+			filename="$($HOSTCC -print-file-name=lib${lib}.${ext})"
+			if [ "$filename" != "lib${lib}.${ext}" ]; then
+				libs=-l$lib
+				break
+			fi
+		done
+		[ -n "$libs" ] && break
+	done
+
+	if [ -z "$libs" ]; then
+		echo "  * Unable to find the required ncurses library."
+		echo "  *"
+		echo "  * Please install ncurses (ncurses-devel) and try again."
+		echo "  * "
+		false
+	fi
+
+	echo "HOSTCFLAGS	+=$cflags" >> ${obj}/.tmp_check
+	echo "HOSTLOADLIBES_mconf	+= $libs"   >> ${obj}/.tmp_check
+	echo "HOSTLOADLIBES_nconf	+= $libs"   >> ${obj}/.tmp_check
+}
+
 check_qt()
 {
 	local cflags=""
@@ -114,6 +163,7 @@ for arg in $*; do
 	case $arg in
 	gettext)	;;
 	gtk)		;;
+	ncurses)	;;
 	qt)		;;
 	*)
 		echo "  *"
diff --git a/scripts/kconfig/lxdialog/check-lxdialog.sh b/scripts/kconfig/lxdialog/check-lxdialog.sh
index 82cc3a8..e69de29 100644
--- a/scripts/kconfig/lxdialog/check-lxdialog.sh
+++ b/scripts/kconfig/lxdialog/check-lxdialog.sh
@@ -1,84 +0,0 @@
-#!/bin/sh
-# Check ncurses compatibility
-
-# What library to link
-ldflags()
-{
-	for ext in so a dylib ; do
-		for lib in ncursesw ncurses curses ; do
-			$cc -print-file-name=lib${lib}.${ext} | grep -q /
-			if [ $? -eq 0 ]; then
-				echo "-l${lib}"
-				exit
-			fi
-		done
-	done
-	exit 1
-}
-
-# Where is ncurses.h?
-ccflags()
-{
-	if [ -f /usr/include/ncurses/ncurses.h ]; then
-		echo '-I/usr/include/ncurses -DCURSES_LOC="<ncurses.h>"'
-	elif [ -f /usr/include/ncurses/curses.h ]; then
-		echo '-I/usr/include/ncurses -DCURSES_LOC="<ncurses/curses.h>"'
-	elif [ -f /usr/include/ncursesw/curses.h ]; then
-		echo '-I/usr/include/ncursesw -DCURSES_LOC="<ncursesw/curses.h>"'
-	elif [ -f /usr/include/ncurses.h ]; then
-		echo '-DCURSES_LOC="<ncurses.h>"'
-	else
-		echo '-DCURSES_LOC="<curses.h>"'
-	fi
-}
-
-# Temp file, try to clean up after us
-tmp=.lxdialog.tmp
-trap "rm -f $tmp" 0 1 2 3 15
-
-# Check if we can link to ncurses
-check() {
-        $cc -xc - -o $tmp 2>/dev/null <<'EOF'
-#include CURSES_LOC
-main() {}
-EOF
-	if [ $? != 0 ]; then
-	    echo " *** Unable to find the ncurses libraries or the"       1>&2
-	    echo " *** required header files."                            1>&2
-	    echo " *** 'make menuconfig' requires the ncurses libraries." 1>&2
-	    echo " *** "                                                  1>&2
-	    echo " *** Install ncurses (ncurses-devel) and try again."    1>&2
-	    echo " *** "                                                  1>&2
-	    exit 1
-	fi
-}
-
-usage() {
-	printf "Usage: $0 [-check compiler options|-ccflags|-ldflags compiler options]\n"
-}
-
-if [ $# -eq 0 ]; then
-	usage
-	exit 1
-fi
-
-cc=""
-case "$1" in
-	"-check")
-		shift
-		cc="$@"
-		check
-		;;
-	"-ccflags")
-		ccflags
-		;;
-	"-ldflags")
-		shift
-		cc="$@"
-		ldflags
-		;;
-	"*")
-		usage
-		exit 1
-		;;
-esac
-- 
1.7.3.4.574.g608b.dirty

