Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756019Ab2I0Fo1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2012 01:44:27 -0400
Received: from terminus.zytor.com ([198.137.202.10]:54235 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755000Ab2I0FoX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2012 01:44:23 -0400
Date: Wed, 26 Sep 2012 22:43:56 -0700
From: tip-bot for Arnaldo Carvalho de Melo <acme@redhat.com>
Message-ID: <tip-9ebpr2vgfk2qs2841i99sa8y@git.kernel.org>
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
Subject: [tip:perf/core] tools lib traceevent: Remove some die() calls
Git-Commit-ID: a6d2a61ac653a85718aa61000d2648803f211ba3
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Wed, 26 Sep 2012 22:44:02 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  a6d2a61ac653a85718aa61000d2648803f211ba3
Gitweb:     http://git.kernel.org/tip/a6d2a61ac653a85718aa61000d2648803f211ba3
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Wed, 12 Sep 2012 17:30:50 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 24 Sep 2012 12:13:35 -0300

tools lib traceevent: Remove some die() calls

Cleaned event-parse.c this time, just propagate the errors and in handle
them the call sites.

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
Link: http://lkml.kernel.org/n/tip-9ebpr2vgfk2qs2841i99sa8y@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/lib/traceevent/event-parse.c |  249 +++++++++++++++++++++++++-----------
 1 files changed, 175 insertions(+), 74 deletions(-)

diff --git a/tools/lib/traceevent/event-parse.c b/tools/lib/traceevent/event-parse.c
index 2091991..b3bc130 100644
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
@@ -1751,8 +1790,10 @@ process_op(struct event_format *event, struct print_arg *arg, char **tok)
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
@@ -1870,7 +1911,11 @@ eval_type_str(unsigned long long val, const char *type, int pointer)
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
@@ -1947,8 +1992,10 @@ eval_type_str(unsigned long long val, const char *type, int pointer)
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
@@ -2133,7 +2180,7 @@ static char *arg_eval (struct print_arg *arg)
 	case PRINT_STRING:
 	case PRINT_BSTRING:
 	default:
-		die("invalid eval type %d", arg->type);
+		do_warning("invalid eval type %d", arg->type);
 		break;
 	}
 
@@ -2431,8 +2478,10 @@ process_paren(struct event_format *event, struct print_arg *arg, char **tok)
 		/* make this a typecast and contine */
 
 		/* prevous must be an atom */
-		if (arg->type != PRINT_ATOM)
-			die("previous needed to be PRINT_ATOM");
+		if (arg->type != PRINT_ATOM) {
+			do_warning("previous needed to be PRINT_ATOM");
+			goto out_free;
+		}
 
 		item_arg = alloc_arg();
 
@@ -2674,7 +2723,8 @@ process_arg_token(struct event_format *event, struct print_arg *arg,
 
 	case EVENT_ERROR ... EVENT_NEWLINE:
 	default:
-		die("unexpected type %d", type);
+		do_warning("unexpected type %d", type);
+		return EVENT_ERROR;
 	}
 	*tok = token;
 
@@ -2921,8 +2971,10 @@ static int get_common_info(struct pevent *pevent,
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
@@ -3080,7 +3132,8 @@ eval_num_arg(void *data, int size, struct event_format *event, struct print_arg
 		if (!arg->field.field) {
 			arg->field.field = pevent_find_any_field(event, arg->field.name);
 			if (!arg->field.field)
-				die("field %s not found", arg->field.name);
+				goto out_warning_field;
+			
 		}
 		/* must be a number */
 		val = pevent_read_number(pevent, data + arg->field.field->offset,
@@ -3141,8 +3194,10 @@ eval_num_arg(void *data, int size, struct event_format *event, struct print_arg
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
@@ -3178,7 +3233,7 @@ eval_num_arg(void *data, int size, struct event_format *event, struct print_arg
 				val = left != right;
 				break;
 			default:
-				die("unknown op '%s'", arg->op.op);
+				goto out_warning_op;
 			}
 			break;
 		case '~':
@@ -3208,7 +3263,7 @@ eval_num_arg(void *data, int size, struct event_format *event, struct print_arg
 				val = left <= right;
 				break;
 			default:
-				die("unknown op '%s'", arg->op.op);
+				goto out_warning_op;
 			}
 			break;
 		case '>':
@@ -3223,12 +3278,13 @@ eval_num_arg(void *data, int size, struct event_format *event, struct print_arg
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
@@ -3244,13 +3300,21 @@ eval_num_arg(void *data, int size, struct event_format *event, struct print_arg
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
@@ -3327,8 +3391,10 @@ static void print_str_arg(struct trace_seq *s, void *data, int size,
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
@@ -3345,7 +3411,11 @@ static void print_str_arg(struct trace_seq *s, void *data, int size,
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
@@ -3385,7 +3455,7 @@ static void print_str_arg(struct trace_seq *s, void *data, int size,
 			str = arg->hex.field->field.name;
 			field = pevent_find_any_field(event, str);
 			if (!field)
-				die("field %s not found", str);
+				goto out_warning_field;
 			arg->hex.field->field.field = field;
 		}
 		hex = data + field->offset;
@@ -3437,6 +3507,11 @@ static void print_str_arg(struct trace_seq *s, void *data, int size,
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
@@ -3463,7 +3538,11 @@ process_defined_func(struct trace_seq *s, void *data, int size,
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
@@ -3475,12 +3554,18 @@ process_defined_func(struct trace_seq *s, void *data, int size,
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
@@ -3490,14 +3575,15 @@ process_defined_func(struct trace_seq *s, void *data, int size,
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
@@ -3538,11 +3624,15 @@ static struct print_arg *make_bprint_args(char *fmt, void *data, int size, struc
 
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
@@ -3637,7 +3727,7 @@ static struct print_arg *make_bprint_args(char *fmt, void *data, int size, struc
 				arg->type = PRINT_BSTRING;
 				arg->string.string = strdup(bptr);
 				if (!arg->string.string)
-					break;
+					goto out_free;
 				bptr += strlen(bptr) + 1;
 				*next = arg;
 				next = &arg->next;
@@ -3669,8 +3759,10 @@ get_bprint_format(void *data, int size __maybe_unused,
 
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
 
@@ -3723,8 +3815,11 @@ static void print_mac_arg(struct trace_seq *s, int mac, void *data, int size,
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
@@ -4380,7 +4475,10 @@ get_event_fields(const char *type, const char *name,
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
@@ -4775,7 +4873,8 @@ enum pevent_errno pevent_parse_event(struct pevent *pevent, const char *buf,
 	}
 	show_warning = 1;
 
-	add_event(pevent, event);
+	if (add_event(pevent, event))
+		goto event_alloc_failed;
 
 	if (!ret && (event->flags & EVENT_FL_ISFTRACE)) {
 		struct format_field *field;
@@ -4808,7 +4907,9 @@ enum pevent_errno pevent_parse_event(struct pevent *pevent, const char *buf,
  event_parse_failed:
 	event->flags |= EVENT_FL_FAILED;
 	/* still add it even if it failed */
-	add_event(pevent, event);
+	if (add_event(pevent, event))
+		goto event_alloc_failed;
+
 	return ret;
 
  event_alloc_failed:
