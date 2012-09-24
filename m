Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756789Ab2IXQAU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2012 12:00:20 -0400
Received: from merlin.infradead.org ([205.233.59.134]:58894 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756699Ab2IXQAG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2012 12:00:06 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 24/30] tools lib traceevent: Use calloc were applicable
Date: Mon, 24 Sep 2012 12:59:38 -0300
Message-Id: <1348502384-14442-25-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
In-Reply-To: <1348502384-14442-1-git-send-email-acme@infradead.org>
References: <1348502384-14442-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="UTF-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

Replacing the equivalent open coded malloc + memset bits.

Reviewed-by: Namhyung Kim <namhyung@kernel.org>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Link: http://lkml.kernel.org/n/tip-598fjtjbzal4wxh7fp0yv0q1@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/lib/traceevent/event-parse.c |   44 +++++++++++------------------------
 1 files changed, 14 insertions(+), 30 deletions(-)

diff --git a/tools/lib/traceevent/event-parse.c b/tools/lib/traceevent/event-parse.c
index 2e05d56..2aeae55 100644
--- a/tools/lib/traceevent/event-parse.c
+++ b/tools/lib/traceevent/event-parse.c
@@ -117,14 +117,7 @@ void breakpoint(void)
 
 struct print_arg *alloc_arg(void)
 {
-	struct print_arg *arg;
-
-	arg = malloc_or_die(sizeof(*arg));
-	if (!arg)
-		return NULL;
-	memset(arg, 0, sizeof(*arg));
-
-	return arg;
+	return calloc(1, sizeof(struct print_arg));
 }
 
 struct cmdline {
@@ -619,14 +612,7 @@ void pevent_print_printk(struct pevent *pevent)
 
 static struct event_format *alloc_event(void)
 {
-	struct event_format *event;
-
-	event = malloc(sizeof(*event));
-	if (!event)
-		return NULL;
-	memset(event, 0, sizeof(*event));
-
-	return event;
+	return calloc(1, sizeof(struct event_format));
 }
 
 static void add_event(struct pevent *pevent, struct event_format *event)
@@ -1240,8 +1226,10 @@ static int event_read_fields(struct event_format *event, struct format_field **f
 
 		last_token = token;
 
-		field = malloc_or_die(sizeof(*field));
-		memset(field, 0, sizeof(*field));
+		field = calloc(1, sizeof(*field));
+		if (!field)
+			goto fail;
+
 		field->event = event;
 
 		/* read the rest of the type */
@@ -2181,8 +2169,9 @@ process_fields(struct event_format *event, struct print_flag_sym **list, char **
 		if (test_type_token(type, token, EVENT_DELIM, ","))
 			goto out_free;
 
-		field = malloc_or_die(sizeof(*field));
-		memset(field, 0, sizeof(*field));
+		field = calloc(1, sizeof(*field));
+		if (!field)
+			goto out_free;
 
 		value = arg_eval(arg);
 		if (value == NULL)
@@ -5106,12 +5095,11 @@ int pevent_register_print_function(struct pevent *pevent,
 		remove_func_handler(pevent, name);
 	}
 
-	func_handle = malloc(sizeof(*func_handle));
+	func_handle = calloc(1, sizeof(*func_handle));
 	if (!func_handle) {
 		do_warning("Failed to allocate function handler");
 		return PEVENT_ERRNO__MEM_ALLOC_FAILED;
 	}
-	memset(func_handle, 0, sizeof(*func_handle));
 
 	func_handle->ret_type = ret_type;
 	func_handle->name = strdup(name);
@@ -5210,13 +5198,12 @@ int pevent_register_event_handler(struct pevent *pevent,
 
  not_found:
 	/* Save for later use. */
-	handle = malloc(sizeof(*handle));
+	handle = calloc(1, sizeof(*handle));
 	if (!handle) {
 		do_warning("Failed to allocate event handler");
 		return PEVENT_ERRNO__MEM_ALLOC_FAILED;
 	}
 
-	memset(handle, 0, sizeof(*handle));
 	handle->id = id;
 	if (event_name)
 		handle->event_name = strdup(event_name);
@@ -5245,13 +5232,10 @@ int pevent_register_event_handler(struct pevent *pevent,
  */
 struct pevent *pevent_alloc(void)
 {
-	struct pevent *pevent;
+	struct pevent *pevent = calloc(1, sizeof(*pevent));
 
-	pevent = malloc(sizeof(*pevent));
-	if (!pevent)
-		return NULL;
-	memset(pevent, 0, sizeof(*pevent));
-	pevent->ref_count = 1;
+	if (pevent)
+		pevent->ref_count = 1;
 
 	return pevent;
 }
-- 
1.7.1

