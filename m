Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754537Ab0HYXiz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Aug 2010 19:38:55 -0400
Received: from casper.infradead.org ([85.118.1.10]:49748 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752214Ab0HYXhH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Aug 2010 19:37:07 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Tom Zanussi <tzanussi@gmail.com>,
        =?utf-8?q?Ozan=20=C3=87a=C4=9Flayan?= <ozan@pardus.org.tr>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 6/6] perf tools: Fix linking errors with --as-needed flag
Date: Wed, 25 Aug 2010 20:36:55 -0300
Message-Id: <1282779415-8544-7-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1282779415-8544-1-git-send-email-acme@infradead.org>
References: <1282779415-8544-1-git-send-email-acme@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tom Zanussi <tzanussi@gmail.com>

External shared libraries should never be appended to the LDFLAGS as this
messes the linking order. As EXTLIBS collects those libraries, it seems that
perl and python libraries  should also be appended to EXTLIBS.

Also fix the broken linking order.

This is a refresh of a patch by Ozan Çağlayan and improved by both Tom Zanussi
and Kirill A. Shutemov.

Cc: Ozan Çağlayan <ozan@pardus.org.tr>
Tested-by: Kirill A. Shutemov <kirill@shutemov.name>
Tested-by: Tom Zanussi <tzanussi@gmail.com>
LKML-Reference: <1282627430.28324.8.camel@tropicana>
Signed-off-by: Tom Zanussi <tzanussi@gmail.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Makefile |   21 +++++++++++++++------
 1 files changed, 15 insertions(+), 6 deletions(-)

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 26a3f2e..fe1e307 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -313,6 +313,9 @@ TEST_PROGRAMS =
 
 SCRIPT_SH += perf-archive.sh
 
+grep-libs = $(filter -l%,$(1))
+strip-libs = $(filter-out -l%,$(1))
+
 #
 # No Perl scripts right now:
 #
@@ -588,14 +591,17 @@ endif
 ifdef NO_LIBPERL
 	BASIC_CFLAGS += -DNO_LIBPERL
 else
-	PERL_EMBED_LDOPTS = `perl -MExtUtils::Embed -e ldopts 2>/dev/null`
+       PERL_EMBED_LDOPTS = $(shell perl -MExtUtils::Embed -e ldopts 2>/dev/null)
+       PERL_EMBED_LDFLAGS = $(call strip-libs,$(PERL_EMBED_LDOPTS))
+       PERL_EMBED_LIBADD = $(call grep-libs,$(PERL_EMBED_LDOPTS))
 	PERL_EMBED_CCOPTS = `perl -MExtUtils::Embed -e ccopts 2>/dev/null`
 	FLAGS_PERL_EMBED=$(PERL_EMBED_CCOPTS) $(PERL_EMBED_LDOPTS)
 
 	ifneq ($(call try-cc,$(SOURCE_PERL_EMBED),$(FLAGS_PERL_EMBED)),y)
 		BASIC_CFLAGS += -DNO_LIBPERL
 	else
-		ALL_LDFLAGS += $(PERL_EMBED_LDOPTS)
+               ALL_LDFLAGS += $(PERL_EMBED_LDFLAGS)
+               EXTLIBS += $(PERL_EMBED_LIBADD)
 		LIB_OBJS += $(OUTPUT)util/scripting-engines/trace-event-perl.o
 		LIB_OBJS += $(OUTPUT)scripts/perl/Perf-Trace-Util/Context.o
 	endif
@@ -604,13 +610,16 @@ endif
 ifdef NO_LIBPYTHON
 	BASIC_CFLAGS += -DNO_LIBPYTHON
 else
-	PYTHON_EMBED_LDOPTS = `python-config --ldflags 2>/dev/null`
+       PYTHON_EMBED_LDOPTS = $(shell python-config --ldflags 2>/dev/null)
+       PYTHON_EMBED_LDFLAGS = $(call strip-libs,$(PYTHON_EMBED_LDOPTS))
+       PYTHON_EMBED_LIBADD = $(call grep-libs,$(PYTHON_EMBED_LDOPTS))
 	PYTHON_EMBED_CCOPTS = `python-config --cflags 2>/dev/null`
 	FLAGS_PYTHON_EMBED=$(PYTHON_EMBED_CCOPTS) $(PYTHON_EMBED_LDOPTS)
 	ifneq ($(call try-cc,$(SOURCE_PYTHON_EMBED),$(FLAGS_PYTHON_EMBED)),y)
 		BASIC_CFLAGS += -DNO_LIBPYTHON
 	else
-		ALL_LDFLAGS += $(PYTHON_EMBED_LDOPTS)
+               ALL_LDFLAGS += $(PYTHON_EMBED_LDFLAGS)
+               EXTLIBS += $(PYTHON_EMBED_LIBADD)
 		LIB_OBJS += $(OUTPUT)util/scripting-engines/trace-event-python.o
 		LIB_OBJS += $(OUTPUT)scripts/python/Perf-Trace-Util/Context.o
 	endif
@@ -919,8 +928,8 @@ $(OUTPUT)perf.o: perf.c $(OUTPUT)common-cmds.h $(OUTPUT)PERF-CFLAGS
 		$(ALL_CFLAGS) -c $(filter %.c,$^) -o $@
 
 $(OUTPUT)perf$X: $(OUTPUT)perf.o $(BUILTIN_OBJS) $(PERFLIBS)
-	$(QUIET_LINK)$(CC) $(ALL_CFLAGS) -o $@ $(OUTPUT)perf.o \
-		$(BUILTIN_OBJS) $(ALL_LDFLAGS) $(LIBS)
+	$(QUIET_LINK)$(CC) $(ALL_CFLAGS) $(ALL_LDFLAGS) $(OUTPUT)perf.o \
+               $(BUILTIN_OBJS) $(LIBS) -o $@
 
 $(OUTPUT)builtin-help.o: builtin-help.c $(OUTPUT)common-cmds.h $(OUTPUT)PERF-CFLAGS
 	$(QUIET_CC)$(CC) -o $@ -c $(ALL_CFLAGS) \
-- 
1.6.2.5

