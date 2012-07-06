Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756251Ab2GFKzl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2012 06:55:41 -0400
Received: from terminus.zytor.com ([198.137.202.10]:51430 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751911Ab2GFKzg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2012 06:55:36 -0400
Date: Fri, 6 Jul 2012 03:55:16 -0700
From: tip-bot for Namhyung Kim <namhyung.kim@lge.com>
Message-ID: <tip-e080e6f1c863242ff709046d0486d09c46dc484a@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@kernel.org, a.p.zijlstra@chello.nl, namhyung.kim@lge.com,
        namhyung@kernel.org, fweisbec@gmail.com, rostedt@goodmis.org,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        acme@redhat.com, a.p.zijlstra@chello.nl, namhyung.kim@lge.com,
        namhyung@kernel.org, fweisbec@gmail.com, rostedt@goodmis.org,
        tglx@linutronix.de
In-Reply-To: <1340757701-10711-4-git-send-email-namhyung@kernel.org>
References: <1340757701-10711-4-git-send-email-namhyung@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] tools lib traceevent: Add support for __print_hex(
 )
Git-Commit-ID: e080e6f1c863242ff709046d0486d09c46dc484a
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Fri, 06 Jul 2012 03:55:22 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  e080e6f1c863242ff709046d0486d09c46dc484a
Gitweb:     http://git.kernel.org/tip/e080e6f1c863242ff709046d0486d09c46dc484a
Author:     Namhyung Kim <namhyung.kim@lge.com>
AuthorDate: Wed, 27 Jun 2012 09:41:41 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Fri, 29 Jun 2012 13:28:12 -0300

tools lib traceevent: Add support for __print_hex()

Since the __print_hex() function is used in print fmt now, add
corresponding parser routines. This makes the output of perf script on
the kvm_emulate_insn event not to fail any more.

 before:
      kvm_emulate_insn:     [FAILED TO PARSE] rip=3238197797 ...

 after:
      kvm_emulate_insn:     0:c102fa25:89 10 (prot32)

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Steven Rostedt <rostedt@goodmis.org>
Link: http://lkml.kernel.org/r/1340757701-10711-4-git-send-email-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/lib/traceevent/event-parse.c                 |   75 +++++++++++++++++++-
 tools/lib/traceevent/event-parse.h                 |    7 ++
 .../perf/util/scripting-engines/trace-event-perl.c |    4 +
 .../util/scripting-engines/trace-event-python.c    |    4 +
 4 files changed, 89 insertions(+), 1 deletions(-)

diff --git a/tools/lib/traceevent/event-parse.c b/tools/lib/traceevent/event-parse.c
index 63d02be..b1abd39 100644
--- a/tools/lib/traceevent/event-parse.c
+++ b/tools/lib/traceevent/event-parse.c
@@ -697,6 +697,10 @@ static void free_arg(struct print_arg *arg)
 		free_arg(arg->symbol.field);
 		free_flag_sym(arg->symbol.symbols);
 		break;
+	case PRINT_HEX:
+		free_arg(arg->hex.field);
+		free_arg(arg->hex.size);
+		break;
 	case PRINT_TYPE:
 		free(arg->typecast.type);
 		free_arg(arg->typecast.item);
@@ -2260,6 +2264,45 @@ process_symbols(struct event_format *event, struct print_arg *arg, char **tok)
 }
 
 static enum event_type
