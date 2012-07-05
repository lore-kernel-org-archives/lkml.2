Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756798Ab2GEPpn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2012 11:45:43 -0400
Received: from casper.infradead.org ([85.118.1.10]:59135 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030179Ab2GEPph (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2012 11:45:37 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Namhyung Kim <namhyung.kim@lge.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Borislav Petkov <bp@alien8.de>, David Ahern <dsahern@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Namhyung Kim <namhyung@kernel.org>
Subject: [PATCH 09/20] tools lib traceevent: Handle realloc() failure path
Date: Thu,  5 Jul 2012 12:45:07 -0300
Message-Id: <1341503118-13198-10-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
In-Reply-To: <1341503118-13198-1-git-send-email-acme@infradead.org>
References: <1341503118-13198-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="UTF-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

The realloc can fail so that we should handle it properly.

Signed-off-by: Namhyung Kim <namhyung.kim@lge.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: Borislav Petkov <bp@alien8.de>
Cc: David Ahern <dsahern@gmail.com>
Link: http://lkml.kernel.org/r/1333940074-19052-7-git-send-email-namhyung.kim@lge.com
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/lib/traceevent/event-parse.c |   76 ++++++++++++++++++++++++++++--------
 1 file changed, 60 insertions(+), 16 deletions(-)

diff --git a/tools/lib/traceevent/event-parse.c b/tools/lib/traceevent/event-parse.c
index cd334d5..05eb6b4 100644
--- a/tools/lib/traceevent/event-parse.c
+++ b/tools/lib/traceevent/event-parse.c
@@ -1264,9 +1264,15 @@ static int event_read_fields(struct event_format *event, struct format_field **f
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
@@ -1291,6 +1297,7 @@ static int event_read_fields(struct event_format *event, struct format_field **f
 		if (strcmp(token, "[") == 0) {
 			enum event_type last_type = type;
 			char *brackets = token;
+			char *new_brackets;
 			int len;
 
 			field->flags |= FIELD_IS_ARRAY;
@@ -1310,9 +1317,14 @@ static int event_read_fields(struct event_format *event, struct format_field **f
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
@@ -1328,7 +1340,12 @@ static int event_read_fields(struct event_format *event, struct format_field **f
 
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
@@ -1339,10 +1356,16 @@ static int event_read_fields(struct event_format *event, struct format_field **f
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
@@ -1350,9 +1373,15 @@ static int event_read_fields(struct event_format *event, struct format_field **f
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
@@ -1735,10 +1764,16 @@ process_op(struct event_format *event, struct print_arg *arg, char **tok)
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
@@ -2597,7 +2632,16 @@ process_arg_token(struct event_format *event, struct print_arg *arg,
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
1.7.9.2.358.g22243

