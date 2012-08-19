Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754246Ab2HSPqv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Aug 2012 11:46:51 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:35086 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753656Ab2HSPqs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Aug 2012 11:46:48 -0400
From: David Ahern <dsahern@gmail.com>
To: acme@ghostprotocols.net, linux-kernel@vger.kernel.org
Cc: David Ahern <dsahern@gmail.com>, Pekka Enberg <penberg@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>
Subject: [PATCH] perf: silence GTK2 probing errors
Date: Sun, 19 Aug 2012 09:46:42 -0600
Message-Id: <1345391202-71865-1-git-send-email-dsahern@gmail.com>
X-Mailer: git-send-email 1.7.10.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If GTK2 development packages are not installed, make is rather noisy:

$ make -C tools/perf O=/tmp/pbuild
Package gtk+-2.0 was not found in the pkg-config search path.
Perhaps you should add the directory containing `gtk+-2.0.pc'
to the PKG_CONFIG_PATH environment variable
No package 'gtk+-2.0' found
make: Entering directory `/opt/sw/ahern/perf.git/tools/perf'
Makefile:593: GTK2 not found, disables GTK2 support. Please install gtk2-devel or libgtk2.0-dev
PERF_VERSION = 3.6.rc1.205.gdb146f.dirty
make: Leaving directory `/opt/sw/ahern/perf.git/tools/perf'
Package gtk+-2.0 was not found in the pkg-config search path.
Perhaps you should add the directory containing `gtk+-2.0.pc'
to the PKG_CONFIG_PATH environment variable
No package 'gtk+-2.0' found
make: Entering directory `/opt/sw/ahern/perf.git/tools/perf'
Makefile:593: GTK2 not found, disables GTK2 support. Please install gtk2-devel or libgtk2.0-dev
...

Silence the pkg-config errors. Aftewards:

$ make -C tools/perf O=/tmp/pbuild
make: Entering directory `/opt/sw/ahern/perf.git/tools/perf'
Makefile:593: GTK2 not found, disables GTK2 support. Please install gtk2-devel or libgtk2.0-dev
PERF_VERSION = 3.6.rc1.206.gd43ff9.dirty
make: Leaving directory `/opt/sw/ahern/perf.git/tools/perf'
make: Entering directory `/opt/sw/ahern/perf.git/tools/perf'
Makefile:593: GTK2 not found, disables GTK2 support. Please install gtk2-devel or libgtk2.0-dev
...

Signed-off-by: David Ahern <dsahern@gmail.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/Makefile |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 1eb7f12..90cfecf 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -588,7 +588,7 @@ endif
 ifdef NO_GTK2
 	BASIC_CFLAGS += -DNO_GTK2_SUPPORT
 else
-	FLAGS_GTK2=$(ALL_CFLAGS) $(ALL_LDFLAGS) $(EXTLIBS) $(shell pkg-config --libs --cflags gtk+-2.0)
+	FLAGS_GTK2=$(ALL_CFLAGS) $(ALL_LDFLAGS) $(EXTLIBS) $(shell pkg-config --libs --cflags gtk+-2.0 2>/dev/null)
 	ifneq ($(call try-cc,$(SOURCE_GTK2),$(FLAGS_GTK2)),y)
 		msg := $(warning GTK2 not found, disables GTK2 support. Please install gtk2-devel or libgtk2.0-dev);
 		BASIC_CFLAGS += -DNO_GTK2_SUPPORT
@@ -596,8 +596,8 @@ else
 		ifeq ($(call try-cc,$(SOURCE_GTK2_INFOBAR),$(FLAGS_GTK2)),y)
 			BASIC_CFLAGS += -DHAVE_GTK_INFO_BAR
 		endif
-		BASIC_CFLAGS += $(shell pkg-config --cflags gtk+-2.0)
-		EXTLIBS += $(shell pkg-config --libs gtk+-2.0)
+		BASIC_CFLAGS += $(shell pkg-config --cflags gtk+-2.0 2>/dev/null)
+		EXTLIBS += $(shell pkg-config --libs gtk+-2.0 2>/dev/null)
 		LIB_OBJS += $(OUTPUT)ui/gtk/browser.o
 		LIB_OBJS += $(OUTPUT)ui/gtk/setup.o
 		LIB_OBJS += $(OUTPUT)ui/gtk/util.o
-- 
1.7.10.1

