Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755096Ab1K1XOy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Nov 2011 18:14:54 -0500
Received: from casper.infradead.org ([85.118.1.10]:34298 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753346Ab1K1XOt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Nov 2011 18:14:49 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 13/25] perf evlist: Introduce id_hdr_size method out of perf_session
Date: Mon, 28 Nov 2011 21:14:14 -0200
Message-Id: <1322522066-21879-14-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.8.rc0.35.gee6df
In-Reply-To: <1322522066-21879-1-git-send-email-acme@infradead.org>
References: <1322522066-21879-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

We will need this when not using perf_session in cases like 'perf top'
and strace where no perf.data file is created nor consumed.

Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-za923wjc41q5xot5vrhuhj3j@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/evlist.c  |   32 ++++++++++++++++++++++++++++++++
 tools/perf/util/evlist.h  |    1 +
 tools/perf/util/session.c |   29 +----------------------------
 3 files changed, 34 insertions(+), 28 deletions(-)

diff --git a/tools/perf/util/evlist.c b/tools/perf/util/evlist.c
index 81237dc..d44e3df 100644
--- a/tools/perf/util/evlist.c
+++ b/tools/perf/util/evlist.c
@@ -625,6 +625,38 @@ u64 perf_evlist__sample_type(const struct perf_evlist *evlist)
 	return first->attr.sample_type;
 }
 
+u16 perf_evlist__id_hdr_size(const struct perf_evlist *evlist)
+{
+	struct perf_evsel *first;
+	struct perf_sample *data;
+	u64 sample_type;
+	u16 size = 0;
+
+	first = list_entry(evlist->entries.next, struct perf_evsel, node);
+
+	if (!first->attr.sample_id_all)
+		goto out;
+
+	sample_type = first->attr.sample_type;
+
+	if (sample_type & PERF_SAMPLE_TID)
+		size += sizeof(data->tid) * 2;
+
+       if (sample_type & PERF_SAMPLE_TIME)
+		size += sizeof(data->time);
+
+	if (sample_type & PERF_SAMPLE_ID)
+		size += sizeof(data->id);
+
+	if (sample_type & PERF_SAMPLE_STREAM_ID)
+		size += sizeof(data->stream_id);
+
+	if (sample_type & PERF_SAMPLE_CPU)
+		size += sizeof(data->cpu) * 2;
+out:
+	return size;
+}
+
 bool perf_evlist__valid_sample_id_all(const struct perf_evlist *evlist)
 {
 	struct perf_evsel *pos, *first;
diff --git a/tools/perf/util/evlist.h b/tools/perf/util/evlist.h
index 17e9c80..2202e7b 100644
--- a/tools/perf/util/evlist.h
+++ b/tools/perf/util/evlist.h
@@ -104,6 +104,7 @@ int perf_evlist__set_filters(struct perf_evlist *evlist);
 
 u64 perf_evlist__sample_type(const struct perf_evlist *evlist);
 bool perf_evlist__sample_id_all(const const struct perf_evlist *evlist);
+u16 perf_evlist__id_hdr_size(const struct perf_evlist *evlist);
 
 bool perf_evlist__valid_sample_type(const struct perf_evlist *evlist);
 bool perf_evlist__valid_sample_id_all(const struct perf_evlist *evlist);
diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index a76666f..675e080 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -78,39 +78,12 @@ out_close:
 	return -1;
 }
 
-static void perf_session__id_header_size(struct perf_session *session)
-{
-       struct perf_sample *data;
-       u64 sample_type = session->sample_type;
-       u16 size = 0;
-
-	if (!session->sample_id_all)
-		goto out;
-
-       if (sample_type & PERF_SAMPLE_TID)
-               size += sizeof(data->tid) * 2;
-
-       if (sample_type & PERF_SAMPLE_TIME)
-               size += sizeof(data->time);
-
-       if (sample_type & PERF_SAMPLE_ID)
-               size += sizeof(data->id);
-
-       if (sample_type & PERF_SAMPLE_STREAM_ID)
-               size += sizeof(data->stream_id);
-
-       if (sample_type & PERF_SAMPLE_CPU)
-               size += sizeof(data->cpu) * 2;
-out:
-       session->id_hdr_size = size;
-}
-
 void perf_session__update_sample_type(struct perf_session *self)
 {
 	self->sample_type = perf_evlist__sample_type(self->evlist);
 	self->sample_size = __perf_evsel__sample_size(self->sample_type);
 	self->sample_id_all = perf_evlist__sample_id_all(self->evlist);
-	perf_session__id_header_size(self);
+	self->id_hdr_size = perf_evlist__id_hdr_size(self->evlist);
 }
 
 int perf_session__create_kernel_maps(struct perf_session *self)
-- 
1.7.8.rc0.35.gee6df

