Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757703Ab0EEQwd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 May 2010 12:52:33 -0400
Received: from hera.kernel.org ([140.211.167.34]:50181 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753730Ab0EEQwb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 May 2010 12:52:31 -0400
Date: Wed, 5 May 2010 16:52:01 GMT
From: tip-bot for Tom Zanussi <tzanussi@gmail.com>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
       hpa@zytor.com, mingo@redhat.com, tzanussi@gmail.com,
       a.p.zijlstra@chello.nl, efault@gmx.de, fweisbec@gmail.com,
       tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, acme@redhat.com, tzanussi@gmail.com,
       a.p.zijlstra@chello.nl, efault@gmx.de, fweisbec@gmail.com,
       tglx@linutronix.de
In-Reply-To: <1273030770.6383.6.camel@tropicana>
References: <1273030770.6383.6.camel@tropicana>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf/record: simplify TRACE_INFO tracepoint check
Message-ID: <tip-db620b1c2fb172346dc54eb62bba9b4a117d173b@git.kernel.org>
Git-Commit-ID: db620b1c2fb172346dc54eb62bba9b4a117d173b
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 05 May 2010 16:52:01 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  db620b1c2fb172346dc54eb62bba9b4a117d173b
Gitweb:     http://git.kernel.org/tip/db620b1c2fb172346dc54eb62bba9b4a117d173b
Author:     Tom Zanussi <tzanussi@gmail.com>
AuthorDate: Tue, 4 May 2010 22:20:16 -0500
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 5 May 2010 11:12:53 -0300

perf/record: simplify TRACE_INFO tracepoint check

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
