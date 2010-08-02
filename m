Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752200Ab0HBANa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Aug 2010 20:13:30 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:39282 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752024Ab0HBANU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Aug 2010 20:13:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:x-mailer-version
         :in-reply-to:references;
        b=NImlR0qrsn5ijBjU1fkZxsMM83E5CQThK/fqWHN4V+T0vy7vaF8INsK6mBSPcR6FkI
         90eO/Iuzuwm+WSfOPkkg/lpQRQxJGU58+9g23KhhJ0rNOhVGjAfjPsiQsskP4EGx0qLk
         0kC58KK7Jh/4vV7XrYOtiQRl5g29VrF05CiDQ=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
        Steven Rostedt <rostedt@goodmis.org>, Li Zefan <lizf@cn.fujitsu.com>
Subject: [PATCH 01/12] perf: Use tracepoint_synchronize_unregister() to flush any pending tracepoint call
Date: Mon,  2 Aug 2010 02:13:02 +0200
Message-Id: <1280707993-6599-2-git-send-regression-fweisbec@gmail.com>
X-Mailer: git-send-regression
X-Mailer-version: 0.1, "The maintainer couldn't reproduce after one week full time debugging" special version.
In-Reply-To: <1280707993-6599-1-git-send-regression-fweisbec@gmail.com>
References: <1280707993-6599-1-git-send-regression-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We use synchronize_sched() to ensure a tracepoint won't be called
while/after we release the perf buffers it references.

But the tracepoint API has its own API for that:
tracepoint_synchronize_unregister(). Use it instead as it's
self-explanatory and eases maintainance.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Li Zefan <lizf@cn.fujitsu.com>
---
 kernel/trace/trace_event_perf.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/kernel/trace/trace_event_perf.c b/kernel/trace/trace_event_perf.c
index 2375165..000e6e8 100644
--- a/kernel/trace/trace_event_perf.c
+++ b/kernel/trace/trace_event_perf.c
@@ -131,10 +131,10 @@ void perf_trace_destroy(struct perf_event *p_event)
 	tp_event->class->reg(tp_event, TRACE_REG_PERF_UNREGISTER);
 
 	/*
-	 * Ensure our callback won't be called anymore. See
-	 * tracepoint_probe_unregister() and __DO_TRACE().
+	 * Ensure our callback won't be called anymore. The buffers
+	 * will be freed after that.
 	 */
-	synchronize_sched();
+	tracepoint_synchronize_unregister();
 
 	free_percpu(tp_event->perf_events);
 	tp_event->perf_events = NULL;
-- 
1.6.2.3

