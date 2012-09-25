Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755904Ab2IYOh2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 10:37:28 -0400
Received: from casper.infradead.org ([85.118.1.10]:60520 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755540Ab2IYOh1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 10:37:27 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 2/2] tools lib traceevent: Fix error path on pevent_parse_event
Date: Tue, 25 Sep 2012 11:37:19 -0300
Message-Id: <1348583839-4264-3-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
In-Reply-To: <1348583839-4264-1-git-send-email-acme@infradead.org>
References: <1348583839-4264-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="UTF-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung@kernel.org>

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
 
-- 
1.7.1

