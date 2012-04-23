Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753383Ab2DWFAX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2012 01:00:23 -0400
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:46999 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751907Ab2DWE7Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2012 00:59:24 -0400
X-AuditID: 9c93016f-b7cfcae00000449e-b0-4f94e1a9f300
From: Namhyung Kim <namhyung.kim@lge.com>
To: Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Cc: Namhyung Kim <namhyung@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Borislav Petkov <bp@alien8.de>, David Ahern <dsahern@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 03/11] parse-events: Get rid of handling concatenation on event_read_print
Date: Mon, 23 Apr 2012 13:58:30 +0900
Message-Id: <1335157118-14658-4-git-send-email-namhyung.kim@lge.com>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <1335157118-14658-1-git-send-email-namhyung.kim@lge.com>
References: <1335157118-14658-1-git-send-email-namhyung.kim@lge.com>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The concatenation of subsequent DQUOTE'd strings is handled
by __read_token() already.

Signed-off-by: Namhyung Kim <namhyung.kim@lge.com>
---
 parse-events.c |   16 ----------------
 1 file changed, 16 deletions(-)

diff --git a/parse-events.c b/parse-events.c
index 0cd79c5..b4ae313 100644
--- a/parse-events.c
+++ b/parse-events.c
@@ -2695,7 +2695,6 @@ static int event_read_print(struct event_format *event)
 	if (read_expect_type(EVENT_DQUOTE, &token) < 0)
 		goto fail;
 
- concat:
 	event->print_fmt.format = token;
 	event->print_fmt.args = NULL;
 
@@ -2705,21 +2704,6 @@ static int event_read_print(struct event_format *event)
 	if (type == EVENT_NONE)
 		return 0;
 
-	/* Handle concatenation of print lines */
-	if (type == EVENT_DQUOTE) {
-		char *cat;
-
-		cat = malloc_or_die(strlen(event->print_fmt.format) +
-				    strlen(token) + 1);
-		strcpy(cat, event->print_fmt.format);
-		strcat(cat, token);
-		free_token(token);
-		free_token(event->print_fmt.format);
-		event->print_fmt.format = NULL;
-		token = cat;
-		goto concat;
-	}
-			     
 	if (test_type_token(type, token, EVENT_DELIM, ","))
 		goto fail;
 
-- 
1.7.10

