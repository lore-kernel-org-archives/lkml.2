Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932333Ab2IQUvA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2012 16:51:00 -0400
Received: from merlin.infradead.org ([205.233.59.134]:36466 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932071Ab2IQUu6 (ORCPT
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
Subject: [PATCH 1/4] tools lib traceevent: Use asprintf were applicable
Date: Mon, 17 Sep 2012 17:50:46 -0300
Message-Id: <1347915049-19093-2-git-send-email-acme@infradead.org>
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

Replacing the equivalent open coded malloc + sprintf bits.

Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Link: http://lkml.kernel.org/n/tip-ghokwtdw2hgmmmn7oa9s03r4@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/lib/traceevent/event-parse.c |   58 +++++++++++++++++++-----------------
 1 file changed, 31 insertions(+), 27 deletions(-)

diff --git a/tools/lib/traceevent/event-parse.c b/tools/lib/traceevent/event-parse.c
index 77ebeb8..278f989 100644
--- a/tools/lib/traceevent/event-parse.c
+++ b/tools/lib/traceevent/event-parse.c
@@ -827,9 +827,9 @@ static enum event_type __read_token(char **tok)
 	switch (type) {
 	case EVENT_NEWLINE:
 	case EVENT_DELIM:
-		*tok = malloc_or_die(2);
-		(*tok)[0] = ch;
-		(*tok)[1] = 0;
+		if (asprintf(tok, "%c", ch) < 0)
+			return EVENT_ERROR;
+
 		return type;
 
 	case EVENT_OP:
@@ -2769,10 +2769,8 @@ static int event_read_print(struct event_format *event)
 	if (type == EVENT_DQUOTE) {
 		char *cat;
 
-		cat = malloc_or_die(strlen(event->print_fmt.format) +
-				    strlen(token) + 1);
-		strcpy(cat, event->print_fmt.format);
-		strcat(cat, token);
+		if (asprintf(&cat, "%s%s", event->print_fmt.format, token) < 0)
+			goto fail;
 		free_token(token);
 		free_token(event->print_fmt.format);
 		event->print_fmt.format = NULL;
@@ -3516,6 +3514,18 @@ process_defined_func(struct trace_seq *s, void *data, int size,
 	return ret;
 }
 
+static void free_args(struct print_arg *args)
+{
+	struct print_arg *next;
+
+	while (args) {
+		next = args->next;
+
+		free_arg(args);
+		args = next;
+	}
+}
+
 static struct print_arg *make_bprint_args(char *fmt, void *data, int size, struct event_format *event)
 {
 	struct pevent *pevent = event->pevent;
@@ -3551,8 +3561,9 @@ static struct print_arg *make_bprint_args(char *fmt, void *data, int size, struc
 	next = &arg->next;
 
 	arg->type = PRINT_ATOM;
-	arg->atom.atom = malloc_or_die(32);
-	sprintf(arg->atom.atom, "%lld", ip);
+		
+	if (asprintf(&arg->atom.atom, "%lld", ip) < 0)
+		goto out_free;
 
 	/* skip the first "%pf : " */
 	for (ptr = fmt + 6, bptr = data + field->offset;
@@ -3609,8 +3620,10 @@ static struct print_arg *make_bprint_args(char *fmt, void *data, int size, struc
 				arg = alloc_arg();
 				arg->next = NULL;
 				arg->type = PRINT_ATOM;
-				arg->atom.atom = malloc_or_die(32);
-				sprintf(arg->atom.atom, "%lld", val);
+				if (asprintf(&arg->atom.atom, "%lld", val) < 0) {
+					free(arg);
+					goto out_free;
+				}
 				*next = arg;
 				next = &arg->next;
 				/*
@@ -3638,18 +3651,10 @@ static struct print_arg *make_bprint_args(char *fmt, void *data, int size, struc
 	}
 
 	return args;
-}
-
-static void free_args(struct print_arg *args)
-{
-	struct print_arg *next;
-
-	while (args) {
-		next = args->next;
 
-		free_arg(args);
-		args = next;
-	}
+out_free:
+	free_args(args);
+	return NULL;
 }
 
 static char *
@@ -3676,9 +3681,8 @@ get_bprint_format(void *data, int size __maybe_unused,
 
 	printk = find_printk(pevent, addr);
 	if (!printk) {
-		format = malloc_or_die(45);
-		sprintf(format, "%%pf : (NO FORMAT FOUND at %llx)\n",
-			addr);
+		if (asprintf(&format, "%%pf : (NO FORMAT FOUND at %llx)\n", addr) < 0)
+			return NULL;
 		return format;
 	}
 
@@ -3686,8 +3690,8 @@ get_bprint_format(void *data, int size __maybe_unused,
 	/* Remove any quotes. */
 	if (*p == '"')
 		p++;
-	format = malloc_or_die(strlen(p) + 10);
-	sprintf(format, "%s : %s", "%pf", p);
+	if (asprintf(&format, "%s : %s", "%pf", p) < 0)
+		return NULL;
 	/* remove ending quotes and new line since we will add one too */
 	p = format + strlen(format) - 1;
 	if (*p == '"')
-- 
1.7.9.2.358.g22243