+process_hex(struct event_format *event, struct print_arg *arg, char **tok)
+{
+	struct print_arg *field;
+	enum event_type type;
+	char *token;
+
+	memset(arg, 0, sizeof(*arg));
+	arg->type = PRINT_HEX;
+
+	field = alloc_arg();
+	type = process_arg(event, field, &token);
+
+	if (test_type_token(type, token, EVENT_DELIM, ","))
+		goto out_free;
+
+	arg->hex.field = field;
+
+	free_token(token);
+
+	field = alloc_arg();
+	type = process_arg(event, field, &token);
+
+	if (test_type_token(type, token, EVENT_DELIM, ")"))
+		goto out_free;
+
+	arg->hex.size = field;
+
+	free_token(token);
+	type = read_token_item(tok);
+	return type;
+
+ out_free:
+	free_arg(field);
+	free_token(token);
+	*tok = NULL;
+	return EVENT_ERROR;
+}
+
+static enum event_type
 process_dynamic_array(struct event_format *event, struct print_arg *arg, char **tok)
 {
 	struct format_field *field;
@@ -2488,6 +2531,10 @@ process_function(struct event_format *event, struct print_arg *arg,
 		is_symbolic_field = 1;
 		return process_symbols(event, arg, tok);
 	}
+	if (strcmp(token, "__print_hex") == 0) {
+		free_token(token);
+		return process_hex(event, arg, tok);
+	}
 	if (strcmp(token, "__get_str") == 0) {
 		free_token(token);
 		return process_str(event, arg, tok);
@@ -2995,6 +3042,7 @@ eval_num_arg(void *data, int size, struct event_format *event, struct print_arg
 		break;
 	case PRINT_FLAGS:
 	case PRINT_SYMBOL:
+	case PRINT_HEX:
 		break;
 	case PRINT_TYPE:
 		val = eval_num_arg(data, size, event, arg->typecast.item);
@@ -3218,8 +3266,9 @@ static void print_str_arg(struct trace_seq *s, void *data, int size,
 	unsigned long long val, fval;
 	unsigned long addr;
 	char *str;
+	unsigned char *hex;
 	int print;
-	int len;
+	int i, len;
 
 	switch (arg->type) {
 	case PRINT_NULL:
@@ -3284,6 +3333,23 @@ static void print_str_arg(struct trace_seq *s, void *data, int size,
 			}
 		}
 		break;
+	case PRINT_HEX:
+		field = arg->hex.field->field.field;
+		if (!field) {
+			str = arg->hex.field->field.name;
+			field = pevent_find_any_field(event, str);
+			if (!field)
+				die("field %s not found", str);
+			arg->hex.field->field.field = field;
+		}
+		hex = data + field->offset;
+		len = eval_num_arg(data, size, event, arg->hex.size);
+		for (i = 0; i < len; i++) {
+			if (i)
+				trace_seq_putc(s, ' ');
+			trace_seq_printf(s, "%02x", hex[i]);
+		}
+		break;
 
 	case PRINT_TYPE:
 		break;
@@ -4294,6 +4360,13 @@ static void print_args(struct print_arg *args)
 		trace_seq_destroy(&s);
 		printf(")");
 		break;
+	case PRINT_HEX:
+		printf("__print_hex(");
+		print_args(args->hex.field);
+		printf(", ");
+		print_args(args->hex.size);
+		printf(")");
+		break;
 	case PRINT_STRING:
 	case PRINT_BSTRING:
 		printf("__get_str(%s)", args->string.string);
diff --git a/tools/lib/traceevent/event-parse.h b/tools/lib/traceevent/event-parse.h
index ac997bc..5772ad8 100644
--- a/tools/lib/traceevent/event-parse.h
+++ b/tools/lib/traceevent/event-parse.h
@@ -226,6 +226,11 @@ struct print_arg_symbol {
 	struct print_flag_sym	*symbols;
 };
 
+struct print_arg_hex {
+	struct print_arg	*field;
+	struct print_arg	*size;
+};
+
 struct print_arg_dynarray {
 	struct format_field	*field;
 	struct print_arg	*index;
@@ -253,6 +258,7 @@ enum print_arg_type {
 	PRINT_FIELD,
 	PRINT_FLAGS,
 	PRINT_SYMBOL,
+	PRINT_HEX,
 	PRINT_TYPE,
 	PRINT_STRING,
 	PRINT_BSTRING,
@@ -270,6 +276,7 @@ struct print_arg {
 		struct print_arg_typecast	typecast;
 		struct print_arg_flags		flags;
 		struct print_arg_symbol		symbol;
+		struct print_arg_hex		hex;
 		struct print_arg_func		func;
 		struct print_arg_string		string;
 		struct print_arg_op		op;
diff --git a/tools/perf/util/scripting-engines/trace-event-perl.c b/tools/perf/util/scripting-engines/trace-event-perl.c
index b3620fe..02dfa19 100644
--- a/tools/perf/util/scripting-engines/trace-event-perl.c
+++ b/tools/perf/util/scripting-engines/trace-event-perl.c
@@ -209,6 +209,10 @@ static void define_event_symbols(struct event_format *event,
 		define_symbolic_values(args->symbol.symbols, ev_name,
 				       cur_field_name);
 		break;
+	case PRINT_HEX:
+		define_event_symbols(event, ev_name, args->hex.field);
+		define_event_symbols(event, ev_name, args->hex.size);
+		break;
 	case PRINT_BSTRING:
 	case PRINT_DYNAMIC_ARRAY:
 	case PRINT_STRING:
diff --git a/tools/perf/util/scripting-engines/trace-event-python.c b/tools/perf/util/scripting-engines/trace-event-python.c
index a8ca2f8..ce4d1b0 100644
--- a/tools/perf/util/scripting-engines/trace-event-python.c
+++ b/tools/perf/util/scripting-engines/trace-event-python.c
@@ -166,6 +166,10 @@ static void define_event_symbols(struct event_format *event,
 		define_values(PRINT_SYMBOL, args->symbol.symbols, ev_name,
 			      cur_field_name);
 		break;
+	case PRINT_HEX:
+		define_event_symbols(event, ev_name, args->hex.field);
+		define_event_symbols(event, ev_name, args->hex.size);
+		break;
 	case PRINT_STRING:
 		break;
 	case PRINT_TYPE:
