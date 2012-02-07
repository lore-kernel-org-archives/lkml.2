Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756654Ab2BGTeH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Feb 2012 14:34:07 -0500
Received: from terminus.zytor.com ([198.137.202.10]:40689 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754808Ab2BGTeF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Feb 2012 14:34:05 -0500
Date: Tue, 7 Feb 2012 11:33:50 -0800
From: tip-bot for Robert Richter <robert.richter@amd.com>
Message-ID: <tip-781ba9d2ed9df07dbb413fb5ee80ef7d353841c9@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@redhat.com, robert.richter@amd.com, tglx@linutronix.de,
        mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        acme@redhat.com, robert.richter@amd.com, tglx@linutronix.de,
        mingo@elte.hu
In-Reply-To: <1323966762-8574-3-git-send-email-robert.richter@amd.com>
References: <1323966762-8574-3-git-send-email-robert.richter@amd.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf record: Make feature initialization generic
Git-Commit-ID: 781ba9d2ed9df07dbb413fb5ee80ef7d353841c9
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Tue, 07 Feb 2012 11:33:55 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  781ba9d2ed9df07dbb413fb5ee80ef7d353841c9
Gitweb:     http://git.kernel.org/tip/781ba9d2ed9df07dbb413fb5ee80ef7d353841c9
Author:     Robert Richter <robert.richter@amd.com>
AuthorDate: Thu, 15 Dec 2011 17:32:40 +0100
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Thu, 2 Feb 2012 17:41:17 -0200

perf record: Make feature initialization generic

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
 
