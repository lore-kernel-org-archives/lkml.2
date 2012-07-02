Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756261Ab2GBUVO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2012 16:21:14 -0400
Received: from casper.infradead.org ([85.118.1.10]:42286 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932762Ab2GBUTC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2012 16:19:02 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Namhyung Kim <namhyung.kim@lge.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Steven Rostedt <rostedt@goodmis.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 05/13] tools lib traceevent: Use local variable 'field'
Date: Mon,  2 Jul 2012 17:18:43 -0300
Message-Id: <1341260331-10204-6-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
In-Reply-To: <1341260331-10204-1-git-send-email-acme@infradead.org>
References: <1341260331-10204-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="UTF-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

Use local variable 'field' to reduce typing. It is needed by later patch
not to exceed 80 column.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Steven Rostedt <rostedt@goodmis.org>
Link: http://lkml.kernel.org/r/1340757701-10711-3-git-send-email-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/lib/traceevent/event-parse.c |   19 +++++++++++--------
 1 file changed, 11 insertions(+), 8 deletions(-)

diff --git a/tools/lib/traceevent/event-parse.c b/tools/lib/traceevent/event-parse.c
index b203a50..63d02be 100644
--- a/tools/lib/traceevent/event-parse.c
+++ b/tools/lib/traceevent/event-parse.c
@@ -3214,6 +3214,7 @@ static void print_str_arg(struct trace_seq *s, void *data, int size,
 {
 	struct pevent *pevent = event->pevent;
 	struct print_flag_sym *flag;
+	struct format_field *field;
 	unsigned long long val, fval;
 	unsigned long addr;
 	char *str;
@@ -3228,27 +3229,29 @@ static void print_str_arg(struct trace_seq *s, void *data, int size,
 		print_str_to_seq(s, format, len_arg, arg->atom.atom);
 		return;
 	case PRINT_FIELD:
-		if (!arg->field.field) {
-			arg->field.field = pevent_find_any_field(event, arg->field.name);
-			if (!arg->field.field)
+		field = arg->field.field;
+		if (!field) {
+			field = pevent_find_any_field(event, arg->field.name);
+			if (!field)
 				die("field %s not found", arg->field.name);
+			arg->field.field = field;
 		}
 		/* Zero sized fields, mean the rest of the data */
-		len = arg->field.field->size ? : size - arg->field.field->offset;
+		len = field->size ? : size - field->offset;
 
 		/*
 		 * Some events pass in pointers. If this is not an array
 		 * and the size is the same as long_size, assume that it
 		 * is a pointer.
 		 */
-		if (!(arg->field.field->flags & FIELD_IS_ARRAY) &&
-		    arg->field.field->size == pevent->long_size) {
-			addr = *(unsigned long *)(data + arg->field.field->offset);
+		if (!(field->flags & FIELD_IS_ARRAY) &&
+		    field->size == pevent->long_size) {
+			addr = *(unsigned long *)(data + field->offset);
 			trace_seq_printf(s, "%lx", addr);
 			break;
 		}
 		str = malloc_or_die(len + 1);
-		memcpy(str, data + arg->field.field->offset, len);
+		memcpy(str, data + field->offset, len);
 		str[len] = 0;
 		print_str_to_seq(s, format, len_arg, str);
 		free(str);
-- 
1.7.9.2.358.g22243

