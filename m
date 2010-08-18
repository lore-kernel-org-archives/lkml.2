Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752052Ab0HRIPK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Aug 2010 04:15:10 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:59721 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751942Ab0HRIPC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Aug 2010 04:15:02 -0400
Date: Wed, 18 Aug 2010 10:14:37 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Steven Rostedt <rostedt@goodmis.org>,
        =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [GIT PULL] perf fixes
Message-ID: <20100818081437.GA13861@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Linus,

Please pull the latest perf-fixes-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git perf-fixes-for-linus

The trace_events.c seqfile conversion makes up for the bulk of the diffstat - 
this was needed for a fix.

 Thanks,

	Ingo

------------------>
Arnaldo Carvalho de Melo (1):
      perf annotate tui: Fix exit and RIGHT keys handling

Bernd Petrovitsch (1):
      perf tools: Fix build on POSIX shells

Huang Ying (1):
      tracing: Fix ring_buffer_read_page reading out of page boundary

Marcin Slusarz (1):
      tracing: Sanitize value returned from write(trace_marker, "...", len)

Mike Frysinger (1):
      tracing: Extend recordmcount to better support Blackfin mcount

Randy Dunlap (1):
      latencytop: Fix kconfig dependency warnings

Shaohua Li (1):
      tracing: Fix an unallocated memory access in function_graph

Steven Rostedt (1):
      tracing/events: Convert format output to seq_file


 kernel/trace/ring_buffer.c             |    3 +
 kernel/trace/trace.c                   |   11 ++-
 kernel/trace/trace_events.c            |  207 ++++++++++++++++++++++----------
 kernel/trace/trace_functions_graph.c   |   10 ++-
 lib/Kconfig.debug                      |    5 +-
 scripts/recordmcount.pl                |    7 +-
 tools/perf/Makefile                    |   16 ++-
 tools/perf/util/ui/browsers/annotate.c |    3 +-
 8 files changed, 185 insertions(+), 77 deletions(-)

diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index 3632ce8..19cccc3 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -3846,6 +3846,9 @@ int ring_buffer_read_page(struct ring_buffer *buffer,
 			rpos = reader->read;
 			pos += size;
 
+			if (rpos >= commit)
+				break;
+
 			event = rb_reader_event(cpu_buffer);
 			size = rb_event_length(event);
 		} while (len > size);
diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index ba14a22..9ec59f5 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -3463,6 +3463,7 @@ tracing_mark_write(struct file *filp, const char __user *ubuf,
 					size_t cnt, loff_t *fpos)
 {
 	char *buf;
+	size_t written;
 
 	if (tracing_disabled)
 		return -EINVAL;
@@ -3484,11 +3485,15 @@ tracing_mark_write(struct file *filp, const char __user *ubuf,
 	} else
 		buf[cnt] = '\0';
 
-	cnt = mark_printk("%s", buf);
+	written = mark_printk("%s", buf);
 	kfree(buf);
-	*fpos += cnt;
+	*fpos += written;
 
-	return cnt;
+	/* don't tell userspace we wrote more - it might confuse them */
+	if (written > cnt)
+		written = cnt;
+
+	return written;
 }
 
 static int tracing_clock_show(struct seq_file *m, void *v)
diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
index 09b4fa6..4c758f1 100644
--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -598,88 +598,165 @@ out:
 	return ret;
 }
 
