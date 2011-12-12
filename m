Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753641Ab1LLRgI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 12:36:08 -0500
Received: from terminus.zytor.com ([198.137.202.10]:40468 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751636Ab1LLRgF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 12:36:05 -0500
Date: Mon, 12 Dec 2011 09:35:39 -0800
From: tip-bot for Andrew Vagin <avagin@openvz.org>
Message-ID: <tip-74eec26facadbe6dbc0621bc862892c915c4534f@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@redhat.com, a.p.zijlstra@chello.nl,
        avagin@openvz.org, dsahern@gmail.com, tglx@linutronix.de,
        asharma@fb.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        avagin@openvz.org, dsahern@gmail.com, tglx@linutronix.de,
        asharma@fb.com, mingo@elte.hu
In-Reply-To: <1323266161-394927-3-git-send-email-avagin@openvz.org>
References: <1323266161-394927-3-git-send-email-avagin@openvz.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools: Add ability to synthesize event according to a sample
Git-Commit-ID: 74eec26facadbe6dbc0621bc862892c915c4534f
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Mon, 12 Dec 2011 09:35:45 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  74eec26facadbe6dbc0621bc862892c915c4534f
Gitweb:     http://git.kernel.org/tip/74eec26facadbe6dbc0621bc862892c915c4534f
Author:     Andrew Vagin <avagin@openvz.org>
AuthorDate: Mon, 28 Nov 2011 12:03:31 +0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 12 Dec 2011 08:44:00 -0200

perf tools: Add ability to synthesize event according to a sample

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
 
