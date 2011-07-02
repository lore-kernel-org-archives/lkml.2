Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753263Ab1GBBsB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jul 2011 21:48:01 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:41010 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753119Ab1GBBr6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jul 2011 21:47:58 -0400
From: Arnaud Lacombe <lacombar@gmail.com>
To: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
        Michal Marek <mmarek@suse.cz>
Cc: Arnaud Lacombe <lacombar@gmail.com>
Subject: [RFC 5/7] kconfig: move GTK checks to `scripts/kconfig/check.sh'
Date: Fri,  1 Jul 2011 21:47:37 -0400
Message-Id: <1309571259-15241-6-git-send-email-lacombar@gmail.com>
X-Mailer: git-send-email 1.7.3.4.574.g608b.dirty
In-Reply-To: <1309571259-15241-1-git-send-email-lacombar@gmail.com>
References: <1307387767-9237-1-git-send-email-lacombar@gmail.com>
 <1309571259-15241-1-git-send-email-lacombar@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

---
 scripts/kconfig/Makefile |   39 +++++----------------------------------
 scripts/kconfig/check.sh |   29 +++++++++++++++++++++++++++++
 2 files changed, 34 insertions(+), 34 deletions(-)

diff --git a/scripts/kconfig/Makefile b/scripts/kconfig/Makefile
index a3176dc..5021817 100644
--- a/scripts/kconfig/Makefile
+++ b/scripts/kconfig/Makefile
@@ -174,7 +174,7 @@ qconf-objs	:= zconf.tab.o
 gconf-objs	:= gconf.o zconf.tab.o
 
 frontends-objs := $(conf-objs) $(mconf-objs) $(nconf-objs)
-frontends-objs += $(qconf-cxxobjs)
+frontends-objs += $(qconf-cxxobjs) $(gconf-objs)
 
 hostprogs-y :=
 
@@ -198,18 +198,15 @@ ifeq ($(MAKECMDGOALS),xconfig)
 	hostprogs-y += qconf
 	KC_CHECK += qt
 endif
-ifeq ($(MAKECMDGOALS),gconfig)
-	gconf-target := 1
-endif
-
 
-ifeq ($(gconf-target),1)
+ifeq ($(MAKECMDGOALS),gconfig)
 	hostprogs-y += gconf
+	KC_CHECK += gtk
 endif
 
 hostprogs-y += conf
 
-clean-files	:= qconf.moc .tmp_gtkcheck .tmp_check
+clean-files	:= qconf.moc .tmp_check
 clean-files	+= zconf.tab.c lex.zconf.c zconf.hash.c gconf.glade.h
 clean-files     += mconf qconf gconf nconf
 clean-files     += config.pot linux.pot
@@ -226,38 +223,12 @@ always := dochecklxdialog
 HOSTCFLAGS_lex.zconf.o	:= -I$(src)
 HOSTCFLAGS_zconf.tab.o	:= -I$(src)
 
-HOSTLOADLIBES_gconf	= `pkg-config --libs gtk+-2.0 gmodule-2.0 libglade-2.0`
-HOSTCFLAGS_gconf.o	= `pkg-config --cflags gtk+-2.0 gmodule-2.0 libglade-2.0` \
-                          -Wno-missing-prototypes
+HOSTCFLAGS_gconf.o	= -Wno-missing-prototypes
 
 HOSTLOADLIBES_mconf   = $(shell $(CONFIG_SHELL) $(check-lxdialog) -ldflags $(HOSTCC))
 
 HOSTLOADLIBES_nconf	= -lmenu -lpanel -lncurses
 
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
 
 need-check := $(addprefix $(obj)/,$(frontends-objs))
 
diff --git a/scripts/kconfig/check.sh b/scripts/kconfig/check.sh
index 47abde4..4456d63 100755
--- a/scripts/kconfig/check.sh
+++ b/scripts/kconfig/check.sh
@@ -19,6 +19,34 @@ check_gettext()
 	}
 }
 
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
 check_qt()
 {
 	local cflags=""
@@ -85,6 +113,7 @@ rm -f ${obj}/.tmp_check
 for arg in $*; do
 	case $arg in
 	gettext)	;;
+	gtk)		;;
 	qt)		;;
 	*)
 		echo "  *"
-- 
1.7.3.4.574.g608b.dirty

