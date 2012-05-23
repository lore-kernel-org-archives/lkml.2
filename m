Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965157Ab2EWPSc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 11:18:32 -0400
Received: from terminus.zytor.com ([198.137.202.10]:40755 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932438Ab2EWPS2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 11:18:28 -0400
Date: Wed, 23 May 2012 08:18:07 -0700
From: tip-bot for Jiri Olsa <jolsa@redhat.com>
Message-ID: <tip-82ba1f2f614871b388cb1bd58594507b6f0f2b79@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@kernel.org, a.p.zijlstra@chello.nl,
        jolsa@redhat.com, fweisbec@gmail.com, tglx@linutronix.de,
        cjashfor@linux.vnet.ibm.com, mingo@elte.hu
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        jolsa@redhat.com, fweisbec@gmail.com, tglx@linutronix.de,
        cjashfor@linux.vnet.ibm.com, mingo@elte.hu
In-Reply-To: <1337584373-2741-3-git-send-email-jolsa@redhat.com>
References: <1337584373-2741-3-git-send-email-jolsa@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools:
  Add support for displaying event parser debug info
Git-Commit-ID: 82ba1f2f614871b388cb1bd58594507b6f0f2b79
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Wed, 23 May 2012 08:18:12 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  82ba1f2f614871b388cb1bd58594507b6f0f2b79
Gitweb:     http://git.kernel.org/tip/82ba1f2f614871b388cb1bd58594507b6f0f2b79
Author:     Jiri Olsa <jolsa@redhat.com>
AuthorDate: Mon, 21 May 2012 09:12:50 +0200
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Tue, 22 May 2012 11:21:17 -0300

perf tools: Add support for displaying event parser debug info

Adding PARSER_DEBUG Makefile variable to enable building event scanner/
parser with debug enabled. This results in verbose output right out of
the scanner/parser.

It's useful for debuging the event parser. Keeping this only for event
parser so far.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1337584373-2741-3-git-send-email-jolsa@redhat.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Makefile            |   12 +++++++++---
 tools/perf/util/parse-events.c |    6 ++++++
 2 files changed, 15 insertions(+), 3 deletions(-)

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 91840e1..b246236 100644
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
@@ -216,10 +222,10 @@ FLEX = flex
 BISON= bison
 
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
