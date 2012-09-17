Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932551Ab2IQUvB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2012 16:51:01 -0400
Received: from merlin.infradead.org ([205.233.59.134]:36465 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932077Ab2IQUu6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2012 16:50:58 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 2/4] tools lib traceevent: Use calloc were applicable
Date: Mon, 17 Sep 2012 17:50:47 -0300
Message-Id: <1347915049-19093-3-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
In-Reply-To: <1347915049-19093-1-git-send-email-acme@infradead.org>
References: <1347915049-19093-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="UTF-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

Replacing the equivalent open coded malloc + memset bits.

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
 tools/lib/traceevent/event-parse.c |   44 ++++++++++++------------------------
 1 file changed, 14 insertions(+), 30 deletions(-)

diff --git a/tools/lib/traceevent/event-parse.c b/tools/lib/traceevent/event-parse.c
index 278f989..5e38d2f 100644
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
@@ -2179,8 +2167,9 @@ process_fields(struct event_format *event, struct print_flag_sym **list, char **
 		if (test_type_token(type, token, EVENT_DELIM, ","))
 			goto out_free;
 
-		field = malloc_or_die(sizeof(*field));
-		memset(field, 0, sizeof(*field));
+		field = calloc(1, sizeof(*field));
+		if (!field)
+			goto out_free;
 
 		value = arg_eval(arg);
 		if (value == NULL)
@@ -5098,12 +5087,11 @@ int pevent_register_print_function(struct pevent *pevent,
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
@@ -5202,13 +5190,12 @@ int pevent_register_event_handler(struct pevent *pevent,
 
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
@@ -5237,13 +5224,10 @@ int pevent_register_event_handler(struct pevent *pevent,
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
1.7.9.2.358.g22243

