Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755604Ab2F0Apy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2012 20:45:54 -0400
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:56752 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755542Ab2F0Apw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2012 20:45:52 -0400
X-AuditID: 9c93016f-b7cbdae0000024ac-3e-4fea57bd5d7a
From: Namhyung Kim <namhyung@kernel.org>
To: Steven Rostedt <rostedt@goodmis.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>
Subject: [PATCH 4/4] tools lib traceevent: Add support for __print_hex()
Date: Wed, 27 Jun 2012 09:41:41 +0900
Message-Id: <1340757701-10711-4-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.10.2
In-Reply-To: <1340757701-10711-1-git-send-email-namhyung@kernel.org>
References: <1340757701-10711-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

Since the __print_hex() function is used in print fmt now,
add corresponding parser routines. This makes the output of
perf script on the kvm_emulate_insn event not to fail any more.

 before:
      kvm_emulate_insn:     [FAILED TO PARSE] rip=3238197797 ...

 after:
      kvm_emulate_insn:     0:c102fa25:89 10 (prot32)

Link: http://lkml.kernel.org/n/tip-ic6oh4flbu7zfznpv1dgktlu@git.kernel.org
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/lib/traceevent/event-parse.c                 |   75 +++++++++++++++++++-
 tools/lib/traceevent/event-parse.h                 |    7 ++
 .../perf/util/scripting-engines/trace-event-perl.c |    4 ++
 .../util/scripting-engines/trace-event-python.c    |    4 ++
 4 files changed, 89 insertions(+), 1 deletion(-)

diff --git a/tools/lib/traceevent/event-parse.c b/tools/lib/traceevent/event-parse.c
index 96cafa7a0fc8..ae56377cadd9 100644
--- a/tools/lib/traceevent/event-parse.c
+++ b/tools/lib/traceevent/event-parse.c
@@ -693,6 +693,10 @@ static void free_arg(struct print_arg *arg)
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
@@ -2293,6 +2297,45 @@ process_symbols(struct event_format *event, struct print_arg *arg, char **tok)
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
@@ -2521,6 +2564,10 @@ process_function(struct event_format *event, struct print_arg *arg,
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
@@ -3038,6 +3085,7 @@ eval_num_arg(void *data, int size, struct event_format *event, struct print_arg
 		break;
 	case PRINT_FLAGS:
 	case PRINT_SYMBOL:
+	case PRINT_HEX:
 		break;
 	case PRINT_TYPE:
 		val = eval_num_arg(data, size, event, arg->typecast.item);
@@ -3261,8 +3309,9 @@ static void print_str_arg(struct trace_seq *s, void *data, int size,
 	unsigned long long val, fval;
 	unsigned long addr;
 	char *str;
+	unsigned char *hex;
 	int print;
-	int len;
+	int i, len;
 
 	switch (arg->type) {
 	case PRINT_NULL:
@@ -3327,6 +3376,23 @@ static void print_str_arg(struct trace_seq *s, void *data, int size,
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
@@ -4376,6 +4442,13 @@ static void print_args(struct print_arg *args)
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
index a8121d78a046..527df038a25f 100644
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
index 4c1b3d72a1d2..a579495d35b5 100644
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
index acb9795286c4..f5c3485640ad 100644
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
-- 
1.7.10.2

