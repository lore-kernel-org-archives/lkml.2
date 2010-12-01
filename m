Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753709Ab0LAJNl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Dec 2010 04:13:41 -0500
Received: from hera.kernel.org ([140.211.167.34]:54256 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752498Ab0LAJNh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Dec 2010 04:13:37 -0500
Date: Wed, 1 Dec 2010 09:13:10 GMT
From: tip-bot for Thomas Gleixner <tglx@linutronix.de>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@redhat.com, peterz@infradead.org, fweisbec@gmail.com,
        tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        acme@redhat.com, fweisbec@gmail.com, peterz@infradead.org,
        tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20101130163820.398713983@linutronix.de>
References: <20101130163820.398713983@linutronix.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf session: Allocate chunks of sample objects
Message-ID: <tip-5c891f3840a7a330c96d7203d4bb5be6fa033724@git.kernel.org>
Git-Commit-ID: 5c891f3840a7a330c96d7203d4bb5be6fa033724
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 01 Dec 2010 09:13:11 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  5c891f3840a7a330c96d7203d4bb5be6fa033724
Gitweb:     http://git.kernel.org/tip/5c891f3840a7a330c96d7203d4bb5be6fa033724
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Tue, 30 Nov 2010 17:49:55 +0000
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Tue, 30 Nov 2010 20:05:25 -0200

perf session: Allocate chunks of sample objects

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
