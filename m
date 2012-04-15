Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755019Ab2DONk4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Apr 2012 09:40:56 -0400
Received: from mx1.redhat.com ([209.132.183.28]:48250 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754661Ab2DONkx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Apr 2012 09:40:53 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: acme@redhat.com, a.p.zijlstra@chello.nl, mingo@elte.hu, paulus@samba.org,
        cjashfor@linux.vnet.ibm.com, fweisbec@gmail.com
Cc: linux-kernel@vger.kernel.org, Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 3/6] perf, tool: Add support for displaying event parser debug info
Date: Sun, 15 Apr 2012 15:40:31 +0200
Message-Id: <1334497234-5441-4-git-send-email-jolsa@redhat.com>
In-Reply-To: <1334497234-5441-1-git-send-email-jolsa@redhat.com>
References: <1334497234-5441-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding PARSER_DEBUG Makefile variable to enable building event
scanner/parser with debug enabled. This results in verbose
output right out of the scanner/parser.

It's usefull for debuging the event parser. Keeping this only
for event parser so far.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
---
 tools/perf/Makefile            |   12 +++++++++---
 tools/perf/util/parse-events.c |    6 ++++++
 2 files changed, 15 insertions(+), 3 deletions(-)

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 5f5bc9c..56f58ea 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -83,7 +83,13 @@ ifndef PERF_DEBUG
   CFLAGS_OPTIMIZE = -O6
 endif
 
-CFLAGS = -fno-omit-frame-pointer -ggdb3 -Wall -Wextra -std=gnu99 $(CFLAGS_WERROR) $(CFLAGS_OPTIMIZE) -D_FORTIFY_SOURCE=2 $(EXTRA_WARNINGS) $(EXTRA_CFLAGS)
+ifdef PARSER_DEBUG
+	PARSER_DEBUG_BISON  := -t
+	PARSER_DEBUG_FLEX   := -d
+	PARSER_DEBUG_CFLAGS := -DPARSER_DEBUG
+endif
+
+CFLAGS = -fno-omit-frame-pointer -ggdb3 -Wall -Wextra -std=gnu99 $(CFLAGS_WERROR) $(CFLAGS_OPTIMIZE) -D_FORTIFY_SOURCE=2 $(EXTRA_WARNINGS) $(EXTRA_CFLAGS) $(PARSER_DEBUG_CFLAGS)
 EXTLIBS = -lpthread -lrt -lelf -lm
 ALL_CFLAGS = $(CFLAGS) -D_LARGEFILE64_SOURCE -D_FILE_OFFSET_BITS=64 -D_GNU_SOURCE
 ALL_LDFLAGS = $(LDFLAGS)
@@ -205,10 +211,10 @@ FLEX = $(CROSS_COMPILE)flex
 BISON= $(CROSS_COMPILE)bison
 
 $(OUTPUT)util/parse-events-flex.c: util/parse-events.l
-	$(QUIET_FLEX)$(FLEX) --header-file=$(OUTPUT)util/parse-events-flex.h -t util/parse-events.l > $(OUTPUT)util/parse-events-flex.c
+	$(QUIET_FLEX)$(FLEX) --header-file=$(OUTPUT)util/parse-events-flex.h $(PARSER_DEBUG_FLEX) -t util/parse-events.l > $(OUTPUT)util/parse-events-flex.c
 
 $(OUTPUT)util/parse-events-bison.c: util/parse-events.y
-	$(QUIET_BISON)$(BISON) -v util/parse-events.y -d -o $(OUTPUT)util/parse-events-bison.c
+	$(QUIET_BISON)$(BISON) -v util/parse-events.y -d $(PARSER_DEBUG_BISON) -o $(OUTPUT)util/parse-events-bison.c
 
 $(OUTPUT)util/pmu-flex.c: util/pmu.l
 	$(QUIET_FLEX)$(FLEX) --header-file=$(OUTPUT)util/pmu-flex.h -t util/pmu.l > $(OUTPUT)util/pmu-flex.c
diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
index c7fc18a..6704978 100644
--- a/tools/perf/util/parse-events.c
+++ b/tools/perf/util/parse-events.c
@@ -23,6 +23,9 @@ struct event_symbol {
 	const char	*alias;
 };
 
+#ifdef PARSER_DEBUG
+extern int parse_events_debug;
+#endif
 int parse_events_parse(struct list_head *list, struct list_head *list_tmp,
 		       int *idx);
 
@@ -768,6 +771,9 @@ int parse_events(struct perf_evlist *evlist, const char *str, int unset __used)
 
 	buffer = parse_events__scan_string(str);
 
+#ifdef PARSER_DEBUG
+	parse_events_debug = 1;
+#endif
 	ret = parse_events_parse(&list, &list_tmp, &idx);
 
 	parse_events__flush_buffer(buffer);
-- 
1.7.7.6

