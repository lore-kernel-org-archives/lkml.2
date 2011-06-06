Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757747Ab1FFS7E (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 14:59:04 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:36359 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757527Ab1FFS6v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 14:58:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=DWfW+EXmrQHYqgySbTrs5UQR92MmCwa/UekOu8wAr2OxjDqqJrTLE9NifSS404PC0d
         UOBRbo80TxUGmFpiOkK2sDWmqLP+QOxV5qBorZFUMQrPVL/Wl6jIY34VaFPtLU9r56md
         1SbaN7QnrNgT9hEPa/QmSz18ondOPxTu6J4b0=
From: Arnaud Lacombe <lacombar@gmail.com>
To: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Michal Marek <mmarek@suse.cz>, Arnaud Lacombe <lacombar@gmail.com>
Subject: [PATCH 7/9] kconfig: nuke LKC_DIRECT_LINK cruft
Date: Mon,  6 Jun 2011 14:58:29 -0400
Message-Id: <1307386711-8866-8-git-send-email-lacombar@gmail.com>
X-Mailer: git-send-email 1.7.3.4.574.g608b.dirty
In-Reply-To: <1307386711-8866-1-git-send-email-lacombar@gmail.com>
References: <1307386711-8866-1-git-send-email-lacombar@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This interface is not (and has never been ?) used by any frontend, just get rid
of it.

Signed-off-by: Arnaud Lacombe <lacombar@gmail.com>
---
 scripts/kconfig/Makefile            |   24 ++++++++----------------
 scripts/kconfig/conf.c              |    1 -
 scripts/kconfig/confdata.c          |    1 -
 scripts/kconfig/expr.c              |    1 -
 scripts/kconfig/gconf.c             |    4 ----
 scripts/kconfig/kconfig_load.c      |   35 -----------------------------------
 scripts/kconfig/kxgettext.c         |    1 -
 scripts/kconfig/lex.zconf.c_shipped |    1 -
 scripts/kconfig/lkc.h               |    5 -----
 scripts/kconfig/mconf.c             |    1 -
 scripts/kconfig/menu.c              |    1 -
 scripts/kconfig/nconf.c             |    2 +-
 scripts/kconfig/qconf.cc            |    4 ----
 scripts/kconfig/symbol.c            |    1 -
 scripts/kconfig/zconf.l             |    1 -
 scripts/kconfig/zconf.tab.c_shipped |    1 -
 scripts/kconfig/zconf.y             |    1 -
 17 files changed, 9 insertions(+), 76 deletions(-)
 delete mode 100644 scripts/kconfig/kconfig_load.c

diff --git a/scripts/kconfig/Makefile b/scripts/kconfig/Makefile
index faa9a47..0460ac3 100644
--- a/scripts/kconfig/Makefile
+++ b/scripts/kconfig/Makefile
@@ -170,8 +170,8 @@ mconf-objs     := mconf.o zconf.tab.o $(lxdialog)
 nconf-objs     := nconf.o zconf.tab.o nconf.gui.o
 kxgettext-objs	:= kxgettext.o zconf.tab.o
 qconf-cxxobjs	:= qconf.o
-qconf-objs	:= kconfig_load.o zconf.tab.o
-gconf-objs	:= gconf.o kconfig_load.o zconf.tab.o
+qconf-objs	:= zconf.tab.o
+gconf-objs	:= gconf.o zconf.tab.o
 
 hostprogs-y := conf
 
@@ -203,7 +203,7 @@ ifeq ($(gconf-target),1)
 	hostprogs-y += gconf
 endif
 
-clean-files	:= lkc_defs.h qconf.moc .tmp_qtcheck .tmp_gtkcheck
+clean-files	:= qconf.moc .tmp_qtcheck .tmp_gtkcheck
 clean-files	+= zconf.tab.c lex.zconf.c zconf.hash.c gconf.glade.h
 clean-files     += mconf qconf gconf nconf
 clean-files     += config.pot linux.pot
@@ -223,12 +223,11 @@ HOST_EXTRACFLAGS += $(shell $(CONFIG_SHELL) $(srctree)/$(src)/check.sh $(HOSTCC)
 HOSTCFLAGS_lex.zconf.o	:= -I$(src)
 HOSTCFLAGS_zconf.tab.o	:= -I$(src)
 
-HOSTLOADLIBES_qconf	= $(KC_QT_LIBS) -ldl
-HOSTCXXFLAGS_qconf.o	= $(KC_QT_CFLAGS) -D LKC_DIRECT_LINK
+HOSTLOADLIBES_qconf	= $(KC_QT_LIBS)
+HOSTCXXFLAGS_qconf.o	= $(KC_QT_CFLAGS)
 
-HOSTLOADLIBES_gconf	= `pkg-config --libs gtk+-2.0 gmodule-2.0 libglade-2.0` -ldl
-HOSTCFLAGS_gconf.o	= `pkg-config --cflags gtk+-2.0 gmodule-2.0 libglade-2.0` \
-                          -D LKC_DIRECT_LINK
+HOSTLOADLIBES_gconf	= `pkg-config --libs gtk+-2.0 gmodule-2.0 libglade-2.0`
+HOSTCFLAGS_gconf.o	= `pkg-config --cflags gtk+-2.0 gmodule-2.0 libglade-2.0`
 
 HOSTLOADLIBES_mconf   = $(shell $(CONFIG_SHELL) $(check-lxdialog) -ldflags $(HOSTCC))
 
@@ -318,18 +317,11 @@ endif
 
 $(obj)/zconf.tab.o: $(obj)/lex.zconf.c $(obj)/zconf.hash.c
 
-$(obj)/kconfig_load.o: $(obj)/lkc_defs.h
-
-$(obj)/qconf.o: $(obj)/qconf.moc $(obj)/lkc_defs.h
-
-$(obj)/gconf.o: $(obj)/lkc_defs.h
+$(obj)/qconf.o: $(obj)/qconf.moc
 
 $(obj)/%.moc: $(src)/%.h
 	$(KC_QT_MOC) -i $< -o $@
 
-$(obj)/lkc_defs.h: $(src)/lkc_proto.h
-	$(Q)sed < $< > $@ 's/P(\([^,]*\),.*/#define \1 (\*\1_p)/'
-
 # Extract gconf menu items for I18N support
 $(obj)/gconf.glade.h: $(obj)/gconf.glade
 	$(Q)intltool-extract --type=gettext/glade --srcdir=$(srctree) \
diff --git a/scripts/kconfig/conf.c b/scripts/kconfig/conf.c
index 8be7374..4e32098 100644
--- a/scripts/kconfig/conf.c
+++ b/scripts/kconfig/conf.c
@@ -14,7 +14,6 @@
 #include <sys/stat.h>
 #include <sys/time.h>
 
-#define LKC_DIRECT_LINK
 #include "lkc.h"
 
 static void conf(struct menu *menu);
diff --git a/scripts/kconfig/confdata.c b/scripts/kconfig/confdata.c
index 2118f4b..3eeaaeb 100644
--- a/scripts/kconfig/confdata.c
+++ b/scripts/kconfig/confdata.c
@@ -14,7 +14,6 @@
 #include <time.h>
 #include <unistd.h>
 
-#define LKC_DIRECT_LINK
 #include "lkc.h"
 
 static void conf_warning(const char *fmt, ...)
diff --git a/scripts/kconfig/expr.c b/scripts/kconfig/expr.c
index 0010034..792c62e 100644
--- a/scripts/kconfig/expr.c
+++ b/scripts/kconfig/expr.c
@@ -7,7 +7,6 @@
 #include <stdlib.h>
 #include <string.h>
 
-#define LKC_DIRECT_LINK
 #include "lkc.h"
 
 #define DEBUG_EXPR	0
diff --git a/scripts/kconfig/gconf.c b/scripts/kconfig/gconf.c
index 79e9806..0426fda 100644
--- a/scripts/kconfig/gconf.c
+++ b/scripts/kconfig/gconf.c
@@ -1507,10 +1507,6 @@ int main(int ac, char *av[])
 	char *env;
 	gchar *glade_file;
 
-#ifndef LKC_DIRECT_LINK
-	kconfig_load();
-#endif
-
 	bindtextdomain(PACKAGE, LOCALEDIR);
 	bind_textdomain_codeset(PACKAGE, "UTF-8");
 	textdomain(PACKAGE);
diff --git a/scripts/kconfig/kconfig_load.c b/scripts/kconfig/kconfig_load.c
deleted file mode 100644
index dbdcaad..0000000
--- a/scripts/kconfig/kconfig_load.c
+++ /dev/null
@@ -1,35 +0,0 @@
-#include <dlfcn.h>
-#include <stdio.h>
-#include <stdlib.h>
-
-#include "lkc.h"
-
-#define P(name,type,arg)	type (*name ## _p) arg
-#include "lkc_proto.h"
-#undef P
-
-void kconfig_load(void)
-{
-	void *handle;
-	char *error;
-
-	handle = dlopen("./libkconfig.so", RTLD_LAZY);
-	if (!handle) {
-		handle = dlopen("./scripts/kconfig/libkconfig.so", RTLD_LAZY);
-		if (!handle) {
-			fprintf(stderr, "%s\n", dlerror());
-			exit(1);
-		}
-	}
-
-#define P(name,type,arg)			\
-{						\
-	name ## _p = dlsym(handle, #name);	\
-        if ((error = dlerror()))  {		\
-                fprintf(stderr, "%s\n", error);	\
-		exit(1);			\
-	}					\
-}
-#include "lkc_proto.h"
-#undef P
-}
diff --git a/scripts/kconfig/kxgettext.c b/scripts/kconfig/kxgettext.c
index e9d8e79..2858738 100644
--- a/scripts/kconfig/kxgettext.c
+++ b/scripts/kconfig/kxgettext.c
@@ -7,7 +7,6 @@
 #include <stdlib.h>
 #include <string.h>
 
-#define LKC_DIRECT_LINK
 #include "lkc.h"
 
 static char *escape(const char* text, char *bf, int len)
diff --git a/scripts/kconfig/lex.zconf.c_shipped b/scripts/kconfig/lex.zconf.c_shipped
index d918291..dcea7a7 100644
--- a/scripts/kconfig/lex.zconf.c_shipped
+++ b/scripts/kconfig/lex.zconf.c_shipped
@@ -785,7 +785,6 @@ char *zconftext;
 #include <string.h>
 #include <unistd.h>
 
-#define LKC_DIRECT_LINK
 #include "lkc.h"
 
 #define START_STRSIZE	16
diff --git a/scripts/kconfig/lkc.h b/scripts/kconfig/lkc.h
index febf0c9..625ec69 100644
--- a/scripts/kconfig/lkc.h
+++ b/scripts/kconfig/lkc.h
@@ -21,12 +21,7 @@ static inline char *bind_textdomain_codeset(const char *dn, char *c) { return c;
 extern "C" {
 #endif
 
-#ifdef LKC_DIRECT_LINK
 #define P(name,type,arg)	extern type name arg
-#else
-#include "lkc_defs.h"
-#define P(name,type,arg)	extern type (*name ## _p) arg
-#endif
 #include "lkc_proto.h"
 #undef P
 
diff --git a/scripts/kconfig/mconf.c b/scripts/kconfig/mconf.c
index fa0ae0e..77344ac 100644
--- a/scripts/kconfig/mconf.c
+++ b/scripts/kconfig/mconf.c
@@ -18,7 +18,6 @@
 #include <unistd.h>
 #include <locale.h>
 
-#define LKC_DIRECT_LINK
 #include "lkc.h"
 #include "lxdialog/dialog.h"
 
diff --git a/scripts/kconfig/menu.c b/scripts/kconfig/menu.c
index 24547fe..aab5a1f 100644
--- a/scripts/kconfig/menu.c
+++ b/scripts/kconfig/menu.c
@@ -8,7 +8,6 @@
 #include <stdlib.h>
 #include <string.h>
 
-#define LKC_DIRECT_LINK
 #include "lkc.h"
 
 static const char nohelp_text[] = N_(
diff --git a/scripts/kconfig/nconf.c b/scripts/kconfig/nconf.c
index 488dd74..da9f5c4 100644
--- a/scripts/kconfig/nconf.c
+++ b/scripts/kconfig/nconf.c
@@ -7,7 +7,7 @@
  */
 #define _GNU_SOURCE
 #include <string.h>
-#define LKC_DIRECT_LINK
+
 #include "lkc.h"
 #include "nconf.h"
 #include <ctype.h>
diff --git a/scripts/kconfig/qconf.cc b/scripts/kconfig/qconf.cc
index c2796b8..31e01cd 100644
--- a/scripts/kconfig/qconf.cc
+++ b/scripts/kconfig/qconf.cc
@@ -1745,10 +1745,6 @@ int main(int ac, char** av)
 	bindtextdomain(PACKAGE, LOCALEDIR);
 	textdomain(PACKAGE);
 
-#ifndef LKC_DIRECT_LINK
-	kconfig_load();
-#endif
-
 	progname = av[0];
 	configApp = new QApplication(ac, av);
 	if (ac > 1 && av[1][0] == '-') {
diff --git a/scripts/kconfig/symbol.c b/scripts/kconfig/symbol.c
index a796c95..cf8edf4 100644
--- a/scripts/kconfig/symbol.c
+++ b/scripts/kconfig/symbol.c
@@ -9,7 +9,6 @@
 #include <regex.h>
 #include <sys/utsname.h>
 
-#define LKC_DIRECT_LINK
 #include "lkc.h"
 
 struct symbol symbol_yes = {
diff --git a/scripts/kconfig/zconf.l b/scripts/kconfig/zconf.l
index b22f884..29b79f4 100644
--- a/scripts/kconfig/zconf.l
+++ b/scripts/kconfig/zconf.l
@@ -14,7 +14,6 @@
 #include <string.h>
 #include <unistd.h>
 
-#define LKC_DIRECT_LINK
 #include "lkc.h"
 
 #define START_STRSIZE	16
diff --git a/scripts/kconfig/zconf.tab.c_shipped b/scripts/kconfig/zconf.tab.c_shipped
index 4c5495e..c1579e6 100644
--- a/scripts/kconfig/zconf.tab.c_shipped
+++ b/scripts/kconfig/zconf.tab.c_shipped
@@ -88,7 +88,6 @@
 #include <string.h>
 #include <stdbool.h>
 
-#define LKC_DIRECT_LINK
 #include "lkc.h"
 
 #define printd(mask, fmt...) if (cdebug & (mask)) printf(fmt)
diff --git a/scripts/kconfig/zconf.y b/scripts/kconfig/zconf.y
index 49fb4ab..29c391f 100644
--- a/scripts/kconfig/zconf.y
+++ b/scripts/kconfig/zconf.y
@@ -11,7 +11,6 @@
 #include <string.h>
 #include <stdbool.h>
 
-#define LKC_DIRECT_LINK
 #include "lkc.h"
 
 #define printd(mask, fmt...) if (cdebug & (mask)) printf(fmt)
-- 
1.7.3.4.574.g608b.dirty

