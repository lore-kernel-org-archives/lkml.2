Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932487Ab1DZAM6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Apr 2011 20:12:58 -0400
Received: from nd215.dnsexit.com ([64.182.102.215]:48515 "EHLO
	box7.911domain.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932167Ab1DZAM5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Apr 2011 20:12:57 -0400
X-Complaints-To: abuse@dnsExit.com
X-SPAM: Please report Spam to abuse@dnsExit.com
        By service at http://www.dnsExit.com/Direct.sv?cmd=mailRelay
        Accounts will be suspended immediately if convicted Spam
Message-ID: <4DB60DE1.8060402@verizon.net>
Date: Mon, 25 Apr 2011 20:12:17 -0400
From: Peter Foley <pefoley2@verizon.net>
Reply-To: <pefoley2@verizon.net>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.15) Gecko/20110303 Thunderbird/3.1.9
MIME-Version: 1.0
To: <linux-kernel@vger.kernel.org>
CC: <linux-kbuild@vger.kernel.org>, <mmarek@suse.cz>
Subject: [PATCH] kbuild: scripts/kconfig/Makefile cleanup and fixes
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch:
Changes the update-po-config target to work when make is run from KBUILD_OUTDIR.
Adds a check to only build kxgettext when needed.
Changes the qconf and gconf targets to change hostprogs-y when they are being built
	like nconfig and menuconfig instead of defining *-objs.
Cleans up the clean-files definitions.

Signed-off-by: Peter Foley <pefoley2@verizon.net>
---
 scripts/kconfig/Makefile |   35 +++++++++++++++++++++--------------
 1 files changed, 21 insertions(+), 14 deletions(-)

diff --git a/scripts/kconfig/Makefile b/scripts/kconfig/Makefile
index 368ae30..c4206ce 100644
--- a/scripts/kconfig/Makefile
+++ b/scripts/kconfig/Makefile
@@ -77,14 +77,15 @@ localyesconfig: $(obj)/streamline_config.pl $(obj)/conf
 # The symlink is used to repair a deficiency in arch/um
 update-po-config: $(obj)/kxgettext $(obj)/gconf.glade.h
 	$(Q)echo "  GEN config"
-	$(Q)xgettext --default-domain=linux              \
-	    --add-comments --keyword=_ --keyword=N_      \
-	    --from-code=UTF-8                            \
-	    --files-from=scripts/kconfig/POTFILES.in     \
+	$(Q)xgettext --default-domain=linux                         \
+	    --add-comments --keyword=_ --keyword=N_                 \
+	    --from-code=UTF-8                                       \
+	    --files-from=$(srctree)/scripts/kconfig/POTFILES.in     \
+	    --directory=$(srctree) --directory=$(objtree)           \
 	    --output $(obj)/config.pot
 	$(Q)sed -i s/CHARSET/UTF-8/ $(obj)/config.pot
-	$(Q)ln -fs Kconfig.i386 arch/um/Kconfig.arch
-	$(Q)(for i in `ls arch/*/Kconfig`;               \
+	$(Q)ln -fs Kconfig.x86 $(srctree)/arch/um/Kconfig
+	$(Q)(for i in `ls $(srctree)/arch/*/Kconfig`;    \
 	    do                                           \
 		echo "  GEN $$i";                        \
 		$(obj)/kxgettext $$i                     \
@@ -92,7 +93,7 @@ update-po-config: $(obj)/kxgettext $(obj)/gconf.glade.h
 	    done )
 	$(Q)msguniq --sort-by-file --to-code=UTF-8 $(obj)/config.pot \
 	    --output $(obj)/linux.pot
-	$(Q)rm -f arch/um/Kconfig.arch
+	$(Q)rm -f $(srctree)/arch/um/Kconfig
 	$(Q)rm -f $(obj)/config.pot

 PHONY += allnoconfig allyesconfig allmodconfig alldefconfig randconfig
@@ -167,9 +168,12 @@ lxdialog += lxdialog/textbox.o lxdialog/yesno.o
lxdialog/menubox.o
 conf-objs	:= conf.o  zconf.tab.o
 mconf-objs     := mconf.o zconf.tab.o $(lxdialog)
 nconf-objs     := nconf.o zconf.tab.o nconf.gui.o
+qconf-cxxobjs	:= qconf.o
+qconf-objs	:= kconfig_load.o zconf.tab.o
+gconf-objs	:= gconf.o kconfig_load.o zconf.tab.o
 kxgettext-objs	:= kxgettext.o zconf.tab.o

-hostprogs-y := conf qconf gconf kxgettext
+hostprogs-y := conf

 ifeq ($(MAKECMDGOALS),nconfig)
 	hostprogs-y += nconf
@@ -186,18 +190,20 @@ ifeq ($(MAKECMDGOALS),gconfig)
 	gconf-target := 1
 endif

+ifeq ($(MAKECMDGOALS),update-po-config)
+	hostprogs-y += kxgettext
+endif

 ifeq ($(qconf-target),1)
-qconf-cxxobjs	:= qconf.o
-qconf-objs	:= kconfig_load.o zconf.tab.o
+	hostprogs-y += qconf
 endif

 ifeq ($(gconf-target),1)
-gconf-objs	:= gconf.o kconfig_load.o zconf.tab.o
+	hostprogs-y += gconf
 endif

-clean-files	:= lkc_defs.h qconf.moc .tmp_qtcheck \
-		   .tmp_gtkcheck zconf.tab.c lex.zconf.c zconf.hash.c gconf.glade.h
+clean-files	:= lkc_defs.h qconf.moc .tmp_qtcheck .tmp_gtkcheck
+clean-files     += zconf.tab.c lex.zconf.c zconf.hash.c gconf.glade.h
 clean-files     += mconf qconf gconf nconf
 clean-files     += config.pot linux.pot

@@ -325,7 +331,8 @@ $(obj)/lkc_defs.h: $(src)/lkc_proto.h

 # Extract gconf menu items for I18N support
 $(obj)/gconf.glade.h: $(obj)/gconf.glade
-	intltool-extract --type=gettext/glade $(obj)/gconf.glade
+	$(Q)intltool-extract --type=gettext/glade --srcdir $(srctree) \
+	$(src)/gconf.glade

 ###
 # The following requires flex/bison/gperf
-- 
1.7.5.rc1

