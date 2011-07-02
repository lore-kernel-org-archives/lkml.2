Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753599Ab1GBBsv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jul 2011 21:48:51 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:42485 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752926Ab1GBBr5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jul 2011 21:47:57 -0400
From: Arnaud Lacombe <lacombar@gmail.com>
To: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
        Michal Marek <mmarek@suse.cz>
Cc: Arnaud Lacombe <lacombar@gmail.com>
Subject: [RFC 4/7] kconfig: move QT checks to `scripts/kconfig/check.sh'
Date: Fri,  1 Jul 2011 21:47:36 -0400
Message-Id: <1309571259-15241-5-git-send-email-lacombar@gmail.com>
X-Mailer: git-send-email 1.7.3.4.574.g608b.dirty
In-Reply-To: <1309571259-15241-1-git-send-email-lacombar@gmail.com>
References: <1307387767-9237-1-git-send-email-lacombar@gmail.com>
 <1309571259-15241-1-git-send-email-lacombar@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

+50 lines of shell script in the main Makefile is just insane. In the same
time attempts to make the script more readable.
---
 scripts/kconfig/Makefile |   73 ++++-----------------------------------------
 scripts/kconfig/check.sh |   62 +++++++++++++++++++++++++++++++++++++++
 2 files changed, 69 insertions(+), 66 deletions(-)

diff --git a/scripts/kconfig/Makefile b/scripts/kconfig/Makefile
index a9344d2..a3176dc 100644
--- a/scripts/kconfig/Makefile
+++ b/scripts/kconfig/Makefile
@@ -174,6 +174,9 @@ qconf-objs	:= zconf.tab.o
 gconf-objs	:= gconf.o zconf.tab.o
 
 frontends-objs := $(conf-objs) $(mconf-objs) $(nconf-objs)
+frontends-objs += $(qconf-cxxobjs)
+
+hostprogs-y :=
 
 hostprogs-y :=
 
@@ -192,24 +195,21 @@ ifeq ($(MAKECMDGOALS),update-po-config)
 endif
 
 ifeq ($(MAKECMDGOALS),xconfig)
-	qconf-target := 1
+	hostprogs-y += qconf
+	KC_CHECK += qt
 endif
 ifeq ($(MAKECMDGOALS),gconfig)
 	gconf-target := 1
 endif
 
 
-ifeq ($(qconf-target),1)
-	hostprogs-y += qconf
-endif
-
 ifeq ($(gconf-target),1)
 	hostprogs-y += gconf
 endif
 
 hostprogs-y += conf
 
-clean-files	:= qconf.moc .tmp_qtcheck .tmp_gtkcheck .tmp_check
+clean-files	:= qconf.moc .tmp_gtkcheck .tmp_check
 clean-files	+= zconf.tab.c lex.zconf.c zconf.hash.c gconf.glade.h
 clean-files     += mconf qconf gconf nconf
 clean-files     += config.pot linux.pot
@@ -226,9 +226,6 @@ always := dochecklxdialog
 HOSTCFLAGS_lex.zconf.o	:= -I$(src)
 HOSTCFLAGS_zconf.tab.o	:= -I$(src)
 
-HOSTLOADLIBES_qconf	= $(KC_QT_LIBS)
-HOSTCXXFLAGS_qconf.o	= $(KC_QT_CFLAGS)
-
 HOSTLOADLIBES_gconf	= `pkg-config --libs gtk+-2.0 gmodule-2.0 libglade-2.0`
 HOSTCFLAGS_gconf.o	= `pkg-config --cflags gtk+-2.0 gmodule-2.0 libglade-2.0` \
                           -Wno-missing-prototypes
@@ -236,62 +233,6 @@ HOSTCFLAGS_gconf.o	= `pkg-config --cflags gtk+-2.0 gmodule-2.0 libglade-2.0` \
 HOSTLOADLIBES_mconf   = $(shell $(CONFIG_SHELL) $(check-lxdialog) -ldflags $(HOSTCC))
 
 HOSTLOADLIBES_nconf	= -lmenu -lpanel -lncurses
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
-endif
 
 $(obj)/gconf.o: $(obj)/.tmp_gtkcheck
 
@@ -337,7 +278,7 @@ $(obj)/zconf.tab.o: $(obj)/lex.zconf.c $(obj)/zconf.hash.c
 $(obj)/qconf.o: $(obj)/qconf.moc
 
 quiet_cmd_moc = MOC     $@
-cmd_moc = $(KC_QT_MOC) -i $< -o $@
+cmd_moc = $(HOSTMOC) -i $< -o $@
 
 $(obj)/%.moc: $(src)/%.h
 	$(call cmd,moc)
diff --git a/scripts/kconfig/check.sh b/scripts/kconfig/check.sh
index fcb999e..47abde4 100755
--- a/scripts/kconfig/check.sh
+++ b/scripts/kconfig/check.sh
@@ -19,11 +19,73 @@ check_gettext()
 	}
 }
 
+check_qt()
+{
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
+}
+
 rm -f ${obj}/.tmp_check
 
 for arg in $*; do
 	case $arg in
 	gettext)	;;
+	qt)		;;
 	*)
 		echo "  *"
 		echo "  * Do not know how to check for \`$arg'"
-- 
1.7.3.4.574.g608b.dirty

