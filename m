Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934873Ab0EEOa7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 May 2010 10:30:59 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:41405 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933610Ab0EEOa5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 May 2010 10:30:57 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Tom Zanussi <tzanussi@gmail.com>,
       Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 2/4] perf/record: simplify TRACE_INFO tracepoint check
Date: Wed,  5 May 2010 11:30:46 -0300
Message-Id: <1273069848-22934-3-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1273069848-22934-1-git-send-email-acme@infradead.org>
References: <1273069848-22934-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tom Zanussi <tzanussi@gmail.com>

Fix a couple of inefficiencies and redundancies related to
have_tracepoints() and its use when checking whether to write
TRACE_INFO.

First, there's no need to use get_tracepoints_path() in
have_tracepoints() - we really just want the part that checks whether
any attributes correspondo to tracepoints.

Second, we really don't care about raw_samples per se - tracepoints
are always raw_samples.  In any case, the have_tracepoints() check
should be sufficient to decide whether or not to write TRACE_INFO.

Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>,
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Acked-by: Frederic Weisbecker <fweisbec@gmail.com>
LKML-Reference: <1273030770.6383.6.camel@tropicana>
Signed-off-by: Tom Zanussi <tzanussi@gmail.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-record.c        |   11 +----------
 tools/perf/util/trace-event-info.c |    8 +++++++-
 2 files changed, 8 insertions(+), 11 deletions(-)

diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index 0ff67d1..d3981ac 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -560,17 +560,8 @@ static int __cmd_record(int argc, const char **argv)
 			return err;
 	}
 
-	if (raw_samples && have_tracepoints(attrs, nr_counters)) {
+	if (have_tracepoints(attrs, nr_counters))
 		perf_header__set_feat(&session->header, HEADER_TRACE_INFO);
-	} else {
-		for (i = 0; i < nr_counters; i++) {
-			if (attrs[i].sample_type & PERF_SAMPLE_RAW &&
-				attrs[i].type == PERF_TYPE_TRACEPOINT) {
-				perf_header__set_feat(&session->header, HEADER_TRACE_INFO);
-				break;
-			}
-		}
-	}
 
 	atexit(atexit_header);
 
diff --git a/tools/perf/util/trace-event-info.c b/tools/perf/util/trace-event-info.c
index 0a1fb9d..b157260 100644
--- a/tools/perf/util/trace-event-info.c
+++ b/tools/perf/util/trace-event-info.c
@@ -489,7 +489,13 @@ get_tracepoints_path(struct perf_event_attr *pattrs, int nb_events)
 
 bool have_tracepoints(struct perf_event_attr *pattrs, int nb_events)
 {
-	return get_tracepoints_path(pattrs, nb_events) ? true : false;
+	int i;
+
+	for (i = 0; i < nb_events; i++)
+		if (pattrs[i].type == PERF_TYPE_TRACEPOINT)
+			return true;
+
+	return false;
 }
 
 int read_tracing_data(int fd, struct perf_event_attr *pattrs, int nb_events)
-- 
1.6.2.5

