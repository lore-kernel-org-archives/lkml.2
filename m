Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753457Ab0LAJNS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Dec 2010 04:13:18 -0500
Received: from hera.kernel.org ([140.211.167.34]:54240 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752462Ab0LAJNP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Dec 2010 04:13:15 -0500
Date: Wed, 1 Dec 2010 09:12:52 GMT
From: tip-bot for Thomas Gleixner <tglx@linutronix.de>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@redhat.com, peterz@infradead.org, fweisbec@gmail.com,
        tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        acme@redhat.com, fweisbec@gmail.com, peterz@infradead.org,
        tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20101130163820.338488630@linutronix.de>
References: <20101130163820.338488630@linutronix.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf session: Cache sample objects
Message-ID: <tip-020bb75a6deeca5ebeae531dc7378c157affc8fd@git.kernel.org>
Git-Commit-ID: 020bb75a6deeca5ebeae531dc7378c157affc8fd
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 01 Dec 2010 09:12:52 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  020bb75a6deeca5ebeae531dc7378c157affc8fd
Gitweb:     http://git.kernel.org/tip/020bb75a6deeca5ebeae531dc7378c157affc8fd
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Tue, 30 Nov 2010 17:49:53 +0000
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Tue, 30 Nov 2010 20:04:18 -0200

perf session: Cache sample objects

When the sample queue is flushed we free the sample reference objects. Though
we need to malloc new objects when we process further. Stop the malloc/free
orgy and cache the already allocated object for resuage. Only allocate when
the cache is empty.

Performance gain: ~ 10%

Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
LKML-Reference: <20101130163820.338488630@linutronix.de>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/session.c |   30 ++++++++++++++++++++++++++----
 tools/perf/util/session.h |    1 +
 2 files changed, 27 insertions(+), 4 deletions(-)

diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index c989583..9fef587 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -113,6 +113,7 @@ struct perf_session *perf_session__new(const char *filename, int mode, bool forc
 	self->machines = RB_ROOT;
 	self->repipe = repipe;
 	INIT_LIST_HEAD(&self->ordered_samples.samples);
+	INIT_LIST_HEAD(&self->ordered_samples.sample_cache);
 	machine__init(&self->host_machine, "", HOST_KERNEL_ID);
 
 	if (mode == O_RDONLY) {
@@ -398,6 +399,19 @@ struct sample_queue {
 	struct list_head	list;
 };
 
+static void perf_session_free_sample_buffers(struct perf_session *session)
+{
+	struct ordered_samples *os = &session->ordered_samples;
+
+	while (!list_empty(&os->sample_cache)) {
+		struct sample_queue *sq;
+
+		sq = list_entry(os->sample_cache.next, struct sample_queue, list);
+		list_del(&sq->list);
+		free(sq);
+	}
+}
+
 static void flush_sample_queue(struct perf_session *s,
 			       struct perf_event_ops *ops)
 {
@@ -418,7 +432,7 @@ static void flush_sample_queue(struct perf_session *s,
 
 		os->last_flush = iter->timestamp;
 		list_del(&iter->list);
-		free(iter);
+		list_add(&iter->list, &os->sample_cache);
 	}
 
 	if (list_empty(head)) {
@@ -527,6 +541,7 @@ static void __queue_sample_event(struct sample_queue *new,
 static int queue_sample_event(event_t *event, struct sample_data *data,
 			      struct perf_session *s)
 {
+	struct list_head *sc = &s->ordered_samples.sample_cache;
 	u64 timestamp = data->time;
 	struct sample_queue *new;
 
@@ -535,9 +550,14 @@ static int queue_sample_event(event_t *event, struct sample_data *data,
 		return -EINVAL;
 	}
 
-	new = malloc(sizeof(*new));
-	if (!new)
-		return -ENOMEM;
+	if (!list_empty(sc)) {
+		new = list_entry(sc->next, struct sample_queue, list);
+		list_del(&new->list);
+	} else {
+		new = malloc(sizeof(*new));
+		if (!new)
+			return -ENOMEM;
+	}
 
 	new->timestamp = timestamp;
 	new->event = event;
@@ -730,6 +750,7 @@ more:
 done:
 	err = 0;
 out_err:
+	perf_session_free_sample_buffers(self);
 	return err;
 }
 
@@ -862,6 +883,7 @@ out_err:
 			    session->hists.stats.nr_unknown_events);
 	}
 
+	perf_session_free_sample_buffers(session);
 	return err;
 }
 
diff --git a/tools/perf/util/session.h b/tools/perf/util/session.h
index a00f32e..e4a7ff2 100644
--- a/tools/perf/util/session.h
+++ b/tools/perf/util/session.h
@@ -18,6 +18,7 @@ struct ordered_samples {
 	u64			next_flush;
 	u64			max_timestamp;
 	struct list_head	samples;
+	struct list_head	sample_cache;
 	struct sample_queue	*last_sample;
 };
 
