Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753562Ab0LGMtI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 07:49:08 -0500
Received: from www.tglx.de ([62.245.132.106]:46592 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752588Ab0LGMtH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 07:49:07 -0500
Message-Id: <20101207124550.528788441@linutronix.de>
User-Agent: quilt/0.48-1
Date: Tue, 07 Dec 2010 12:48:44 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>,
        Ian Munsie <imunsie@au1.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>
Subject: [patch 2/9] perf: session: Dont queue events w/o timestamps
References: <20101207124527.868085529@linutronix.de>
Content-Disposition: inline;
	filename=perf-session-do-not-queue-events-w-o-timestamps.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If the event has no timestamp assigned then the parse code sets it to
~0ULL which causes the ordering code to enqueue it at the end.

Process it right away.

Reported-by: Ian Munsie <imunsie@au1.ibm.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 tools/perf/util/session.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6-tip/tools/perf/util/session.c
===================================================================
--- linux-2.6-tip.orig/tools/perf/util/session.c
+++ linux-2.6-tip/tools/perf/util/session.c
@@ -603,7 +603,7 @@ static int perf_session_queue_event(stru
 	u64 timestamp = data->time;
 	struct sample_queue *new;
 
-	if (!timestamp)
+	if (!timestamp || timestamp == ~0ULL)
 		return -ETIME;
 
 	if (timestamp < s->ordered_samples.last_flush) {


