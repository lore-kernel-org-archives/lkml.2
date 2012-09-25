Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753883Ab2IYMZs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 08:25:48 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:62780 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751507Ab2IYMZr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 08:25:47 -0400
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] tools lib traceevent: Fix error path on pevent_parse_event
Date: Tue, 25 Sep 2012 21:25:19 +0900
Message-Id: <1348575919-4954-1-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.9.2
In-Reply-To: <20120925111203.GB28902@infradead.org>
References: <20120925111203.GB28902@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If __pevent_parse_format() succeeded but add_event() failed, 'ret' didn't
have a proper error code.  Set it to PEVENT_ERRNO__MEM_ALLOC_FAILED.

In addition, at that point 'event' also has fields and format information
and they all need to be freed.  Call pevent_free_format() to handle it.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/lib/traceevent/event-parse.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/tools/lib/traceevent/event-parse.c b/tools/lib/traceevent/event-parse.c
index 17c922145e88..47264b4652b9 100644
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
1.7.9.2

