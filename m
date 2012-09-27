Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755319Ab2I0Fvo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2012 01:51:44 -0400
Received: from terminus.zytor.com ([198.137.202.10]:54410 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754549Ab2I0Fvm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2012 01:51:42 -0400
Date: Wed, 26 Sep 2012 22:51:25 -0700
From: tip-bot for Namhyung Kim <namhyung@kernel.org>
Message-ID: <tip-f1b2256d66fe8d613b9afcc1c16079362f9fc05c@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@kernel.org, peterz@infradead.org, tglx@linutronix.de,
        namhyung@kernel.org
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        acme@redhat.com, peterz@infradead.org, tglx@linutronix.de,
        namhyung@kernel.org
In-Reply-To: <1348575919-4954-1-git-send-email-namhyung@kernel.org>
References: <1348575919-4954-1-git-send-email-namhyung@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] tools lib traceevent:
  Fix error path on pevent_parse_event
Git-Commit-ID: f1b2256d66fe8d613b9afcc1c16079362f9fc05c
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Wed, 26 Sep 2012 22:51:31 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  f1b2256d66fe8d613b9afcc1c16079362f9fc05c
Gitweb:     http://git.kernel.org/tip/f1b2256d66fe8d613b9afcc1c16079362f9fc05c
Author:     Namhyung Kim <namhyung@kernel.org>
AuthorDate: Tue, 25 Sep 2012 21:25:19 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Tue, 25 Sep 2012 09:53:53 -0300

tools lib traceevent: Fix error path on pevent_parse_event

If __pevent_parse_format() succeeded but add_event() failed, 'ret' didn't
have a proper error code.  Set it to PEVENT_ERRNO__MEM_ALLOC_FAILED.

In addition, at that point 'event' also has fields and format
information and they all need to be freed.  Call pevent_free_format() to
handle it.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/1348575919-4954-1-git-send-email-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/lib/traceevent/event-parse.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/tools/lib/traceevent/event-parse.c b/tools/lib/traceevent/event-parse.c
index 17c9221..47264b4 100644
--- a/tools/lib/traceevent/event-parse.c
+++ b/tools/lib/traceevent/event-parse.c
@@ -5044,8 +5044,10 @@ enum pevent_errno pevent_parse_event(struct pevent *pevent, const char *buf,
 	/* Add pevent to event so that it can be referenced */
 	event->pevent = pevent;
 
-	if (add_event(pevent, event))
+	if (add_event(pevent, event)) {
+		ret = PEVENT_ERRNO__MEM_ALLOC_FAILED;
 		goto event_add_failed;
+	}
 
 #define PRINT_ARGS 0
 	if (PRINT_ARGS && event->print_fmt.args)
@@ -5054,9 +5056,7 @@ enum pevent_errno pevent_parse_event(struct pevent *pevent, const char *buf,
 	return 0;
 
 event_add_failed:
-	free(event->system);
-	free(event->name);
-	free(event);
+	pevent_free_format(event);
 	return ret;
 }
 
