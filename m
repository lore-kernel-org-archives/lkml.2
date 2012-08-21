Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757996Ab2HUQZI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 12:25:08 -0400
Received: from terminus.zytor.com ([198.137.202.10]:32817 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757890Ab2HUQZE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 12:25:04 -0400
Date: Tue, 21 Aug 2012 09:24:41 -0700
From: tip-bot for Robert Richter <robert.richter@amd.com>
Message-ID: <tip-f4d834367cda98eee3769638da6ad687607c74e6@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@kernel.org, peterz@infradead.org, jolsa@redhat.com,
        robert.richter@amd.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        acme@redhat.com, robert.richter@amd.com, peterz@infradead.org,
        tglx@linutronix.de, jolsa@redhat.com
In-Reply-To: <1345144224-27280-2-git-send-email-robert.richter@amd.com>
References: <1345144224-27280-2-git-send-email-robert.richter@amd.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools: Fix type for evsel->
 ids and add size check for ids
Git-Commit-ID: f4d834367cda98eee3769638da6ad687607c74e6
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Tue, 21 Aug 2012 09:24:47 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  f4d834367cda98eee3769638da6ad687607c74e6
Gitweb:     http://git.kernel.org/tip/f4d834367cda98eee3769638da6ad687607c74e6
Author:     Robert Richter <robert.richter@amd.com>
AuthorDate: Thu, 16 Aug 2012 21:10:17 +0200
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Fri, 17 Aug 2012 12:38:07 -0300

perf tools: Fix type for evsel->ids and add size check for ids

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
