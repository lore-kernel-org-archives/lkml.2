Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932550Ab1LOQi3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Dec 2011 11:38:29 -0500
Received: from tx2ehsobe004.messaging.microsoft.com ([65.55.88.14]:57770 "EHLO
	TX2EHSOBE009.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1758988Ab1LOQi2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Dec 2011 11:38:28 -0500
X-SpamScore: 7
X-BigFish: VPS7(z1039ozzz1202hzz8275bhz2dh668h839h)
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-FB-SS: 13,
X-WSS-ID: 0LW97AY-01-5FI-02
X-M-MSG: 
From: Robert Richter <robert.richter@amd.com>
To: Arnaldo Carvalho de Melo <acme@redhat.com>
CC: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
        Robert Richter <robert.richter@amd.com>
Subject: [PATCH 2/4] perf record: Make feature initialization generic
Date: Thu, 15 Dec 2011 17:32:40 +0100
Message-ID: <1323966762-8574-3-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1323966762-8574-1-git-send-email-robert.richter@amd.com>
References: <1323966762-8574-1-git-send-email-robert.richter@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Loop over all features to enable it instead of explicitly enabling
every single feature. Reducing duplicate code and making it more
robust to later changes e.g. when adding more features.

Signed-off-by: Robert Richter <robert.richter@amd.com>
---
 tools/perf/builtin-record.c |   28 +++++++++-------------------
 tools/perf/util/header.h    |    1 +
 2 files changed, 10 insertions(+), 19 deletions(-)

diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index ec230e2..4684e7f 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -375,7 +375,7 @@ static int __cmd_record(struct perf_record *rec, int argc, const char **argv)
 {
 	struct stat st;
 	int flags;
-	int err, output;
+	int err, output, feat;
 	unsigned long waking = 0;
 	const bool forks = argc > 0;
 	struct machine *machine;
@@ -442,8 +442,14 @@ static int __cmd_record(struct perf_record *rec, int argc, const char **argv)
 
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
@@ -451,22 +457,6 @@ static int __cmd_record(struct perf_record *rec, int argc, const char **argv)
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
1.7.7


