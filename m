Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756943Ab2IXQFy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2012 12:05:54 -0400
Received: from casper.infradead.org ([85.118.1.10]:41453 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756685Ab2IXQAA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2012 12:00:00 -0400
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
Subject: [PATCH 23/30] tools lib traceevent: Use asprintf were applicable
Date: Mon, 24 Sep 2012 12:59:37 -0300
Message-Id: <1348502384-14442-24-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
In-Reply-To: <1348502384-14442-1-git-send-email-acme@infradead.org>
References: <1348502384-14442-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="UTF-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

Replacing the equivalent open coded malloc + sprintf bits.

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
Link: http://lkml.kernel.org/n/tip-ghokwtdw2hgmmmn7oa9s03r4@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/lib/traceevent/event-parse.c |   58 +++++++++++++++++++----------------
 1 files changed, 31 insertions(+), 27 deletions(-)

diff --git a/tools/lib/traceevent/event-parse.c b/tools/lib/traceevent/event-parse.c
index acf4038..2e05d56 100644
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
@@ -2777,10 +2777,8 @@ static int event_read_print(struct event_format *event)
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
@@ -3524,6 +3522,18 @@ process_defined_func(struct trace_seq *s, void *data, int size,
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
@@ -3559,8 +3569,9 @@ static struct print_arg *make_bprint_args(char *fmt, void *data, int size, struc
 	next = &arg->next;
 
 	arg->type = PRINT_ATOM;
-	arg->atom.atom = malloc_or_die(32);
-	sprintf(arg->atom.atom, "%lld", ip);
+		
+	if (asprintf(&arg->atom.atom, "%lld", ip) < 0)
+		goto out_free;
 
 	/* skip the first "%pf : " */
 	for (ptr = fmt + 6, bptr = data + field->offset;
@@ -3617,8 +3628,10 @@ static struct print_arg *make_bprint_args(char *fmt, void *data, int size, struc
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
@@ -3646,18 +3659,10 @@ static struct print_arg *make_bprint_args(char *fmt, void *data, int size, struc
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
@@ -3684,9 +3689,8 @@ get_bprint_format(void *data, int size __maybe_unused,
 
 	printk = find_printk(pevent, addr);
 	if (!printk) {
-		format = malloc_or_die(45);
-		sprintf(format, "%%pf : (NO FORMAT FOUND at %llx)\n",
-			addr);
+		if (asprintf(&format, "%%pf : (NO FORMAT FOUND at %llx)\n", addr) < 0)
+			return NULL;
 		return format;
 	}
 
@@ -3694,8 +3698,8 @@ get_bprint_format(void *data, int size __maybe_unused,
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
1.7.1

