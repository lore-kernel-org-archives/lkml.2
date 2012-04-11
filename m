Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756674Ab2DKKkZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 06:40:25 -0400
Received: from mx1.redhat.com ([209.132.183.28]:53458 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754394Ab2DKKkY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 06:40:24 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: acme@redhat.com, a.p.zijlstra@chello.nl, mingo@elte.hu, paulus@samba.org,
        cjashfor@linux.vnet.ibm.com, fweisbec@gmail.com
Cc: linux-kernel@vger.kernel.org, Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH] perf, tool: Fix parsers' rules to dependencies
Date: Wed, 11 Apr 2012 12:39:51 +0200
Message-Id: <1334140791-3024-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently the parsers objects (bison/flex related) are each time perf
is built. No matter the generated files are already in place, the
parser generation is executed every time.

Changing the rules to have proper flex/bison objects generation
dependencies.

The parsers code is not rebuilt until the flex/bison source files
are touched. Also when flex/bison source is changed, only dependent
objects are rebuilt.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
---
 tools/perf/Makefile |   19 ++++++++-----------
 1 files changed, 8 insertions(+), 11 deletions(-)

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 820371f..733336c 100644
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
1.7.7.6

