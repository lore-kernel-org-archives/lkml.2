Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933552Ab1J2R0B (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Oct 2011 13:26:01 -0400
Received: from casper.infradead.org ([85.118.1.10]:35430 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933496Ab1J2R0A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Oct 2011 13:26:00 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 3/3] perf report: Add progress bar when processing time ordered events
Date: Sat, 29 Oct 2011 15:25:51 -0200
Message-Id: <1319909151-11432-4-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1319909151-11432-1-git-send-email-acme@infradead.org>
References: <1319909151-11432-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

So that for large perf.data files the user can have visual feedback that
activity is being performed.

Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-3ysn01mpspfrbsy56gznzqqz@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/session.c |    9 +++++++++
 tools/perf/util/session.h |    1 +
 2 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index da354fe..85c1e6b 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -502,6 +502,7 @@ static void flush_sample_queue(struct perf_session *s,
 	struct perf_sample sample;
 	u64 limit = os->next_flush;
 	u64 last_ts = os->last_sample ? os->last_sample->timestamp : 0ULL;
+	unsigned idx = 0, progress_next = os->nr_samples / 16;
 	int ret;
 
 	if (!ops->ordered_samples || !limit)
@@ -521,6 +522,11 @@ static void flush_sample_queue(struct perf_session *s,
 		os->last_flush = iter->timestamp;
 		list_del(&iter->list);
 		list_add(&iter->list, &os->sample_cache);
+		if (++idx >= progress_next) {
+			progress_next += os->nr_samples / 16;
+			ui_progress__update(idx, os->nr_samples,
+					    "Processing time ordered events...");
+		}
 	}
 
 	if (list_empty(head)) {
@@ -529,6 +535,8 @@ static void flush_sample_queue(struct perf_session *s,
 		os->last_sample =
 			list_entry(head->prev, struct sample_queue, list);
 	}
+
+	os->nr_samples = 0;
 }
 
 /*
@@ -588,6 +596,7 @@ static void __queue_event(struct sample_queue *new, struct perf_session *s)
 	u64 timestamp = new->timestamp;
 	struct list_head *p;
 
+	++os->nr_samples;
 	os->last_sample = new;
 
 	if (!sample) {
diff --git a/tools/perf/util/session.h b/tools/perf/util/session.h
index 514b06d..6e393c9 100644
--- a/tools/perf/util/session.h
+++ b/tools/perf/util/session.h
@@ -23,6 +23,7 @@ struct ordered_samples {
 	struct sample_queue	*sample_buffer;
 	struct sample_queue	*last_sample;
 	int			sample_buffer_idx;
+	unsigned int		nr_samples;
 };
 
 struct perf_session {
-- 
1.6.2.5

