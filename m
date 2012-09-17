Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932592Ab2IQUvG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2012 16:51:06 -0400
Received: from casper.infradead.org ([85.118.1.10]:49210 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932545Ab2IQUvC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2012 16:51:02 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 4/4] tools lib traceevent: Remove some die() calls
Date: Mon, 17 Sep 2012 17:50:49 -0300
Message-Id: <1347915049-19093-5-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
In-Reply-To: <1347915049-19093-1-git-send-email-acme@infradead.org>
References: <1347915049-19093-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="UTF-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

Cleaned event-parse.c this time, just propagate the errors and in handle
them the call sites.

Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-9ebpr2vgfk2qs2841i99sa8y@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/lib/traceevent/event-parse.c |  249 +++++++++++++++++++++++++-----------
 1 file changed, 175 insertions(+), 74 deletions(-)

diff --git a/tools/lib/traceevent/event-parse.c b/tools/lib/traceevent/event-parse.c
index ecc9a17..e8e0fe0 100644
--- a/tools/lib/traceevent/event-parse.c
+++ b/tools/lib/traceevent/event-parse.c
@@ -31,6 +31,7 @@
 #include <ctype.h>
 #include <errno.h>
 #include <stdint.h>
+#include <limits.h>
 
 #include "event-parse.h"
 #include "event-utils.h"
@@ -151,7 +152,9 @@ static int cmdline_init(struct pevent *pevent)
 	struct cmdline *cmdlines;
 	int i;
 
-	cmdlines = malloc_or_die(sizeof(*cmdlines) * pevent->cmdline_count);
+	cmdlines = malloc(sizeof(*cmdlines) * pevent->cmdline_count);
+	if (!cmdlines)
+		return -1;
 
 	i = 0;
 	while (cmdlist) {
@@ -179,8 +182,8 @@ static char *find_cmdline(struct pevent *pevent, int pid)
 	if (!pid)
 		return "<idle>";
 
-	if (!pevent->cmdlines)
-		cmdline_init(pevent);
+	if (!pevent->cmdlines && cmdline_init(pevent))
+		return "<not enough memory for cmdlines!>";
 
 	key.pid = pid;
 
@@ -208,8 +211,8 @@ int pevent_pid_is_registered(struct pevent *pevent, int pid)
 	if (!pid)
 		return 1;
 
-	if (!pevent->cmdlines)
-		cmdline_init(pevent);
+	if (!pevent->cmdlines && cmdline_init(pevent))
+		return 0;
 
 	key.pid = pid;
 
@@ -251,10 +254,14 @@ static int add_new_comm(struct pevent *pevent, const char *comm, int pid)
 		return -1;
 	}
 
-	cmdlines[pevent->cmdline_count].pid = pid;
 	cmdlines[pevent->cmdline_count].comm = strdup(comm);
-	if (!cmdlines[pevent->cmdline_count].comm)
-		die("malloc comm");
+	if (!cmdlines[pevent->cmdline_count].comm) {
+		free(cmdlines);
+		errno = ENOMEM;
+		return -1;
+	}
+
+	cmdlines[pevent->cmdline_count].pid = pid;
 		
 	if (cmdlines[pevent->cmdline_count].comm)
 		pevent->cmdline_count++;
@@ -281,10 +288,15 @@ int pevent_register_comm(struct pevent *pevent, const char *comm, int pid)
 	if (pevent->cmdlines)
 		return add_new_comm(pevent, comm, pid);
 
-	item = malloc_or_die(sizeof(*item));
+	item = malloc(sizeof(*item));
+	if (!item)
+		return -1;
+
 	item->comm = strdup(comm);
-	if (!item->comm)
-		die("malloc comm");
+	if (!item->comm) {
+		free(item);
+		return -1;
+	}
 	item->pid = pid;
 	item->next = pevent->cmdlist;
 
@@ -348,7 +360,10 @@ static int func_map_init(struct pevent *pevent)
 	struct func_map *func_map;
 	int i;
 
-	func_map = malloc_or_die(sizeof(*func_map) * (pevent->func_count + 1));
+	func_map = malloc(sizeof(*func_map) * (pevent->func_count + 1));
+	if (!func_map)
+		return -1;
+
 	funclist = pevent->funclist;
 
 	i = 0;
