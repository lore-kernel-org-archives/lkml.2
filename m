Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757291Ab2IXQES (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2012 12:04:18 -0400
Received: from merlin.infradead.org ([205.233.59.134]:58780 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756690Ab2IXQAA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2012 12:00:00 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Namhyung Kim <namhyung.kim@lge.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Steven Rostedt <rostedt@goodmis.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 20/30] tools lib traceevent: Free field if an error occurs on process_fields
Date: Mon, 24 Sep 2012 12:59:34 -0300
Message-Id: <1348502384-14442-21-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
In-Reply-To: <1348502384-14442-1-git-send-email-acme@infradead.org>
References: <1348502384-14442-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="UTF-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

The field should be freed on error paths.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Steven Rostedt <rostedt@goodmis.org>
Link: http://lkml.kernel.org/r/1348037924-17568-4-git-send-email-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/lib/traceevent/event-parse.c |   12 +++++++-----
 1 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/tools/lib/traceevent/event-parse.c b/tools/lib/traceevent/event-parse.c
index 27088c5..a776ed5 100644
--- a/tools/lib/traceevent/event-parse.c
+++ b/tools/lib/traceevent/event-parse.c
@@ -2186,10 +2186,10 @@ process_fields(struct event_format *event, struct print_flag_sym **list, char **
 
 		value = arg_eval(arg);
 		if (value == NULL)
-			goto out_free;
+			goto out_free_field;
 		field->value = strdup(value);
 		if (field->value == NULL)
-			goto out_free;
+			goto out_free_field;
 
 		free_arg(arg);
 		arg = alloc_arg();
@@ -2197,14 +2197,14 @@ process_fields(struct event_format *event, struct print_flag_sym **list, char **
 		free_token(token);
 		type = process_arg(event, arg, &token);
 		if (test_type_token(type, token, EVENT_OP, "}"))
-			goto out_free;
+			goto out_free_field;
 
 		value = arg_eval(arg);
 		if (value == NULL)
-			goto out_free;
+			goto out_free_field;
 		field->str = strdup(value);
 		if (field->str == NULL)
-			goto out_free;
+			goto out_free_field;
 		free_arg(arg);
 		arg = NULL;
 
@@ -2218,6 +2218,8 @@ process_fields(struct event_format *event, struct print_flag_sym **list, char **
 	*tok = token;
 	return type;
 
+out_free_field:
+	free_flag_sym(field);
 out_free:
 	free_arg(arg);
 	free_token(token);
-- 
1.7.1

