Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754087Ab0LGMuJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 07:50:09 -0500
Received: from www.tglx.de ([62.245.132.106]:46611 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753874Ab0LGMtT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 07:49:19 -0500
Message-Id: <20101207124550.725128545@linutronix.de>
User-Agent: quilt/0.48-1
Date: Tue, 07 Dec 2010 12:48:50 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>,
        Ian Munsie <imunsie@au1.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>
Subject: [patch 4/9] perf: session: Store file offset in sample_queue
References: <20101207124527.868085529@linutronix.de>
Content-Disposition: inline;
	filename=perf-session-store-file-offset-in-sample-queue.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Preparatory patch for ordered output of perf report -D

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 tools/perf/util/session.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

Index: linux-2.6-tip/tools/perf/util/session.c
===================================================================
--- linux-2.6-tip.orig/tools/perf/util/session.c
+++ linux-2.6-tip/tools/perf/util/session.c
@@ -444,6 +444,7 @@ static event__swap_op event__swap_ops[] 
 
 struct sample_queue {
 	u64			timestamp;
+	u64			file_offset;
 	event_t			*event;
 	struct list_head	list;
 };
@@ -596,7 +597,7 @@ static void __queue_event(struct sample_
 #define MAX_SAMPLE_BUFFER	(64 * 1024 / sizeof(struct sample_queue))
 
 static int perf_session_queue_event(struct perf_session *s, event_t *event,
-				    struct sample_data *data)
+				    struct sample_data *data, u64 file_offset)
 {
 	struct ordered_samples *os = &s->ordered_samples;
 	struct list_head *sc = &os->sample_cache;
@@ -628,6 +629,7 @@ static int perf_session_queue_event(stru
 	}
 
 	new->timestamp = timestamp;
+	new->file_offset = file_offset;
 	new->event = event;
 
 	__queue_event(new, s);
@@ -780,7 +782,8 @@ static int perf_session__process_event(s
 	}
 
 	if (ops->ordered_samples) {
-		ret = perf_session_queue_event(session, event, &sample);
+		ret = perf_session_queue_event(session, event, &sample,
+					       file_offset);
 		if (ret != -ETIME)
 			return ret;
 	}


