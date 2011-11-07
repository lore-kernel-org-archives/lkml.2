Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932425Ab1KGMyR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Nov 2011 07:54:17 -0500
Received: from mailhub.sw.ru ([195.214.232.25]:26176 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932393Ab1KGMyP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Nov 2011 07:54:15 -0500
From: Andrew Vagin <avagin@openvz.org>
To: linux-kernel@vger.kernel.org
Cc: Arun Sharma <asharma@fb.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>, avagin@openvz.org,
        devel@openvz.org
Subject: [PATCH 4/7] perf: add ability to change event according to sample
Date: Mon,  7 Nov 2011 15:54:14 +0300
Message-Id: <1320670457-2633428-5-git-send-email-avagin@openvz.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1320670457-2633428-1-git-send-email-avagin@openvz.org>
References: <1320670457-2633428-1-git-send-email-avagin@openvz.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It's opposition of perf_session__parse_sample.

Signed-off-by: Andrew Vagin <avagin@openvz.org>
---
 tools/perf/util/event.h   |    2 +
 tools/perf/util/evsel.c   |   74 +++++++++++++++++++++++++++++++++++++++++++++
 tools/perf/util/session.h |    9 +++++
 3 files changed, 85 insertions(+), 0 deletions(-)

diff --git a/tools/perf/util/event.h b/tools/perf/util/event.h
index 357a85b..0493101 100644
--- a/tools/perf/util/event.h
+++ b/tools/perf/util/event.h
@@ -187,5 +187,7 @@ const char *perf_event__name(unsigned int id);
 int perf_event__parse_sample(const union perf_event *event, u64 type,
 			     int sample_size, bool sample_id_all,
 			     struct perf_sample *sample, bool swapped);
+int perf_event__change_sample(union perf_event *event, u64 type,
+			     const struct perf_sample *data, bool swapped);
 
 #endif /* __PERF_RECORD_H */
diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
index b46f6e4..9274e08 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -475,3 +475,77 @@ int perf_event__parse_sample(const union perf_event *event, u64 type,
 
 	return 0;
 }
+
+int perf_event__change_sample(union perf_event *event, u64 type,
+			     const struct perf_sample *data, bool swapped)
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
+		event->ip.ip = data->ip;
+		array++;
+	}
+
+	if (type & PERF_SAMPLE_TID) {
+		u.val32[0] = data->pid;
+		u.val32[1] = data->tid;
+		if (swapped) {
+			/* undo swap of u64, then swap on individual u32s */
+			u.val64 = bswap_64(u.val64);
+			u.val32[0] = bswap_32(u.val32[0]);
+			u.val32[1] = bswap_32(u.val32[1]);
+		}
+
+		*array = u.val64;
+		array++;
+	}
+
+	if (type & PERF_SAMPLE_TIME) {
+		*array = data->time;
+		array++;
+	}
+
+	if (type & PERF_SAMPLE_ADDR) {
+		*array = data->addr;
+		array++;
+	}
+
+	if (type & PERF_SAMPLE_ID) {
+		*array = data->id;
+		array++;
+	}
+
+	if (type & PERF_SAMPLE_STREAM_ID) {
+		*array = data->stream_id;
+		array++;
+	}
+
+	if (type & PERF_SAMPLE_CPU) {
+		u.val32[0] = data->cpu;
+		if (swapped) {
+			/* undo swap of u64, then swap on individual u32s */
+			u.val64 = bswap_64(u.val64);
+			u.val32[0] = bswap_32(u.val32[0]);
+		}
+		*array = u.val64;
+		array++;
+	}
+
+	if (type & PERF_SAMPLE_PERIOD) {
+		*array = data->period;
+		array++;
+	}
+
+	return 0;
+}
diff --git a/tools/perf/util/session.h b/tools/perf/util/session.h
index 514b06d..5a36d10 100644
--- a/tools/perf/util/session.h
+++ b/tools/perf/util/session.h
@@ -166,6 +166,15 @@ static inline int perf_session__parse_sample(struct perf_session *session,
 					session->header.needs_swap);
 }
 
+static inline int perf_session__change_sample(struct perf_session *session,
+					     union perf_event *event,
+					     const struct perf_sample *sample)
+{
+	return perf_event__change_sample(event, session->sample_type,
+					sample,
+					session->header.needs_swap);
+}
+
 struct perf_evsel *perf_session__find_first_evtype(struct perf_session *session,
 					    unsigned int type);
 
-- 
1.7.1

