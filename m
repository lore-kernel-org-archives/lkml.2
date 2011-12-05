Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756280Ab1LEMyL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 07:54:11 -0500
Received: from terminus.zytor.com ([198.137.202.10]:56898 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755266Ab1LEMyJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 07:54:09 -0500
Date: Mon, 5 Dec 2011 04:53:05 -0800
From: tip-bot for Arnaldo Carvalho de Melo <acme@redhat.com>
Message-ID: <tip-za923wjc41q5xot5vrhuhj3j@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, paulus@samba.org,
        acme@redhat.com, hpa@zytor.com, mingo@redhat.com, peterz@infradead.org,
        efault@gmx.de, fweisbec@gmail.com, dsahern@gmail.com,
        tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, efault@gmx.de,
        peterz@infradead.org, fweisbec@gmail.com, dsahern@gmail.com,
        tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf evlist: Introduce id_hdr_size method out of perf_session
Git-Commit-ID: 81e36bffad95e015af9741b5b1ee16afe08aab05
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Mon, 05 Dec 2011 04:53:11 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  81e36bffad95e015af9741b5b1ee16afe08aab05
Gitweb:     http://git.kernel.org/tip/81e36bffad95e015af9741b5b1ee16afe08aab05
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Fri, 11 Nov 2011 22:28:50 -0200
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 28 Nov 2011 10:37:29 -0200

perf evlist: Introduce id_hdr_size method out of perf_session

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
