Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754294Ab2ISHHz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2012 03:07:55 -0400
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:47869 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753637Ab2ISHHZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2012 03:07:25 -0400
X-AuditID: 9c93016f-b7c19ae000000e6d-5f-50596f29ee90
From: Namhyung Kim <namhyung@kernel.org>
To: Steven Rostedt <rostedt@goodmis.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>
Subject: [PATCH 3/4] tools lib traceevent: Free field if an error occurs on process_fields
Date: Wed, 19 Sep 2012 15:58:43 +0900
Message-Id: <1348037924-17568-4-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.4
In-Reply-To: <1348037924-17568-1-git-send-email-namhyung@kernel.org>
References: <1348037924-17568-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

The field should be freed on error paths.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/lib/traceevent/event-parse.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/tools/lib/traceevent/event-parse.c b/tools/lib/traceevent/event-parse.c
index bc4e70e3ba29..e0f755111bd0 100644
--- a/tools/lib/traceevent/event-parse.c
+++ b/tools/lib/traceevent/event-parse.c
@@ -2262,10 +2262,10 @@ process_fields(struct event_format *event, struct print_flag_sym **list, char **
 
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
@@ -2275,14 +2275,14 @@ process_fields(struct event_format *event, struct print_flag_sym **list, char **
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
 
@@ -2296,6 +2296,8 @@ process_fields(struct event_format *event, struct print_flag_sym **list, char **
 	*tok = token;
 	return type;
 
+out_free_field:
+	free_flag_sym(field);
 out_free:
 	free_arg(arg);
 	free_token(token);
-- 
1.7.11.4

