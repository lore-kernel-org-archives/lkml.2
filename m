Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933423Ab2GFKyn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2012 06:54:43 -0400
Received: from terminus.zytor.com ([198.137.202.10]:51405 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932831Ab2GFKyl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2012 06:54:41 -0400
Date: Fri, 6 Jul 2012 03:54:21 -0700
From: tip-bot for Namhyung Kim <namhyung.kim@lge.com>
Message-ID: <tip-b700807196ac8d87e00fed9fda80ab89b7f56db6@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@kernel.org, a.p.zijlstra@chello.nl, namhyung.kim@lge.com,
        namhyung@kernel.org, fweisbec@gmail.com, rostedt@goodmis.org,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        acme@redhat.com, a.p.zijlstra@chello.nl, namhyung.kim@lge.com,
        namhyung@kernel.org, fweisbec@gmail.com, rostedt@goodmis.org,
        tglx@linutronix.de
In-Reply-To: <1340757701-10711-3-git-send-email-namhyung@kernel.org>
References: <1340757701-10711-3-git-send-email-namhyung@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] tools lib traceevent: Use local variable 'field'
Git-Commit-ID: b700807196ac8d87e00fed9fda80ab89b7f56db6
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Fri, 06 Jul 2012 03:54:27 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  b700807196ac8d87e00fed9fda80ab89b7f56db6
Gitweb:     http://git.kernel.org/tip/b700807196ac8d87e00fed9fda80ab89b7f56db6
Author:     Namhyung Kim <namhyung.kim@lge.com>
AuthorDate: Wed, 27 Jun 2012 09:41:40 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Fri, 29 Jun 2012 13:28:12 -0300

tools lib traceevent: Use local variable 'field'

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
 1 files changed, 11 insertions(+), 8 deletions(-)

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
