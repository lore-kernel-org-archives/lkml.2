Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964916Ab2EWCjW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 22:39:22 -0400
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:43911 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933545Ab2EWCjI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 22:39:08 -0400
X-AuditID: 9c93016f-b7c3cae000001954-b6-4fbc4dc88c7c
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
Subject: [PATCH 11/22] lib/traceevent: Handle realloc() failure path
Date: Wed, 23 May 2012 11:36:48 +0900
Message-Id: <1337740619-27925-12-git-send-email-namhyung.kim@lge.com>
X-Mailer: git-send-email 1.7.10.1
In-Reply-To: <1337740619-27925-1-git-send-email-namhyung.kim@lge.com>
References: <1337740619-27925-1-git-send-email-namhyung.kim@lge.com>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The realloc can fail so that we should handle it properly.

Link: http://lkml.kernel.org/r/1333940074-19052-7-git-send-email-namhyung.kim@lge.com

Signed-off-by: Namhyung Kim <namhyung.kim@lge.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: Borislav Petkov <bp@alien8.de>
Cc: David Ahern <dsahern@gmail.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 tools/lib/traceevent/event-parse.c |   76 ++++++++++++++++++++++++++++--------
 1 file changed, 60 insertions(+), 16 deletions(-)

diff --git a/tools/lib/traceevent/event-parse.c b/tools/lib/traceevent/event-parse.c
index 0fa09c62a14a..6a8e3169ac68 100644
--- a/tools/lib/traceevent/event-parse.c
+++ b/tools/lib/traceevent/event-parse.c
@@ -1258,9 +1258,15 @@ static int event_read_fields(struct event_format *event, struct format_field **f
 					field->flags |= FIELD_IS_POINTER;
 
 				if (field->type) {
-					field->type = realloc(field->type,
-							      strlen(field->type) +
-							      strlen(last_token) + 2);
+					char *new_type;
+					new_type = realloc(field->type,
+							   strlen(field->type) +
+							   strlen(last_token) + 2);
+					if (!new_type) {
+						free(last_token);
+						goto fail;
+					}
+					field->type = new_type;
 					strcat(field->type, " ");
 					strcat(field->type, last_token);
 					free(last_token);
@@ -1285,6 +1291,7 @@ static int event_read_fields(struct event_format *event, struct format_field **f
 		if (strcmp(token, "[") == 0) {
 			enum event_type last_type = type;
 			char *brackets = token;
+			char *new_brackets;
 			int len;
 
 			field->flags |= FIELD_IS_ARRAY;
@@ -1304,9 +1311,14 @@ static int event_read_fields(struct event_format *event, struct format_field **f
 					len = 1;
 				last_type = type;
 
-				brackets = realloc(brackets,
-						   strlen(brackets) +
-						   strlen(token) + len);
+				new_brackets = realloc(brackets,
+						       strlen(brackets) +
+						       strlen(token) + len);
+				if (!new_brackets) {
+					free(brackets);
+					goto fail;
+				}
+				brackets = new_brackets;
 				if (len == 2)
 					strcat(brackets, " ");
 				strcat(brackets, token);
@@ -1322,7 +1334,12 @@ static int event_read_fields(struct event_format *event, struct format_field **f
 
 			free_token(token);
 
-			brackets = realloc(brackets, strlen(brackets) + 2);
+			new_brackets = realloc(brackets, strlen(brackets) + 2);
+			if (!new_brackets) {
+				free(brackets);
+				goto fail;
+			}
+			brackets = new_brackets;
 			strcat(brackets, "]");
 
 			/* add brackets to type */
@@ -1333,10 +1350,16 @@ static int event_read_fields(struct event_format *event, struct format_field **f
 			 * the format: type [] item;
 			 */
 			if (type == EVENT_ITEM) {
-				field->type = realloc(field->type,
-						      strlen(field->type) +
-						      strlen(field->name) +
-						      strlen(brackets) + 2);
+				char *new_type;
+				new_type = realloc(field->type,
+						   strlen(field->type) +
+						   strlen(field->name) +
+						   strlen(brackets) + 2);
+				if (!new_type) {
+					free(brackets);
+					goto fail;
+				}
+				field->type = new_type;
 				strcat(field->type, " ");
 				strcat(field->type, field->name);
 				free_token(field->name);
@@ -1344,9 +1367,15 @@ static int event_read_fields(struct event_format *event, struct format_field **f
 				field->name = token;
 				type = read_token(&token);
 			} else {
-				field->type = realloc(field->type,
-						      strlen(field->type) +
-						      strlen(brackets) + 1);
+				char *new_type;
+				new_type = realloc(field->type,
+						   strlen(field->type) +
+						   strlen(brackets) + 1);
+				if (!new_type) {
+					free(brackets);
+					goto fail;
+				}
+				field->type = new_type;
 				strcat(field->type, brackets);
 			}
 			free(brackets);
@@ -1727,10 +1756,16 @@ process_op(struct event_format *event, struct print_arg *arg, char **tok)
 		/* could just be a type pointer */
 		if ((strcmp(arg->op.op, "*") == 0) &&
 		    type == EVENT_DELIM && (strcmp(token, ")") == 0)) {
+			char *new_atom;
+
 			if (left->type != PRINT_ATOM)
 				die("bad pointer type");
-			left->atom.atom = realloc(left->atom.atom,
+			new_atom = realloc(left->atom.atom,
 					    strlen(left->atom.atom) + 3);
+			if (!new_atom)
+				goto out_free;
+
+			left->atom.atom = new_atom;
 			strcat(left->atom.atom, " *");
 			free(arg->op.op);
 			*arg = *left;
@@ -2545,7 +2580,16 @@ process_arg_token(struct event_format *event, struct print_arg *arg,
 		}
 		/* atoms can be more than one token long */
 		while (type == EVENT_ITEM) {
-			atom = realloc(atom, strlen(atom) + strlen(token) + 2);
+			char *new_atom;
+			new_atom = realloc(atom,
+					   strlen(atom) + strlen(token) + 2);
+			if (!new_atom) {
+				free(atom);
+				*tok = NULL;
+				free_token(token);
+				return EVENT_ERROR;
+			}
+			atom = new_atom;
 			strcat(atom, " ");
 			strcat(atom, token);
 			free_token(token);
-- 
1.7.10.1

