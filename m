Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964852Ab2EWCjS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 22:39:18 -0400
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:43911 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933549Ab2EWCjK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 22:39:10 -0400
X-AuditID: 9c93016f-b7c3cae000001954-d4-4fbc4dc98193
From: Namhyung Kim <namhyung.kim@lge.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>, Namhyung Kim <namhyung@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Borislav Petkov <bp@alien8.de>, David Ahern <dsahern@gmail.com>
Subject: [PATCH 13/22] lib/traceevent: Fix freeing arg on process_dynamic_array()
Date: Wed, 23 May 2012 11:36:50 +0900
Message-Id: <1337740619-27925-14-git-send-email-namhyung.kim@lge.com>
X-Mailer: git-send-email 1.7.10.1
In-Reply-To: <1337740619-27925-1-git-send-email-namhyung.kim@lge.com>
References: <1337740619-27925-1-git-send-email-namhyung.kim@lge.com>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The @arg paremeter should not be freed inside of process_XXX(),
because it'd be freed from the caller of process_arg(). We can
free it only after it was reused for local usage.

Link: http://lkml.kernel.org/r/1335157118-14658-3-git-send-email-namhyung.kim@lge.com

Signed-off-by: Namhyung Kim <namhyung.kim@lge.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: Borislav Petkov <bp@alien8.de>
Cc: David Ahern <dsahern@gmail.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 tools/lib/traceevent/event-parse.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/tools/lib/traceevent/event-parse.c b/tools/lib/traceevent/event-parse.c
index 865d0f268274..eb9babbf8e55 100644
--- a/tools/lib/traceevent/event-parse.c
+++ b/tools/lib/traceevent/event-parse.c
@@ -2342,17 +2342,18 @@ process_dynamic_array(struct event_format *event, struct print_arg *arg, char **
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
1.7.10.1

