Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756780Ab0LISOD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Dec 2010 13:14:03 -0500
Received: from canuck.infradead.org ([134.117.69.58]:58444 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756691Ab0LISNH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Dec 2010 13:13:07 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ian Munsie <imunsie@au1.ibm.com>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 05/10] perf session: Store file offset in sample_queue
Date: Thu,  9 Dec 2010 16:12:52 -0200
Message-Id: <1291918376-18261-6-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1291918376-18261-1-git-send-email-acme@infradead.org>
References: <1291918376-18261-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>

Preparatory patch for ordered output of perf report -D.

Acked-by: Ian Munsie <imunsie@au1.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ian Munsie <imunsie@au1.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <peterz@infradead.org>
LKML-Reference: <20101207124550.725128545@linutronix.de>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/session.c |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index 12761d5..a433954 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -444,6 +444,7 @@ static event__swap_op event__swap_ops[] = {
 
 struct sample_queue {
 	u64			timestamp;
+	u64			file_offset;
 	event_t			*event;
 	struct list_head	list;
 };
@@ -596,7 +597,7 @@ static void __queue_event(struct sample_queue *new, struct perf_session *s)
 #define MAX_SAMPLE_BUFFER	(64 * 1024 / sizeof(struct sample_queue))
 
 static int perf_session_queue_event(struct perf_session *s, event_t *event,
-				    struct sample_data *data)
+				    struct sample_data *data, u64 file_offset)
 {
 	struct ordered_samples *os = &s->ordered_samples;
 	struct list_head *sc = &os->sample_cache;
@@ -628,6 +629,7 @@ static int perf_session_queue_event(struct perf_session *s, event_t *event,
 	}
 
 	new->timestamp = timestamp;
+	new->file_offset = file_offset;
 	new->event = event;
 
 	__queue_event(new, s);
@@ -780,7 +782,8 @@ static int perf_session__process_event(struct perf_session *session,
 	}
 
 	if (ops->ordered_samples) {
-		ret = perf_session_queue_event(session, event, &sample);
+		ret = perf_session_queue_event(session, event, &sample,
+					       file_offset);
 		if (ret != -ETIME)
 			return ret;
 	}
-- 
1.6.2.5

