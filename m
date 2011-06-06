Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757763Ab1FFTQS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 15:16:18 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:37514 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757684Ab1FFTQO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 15:16:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=O+uOeiO5IVDFS9X1mtK/A5+rewc2l/MN078I+eeThJMmF/ugREC3k+GQWNp3wWE5RF
         TIzaUTLMsWedz9rHLS9nPk/RXBLFFmFBTDgtcmSj7g6KcaTSEcB6gXwus6p2RPxWIx4L
         h3VpNNhmVsMaMBtaq2Prsla/jEO7CH/pJU7zo=
From: Arnaud Lacombe <lacombar@gmail.com>
To: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Michal Marek <mmarek@suse.cz>, Arnaud Lacombe <lacombar@gmail.com>,
        Sam Ravnborg <sam@ravnborg.org>
Subject: [RFC] Kconfig library check merge
Date: Mon,  6 Jun 2011 15:16:07 -0400
Message-Id: <1307387767-9237-1-git-send-email-lacombar@gmail.com>
X-Mailer: git-send-email 1.7.3.4.574.g608b.dirty
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Michal, Sam,

This is a bit a more deep patch. I was fed up of seeing the various library
check done for kconfig in at least 3 places in the scripts/kconfig/ tree. In
particular, the QT and GTK checks are far too messy to be in a Makefile, while
the gettext is pretty trivial and has its own shell script... Moreover, `nconf'
is missing explicit check for ncurses.

Anyway, here it is. It is a single huge patch _on_purpose_, merely meant to be a
proof of concept. It is based on the previous serie of trivial fixes.

Most of the changes are made to rationalize the architecture. I thought in the
beginning of using autoconf/automake, but that'd be overkill. A single shell
script is far enough to do the job. All the checks only do a bunch of
verification, and export CFLAGS/LDFLAGS for building the frontend. The script
itself output a Makefile ready to be included for the top-level Makefile, with
the necessary check to trigger a re-check if the requested front-end is changed.

Comments welcome!

Regards,
 - Arnaud

Cc: Sam Ravnborg <sam@ravnborg.org>

---
 scripts/kconfig/Makefile                   |  160 +++++++------------------
 scripts/kconfig/check.sh                   |  184 ++++++++++++++++++++++++++--
 scripts/kconfig/lxdialog/check-lxdialog.sh |   84 -------------
 3 files changed, 216 insertions(+), 212 deletions(-)

diff --git a/scripts/kconfig/Makefile b/scripts/kconfig/Makefile
index 84abb2f..f8f853d 100644
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
@@ -173,14 +165,19 @@ qconf-cxxobjs	:= qconf.o
 qconf-objs	:= zconf.tab.o
 gconf-objs	:= gconf.o zconf.tab.o
 
-hostprogs-y := conf
+frontends-objs := $(conf-objs) $(mconf-objs) $(nconf-objs)
+frontends-objs := $(qconf-cxxobjs) $(gconf-objs)
+
+hostprogs-y :=
 
 ifeq ($(MAKECMDGOALS),nconfig)
 	hostprogs-y += nconf
+	ncurses-check := 1
 endif
 
 ifeq ($(MAKECMDGOALS),menuconfig)
 	hostprogs-y += mconf
+	ncurses-check := 1
 endif
 
 ifeq ($(MAKECMDGOALS),update-po-config)
@@ -188,140 +185,67 @@ ifeq ($(MAKECMDGOALS),update-po-config)
 endif
 
 ifeq ($(MAKECMDGOALS),xconfig)
-	qconf-target := 1
-endif
-ifeq ($(MAKECMDGOALS),gconfig)
-	gconf-target := 1
-endif
-
-
-ifeq ($(qconf-target),1)
 	hostprogs-y += qconf
+	qt-check := 1
 endif
-
-ifeq ($(gconf-target),1)
+ifeq ($(MAKECMDGOALS),gconfig)
 	hostprogs-y += gconf
+	gtk-check := 1
 endif
 
-clean-files	:= qconf.moc .tmp_qtcheck .tmp_gtkcheck
+hostprogs-y += conf
+
+clean-files	:= qconf.moc .tmp_check
 clean-files	+= zconf.tab.c lex.zconf.c zconf.hash.c gconf.glade.h
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
-# Add environment specific flags
-HOST_EXTRACFLAGS += $(shell $(CONFIG_SHELL) $(srctree)/$(src)/check.sh $(HOSTCC) $(HOSTCFLAGS))
-
 # generated files seem to need this to find local include files
 HOSTCFLAGS_lex.zconf.o	:= -I$(src)
 HOSTCFLAGS_zconf.tab.o	:= -I$(src)
 
-HOSTLOADLIBES_qconf	= $(KC_QT_LIBS)
-HOSTCXXFLAGS_qconf.o	= $(KC_QT_CFLAGS)
+HOSTCFLAGS_gconf.o	= -Wno-missing-prototypes
+
+HOSTLOADLIBES_nconf	= -lmenu -lpanel -lncurses
 
-HOSTLOADLIBES_gconf	= `pkg-config --libs gtk+-2.0 gmodule-2.0 libglade-2.0`
-HOSTCFLAGS_gconf.o	= `pkg-config --cflags gtk+-2.0 gmodule-2.0 libglade-2.0` \
-                          -Wno-missing-prototypes
+need-check += $(addprefix $(obj)/,$(frontends-objs))
+need-check += $(addprefix $(obj)/,$(lxdialog))
 
-HOSTLOADLIBES_mconf   = $(shell $(CONFIG_SHELL) $(check-lxdialog) -ldflags $(HOSTCC))
+$(need-check): $(obj)/.tmp_check
 
-HOSTLOADLIBES_nconf	= -lmenu -lpanel -lncurses
-$(obj)/qconf.o: $(obj)/.tmp_qtcheck
-
-ifeq ($(qconf-target),1)
-$(obj)/.tmp_qtcheck: $(src)/Makefile
--include $(obj)/.tmp_qtcheck
-
-# QT needs some extra effort...
-$(obj)/.tmp_qtcheck:
-	@set -e; echo "  CHECK   qt"; dir=""; pkg=""; \
-	if ! pkg-config --exists QtCore 2> /dev/null; then \
-	    echo "* Unable to find the QT4 tool qmake. Trying to use QT3"; \
-	    pkg-config --exists qt 2> /dev/null && pkg=qt; \
-	    pkg-config --exists qt-mt 2> /dev/null && pkg=qt-mt; \
-	    if [ -n "$$pkg" ]; then \
-	      cflags="\$$(shell pkg-config $$pkg --cflags)"; \
-	      libs="\$$(shell pkg-config $$pkg --libs)"; \
-	      moc="\$$(shell pkg-config $$pkg --variable=prefix)/bin/moc"; \
-	      dir="$$(pkg-config $$pkg --variable=prefix)"; \
-	    else \
-	      for d in $$QTDIR /usr/share/qt* /usr/lib/qt*; do \
-	        if [ -f $$d/include/qconfig.h ]; then dir=$$d; break; fi; \
-	      done; \
-	      if [ -z "$$dir" ]; then \
-	        echo "*"; \
-	        echo "* Unable to find any QT installation. Please make sure that"; \
-	        echo "* the QT4 or QT3 development package is correctly installed and"; \
-	        echo "* either qmake can be found or install pkg-config or set"; \
-	        echo "* the QTDIR environment variable to the correct location."; \
-	        echo "*"; \
-	        false; \
-	      fi; \
-	      libpath=$$dir/lib; lib=qt; osdir=""; \
-	      $(HOSTCXX) -print-multi-os-directory > /dev/null 2>&1 && \
-	        osdir=x$$($(HOSTCXX) -print-multi-os-directory); \
-	      test -d $$libpath/$$osdir && libpath=$$libpath/$$osdir; \
-	      test -f $$libpath/libqt-mt.so && lib=qt-mt; \
-	      cflags="-I$$dir/include"; \
-	      libs="-L$$libpath -Wl,-rpath,$$libpath -l$$lib"; \
-	      moc="$$dir/bin/moc"; \
-	    fi; \
-	    if [ ! -x $$dir/bin/moc -a -x /usr/bin/moc ]; then \
-	      echo "*"; \
-	      echo "* Unable to find $$dir/bin/moc, using /usr/bin/moc instead."; \
-	      echo "*"; \
-	      moc="/usr/bin/moc"; \
-	    fi; \
-	else \
-	  cflags="\$$(shell pkg-config QtCore QtGui Qt3Support --cflags)"; \
-	  libs="\$$(shell pkg-config QtCore QtGui Qt3Support --libs)"; \
-	  binpath="\$$(shell pkg-config QtCore --variable=prefix)"; \
-	  moc="$$binpath/bin/moc"; \
-	fi; \
-	echo "KC_QT_CFLAGS=$$cflags" > $@; \
-	echo "KC_QT_LIBS=$$libs" >> $@; \
-	echo "KC_QT_MOC=$$moc" >> $@
+KC_CHECK	:= gettext
+
+ifeq ($(ncurses-check),1)
+KC_CHECK	+= ncurses
 endif
 
-$(obj)/gconf.o: $(obj)/.tmp_gtkcheck
-
-ifeq ($(gconf-target),1)
--include $(obj)/.tmp_gtkcheck
-
-# GTK needs some extra effort, too...
-$(obj)/.tmp_gtkcheck:
-	@if `pkg-config --exists gtk+-2.0 gmodule-2.0 libglade-2.0`; then		\
-		if `pkg-config --atleast-version=2.0.0 gtk+-2.0`; then			\
-			touch $@;								\
-		else									\
-			echo "*"; 							\
-			echo "* GTK+ is present but version >= 2.0.0 is required.";	\
-			echo "*";							\
-			false;								\
-		fi									\
-	else										\
-		echo "*"; 								\
-		echo "* Unable to find the GTK+ installation. Please make sure that"; 	\
-		echo "* the GTK+ 2.0 development package is correctly installed..."; 	\
-		echo "* You need gtk+-2.0, glib-2.0 and libglade-2.0."; 		\
-		echo "*"; 								\
-		false;									\
-	fi
+ifeq ($(qt-check),1)
+KC_CHECK	+= qt
 endif
 
+ifeq ($(gtk-check),1)
+KC_CHECK	+= gtk
+endif
+
+-include $(obj)/.tmp_check
+
+KC_CHECKED := $(foreach check,$(KC_CHECK),$(if $(KCONFIG_CHECKED_$(check)),$(check),))
+ifneq ($(KC_CHECK),$(KC_CHECKED))
+$(obj)/.tmp_check: FORCE
+endif
+
+$(obj)/.tmp_check: $(src)/Makefile
+	$(Q)$(srctree)/$(src)/check.sh $(KC_CHECK)
+
 $(obj)/zconf.tab.o: $(obj)/lex.zconf.c $(obj)/zconf.hash.c
 
 $(obj)/qconf.o: $(obj)/qconf.moc
 
+quiet_cmd_moc = MOC     $@
+cmd_moc = $(HOSTMOC) -i $< -o $@
+
 $(obj)/%.moc: $(src)/%.h
-	$(KC_QT_MOC) -i $< -o $@
+	$(call cmd,moc)
 
 # Extract gconf menu items for I18N support
 $(obj)/gconf.glade.h: $(obj)/gconf.glade
diff --git a/scripts/kconfig/check.sh b/scripts/kconfig/check.sh
index fa59cbf..841d4bc 100755
--- a/scripts/kconfig/check.sh
+++ b/scripts/kconfig/check.sh
@@ -1,14 +1,178 @@
 #!/bin/sh
-# Needed for systems without gettext
-$* -xc -o /dev/null - > /dev/null 2>&1 << EOF
-#include <libintl.h>
-int main()
+#
+
+set -e
+
+check_gettext()
+{
+
+	echo '
+	#include <libintl.h>
+	int main()
+	{
+		gettext("");
+		return 0;
+	}' | \
+	{
+		$* -xc -o /dev/null - > /dev/null 2>&1 || \
+			echo HOST_EXTRACFLAGS	+= -DKBUILD_NO_NLS >> ${obj}/.tmp_check
+	}
+}
+
+check_gtk()
+{
+	local cflags=""
+	local libs=""
+
+	if pkg-config --exists gtk+-2.0 gmodule-2.0 libglade-2.0; then
+		if ! pkg-config --atleast-version=2.0.0 gtk+-2.0; then
+			echo "*"
+			echo "* GTK+ is present but version >= 2.0.0 is required."
+			echo "*"
+			false
+		fi
+	else
+		echo "*"
+		echo "* Unable to find the GTK+ installation. Please make sure that"
+		echo "* the GTK+ 2.0 development package is correctly installed..."
+		echo "* You need gtk+-2.0, glib-2.0 and libglade-2.0."
+		echo "*"
+		false
+	fi
+
+	cflags="$(pkg-config --cflags gtk+-2.0 gmodule-2.0 libglade-2.0)"
+	libs="$(pkg-config --libs gtk+-2.0 gmodule-2.0 libglade-2.0)"
+
+	echo "HOSTCFLAGS_gconf.o	+= $cflags" >> ${obj}/.tmp_check
+	echo "HOSTLOADLIBES_gconf	+= $libs"   >> ${obj}/.tmp_check
+}
+
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
+	echo "HOSTCFLAGS	:=$cflags" >> ${obj}/.tmp_check
+	echo "HOSTLOADLIBES_mconf	:= $libs"   >> ${obj}/.tmp_check
+}
+
+check_qt()
 {
-	gettext("");
-	return 0;
+	local cflags=""
+	local libs=""
+	local prefix=""
+
+	if pkg-config --exists QtCore 2> /dev/null; then
+		cflags="$(pkg-config QtCore QtGui Qt3Support --cflags)"
+		libs="$(pkg-config QtCore QtGui Qt3Support --libs)"
+		prefix="$(pkg-config QtCore --variable=prefix)"
+	else
+		echo "* Unable to find the QT4 tool qmake. Trying to use QT3"
+		pkg=""
+		pkg-config --exists qt 2> /dev/null && pkg=qt
+		pkg-config --exists qt-mt 2> /dev/null && pkg=qt-mt
+		if [ -n "$pkg" ]; then
+			cflags="$(pkg-config $pkg --cflags)"
+			libs="$(pkg-config $pkg --libs)"
+			prefix="$(pkg-config $pkg --variable=prefix)"
+		else
+			for d in $QTDIR /usr/share/qt* /usr/lib/qt*; do
+				if [ -f $d/include/qconfig.h ]; then
+					prefix=$d
+					break
+				fi
+			done
+			if [ -z "$prefix" ]; then
+				echo "  *"
+				echo "  * Unable to find any QT installation. Please make sure that"
+				echo "  * the QT4 or QT3 development package is correctly installed and"
+				echo "  * either qmake can be found or install pkg-config or set"
+				echo "  * the QTDIR environment variable to the correct location."
+				echo "  *"
+				false
+			fi
+			libpath=$dir/lib
+			lib=qt
+			osdir=""
+			${HOSTCXX} -print-multi-os-directory > /dev/null 2>&1 && \
+			    osdir=x$(${HOSTCXX} -print-multi-os-directory)
+			test -d $libpath/$osdir && libpath=$libpath/$osdir
+			test -f $libpath/libqt-mt.so && lib=qt-mt
+			cflags="-I$prefix/include"
+			libs="-L$libpath -Wl,-rpath,$libpath -l$lib"
+		fi
+	fi
+
+	if [ -x $prefix/bin/moc ]; then
+		moc=$prefix/bin/moc
+	elif [ -a -x /usr/bin/moc ]; then
+		echo "  *"
+		echo "  * Unable to find $prefix/bin/moc, using /usr/bin/moc instead."
+		echo "  *"
+		moc="/usr/bin/moc"
+	fi
+
+	echo "HOSTCXXFLAGS_qconf.o	+= $cflags" >> ${obj}/.tmp_check
+	echo "HOSTLOADLIBES_qconf	+= $libs"   >> ${obj}/.tmp_check
+	echo "HOSTMOC	:= $moc" >> ${obj}/.tmp_check
 }
-EOF
-if [ ! "$?" -eq "0"  ]; then
-	echo -DKBUILD_NO_NLS;
-fi
 
+rm -f ${obj}/.tmp_check
+
+for arg in $*; do
+	case $arg in
+	gettext)	;;
+	gtk)		;;
+	ncurses)	;;
+	qt)		;;
+	*)
+		echo "  *"
+		echo "  * Do not know how to check for \`$arg'"
+		echo "  *"
+		false
+		;;
+	esac
+	echo "  CHECK   $arg"
+
+	check_$arg
+	echo "KCONFIG_CHECKED_$arg := 1"	>> ${obj}/.tmp_check
+done
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

