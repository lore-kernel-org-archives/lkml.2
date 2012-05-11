Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760503Ab2EKGi3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2012 02:38:29 -0400
Received: from terminus.zytor.com ([198.137.202.10]:57193 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753359Ab2EKGiZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2012 02:38:25 -0400
Date: Thu, 10 May 2012 23:37:59 -0700
From: tip-bot for Jiri Olsa <jolsa@redhat.com>
Message-ID: <tip-9389a46043c8f091dc8f8d8e25a5c1355f8bcc9b@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@kernel.org, a.p.zijlstra@chello.nl,
        jolsa@redhat.com, fweisbec@gmail.com, tglx@linutronix.de,
        cjashfor@linux.vnet.ibm.com, mingo@elte.hu
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        jolsa@redhat.com, fweisbec@gmail.com, tglx@linutronix.de,
        cjashfor@linux.vnet.ibm.com, mingo@elte.hu
In-Reply-To: <20120416184251.GA11503@m.brq.redhat.com>
References: <20120416184251.GA11503@m.brq.redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf session:
  Fail on processing event with unknown size
Git-Commit-ID: 9389a46043c8f091dc8f8d8e25a5c1355f8bcc9b
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Thu, 10 May 2012 23:38:05 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  9389a46043c8f091dc8f8d8e25a5c1355f8bcc9b
Gitweb:     http://git.kernel.org/tip/9389a46043c8f091dc8f8d8e25a5c1355f8bcc9b
Author:     Jiri Olsa <jolsa@redhat.com>
AuthorDate: Mon, 16 Apr 2012 20:42:51 +0200
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Fri, 4 May 2012 11:53:22 -0300

perf session: Fail on processing event with unknown size

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
 1 files changed, 9 insertions(+), 21 deletions(-)

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
