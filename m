Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755364Ab2I0Fld (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2012 01:41:33 -0400
Received: from terminus.zytor.com ([198.137.202.10]:54183 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754992Ab2I0Flc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2012 01:41:32 -0400
Date: Wed, 26 Sep 2012 22:41:09 -0700
From: tip-bot for Arnaldo Carvalho de Melo <acme@redhat.com>
Message-ID: <tip-ghokwtdw2hgmmmn7oa9s03r4@git.kernel.org>
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
Subject: [tip:perf/core] tools lib traceevent: Use asprintf were applicable
Git-Commit-ID: 0dbca1e364aba20dba70d88c083239c5152440ac
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Wed, 26 Sep 2012 22:41:15 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  0dbca1e364aba20dba70d88c083239c5152440ac
Gitweb:     http://git.kernel.org/tip/0dbca1e364aba20dba70d88c083239c5152440ac
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Wed, 12 Sep 2012 15:39:59 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 24 Sep 2012 12:10:34 -0300

tools lib traceevent: Use asprintf were applicable

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
