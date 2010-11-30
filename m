Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932087Ab0K3ULP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Nov 2010 15:11:15 -0500
Received: from canuck.infradead.org ([134.117.69.58]:44527 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756716Ab0K3ULN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Nov 2010 15:11:13 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 10/11] perf session: Allocate chunks of sample objects
Date: Tue, 30 Nov 2010 18:10:55 -0200
Message-Id: <1291147856-17459-11-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1291147856-17459-1-git-send-email-acme@infradead.org>
References: <1291147856-17459-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>

The ordered sample code allocates singular reference objects struct
sample_queue which have 48byte size on 64bit and 20 bytes on 32bit. That's
silly. Allocate ~64k sized chunks and hand them out.

Performance gain: ~ 15%

Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
LKML-Reference: <20101130163820.398713983@linutronix.de>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/session.c |   21 ++++++++++++++++-----
 tools/perf/util/session.h |    3 +++
 2 files changed, 19 insertions(+), 5 deletions(-)

diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index 9fef587..52672da 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -114,6 +114,7 @@ struct perf_session *perf_session__new(const char *filename, int mode, bool forc
 	self->repipe = repipe;
 	INIT_LIST_HEAD(&self->ordered_samples.samples);
 	INIT_LIST_HEAD(&self->ordered_samples.sample_cache);
+	INIT_LIST_HEAD(&self->ordered_samples.to_free);
 	machine__init(&self->host_machine, "", HOST_KERNEL_ID);
 
 	if (mode == O_RDONLY) {
@@ -403,10 +404,10 @@ static void perf_session_free_sample_buffers(struct perf_session *session)
 {
 	struct ordered_samples *os = &session->ordered_samples;
 
-	while (!list_empty(&os->sample_cache)) {
+	while (!list_empty(&os->to_free)) {
 		struct sample_queue *sq;
 
-		sq = list_entry(os->sample_cache.next, struct sample_queue, list);
+		sq = list_entry(os->to_free.next, struct sample_queue, list);
 		list_del(&sq->list);
 		free(sq);
 	}
@@ -538,10 +539,13 @@ static void __queue_sample_event(struct sample_queue *new,
 	}
 }
 
+#define MAX_SAMPLE_BUFFER	(64 * 1024 / sizeof(struct sample_queue))
+
 static int queue_sample_event(event_t *event, struct sample_data *data,
 			      struct perf_session *s)
 {
-	struct list_head *sc = &s->ordered_samples.sample_cache;
+	struct ordered_samples *os = &s->ordered_samples;
+	struct list_head *sc = &os->sample_cache;
 	u64 timestamp = data->time;
 	struct sample_queue *new;
 
@@ -553,10 +557,17 @@ static int queue_sample_event(event_t *event, struct sample_data *data,
 	if (!list_empty(sc)) {
 		new = list_entry(sc->next, struct sample_queue, list);
 		list_del(&new->list);
+	} else if (os->sample_buffer) {
+		new = os->sample_buffer + os->sample_buffer_idx;
+		if (++os->sample_buffer_idx == MAX_SAMPLE_BUFFER)
+			os->sample_buffer = NULL;
 	} else {
-		new = malloc(sizeof(*new));
-		if (!new)
+		os->sample_buffer = malloc(MAX_SAMPLE_BUFFER * sizeof(*new));
+		if (!os->sample_buffer)
 			return -ENOMEM;
+		list_add(&os->sample_buffer->list, &os->to_free);
+		os->sample_buffer_idx = 2;
+		new = os->sample_buffer + 1;
 	}
 
 	new->timestamp = timestamp;
diff --git a/tools/perf/util/session.h b/tools/perf/util/session.h
index e4a7ff2..5bf6efa 100644
--- a/tools/perf/util/session.h
+++ b/tools/perf/util/session.h
@@ -19,7 +19,10 @@ struct ordered_samples {
 	u64			max_timestamp;
 	struct list_head	samples;
 	struct list_head	sample_cache;
+	struct list_head	to_free;
+	struct sample_queue	*sample_buffer;
 	struct sample_queue	*last_sample;
+	int			sample_buffer_idx;
 };
 
 struct perf_session {
-- 
1.6.2.5

