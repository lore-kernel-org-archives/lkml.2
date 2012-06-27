Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755638Ab2F0AqZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2012 20:46:25 -0400
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:56752 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755443Ab2F0Apu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2012 20:45:50 -0400
X-AuditID: 9c93016f-b7cbdae0000024ac-1a-4fea57ba382d
From: Namhyung Kim <namhyung@kernel.org>
To: Steven Rostedt <rostedt@goodmis.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>
Subject: [PATCH 3/4] tools lib traceevent: Use local variable 'field'
Date: Wed, 27 Jun 2012 09:41:40 +0900
Message-Id: <1340757701-10711-3-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.10.2
In-Reply-To: <1340757701-10711-1-git-send-email-namhyung@kernel.org>
References: <1340757701-10711-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

Use local variable 'field' to reduce typing. It is needed
by later patch not to exceed 80 column.

Link: http://lkml.kernel.org/n/tip-fz5zzpw09j937nly556wmgfn@git.kernel.org
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/lib/traceevent/event-parse.c |   19 +++++++++++--------
 1 file changed, 11 insertions(+), 8 deletions(-)

diff --git a/tools/lib/traceevent/event-parse.c b/tools/lib/traceevent/event-parse.c
index eb195cbc841c..96cafa7a0fc8 100644
--- a/tools/lib/traceevent/event-parse.c
+++ b/tools/lib/traceevent/event-parse.c
@@ -3257,6 +3257,7 @@ static void print_str_arg(struct trace_seq *s, void *data, int size,
 {
 	struct pevent *pevent = event->pevent;
 	struct print_flag_sym *flag;
+	struct format_field *field;
 	unsigned long long val, fval;
 	unsigned long addr;
 	char *str;
@@ -3271,27 +3272,29 @@ static void print_str_arg(struct trace_seq *s, void *data, int size,
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
1.7.10.2

