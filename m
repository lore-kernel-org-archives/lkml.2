Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757241Ab2FTQwi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 12:52:38 -0400
Received: from terminus.zytor.com ([198.137.202.10]:38183 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751738Ab2FTQwg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 12:52:36 -0400
Date: Wed, 20 Jun 2012 09:52:05 -0700
From: tip-bot for Arnaldo Carvalho de Melo <acme@redhat.com>
Message-ID: <tip-9gmd5wewsrvtny8tzxjfp471@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, paulus@samba.org,
        acme@redhat.com, hpa@zytor.com, mingo@kernel.org, peterz@infradead.org,
        efault@gmx.de, namhyung@gmail.com, jolsa@redhat.com,
        fweisbec@gmail.com, dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, efault@gmx.de,
        peterz@infradead.org, namhyung@gmail.com, jolsa@redhat.com,
        fweisbec@gmail.com, dsahern@gmail.com, tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf evsel: Carve out event modifier formatting
Git-Commit-ID: 27f18617b01dbbc928e9bd3731d1766222fb7e0d
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Wed, 20 Jun 2012 09:52:11 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  27f18617b01dbbc928e9bd3731d1766222fb7e0d
Gitweb:     http://git.kernel.org/tip/27f18617b01dbbc928e9bd3731d1766222fb7e0d
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Mon, 11 Jun 2012 13:33:09 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Tue, 19 Jun 2012 13:06:20 -0300

perf evsel: Carve out event modifier formatting

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
