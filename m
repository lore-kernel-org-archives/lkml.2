Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758278Ab2EXQl4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2012 12:41:56 -0400
Received: from casper.infradead.org ([85.118.1.10]:44657 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752591Ab2EXQkb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2012 12:40:31 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Namhyung Kim <namhyung.kim@lge.com>,
        Borislav Petkov <bp@alien8.de>, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Namhyung Kim <namhyung@gmail.com>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Steven Rostedt <rostedt@goodmis.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 4/6] tools lib traceevent: Fix freeing arg on process_dynamic_array()
Date: Thu, 24 May 2012 13:40:11 -0300
Message-Id: <1337877613-15133-5-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
In-Reply-To: <1337877613-15133-1-git-send-email-acme@infradead.org>
References: <1337877613-15133-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="UTF-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

The @arg paremeter should not be freed inside of process_XXX(),
because it'd be freed from the caller of process_arg(). We can
free it only after it was reused for local usage.

Cc: Borislav Petkov <bp@alien8.de>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1337740619-27925-14-git-send-email-namhyung.kim@lge.com
Signed-off-by: Namhyung Kim <namhyung.kim@lge.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/lib/traceevent/event-parse.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/tools/lib/traceevent/event-parse.c b/tools/lib/traceevent/event-parse.c
index 445a43a..3559027 100644
--- a/tools/lib/traceevent/event-parse.c
+++ b/tools/lib/traceevent/event-parse.c
@@ -2300,17 +2300,18 @@ process_dynamic_array(struct event_format *event, struct print_arg *arg, char **
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
1.7.9.2.358.g22243