-static void print_event_fields(struct trace_seq *s, struct list_head *head)
+enum {
+	FORMAT_HEADER		= 1,
+	FORMAT_PRINTFMT		= 2,
+};
+
+static void *f_next(struct seq_file *m, void *v, loff_t *pos)
 {
+	struct ftrace_event_call *call = m->private;
 	struct ftrace_event_field *field;
+	struct list_head *head;
 
-	list_for_each_entry_reverse(field, head, link) {
-		/*
-		 * Smartly shows the array type(except dynamic array).
-		 * Normal:
-		 *	field:TYPE VAR
-		 * If TYPE := TYPE[LEN], it is shown:
-		 *	field:TYPE VAR[LEN]
-		 */
-		const char *array_descriptor = strchr(field->type, '[');
+	(*pos)++;
 
-		if (!strncmp(field->type, "__data_loc", 10))
-			array_descriptor = NULL;
+	switch ((unsigned long)v) {
+	case FORMAT_HEADER:
+		head = &ftrace_common_fields;
 
-		if (!array_descriptor) {
-			trace_seq_printf(s, "\tfield:%s %s;\toffset:%u;"
-					"\tsize:%u;\tsigned:%d;\n",
-					field->type, field->name, field->offset,
-					field->size, !!field->is_signed);
-		} else {
-			trace_seq_printf(s, "\tfield:%.*s %s%s;\toffset:%u;"
-					"\tsize:%u;\tsigned:%d;\n",
-					(int)(array_descriptor - field->type),
-					field->type, field->name,
-					array_descriptor, field->offset,
-					field->size, !!field->is_signed);
-		}
+		if (unlikely(list_empty(head)))
+			return NULL;
+
+		field = list_entry(head->prev, struct ftrace_event_field, link);
+		return field;
+
+	case FORMAT_PRINTFMT:
+		/* all done */
+		return NULL;
+	}
+
+	head = trace_get_fields(call);
+
+	/*
+	 * To separate common fields from event fields, the
+	 * LSB is set on the first event field. Clear it in case.
+	 */
+	v = (void *)((unsigned long)v & ~1L);
+
+	field = v;
+	/*
+	 * If this is a common field, and at the end of the list, then
+	 * continue with main list.
+	 */
+	if (field->link.prev == &ftrace_common_fields) {
+		if (unlikely(list_empty(head)))
+			return NULL;
+		field = list_entry(head->prev, struct ftrace_event_field, link);
+		/* Set the LSB to notify f_show to print an extra newline */
+		field = (struct ftrace_event_field *)
+			((unsigned long)field | 1);
+		return field;
 	}
+
+	/* If we are done tell f_show to print the format */
+	if (field->link.prev == head)
+		return (void *)FORMAT_PRINTFMT;
+
+	field = list_entry(field->link.prev, struct ftrace_event_field, link);
+
+	return field;
 }
 
-static ssize_t
-event_format_read(struct file *filp, char __user *ubuf, size_t cnt,
-		  loff_t *ppos)
+static void *f_start(struct seq_file *m, loff_t *pos)
 {
-	struct ftrace_event_call *call = filp->private_data;
-	struct list_head *head;
-	struct trace_seq *s;
-	char *buf;
-	int r;
+	loff_t l = 0;
+	void *p;
 
-	if (*ppos)
+	/* Start by showing the header */
+	if (!*pos)
+		return (void *)FORMAT_HEADER;
+
+	p = (void *)FORMAT_HEADER;
+	do {
+		p = f_next(m, p, &l);
+	} while (p && l < *pos);
+
+	return p;
+}
+
+static int f_show(struct seq_file *m, void *v)
+{
+	struct ftrace_event_call *call = m->private;
+	struct ftrace_event_field *field;
+	const char *array_descriptor;
+
+	switch ((unsigned long)v) {
+	case FORMAT_HEADER:
+		seq_printf(m, "name: %s\n", call->name);
+		seq_printf(m, "ID: %d\n", call->event.type);
+		seq_printf(m, "format:\n");
 		return 0;
 
-	s = kmalloc(sizeof(*s), GFP_KERNEL);
-	if (!s)
-		return -ENOMEM;
+	case FORMAT_PRINTFMT:
+		seq_printf(m, "\nprint fmt: %s\n",
+			   call->print_fmt);
+		return 0;
+	}
 
-	trace_seq_init(s);
+	/*
+	 * To separate common fields from event fields, the
+	 * LSB is set on the first event field. Clear it and
+	 * print a newline if it is set.
+	 */
+	if ((unsigned long)v & 1) {
+		seq_putc(m, '\n');
+		v = (void *)((unsigned long)v & ~1L);
+	}
 
-	trace_seq_printf(s, "name: %s\n", call->name);
-	trace_seq_printf(s, "ID: %d\n", call->event.type);
-	trace_seq_printf(s, "format:\n");
+	field = v;
 
-	/* print common fields */
-	print_event_fields(s, &ftrace_common_fields);
+	/*
+	 * Smartly shows the array type(except dynamic array).
+	 * Normal:
+	 *	field:TYPE VAR
+	 * If TYPE := TYPE[LEN], it is shown:
+	 *	field:TYPE VAR[LEN]
+	 */
+	array_descriptor = strchr(field->type, '[');
 
-	trace_seq_putc(s, '\n');
+	if (!strncmp(field->type, "__data_loc", 10))
+		array_descriptor = NULL;
 
-	/* print event specific fields */
-	head = trace_get_fields(call);
-	print_event_fields(s, head);
+	if (!array_descriptor)
+		seq_printf(m, "\tfield:%s %s;\toffset:%u;\tsize:%u;\tsigned:%d;\n",
+			   field->type, field->name, field->offset,
+			   field->size, !!field->is_signed);
+	else
+		seq_printf(m, "\tfield:%.*s %s%s;\toffset:%u;\tsize:%u;\tsigned:%d;\n",
+			   (int)(array_descriptor - field->type),
+			   field->type, field->name,
+			   array_descriptor, field->offset,
+			   field->size, !!field->is_signed);
 
-	r = trace_seq_printf(s, "\nprint fmt: %s\n", call->print_fmt);
+	return 0;
+}
 
-	if (!r) {
-		/*
-		 * ug!  The format output is bigger than a PAGE!!
-		 */
-		buf = "FORMAT TOO BIG\n";
-		r = simple_read_from_buffer(ubuf, cnt, ppos,
-					      buf, strlen(buf));
-		goto out;
-	}
+static void f_stop(struct seq_file *m, void *p)
+{
+}
 
-	r = simple_read_from_buffer(ubuf, cnt, ppos,
-				    s->buffer, s->len);
- out:
-	kfree(s);
-	return r;
+static const struct seq_operations trace_format_seq_ops = {
+	.start		= f_start,
+	.next		= f_next,
+	.stop		= f_stop,
+	.show		= f_show,
+};
+
+static int trace_format_open(struct inode *inode, struct file *file)
+{
+	struct ftrace_event_call *call = inode->i_private;
+	struct seq_file *m;
+	int ret;
+
+	ret = seq_open(file, &trace_format_seq_ops);
+	if (ret < 0)
+		return ret;
+
+	m = file->private_data;
+	m->private = call;
+
+	return 0;
 }
 
 static ssize_t
@@ -877,8 +954,10 @@ static const struct file_operations ftrace_enable_fops = {
 };
 
 static const struct file_operations ftrace_event_format_fops = {
-	.open = tracing_open_generic,
-	.read = event_format_read,
+	.open = trace_format_open,
+	.read = seq_read,
+	.llseek = seq_lseek,
+	.release = seq_release,
 };
 
 static const struct file_operations ftrace_event_id_fops = {
diff --git a/kernel/trace/trace_functions_graph.c b/kernel/trace/trace_functions_graph.c
index 6bff236..6f23369 100644
--- a/kernel/trace/trace_functions_graph.c
+++ b/kernel/trace/trace_functions_graph.c
@@ -507,7 +507,15 @@ get_return_for_leaf(struct trace_iterator *iter,
 			 * if the output fails.
 			 */
 			data->ent = *curr;
-			data->ret = *next;
+			/*
+			 * If the next event is not a return type, then
+			 * we only care about what type it is. Otherwise we can
+			 * safely copy the entire event.
+			 */
+			if (next->ent.type == TRACE_GRAPH_RET)
+				data->ret = *next;
+			else
+				data->ret.ent.type = next->ent.type;
 		}
 	}
 
diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index 9e06b7f..1b4afd2 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -994,13 +994,16 @@ config FAULT_INJECTION_STACKTRACE_FILTER
 
 config LATENCYTOP
 	bool "Latency measuring infrastructure"
+	depends on HAVE_LATENCYTOP_SUPPORT
+	depends on DEBUG_KERNEL
+	depends on STACKTRACE_SUPPORT
+	depends on PROC_FS
 	select FRAME_POINTER if !MIPS && !PPC && !S390 && !MICROBLAZE
 	select KALLSYMS
 	select KALLSYMS_ALL
 	select STACKTRACE
 	select SCHEDSTATS
 	select SCHED_DEBUG
-	depends on HAVE_LATENCYTOP_SUPPORT
 	help
 	  Enable this option if you want to use the LatencyTOP tool
 	  to find out which userspace is blocking on what kernel operations.
diff --git a/scripts/recordmcount.pl b/scripts/recordmcount.pl
index 0171060..e67f054 100755
--- a/scripts/recordmcount.pl
+++ b/scripts/recordmcount.pl
@@ -159,6 +159,7 @@ my $section_regex;	# Find the start of a section
 my $function_regex;	# Find the name of a function
 			#    (return offset and func name)
 my $mcount_regex;	# Find the call site to mcount (return offset)
+my $mcount_adjust;	# Address adjustment to mcount offset
 my $alignment;		# The .align value to use for $mcount_section
 my $section_type;	# Section header plus possible alignment command
 my $can_use_local = 0; 	# If we can use local function references
@@ -213,6 +214,7 @@ $section_regex = "Disassembly of section\\s+(\\S+):";
 $function_regex = "^([0-9a-fA-F]+)\\s+<(.*?)>:";
 $mcount_regex = "^\\s*([0-9a-fA-F]+):.*\\smcount\$";
 $section_type = '@progbits';
+$mcount_adjust = 0;
 $type = ".long";
 
 if ($arch eq "x86_64") {
@@ -351,6 +353,9 @@ if ($arch eq "x86_64") {
 } elsif ($arch eq "microblaze") {
     # Microblaze calls '_mcount' instead of plain 'mcount'.
     $mcount_regex = "^\\s*([0-9a-fA-F]+):.*\\s_mcount\$";
+} elsif ($arch eq "blackfin") {
+    $mcount_regex = "^\\s*([0-9a-fA-F]+):.*\\s__mcount\$";
+    $mcount_adjust = -4;
 } else {
     die "Arch $arch is not supported with CONFIG_FTRACE_MCOUNT_RECORD";
 }
@@ -511,7 +516,7 @@ while (<IN>) {
     }
     # is this a call site to mcount? If so, record it to print later
     if ($text_found && /$mcount_regex/) {
-	push(@offsets, hex $1);
+	push(@offsets, (hex $1) + $mcount_adjust);
     }
 }
 
diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 41abb90..dcb9700 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -157,10 +157,6 @@ all::
 #
 # Define NO_DWARF if you do not want debug-info analysis feature at all.
 
-$(shell sh -c 'mkdir -p $(OUTPUT)scripts/{perl,python}/Perf-Trace-Util/' 2> /dev/null)
-$(shell sh -c 'mkdir -p $(OUTPUT)util/{ui/browsers,scripting-engines}/' 2> /dev/null)
-$(shell sh -c 'mkdir $(OUTPUT)bench' 2> /dev/null)
-
 $(OUTPUT)PERF-VERSION-FILE: .FORCE-PERF-VERSION-FILE
 	@$(SHELL_PATH) util/PERF-VERSION-GEN $(OUTPUT)
 -include $(OUTPUT)PERF-VERSION-FILE
@@ -186,8 +182,6 @@ ifeq ($(ARCH),x86_64)
         ARCH := x86
 endif
 
-$(shell sh -c 'mkdir -p $(OUTPUT)arch/$(ARCH)/util/' 2> /dev/null)
-
 # CFLAGS and LDFLAGS are for the users to override from the command line.
 
 #
@@ -268,6 +262,7 @@ export prefix bindir sharedir sysconfdir
 CC = $(CROSS_COMPILE)gcc
 AR = $(CROSS_COMPILE)ar
 RM = rm -f
+MKDIR = mkdir
 TAR = tar
 FIND = find
 INSTALL = install
@@ -838,6 +833,7 @@ ifndef V
 	QUIET_CC       = @echo '   ' CC $@;
 	QUIET_AR       = @echo '   ' AR $@;
 	QUIET_LINK     = @echo '   ' LINK $@;
+	QUIET_MKDIR    = @echo '   ' MKDIR $@;
 	QUIET_BUILT_IN = @echo '   ' BUILTIN $@;
 	QUIET_GEN      = @echo '   ' GEN $@;
 	QUIET_SUBDIR0  = +@subdir=
@@ -1012,6 +1008,14 @@ $(LIB_OBJS) $(BUILTIN_OBJS): $(LIB_H)
 $(patsubst perf-%$X,%.o,$(PROGRAMS)): $(LIB_H) $(wildcard */*.h)
 builtin-revert.o wt-status.o: wt-status.h
 
+# we compile into subdirectories. if the target directory is not the source directory, they might not exists. So
+# we depend the various files onto their directories.
+DIRECTORY_DEPS = $(LIB_OBJS) $(BUILTIN_OBJS) $(OUTPUT)PERF-VERSION-FILE $(OUTPUT)common-cmds.h
+$(DIRECTORY_DEPS): $(sort $(dir $(DIRECTORY_DEPS)))
+# In the second step, we make a rule to actually create these directories
+$(sort $(dir $(DIRECTORY_DEPS))):
+	$(QUIET_MKDIR)$(MKDIR) -p $@ 2>/dev/null
+
 $(LIB_FILE): $(LIB_OBJS)
 	$(QUIET_AR)$(RM) $@ && $(AR) rcs $@ $(LIB_OBJS)
 
diff --git a/tools/perf/util/ui/browsers/annotate.c b/tools/perf/util/ui/browsers/annotate.c
index 55ff792..a90273e 100644
--- a/tools/perf/util/ui/browsers/annotate.c
+++ b/tools/perf/util/ui/browsers/annotate.c
@@ -146,6 +146,7 @@ static int annotate_browser__run(struct annotate_browser *self,
 		return -1;
 
 	newtFormAddHotKey(self->b.form, NEWT_KEY_LEFT);
+	newtFormAddHotKey(self->b.form, NEWT_KEY_RIGHT);
 
 	nd = self->curr_hot;
 	if (nd) {
@@ -178,7 +179,7 @@ static int annotate_browser__run(struct annotate_browser *self,
 	}
 out:
 	ui_browser__hide(&self->b);
-	return 0;
+	return es->u.key;
 }
 
 int hist_entry__tui_annotate(struct hist_entry *self)
