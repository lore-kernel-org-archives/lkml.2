Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933363Ab2GEPq4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2012 11:46:56 -0400
Received: from merlin.infradead.org ([205.233.59.134]:60756 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756801Ab2GEPpo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2012 11:45:44 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Namhyung Kim <namhyung.kim@lge.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Borislav Petkov <bp@alien8.de>, David Ahern <dsahern@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Namhyung Kim <namhyung@kernel.org>
Subject: [PATCH 08/20] tools lib traceevent: Handle strdup failure cases
Date: Thu,  5 Jul 2012 12:45:06 -0300
Message-Id: <1341503118-13198-9-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
In-Reply-To: <1341503118-13198-1-git-send-email-acme@infradead.org>
References: <1341503118-13198-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="UTF-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

There were some places didn't check return value of the strdup and had
unneeded/duplicated checks.  Fix it.

Signed-off-by: Namhyung Kim <namhyung.kim@lge.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: Borislav Petkov <bp@alien8.de>
Cc: David Ahern <dsahern@gmail.com>
Link: http://lkml.kernel.org/r/1333940074-19052-5-git-send-email-namhyung.kim@lge.com
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/lib/traceevent/event-parse.c |   29 +++++++++++++++++++++++++++--
 1 file changed, 27 insertions(+), 2 deletions(-)

diff --git a/tools/lib/traceevent/event-parse.c b/tools/lib/traceevent/event-parse.c
index 768fab5..cd334d5 100644
--- a/tools/lib/traceevent/event-parse.c
+++ b/tools/lib/traceevent/event-parse.c
@@ -467,8 +467,10 @@ int pevent_register_function(struct pevent *pevent, char *func,
 		item->mod = NULL;
 	item->addr = addr;
 
-	pevent->funclist = item;
+	if (!item->func || (mod && !item->mod))
+		die("malloc func");
 
+	pevent->funclist = item;
 	pevent->func_count++;
 
 	return 0;
@@ -583,10 +585,13 @@ int pevent_register_print_string(struct pevent *pevent, char *fmt,
 	item = malloc_or_die(sizeof(*item));
 
 	item->next = pevent->printklist;
-	pevent->printklist = item;
 	item->printk = strdup(fmt);
 	item->addr = addr;
 
+	if (!item->printk)
+		die("malloc fmt");
+
+	pevent->printklist = item;
 	pevent->printk_count++;
 
 	return 0;
@@ -2150,6 +2155,8 @@ process_fields(struct event_format *event, struct print_flag_sym **list, char **
 		if (value == NULL)
 			goto out_free;
 		field->value = strdup(value);
+		if (field->value == NULL)
+			goto out_free;
 
 		free_arg(arg);
 		arg = alloc_arg();
@@ -2163,6 +2170,8 @@ process_fields(struct event_format *event, struct print_flag_sym **list, char **
 		if (value == NULL)
 			goto out_free;
 		field->str = strdup(value);
+		if (field->str == NULL)
+			goto out_free;
 		free_arg(arg);
 		arg = NULL;
 
@@ -3433,6 +3442,9 @@ process_defined_func(struct trace_seq *s, void *data, int size,
 			string = malloc_or_die(sizeof(*string));
 			string->next = strings;
 			string->str = strdup(str.buffer);
+			if (!string->str)
+				die("malloc str");
+
 			strings = string;
 			trace_seq_destroy(&str);
 			break;
@@ -3571,6 +3583,8 @@ static struct print_arg *make_bprint_args(char *fmt, void *data, int size, struc
 				arg->next = NULL;
 				arg->type = PRINT_BSTRING;
 				arg->string.string = strdup(bptr);
+				if (!arg->string.string)
+					break;
 				bptr += strlen(bptr) + 1;
 				*next = arg;
 				next = &arg->next;
@@ -4666,6 +4680,8 @@ int pevent_parse_event(struct pevent *pevent,
 		die("failed to read event id");
 
 	event->system = strdup(sys);
+	if (!event->system)
+		die("failed to allocate system");
 
 	/* Add pevent to event so that it can be referenced */
 	event->pevent = pevent;
@@ -4707,6 +4723,10 @@ int pevent_parse_event(struct pevent *pevent,
 			list = &arg->next;
 			arg->type = PRINT_FIELD;
 			arg->field.name = strdup(field->name);
+			if (!arg->field.name) {
+				do_warning("failed to allocate field name");
+				goto event_failed;
+			}
 			arg->field.field = field;
 		}
 		return 0;
@@ -5050,6 +5070,11 @@ int pevent_register_event_handler(struct pevent *pevent,
 	if (sys_name)
 		handle->sys_name = strdup(sys_name);
 
+	if ((event_name && !handle->event_name) ||
+	    (sys_name && !handle->sys_name)) {
+		die("Failed to allocate event/sys name");
+	}
+
 	handle->func = func;
 	handle->next = pevent->handlers;
 	pevent->handlers = handle;
-- 
1.7.9.2.358.g22243

