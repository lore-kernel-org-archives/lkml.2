Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756559Ab2DEWsb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2012 18:48:31 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:48332 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756391Ab2DEWs3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2012 18:48:29 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Tom Zanussi <tzanussi@gmail.com>, Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Borislav Petkov <bp@alien8.de>, Jiri Olsa <jolsa@redhat.com>,
        Arun Sharma <asharma@fb.com>, Namhyung Kim <namhyung.kim@lge.com>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 07/15] perf/events: Add flag/symbol format_flags
Date: Fri,  6 Apr 2012 00:47:58 +0200
Message-Id: <1333666086-6517-8-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1333666086-6517-1-git-send-email-fweisbec@gmail.com>
References: <1333666086-6517-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tom Zanussi <tzanussi@gmail.com>

This is a port of commit eb9a42caa7a92
 perf trace: Add flag/symbolic format_flags
of the old trace-event-parse.c to the new event-parse.c that
was written by Tom Zanussi and forward ported by Steven Rostedt.

Signed-off-by: Tom Zanussi <tzanussi@gmail.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Arun Sharma <asharma@fb.com>
Cc: Namhyung Kim <namhyung.kim@lge.com>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 tools/lib/traceevent/event-parse.c |   15 +++++++++++++++
 1 files changed, 15 insertions(+), 0 deletions(-)

diff --git a/tools/lib/traceevent/event-parse.c b/tools/lib/traceevent/event-parse.c
index c799c19..f012395 100644
--- a/tools/lib/traceevent/event-parse.c
+++ b/tools/lib/traceevent/event-parse.c
@@ -39,6 +39,9 @@ static const char *input_buf;
 static unsigned long long input_buf_ptr;
 static unsigned long long input_buf_siz;
 
+static int is_flag_field;
+static int is_symbolic_field;
+
 static int show_warning = 1;
 
 #define do_warning(fmt, ...)				\
@@ -1789,6 +1792,16 @@ process_entry(struct event_format *event __unused, struct print_arg *arg,
 	arg->type = PRINT_FIELD;
 	arg->field.name = field;
 
+	if (is_flag_field) {
+		arg->field.field = pevent_find_any_field(event, arg->field.name);
+		arg->field.field->flags |= FIELD_IS_FLAG;
+		is_flag_field = 0;
+	} else if (is_symbolic_field) {
+		arg->field.field = pevent_find_any_field(event, arg->field.name);
+		arg->field.field->flags |= FIELD_IS_SYMBOLIC;
+		is_symbolic_field = 0;
+	}
+
 	type = read_token(&token);
 	*tok = token;
 
@@ -2398,10 +2411,12 @@ process_function(struct event_format *event, struct print_arg *arg,
 
 	if (strcmp(token, "__print_flags") == 0) {
 		free_token(token);
+		is_flag_field = 1;
 		return process_flags(event, arg, tok);
 	}
 	if (strcmp(token, "__print_symbolic") == 0) {
 		free_token(token);
+		is_symbolic_field = 1;
 		return process_symbols(event, arg, tok);
 	}
 	if (strcmp(token, "__get_str") == 0) {
-- 
1.7.5.4

