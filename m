Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752466Ab2DWE7Z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2012 00:59:25 -0400
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:46999 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751594Ab2DWE7X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2012 00:59:23 -0400
X-AuditID: 9c93016f-b7cfcae00000449e-a9-4f94e1a92333
From: Namhyung Kim <namhyung.kim@lge.com>
To: Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Cc: Namhyung Kim <namhyung@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Borislav Petkov <bp@alien8.de>, David Ahern <dsahern@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 01/11] parse-events: Free flag/sym field on failure path
Date: Mon, 23 Apr 2012 13:58:28 +0900
Message-Id: <1335157118-14658-2-git-send-email-namhyung.kim@lge.com>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <1335157118-14658-1-git-send-email-namhyung.kim@lge.com>
References: <1335157118-14658-1-git-send-email-namhyung.kim@lge.com>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If parsing flag/sym field failed after allocating it, it
should be freed.

Signed-off-by: Namhyung Kim <namhyung.kim@lge.com>
---
 parse-events.c |   14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff --git a/parse-events.c b/parse-events.c
index bd078ba..81e6581 100644
--- a/parse-events.c
+++ b/parse-events.c
@@ -2166,10 +2166,10 @@ process_fields(struct event_format *event, struct print_flag_sym **list, char **
 
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
@@ -2177,14 +2177,14 @@ process_fields(struct event_format *event, struct print_flag_sym **list, char **
 		free_token(token);
 		type = process_arg(event, arg, &token);
 		if (test_type_token(type, token, EVENT_OP, "}"))
-			goto out_free;
+			goto out_free_field_value;
 
 		value = arg_eval(arg);
 		if (value == NULL)
-			goto out_free;
+			goto out_free_field_value;
 		field->str = strdup(value);
 		if (field->str == NULL)
-			goto out_free;
+			goto out_free_field_value;
 		free_arg(arg);
 		arg = NULL;
 
@@ -2198,6 +2198,10 @@ process_fields(struct event_format *event, struct print_flag_sym **list, char **
 	*tok = token;
 	return type;
 
+out_free_field_value:
+	free(field->value);
+out_free_field:
+	free(field);
 out_free:
 	free_arg(arg);
 	free_token(token);
-- 
1.7.10

