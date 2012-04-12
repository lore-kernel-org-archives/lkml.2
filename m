Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933596Ab2DLMVX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2012 08:21:23 -0400
Received: from mx1.redhat.com ([209.132.183.28]:21525 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933338Ab2DLMVW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2012 08:21:22 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: acme@redhat.com, a.p.zijlstra@chello.nl, mingo@elte.hu, paulus@samba.org,
        cjashfor@linux.vnet.ibm.com, fweisbec@gmail.com
Cc: linux-kernel@vger.kernel.org, Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 3/3] perf, tool: Fail on processing event with unknown size
Date: Thu, 12 Apr 2012 14:21:02 +0200
Message-Id: <1334233262-5679-4-git-send-email-jolsa@redhat.com>
In-Reply-To: <1334233262-5679-1-git-send-email-jolsa@redhat.com>
References: <1334233262-5679-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently if we cannot decide the size of the event, we guess next
event possition by:
  "... check alignment, and increment a single u64 in the hope
  to catch on again 'soon'"

This usually ends up with segfault or endless loop. It's better
to admit the failure right away, then pretend nothing happened.
It makes the life easier.. ;)

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
---
 tools/perf/util/session.c |   28 +++++++---------------------
 1 files changed, 7 insertions(+), 21 deletions(-)

diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index 9189751..fa0528b 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -1100,16 +1100,9 @@ more:
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
+		goto out_err;
 	}
 
 	head += size;
@@ -1218,17 +1211,10 @@ more:
 
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
+		goto out_err;
 	}
 
 	head += size;
-- 
1.7.1

