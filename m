Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753746Ab2DWFAj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2012 01:00:39 -0400
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:48856 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751635Ab2DWE7Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2012 00:59:24 -0400
X-AuditID: 9c93016f-b7cfcae00000449e-ad-4f94e1a9371e
From: Namhyung Kim <namhyung.kim@lge.com>
To: Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Cc: Namhyung Kim <namhyung@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Borislav Petkov <bp@alien8.de>, David Ahern <dsahern@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 02/11] parse-events: Fix freeing arg on process_dynamic_array()
Date: Mon, 23 Apr 2012 13:58:29 +0900
Message-Id: <1335157118-14658-3-git-send-email-namhyung.kim@lge.com>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <1335157118-14658-1-git-send-email-namhyung.kim@lge.com>
References: <1335157118-14658-1-git-send-email-namhyung.kim@lge.com>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The @arg paremeter should not be freed inside of process_XXX(),
because it'd be freed from the caller of process_arg(). We can
free it only after it was reused for local usage.

Signed-off-by: Namhyung Kim <namhyung.kim@lge.com>
---
 parse-events.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/parse-events.c b/parse-events.c
index 81e6581..0cd79c5 100644
--- a/parse-events.c
+++ b/parse-events.c
@@ -2330,17 +2330,18 @@ process_dynamic_array(struct event_format *event, struct print_arg *arg, char **
 	arg = alloc_arg();
 	type = process_arg(event, arg, &token);
 	if (type == EVENT_ERROR)
-		goto out_free;
+		goto out_free_arg;
 
 	if (!test_type_token(type, token, EVENT_OP, "]"))
-		goto out_free;
+		goto out_free_arg;
 
 	free_token(token);
 	type = read_token_item(tok);
 	return type;
 
+ out_free_arg:
+	free_arg(arg);
  out_free:
-	free(arg);
 	free_token(token);
 	*tok = NULL;
 	return EVENT_ERROR;
-- 
1.7.10

