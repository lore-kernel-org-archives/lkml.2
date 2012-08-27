Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753491Ab2H0RAP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2012 13:00:15 -0400
Received: from terminus.zytor.com ([198.137.202.10]:34221 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751334Ab2H0RAN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2012 13:00:13 -0400
Date: Mon, 27 Aug 2012 09:59:51 -0700
From: tip-bot for Namhyung Kim <namhyung.kim@lge.com>
Message-ID: <tip-bffddffde7f9bd093909235a25dbb806fe639dde@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@kernel.org, a.p.zijlstra@chello.nl, namhyung.kim@lge.com,
        namhyung@kernel.org, fweisbec@gmail.com, rostedt@goodmis.org,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        acme@redhat.com, a.p.zijlstra@chello.nl, namhyung.kim@lge.com,
        namhyung@kernel.org, fweisbec@gmail.com, rostedt@goodmis.org,
        tglx@linutronix.de
In-Reply-To: <1345618831-9148-3-git-send-email-namhyung@kernel.org>
References: <1345618831-9148-3-git-send-email-namhyung@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] tools lib traceevent: Introduce pevent_errno
Git-Commit-ID: bffddffde7f9bd093909235a25dbb806fe639dde
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Mon, 27 Aug 2012 09:59:57 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  bffddffde7f9bd093909235a25dbb806fe639dde
Gitweb:     http://git.kernel.org/tip/bffddffde7f9bd093909235a25dbb806fe639dde
Author:     Namhyung Kim <namhyung.kim@lge.com>
AuthorDate: Wed, 22 Aug 2012 16:00:29 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 22 Aug 2012 16:02:59 -0300

tools lib traceevent: Introduce pevent_errno

Define and use error numbers for pevent_parse_event() and get rid of
die() and do_warning() calls. If the function returns non-zero value,
the caller can check the return code and do appropriate things.

I chose the error numbers to be negative not to clash with standard
errno, and as usual, 0 for success.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Acked-by: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Steven Rostedt <rostedt@goodmis.org>
Link: http://lkml.kernel.org/r/1345618831-9148-3-git-send-email-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/lib/traceevent/event-parse.c |   50 +++++++++++++++++++++--------------
 tools/lib/traceevent/event-parse.h |   26 +++++++++++++++++-
 2 files changed, 54 insertions(+), 22 deletions(-)

diff --git a/tools/lib/traceevent/event-parse.c b/tools/lib/traceevent/event-parse.c
index 33fcd94..a46cae7 100644
--- a/tools/lib/traceevent/event-parse.c
+++ b/tools/lib/traceevent/event-parse.c
@@ -4686,9 +4686,8 @@ static int find_event_handle(struct pevent *pevent, struct event_format *event)
  *
  * /sys/kernel/debug/tracing/events/.../.../format
  */
