Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757272Ab2HTQ1F (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 12:27:05 -0400
Received: from casper.infradead.org ([85.118.1.10]:56607 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754287Ab2HTQ0j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 12:26:39 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Namhyung Kim <namhyung@kernel.org>, Pekka Enberg <penberg@kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 20/24] perf: silence GTK2 probing errors
Date: Mon, 20 Aug 2012 13:26:21 -0300
Message-Id: <1345479985-18669-21-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
In-Reply-To: <1345479985-18669-1-git-send-email-acme@infradead.org>
References: <1345479985-18669-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="UTF-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Ahern <dsahern@gmail.com>

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
Acked-by: Namhyung Kim <namhyung@kernel.org>
Acked-by: Pekka Enberg <penberg@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Pekka Enberg <penberg@kernel.org>
Link: http://lkml.kernel.org/r/1345391202-71865-1-git-send-email-dsahern@gmail.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Makefile |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 75af93d..8beff99 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -587,7 +587,7 @@ endif
 ifdef NO_GTK2
 	BASIC_CFLAGS += -DNO_GTK2_SUPPORT
 else
-	FLAGS_GTK2=$(ALL_CFLAGS) $(ALL_LDFLAGS) $(EXTLIBS) $(shell pkg-config --libs --cflags gtk+-2.0)
+	FLAGS_GTK2=$(ALL_CFLAGS) $(ALL_LDFLAGS) $(EXTLIBS) $(shell pkg-config --libs --cflags gtk+-2.0 2>/dev/null)
 	ifneq ($(call try-cc,$(SOURCE_GTK2),$(FLAGS_GTK2)),y)
 		msg := $(warning GTK2 not found, disables GTK2 support. Please install gtk2-devel or libgtk2.0-dev);
 		BASIC_CFLAGS += -DNO_GTK2_SUPPORT
@@ -595,8 +595,8 @@ else
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
1.7.1

