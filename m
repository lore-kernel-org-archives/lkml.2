Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753391Ab2DPSnJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 14:43:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:2176 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751469Ab2DPSnI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 14:43:08 -0400
Date: Mon, 16 Apr 2012 20:42:51 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: acme@redhat.com, a.p.zijlstra@chello.nl, mingo@elte.hu, paulus@samba.org,
        cjashfor@linux.vnet.ibm.com, fweisbec@gmail.com
Cc: linux-kernel@vger.kernel.org
Subject: [PATCHv2 3/3] perf, tool: Fail on processing event with unknown size
Message-ID: <20120416184251.GA11503@m.brq.redhat.com>
References: <1334233262-5679-1-git-send-email-jolsa@redhat.com>
 <1334233262-5679-4-git-send-email-jolsa@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1334233262-5679-4-git-send-email-jolsa@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi,
I compiled the initial version with old gcc and missed compiler
warnings, attaching fixed patch

jirka

---
Currently if we cannot decide the size of the event, we guess next
event possition by:
  "... check alignment, and increment a single u64 in the hope
  to catch on again 'soon'"

This usually ends up with segfault or endless loop. It's better
to admit the failure right away, then pretend nothing happened.
It makes the life easier ;)

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
---
 tools/perf/util/session.c |   30 +++++++++---------------------
 1 files changed, 9 insertions(+), 21 deletions(-)

diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index 1efd3be..4dcc8f3 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -1108,16 +1108,10 @@ more:
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
@@ -1226,17 +1220,11 @@ more:
 
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
1.7.7.6

