Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756759Ab2DDUWL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2012 16:22:11 -0400
Received: from mx1.redhat.com ([209.132.183.28]:9565 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751988Ab2DDUWI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2012 16:22:08 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: acme@redhat.com, a.p.zijlstra@chello.nl, mingo@elte.hu, paulus@samba.org,
        cjashfor@linux.vnet.ibm.com, fweisbec@gmail.com
Cc: linux-kernel@vger.kernel.org, Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 7/8] perf, tool: Add support for displaying event parser debug info
Date: Wed,  4 Apr 2012 22:21:37 +0200
Message-Id: <1333570898-10505-8-git-send-email-jolsa@redhat.com>
In-Reply-To: <1333570898-10505-1-git-send-email-jolsa@redhat.com>
References: <1333570898-10505-1-git-send-email-jolsa@redhat.com>
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
index 7546dd5..33bec3a 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -116,7 +116,13 @@ ifndef PERF_DEBUG
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
@@ -238,8 +244,8 @@ FLEX = $(CROSS_COMPILE)flex
 BISON= $(CROSS_COMPILE)bison
 
 event-parser:
-	$(QUIET_BISON)$(BISON) -v util/parse-events.y -d -o $(OUTPUT)util/parse-events-bison.c
-	$(QUIET_FLEX)$(FLEX) --header-file=$(OUTPUT)util/parse-events-flex.h -t util/parse-events.l > $(OUTPUT)util/parse-events-flex.c
+	$(QUIET_BISON)$(BISON) -v util/parse-events.y -d $(PARSER_DEBUG_BISON) -o $(OUTPUT)util/parse-events-bison.c
+	$(QUIET_FLEX)$(FLEX) --header-file=$(OUTPUT)util/parse-events-flex.h $(PARSER_DEBUG_FLEX) -t util/parse-events.l > $(OUTPUT)util/parse-events-flex.c
 
 $(OUTPUT)util/parse-events-flex.c: event-parser
 $(OUTPUT)util/parse-events-bison.c: event-parser
diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
index 076b1f8..b6136fd 100644
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
 
@@ -863,6 +866,9 @@ int parse_events(struct perf_evlist *evlist, const char *str, int unset __used)
 
 	buffer = parse_events__scan_string(str);
 
+#ifdef PARSER_DEBUG
+	parse_events_debug = 1;
+#endif
 	ret = parse_events_parse(&list, &list_tmp, &idx);
 
 	parse_events__flush_buffer(buffer);
-- 
1.7.7.6