@@ -448,25 +463,36 @@ pevent_find_function_address(struct pevent *pevent, unsigned long long addr)
 int pevent_register_function(struct pevent *pevent, char *func,
 			     unsigned long long addr, char *mod)
 {
-	struct func_list *item;
+	struct func_list *item = malloc(sizeof(*item));
 
-	item = malloc_or_die(sizeof(*item));
+	if (!item)
+		return -1;
 
 	item->next = pevent->funclist;
 	item->func = strdup(func);
-	if (mod)
+	if (!item->func)
+		goto out_free;
+
+	if (mod) {
 		item->mod = strdup(mod);
-	else
+		if (!item->mod)
+			goto out_free_func;
+	} else
 		item->mod = NULL;
 	item->addr = addr;
 
-	if (!item->func || (mod && !item->mod))
-		die("malloc func");
-
 	pevent->funclist = item;
 	pevent->func_count++;
 
 	return 0;
+
+out_free_func:
+	free(item->func);
+	item->func = NULL;
+out_free:
+	free(item);
+	errno = ENOMEM;
+	return -1;
 }
 
 /**
@@ -517,14 +543,16 @@ static int printk_cmp(const void *a, const void *b)
 	return 0;
 }
 
-static void printk_map_init(struct pevent *pevent)
+static int printk_map_init(struct pevent *pevent)
 {
 	struct printk_list *printklist;
 	struct printk_list *item;
 	struct printk_map *printk_map;
 	int i;
 
-	printk_map = malloc_or_die(sizeof(*printk_map) * (pevent->printk_count + 1));
+	printk_map = malloc(sizeof(*printk_map) * (pevent->printk_count + 1));
+	if (!printk_map)
+		return -1;
 
 	printklist = pevent->printklist;
 
@@ -542,6 +570,8 @@ static void printk_map_init(struct pevent *pevent)
 
 	pevent->printk_map = printk_map;
 	pevent->printklist = NULL;
+
+	return 0;
 }
 
 static struct printk_map *
@@ -550,8 +580,8 @@ find_printk(struct pevent *pevent, unsigned long long addr)
 	struct printk_map *printk;
 	struct printk_map key;
 
-	if (!pevent->printk_map)
-		printk_map_init(pevent);
+	if (!pevent->printk_map && printk_map_init(pevent))
+		return NULL;
 
 	key.addr = addr;
 
@@ -573,21 +603,27 @@ find_printk(struct pevent *pevent, unsigned long long addr)
 int pevent_register_print_string(struct pevent *pevent, char *fmt,
 				 unsigned long long addr)
 {
-	struct printk_list *item;
+	struct printk_list *item = malloc(sizeof(*item));
 
-	item = malloc_or_die(sizeof(*item));
+	if (!item)
+		return -1;
 
 	item->next = pevent->printklist;
-	item->printk = strdup(fmt);
 	item->addr = addr;
 
+	item->printk = strdup(fmt);
 	if (!item->printk)
-		die("malloc fmt");
+		goto out_free;
 
 	pevent->printklist = item;
 	pevent->printk_count++;
 
 	return 0;
+
+out_free:
+	free(item);
+	errno = ENOMEM;
+	return -1;
 }
 
 /**
@@ -615,14 +651,15 @@ static struct event_format *alloc_event(void)
 	return calloc(1, sizeof(struct event_format));
 }
 
-static void add_event(struct pevent *pevent, struct event_format *event)
+static int add_event(struct pevent *pevent, struct event_format *event)
 {
 	int i;
+	struct event_format **events = realloc(pevent->events, sizeof(event) *
+					       (pevent->nr_events + 1));
+	if (!events)
+		return -1;
 
-	pevent->events = realloc(pevent->events, sizeof(event) *
-				 (pevent->nr_events + 1));
-	if (!pevent->events)
-		die("Can not allocate events");
+	pevent->events = events;
 
 	for (i = 0; i < pevent->nr_events; i++) {
 		if (pevent->events[i]->id > event->id)
@@ -637,6 +674,8 @@ static void add_event(struct pevent *pevent, struct event_format *event)
 	pevent->nr_events++;
 
 	event->pevent = pevent;
+
+	return 0;
 }
 
 static int event_item_type(enum event_type type)
@@ -1750,8 +1789,10 @@ process_op(struct event_format *event, struct print_arg *arg, char **tok)
 		    type == EVENT_DELIM && (strcmp(token, ")") == 0)) {
 			char *new_atom;
 
-			if (left->type != PRINT_ATOM)
-				die("bad pointer type");
+			if (left->type != PRINT_ATOM) {
+				do_warning("bad pointer type");
+				goto out_free;
+			}
 			new_atom = realloc(left->atom.atom,
 					    strlen(left->atom.atom) + 3);
 			if (!new_atom)
@@ -1868,7 +1909,11 @@ eval_type_str(unsigned long long val, const char *type, int pointer)
 			return val;
 		}
 
-		ref = malloc_or_die(len);
+		ref = malloc(len);
+		if (!ref) {
+			do_warning("%s: not enough memory!", __func__);
+			return val;
+		}
 		memcpy(ref, type, len);
 
 		/* chop off the " *" */
