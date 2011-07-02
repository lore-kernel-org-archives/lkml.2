Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753086Ab1GBBr6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jul 2011 21:47:58 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:41010 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752899Ab1GBBrz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jul 2011 21:47:55 -0400
From: Arnaud Lacombe <lacombar@gmail.com>
To: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
        Michal Marek <mmarek@suse.cz>
Cc: Arnaud Lacombe <lacombar@gmail.com>
Subject: [RFC 3/7] kconfig/check.sh: prepare for generic check
Date: Fri,  1 Jul 2011 21:47:35 -0400
Message-Id: <1309571259-15241-4-git-send-email-lacombar@gmail.com>
X-Mailer: git-send-email 1.7.3.4.574.g608b.dirty
In-Reply-To: <1309571259-15241-1-git-send-email-lacombar@gmail.com>
References: <1307387767-9237-1-git-send-email-lacombar@gmail.com>
 <1309571259-15241-1-git-send-email-lacombar@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

`scripts/kconfig/check.sh' currently checks for libintl availability, make this
explicit. Result gets stored in a ${obj}/.tmp_check Makefile sourced by
the main Makefile dynamically.
---
 scripts/kconfig/Makefile |   22 ++++++++++++++++++----
 scripts/kconfig/check.sh |   44 ++++++++++++++++++++++++++++++++++----------
 2 files changed, 52 insertions(+), 14 deletions(-)

diff --git a/scripts/kconfig/Makefile b/scripts/kconfig/Makefile
index 8abde17..a9344d2 100644
--- a/scripts/kconfig/Makefile
+++ b/scripts/kconfig/Makefile
@@ -173,8 +173,12 @@ qconf-cxxobjs	:= qconf.o
 qconf-objs	:= zconf.tab.o
 gconf-objs	:= gconf.o zconf.tab.o
 
+frontends-objs := $(conf-objs) $(mconf-objs) $(nconf-objs)
+
 hostprogs-y :=
 
+KC_CHECK := gettext
+
 ifeq ($(MAKECMDGOALS),nconfig)
 	hostprogs-y += nconf
 endif
@@ -205,7 +209,7 @@ endif
 
 hostprogs-y += conf
 
-clean-files	:= qconf.moc .tmp_qtcheck .tmp_gtkcheck
+clean-files	:= qconf.moc .tmp_qtcheck .tmp_gtkcheck .tmp_check
 clean-files	+= zconf.tab.c lex.zconf.c zconf.hash.c gconf.glade.h
 clean-files     += mconf qconf gconf nconf
 clean-files     += config.pot linux.pot
@@ -218,9 +222,6 @@ $(obj)/dochecklxdialog:
 
 always := dochecklxdialog
 
-# Add environment specific flags
-HOST_EXTRACFLAGS += $(shell $(CONFIG_SHELL) $(srctree)/$(src)/check.sh $(HOSTCC) $(HOSTCFLAGS))
-
 # generated files seem to need this to find local include files
 HOSTCFLAGS_lex.zconf.o	:= -I$(src)
 HOSTCFLAGS_zconf.tab.o	:= -I$(src)
@@ -316,8 +317,21 @@ $(obj)/.tmp_gtkcheck:
 		echo "*"; 								\
 		false;									\
 	fi
+
+need-check := $(addprefix $(obj)/,$(frontends-objs))
+
+$(need-check): $(obj)/.tmp_check
+
+-include $(obj)/.tmp_check
+
+KC_CHECKED := $(foreach check,$(KC_CHECK),$(if $(KCONFIG_CHECKED_$(check)),$(check),))
+ifneq ($(KC_CHECK),$(KC_CHECKED))
+$(obj)/.tmp_check: FORCE
 endif
 
+$(obj)/.tmp_check: $(src)/Makefile
+	$(Q)$(srctree)/$(src)/check.sh $(KC_CHECK)
+
 $(obj)/zconf.tab.o: $(obj)/lex.zconf.c $(obj)/zconf.hash.c
 
 $(obj)/qconf.o: $(obj)/qconf.moc
diff --git a/scripts/kconfig/check.sh b/scripts/kconfig/check.sh
index fa59cbf..fcb999e 100755
--- a/scripts/kconfig/check.sh
+++ b/scripts/kconfig/check.sh
@@ -1,14 +1,38 @@
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
 {
-	gettext("");
-	return 0;
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
-- 
1.7.3.4.574.g608b.dirty

