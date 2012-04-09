Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756692Ab2DICyo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Apr 2012 22:54:44 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:64221 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756634Ab2DICyl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Apr 2012 22:54:41 -0400
X-AuditID: 9c930197-b7b09ae000000a5d-cd-4f824f6d5321
From: Namhyung Kim <namhyung.kim@lge.com>
To: Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@infradead.org>,
        Borislav Petkov <bp@alien8.de>, David Ahern <dsahern@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 6/7] parse-events: Handle realloc() failure path
Date: Mon,  9 Apr 2012 11:54:33 +0900
Message-Id: <1333940074-19052-7-git-send-email-namhyung.kim@lge.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1333940074-19052-1-git-send-email-namhyung.kim@lge.com>
References: <1333940074-19052-1-git-send-email-namhyung.kim@lge.com>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The realloc can fail so that we should handle it properly.

Signed-off-by: Namhyung Kim <namhyung.kim@lge.com>
---
 parse-events.c |   76 ++++++++++++++++++++++++++++++++++++++++++++------------
 1 files changed, 60 insertions(+), 16 deletions(-)

diff --git a/parse-events.c b/parse-events.c
index 710a9e8..e789275 100644
--- a/parse-events.c
+++ b/parse-events.c
@@ -1252,9 +1252,15 @@ static int event_read_fields(struct event_format *event, struct format_field **f
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
@@ -1279,6 +1285,7 @@ static int event_read_fields(struct event_format *event, struct format_field **f
 		if (strcmp(token, "[") == 0) {
 			enum event_type last_type = type;
 			char *brackets = token;
+			char *new_brackets;
 			int len;
 
 			field->flags |= FIELD_IS_ARRAY;
@@ -1298,9 +1305,14 @@ static int event_read_fields(struct event_format *event, struct format_field **f
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
@@ -1316,7 +1328,12 @@ static int event_read_fields(struct event_format *event, struct format_field **f
 
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
@@ -1327,10 +1344,16 @@ static int event_read_fields(struct event_format *event, struct format_field **f
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
@@ -1338,9 +1361,15 @@ static int event_read_fields(struct event_format *event, struct format_field **f
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
@@ -1721,10 +1750,16 @@ process_op(struct event_format *event, struct print_arg *arg, char **tok)
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
@@ -2527,7 +2562,16 @@ process_arg_token(struct event_format *event, struct print_arg *arg,
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
1.7.7.6