@@ -1945,8 +1990,10 @@ eval_type_str(unsigned long long val, const char *type, int pointer)
 static unsigned long long
 eval_type(unsigned long long val, struct print_arg *arg, int pointer)
 {
-	if (arg->type != PRINT_TYPE)
-		die("expected type argument");
+	if (arg->type != PRINT_TYPE) {
+		do_warning("expected type argument");
+		return 0;
+	}
 
 	return eval_type_str(val, arg->typecast.type, pointer);
 }
@@ -2131,7 +2178,7 @@ static char *arg_eval (struct print_arg *arg)
 	case PRINT_STRING:
 	case PRINT_BSTRING:
 	default:
-		die("invalid eval type %d", arg->type);
+		do_warning("invalid eval type %d", arg->type);
 		break;
 	}
 
@@ -2423,8 +2470,10 @@ process_paren(struct event_format *event, struct print_arg *arg, char **tok)
 		/* make this a typecast and contine */
 
 		/* prevous must be an atom */
-		if (arg->type != PRINT_ATOM)
-			die("previous needed to be PRINT_ATOM");
+		if (arg->type != PRINT_ATOM) {
+			do_warning("previous needed to be PRINT_ATOM");
+			goto out_free;
+		}
 
 		item_arg = alloc_arg();
 
@@ -2666,7 +2715,8 @@ process_arg_token(struct event_format *event, struct print_arg *arg,
 
 	case EVENT_ERROR ... EVENT_NEWLINE:
 	default:
-		die("unexpected type %d", type);
+		do_warning("unexpected type %d", type);
+		return EVENT_ERROR;
 	}
 	*tok = token;
 
