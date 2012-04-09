Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756708Ab2DICzg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Apr 2012 22:55:36 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:64221 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751747Ab2DICyk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Apr 2012 22:54:40 -0400
X-AuditID: 9c930197-b7b09ae000000a5d-c6-4f824f6d59fd
From: Namhyung Kim <namhyung.kim@lge.com>
To: Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@infradead.org>,
        Borislav Petkov <bp@alien8.de>, David Ahern <dsahern@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 4/7] parse-events: Handle strdup failure cases
Date: Mon,  9 Apr 2012 11:54:31 +0900
Message-Id: <1333940074-19052-5-git-send-email-namhyung.kim@lge.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1333940074-19052-1-git-send-email-namhyung.kim@lge.com>
References: <1333940074-19052-1-git-send-email-namhyung.kim@lge.com>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There were some places didn't check return value of the strdup
and had unneeded/duplicated checks. Fix it.

Signed-off-by: Namhyung Kim <namhyung.kim@lge.com>
---
 parse-events.c |   29 +++++++++++++++++++++++++++--
 1 files changed, 27 insertions(+), 2 deletions(-)

diff --git a/parse-events.c b/parse-events.c
index 0b1e40a..773c928 100644
--- a/parse-events.c
+++ b/parse-events.c
@@ -463,8 +463,10 @@ int pevent_register_function(struct pevent *pevent, char *func,
 		item->mod = NULL;
 	item->addr = addr;
 
-	pevent->funclist = item;
+	if (!item->func || (mod && !item->mod))
+		die("malloc func");
 
+	pevent->funclist = item;
 	pevent->func_count++;
 
 	return 0;
@@ -579,10 +581,13 @@ int pevent_register_print_string(struct pevent *pevent, char *fmt,
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
@@ -2123,6 +2128,8 @@ process_fields(struct event_format *event, struct print_flag_sym **list, char **
 		if (value == NULL)
 			goto out_free;
 		field->value = strdup(value);
+		if (field->value == NULL)
+			goto out_free;
 
 		free_arg(arg);
 		arg = alloc_arg();
@@ -2136,6 +2143,8 @@ process_fields(struct event_format *event, struct print_flag_sym **list, char **
 		if (value == NULL)
 			goto out_free;
 		field->str = strdup(value);
+		if (field->str == NULL)
+			goto out_free;
 		free_arg(arg);
 		arg = NULL;
 
@@ -3338,6 +3347,9 @@ process_defined_func(struct trace_seq *s, void *data, int size,
 			string = malloc_or_die(sizeof(*string));
 			string->next = strings;
 			string->str = strdup(str.buffer);
+			if (!string->str)
+				die("malloc str");
+
 			strings = string;
 			trace_seq_destroy(&str);
 			break;
@@ -3475,6 +3487,8 @@ static struct print_arg *make_bprint_args(char *fmt, void *data, int size, struc
 				arg->next = NULL;
 				arg->type = PRINT_BSTRING;
 				arg->string.string = strdup(bptr);
+				if (!arg->string.string)
+					break;
 				bptr += strlen(bptr) + 1;
 				*next = arg;
 				next = &arg->next;
@@ -4542,6 +4556,8 @@ int pevent_parse_event(struct pevent *pevent,
 		die("failed to read event id");
 
 	event->system = strdup(sys);
+	if (!event->system)
+		die("failed to allocate system");
 
 	/* Add pevent to event so that it can be referenced */
 	event->pevent = pevent;
@@ -4583,6 +4599,10 @@ int pevent_parse_event(struct pevent *pevent,
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
@@ -4926,6 +4946,11 @@ int pevent_register_event_handler(struct pevent *pevent,
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
1.7.7.6

