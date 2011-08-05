Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755449Ab1HEVNI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Aug 2011 17:13:08 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:62677 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751407Ab1HEVND (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Aug 2011 17:13:03 -0400
X-Authority-Analysis: v=1.1 cv=s3eDhkhcaTLnj7IEXy8aaXUiY7FbET0mf+/2Xe0elbc= c=1 sm=0 a=vhdKIqpQuCYA:10 a=39dG3meRHKMA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=20KFwNOVAAAA:8 a=meVymXHHAAAA:8 a=NaTZ4S0qyEtckgpg4yAA:9 a=eB3aUe6L9nZEBAWe4voA:7 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Message-Id: <20110805211301.139671431@goodmis.org>
User-Agent: quilt/0.48-1
Date: Fri, 05 Aug 2011 16:59:24 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Borislav Petkov <bp@alien8.de>, Arjan van de Ven <arjan@infradead.org>
Subject: [RFC][PATCH 3/8] perf: Build libparsevent.a
References: <20110805205921.909038487@goodmis.org>
Content-Disposition: inline; filename=0003-perf-Build-libparsevent.a.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

Have building perf also build libparsevent.a. Currently, perf does
not use the code within libparsevent.a, but it soon will.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 tools/perf/Makefile |   11 ++++++++++-
 1 files changed, 10 insertions(+), 1 deletions(-)

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index ebf38c1..0ea25c9 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -1,5 +1,6 @@
 ifeq ("$(origin O)", "command line")
 	OUTPUT := $(O)/
+	COMMAND_O := O=$(O)
 endif
 
 # The default target of this Makefile is...
@@ -187,6 +188,9 @@ $(OUTPUT)python/perf.so: $(PYRF_OBJS)
 
 SCRIPTS = $(patsubst %.sh,%,$(SCRIPT_SH))
 
+EVENT_PARSE_DIR = ../lib/events/
+LIBPARSEVENT = $(OUTPUT)$(EVENT_PARSE_DIR)libparsevent.a
+
 #
 # Single 'perf' binary right now:
 #
@@ -286,6 +290,7 @@ LIB_H += util/cpumap.h
 LIB_H += util/top.h
 LIB_H += $(ARCH_INCLUDE)
 LIB_H += util/cgroup.h
+LIB_H += $(EVENT_PARSE_DIR)event-parse.h
 
 LIB_OBJS += $(OUTPUT)util/abspath.o
 LIB_OBJS += $(OUTPUT)util/alias.o
@@ -663,7 +668,7 @@ $(OUTPUT)perf.o: perf.c $(OUTPUT)common-cmds.h $(OUTPUT)PERF-CFLAGS
 		'-DPERF_HTML_PATH="$(htmldir_SQ)"' \
 		$(ALL_CFLAGS) -c $(filter %.c,$^) -o $@
 
-$(OUTPUT)perf: $(OUTPUT)perf.o $(BUILTIN_OBJS) $(PERFLIBS)
+$(OUTPUT)perf: $(OUTPUT)perf.o $(BUILTIN_OBJS) $(PERFLIBS) $(LIBPARSEVENT)
 	$(QUIET_LINK)$(CC) $(ALL_CFLAGS) $(ALL_LDFLAGS) $(OUTPUT)perf.o \
                $(BUILTIN_OBJS) $(LIBS) -o $@
 
@@ -756,6 +761,10 @@ $(sort $(dir $(DIRECTORY_DEPS))):
 $(LIB_FILE): $(LIB_OBJS)
 	$(QUIET_AR)$(RM) $@ && $(AR) rcs $@ $(LIB_OBJS)
 
+# libparsevent.a
+$(LIBPARSEVENT):
+	make -C $(EVENT_PARSE_DIR) $(COMMAND_O) libparsevent.a
+
 help:
 	@echo 'Perf make targets:'
 	@echo '  doc		- make *all* documentation (see below)'
-- 
1.7.5.4


