Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755939Ab2BFWKg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Feb 2012 17:10:36 -0500
Received: from casper.infradead.org ([85.118.1.10]:56436 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755899Ab2BFWKe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Feb 2012 17:10:34 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Robert Richter <robert.richter@amd.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 4/8] perf record: Make feature initialization generic
Date: Mon,  6 Feb 2012 20:10:19 -0200
Message-Id: <1328566223-27218-5-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.123.g65da0
In-Reply-To: <1328566223-27218-1-git-send-email-acme@infradead.org>
References: <1328566223-27218-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Robert Richter <robert.richter@amd.com>

Loop over all features to enable it instead of explicitly enabling every
single feature. Reducing duplicate code and making it more robust to
later changes e.g. when adding more features.

Cc: Ingo Molnar <mingo@elte.hu>
Link: http://lkml.kernel.org/r/1323966762-8574-3-git-send-email-robert.richter@amd.com
Signed-off-by: Robert Richter <robert.richter@amd.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-record.c |   28 +++++++++-------------------
 tools/perf/util/header.h    |    1 +
 2 files changed, 10 insertions(+), 19 deletions(-)

diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index 32870ee..f8d9a54 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -386,7 +386,7 @@ static int __cmd_record(struct perf_record *rec, int argc, const char **argv)
 {
 	struct stat st;
 	int flags;
-	int err, output;
+	int err, output, feat;
 	unsigned long waking = 0;
 	const bool forks = argc > 0;
 	struct machine *machine;
@@ -453,8 +453,14 @@ static int __cmd_record(struct perf_record *rec, int argc, const char **argv)
 
 	rec->session = session;
 
-	if (!rec->no_buildid)
-		perf_header__set_feat(&session->header, HEADER_BUILD_ID);
+	for (feat = HEADER_FIRST_FEATURE; feat < HEADER_LAST_FEATURE; feat++)
+		perf_header__set_feat(&session->header, feat);
+
+	if (rec->no_buildid)
+		perf_header__clear_feat(&session->header, HEADER_BUILD_ID);
+
+	if (!have_tracepoints(&evsel_list->entries))
+		perf_header__clear_feat(&session->header, HEADER_TRACE_INFO);
 
 	if (!rec->file_new) {
 		err = perf_session__read_header(session, output);
@@ -462,22 +468,6 @@ static int __cmd_record(struct perf_record *rec, int argc, const char **argv)
 			goto out_delete_session;
 	}
 
-	if (have_tracepoints(&evsel_list->entries))
-		perf_header__set_feat(&session->header, HEADER_TRACE_INFO);
-
-	perf_header__set_feat(&session->header, HEADER_HOSTNAME);
-	perf_header__set_feat(&session->header, HEADER_OSRELEASE);
-	perf_header__set_feat(&session->header, HEADER_ARCH);
-	perf_header__set_feat(&session->header, HEADER_CPUDESC);
-	perf_header__set_feat(&session->header, HEADER_NRCPUS);
-	perf_header__set_feat(&session->header, HEADER_EVENT_DESC);
-	perf_header__set_feat(&session->header, HEADER_CMDLINE);
-	perf_header__set_feat(&session->header, HEADER_VERSION);
-	perf_header__set_feat(&session->header, HEADER_CPU_TOPOLOGY);
-	perf_header__set_feat(&session->header, HEADER_TOTAL_MEM);
-	perf_header__set_feat(&session->header, HEADER_NUMA_TOPOLOGY);
-	perf_header__set_feat(&session->header, HEADER_CPUID);
-
 	if (forks) {
 		err = perf_evlist__prepare_workload(evsel_list, opts, argv);
 		if (err < 0) {
diff --git a/tools/perf/util/header.h b/tools/perf/util/header.h
index ac4ec95..e68f617 100644
--- a/tools/perf/util/header.h
+++ b/tools/perf/util/header.h
@@ -11,6 +11,7 @@
 
 enum {
 	HEADER_RESERVED		= 0,	/* always cleared */
+	HEADER_FIRST_FEATURE	= 1,
 	HEADER_TRACE_INFO	= 1,
 	HEADER_BUILD_ID,
 
-- 
1.7.9.123.g65da0

