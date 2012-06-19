Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754725Ab2FSSDJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2012 14:03:09 -0400
Received: from merlin.infradead.org ([205.233.59.134]:33394 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753174Ab2FSSAP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2012 14:00:15 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 09/20] perf evsel: Carve out event modifier formatting
Date: Tue, 19 Jun 2012 14:50:10 -0300
Message-Id: <1340128221-17348-10-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
In-Reply-To: <1340128221-17348-1-git-send-email-acme@infradead.org>
References: <1340128221-17348-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="UTF-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

>From perf_evsel__hw_name, so that we can use it for the other kinds of
events (tracepoints, software, hw cache, etc).

Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-9gmd5wewsrvtny8tzxjfp471@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/evsel.c |   17 +++++++++++------
 1 files changed, 11 insertions(+), 6 deletions(-)

diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
index 9f6cebd..dab8938 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -86,16 +86,15 @@ const char *__perf_evsel__hw_name(u64 config)
 	return "unknown-hardware";
 }
 
-static int perf_evsel__hw_name(struct perf_evsel *evsel, char *bf, size_t size)
+static int perf_evsel__add_modifiers(struct perf_evsel *evsel, char *bf, size_t size)
 {
-	int colon = 0;
+	int colon = 0, r = 0;
 	struct perf_event_attr *attr = &evsel->attr;
-	int r = scnprintf(bf, size, "%s", __perf_evsel__hw_name(attr->config));
 	bool exclude_guest_default = false;
 
 #define MOD_PRINT(context, mod)	do {					\
 		if (!attr->exclude_##context) {				\
-			if (!colon) colon = r++;			\
+			if (!colon) colon = ++r;			\
 			r += scnprintf(bf + r, size - r, "%c", mod);	\
 		} } while(0)
 
@@ -108,7 +107,7 @@ static int perf_evsel__hw_name(struct perf_evsel *evsel, char *bf, size_t size)
 
 	if (attr->precise_ip) {
 		if (!colon)
-			colon = r++;
+			colon = ++r;
 		r += scnprintf(bf + r, size - r, "%.*s", attr->precise_ip, "ppp");
 		exclude_guest_default = true;
 	}
@@ -119,10 +118,16 @@ static int perf_evsel__hw_name(struct perf_evsel *evsel, char *bf, size_t size)
 	}
 #undef MOD_PRINT
 	if (colon)
-		bf[colon] = ':';
+		bf[colon - 1] = ':';
 	return r;
 }
 
+static int perf_evsel__hw_name(struct perf_evsel *evsel, char *bf, size_t size)
+{
+	int r = scnprintf(bf, size, "%s", __perf_evsel__hw_name(evsel->attr.config));
+	return r + perf_evsel__add_modifiers(evsel, bf + r, size - r);
+}
+
 int perf_evsel__name(struct perf_evsel *evsel, char *bf, size_t size)
 {
 	int ret;
-- 
1.7.1

