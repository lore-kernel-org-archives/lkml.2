Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753391Ab2DMST2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2012 14:19:28 -0400
Received: from terminus.zytor.com ([198.137.202.10]:51705 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751581Ab2DMST0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2012 14:19:26 -0400
Date: Fri, 13 Apr 2012 11:18:50 -0700
From: tip-bot for Jiri Olsa <jolsa@redhat.com>
Message-ID: <tip-024e6c9747bb274c9d744ad52a987a0ebec528a6@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@kernel.org, a.p.zijlstra@chello.nl,
        jolsa@redhat.com, fweisbec@gmail.com, tglx@linutronix.de,
        cjashfor@linux.vnet.ibm.com, mingo@elte.hu
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        jolsa@redhat.com, fweisbec@gmail.com, tglx@linutronix.de,
        cjashfor@linux.vnet.ibm.com, mingo@elte.hu
In-Reply-To: <1334140791-3024-1-git-send-email-jolsa@redhat.com>
References: <1334140791-3024-1-git-send-email-jolsa@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools: Fix parsers' rules to dependencies
Git-Commit-ID: 024e6c9747bb274c9d744ad52a987a0ebec528a6
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Fri, 13 Apr 2012 11:18:56 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  024e6c9747bb274c9d744ad52a987a0ebec528a6
Gitweb:     http://git.kernel.org/tip/024e6c9747bb274c9d744ad52a987a0ebec528a6
Author:     Jiri Olsa <jolsa@redhat.com>
AuthorDate: Wed, 11 Apr 2012 12:39:51 +0200
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 11 Apr 2012 16:57:09 -0300

perf tools: Fix parsers' rules to dependencies

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
 1 files changed, 8 insertions(+), 11 deletions(-)

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 4ca77cc..b28b610 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -204,21 +204,20 @@ export PERL_PATH
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
 
@@ -807,8 +806,6 @@ help:
 	@echo '  html		- make html documentation'
 	@echo '  info		- make GNU info documentation (access with info <foo>)'
 	@echo '  pdf		- make pdf documentation'
-	@echo '  event-parser	- make event parser code'
-	@echo '  pmu-parser	- make pmu format parser code'
 	@echo '  TAGS		- use etags to make tag information for source browsing'
 	@echo '  tags		- use ctags to make tag information for source browsing'
 	@echo '  cscope	- use cscope to make interactive browsing database'
