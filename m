Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758991Ab0EBW73 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 May 2010 18:59:29 -0400
Received: from casper.infradead.org ([85.118.1.10]:45142 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754888Ab0EBW7N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 May 2010 18:59:13 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Tom Zanussi <tzanussi@gmail.com>,
       =?utf-8?q?Fr=C3=A9d=C3=A9ric=20Weisbecker?= <fweisbec@gmail.com>,
       Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 2/5] perf/live: don't synthesize build ids at the end of a live mode trace
Date: Sun,  2 May 2010 19:58:59 -0300
Message-Id: <1272841142-26029-3-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1272841142-26029-1-git-send-email-acme@infradead.org>
References: <1272841142-26029-1-git-send-email-acme@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tom Zanussi <tzanussi@gmail.com>

It doesn't really make sense to record the build ids at the end of a
live mode session - live mode samples need that information during the
trace rather than at the end.

Leave event__synthesize_build_id() in place, however; we'll still be
using that to synthesize build ids in a more timely fashion in a
future patch.

Cc: Frédéric Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Steven Rostedt <rostedt@goodmis.org>
LKML-Reference: <1272696080-16435-2-git-send-email-tzanussi@gmail.com>
Signed-off-by: Tom Zanussi <tzanussi@gmail.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-record.c |    7 -----
 tools/perf/util/header.c    |   61 -------------------------------------------
 tools/perf/util/header.h    |    2 -
 3 files changed, 0 insertions(+), 70 deletions(-)

diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index 83b308a..1a73796 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -446,13 +446,6 @@ static void atexit_header(void)
 
 		process_buildids();
 		perf_header__write(&session->header, output, true);
-	} else {
-		int err;
-
-		err = event__synthesize_build_ids(process_synthesized_event,
-						  session);
-		if (err < 0)
-			pr_err("Couldn't synthesize build ids.\n");
 	}
 }
 
diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
index 6227dc4..2d1d97e 100644
--- a/tools/perf/util/header.c
+++ b/tools/perf/util/header.c
@@ -1136,67 +1136,6 @@ int event__synthesize_build_id(struct dso *pos, u16 misc,
 	return err;
 }
 
-static int __event_synthesize_build_ids(struct list_head *head, u16 misc,
-					event__handler_t process,
-					struct machine *machine,
-					struct perf_session *session)
-{
-	struct dso *pos;
-
-	dsos__for_each_with_build_id(pos, head) {
-		int err;
-		if (!pos->hit)
-			continue;
-
-		err = event__synthesize_build_id(pos, misc, process,
-						 machine, session);
-		if (err < 0)
-			return err;
-	}
-
-	return 0;
-}
-
-int event__synthesize_build_ids(event__handler_t process,
-				struct perf_session *session)
-{
-	int err = 0;
-	u16 kmisc, umisc;
-	struct machine *pos;
-	struct rb_node *nd;
-
-	if (!dsos__read_build_ids(&session->header, true))
-		return 0;
-
-	for (nd = rb_first(&session->machines); nd; nd = rb_next(nd)) {
-		pos = rb_entry(nd, struct machine, rb_node);
-		if (machine__is_host(pos)) {
-			kmisc = PERF_RECORD_MISC_KERNEL;
-			umisc = PERF_RECORD_MISC_USER;
-		} else {
-			kmisc = PERF_RECORD_MISC_GUEST_KERNEL;
-			umisc = PERF_RECORD_MISC_GUEST_USER;
-		}
-
-		err = __event_synthesize_build_ids(&pos->kernel_dsos, kmisc,
-						   process, pos, session);
-		if (err == 0)
-			err = __event_synthesize_build_ids(&pos->user_dsos, umisc,
-							   process, pos, session);
-		if (err)
-			break;
-	}
-
-	if (err < 0) {
-		pr_debug("failed to synthesize build ids\n");
-		return err;
-	}
-
-	dsos__cache_build_ids(&session->header);
-
-	return 0;
-}
-
 int event__process_build_id(event_t *self,
 			    struct perf_session *session)
 {
diff --git a/tools/perf/util/header.h b/tools/perf/util/header.h
index f39443d..402ac24 100644
--- a/tools/perf/util/header.h
+++ b/tools/perf/util/header.h
@@ -122,8 +122,6 @@ int event__synthesize_build_id(struct dso *pos, u16 misc,
 			       event__handler_t process,
 			       struct machine *machine,
 			       struct perf_session *session);
-int event__synthesize_build_ids(event__handler_t process,
-				struct perf_session *session);
 int event__process_build_id(event_t *self, struct perf_session *session);
 
 #endif /* __PERF_HEADER_H */
-- 
1.6.2.5

