Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755421Ab2I0Fmb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2012 01:42:31 -0400
Received: from terminus.zytor.com ([198.137.202.10]:54202 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754720Ab2I0Fm3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2012 01:42:29 -0400
Date: Wed, 26 Sep 2012 22:42:05 -0700
From: tip-bot for Arnaldo Carvalho de Melo <acme@redhat.com>
Message-ID: <tip-598fjtjbzal4wxh7fp0yv0q1@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, paulus@samba.org,
        acme@redhat.com, hpa@zytor.com, mingo@kernel.org, peterz@infradead.org,
        efault@gmx.de, namhyung@gmail.com, namhyung@kernel.org,
        jolsa@redhat.com, fweisbec@gmail.com, rostedt@goodmis.org,
        dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, efault@gmx.de,
        peterz@infradead.org, namhyung@kernel.org, namhyung@gmail.com,
        jolsa@redhat.com, fweisbec@gmail.com, rostedt@goodmis.org,
        dsahern@gmail.com, tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] tools lib traceevent: Use calloc were applicable
Git-Commit-ID: 87162d816f5f344d72e25249acd9b823b646a5c9
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Wed, 26 Sep 2012 22:42:11 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  87162d816f5f344d72e25249acd9b823b646a5c9
Gitweb:     http://git.kernel.org/tip/87162d816f5f344d72e25249acd9b823b646a5c9
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Wed, 12 Sep 2012 15:39:59 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 24 Sep 2012 12:12:31 -0300

tools lib traceevent: Use calloc were applicable

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
