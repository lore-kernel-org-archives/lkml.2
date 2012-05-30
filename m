Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754749Ab2E3Pjb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2012 11:39:31 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:32871 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751212Ab2E3Pj1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2012 11:39:27 -0400
Date: Wed, 30 May 2012 17:39:15 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] perf fixes
Message-ID: <20120530153915.GA7369@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest perf-urgent-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git perf-urgent-for-linus

   HEAD: 59cd358a7a5b2f6b61faa01dae6cfda3830ac62a Merge tag 'perf-core-for-mingo' of git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux into perf/urgent

 Thanks,

	Ingo

------------------>
Arnaldo Carvalho de Melo (9):
      perf evlist: Explicititely initialize input_name
      perf tools: Do not use _FORTIFY_SOURCE when DEBUG=1 is specified
      perf top: Fix counter name fixup when fallbacking to cpu-clock
      perf tools: Reconstruct event with modifiers from perf_event_attr
      perf annotate browser: The idx_asm field should be used in asm only view
      perf annotate browser: Make feature toggles global
      perf config: Allow '_' in config file variable names
      perf annotate browser: Read perf config file for settings
      perf ui browser: Stop using 'self'

Franck Bui-Huu (1):
      perf tools: fix thread_map__new_by_pid_str() memory leak in error path

Namhyung Kim (8):
      tools lib traceevent: Fix a possible memory leak
      tools lib traceevent: Fix a possibly wrong memory dereference
      tools lib traceevent: Fix freeing arg on process_dynamic_array()
      tools lib traceevent: Use proper function parameter type
      tools lib traceevent: Fix signature of create_arg_item()
      tools lib traceevent: Silence compiler warning on 32bit build
      perf ui: Make --stdio default when TUI is not supported
      perf tools: Convert critical messages to ui__error()

Stefan Hajnoczi (1):
      tools lib traceevent: Allow expressions in __print_symbolic() fields

Stephane Eranian (1):
      perf record: Fix branch_stack type in perf_record_opts

Steven Rostedt (1):
      ring-buffer: Check for valid buffer before changing size


 kernel/trace/ring_buffer.c                  |   5 +
 tools/lib/traceevent/event-parse.c          |  22 +-
 tools/lib/traceevent/parse-filter.c         |   7 +-
 tools/perf/Documentation/perfconfig.example |   8 +
 tools/perf/Makefile                         |   4 +-
 tools/perf/builtin-annotate.c               |   2 +-
 tools/perf/builtin-evlist.c                 |   2 +-
 tools/perf/builtin-record.c                 |  14 +-
 tools/perf/builtin-report.c                 |  14 +-
 tools/perf/builtin-top.c                    |  24 +-
 tools/perf/perf.h                           |   2 +-
 tools/perf/ui/browser.c                     | 182 +++++++--------
 tools/perf/ui/browser.h                     |   1 +
 tools/perf/ui/browsers/annotate.c           | 262 +++++++++++++--------
 tools/perf/ui/browsers/hists.c              | 338 ++++++++++++++--------------
 tools/perf/ui/setup.c                       |   1 +
 tools/perf/util/config.c                    |   2 +-
 tools/perf/util/evsel.c                     |  90 ++++++++
 tools/perf/util/evsel.h                     |   3 +
 tools/perf/util/parse-events.c              |  27 +--
 tools/perf/util/thread_map.c                |  21 +-
 21 files changed, 615 insertions(+), 416 deletions(-)

diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index 6420cda..1d0f6a8 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -1486,6 +1486,11 @@ int ring_buffer_resize(struct ring_buffer *buffer, unsigned long size,
 	if (!buffer)
 		return size;
 
+	/* Make sure the requested buffer exists */
+	if (cpu_id != RING_BUFFER_ALL_CPUS &&
+	    !cpumask_test_cpu(cpu_id, buffer->cpumask))
+		return size;
+
 	size = DIV_ROUND_UP(size, BUF_PAGE_SIZE);
 	size *= BUF_PAGE_SIZE;
 
diff --git a/tools/lib/traceevent/event-parse.c b/tools/lib/traceevent/event-parse.c
index 9985349..5548282 100644
--- a/tools/lib/traceevent/event-parse.c
+++ b/tools/lib/traceevent/event-parse.c
@@ -1434,8 +1434,11 @@ static int event_read_fields(struct event_format *event, struct format_field **f
 fail:
 	free_token(token);
 fail_expect:
-	if (field)
+	if (field) {
+		free(field->type);
+		free(field->name);
 		free(field);
+	}
 	return -1;
 }
 
@@ -1712,6 +1715,8 @@ process_op(struct event_format *event, struct print_arg *arg, char **tok)
 
 		if (set_op_prio(arg) == -1) {
 			event->flags |= EVENT_FL_FAILED;
+			/* arg->op.op (= token) will be freed at out_free */
+			arg->op.op = NULL;
 			goto out_free;
 		}
 
@@ -2124,6 +2129,13 @@ process_fields(struct event_format *event, struct print_flag_sym **list, char **
 
 		free_token(token);
 		type = process_arg(event, arg, &token);
+
+		if (type == EVENT_OP)
+			type = process_op(event, arg, &token);
+
+		if (type == EVENT_ERROR)
+			goto out_free;
+
 		if (test_type_token(type, token, EVENT_DELIM, ","))
 			goto out_free;
 
@@ -2288,17 +2300,18 @@ process_dynamic_array(struct event_format *event, struct print_arg *arg, char **
 	arg = alloc_arg();
 	type = process_arg(event, arg, &token);
 	if (type == EVENT_ERROR)
-		goto out_free;
+		goto out_free_arg;
 
 	if (!test_type_token(type, token, EVENT_OP, "]"))
-		goto out_free;
+		goto out_free_arg;
 
 	free_token(token);
 	type = read_token_item(tok);
 	return type;
 
+ out_free_arg:
+	free_arg(arg);
  out_free:
-	free(arg);
 	free_token(token);
 	*tok = NULL;
 	return EVENT_ERROR;
@@ -3362,6 +3375,7 @@ process_defined_func(struct trace_seq *s, void *data, int size,
 			break;
 		}
 		farg = farg->next;
+		param = param->next;
 	}
 
 	ret = (*func_handle->func)(s, args);
diff --git a/tools/lib/traceevent/parse-filter.c b/tools/lib/traceevent/parse-filter.c
index 2d40c5e..dfcfe2c 100644
--- a/tools/lib/traceevent/parse-filter.c
+++ b/tools/lib/traceevent/parse-filter.c
@@ -325,9 +325,8 @@ static void free_events(struct event_list *events)
 }
 
 static struct filter_arg *
-create_arg_item(struct event_format *event,
-		const char *token, enum filter_arg_type type,
-		char **error_str)
+create_arg_item(struct event_format *event, const char *token,
+		enum event_type type, char **error_str)
 {
 	struct format_field *field;
 	struct filter_arg *arg;
@@ -1585,7 +1584,7 @@ get_value(struct event_format *event,
 		const char *name;
 
 		name = get_comm(event, record);
-		return (unsigned long long)name;
+		return (unsigned long)name;
 	}
 
 	pevent_read_number_field(field, record->data, &val);
diff --git a/tools/perf/Documentation/perfconfig.example b/tools/perf/Documentation/perfconfig.example
index 42c6fd2..767ea24 100644
--- a/tools/perf/Documentation/perfconfig.example
+++ b/tools/perf/Documentation/perfconfig.example
@@ -19,3 +19,11 @@
 
 	# Default, disable using /dev/null
 	dir = /root/.debug
+
+[annotate]
+
+	# Defaults
+	hide_src_code = false
+	use_offset = true
+	jump_arrows = true
+	show_nr_jumps = false
diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 1d3d513..0eee64c 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -80,7 +80,7 @@ ifeq ("$(origin DEBUG)", "command line")
   PERF_DEBUG = $(DEBUG)
 endif
 ifndef PERF_DEBUG
-  CFLAGS_OPTIMIZE = -O6
+  CFLAGS_OPTIMIZE = -O6 -D_FORTIFY_SOURCE=2
 endif
 
 ifdef PARSER_DEBUG
@@ -89,7 +89,7 @@ ifdef PARSER_DEBUG
 	PARSER_DEBUG_CFLAGS := -DPARSER_DEBUG
 endif
 
-CFLAGS = -fno-omit-frame-pointer -ggdb3 -Wall -Wextra -std=gnu99 $(CFLAGS_WERROR) $(CFLAGS_OPTIMIZE) -D_FORTIFY_SOURCE=2 $(EXTRA_WARNINGS) $(EXTRA_CFLAGS) $(PARSER_DEBUG_CFLAGS)
+CFLAGS = -fno-omit-frame-pointer -ggdb3 -Wall -Wextra -std=gnu99 $(CFLAGS_WERROR) $(CFLAGS_OPTIMIZE) $(EXTRA_WARNINGS) $(EXTRA_CFLAGS) $(PARSER_DEBUG_CFLAGS)
 EXTLIBS = -lpthread -lrt -lelf -lm
 ALL_CFLAGS = $(CFLAGS) -D_LARGEFILE64_SOURCE -D_FILE_OFFSET_BITS=64 -D_GNU_SOURCE
 ALL_LDFLAGS = $(LDFLAGS)
diff --git a/tools/perf/builtin-annotate.c b/tools/perf/builtin-annotate.c
index 806e0a2..67522cf 100644
--- a/tools/perf/builtin-annotate.c
+++ b/tools/perf/builtin-annotate.c
@@ -215,7 +215,7 @@ static int __cmd_annotate(struct perf_annotate *ann)
 	}
 
 	if (total_nr_samples == 0) {
-		ui__warning("The %s file has no samples!\n", session->filename);
+		ui__error("The %s file has no samples!\n", session->filename);
 		goto out_delete;
 	}
 out_delete:
diff --git a/tools/perf/builtin-evlist.c b/tools/perf/builtin-evlist.c
index e52d77e..acd78dc 100644
--- a/tools/perf/builtin-evlist.c
+++ b/tools/perf/builtin-evlist.c
@@ -116,7 +116,7 @@ static const char * const evlist_usage[] = {
 int cmd_evlist(int argc, const char **argv, const char *prefix __used)
 {
 	struct perf_attr_details details = { .verbose = false, };
-	const char *input_name;
+	const char *input_name = NULL;
 	const struct option options[] = {
 		OPT_STRING('i', "input", &input_name, "file",
 			    "Input file name"),
diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index e5cb084..f95840d 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -264,7 +264,7 @@ try_again:
 			}
 
 			if (err == ENOENT) {
-				ui__warning("The %s event is not supported.\n",
+				ui__error("The %s event is not supported.\n",
 					    event_name(pos));
 				exit(EXIT_FAILURE);
 			}
@@ -858,8 +858,8 @@ int cmd_record(int argc, const char **argv, const char *prefix __used)
 		usage_with_options(record_usage, record_options);
 
 	if (rec->force && rec->append_file) {
-		fprintf(stderr, "Can't overwrite and append at the same time."
-				" You need to choose between -f and -A");
+		ui__error("Can't overwrite and append at the same time."
+			  " You need to choose between -f and -A");
 		usage_with_options(record_usage, record_options);
 	} else if (rec->append_file) {
 		rec->write_mode = WRITE_APPEND;
@@ -868,8 +868,8 @@ int cmd_record(int argc, const char **argv, const char *prefix __used)
 	}
 
 	if (nr_cgroups && !rec->opts.target.system_wide) {
-		fprintf(stderr, "cgroup monitoring only available in"
-			" system-wide mode\n");
+		ui__error("cgroup monitoring only available in"
+			  " system-wide mode\n");
 		usage_with_options(record_usage, record_options);
 	}
 
@@ -905,7 +905,7 @@ int cmd_record(int argc, const char **argv, const char *prefix __used)
 		int saved_errno = errno;
 
 		perf_target__strerror(&rec->opts.target, err, errbuf, BUFSIZ);
-		ui__warning("%s", errbuf);
+		ui__error("%s", errbuf);
 
 		err = -saved_errno;
 		goto out_free_fd;
@@ -933,7 +933,7 @@ int cmd_record(int argc, const char **argv, const char *prefix __used)
 	else if (rec->opts.freq) {
 		rec->opts.default_interval = rec->opts.freq;
 	} else {
-		fprintf(stderr, "frequency and count are zero, aborting\n");
+		ui__error("frequency and count are zero, aborting\n");
 		err = -EINVAL;
 		goto out_free_fd;
 	}
diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index d58e414..8c767c6 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -251,13 +251,13 @@ static int perf_report__setup_sample_type(struct perf_report *rep)
 
 	if (!(self->sample_type & PERF_SAMPLE_CALLCHAIN)) {
 		if (sort__has_parent) {
-			ui__warning("Selected --sort parent, but no "
+			ui__error("Selected --sort parent, but no "
 				    "callchain data. Did you call "
 				    "'perf record' without -g?\n");
 			return -EINVAL;
 		}
 		if (symbol_conf.use_callchain) {
-			ui__warning("Selected -g but no callchain data. Did "
+			ui__error("Selected -g but no callchain data. Did "
 				    "you call 'perf record' without -g?\n");
 			return -1;
 		}
@@ -266,17 +266,15 @@ static int perf_report__setup_sample_type(struct perf_report *rep)
 		   !symbol_conf.use_callchain) {
 			symbol_conf.use_callchain = true;
 			if (callchain_register_param(&callchain_param) < 0) {
-				ui__warning("Can't register callchain "
-					    "params.\n");
+				ui__error("Can't register callchain params.\n");
 				return -EINVAL;
 			}
 	}
 
 	if (sort__branch_mode == 1) {
 		if (!(self->sample_type & PERF_SAMPLE_BRANCH_STACK)) {
-			fprintf(stderr, "selected -b but no branch data."
-					" Did you call perf record without"
-					" -b?\n");
+			ui__error("Selected -b but no branch data. "
+				  "Did you call perf record without -b?\n");
 			return -1;
 		}
 	}
@@ -420,7 +418,7 @@ static int __cmd_report(struct perf_report *rep)
 	}
 
 	if (nr_samples == 0) {
-		ui__warning("The %s file has no samples!\n", session->filename);
+		ui__error("The %s file has no samples!\n", session->filename);
 		goto out_delete;
 	}
 
diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index 6031dce..871b540 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -953,22 +953,22 @@ try_again:
 				attr->config = PERF_COUNT_SW_CPU_CLOCK;
 				if (counter->name) {
 					free(counter->name);
-					counter->name = strdup(event_name(counter));
+					counter->name = NULL;
 				}
 				goto try_again;
 			}
 
 			if (err == ENOENT) {
-				ui__warning("The %s event is not supported.\n",
+				ui__error("The %s event is not supported.\n",
 					    event_name(counter));
 				goto out_err;
 			} else if (err == EMFILE) {
-				ui__warning("Too many events are opened.\n"
+				ui__error("Too many events are opened.\n"
 					    "Try again after reducing the number of events\n");
 				goto out_err;
 			}
 
-			ui__warning("The sys_perf_event_open() syscall "
+			ui__error("The sys_perf_event_open() syscall "
 				    "returned with %d (%s).  /bin/dmesg "
 				    "may provide additional information.\n"
 				    "No CONFIG_PERF_EVENTS=y kernel support "
@@ -978,7 +978,7 @@ try_again:
 	}
 
 	if (perf_evlist__mmap(evlist, top->mmap_pages, false) < 0) {
-		ui__warning("Failed to mmap with %d (%s)\n",
+		ui__error("Failed to mmap with %d (%s)\n",
 			    errno, strerror(errno));
 		goto out_err;
 	}
@@ -994,12 +994,12 @@ static int perf_top__setup_sample_type(struct perf_top *top)
 {
 	if (!top->sort_has_symbols) {
 		if (symbol_conf.use_callchain) {
-			ui__warning("Selected -g but \"sym\" not present in --sort/-s.");
+			ui__error("Selected -g but \"sym\" not present in --sort/-s.");
 			return -EINVAL;
 		}
 	} else if (!top->dont_use_callchains && callchain_param.mode != CHAIN_NONE) {
 		if (callchain_register_param(&callchain_param) < 0) {
-			ui__warning("Can't register callchain params.\n");
+			ui__error("Can't register callchain params.\n");
 			return -EINVAL;
 		}
 	}
@@ -1041,7 +1041,7 @@ static int __cmd_top(struct perf_top *top)
 
 	if (pthread_create(&thread, NULL, (use_browser > 0 ? display_thread_tui :
 							    display_thread), top)) {
-		printf("Could not create display thread.\n");
+		ui__error("Could not create display thread.\n");
 		exit(-1);
 	}
 
@@ -1050,7 +1050,7 @@ static int __cmd_top(struct perf_top *top)
 
 		param.sched_priority = top->realtime_prio;
 		if (sched_setscheduler(0, SCHED_FIFO, &param)) {
-			printf("Could not set realtime priority.\n");
+			ui__error("Could not set realtime priority.\n");
 			exit(-1);
 		}
 	}
@@ -1274,7 +1274,7 @@ int cmd_top(int argc, const char **argv, const char *prefix __used)
 		int saved_errno = errno;
 
 		perf_target__strerror(&top.target, status, errbuf, BUFSIZ);
-		ui__warning("%s", errbuf);
+		ui__error("%s", errbuf);
 
 		status = -saved_errno;
 		goto out_delete_evlist;
@@ -1288,7 +1288,7 @@ int cmd_top(int argc, const char **argv, const char *prefix __used)
 
 	if (!top.evlist->nr_entries &&
 	    perf_evlist__add_default(top.evlist) < 0) {
-		pr_err("Not enough memory for event selector list\n");
+		ui__error("Not enough memory for event selector list\n");
 		return -ENOMEM;
 	}
 
@@ -1305,7 +1305,7 @@ int cmd_top(int argc, const char **argv, const char *prefix __used)
 	else if (top.freq) {
 		top.default_interval = top.freq;
 	} else {
-		fprintf(stderr, "frequency and count are zero, aborting\n");
+		ui__error("frequency and count are zero, aborting\n");
 		exit(EXIT_FAILURE);
 	}
 
diff --git a/tools/perf/perf.h b/tools/perf/perf.h
index 14f1034..f960ccb 100644
--- a/tools/perf/perf.h
+++ b/tools/perf/perf.h
@@ -227,7 +227,7 @@ struct perf_record_opts {
 	unsigned int freq;
 	unsigned int mmap_pages;
 	unsigned int user_freq;
-	int	     branch_stack;
+	u64          branch_stack;
 	u64	     default_interval;
 	u64	     user_interval;
 };
diff --git a/tools/perf/ui/browser.c b/tools/perf/ui/browser.c
index cde4d0f..1818a53 100644
--- a/tools/perf/ui/browser.c
+++ b/tools/perf/ui/browser.c
@@ -35,16 +35,16 @@ int ui_browser__set_color(struct ui_browser *browser, int color)
 	return ret;
 }
 
-void ui_browser__set_percent_color(struct ui_browser *self,
+void ui_browser__set_percent_color(struct ui_browser *browser,
 				   double percent, bool current)
 {
-	 int color = ui_browser__percent_color(self, percent, current);
-	 ui_browser__set_color(self, color);
+	 int color = ui_browser__percent_color(browser, percent, current);
+	 ui_browser__set_color(browser, color);
 }
 
-void ui_browser__gotorc(struct ui_browser *self, int y, int x)
+void ui_browser__gotorc(struct ui_browser *browser, int y, int x)
 {
-	SLsmg_gotorc(self->y + y, self->x + x);
+	SLsmg_gotorc(browser->y + y, browser->x + x);
 }
 
 static struct list_head *
@@ -73,23 +73,23 @@ ui_browser__list_head_filter_prev_entries(struct ui_browser *browser,
 	return NULL;
 }
 
-void ui_browser__list_head_seek(struct ui_browser *self, off_t offset, int whence)
+void ui_browser__list_head_seek(struct ui_browser *browser, off_t offset, int whence)
 {
-	struct list_head *head = self->entries;
+	struct list_head *head = browser->entries;
 	struct list_head *pos;
 
-	if (self->nr_entries == 0)
+	if (browser->nr_entries == 0)
 		return;
 
 	switch (whence) {
 	case SEEK_SET:
-		pos = ui_browser__list_head_filter_entries(self, head->next);
+		pos = ui_browser__list_head_filter_entries(browser, head->next);
 		break;
 	case SEEK_CUR:
-		pos = self->top;
+		pos = browser->top;
 		break;
 	case SEEK_END:
-		pos = ui_browser__list_head_filter_prev_entries(self, head->prev);
+		pos = ui_browser__list_head_filter_prev_entries(browser, head->prev);
 		break;
 	default:
 		return;
@@ -99,18 +99,18 @@ void ui_browser__list_head_seek(struct ui_browser *self, off_t offset, int whenc
 
 	if (offset > 0) {
 		while (offset-- != 0)
-			pos = ui_browser__list_head_filter_entries(self, pos->next);
+			pos = ui_browser__list_head_filter_entries(browser, pos->next);
 	} else {
 		while (offset++ != 0)
-			pos = ui_browser__list_head_filter_prev_entries(self, pos->prev);
+			pos = ui_browser__list_head_filter_prev_entries(browser, pos->prev);
 	}
 
-	self->top = pos;
+	browser->top = pos;
 }
 
-void ui_browser__rb_tree_seek(struct ui_browser *self, off_t offset, int whence)
+void ui_browser__rb_tree_seek(struct ui_browser *browser, off_t offset, int whence)
 {
-	struct rb_root *root = self->entries;
+	struct rb_root *root = browser->entries;
 	struct rb_node *nd;
 
 	switch (whence) {
@@ -118,7 +118,7 @@ void ui_browser__rb_tree_seek(struct ui_browser *self, off_t offset, int whence)
 		nd = rb_first(root);
 		break;
 	case SEEK_CUR:
-		nd = self->top;
+		nd = browser->top;
 		break;
 	case SEEK_END:
 		nd = rb_last(root);
@@ -135,23 +135,23 @@ void ui_browser__rb_tree_seek(struct ui_browser *self, off_t offset, int whence)
 			nd = rb_prev(nd);
 	}
 
-	self->top = nd;
+	browser->top = nd;
 }
 
-unsigned int ui_browser__rb_tree_refresh(struct ui_browser *self)
+unsigned int ui_browser__rb_tree_refresh(struct ui_browser *browser)
 {
 	struct rb_node *nd;
 	int row = 0;
 
-	if (self->top == NULL)
-                self->top = rb_first(self->entries);
+	if (browser->top == NULL)
+                browser->top = rb_first(browser->entries);
 
-	nd = self->top;
+	nd = browser->top;
 
 	while (nd != NULL) {
-		ui_browser__gotorc(self, row, 0);
-		self->write(self, nd, row);
-		if (++row == self->height)
+		ui_browser__gotorc(browser, row, 0);
+		browser->write(browser, nd, row);
+		if (++row == browser->height)
 			break;
 		nd = rb_next(nd);
 	}
@@ -159,17 +159,17 @@ unsigned int ui_browser__rb_tree_refresh(struct ui_browser *self)
 	return row;
 }
 
-bool ui_browser__is_current_entry(struct ui_browser *self, unsigned row)
+bool ui_browser__is_current_entry(struct ui_browser *browser, unsigned row)
 {
-	return self->top_idx + row == self->index;
+	return browser->top_idx + row == browser->index;
 }
 
-void ui_browser__refresh_dimensions(struct ui_browser *self)
+void ui_browser__refresh_dimensions(struct ui_browser *browser)
 {
-	self->width = SLtt_Screen_Cols - 1;
-	self->height = SLtt_Screen_Rows - 2;
-	self->y = 1;
-	self->x = 0;
+	browser->width = SLtt_Screen_Cols - 1;
+	browser->height = SLtt_Screen_Rows - 2;
+	browser->y = 1;
+	browser->x = 0;
 }
 
 void ui_browser__handle_resize(struct ui_browser *browser)
@@ -225,10 +225,10 @@ bool ui_browser__dialog_yesno(struct ui_browser *browser, const char *text)
 	return key == K_ENTER || toupper(key) == 'Y';
 }
 
-void ui_browser__reset_index(struct ui_browser *self)
+void ui_browser__reset_index(struct ui_browser *browser)
 {
-	self->index = self->top_idx = 0;
-	self->seek(self, 0, SEEK_SET);
+	browser->index = browser->top_idx = 0;
+	browser->seek(browser, 0, SEEK_SET);
 }
 
 void __ui_browser__show_title(struct ui_browser *browser, const char *title)
@@ -245,26 +245,26 @@ void ui_browser__show_title(struct ui_browser *browser, const char *title)
 	pthread_mutex_unlock(&ui__lock);
 }
 
-int ui_browser__show(struct ui_browser *self, const char *title,
+int ui_browser__show(struct ui_browser *browser, const char *title,
 		     const char *helpline, ...)
 {
 	int err;
 	va_list ap;
 
-	ui_browser__refresh_dimensions(self);
+	ui_browser__refresh_dimensions(browser);
 
 	pthread_mutex_lock(&ui__lock);
-	__ui_browser__show_title(self, title);
+	__ui_browser__show_title(browser, title);
 
-	self->title = title;
-	free(self->helpline);
-	self->helpline = NULL;
+	browser->title = title;
+	free(browser->helpline);
+	browser->helpline = NULL;
 
 	va_start(ap, helpline);
-	err = vasprintf(&self->helpline, helpline, ap);
+	err = vasprintf(&browser->helpline, helpline, ap);
 	va_end(ap);
 	if (err > 0)
-		ui_helpline__push(self->helpline);
+		ui_helpline__push(browser->helpline);
 	pthread_mutex_unlock(&ui__lock);
 	return err ? 0 : -1;
 }
@@ -350,7 +350,7 @@ void ui_browser__update_nr_entries(struct ui_browser *browser, u32 nr_entries)
 	browser->seek(browser, browser->top_idx, SEEK_SET);
 }
 
-int ui_browser__run(struct ui_browser *self, int delay_secs)
+int ui_browser__run(struct ui_browser *browser, int delay_secs)
 {
 	int err, key;
 
@@ -358,7 +358,7 @@ int ui_browser__run(struct ui_browser *self, int delay_secs)
 		off_t offset;
 
 		pthread_mutex_lock(&ui__lock);
-		err = __ui_browser__refresh(self);
+		err = __ui_browser__refresh(browser);
 		SLsmg_refresh();
 		pthread_mutex_unlock(&ui__lock);
 		if (err < 0)
@@ -368,18 +368,18 @@ int ui_browser__run(struct ui_browser *self, int delay_secs)
 
 		if (key == K_RESIZE) {
 			ui__refresh_dimensions(false);
-			ui_browser__refresh_dimensions(self);
-			__ui_browser__show_title(self, self->title);
-			ui_helpline__puts(self->helpline);
+			ui_browser__refresh_dimensions(browser);
+			__ui_browser__show_title(browser, browser->title);
+			ui_helpline__puts(browser->helpline);
 			continue;
 		}
 
-		if (self->use_navkeypressed && !self->navkeypressed) {
+		if (browser->use_navkeypressed && !browser->navkeypressed) {
 			if (key == K_DOWN || key == K_UP ||
 			    key == K_PGDN || key == K_PGUP ||
 			    key == K_HOME || key == K_END ||
 			    key == ' ') {
-				self->navkeypressed = true;
+				browser->navkeypressed = true;
 				continue;
 			} else
 				return key;
@@ -387,59 +387,59 @@ int ui_browser__run(struct ui_browser *self, int delay_secs)
 
 		switch (key) {
 		case K_DOWN:
-			if (self->index == self->nr_entries - 1)
+			if (browser->index == browser->nr_entries - 1)
 				break;
-			++self->index;
-			if (self->index == self->top_idx + self->height) {
-				++self->top_idx;
-				self->seek(self, +1, SEEK_CUR);
+			++browser->index;
+			if (browser->index == browser->top_idx + browser->height) {
+				++browser->top_idx;
+				browser->seek(browser, +1, SEEK_CUR);
 			}
 			break;
 		case K_UP:
-			if (self->index == 0)
+			if (browser->index == 0)
 				break;
-			--self->index;
-			if (self->index < self->top_idx) {
-				--self->top_idx;
-				self->seek(self, -1, SEEK_CUR);
+			--browser->index;
+			if (browser->index < browser->top_idx) {
+				--browser->top_idx;
+				browser->seek(browser, -1, SEEK_CUR);
 			}
 			break;
 		case K_PGDN:
 		case ' ':
-			if (self->top_idx + self->height > self->nr_entries - 1)
+			if (browser->top_idx + browser->height > browser->nr_entries - 1)
 				break;
 
-			offset = self->height;
-			if (self->index + offset > self->nr_entries - 1)
-				offset = self->nr_entries - 1 - self->index;
-			self->index += offset;
-			self->top_idx += offset;
-			self->seek(self, +offset, SEEK_CUR);
+			offset = browser->height;
+			if (browser->index + offset > browser->nr_entries - 1)
+				offset = browser->nr_entries - 1 - browser->index;
+			browser->index += offset;
+			browser->top_idx += offset;
+			browser->seek(browser, +offset, SEEK_CUR);
 			break;
 		case K_PGUP:
-			if (self->top_idx == 0)
+			if (browser->top_idx == 0)
 				break;
 
-			if (self->top_idx < self->height)
-				offset = self->top_idx;
+			if (browser->top_idx < browser->height)
+				offset = browser->top_idx;
 			else
-				offset = self->height;
+				offset = browser->height;
 
-			self->index -= offset;
-			self->top_idx -= offset;
-			self->seek(self, -offset, SEEK_CUR);
+			browser->index -= offset;
+			browser->top_idx -= offset;
+			browser->seek(browser, -offset, SEEK_CUR);
 			break;
 		case K_HOME:
-			ui_browser__reset_index(self);
+			ui_browser__reset_index(browser);
 			break;
 		case K_END:
-			offset = self->height - 1;
-			if (offset >= self->nr_entries)
-				offset = self->nr_entries - 1;
+			offset = browser->height - 1;
+			if (offset >= browser->nr_entries)
+				offset = browser->nr_entries - 1;
 
-			self->index = self->nr_entries - 1;
-			self->top_idx = self->index - offset;
-			self->seek(self, -offset, SEEK_END);
+			browser->index = browser->nr_entries - 1;
+			browser->top_idx = browser->index - offset;
+			browser->seek(browser, -offset, SEEK_END);
 			break;
 		default:
 			return key;
@@ -448,22 +448,22 @@ int ui_browser__run(struct ui_browser *self, int delay_secs)
 	return -1;
 }
 
-unsigned int ui_browser__list_head_refresh(struct ui_browser *self)
+unsigned int ui_browser__list_head_refresh(struct ui_browser *browser)
 {
 	struct list_head *pos;
-	struct list_head *head = self->entries;
+	struct list_head *head = browser->entries;
 	int row = 0;
 
-	if (self->top == NULL || self->top == self->entries)
-                self->top = ui_browser__list_head_filter_entries(self, head->next);
+	if (browser->top == NULL || browser->top == browser->entries)
+                browser->top = ui_browser__list_head_filter_entries(browser, head->next);
 
-	pos = self->top;
+	pos = browser->top;
 
 	list_for_each_from(pos, head) {
-		if (!self->filter || !self->filter(self, pos)) {
-			ui_browser__gotorc(self, row, 0);
-			self->write(self, pos, row);
-			if (++row == self->height)
+		if (!browser->filter || !browser->filter(browser, pos)) {
+			ui_browser__gotorc(browser, row, 0);
+			browser->write(browser, pos, row);
+			if (++row == browser->height)
 				break;
 		}
 	}
@@ -708,4 +708,6 @@ void ui_browser__init(void)
 		struct ui_browser__colorset *c = &ui_browser__colorsets[i++];
 		sltt_set_color(c->colorset, c->name, c->fg, c->bg);
 	}
+
+	annotate_browser__init();
 }
diff --git a/tools/perf/ui/browser.h b/tools/perf/ui/browser.h
index dd96d82..af70314 100644
--- a/tools/perf/ui/browser.h
+++ b/tools/perf/ui/browser.h
@@ -69,4 +69,5 @@ void ui_browser__list_head_seek(struct ui_browser *self, off_t offset, int whenc
 unsigned int ui_browser__list_head_refresh(struct ui_browser *self);
 
 void ui_browser__init(void);
+void annotate_browser__init(void);
 #endif /* _PERF_UI_BROWSER_H_ */
diff --git a/tools/perf/ui/browsers/annotate.c b/tools/perf/ui/browsers/annotate.c
index 6e0ef79..4deea6a 100644
--- a/tools/perf/ui/browsers/annotate.c
+++ b/tools/perf/ui/browsers/annotate.c
@@ -19,6 +19,16 @@ struct browser_disasm_line {
 	int		jump_sources;
 };
 
+static struct annotate_browser_opt {
+	bool hide_src_code,
+	     use_offset,
+	     jump_arrows,
+	     show_nr_jumps;
+} annotate_browser__opts = {
+	.use_offset	= true,
+	.jump_arrows	= true,
+};
+
 struct annotate_browser {
 	struct ui_browser b;
 	struct rb_root	  entries;
@@ -30,10 +40,6 @@ struct annotate_browser {
 	int		    nr_entries;
 	int		    max_jump_sources;
 	int		    nr_jumps;
-	bool		    hide_src_code;
-	bool		    use_offset;
-	bool		    jump_arrows;
-	bool		    show_nr_jumps;
 	bool		    searching_backwards;
 	u8		    addr_width;
 	u8		    jumps_width;
@@ -48,11 +54,9 @@ static inline struct browser_disasm_line *disasm_line__browser(struct disasm_lin
 	return (struct browser_disasm_line *)(dl + 1);
 }
 
-static bool disasm_line__filter(struct ui_browser *browser, void *entry)
+static bool disasm_line__filter(struct ui_browser *browser __used, void *entry)
 {
-	struct annotate_browser *ab = container_of(browser, struct annotate_browser, b);
-
-	if (ab->hide_src_code) {
+	if (annotate_browser__opts.hide_src_code) {
 		struct disasm_line *dl = list_entry(entry, struct disasm_line, node);
 		return dl->offset == -1;
 	}
@@ -79,30 +83,30 @@ static int annotate_browser__set_jumps_percent_color(struct annotate_browser *br
 	 return ui_browser__set_color(&browser->b, color);
 }
 
-static void annotate_browser__write(struct ui_browser *self, void *entry, int row)
+static void annotate_browser__write(struct ui_browser *browser, void *entry, int row)
 {
-	struct annotate_browser *ab = container_of(self, struct annotate_browser, b);
+	struct annotate_browser *ab = container_of(browser, struct annotate_browser, b);
 	struct disasm_line *dl = list_entry(entry, struct disasm_line, node);
 	struct browser_disasm_line *bdl = disasm_line__browser(dl);
-	bool current_entry = ui_browser__is_current_entry(self, row);
-	bool change_color = (!ab->hide_src_code &&
-			     (!current_entry || (self->use_navkeypressed &&
-					         !self->navkeypressed)));
-	int width = self->width, printed;
+	bool current_entry = ui_browser__is_current_entry(browser, row);
+	bool change_color = (!annotate_browser__opts.hide_src_code &&
+			     (!current_entry || (browser->use_navkeypressed &&
+					         !browser->navkeypressed)));
+	int width = browser->width, printed;
 	char bf[256];
 
 	if (dl->offset != -1 && bdl->percent != 0.0) {
-		ui_browser__set_percent_color(self, bdl->percent, current_entry);
+		ui_browser__set_percent_color(browser, bdl->percent, current_entry);
 		slsmg_printf("%6.2f ", bdl->percent);
 	} else {
-		ui_browser__set_percent_color(self, 0, current_entry);
+		ui_browser__set_percent_color(browser, 0, current_entry);
 		slsmg_write_nstring(" ", 7);
 	}
 
 	SLsmg_write_char(' ');
 
 	/* The scroll bar isn't being used */
-	if (!self->navkeypressed)
+	if (!browser->navkeypressed)
 		width += 1;
 
 	if (!*dl->line)
@@ -116,14 +120,14 @@ static void annotate_browser__write(struct ui_browser *self, void *entry, int ro
 		u64 addr = dl->offset;
 		int color = -1;
 
-		if (!ab->use_offset)
+		if (!annotate_browser__opts.use_offset)
 			addr += ab->start;
 
-		if (!ab->use_offset) {
+		if (!annotate_browser__opts.use_offset) {
 			printed = scnprintf(bf, sizeof(bf), "%" PRIx64 ": ", addr);
 		} else {
 			if (bdl->jump_sources) {
-				if (ab->show_nr_jumps) {
+				if (annotate_browser__opts.show_nr_jumps) {
 					int prev;
 					printed = scnprintf(bf, sizeof(bf), "%*d ",
 							    ab->jumps_width,
@@ -131,7 +135,7 @@ static void annotate_browser__write(struct ui_browser *self, void *entry, int ro
 					prev = annotate_browser__set_jumps_percent_color(ab, bdl->jump_sources,
 											 current_entry);
 					slsmg_write_nstring(bf, printed);
-					ui_browser__set_color(self, prev);
+					ui_browser__set_color(browser, prev);
 				}
 
 				printed = scnprintf(bf, sizeof(bf), "%*" PRIx64 ": ",
@@ -143,19 +147,19 @@ static void annotate_browser__write(struct ui_browser *self, void *entry, int ro
 		}
 
 		if (change_color)
-			color = ui_browser__set_color(self, HE_COLORSET_ADDR);
+			color = ui_browser__set_color(browser, HE_COLORSET_ADDR);
 		slsmg_write_nstring(bf, printed);
 		if (change_color)
-			ui_browser__set_color(self, color);
+			ui_browser__set_color(browser, color);
 		if (dl->ins && dl->ins->ops->scnprintf) {
 			if (ins__is_jump(dl->ins)) {
 				bool fwd = dl->ops.target.offset > (u64)dl->offset;
 
-				ui_browser__write_graph(self, fwd ? SLSMG_DARROW_CHAR :
+				ui_browser__write_graph(browser, fwd ? SLSMG_DARROW_CHAR :
 								    SLSMG_UARROW_CHAR);
 				SLsmg_write_char(' ');
 			} else if (ins__is_call(dl->ins)) {
-				ui_browser__write_graph(self, SLSMG_RARROW_CHAR);
+				ui_browser__write_graph(browser, SLSMG_RARROW_CHAR);
 				SLsmg_write_char(' ');
 			} else {
 				slsmg_write_nstring(" ", 2);
@@ -164,12 +168,12 @@ static void annotate_browser__write(struct ui_browser *self, void *entry, int ro
 			if (strcmp(dl->name, "retq")) {
 				slsmg_write_nstring(" ", 2);
 			} else {
-				ui_browser__write_graph(self, SLSMG_LARROW_CHAR);
+				ui_browser__write_graph(browser, SLSMG_LARROW_CHAR);
 				SLsmg_write_char(' ');
 			}
 		}
 
-		disasm_line__scnprintf(dl, bf, sizeof(bf), !ab->use_offset);
+		disasm_line__scnprintf(dl, bf, sizeof(bf), !annotate_browser__opts.use_offset);
 		slsmg_write_nstring(bf, width - 10 - printed);
 	}
 
@@ -184,7 +188,7 @@ static void annotate_browser__draw_current_jump(struct ui_browser *browser)
 	struct browser_disasm_line *btarget, *bcursor;
 	unsigned int from, to;
 
-	if (!cursor->ins || !ins__is_jump(cursor->ins) ||
+	if (!cursor || !cursor->ins || !ins__is_jump(cursor->ins) ||
 	    !disasm_line__has_offset(cursor))
 		return;
 
@@ -195,7 +199,7 @@ static void annotate_browser__draw_current_jump(struct ui_browser *browser)
 	bcursor = disasm_line__browser(cursor);
 	btarget = disasm_line__browser(target);
 
-	if (ab->hide_src_code) {
+	if (annotate_browser__opts.hide_src_code) {
 		from = bcursor->idx_asm;
 		to = btarget->idx_asm;
 	} else {
@@ -209,10 +213,9 @@ static void annotate_browser__draw_current_jump(struct ui_browser *browser)
 
 static unsigned int annotate_browser__refresh(struct ui_browser *browser)
 {
-	struct annotate_browser *ab = container_of(browser, struct annotate_browser, b);
 	int ret = ui_browser__list_head_refresh(browser);
 
-	if (ab->jump_arrows)
+	if (annotate_browser__opts.jump_arrows)
 		annotate_browser__draw_current_jump(browser);
 
 	ui_browser__set_color(browser, HE_COLORSET_NORMAL);
@@ -272,27 +275,27 @@ static void disasm_rb_tree__insert(struct rb_root *root, struct browser_disasm_l
 	rb_insert_color(&bdl->rb_node, root);
 }
 
-static void annotate_browser__set_top(struct annotate_browser *self,
+static void annotate_browser__set_top(struct annotate_browser *browser,
 				      struct disasm_line *pos, u32 idx)
 {
 	unsigned back;
 
-	ui_browser__refresh_dimensions(&self->b);
-	back = self->b.height / 2;
-	self->b.top_idx = self->b.index = idx;
+	ui_browser__refresh_dimensions(&browser->b);
+	back = browser->b.height / 2;
+	browser->b.top_idx = browser->b.index = idx;
 
-	while (self->b.top_idx != 0 && back != 0) {
+	while (browser->b.top_idx != 0 && back != 0) {
 		pos = list_entry(pos->node.prev, struct disasm_line, node);
 
-		if (disasm_line__filter(&self->b, &pos->node))
+		if (disasm_line__filter(&browser->b, &pos->node))
 			continue;
 
-		--self->b.top_idx;
+		--browser->b.top_idx;
 		--back;
 	}
 
-	self->b.top = pos;
-	self->b.navkeypressed = true;
+	browser->b.top = pos;
+	browser->b.navkeypressed = true;
 }
 
 static void annotate_browser__set_rb_top(struct annotate_browser *browser,
@@ -300,10 +303,14 @@ static void annotate_browser__set_rb_top(struct annotate_browser *browser,
 {
 	struct browser_disasm_line *bpos;
 	struct disasm_line *pos;
+	u32 idx;
 
 	bpos = rb_entry(nd, struct browser_disasm_line, rb_node);
 	pos = ((struct disasm_line *)bpos) - 1;
-	annotate_browser__set_top(browser, pos, bpos->idx);
+	idx = bpos->idx;
+	if (annotate_browser__opts.hide_src_code)
+		idx = bpos->idx_asm;
+	annotate_browser__set_top(browser, pos, idx);
 	browser->curr_hot = nd;
 }
 
@@ -343,12 +350,12 @@ static bool annotate_browser__toggle_source(struct annotate_browser *browser)
 	dl = list_entry(browser->b.top, struct disasm_line, node);
 	bdl = disasm_line__browser(dl);
 
-	if (browser->hide_src_code) {
+	if (annotate_browser__opts.hide_src_code) {
 		if (bdl->idx_asm < offset)
 			offset = bdl->idx;
 
 		browser->b.nr_entries = browser->nr_entries;
-		browser->hide_src_code = false;
+		annotate_browser__opts.hide_src_code = false;
 		browser->b.seek(&browser->b, -offset, SEEK_CUR);
 		browser->b.top_idx = bdl->idx - offset;
 		browser->b.index = bdl->idx;
@@ -363,7 +370,7 @@ static bool annotate_browser__toggle_source(struct annotate_browser *browser)
 			offset = bdl->idx_asm;
 
 		browser->b.nr_entries = browser->nr_asm_entries;
-		browser->hide_src_code = true;
+		annotate_browser__opts.hide_src_code = true;
 		browser->b.seek(&browser->b, -offset, SEEK_CUR);
 		browser->b.top_idx = bdl->idx_asm - offset;
 		browser->b.index = bdl->idx_asm;
@@ -372,6 +379,12 @@ static bool annotate_browser__toggle_source(struct annotate_browser *browser)
 	return true;
 }
 
+static void annotate_browser__init_asm_mode(struct annotate_browser *browser)
+{
+	ui_browser__reset_index(&browser->b);
+	browser->b.nr_entries = browser->nr_asm_entries;
+}
+
 static bool annotate_browser__callq(struct annotate_browser *browser,
 				    int evidx, void (*timer)(void *arg),
 				    void *arg, int delay_secs)
@@ -574,33 +587,46 @@ bool annotate_browser__continue_search_reverse(struct annotate_browser *browser,
 	return __annotate_browser__search_reverse(browser);
 }
 
-static int annotate_browser__run(struct annotate_browser *self, int evidx,
+static void annotate_browser__update_addr_width(struct annotate_browser *browser)
+{
+	if (annotate_browser__opts.use_offset)
+		browser->target_width = browser->min_addr_width;
+	else
+		browser->target_width = browser->max_addr_width;
+
+	browser->addr_width = browser->target_width;
+
+	if (annotate_browser__opts.show_nr_jumps)
+		browser->addr_width += browser->jumps_width + 1;
+}
+
+static int annotate_browser__run(struct annotate_browser *browser, int evidx,
 				 void(*timer)(void *arg),
 				 void *arg, int delay_secs)
 {
 	struct rb_node *nd = NULL;
-	struct map_symbol *ms = self->b.priv;
+	struct map_symbol *ms = browser->b.priv;
 	struct symbol *sym = ms->sym;
 	const char *help = "Press 'h' for help on key bindings";
 	int key;
 
-	if (ui_browser__show(&self->b, sym->name, help) < 0)
+	if (ui_browser__show(&browser->b, sym->name, help) < 0)
 		return -1;
 
-	annotate_browser__calc_percent(self, evidx);
+	annotate_browser__calc_percent(browser, evidx);
 
-	if (self->curr_hot) {
-		annotate_browser__set_rb_top(self, self->curr_hot);
-		self->b.navkeypressed = false;
+	if (browser->curr_hot) {
+		annotate_browser__set_rb_top(browser, browser->curr_hot);
+		browser->b.navkeypressed = false;
 	}
 
-	nd = self->curr_hot;
+	nd = browser->curr_hot;
 
 	while (1) {
-		key = ui_browser__run(&self->b, delay_secs);
+		key = ui_browser__run(&browser->b, delay_secs);
 
 		if (delay_secs != 0) {
-			annotate_browser__calc_percent(self, evidx);
+			annotate_browser__calc_percent(browser, evidx);
 			/*
 			 * Current line focus got out of the list of most active
 			 * lines, NULL it so that if TAB|UNTAB is pressed, we
@@ -622,21 +648,21 @@ static int annotate_browser__run(struct annotate_browser *self, int evidx,
 			if (nd != NULL) {
 				nd = rb_prev(nd);
 				if (nd == NULL)
-					nd = rb_last(&self->entries);
+					nd = rb_last(&browser->entries);
 			} else
-				nd = self->curr_hot;
+				nd = browser->curr_hot;
 			break;
 		case K_UNTAB:
 			if (nd != NULL)
 				nd = rb_next(nd);
 				if (nd == NULL)
-					nd = rb_first(&self->entries);
+					nd = rb_first(&browser->entries);
 			else
-				nd = self->curr_hot;
+				nd = browser->curr_hot;
 			break;
 		case K_F1:
 		case 'h':
-			ui_browser__help_window(&self->b,
+			ui_browser__help_window(&browser->b,
 		"UP/DOWN/PGUP\n"
 		"PGDN/SPACE    Navigate\n"
 		"q/ESC/CTRL+C  Exit\n\n"
@@ -652,57 +678,62 @@ static int annotate_browser__run(struct annotate_browser *self, int evidx,
 		"?             Search previous string\n");
 			continue;
 		case 'H':
-			nd = self->curr_hot;
+			nd = browser->curr_hot;
 			break;
 		case 's':
-			if (annotate_browser__toggle_source(self))
+			if (annotate_browser__toggle_source(browser))
 				ui_helpline__puts(help);
 			continue;
 		case 'o':
-			self->use_offset = !self->use_offset;
-			if (self->use_offset)
-				self->target_width = self->min_addr_width;
-			else
-				self->target_width = self->max_addr_width;
-update_addr_width:
-			self->addr_width = self->target_width;
-			if (self->show_nr_jumps)
-				self->addr_width += self->jumps_width + 1;
+			annotate_browser__opts.use_offset = !annotate_browser__opts.use_offset;
+			annotate_browser__update_addr_width(browser);
 			continue;
 		case 'j':
-			self->jump_arrows = !self->jump_arrows;
+			annotate_browser__opts.jump_arrows = !annotate_browser__opts.jump_arrows;
 			continue;
 		case 'J':
-			self->show_nr_jumps = !self->show_nr_jumps;
-			goto update_addr_width;
+			annotate_browser__opts.show_nr_jumps = !annotate_browser__opts.show_nr_jumps;
+			annotate_browser__update_addr_width(browser);
+			continue;
 		case '/':
-			if (annotate_browser__search(self, delay_secs)) {
+			if (annotate_browser__search(browser, delay_secs)) {
 show_help:
 				ui_helpline__puts(help);
 			}
 			continue;
 		case 'n':
-			if (self->searching_backwards ?
-			    annotate_browser__continue_search_reverse(self, delay_secs) :
-			    annotate_browser__continue_search(self, delay_secs))
+			if (browser->searching_backwards ?
+			    annotate_browser__continue_search_reverse(browser, delay_secs) :
+			    annotate_browser__continue_search(browser, delay_secs))
 				goto show_help;
 			continue;
 		case '?':
-			if (annotate_browser__search_reverse(self, delay_secs))
+			if (annotate_browser__search_reverse(browser, delay_secs))
 				goto show_help;
 			continue;
+		case 'D': {
+			static int seq;
+			ui_helpline__pop();
+			ui_helpline__fpush("%d: nr_ent=%d, height=%d, idx=%d, top_idx=%d, nr_asm_entries=%d",
+					   seq++, browser->b.nr_entries,
+					   browser->b.height,
+					   browser->b.index,
+					   browser->b.top_idx,
+					   browser->nr_asm_entries);
+		}
+			continue;
 		case K_ENTER:
 		case K_RIGHT:
-			if (self->selection == NULL)
+			if (browser->selection == NULL)
 				ui_helpline__puts("Huh? No selection. Report to linux-kernel@vger.kernel.org");
-			else if (self->selection->offset == -1)
+			else if (browser->selection->offset == -1)
 				ui_helpline__puts("Actions are only available for assembly lines.");
-			else if (!self->selection->ins) {
-				if (strcmp(self->selection->name, "retq"))
+			else if (!browser->selection->ins) {
+				if (strcmp(browser->selection->name, "retq"))
 					goto show_sup_ins;
 				goto out;
-			} else if (!(annotate_browser__jump(self) ||
-				     annotate_browser__callq(self, evidx, timer, arg, delay_secs))) {
+			} else if (!(annotate_browser__jump(browser) ||
+				     annotate_browser__callq(browser, evidx, timer, arg, delay_secs))) {
 show_sup_ins:
 				ui_helpline__puts("Actions are only available for 'callq', 'retq' & jump instructions.");
 			}
@@ -717,10 +748,10 @@ show_sup_ins:
 		}
 
 		if (nd != NULL)
-			annotate_browser__set_rb_top(self, nd);
+			annotate_browser__set_rb_top(browser, nd);
 	}
 out:
-	ui_browser__hide(&self->b);
+	ui_browser__hide(&browser->b);
 	return key;
 }
 
@@ -797,8 +828,6 @@ int symbol__tui_annotate(struct symbol *sym, struct map *map, int evidx,
 			.priv	 = &ms,
 			.use_navkeypressed = true,
 		},
-		.use_offset = true,
-		.jump_arrows = true,
 	};
 	int ret = -1;
 
@@ -855,6 +884,12 @@ int symbol__tui_annotate(struct symbol *sym, struct map *map, int evidx,
 	browser.b.nr_entries = browser.nr_entries;
 	browser.b.entries = &notes->src->source,
 	browser.b.width += 18; /* Percentage */
+
+	if (annotate_browser__opts.hide_src_code)
+		annotate_browser__init_asm_mode(&browser);
+
+	annotate_browser__update_addr_width(&browser);
+
 	ret = annotate_browser__run(&browser, evidx, timer, arg, delay_secs);
 	list_for_each_entry_safe(pos, n, &notes->src->source, node) {
 		list_del(&pos->node);
@@ -865,3 +900,52 @@ out_free_offsets:
 	free(browser.offsets);
 	return ret;
 }
+
+#define ANNOTATE_CFG(n) \
+	{ .name = #n, .value = &annotate_browser__opts.n, }
+	
+/*
+ * Keep the entries sorted, they are bsearch'ed
+ */
+static struct annotate__config {
+	const char *name;
+	bool *value;
+} annotate__configs[] = {
+	ANNOTATE_CFG(hide_src_code),
+	ANNOTATE_CFG(jump_arrows),
+	ANNOTATE_CFG(show_nr_jumps),
+	ANNOTATE_CFG(use_offset),
+};
+
+#undef ANNOTATE_CFG
+
+static int annotate_config__cmp(const void *name, const void *cfgp)
+{
+	const struct annotate__config *cfg = cfgp;
+
+	return strcmp(name, cfg->name);
+}
+
+static int annotate__config(const char *var, const char *value, void *data __used)
+{
+	struct annotate__config *cfg;
+	const char *name;
+
+	if (prefixcmp(var, "annotate.") != 0)
+		return 0;
+
+	name = var + 9;
+	cfg = bsearch(name, annotate__configs, ARRAY_SIZE(annotate__configs),
+		      sizeof(struct annotate__config), annotate_config__cmp);
+
+	if (cfg == NULL)
+		return -1;
+
+	*cfg->value = perf_config_bool(name, value);
+	return 0;
+}
+
+void annotate_browser__init(void)
+{
+	perf_config(annotate__config, NULL);
+}
diff --git a/tools/perf/ui/browsers/hists.c b/tools/perf/ui/browsers/hists.c
index a372a4b..53f6697 100644
--- a/tools/perf/ui/browsers/hists.c
+++ b/tools/perf/ui/browsers/hists.c
@@ -26,21 +26,21 @@ struct hist_browser {
 	bool		     has_symbols;
 };
 
-static int hists__browser_title(struct hists *self, char *bf, size_t size,
+static int hists__browser_title(struct hists *hists, char *bf, size_t size,
 				const char *ev_name);
 
-static void hist_browser__refresh_dimensions(struct hist_browser *self)
+static void hist_browser__refresh_dimensions(struct hist_browser *browser)
 {
 	/* 3 == +/- toggle symbol before actual hist_entry rendering */
-	self->b.width = 3 + (hists__sort_list_width(self->hists) +
+	browser->b.width = 3 + (hists__sort_list_width(browser->hists) +
 			     sizeof("[k]"));
 }
 
-static void hist_browser__reset(struct hist_browser *self)
+static void hist_browser__reset(struct hist_browser *browser)
 {
-	self->b.nr_entries = self->hists->nr_entries;
-	hist_browser__refresh_dimensions(self);
-	ui_browser__reset_index(&self->b);
+	browser->b.nr_entries = browser->hists->nr_entries;
+	hist_browser__refresh_dimensions(browser);
+	ui_browser__reset_index(&browser->b);
 }
 
 static char tree__folded_sign(bool unfolded)
@@ -48,32 +48,32 @@ static char tree__folded_sign(bool unfolded)
 	return unfolded ? '-' : '+';
 }
 
-static char map_symbol__folded(const struct map_symbol *self)
+static char map_symbol__folded(const struct map_symbol *ms)
 {
-	return self->has_children ? tree__folded_sign(self->unfolded) : ' ';
+	return ms->has_children ? tree__folded_sign(ms->unfolded) : ' ';
 }
 
-static char hist_entry__folded(const struct hist_entry *self)
+static char hist_entry__folded(const struct hist_entry *he)
 {
-	return map_symbol__folded(&self->ms);
+	return map_symbol__folded(&he->ms);
 }
 
-static char callchain_list__folded(const struct callchain_list *self)
+static char callchain_list__folded(const struct callchain_list *cl)
 {
-	return map_symbol__folded(&self->ms);
+	return map_symbol__folded(&cl->ms);
 }
 
-static void map_symbol__set_folding(struct map_symbol *self, bool unfold)
+static void map_symbol__set_folding(struct map_symbol *ms, bool unfold)
 {
-	self->unfolded = unfold ? self->has_children : false;
+	ms->unfolded = unfold ? ms->has_children : false;
 }
 
-static int callchain_node__count_rows_rb_tree(struct callchain_node *self)
+static int callchain_node__count_rows_rb_tree(struct callchain_node *node)
 {
 	int n = 0;
 	struct rb_node *nd;
 
-	for (nd = rb_first(&self->rb_root); nd; nd = rb_next(nd)) {
+	for (nd = rb_first(&node->rb_root); nd; nd = rb_next(nd)) {
 		struct callchain_node *child = rb_entry(nd, struct callchain_node, rb_node);
 		struct callchain_list *chain;
 		char folded_sign = ' '; /* No children */
@@ -123,23 +123,23 @@ static int callchain__count_rows(struct rb_root *chain)
 	return n;
 }
 
-static bool map_symbol__toggle_fold(struct map_symbol *self)
+static bool map_symbol__toggle_fold(struct map_symbol *ms)
 {
-	if (!self)
+	if (!ms)
 		return false;
 
-	if (!self->has_children)
+	if (!ms->has_children)
 		return false;
 
-	self->unfolded = !self->unfolded;
+	ms->unfolded = !ms->unfolded;
 	return true;
 }
 
-static void callchain_node__init_have_children_rb_tree(struct callchain_node *self)
+static void callchain_node__init_have_children_rb_tree(struct callchain_node *node)
 {
-	struct rb_node *nd = rb_first(&self->rb_root);
+	struct rb_node *nd = rb_first(&node->rb_root);
 
-	for (nd = rb_first(&self->rb_root); nd; nd = rb_next(nd)) {
+	for (nd = rb_first(&node->rb_root); nd; nd = rb_next(nd)) {
 		struct callchain_node *child = rb_entry(nd, struct callchain_node, rb_node);
 		struct callchain_list *chain;
 		bool first = true;
@@ -158,49 +158,49 @@ static void callchain_node__init_have_children_rb_tree(struct callchain_node *se
 	}
 }
 
-static void callchain_node__init_have_children(struct callchain_node *self)
+static void callchain_node__init_have_children(struct callchain_node *node)
 {
 	struct callchain_list *chain;
 
-	list_for_each_entry(chain, &self->val, list)
-		chain->ms.has_children = !RB_EMPTY_ROOT(&self->rb_root);
+	list_for_each_entry(chain, &node->val, list)
+		chain->ms.has_children = !RB_EMPTY_ROOT(&node->rb_root);
 
-	callchain_node__init_have_children_rb_tree(self);
+	callchain_node__init_have_children_rb_tree(node);
 }
 
-static void callchain__init_have_children(struct rb_root *self)
+static void callchain__init_have_children(struct rb_root *root)
 {
 	struct rb_node *nd;
 
-	for (nd = rb_first(self); nd; nd = rb_next(nd)) {
+	for (nd = rb_first(root); nd; nd = rb_next(nd)) {
 		struct callchain_node *node = rb_entry(nd, struct callchain_node, rb_node);
 		callchain_node__init_have_children(node);
 	}
 }
 
-static void hist_entry__init_have_children(struct hist_entry *self)
+static void hist_entry__init_have_children(struct hist_entry *he)
 {
-	if (!self->init_have_children) {
-		self->ms.has_children = !RB_EMPTY_ROOT(&self->sorted_chain);
-		callchain__init_have_children(&self->sorted_chain);
-		self->init_have_children = true;
+	if (!he->init_have_children) {
+		he->ms.has_children = !RB_EMPTY_ROOT(&he->sorted_chain);
+		callchain__init_have_children(&he->sorted_chain);
+		he->init_have_children = true;
 	}
 }
 
-static bool hist_browser__toggle_fold(struct hist_browser *self)
+static bool hist_browser__toggle_fold(struct hist_browser *browser)
 {
-	if (map_symbol__toggle_fold(self->selection)) {
-		struct hist_entry *he = self->he_selection;
+	if (map_symbol__toggle_fold(browser->selection)) {
+		struct hist_entry *he = browser->he_selection;
 
 		hist_entry__init_have_children(he);
-		self->hists->nr_entries -= he->nr_rows;
+		browser->hists->nr_entries -= he->nr_rows;
 
 		if (he->ms.unfolded)
 			he->nr_rows = callchain__count_rows(&he->sorted_chain);
 		else
 			he->nr_rows = 0;
-		self->hists->nr_entries += he->nr_rows;
-		self->b.nr_entries = self->hists->nr_entries;
+		browser->hists->nr_entries += he->nr_rows;
+		browser->b.nr_entries = browser->hists->nr_entries;
 
 		return true;
 	}
@@ -209,12 +209,12 @@ static bool hist_browser__toggle_fold(struct hist_browser *self)
 	return false;
 }
 
-static int callchain_node__set_folding_rb_tree(struct callchain_node *self, bool unfold)
+static int callchain_node__set_folding_rb_tree(struct callchain_node *node, bool unfold)
 {
 	int n = 0;
 	struct rb_node *nd;
 
-	for (nd = rb_first(&self->rb_root); nd; nd = rb_next(nd)) {
+	for (nd = rb_first(&node->rb_root); nd; nd = rb_next(nd)) {
 		struct callchain_node *child = rb_entry(nd, struct callchain_node, rb_node);
 		struct callchain_list *chain;
 		bool has_children = false;
@@ -263,37 +263,37 @@ static int callchain__set_folding(struct rb_root *chain, bool unfold)
 	return n;
 }
 
-static void hist_entry__set_folding(struct hist_entry *self, bool unfold)
+static void hist_entry__set_folding(struct hist_entry *he, bool unfold)
 {
-	hist_entry__init_have_children(self);
-	map_symbol__set_folding(&self->ms, unfold);
+	hist_entry__init_have_children(he);
+	map_symbol__set_folding(&he->ms, unfold);
 
-	if (self->ms.has_children) {
-		int n = callchain__set_folding(&self->sorted_chain, unfold);
-		self->nr_rows = unfold ? n : 0;
+	if (he->ms.has_children) {
+		int n = callchain__set_folding(&he->sorted_chain, unfold);
+		he->nr_rows = unfold ? n : 0;
 	} else
-		self->nr_rows = 0;
+		he->nr_rows = 0;
 }
 
-static void hists__set_folding(struct hists *self, bool unfold)
+static void hists__set_folding(struct hists *hists, bool unfold)
 {
 	struct rb_node *nd;
 
-	self->nr_entries = 0;
+	hists->nr_entries = 0;
 
-	for (nd = rb_first(&self->entries); nd; nd = rb_next(nd)) {
+	for (nd = rb_first(&hists->entries); nd; nd = rb_next(nd)) {
 		struct hist_entry *he = rb_entry(nd, struct hist_entry, rb_node);
 		hist_entry__set_folding(he, unfold);
-		self->nr_entries += 1 + he->nr_rows;
+		hists->nr_entries += 1 + he->nr_rows;
 	}
 }
 
-static void hist_browser__set_folding(struct hist_browser *self, bool unfold)
+static void hist_browser__set_folding(struct hist_browser *browser, bool unfold)
 {
-	hists__set_folding(self->hists, unfold);
-	self->b.nr_entries = self->hists->nr_entries;
+	hists__set_folding(browser->hists, unfold);
+	browser->b.nr_entries = browser->hists->nr_entries;
 	/* Go to the start, we may be way after valid entries after a collapse */
-	ui_browser__reset_index(&self->b);
+	ui_browser__reset_index(&browser->b);
 }
 
 static void ui_browser__warn_lost_events(struct ui_browser *browser)
@@ -305,64 +305,64 @@ static void ui_browser__warn_lost_events(struct ui_browser *browser)
 		"Or reduce the sampling frequency.");
 }
 
-static int hist_browser__run(struct hist_browser *self, const char *ev_name,
+static int hist_browser__run(struct hist_browser *browser, const char *ev_name,
 			     void(*timer)(void *arg), void *arg, int delay_secs)
 {
 	int key;
 	char title[160];
 
-	self->b.entries = &self->hists->entries;
-	self->b.nr_entries = self->hists->nr_entries;
+	browser->b.entries = &browser->hists->entries;
+	browser->b.nr_entries = browser->hists->nr_entries;
 
-	hist_browser__refresh_dimensions(self);
-	hists__browser_title(self->hists, title, sizeof(title), ev_name);
+	hist_browser__refresh_dimensions(browser);
+	hists__browser_title(browser->hists, title, sizeof(title), ev_name);
 
-	if (ui_browser__show(&self->b, title,
+	if (ui_browser__show(&browser->b, title,
 			     "Press '?' for help on key bindings") < 0)
 		return -1;
 
 	while (1) {
-		key = ui_browser__run(&self->b, delay_secs);
+		key = ui_browser__run(&browser->b, delay_secs);
 
 		switch (key) {
 		case K_TIMER:
 			timer(arg);
-			ui_browser__update_nr_entries(&self->b, self->hists->nr_entries);
+			ui_browser__update_nr_entries(&browser->b, browser->hists->nr_entries);
 
-			if (self->hists->stats.nr_lost_warned !=
-			    self->hists->stats.nr_events[PERF_RECORD_LOST]) {
-				self->hists->stats.nr_lost_warned =
-					self->hists->stats.nr_events[PERF_RECORD_LOST];
-				ui_browser__warn_lost_events(&self->b);
+			if (browser->hists->stats.nr_lost_warned !=
+			    browser->hists->stats.nr_events[PERF_RECORD_LOST]) {
+				browser->hists->stats.nr_lost_warned =
+					browser->hists->stats.nr_events[PERF_RECORD_LOST];
+				ui_browser__warn_lost_events(&browser->b);
 			}
 
-			hists__browser_title(self->hists, title, sizeof(title), ev_name);
-			ui_browser__show_title(&self->b, title);
+			hists__browser_title(browser->hists, title, sizeof(title), ev_name);
+			ui_browser__show_title(&browser->b, title);
 			continue;
 		case 'D': { /* Debug */
 			static int seq;
-			struct hist_entry *h = rb_entry(self->b.top,
+			struct hist_entry *h = rb_entry(browser->b.top,
 							struct hist_entry, rb_node);
 			ui_helpline__pop();
 			ui_helpline__fpush("%d: nr_ent=(%d,%d), height=%d, idx=%d, fve: idx=%d, row_off=%d, nrows=%d",
-					   seq++, self->b.nr_entries,
-					   self->hists->nr_entries,
-					   self->b.height,
-					   self->b.index,
-					   self->b.top_idx,
+					   seq++, browser->b.nr_entries,
+					   browser->hists->nr_entries,
+					   browser->b.height,
+					   browser->b.index,
+					   browser->b.top_idx,
 					   h->row_offset, h->nr_rows);
 		}
 			break;
 		case 'C':
 			/* Collapse the whole world. */
-			hist_browser__set_folding(self, false);
+			hist_browser__set_folding(browser, false);
 			break;
 		case 'E':
 			/* Expand the whole world. */
-			hist_browser__set_folding(self, true);
+			hist_browser__set_folding(browser, true);
 			break;
 		case K_ENTER:
-			if (hist_browser__toggle_fold(self))
+			if (hist_browser__toggle_fold(browser))
 				break;
 			/* fall thru */
 		default:
@@ -370,23 +370,23 @@ static int hist_browser__run(struct hist_browser *self, const char *ev_name,
 		}
 	}
 out:
-	ui_browser__hide(&self->b);
+	ui_browser__hide(&browser->b);
 	return key;
 }
 
-static char *callchain_list__sym_name(struct callchain_list *self,
+static char *callchain_list__sym_name(struct callchain_list *cl,
 				      char *bf, size_t bfsize)
 {
-	if (self->ms.sym)
-		return self->ms.sym->name;
+	if (cl->ms.sym)
+		return cl->ms.sym->name;
 
-	snprintf(bf, bfsize, "%#" PRIx64, self->ip);
+	snprintf(bf, bfsize, "%#" PRIx64, cl->ip);
 	return bf;
 }
 
 #define LEVEL_OFFSET_STEP 3
 
-static int hist_browser__show_callchain_node_rb_tree(struct hist_browser *self,
+static int hist_browser__show_callchain_node_rb_tree(struct hist_browser *browser,
 						     struct callchain_node *chain_node,
 						     u64 total, int level,
 						     unsigned short row,
@@ -444,21 +444,21 @@ static int hist_browser__show_callchain_node_rb_tree(struct hist_browser *self,
 			}
 
 			color = HE_COLORSET_NORMAL;
-			width = self->b.width - (offset + extra_offset + 2);
-			if (ui_browser__is_current_entry(&self->b, row)) {
-				self->selection = &chain->ms;
+			width = browser->b.width - (offset + extra_offset + 2);
+			if (ui_browser__is_current_entry(&browser->b, row)) {
+				browser->selection = &chain->ms;
 				color = HE_COLORSET_SELECTED;
 				*is_current_entry = true;
 			}
 
-			ui_browser__set_color(&self->b, color);
-			ui_browser__gotorc(&self->b, row, 0);
+			ui_browser__set_color(&browser->b, color);
+			ui_browser__gotorc(&browser->b, row, 0);
 			slsmg_write_nstring(" ", offset + extra_offset);
 			slsmg_printf("%c ", folded_sign);
 			slsmg_write_nstring(str, width);
 			free(alloc_str);
 
-			if (++row == self->b.height)
+			if (++row == browser->b.height)
 				goto out;
 do_next:
 			if (folded_sign == '+')
@@ -467,11 +467,11 @@ do_next:
 
 		if (folded_sign == '-') {
 			const int new_level = level + (extra_offset ? 2 : 1);
-			row += hist_browser__show_callchain_node_rb_tree(self, child, new_total,
+			row += hist_browser__show_callchain_node_rb_tree(browser, child, new_total,
 									 new_level, row, row_offset,
 									 is_current_entry);
 		}
-		if (row == self->b.height)
+		if (row == browser->b.height)
 			goto out;
 		node = next;
 	}
@@ -479,7 +479,7 @@ out:
 	return row - first_row;
 }
 
-static int hist_browser__show_callchain_node(struct hist_browser *self,
+static int hist_browser__show_callchain_node(struct hist_browser *browser,
 					     struct callchain_node *node,
 					     int level, unsigned short row,
 					     off_t *row_offset,
@@ -488,7 +488,7 @@ static int hist_browser__show_callchain_node(struct hist_browser *self,
 	struct callchain_list *chain;
 	int first_row = row,
 	     offset = level * LEVEL_OFFSET_STEP,
-	     width = self->b.width - offset;
+	     width = browser->b.width - offset;
 	char folded_sign = ' ';
 
 	list_for_each_entry(chain, &node->val, list) {
@@ -503,26 +503,26 @@ static int hist_browser__show_callchain_node(struct hist_browser *self,
 		}
 
 		color = HE_COLORSET_NORMAL;
-		if (ui_browser__is_current_entry(&self->b, row)) {
-			self->selection = &chain->ms;
+		if (ui_browser__is_current_entry(&browser->b, row)) {
+			browser->selection = &chain->ms;
 			color = HE_COLORSET_SELECTED;
 			*is_current_entry = true;
 		}
 
 		s = callchain_list__sym_name(chain, ipstr, sizeof(ipstr));
-		ui_browser__gotorc(&self->b, row, 0);
-		ui_browser__set_color(&self->b, color);
+		ui_browser__gotorc(&browser->b, row, 0);
+		ui_browser__set_color(&browser->b, color);
 		slsmg_write_nstring(" ", offset);
 		slsmg_printf("%c ", folded_sign);
 		slsmg_write_nstring(s, width - 2);
 
-		if (++row == self->b.height)
+		if (++row == browser->b.height)
 			goto out;
 	}
 
 	if (folded_sign == '-')
-		row += hist_browser__show_callchain_node_rb_tree(self, node,
-								 self->hists->stats.total_period,
+		row += hist_browser__show_callchain_node_rb_tree(browser, node,
+								 browser->hists->stats.total_period,
 								 level + 1, row,
 								 row_offset,
 								 is_current_entry);
@@ -530,7 +530,7 @@ out:
 	return row - first_row;
 }
 
-static int hist_browser__show_callchain(struct hist_browser *self,
+static int hist_browser__show_callchain(struct hist_browser *browser,
 					struct rb_root *chain,
 					int level, unsigned short row,
 					off_t *row_offset,
@@ -542,31 +542,31 @@ static int hist_browser__show_callchain(struct hist_browser *self,
 	for (nd = rb_first(chain); nd; nd = rb_next(nd)) {
 		struct callchain_node *node = rb_entry(nd, struct callchain_node, rb_node);
 
-		row += hist_browser__show_callchain_node(self, node, level,
+		row += hist_browser__show_callchain_node(browser, node, level,
 							 row, row_offset,
 							 is_current_entry);
-		if (row == self->b.height)
+		if (row == browser->b.height)
 			break;
 	}
 
 	return row - first_row;
 }
 
-static int hist_browser__show_entry(struct hist_browser *self,
+static int hist_browser__show_entry(struct hist_browser *browser,
 				    struct hist_entry *entry,
 				    unsigned short row)
 {
 	char s[256];
 	double percent;
 	int printed = 0;
-	int width = self->b.width - 6; /* The percentage */
+	int width = browser->b.width - 6; /* The percentage */
 	char folded_sign = ' ';
-	bool current_entry = ui_browser__is_current_entry(&self->b, row);
+	bool current_entry = ui_browser__is_current_entry(&browser->b, row);
 	off_t row_offset = entry->row_offset;
 
 	if (current_entry) {
-		self->he_selection = entry;
-		self->selection = &entry->ms;
+		browser->he_selection = entry;
+		browser->selection = &entry->ms;
 	}
 
 	if (symbol_conf.use_callchain) {
@@ -575,11 +575,11 @@ static int hist_browser__show_entry(struct hist_browser *self,
 	}
 
 	if (row_offset == 0) {
-		hist_entry__snprintf(entry, s, sizeof(s), self->hists);
-		percent = (entry->period * 100.0) / self->hists->stats.total_period;
+		hist_entry__snprintf(entry, s, sizeof(s), browser->hists);
+		percent = (entry->period * 100.0) / browser->hists->stats.total_period;
 
-		ui_browser__set_percent_color(&self->b, percent, current_entry);
-		ui_browser__gotorc(&self->b, row, 0);
+		ui_browser__set_percent_color(&browser->b, percent, current_entry);
+		ui_browser__gotorc(&browser->b, row, 0);
 		if (symbol_conf.use_callchain) {
 			slsmg_printf("%c ", folded_sign);
 			width -= 2;
@@ -588,11 +588,11 @@ static int hist_browser__show_entry(struct hist_browser *self,
 		slsmg_printf(" %5.2f%%", percent);
 
 		/* The scroll bar isn't being used */
-		if (!self->b.navkeypressed)
+		if (!browser->b.navkeypressed)
 			width += 1;
 
-		if (!current_entry || !self->b.navkeypressed)
-			ui_browser__set_color(&self->b, HE_COLORSET_NORMAL);
+		if (!current_entry || !browser->b.navkeypressed)
+			ui_browser__set_color(&browser->b, HE_COLORSET_NORMAL);
 
 		if (symbol_conf.show_nr_samples) {
 			slsmg_printf(" %11u", entry->nr_events);
@@ -610,12 +610,12 @@ static int hist_browser__show_entry(struct hist_browser *self,
 	} else
 		--row_offset;
 
-	if (folded_sign == '-' && row != self->b.height) {
-		printed += hist_browser__show_callchain(self, &entry->sorted_chain,
+	if (folded_sign == '-' && row != browser->b.height) {
+		printed += hist_browser__show_callchain(browser, &entry->sorted_chain,
 							1, row, &row_offset,
 							&current_entry);
 		if (current_entry)
-			self->he_selection = entry;
+			browser->he_selection = entry;
 	}
 
 	return printed;
@@ -631,22 +631,22 @@ static void ui_browser__hists_init_top(struct ui_browser *browser)
 	}
 }
 
-static unsigned int hist_browser__refresh(struct ui_browser *self)
+static unsigned int hist_browser__refresh(struct ui_browser *browser)
 {
 	unsigned row = 0;
 	struct rb_node *nd;
-	struct hist_browser *hb = container_of(self, struct hist_browser, b);
+	struct hist_browser *hb = container_of(browser, struct hist_browser, b);
 
-	ui_browser__hists_init_top(self);
+	ui_browser__hists_init_top(browser);
 
-	for (nd = self->top; nd; nd = rb_next(nd)) {
+	for (nd = browser->top; nd; nd = rb_next(nd)) {
 		struct hist_entry *h = rb_entry(nd, struct hist_entry, rb_node);
 
 		if (h->filtered)
 			continue;
 
 		row += hist_browser__show_entry(hb, h, row);
-		if (row == self->height)
+		if (row == browser->height)
 			break;
 	}
 
@@ -679,27 +679,27 @@ static struct rb_node *hists__filter_prev_entries(struct rb_node *nd)
 	return NULL;
 }
 
-static void ui_browser__hists_seek(struct ui_browser *self,
+static void ui_browser__hists_seek(struct ui_browser *browser,
 				   off_t offset, int whence)
 {
 	struct hist_entry *h;
 	struct rb_node *nd;
 	bool first = true;
 
-	if (self->nr_entries == 0)
+	if (browser->nr_entries == 0)
 		return;
 
-	ui_browser__hists_init_top(self);
+	ui_browser__hists_init_top(browser);
 
 	switch (whence) {
 	case SEEK_SET:
-		nd = hists__filter_entries(rb_first(self->entries));
+		nd = hists__filter_entries(rb_first(browser->entries));
 		break;
 	case SEEK_CUR:
-		nd = self->top;
+		nd = browser->top;
 		goto do_offset;
 	case SEEK_END:
-		nd = hists__filter_prev_entries(rb_last(self->entries));
+		nd = hists__filter_prev_entries(rb_last(browser->entries));
 		first = false;
 		break;
 	default:
@@ -710,7 +710,7 @@ static void ui_browser__hists_seek(struct ui_browser *self,
 	 * Moves not relative to the first visible entry invalidates its
 	 * row_offset:
 	 */
-	h = rb_entry(self->top, struct hist_entry, rb_node);
+	h = rb_entry(browser->top, struct hist_entry, rb_node);
 	h->row_offset = 0;
 
 	/*
@@ -738,7 +738,7 @@ do_offset:
 				} else {
 					h->row_offset += offset;
 					offset = 0;
-					self->top = nd;
+					browser->top = nd;
 					break;
 				}
 			}
@@ -746,7 +746,7 @@ do_offset:
 			if (nd == NULL)
 				break;
 			--offset;
-			self->top = nd;
+			browser->top = nd;
 		} while (offset != 0);
 	} else if (offset < 0) {
 		while (1) {
@@ -759,7 +759,7 @@ do_offset:
 					} else {
 						h->row_offset += offset;
 						offset = 0;
-						self->top = nd;
+						browser->top = nd;
 						break;
 					}
 				} else {
@@ -769,7 +769,7 @@ do_offset:
 					} else {
 						h->row_offset = h->nr_rows + offset;
 						offset = 0;
-						self->top = nd;
+						browser->top = nd;
 						break;
 					}
 				}
@@ -779,7 +779,7 @@ do_offset:
 			if (nd == NULL)
 				break;
 			++offset;
-			self->top = nd;
+			browser->top = nd;
 			if (offset == 0) {
 				/*
 				 * Last unfiltered hist_entry, check if it is
@@ -794,7 +794,7 @@ do_offset:
 			first = false;
 		}
 	} else {
-		self->top = nd;
+		browser->top = nd;
 		h = rb_entry(nd, struct hist_entry, rb_node);
 		h->row_offset = 0;
 	}
@@ -802,46 +802,46 @@ do_offset:
 
 static struct hist_browser *hist_browser__new(struct hists *hists)
 {
-	struct hist_browser *self = zalloc(sizeof(*self));
+	struct hist_browser *browser = zalloc(sizeof(*browser));
 
-	if (self) {
-		self->hists = hists;
-		self->b.refresh = hist_browser__refresh;
-		self->b.seek = ui_browser__hists_seek;
-		self->b.use_navkeypressed = true;
+	if (browser) {
+		browser->hists = hists;
+		browser->b.refresh = hist_browser__refresh;
+		browser->b.seek = ui_browser__hists_seek;
+		browser->b.use_navkeypressed = true;
 		if (sort__branch_mode == 1)
-			self->has_symbols = sort_sym_from.list.next != NULL;
+			browser->has_symbols = sort_sym_from.list.next != NULL;
 		else
-			self->has_symbols = sort_sym.list.next != NULL;
+			browser->has_symbols = sort_sym.list.next != NULL;
 	}
 
-	return self;
+	return browser;
 }
 
-static void hist_browser__delete(struct hist_browser *self)
+static void hist_browser__delete(struct hist_browser *browser)
 {
-	free(self);
+	free(browser);
 }
 
-static struct hist_entry *hist_browser__selected_entry(struct hist_browser *self)
+static struct hist_entry *hist_browser__selected_entry(struct hist_browser *browser)
 {
-	return self->he_selection;
+	return browser->he_selection;
 }
 
-static struct thread *hist_browser__selected_thread(struct hist_browser *self)
+static struct thread *hist_browser__selected_thread(struct hist_browser *browser)
 {
-	return self->he_selection->thread;
+	return browser->he_selection->thread;
 }
 
-static int hists__browser_title(struct hists *self, char *bf, size_t size,
+static int hists__browser_title(struct hists *hists, char *bf, size_t size,
 				const char *ev_name)
 {
 	char unit;
 	int printed;
-	const struct dso *dso = self->dso_filter;
-	const struct thread *thread = self->thread_filter;
-	unsigned long nr_samples = self->stats.nr_events[PERF_RECORD_SAMPLE];
-	u64 nr_events = self->stats.total_period;
+	const struct dso *dso = hists->dso_filter;
+	const struct thread *thread = hists->thread_filter;
+	unsigned long nr_samples = hists->stats.nr_events[PERF_RECORD_SAMPLE];
+	u64 nr_events = hists->stats.total_period;
 
 	nr_samples = convert_unit(nr_samples, &unit);
 	printed = scnprintf(bf, size,
@@ -849,9 +849,9 @@ static int hists__browser_title(struct hists *self, char *bf, size_t size,
 			   nr_samples, unit, ev_name, nr_events);
 
 
-	if (self->uid_filter_str)
+	if (hists->uid_filter_str)
 		printed += snprintf(bf + printed, size - printed,
-				    ", UID: %s", self->uid_filter_str);
+				    ", UID: %s", hists->uid_filter_str);
 	if (thread)
 		printed += scnprintf(bf + printed, size - printed,
 				    ", Thread: %s(%d)",
@@ -879,8 +879,8 @@ static int perf_evsel__hists_browse(struct perf_evsel *evsel, int nr_events,
 				    void(*timer)(void *arg), void *arg,
 				    int delay_secs)
 {
-	struct hists *self = &evsel->hists;
-	struct hist_browser *browser = hist_browser__new(self);
+	struct hists *hists = &evsel->hists;
+	struct hist_browser *browser = hist_browser__new(hists);
 	struct branch_info *bi;
 	struct pstack *fstack;
 	char *options[16];
@@ -946,8 +946,8 @@ static int perf_evsel__hists_browse(struct perf_evsel *evsel, int nr_events,
 					"Please enter the name of symbol you want to see",
 					buf, "ENTER: OK, ESC: Cancel",
 					delay_secs * 2) == K_ENTER) {
-				self->symbol_filter_str = *buf ? buf : NULL;
-				hists__filter_by_symbol(self);
+				hists->symbol_filter_str = *buf ? buf : NULL;
+				hists__filter_by_symbol(hists);
 				hist_browser__reset(browser);
 			}
 			continue;
@@ -1128,7 +1128,7 @@ zoom_out_dso:
 				sort_dso.elide = true;
 				pstack__push(fstack, &browser->hists->dso_filter);
 			}
-			hists__filter_by_dso(self);
+			hists__filter_by_dso(hists);
 			hist_browser__reset(browser);
 		} else if (choice == zoom_thread) {
 zoom_thread:
@@ -1146,7 +1146,7 @@ zoom_out_thread:
 				sort_thread.elide = true;
 				pstack__push(fstack, &browser->hists->thread_filter);
 			}
-			hists__filter_by_thread(self);
+			hists__filter_by_thread(hists);
 			hist_browser__reset(browser);
 		}
 	}
diff --git a/tools/perf/ui/setup.c b/tools/perf/ui/setup.c
index 9f5f888..791fb15 100644
--- a/tools/perf/ui/setup.c
+++ b/tools/perf/ui/setup.c
@@ -22,6 +22,7 @@ void setup_browser(bool fallback_to_pager)
 			break;
 		/* fall through */
 	default:
+		use_browser = 0;
 		if (fallback_to_pager)
 			setup_pager();
 		break;
diff --git a/tools/perf/util/config.c b/tools/perf/util/config.c
index 0deac6a..6faa3a1 100644
--- a/tools/perf/util/config.c
+++ b/tools/perf/util/config.c
@@ -120,7 +120,7 @@ static char *parse_value(void)
 
 static inline int iskeychar(int c)
 {
-	return isalnum(c) || c == '-';
+	return isalnum(c) || c == '-' || c == '_';
 }
 
 static int get_value(config_fn_t fn, void *data, char *name, unsigned int len)
diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
index 57e4ce5..91d1913 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -15,6 +15,7 @@
 #include "cpumap.h"
 #include "thread_map.h"
 #include "target.h"
+#include "../../include/linux/perf_event.h"
 
 #define FD(e, x, y) (*(int *)xyarray__entry(e->fd, x, y))
 #define GROUP_FD(group_fd, cpu) (*(int *)xyarray__entry(group_fd, cpu, 0))
@@ -64,6 +65,95 @@ struct perf_evsel *perf_evsel__new(struct perf_event_attr *attr, int idx)
 	return evsel;
 }
 
+static const char *perf_evsel__hw_names[PERF_COUNT_HW_MAX] = {
+	"cycles",
+	"instructions",
+	"cache-references",
+	"cache-misses",
+	"branches",
+	"branch-misses",
+	"bus-cycles",
+	"stalled-cycles-frontend",
+	"stalled-cycles-backend",
+	"ref-cycles",
+};
+
+const char *__perf_evsel__hw_name(u64 config)
+{
+	if (config < PERF_COUNT_HW_MAX && perf_evsel__hw_names[config])
+		return perf_evsel__hw_names[config];
+
+	return "unknown-hardware";
+}
+
+static int perf_evsel__hw_name(struct perf_evsel *evsel, char *bf, size_t size)
+{
+	int colon = 0;
+	struct perf_event_attr *attr = &evsel->attr;
+	int r = scnprintf(bf, size, "%s", __perf_evsel__hw_name(attr->config));
+	bool exclude_guest_default = false;
+
+#define MOD_PRINT(context, mod)	do {					\
+		if (!attr->exclude_##context) {				\
+			if (!colon) colon = r++;			\
+			r += scnprintf(bf + r, size - r, "%c", mod);	\
+		} } while(0)
+
+	if (attr->exclude_kernel || attr->exclude_user || attr->exclude_hv) {
+		MOD_PRINT(kernel, 'k');
+		MOD_PRINT(user, 'u');
+		MOD_PRINT(hv, 'h');
+		exclude_guest_default = true;
+	}
+
+	if (attr->precise_ip) {
+		if (!colon)
+			colon = r++;
+		r += scnprintf(bf + r, size - r, "%.*s", attr->precise_ip, "ppp");
+		exclude_guest_default = true;
+	}
+
+	if (attr->exclude_host || attr->exclude_guest == exclude_guest_default) {
+		MOD_PRINT(host, 'H');
+		MOD_PRINT(guest, 'G');
+	}
+#undef MOD_PRINT
+	if (colon)
+		bf[colon] = ':';
+	return r;
+}
+
+int perf_evsel__name(struct perf_evsel *evsel, char *bf, size_t size)
+{
+	int ret;
+
+	switch (evsel->attr.type) {
+	case PERF_TYPE_RAW:
+		ret = scnprintf(bf, size, "raw 0x%" PRIx64, evsel->attr.config);
+		break;
+
+	case PERF_TYPE_HARDWARE:
+		ret = perf_evsel__hw_name(evsel, bf, size);
+		break;
+	default:
+		/*
+		 * FIXME
+ 		 *
+		 * This is the minimal perf_evsel__name so that we can
+		 * reconstruct event names taking into account event modifiers.
+		 *
+		 * The old event_name uses it now for raw anr hw events, so that
+		 * we don't drag all the parsing stuff into the python binding.
+		 *
+		 * On the next devel cycle the rest of the event naming will be
+		 * brought here.
+ 		 */
+		return 0;
+	}
+
+	return ret;
+}
+
 void perf_evsel__config(struct perf_evsel *evsel, struct perf_record_opts *opts,
 			struct perf_evsel *first)
 {
diff --git a/tools/perf/util/evsel.h b/tools/perf/util/evsel.h
index 3d6b3e4..4ba8b56 100644
--- a/tools/perf/util/evsel.h
+++ b/tools/perf/util/evsel.h
@@ -83,6 +83,9 @@ void perf_evsel__config(struct perf_evsel *evsel,
 			struct perf_record_opts *opts,
 			struct perf_evsel *first);
 
+const char* __perf_evsel__hw_name(u64 config);
+int perf_evsel__name(struct perf_evsel *evsel, char *bf, size_t size);
+
 int perf_evsel__alloc_fd(struct perf_evsel *evsel, int ncpus, int nthreads);
 int perf_evsel__alloc_id(struct perf_evsel *evsel, int ncpus, int nthreads);
 int perf_evsel__alloc_counts(struct perf_evsel *evsel, int ncpus);
diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
index fac7d59..05dbc8b 100644
--- a/tools/perf/util/parse-events.c
+++ b/tools/perf/util/parse-events.c
@@ -62,19 +62,6 @@ static struct event_symbol event_symbols[] = {
 #define PERF_EVENT_TYPE(config)		__PERF_EVENT_FIELD(config, TYPE)
 #define PERF_EVENT_ID(config)		__PERF_EVENT_FIELD(config, EVENT)
 
-static const char *hw_event_names[PERF_COUNT_HW_MAX] = {
-	"cycles",
-	"instructions",
-	"cache-references",
-	"cache-misses",
-	"branches",
-	"branch-misses",
-	"bus-cycles",
-	"stalled-cycles-frontend",
-	"stalled-cycles-backend",
-	"ref-cycles",
-};
-
 static const char *sw_event_names[PERF_COUNT_SW_MAX] = {
 	"cpu-clock",
 	"task-clock",
@@ -300,6 +287,16 @@ const char *event_name(struct perf_evsel *evsel)
 	u64 config = evsel->attr.config;
 	int type = evsel->attr.type;
 
+	if (type == PERF_TYPE_RAW || type == PERF_TYPE_HARDWARE) {
+		/*
+ 		 * XXX minimal fix, see comment on perf_evsen__name, this static buffer
+ 		 * will go away together with event_name in the next devel cycle.
+ 		 */
+		static char bf[128];
+		perf_evsel__name(evsel, bf, sizeof(bf));
+		return bf;
+	}
+
 	if (evsel->name)
 		return evsel->name;
 
@@ -317,9 +314,7 @@ const char *__event_name(int type, u64 config)
 
 	switch (type) {
 	case PERF_TYPE_HARDWARE:
-		if (config < PERF_COUNT_HW_MAX && hw_event_names[config])
-			return hw_event_names[config];
-		return "unknown-hardware";
+		return __perf_evsel__hw_name(config);
 
 	case PERF_TYPE_HW_CACHE: {
 		u8 cache_type, cache_op, cache_result;
diff --git a/tools/perf/util/thread_map.c b/tools/perf/util/thread_map.c
index 84d9bd78..9b5f856 100644
--- a/tools/perf/util/thread_map.c
+++ b/tools/perf/util/thread_map.c
@@ -188,28 +188,27 @@ static struct thread_map *thread_map__new_by_pid_str(const char *pid_str)
 		nt = realloc(threads, (sizeof(*threads) +
 				       sizeof(pid_t) * total_tasks));
 		if (nt == NULL)
-			goto out_free_threads;
+			goto out_free_namelist;
 
 		threads = nt;
 
-		if (threads) {
-			for (i = 0; i < items; i++)
-				threads->map[j++] = atoi(namelist[i]->d_name);
-			threads->nr = total_tasks;
-		}
-
-		for (i = 0; i < items; i++)
+		for (i = 0; i < items; i++) {
+			threads->map[j++] = atoi(namelist[i]->d_name);
 			free(namelist[i]);
+		}
+		threads->nr = total_tasks;
 		free(namelist);
-
-		if (!threads)
-			break;
 	}
 
 out:
 	strlist__delete(slist);
 	return threads;
 
+out_free_namelist:
+	for (i = 0; i < items; i++)
+		free(namelist[i]);
+	free(namelist);
+
 out_free_threads:
 	free(threads);
 	threads = NULL;
