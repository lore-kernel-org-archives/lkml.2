Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754355Ab2HTEpN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 00:45:13 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:61856 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753895Ab2HTEpI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 00:45:08 -0400
From: David Ahern <dsahern@gmail.com>
To: acme@ghostprotocols.net, linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, peterz@infradead.org, fweisbec@gmail.com,
        eranian@google.com, namhyung@kernel.org, jolsa@redhat.com,
        David Ahern <dsahern@gmail.com>
Subject: [RFC PATCH 2/7] perf: make perl support based on CONFIG_LIBPERL
Date: Sun, 19 Aug 2012 22:44:46 -0600
Message-Id: <1345437891-78830-3-git-send-email-dsahern@gmail.com>
X-Mailer: git-send-email 1.7.10.1
In-Reply-To: <1345437891-78830-1-git-send-email-dsahern@gmail.com>
References: <1345437891-78830-1-git-send-email-dsahern@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: David Ahern <dsahern@gmail.com>
---
 tools/perf/Makefile                     |   25 +++++++++++--------------
 tools/perf/config/feature-tests.mak     |    2 +-
 tools/perf/util/trace-event-scripting.c |   13 +++++++------
 3 files changed, 19 insertions(+), 21 deletions(-)

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 70b4ae9..a447aa8 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -16,8 +16,6 @@ include config/utilities.mak
 #
 # Define CROSS_COMPILE as prefix name of compiler if you want cross-builds.
 #
-# Define NO_LIBPERL to disable perl script extension.
-#
 # Define NO_LIBPYTHON to disable python script extension.
 #
 # Define PYTHON to point to the python binary if the default
@@ -614,23 +612,22 @@ else
 	endif
 endif
 
-ifdef NO_LIBPERL
-	BASIC_CFLAGS += -DNO_LIBPERL
-else
+ifdef CONFIG_LIBPERL
        PERL_EMBED_LDOPTS = $(shell perl -MExtUtils::Embed -e ldopts 2>/dev/null)
        PERL_EMBED_LDFLAGS = $(call strip-libs,$(PERL_EMBED_LDOPTS))
        PERL_EMBED_LIBADD = $(call grep-libs,$(PERL_EMBED_LDOPTS))
 	PERL_EMBED_CCOPTS = `perl -MExtUtils::Embed -e ccopts 2>/dev/null`
 	FLAGS_PERL_EMBED=$(PERL_EMBED_CCOPTS) $(PERL_EMBED_LDOPTS)
-
-	ifneq ($(call try-cc,$(SOURCE_PERL_EMBED),$(FLAGS_PERL_EMBED)),y)
-		BASIC_CFLAGS += -DNO_LIBPERL
-	else
-               ALL_LDFLAGS += $(PERL_EMBED_LDFLAGS)
-               EXTLIBS += $(PERL_EMBED_LIBADD)
-		LIB_OBJS += $(OUTPUT)util/scripting-engines/trace-event-perl.o
-		LIB_OBJS += $(OUTPUT)scripts/perl/Perf-Trace-Util/Context.o
-	endif
+       ifneq ($(call try-cc,$(SOURCE_PERL_EMBED),$(FLAGS_PERL_EMBED)),y)
+           $(warning perl module ExtUtils::Embed is not installed)
+           $(warning Install it or unset CONFIG_LIBPERL to continue)
+           $(error )
+       endif
+
+       ALL_LDFLAGS += $(PERL_EMBED_LDFLAGS)
+       EXTLIBS += $(PERL_EMBED_LIBADD)
+       LIB_OBJS += $(OUTPUT)util/scripting-engines/trace-event-perl.o
+       LIB_OBJS += $(OUTPUT)scripts/perl/Perf-Trace-Util/Context.o
 endif
 
 disable-python = $(eval $(disable-python_code))
diff --git a/tools/perf/config/feature-tests.mak b/tools/perf/config/feature-tests.mak
index 2f1156a..0145c05 100644
--- a/tools/perf/config/feature-tests.mak
+++ b/tools/perf/config/feature-tests.mak
@@ -93,7 +93,7 @@ int main(void)
 endef
 endif
 
-ifndef NO_LIBPERL
+ifdef CONFIG_LIBPERL
 define SOURCE_PERL_EMBED
 #include <EXTERN.h>
 #include <perl.h>
diff --git a/tools/perf/util/trace-event-scripting.c b/tools/perf/util/trace-event-scripting.c
index 302ff26..edaed05 100644
--- a/tools/perf/util/trace-event-scripting.c
+++ b/tools/perf/util/trace-event-scripting.c
@@ -27,6 +27,7 @@
 #include "../perf.h"
 #include "util.h"
 #include "trace-event.h"
+#include "generated/autoconf.h"
 
 struct scripting_context *scripting_context;
 
@@ -108,7 +109,7 @@ void setup_python_scripting(void)
 static void print_perl_unsupported_msg(void)
 {
 	fprintf(stderr, "Perl scripting not supported."
-		"  Install libperl and rebuild perf to enable it.\n"
+		"  Enable CONFIG_LIBPERL and rebuild perf.\n"
 		"For example:\n  # apt-get install libperl-dev (ubuntu)"
 		"\n  # yum install 'perl(ExtUtils::Embed)' (Fedora)"
 		"\n  etc.\n");
@@ -153,16 +154,16 @@ static void register_perl_scripting(struct scripting_ops *scripting_ops)
 	scripting_context = malloc(sizeof(struct scripting_context));
 }
 
-#ifdef NO_LIBPERL
+#ifdef CONFIG_LIBPERL
+extern struct scripting_ops perl_scripting_ops;
+
 void setup_perl_scripting(void)
 {
-	register_perl_scripting(&perl_scripting_unsupported_ops);
+	register_perl_scripting(&perl_scripting_ops);
 }
 #else
-extern struct scripting_ops perl_scripting_ops;
-
 void setup_perl_scripting(void)
 {
-	register_perl_scripting(&perl_scripting_ops);
+	register_perl_scripting(&perl_scripting_unsupported_ops);
 }
 #endif
-- 
1.7.10.1

