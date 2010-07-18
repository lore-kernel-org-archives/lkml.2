Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754260Ab0GRKpQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jul 2010 06:45:16 -0400
Received: from lider.pardus.org.tr ([193.140.100.216]:51818 "EHLO
	lider.pardus.org.tr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754158Ab0GRKpM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jul 2010 06:45:12 -0400
From: =?UTF-8?q?Ozan=20=C3=87a=C4=9Flayan?= <ozan@pardus.org.tr>
To: linux-kernel@vger.kernel.org
Cc: acme@redhat.com, mst@redhat.com, mingo@elte.hu
Subject: [PATCH] perf tools: Fix linking errors with --as-needed flag
Date: Sun, 18 Jul 2010 13:45:37 +0300
Message-Id: <1279449937-29115-1-git-send-email-ozan@pardus.org.tr>
X-Mailer: git-send-email 1.7.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

External shared libraries should never be appended to the LDFLAGS as
this messes the linking order. As EXTLIBS collects those libraries,
it seems that perl and python libraries  should also be appended
to EXTLIBS.

Also fix the broken linking order.

See:
  http://www.gentoo.org/proj/en/qa/asneeded.xml

Signed-off-by: Ozan Çağlayan <ozan@pardus.org.tr>
---
 tools/perf/Makefile |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 3d8f31e..98c537f 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -580,7 +580,7 @@ endif
 ifneq ($(shell sh -c "(echo '\#include <EXTERN.h>'; echo '\#include <perl.h>'; echo 'int main(void) { perl_alloc(); return 0; }') | $(CC) -x c - $(PERL_EMBED_CCOPTS) -o $(BITBUCKET) $(PERL_EMBED_LDOPTS) > /dev/null 2>&1 && echo y"), y)
 	BASIC_CFLAGS += -DNO_LIBPERL
 else
-	ALL_LDFLAGS += $(PERL_EMBED_LDOPTS)
+	EXTLIBS += $(PERL_EMBED_LDOPTS)
 	LIB_OBJS += $(OUTPUT)util/scripting-engines/trace-event-perl.o
 	LIB_OBJS += $(OUTPUT)scripts/perl/Perf-Trace-Util/Context.o
 endif
@@ -593,7 +593,7 @@ endif
 ifneq ($(shell sh -c "(echo '\#include <Python.h>'; echo 'int main(void) { Py_Initialize(); return 0; }') | $(CC) -x c - $(PYTHON_EMBED_CCOPTS) -o $(BITBUCKET) $(PYTHON_EMBED_LDOPTS) > /dev/null 2>&1 && echo y"), y)
 	BASIC_CFLAGS += -DNO_LIBPYTHON
 else
-	ALL_LDFLAGS += $(PYTHON_EMBED_LDOPTS)
+	EXTLIBS += $(PYTHON_EMBED_LDOPTS)
 	LIB_OBJS += $(OUTPUT)util/scripting-engines/trace-event-python.o
 	LIB_OBJS += $(OUTPUT)scripts/python/Perf-Trace-Util/Context.o
 endif
@@ -886,8 +886,8 @@ $(OUTPUT)perf.o: perf.c $(OUTPUT)common-cmds.h $(OUTPUT)PERF-CFLAGS
 		$(ALL_CFLAGS) -c $(filter %.c,$^) -o $@
 
 $(OUTPUT)perf$X: $(OUTPUT)perf.o $(BUILTIN_OBJS) $(PERFLIBS)
-	$(QUIET_LINK)$(CC) $(ALL_CFLAGS) -o $@ $(OUTPUT)perf.o \
-		$(BUILTIN_OBJS) $(ALL_LDFLAGS) $(LIBS)
+	$(QUIET_LINK)$(CC) $(ALL_CFLAGS) $(ALL_LDFLAGS) $(OUTPUT)perf.o \
+		$(BUILTIN_OBJS) $(LIBS) -o $@
 
 $(OUTPUT)builtin-help.o: builtin-help.c $(OUTPUT)common-cmds.h $(OUTPUT)PERF-CFLAGS
 	$(QUIET_CC)$(CC) -o $@ -c $(ALL_CFLAGS) \
-- 
1.7.1