-int pevent_parse_event(struct pevent *pevent,
-		       const char *buf, unsigned long size,
-		       const char *sys)
+enum pevent_errno pevent_parse_event(struct pevent *pevent, const char *buf,
+				     unsigned long size, const char *sys)
 {
 	struct event_format *event;
 	int ret;
@@ -4697,17 +4696,16 @@ int pevent_parse_event(struct pevent *pevent,
 
 	event = alloc_event();
 	if (!event)
-		return -ENOMEM;
+		return PEVENT_ERRNO__MEM_ALLOC_FAILED;
 
 	event->name = event_read_name();
 	if (!event->name) {
 		/* Bad event? */
-		free(event);
-		return -1;
+		ret = PEVENT_ERRNO__MEM_ALLOC_FAILED;
+		goto event_alloc_failed;
 	}
 
 	if (strcmp(sys, "ftrace") == 0) {
-
 		event->flags |= EVENT_FL_ISFTRACE;
 
 		if (strcmp(event->name, "bprint") == 0)
@@ -4715,20 +4713,28 @@ int pevent_parse_event(struct pevent *pevent,
 	}
 		
 	event->id = event_read_id();
-	if (event->id < 0)
-		die("failed to read event id");
+	if (event->id < 0) {
+		ret = PEVENT_ERRNO__READ_ID_FAILED;
+		/*
+		 * This isn't an allocation error actually.
+		 * But as the ID is critical, just bail out.
+		 */
+		goto event_alloc_failed;
+	}
 
 	event->system = strdup(sys);
-	if (!event->system)
-		die("failed to allocate system");
+	if (!event->system) {
+		ret = PEVENT_ERRNO__MEM_ALLOC_FAILED;
+		goto event_alloc_failed;
+	}
 
 	/* Add pevent to event so that it can be referenced */
 	event->pevent = pevent;
 
 	ret = event_read_format(event);
 	if (ret < 0) {
-		do_warning("failed to read event format for %s", event->name);
-		goto event_failed;
+		ret = PEVENT_ERRNO__READ_FORMAT_FAILED;
+		goto event_parse_failed;
 	}
 
 	/*
@@ -4740,10 +4746,9 @@ int pevent_parse_event(struct pevent *pevent,
 
 	ret = event_read_print(event);
 	if (ret < 0) {
-		do_warning("failed to read event print fmt for %s",
-			   event->name);
 		show_warning = 1;
-		goto event_failed;
+		ret = PEVENT_ERRNO__READ_PRINT_FAILED;
+		goto event_parse_failed;
 	}
 	show_warning = 1;
 
@@ -4760,10 +4765,9 @@ int pevent_parse_event(struct pevent *pevent,
 			arg->type = PRINT_FIELD;
 			arg->field.name = strdup(field->name);
 			if (!arg->field.name) {
-				do_warning("failed to allocate field name");
 				event->flags |= EVENT_FL_FAILED;
 				free_arg(arg);
-				return -1;
+				return PEVENT_ERRNO__OLD_FTRACE_ARG_FAILED;
 			}
 			arg->field.field = field;
 			*list = arg;
@@ -4778,11 +4782,17 @@ int pevent_parse_event(struct pevent *pevent,
 
 	return 0;
 
- event_failed:
+ event_parse_failed:
 	event->flags |= EVENT_FL_FAILED;
 	/* still add it even if it failed */
 	add_event(pevent, event);
-	return -1;
+	return ret;
+
+ event_alloc_failed:
+	free(event->system);
+	free(event->name);
+	free(event);
+	return ret;
 }
 
 int get_field_val(struct trace_seq *s, struct format_field *field,
diff --git a/tools/lib/traceevent/event-parse.h b/tools/lib/traceevent/event-parse.h
index 5772ad8..3c48229 100644
--- a/tools/lib/traceevent/event-parse.h
+++ b/tools/lib/traceevent/event-parse.h
@@ -345,6 +345,28 @@ enum pevent_flag {
 	PEVENT_NSEC_OUTPUT		= 1,	/* output in NSECS */
 };
 
+enum pevent_errno {
+	PEVENT_ERRNO__SUCCESS			= 0,
+
+	/*
+	 * Choose an arbitrary negative big number not to clash with standard
+	 * errno since SUS requires the errno has distinct positive values.
+	 * See 'Issue 6' in the link below.
+	 *
+	 * http://pubs.opengroup.org/onlinepubs/9699919799/basedefs/errno.h.html
+	 */
+	__PEVENT_ERRNO__START			= -100000,
+
+	PEVENT_ERRNO__MEM_ALLOC_FAILED		= __PEVENT_ERRNO__START,
+	PEVENT_ERRNO__PARSE_EVENT_FAILED,
+	PEVENT_ERRNO__READ_ID_FAILED,
+	PEVENT_ERRNO__READ_FORMAT_FAILED,
+	PEVENT_ERRNO__READ_PRINT_FAILED,
+	PEVENT_ERRNO__OLD_FTRACE_ARG_FAILED,
+
+	__PEVENT_ERRNO__END,
+};
+
 struct cmdline;
 struct cmdline_list;
 struct func_map;
@@ -509,8 +531,8 @@ void pevent_print_event(struct pevent *pevent, struct trace_seq *s,
 int pevent_parse_header_page(struct pevent *pevent, char *buf, unsigned long size,
 			     int long_size);
 
-int pevent_parse_event(struct pevent *pevent, const char *buf,
-		       unsigned long size, const char *sys);
+enum pevent_errno pevent_parse_event(struct pevent *pevent, const char *buf,
+				     unsigned long size, const char *sys);
 
 void *pevent_get_field_raw(struct trace_seq *s, struct event_format *event,
 			   const char *name, struct pevent_record *record,
