Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964935Ab2EWCjY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 22:39:24 -0400
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:49362 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933543Ab2EWCjI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 22:39:08 -0400
X-AuditID: 9c93016f-b7c3cae000001954-a0-4fbc4dc7783f
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
Subject: [PATCH 09/22] lib/traceevent: Handle strdup failure cases
Date: Wed, 23 May 2012 11:36:46 +0900
Message-Id: <1337740619-27925-10-git-send-email-namhyung.kim@lge.com>
X-Mailer: git-send-email 1.7.10.1
In-Reply-To: <1337740619-27925-1-git-send-email-namhyung.kim@lge.com>
References: <1337740619-27925-1-git-send-email-namhyung.kim@lge.com>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There were some places didn't check return value of the strdup
and had unneeded/duplicated checks. Fix it.

Link: http://lkml.kernel.org/r/1333940074-19052-5-git-send-email-namhyung.kim@lge.com

Signed-off-by: Namhyung Kim <namhyung.kim@lge.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: Borislav Petkov <bp@alien8.de>
Cc: David Ahern <dsahern@gmail.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 tools/lib/traceevent/event-parse.c |   29 +++++++++++++++++++++++++++--
 1 file changed, 27 insertions(+), 2 deletions(-)

diff --git a/tools/lib/traceevent/event-parse.c b/tools/lib/traceevent/event-parse.c
index bdfc29607b49..760e7831390a 100644
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
@@ -2139,6 +2144,8 @@ process_fields(struct event_format *event, struct print_flag_sym **list, char **
 		if (value == NULL)
 			goto out_free;
 		field->value = strdup(value);
+		if (field->value == NULL)
+			goto out_free;
 
 		free_arg(arg);
 		arg = alloc_arg();
@@ -2152,6 +2159,8 @@ process_fields(struct event_format *event, struct print_flag_sym **list, char **
 		if (value == NULL)
 			goto out_free;
 		field->str = strdup(value);
+		if (field->str == NULL)
+			goto out_free;
 		free_arg(arg);
 		arg = NULL;
 
@@ -3356,6 +3365,9 @@ process_defined_func(struct trace_seq *s, void *data, int size,
 			string = malloc_or_die(sizeof(*string));
 			string->next = strings;
 			string->str = strdup(str.buffer);
+			if (!string->str)
+				die("malloc str");
+
 			strings = string;
 			trace_seq_destroy(&str);
 			break;
@@ -3493,6 +3505,8 @@ static struct print_arg *make_bprint_args(char *fmt, void *data, int size, struc
 				arg->next = NULL;
 				arg->type = PRINT_BSTRING;
 				arg->string.string = strdup(bptr);
+				if (!arg->string.string)
+					break;
 				bptr += strlen(bptr) + 1;
 				*next = arg;
 				next = &arg->next;
@@ -4569,6 +4583,8 @@ int pevent_parse_event(struct pevent *pevent,
 		die("failed to read event id");
 
 	event->system = strdup(sys);
+	if (!event->system)
+		die("failed to allocate system");
 
 	/* Add pevent to event so that it can be referenced */
 	event->pevent = pevent;
@@ -4610,6 +4626,10 @@ int pevent_parse_event(struct pevent *pevent,
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
@@ -4953,6 +4973,11 @@ int pevent_register_event_handler(struct pevent *pevent,
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
1.7.10.1

