Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755792Ab2DNREI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Apr 2012 13:04:08 -0400
Received: from casper.infradead.org ([85.118.1.10]:36455 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755741Ab2DNRED (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Apr 2012 13:04:03 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Jiri Olsa <jolsa@redhat.com>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 3/5] perf tools: Fix parsers' rules to dependencies
Date: Sat, 14 Apr 2012 14:03:45 -0300
Message-Id: <1334423027-2220-4-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
In-Reply-To: <1334423027-2220-1-git-send-email-acme@infradead.org>
References: <1334423027-2220-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Olsa <jolsa@redhat.com>

Currently the parsers objects (bison/flex related) are each time perf
is built. No matter the generated files are already in place, the
parser generation is executed every time.

Changing the rules to have proper flex/bison objects generation
dependencies.

The parsers code is not rebuilt until the flex/bison source files
are touched. Also when flex/bison source is changed, only dependent
objects are rebuilt.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1334140791-3024-1-git-send-email-jolsa@redhat.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Makefile |   19 ++++++++-----------
 1 file changed, 8 insertions(+), 11 deletions(-)

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index a20d0c5..03059e7 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -237,21 +237,20 @@ export PERL_PATH
 FLEX = $(CROSS_COMPILE)flex
 BISON= $(CROSS_COMPILE)bison
 
-event-parser:
-	$(QUIET_BISON)$(BISON) -v util/parse-events.y -d -o $(OUTPUT)util/parse-events-bison.c
+$(OUTPUT)util/parse-events-flex.c: util/parse-events.l
 	$(QUIET_FLEX)$(FLEX) --header-file=$(OUTPUT)util/parse-events-flex.h -t util/parse-events.l > $(OUTPUT)util/parse-events-flex.c
 
-$(OUTPUT)util/parse-events-flex.c: event-parser
-$(OUTPUT)util/parse-events-bison.c: event-parser
+$(OUTPUT)util/parse-events-bison.c: util/parse-events.y
+	$(QUIET_BISON)$(BISON) -v util/parse-events.y -d -o $(OUTPUT)util/parse-events-bison.c
 
-pmu-parser:
-	$(QUIET_BISON)$(BISON) -v util/pmu.y -d -o $(OUTPUT)util/pmu-bison.c
+$(OUTPUT)util/pmu-flex.c: util/pmu.l
 	$(QUIET_FLEX)$(FLEX) --header-file=$(OUTPUT)util/pmu-flex.h -t util/pmu.l > $(OUTPUT)util/pmu-flex.c
 
-$(OUTPUT)util/pmu-flex.c: pmu-parser
-$(OUTPUT)util/pmu-bison.c: pmu-parser
+$(OUTPUT)util/pmu-bison.c: util/pmu.y
+	$(QUIET_BISON)$(BISON) -v util/pmu.y -d -o $(OUTPUT)util/pmu-bison.c
 
-$(OUTPUT)util/parse-events.o: event-parser pmu-parser
+$(OUTPUT)util/parse-events.o: $(OUTPUT)util/parse-events-flex.c $(OUTPUT)util/parse-events-bison.c
+$(OUTPUT)util/pmu.o: $(OUTPUT)util/pmu-flex.c $(OUTPUT)util/pmu-bison.c
 
 LIB_FILE=$(OUTPUT)libperf.a
 
@@ -852,8 +851,6 @@ help:
 	@echo '  html		- make html documentation'
 	@echo '  info		- make GNU info documentation (access with info <foo>)'
 	@echo '  pdf		- make pdf documentation'
-	@echo '  event-parser	- make event parser code'
-	@echo '  pmu-parser	- make pmu format parser code'
 	@echo '  TAGS		- use etags to make tag information for source browsing'
 	@echo '  tags		- use ctags to make tag information for source browsing'
 	@echo '  cscope	- use cscope to make interactive browsing database'
-- 
1.7.9.2.358.g22243

