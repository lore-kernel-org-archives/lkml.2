Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758624Ab2I1Qda (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 12:33:30 -0400
Received: from terminus.zytor.com ([198.137.202.10]:41949 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758505Ab2I1Qd3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 12:33:29 -0400
Date: Fri, 28 Sep 2012 09:33:05 -0700
From: tip-bot for Arnaldo Carvalho de Melo <acme@redhat.com>
Message-ID: <tip-9v4zl7ldlp8v6azrpsu5lupk@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, paulus@samba.org,
        acme@redhat.com, hpa@zytor.com, mingo@kernel.org, peterz@infradead.org,
        efault@gmx.de, namhyung@gmail.com, jolsa@redhat.com,
        fweisbec@gmail.com, dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, efault@gmx.de,
        peterz@infradead.org, namhyung@gmail.com, jolsa@redhat.com,
        fweisbec@gmail.com, dsahern@gmail.com, tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools:
  Use perf_evsel__newtp in the event parser
Git-Commit-ID: 82fe1c290cd26a3d092beb1e9755647d284a4134
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Fri, 28 Sep 2012 09:33:10 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  82fe1c290cd26a3d092beb1e9755647d284a4134
Gitweb:     http://git.kernel.org/tip/82fe1c290cd26a3d092beb1e9755647d284a4134
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Wed, 26 Sep 2012 17:13:07 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 26 Sep 2012 18:29:19 -0300

perf tools: Use perf_evsel__newtp in the event parser

Elliminating code duplication.

Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-9v4zl7ldlp8v6azrpsu5lupk@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/parse-events.c |   46 ++++++++++++++--------------------------
 1 files changed, 16 insertions(+), 30 deletions(-)

diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
index bf5d033..aed38e4 100644
--- a/tools/perf/util/parse-events.c
+++ b/tools/perf/util/parse-events.c
@@ -356,42 +356,28 @@ int parse_events_add_cache(struct list_head **list, int *idx,
 	return add_event(list, idx, &attr, name);
 }
 
-static int add_tracepoint(struct list_head **list, int *idx,
+static int add_tracepoint(struct list_head **listp, int *idx,
 			  char *sys_name, char *evt_name)
 {
-	struct perf_event_attr attr;
-	char name[MAX_NAME_LEN];
-	char evt_path[MAXPATHLEN];
-	char id_buf[4];
-	u64 id;
-	int fd;
-
-	snprintf(evt_path, MAXPATHLEN, "%s/%s/%s/id", tracing_events_path,
-		 sys_name, evt_name);
-
-	fd = open(evt_path, O_RDONLY);
-	if (fd < 0)
-		return -1;
+	struct perf_evsel *evsel;
+	struct list_head *list = *listp;
 
-	if (read(fd, id_buf, sizeof(id_buf)) < 0) {
-		close(fd);
-		return -1;
+	if (!list) {
+		list = malloc(sizeof(*list));
+		if (!list)
+			return -ENOMEM;
+		INIT_LIST_HEAD(list);
 	}
 
-	close(fd);
-	id = atoll(id_buf);
-
-	memset(&attr, 0, sizeof(attr));
-	attr.config = id;
-	attr.type = PERF_TYPE_TRACEPOINT;
-	attr.sample_type |= PERF_SAMPLE_RAW;
-	attr.sample_type |= PERF_SAMPLE_TIME;
-	attr.sample_type |= PERF_SAMPLE_CPU;
-	attr.sample_type |= PERF_SAMPLE_PERIOD;
-	attr.sample_period = 1;
+	evsel = perf_evsel__newtp(sys_name, evt_name, (*idx)++);
+	if (!evsel) {
+		free(list);
+		return -ENOMEM;
+	}
 
-	snprintf(name, MAX_NAME_LEN, "%s:%s", sys_name, evt_name);
-	return add_event(list, idx, &attr, name);
+	list_add_tail(&evsel->node, list);
+	*listp = list;
+	return 0;
 }
 
 static int add_tracepoint_multi(struct list_head **list, int *idx,
