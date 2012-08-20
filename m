Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757328Ab2HTQa3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 12:30:29 -0400
Received: from merlin.infradead.org ([205.233.59.134]:56351 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754685Ab2HTQ0m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 12:26:42 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Robert Richter <robert.richter@amd.com>,
        Jiri Olsa <jolsa@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 14/24] perf tools: Fix type for evsel->ids and add size check for ids
Date: Mon, 20 Aug 2012 13:26:15 -0300
Message-Id: <1345479985-18669-15-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
In-Reply-To: <1345479985-18669-1-git-send-email-acme@infradead.org>
References: <1345479985-18669-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="UTF-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Robert Richter <robert.richter@amd.com>

Use same type for ids everywhere.

In case of writing to perf.data the size is u32. In pipe mode it is
limited to header.size (less than u16). Adding a size check here.

Size overflow due to casting shouldn't actually happen in practice, but
during development this may cause type missmatch warninngs/errors,
unifying types avoids this.

Signed-off-by: Robert Richter <robert.richter@amd.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/1345144224-27280-2-git-send-email-robert.richter@amd.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
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
1.7.1

