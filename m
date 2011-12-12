Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753388Ab1LLN0c (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 08:26:32 -0500
Received: from merlin.infradead.org ([205.233.59.134]:43013 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752997Ab1LLN0U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 08:26:20 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Andrew Vagin <avagin@openvz.org>,
        Arun Sharma <asharma@fb.com>, David Ahern <dsahern@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, devel@openvz.org,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 3/3] perf tools: Add ability to synthesize event according to a sample
Date: Mon, 12 Dec 2011 11:26:09 -0200
Message-Id: <1323696369-14688-4-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.8.rc0.35.gee6df
In-Reply-To: <1323696369-14688-1-git-send-email-acme@infradead.org>
References: <1323696369-14688-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andrew Vagin <avagin@openvz.org>

It's the counterpart of perf_session__parse_sample.

v2: fixed mistakes found by David Ahern.
v3: s/data/sample/
    s/perf_event__change_sample/perf_event__synthesize_sample

Reviewed-by: David Ahern <dsahern@gmail.com>
Cc: Arun Sharma <asharma@fb.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: devel@openvz.org
Link: http://lkml.kernel.org/r/1323266161-394927-3-git-send-email-avagin@openvz.org
Signed-off-by: Andrew Vagin <avagin@openvz.org>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/event.h   |    3 ++
 tools/perf/util/evsel.c   |   79 +++++++++++++++++++++++++++++++++++++++++++++
 tools/perf/util/session.h |    8 ++++
 3 files changed, 90 insertions(+), 0 deletions(-)

diff --git a/tools/perf/util/event.h b/tools/perf/util/event.h
index 0d80201..cbdeaad 100644
--- a/tools/perf/util/event.h
+++ b/tools/perf/util/event.h
@@ -199,6 +199,9 @@ const char *perf_event__name(unsigned int id);
 int perf_event__parse_sample(const union perf_event *event, u64 type,
 			     int sample_size, bool sample_id_all,
 			     struct perf_sample *sample, bool swapped);
+int perf_event__synthesize_sample(union perf_event *event, u64 type,
+				  const struct perf_sample *sample,
+				  bool swapped);
 
 size_t perf_event__fprintf_comm(union perf_event *event, FILE *fp);
 size_t perf_event__fprintf_mmap(union perf_event *event, FILE *fp);
diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
index ee68d69..4a8c8b0 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -574,3 +574,82 @@ int perf_event__parse_sample(const union perf_event *event, u64 type,
 
 	return 0;
 }
+
+int perf_event__synthesize_sample(union perf_event *event, u64 type,
+				  const struct perf_sample *sample,
+				  bool swapped)
+{
+	u64 *array;
+
+	/*
+	 * used for cross-endian analysis. See git commit 65014ab3
+	 * for why this goofiness is needed.
+	 */
+	union {
+		u64 val64;
+		u32 val32[2];
+	} u;
+
+	array = event->sample.array;
+
+	if (type & PERF_SAMPLE_IP) {
+		event->ip.ip = sample->ip;
+		array++;
+	}
+
+	if (type & PERF_SAMPLE_TID) {
+		u.val32[0] = sample->pid;
+		u.val32[1] = sample->tid;
+		if (swapped) {
+			/*
+			 * Inverse of what is done in perf_event__parse_sample
+			 */
+			u.val32[0] = bswap_32(u.val32[0]);
+			u.val32[1] = bswap_32(u.val32[1]);
+			u.val64 = bswap_64(u.val64);
+		}
+
+		*array = u.val64;
+		array++;
+	}
+
+	if (type & PERF_SAMPLE_TIME) {
+		*array = sample->time;
+		array++;
+	}
+
+	if (type & PERF_SAMPLE_ADDR) {
+		*array = sample->addr;
+		array++;
+	}
+
+	if (type & PERF_SAMPLE_ID) {
+		*array = sample->id;
+		array++;
+	}
+
+	if (type & PERF_SAMPLE_STREAM_ID) {
+		*array = sample->stream_id;
+		array++;
+	}
+
+	if (type & PERF_SAMPLE_CPU) {
+		u.val32[0] = sample->cpu;
+		if (swapped) {
+			/*
+			 * Inverse of what is done in perf_event__parse_sample
+			 */
+			u.val32[0] = bswap_32(u.val32[0]);
+			u.val64 = bswap_64(u.val64);
+		}
+		*array = u.val64;
+		array++;
+	}
+
+	if (type & PERF_SAMPLE_PERIOD) {
+		*array = sample->period;
+		array++;
+	}
+
+	return 0;
+}
diff --git a/tools/perf/util/session.h b/tools/perf/util/session.h
index 30e9c6b6..fb69612 100644
--- a/tools/perf/util/session.h
+++ b/tools/perf/util/session.h
@@ -134,6 +134,14 @@ static inline int perf_session__parse_sample(struct perf_session *session,
 					session->header.needs_swap);
 }
 
+static inline int perf_session__synthesize_sample(struct perf_session *session,
+						  union perf_event *event,
+						  const struct perf_sample *sample)
+{
+	return perf_event__synthesize_sample(event, session->sample_type,
+					     sample, session->header.needs_swap);
+}
+
 struct perf_evsel *perf_session__find_first_evtype(struct perf_session *session,
 					    unsigned int type);
 
-- 
1.7.8.rc0.35.gee6df