@@ -2913,8 +2963,10 @@ static int get_common_info(struct pevent *pevent,
 	 * All events should have the same common elements.
 	 * Pick any event to find where the type is;
 	 */
-	if (!pevent->events)
-		die("no event_list!");
+	if (!pevent->events) {
+		do_warning("no event_list!");
+		return -1;
+	}
 
 	event = pevent->events[0];
 	field = pevent_find_common_field(event, type);
@@ -3072,7 +3124,8 @@ eval_num_arg(void *data, int size, struct event_format *event, struct print_arg
 		if (!arg->field.field) {
 			arg->field.field = pevent_find_any_field(event, arg->field.name);
 			if (!arg->field.field)
-				die("field %s not found", arg->field.name);
+				goto out_warning_field;
+			
 		}
 		/* must be a number */
 		val = pevent_read_number(pevent, data + arg->field.field->offset,
@@ -3133,8 +3186,10 @@ eval_num_arg(void *data, int size, struct event_format *event, struct print_arg
 				if (!larg->field.field) {
 					larg->field.field =
 						pevent_find_any_field(event, larg->field.name);
-					if (!larg->field.field)
-						die("field %s not found", larg->field.name);
+					if (!larg->field.field) {
+						arg = larg;
+						goto out_warning_field;
+					}
 				}
 				field_size = larg->field.field->elementsize;
 				offset = larg->field.field->offset +
@@ -3170,7 +3225,7 @@ eval_num_arg(void *data, int size, struct event_format *event, struct print_arg
 				val = left != right;
 				break;
 			default:
-				die("unknown op '%s'", arg->op.op);
+				goto out_warning_op;
 			}
 			break;
 		case '~':
@@ -3200,7 +3255,7 @@ eval_num_arg(void *data, int size, struct event_format *event, struct print_arg
 				val = left <= right;
 				break;
 			default:
-				die("unknown op '%s'", arg->op.op);
+				goto out_warning_op;
 			}
 			break;
 		case '>':
@@ -3215,12 +3270,13 @@ eval_num_arg(void *data, int size, struct event_format *event, struct print_arg
 				val = left >= right;
 				break;
 			default:
-				die("unknown op '%s'", arg->op.op);
+				goto out_warning_op;
 			}
 			break;
 		case '=':
 			if (arg->op.op[1] != '=')
-				die("unknown op '%s'", arg->op.op);
+				goto out_warning_op;
+
 			val = left == right;
 			break;
 		case '-':
@@ -3236,13 +3292,21 @@ eval_num_arg(void *data, int size, struct event_format *event, struct print_arg
 			val = left * right;
 			break;
 		default:
-			die("unknown op '%s'", arg->op.op);
+			goto out_warning_op;
 		}
 		break;
 	default: /* not sure what to do there */
 		return 0;
 	}
 	return val;
+
+out_warning_op:
+	do_warning("%s: unknown op '%s'", __func__, arg->op.op);
+	return 0;
+
+out_warning_field:
+	do_warning("%s: field %s not found", __func__, arg->field.name);
+	return 0;
 }
 
 struct flag {
@@ -3319,8 +3383,10 @@ static void print_str_arg(struct trace_seq *s, void *data, int size,
 		field = arg->field.field;
 		if (!field) {
 			field = pevent_find_any_field(event, arg->field.name);
-			if (!field)
-				die("field %s not found", arg->field.name);
+			if (!field) {
+				str = arg->field.name;
+				goto out_warning_field;
+			}
 			arg->field.field = field;
 		}
 		/* Zero sized fields, mean the rest of the data */
@@ -3337,7 +3403,11 @@ static void print_str_arg(struct trace_seq *s, void *data, int size,
 			trace_seq_printf(s, "%lx", addr);
 			break;
 		}
-		str = malloc_or_die(len + 1);
+		str = malloc(len + 1);
+		if (!str) {
+			do_warning("%s: not enough memory!", __func__);
+			return;
+		}
 		memcpy(str, data + field->offset, len);
 		str[len] = 0;
 		print_str_to_seq(s, format, len_arg, str);
@@ -3377,7 +3447,7 @@ static void print_str_arg(struct trace_seq *s, void *data, int size,
 			str = arg->hex.field->field.name;
 			field = pevent_find_any_field(event, str);
 			if (!field)
-				die("field %s not found", str);
+				goto out_warning_field;
 			arg->hex.field->field.field = field;
 		}
 		hex = data + field->offset;
@@ -3429,6 +3499,11 @@ static void print_str_arg(struct trace_seq *s, void *data, int size,
 		/* well... */
 		break;
 	}
+
+	return;
+
+out_warning_field:
+	do_warning("%s: field %s not found", __func__, arg->field.name);
 }
 
 static unsigned long long
@@ -3455,7 +3530,11 @@ process_defined_func(struct trace_seq *s, void *data, int size,
 	farg = arg->func.args;
 	param = func_handle->params;
 
-	args = malloc_or_die(sizeof(*args) * func_handle->nr_args);
+	ret = ULLONG_MAX;
+	args = malloc(sizeof(*args) * func_handle->nr_args);
+	if (!args)
+		goto out;
+
 	for (i = 0; i < func_handle->nr_args; i++) {
 		switch (param->type) {
 		case PEVENT_FUNC_ARG_INT:
@@ -3467,12 +3546,18 @@ process_defined_func(struct trace_seq *s, void *data, int size,
 			trace_seq_init(&str);
 			print_str_arg(&str, data, size, event, "%s", -1, farg);
 			trace_seq_terminate(&str);
-			string = malloc_or_die(sizeof(*string));
+			string = malloc(sizeof(*string));
+			if (!string) {
+				do_warning("%s(%d): malloc str", __func__, __LINE__);
+				goto out_free;
+			}
 			string->next = strings;
 			string->str = strdup(str.buffer);
-			if (!string->str)
-				die("malloc str");
-
+			if (!string->str) {
+				free(string);
+				do_warning("%s(%d): malloc str", __func__, __LINE__);
+				goto out_free;
+			}
 			args[i] = (uintptr_t)string->str;
 			strings = string;
 			trace_seq_destroy(&str);
@@ -3482,14 +3567,15 @@ process_defined_func(struct trace_seq *s, void *data, int size,
 			 * Something went totally wrong, this is not
 			 * an input error, something in this code broke.
 			 */
-			die("Unexpected end of arguments\n");
-			break;
+			do_warning("Unexpected end of arguments\n");
+			goto out_free;
 		}
 		farg = farg->next;
 		param = param->next;
 	}
 
 	ret = (*func_handle->func)(s, args);
+out_free:
 	free(args);
 	while (strings) {
 		string = strings;
@@ -3530,11 +3616,15 @@ static struct print_arg *make_bprint_args(char *fmt, void *data, int size, struc
 
 	if (!field) {
 		field = pevent_find_field(event, "buf");
-		if (!field)
-			die("can't find buffer field for binary printk");
+		if (!field) {
+			do_warning("can't find buffer field for binary printk");
+			return NULL;
+		}
 		ip_field = pevent_find_field(event, "ip");
-		if (!ip_field)
-			die("can't find ip field for binary printk");
+		if (!ip_field) {
+			do_warning("can't find ip field for binary printk");
+			return NULL;
+		}
 		pevent->bprint_buf_field = field;
 		pevent->bprint_ip_field = ip_field;
 	}
@@ -3629,7 +3719,7 @@ static struct print_arg *make_bprint_args(char *fmt, void *data, int size, struc
 				arg->type = PRINT_BSTRING;
 				arg->string.string = strdup(bptr);
 				if (!arg->string.string)
-					break;
+					goto out_free;
 				bptr += strlen(bptr) + 1;
 				*next = arg;
 				next = &arg->next;
@@ -3661,8 +3751,10 @@ get_bprint_format(void *data, int size __maybe_unused,
 
 	if (!field) {
 		field = pevent_find_field(event, "fmt");
-		if (!field)
-			die("can't find format field for binary printk");
+		if (!field) {
+			do_warning("can't find format field for binary printk");
+			return NULL;
+		}
 		pevent->bprint_fmt_field = field;
 	}
 
@@ -3715,8 +3807,11 @@ static void print_mac_arg(struct trace_seq *s, int mac, void *data, int size,
 	if (!arg->field.field) {
 		arg->field.field =
 			pevent_find_any_field(event, arg->field.name);
-		if (!arg->field.field)
-			die("field %s not found", arg->field.name);
+		if (!arg->field.field) {
+			do_warning("%s: field %s not found",
+				   __func__, arg->field.name);
+			return;
+		}
 	}
 	if (arg->field.field->size != 6) {
 		trace_seq_printf(s, "INVALIDMAC");
@@ -4372,7 +4467,10 @@ get_event_fields(const char *type, const char *name,
 	struct format_field *field;
 	int i = 0;
 
-	fields = malloc_or_die(sizeof(*fields) * (count + 1));
+	fields = malloc(sizeof(*fields) * (count + 1));
+	if (!fields)
+		return NULL;
+
 	for (field = list; field; field = field->next) {
 		fields[i++] = field;
 		if (i == count + 1) {
@@ -4767,7 +4865,8 @@ enum pevent_errno pevent_parse_event(struct pevent *pevent, const char *buf,
 	}
 	show_warning = 1;
 
-	add_event(pevent, event);
+	if (add_event(pevent, event))
+		goto event_alloc_failed;
 
 	if (!ret && (event->flags & EVENT_FL_ISFTRACE)) {
 		struct format_field *field;
@@ -4800,7 +4899,9 @@ enum pevent_errno pevent_parse_event(struct pevent *pevent, const char *buf,
  event_parse_failed:
 	event->flags |= EVENT_FL_FAILED;
 	/* still add it even if it failed */
-	add_event(pevent, event);
+	if (add_event(pevent, event))
+		goto event_alloc_failed;
+
 	return ret;
 
  event_alloc_failed:
-- 
1.7.9.2.358.g22243

