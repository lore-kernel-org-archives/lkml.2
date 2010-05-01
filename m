Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751288Ab0EAGlb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 May 2010 02:41:31 -0400
Received: from mail-iw0-f182.google.com ([209.85.223.182]:62868 "EHLO
	mail-iw0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751107Ab0EAGl0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 May 2010 02:41:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=rWYviGuOScVcg1rd+QWd7yXEuV0FSDQMHV3atpftBHw5ACc0h7gnGz05jihSeF7x7t
         bqe8QVHo6tpXY8YfYbchy2ixfOFXjfO8ju8pzR4BWRwK0QybyH0t5UfGFbxaDslI5XL8
         Elsyl9sjPcoaFcwqmZWF0o6GVFEcRS4nr32hg=
From: Tom Zanussi <tzanussi@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, fweisbec@gmail.com, rostedt@goodmis.org,
       acme@ghostprotocols.net
Subject: [RFC][PATCH 1/2] perf/live: don't synthesize build ids at the end of a live mode trace
Date: Sat,  1 May 2010 01:41:19 -0500
Message-Id: <1272696080-16435-2-git-send-email-tzanussi@gmail.com>
X-Mailer: git-send-email 1.6.4.GIT
In-Reply-To: <1272696080-16435-1-git-send-email-tzanussi@gmail.com>
References: <1272696080-16435-1-git-send-email-tzanussi@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It doesn't really make sense to record the build ids at the end of a
live mode session - live mode samples need that information during the
trace rather than at the end.

Leave event__synthesize_build_id() in place, however; we'll still be
using that to synthesize build ids in a more timely fashion in a
future patch.

Signed-off-by: Tom Zanussi <tzanussi@gmail.com>
---
 tools/perf/builtin-record.c |    7 -----
 tools/perf/util/header.c    |   61 -------------------------------------------
 tools/perf/util/header.h    |    2 -
 3 files changed, 0 insertions(+), 70 deletions(-)

diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index 722b6f1..5d21a3a 100644
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
index fe12276..83b79e2 100644
--- a/tools/perf/util/header.c
+++ b/tools/perf/util/header.c
@@ -1135,67 +1135,6 @@ int event__synthesize_build_id(struct dso *pos, u16 misc,
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
1.6.4.GIT

