Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030443Ab2HPT5H (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 15:57:07 -0400
Received: from [213.199.154.208] ([213.199.154.208]:56672 "EHLO
	am1outboundpool.messaging.microsoft.com" rhost-flags-FAIL-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S932536Ab2HPTyK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 15:54:10 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VPS0(zzzz1202hzz8275bhz2dh668h839hd24he5bhf0ah1155h)
X-WSS-ID: 0M8V5WZ-01-68M-02
X-M-MSG: 
From: Robert Richter <robert.richter@amd.com>
To: Arnaldo Carvalho de Melo <acme@redhat.com>
CC: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Jiri Olsa <jolsa@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        Robert Richter <robert.richter@amd.com>
Subject: [PATCH 1/8] perf tools: Fix type for evsel->ids and add size check for ids
Date: Thu, 16 Aug 2012 21:10:17 +0200
Message-ID: <1345144224-27280-2-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.7.8.6
In-Reply-To: <1345144224-27280-1-git-send-email-robert.richter@amd.com>
References: <1345144224-27280-1-git-send-email-robert.richter@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use same type for ids everywhere.

In case of writing to perf.data the size is u32. In pipe mode it is
limited to header.size (less than u16). Adding a size check here.

Size overflow due to casting shouldn't actually happen in practice,
but during development this may cause type missmatch warninngs/errors,
unifying types avoids this.

Signed-off-by: Robert Richter <robert.richter@amd.com>
---
 tools/perf/util/evsel.h  |    2 +-
 tools/perf/util/header.c |   11 +++++++----
 tools/perf/util/header.h |    2 +-
 3 files changed, 9 insertions(+), 6 deletions(-)

diff --git a/tools/perf/util/evsel.h b/tools/perf/util/evsel.h
index 65f39fd..94f6ba1 100644
--- a/tools/perf/util/evsel.h
+++ b/tools/perf/util/evsel.h
@@ -53,7 +53,7 @@ struct perf_evsel {
 	u64			*id;
 	struct perf_counts	*counts;
 	int			idx;
-	int			ids;
+	u32			ids;
 	struct hists		hists;
 	char			*name;
 	struct event_format	*tp_format;
diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
index 77832b8..471b0c4 100644
--- a/tools/perf/util/header.c
+++ b/tools/perf/util/header.c
@@ -2240,7 +2240,7 @@ out_delete_evlist:
 }
 
 int perf_event__synthesize_attr(struct perf_tool *tool,
-				struct perf_event_attr *attr, u16 ids, u64 *id,
+				struct perf_event_attr *attr, u32 ids, u64 *id,
 				perf_event__handler_t process)
 {
 	union perf_event *ev;
@@ -2261,9 +2261,12 @@ int perf_event__synthesize_attr(struct perf_tool *tool,
 	memcpy(ev->attr.id, id, ids * sizeof(u64));
 
 	ev->attr.header.type = PERF_RECORD_HEADER_ATTR;
-	ev->attr.header.size = size;
+	ev->attr.header.size = (u16)size;
 
-	err = process(tool, ev, NULL, NULL);
+	if (ev->attr.header.size == size)
+		err = process(tool, ev, NULL, NULL);
+	else
+		err = -E2BIG;
 
 	free(ev);
 
@@ -2292,7 +2295,7 @@ int perf_event__synthesize_attrs(struct perf_tool *tool,
 int perf_event__process_attr(union perf_event *event,
 			     struct perf_evlist **pevlist)
 {
-	unsigned int i, ids, n_ids;
+	u32 i, ids, n_ids;
 	struct perf_evsel *evsel;
 	struct perf_evlist *evlist = *pevlist;
 
diff --git a/tools/perf/util/header.h b/tools/perf/util/header.h
index 2d42b3e..24962e7 100644
--- a/tools/perf/util/header.h
+++ b/tools/perf/util/header.h
@@ -99,7 +99,7 @@ int build_id_cache__add_s(const char *sbuild_id, const char *debugdir,
 int build_id_cache__remove_s(const char *sbuild_id, const char *debugdir);
 
 int perf_event__synthesize_attr(struct perf_tool *tool,
-				struct perf_event_attr *attr, u16 ids, u64 *id,
+				struct perf_event_attr *attr, u32 ids, u64 *id,
 				perf_event__handler_t process);
 int perf_event__synthesize_attrs(struct perf_tool *tool,
 				 struct perf_session *session,
-- 
1.7.8.6


