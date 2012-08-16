Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030428Ab2HPT5F (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 15:57:05 -0400
Received: from [213.199.154.206] ([213.199.154.206]:21501 "EHLO
	am1outboundpool.messaging.microsoft.com" rhost-flags-FAIL-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S933184Ab2HPTyL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 15:54:11 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VPS0(zzzz1202hzz8275bhz2dh668h839hd24he5bhf0ah1155h)
X-WSS-ID: 0M8V5X1-01-68W-02
X-M-MSG: 
From: Robert Richter <robert.richter@amd.com>
To: Arnaldo Carvalho de Melo <acme@redhat.com>
CC: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Jiri Olsa <jolsa@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        Robert Richter <robert.richter@amd.com>
Subject: [PATCH 3/8] perf tools: Rename some variables for better understanding
Date: Thu, 16 Aug 2012 21:10:19 +0200
Message-ID: <1345144224-27280-4-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.7.8.6
In-Reply-To: <1345144224-27280-1-git-send-email-robert.richter@amd.com>
References: <1345144224-27280-1-git-send-email-robert.richter@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Trivial patch to improve understanding of code.

Varible attr is usually used for struct perf_event_attr. Using it in a
different context is irritating. Thus, renaming it.

Signed-off-by: Robert Richter <robert.richter@amd.com>
---
 tools/perf/util/header.c |   42 +++++++++++++++++++++---------------------
 1 files changed, 21 insertions(+), 21 deletions(-)

diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
index 471b0c4..e2e5129 100644
--- a/tools/perf/util/header.c
+++ b/tools/perf/util/header.c
@@ -608,11 +608,11 @@ static int write_nrcpus(int fd, struct perf_header *h __used,
 static int write_event_desc(int fd, struct perf_header *h __used,
 			    struct perf_evlist *evlist)
 {
-	struct perf_evsel *attr;
+	struct perf_evsel *evsel;
 	u32 nre = 0, nri, sz;
 	int ret;
 
-	list_for_each_entry(attr, &evlist->entries, node)
+	list_for_each_entry(evsel, &evlist->entries, node)
 		nre++;
 
 	/*
@@ -625,14 +625,14 @@ static int write_event_desc(int fd, struct perf_header *h __used,
 	/*
 	 * size of perf_event_attr struct
 	 */
-	sz = (u32)sizeof(attr->attr);
+	sz = (u32)sizeof(evsel->attr);
 	ret = do_write(fd, &sz, sizeof(sz));
 	if (ret < 0)
 		return ret;
 
-	list_for_each_entry(attr, &evlist->entries, node) {
+	list_for_each_entry(evsel, &evlist->entries, node) {
 
-		ret = do_write(fd, &attr->attr, sz);
+		ret = do_write(fd, &evsel->attr, sz);
 		if (ret < 0)
 			return ret;
 		/*
@@ -642,7 +642,7 @@ static int write_event_desc(int fd, struct perf_header *h __used,
 		 * copy into an nri to be independent of the
 		 * type of ids,
 		 */
-		nri = attr->ids;
+		nri = evsel->ids;
 		ret = do_write(fd, &nri, sizeof(nri));
 		if (ret < 0)
 			return ret;
@@ -650,13 +650,13 @@ static int write_event_desc(int fd, struct perf_header *h __used,
 		/*
 		 * write event string as passed on cmdline
 		 */
-		ret = do_write_string(fd, perf_evsel__name(attr));
+		ret = do_write_string(fd, perf_evsel__name(evsel));
 		if (ret < 0)
 			return ret;
 		/*
 		 * write unique ids for this event
 		 */
-		ret = do_write(fd, attr->id, attr->ids * sizeof(u64));
+		ret = do_write(fd, evsel->id, evsel->ids * sizeof(u64));
 		if (ret < 0)
 			return ret;
 	}
@@ -1683,7 +1683,7 @@ int perf_session__write_header(struct perf_session *session,
 	struct perf_file_header f_header;
 	struct perf_file_attr   f_attr;
 	struct perf_header *header = &session->header;
-	struct perf_evsel *attr, *pair = NULL;
+	struct perf_evsel *evsel, *pair = NULL;
 	int err;
 
 	lseek(fd, sizeof(f_header), SEEK_SET);
@@ -1691,9 +1691,9 @@ int perf_session__write_header(struct perf_session *session,
 	if (session->evlist != evlist)
 		pair = perf_evlist__first(session->evlist);
 
-	list_for_each_entry(attr, &evlist->entries, node) {
-		attr->id_offset = lseek(fd, 0, SEEK_CUR);
-		err = do_write(fd, attr->id, attr->ids * sizeof(u64));
+	list_for_each_entry(evsel, &evlist->entries, node) {
+		evsel->id_offset = lseek(fd, 0, SEEK_CUR);
+		err = do_write(fd, evsel->id, evsel->ids * sizeof(u64));
 		if (err < 0) {
 out_err_write:
 			pr_debug("failed to write perf header\n");
@@ -1703,19 +1703,19 @@ out_err_write:
 			err = do_write(fd, pair->id, pair->ids * sizeof(u64));
 			if (err < 0)
 				goto out_err_write;
-			attr->ids += pair->ids;
+			evsel->ids += pair->ids;
 			pair = perf_evsel__next(pair);
 		}
 	}
 
 	header->attr_offset = lseek(fd, 0, SEEK_CUR);
 
-	list_for_each_entry(attr, &evlist->entries, node) {
+	list_for_each_entry(evsel, &evlist->entries, node) {
 		f_attr = (struct perf_file_attr){
-			.attr = attr->attr,
+			.attr = evsel->attr,
 			.ids  = {
-				.offset = attr->id_offset,
-				.size   = attr->ids * sizeof(u64),
+				.offset = evsel->id_offset,
+				.size   = evsel->ids * sizeof(u64),
 			}
 		};
 		err = do_write(fd, &f_attr, sizeof(f_attr));
@@ -2277,12 +2277,12 @@ int perf_event__synthesize_attrs(struct perf_tool *tool,
 				   struct perf_session *session,
 				   perf_event__handler_t process)
 {
-	struct perf_evsel *attr;
+	struct perf_evsel *evsel;
 	int err = 0;
 
-	list_for_each_entry(attr, &session->evlist->entries, node) {
-		err = perf_event__synthesize_attr(tool, &attr->attr, attr->ids,
-						  attr->id, process);
+	list_for_each_entry(evsel, &session->evlist->entries, node) {
+		err = perf_event__synthesize_attr(tool, &evsel->attr, evsel->ids,
+						  evsel->id, process);
 		if (err) {
 			pr_debug("failed to create perf header attribute\n");
 			return err;
-- 
1.7.8.6


