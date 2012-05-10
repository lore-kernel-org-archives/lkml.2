Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758893Ab2EJRSs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 13:18:48 -0400
Received: from merlin.infradead.org ([205.233.59.134]:55891 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757682Ab2EJRSA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 13:18:00 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Jiri Olsa <jolsa@redhat.com>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 01/16] perf session: Fail on processing event with unknown size
Date: Thu, 10 May 2012 14:17:30 -0300
Message-Id: <1336670265-20401-2-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
In-Reply-To: <1336670265-20401-1-git-send-email-acme@infradead.org>
References: <1336670265-20401-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="UTF-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Olsa <jolsa@redhat.com>

Currently if we cannot decide the size of the event, we guess next
event possition by:
  "... check alignment, and increment a single u64 in the hope
  to catch on again 'soon'"

This usually ends up with segfault or endless loop. It's better
to admit the failure right away, then pretend nothing happened.
It makes the life easier ;)

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/20120416184251.GA11503@m.brq.redhat.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/session.c |   30 +++++++++---------------------
 1 file changed, 9 insertions(+), 21 deletions(-)

diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index 9412e3b..f992ae3 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -1100,16 +1100,10 @@ more:
 	}
 
 	if ((skip = perf_session__process_event(self, &event, tool, head)) < 0) {
-		dump_printf("%#" PRIx64 " [%#x]: skipping unknown header type: %d\n",
-			    head, event.header.size, event.header.type);
-		/*
-		 * assume we lost track of the stream, check alignment, and
-		 * increment a single u64 in the hope to catch on again 'soon'.
-		 */
-		if (unlikely(head & 7))
-			head &= ~7ULL;
-
-		size = 8;
+		pr_err("%#" PRIx64 " [%#x]: failed to process type: %d\n",
+		       head, event.header.size, event.header.type);
+		err = -EINVAL;
+		goto out_err;
 	}
 
 	head += size;
@@ -1218,17 +1212,11 @@ more:
 
 	if (size == 0 ||
 	    perf_session__process_event(session, event, tool, file_pos) < 0) {
-		dump_printf("%#" PRIx64 " [%#x]: skipping unknown header type: %d\n",
-			    file_offset + head, event->header.size,
-			    event->header.type);
-		/*
-		 * assume we lost track of the stream, check alignment, and
-		 * increment a single u64 in the hope to catch on again 'soon'.
-		 */
-		if (unlikely(head & 7))
-			head &= ~7ULL;
-
-		size = 8;
+		pr_err("%#" PRIx64 " [%#x]: failed to process type: %d\n",
+		       file_offset + head, event->header.size,
+		       event->header.type);
+		err = -EINVAL;
+		goto out_err;
 	}
 
 	head += size;
-- 
1.7.9.2.358.g22243

