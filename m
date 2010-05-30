Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753605Ab0E3T1w (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 May 2010 15:27:52 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:35274 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752611Ab0E3T1v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 May 2010 15:27:51 -0400
Date: Sun, 30 May 2010 21:27:30 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Paul Mackerras <paulus@samba.org>,
       Fr??d??ric Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] perf fixes
Message-ID: <20100530192730.GA3357@elte.hu>
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

 Thanks,

	Ingo

------------------>
Arnaldo Carvalho de Melo (3):
      perf tui: Reset use_browser if stdout is not a tty
      perf symbols: Add the build id cache to the vmlinux path
      perf tui: Fix last use_browser problem related to .perfconfig

Steven Rostedt (2):
      ring-buffer: Reset "real_end" when page is filled
      ring-buffer: Move zeroing out excess in page to ring buffer code


 kernel/trace/ring_buffer.c    |   19 +++++++++++++++++--
 kernel/trace/trace.c          |    6 ------
 tools/perf/builtin-annotate.c |    2 +-
 tools/perf/builtin-top.c      |    2 +-
 tools/perf/util/debug.c       |    2 +-
 tools/perf/util/newt.c        |    1 +
 tools/perf/util/symbol.c      |   27 +++++++++++++++++++++++----
 tools/perf/util/symbol.h      |    2 +-
 8 files changed, 45 insertions(+), 16 deletions(-)

diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index 7f6059c..1da7b6e 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -1768,6 +1768,14 @@ rb_reset_tail(struct ring_buffer_per_cpu *cpu_buffer,
 	 * must fill the old tail_page with padding.
 	 */
 	if (tail >= BUF_PAGE_SIZE) {
+		/*
+		 * If the page was filled, then we still need
+		 * to update the real_end. Reset it to zero
+		 * and the reader will ignore it.
+		 */
+		if (tail == BUF_PAGE_SIZE)
+			tail_page->real_end = 0;
+
 		local_sub(length, &tail_page->write);
 		return;
 	}
@@ -3894,12 +3902,12 @@ int ring_buffer_read_page(struct ring_buffer *buffer,
 	ret = read;
 
 	cpu_buffer->lost_events = 0;
+
+	commit = local_read(&bpage->commit);
 	/*
 	 * Set a flag in the commit field if we lost events
 	 */
 	if (missed_events) {
-		commit = local_read(&bpage->commit);
-
 		/* If there is room at the end of the page to save the
 		 * missed events, then record it there.
 		 */
@@ -3907,10 +3915,17 @@ int ring_buffer_read_page(struct ring_buffer *buffer,
 			memcpy(&bpage->data[commit], &missed_events,
 			       sizeof(missed_events));
 			local_add(RB_MISSED_STORED, &bpage->commit);
+			commit += sizeof(missed_events);
 		}
 		local_add(RB_MISSED_EVENTS, &bpage->commit);
 	}
 
+	/*
+	 * This page may be off to user land. Zero it out here.
+	 */
+	if (commit < BUF_PAGE_SIZE)
+		memset(&bpage->data[commit], 0, BUF_PAGE_SIZE - commit);
+
  out_unlock:
 	spin_unlock_irqrestore(&cpu_buffer->reader_lock, flags);
 
diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index ba0ec81..95d0b1a 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -3661,7 +3661,6 @@ tracing_buffers_read(struct file *filp, char __user *ubuf,
 		     size_t count, loff_t *ppos)
 {
 	struct ftrace_buffer_info *info = filp->private_data;
-	unsigned int pos;
 	ssize_t ret;
 	size_t size;
 
@@ -3688,11 +3687,6 @@ tracing_buffers_read(struct file *filp, char __user *ubuf,
 	if (ret < 0)
 		return 0;
 
-	pos = ring_buffer_page_len(info->spare);
-
-	if (pos < PAGE_SIZE)
-		memset(info->spare + pos, 0, PAGE_SIZE - pos);
-
 read:
 	size = PAGE_SIZE - info->read;
 	if (size > count)
diff --git a/tools/perf/builtin-annotate.c b/tools/perf/builtin-annotate.c
index 08278ed..96db524 100644
--- a/tools/perf/builtin-annotate.c
+++ b/tools/perf/builtin-annotate.c
@@ -343,7 +343,7 @@ find_next:
 			continue;
 		}
 
-		if (use_browser) {
+		if (use_browser > 0) {
 			key = hist_entry__tui_annotate(he);
 			if (is_exit_key(key))
 				break;
diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index 397290a..a66f427 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -1060,7 +1060,7 @@ static void event__process_sample(const event_t *self,
 			pr_err("Can't annotate %s", sym->name);
 			if (sym_filter_entry->map->dso->origin == DSO__ORIG_KERNEL) {
 				pr_err(": No vmlinux file was found in the path:\n");
-				vmlinux_path__fprintf(stderr);
+				machine__fprintf_vmlinux_path(machine, stderr);
 			} else
 				pr_err(".\n");
 			exit(1);
diff --git a/tools/perf/util/debug.c b/tools/perf/util/debug.c
index dd824cf..6cddff2 100644
--- a/tools/perf/util/debug.c
+++ b/tools/perf/util/debug.c
@@ -22,7 +22,7 @@ int eprintf(int level, const char *fmt, ...)
 
 	if (verbose >= level) {
 		va_start(args, fmt);
-		if (use_browser)
+		if (use_browser > 0)
 			ret = browser__show_help(fmt, args);
 		else
 			ret = vfprintf(stderr, fmt, args);
diff --git a/tools/perf/util/newt.c b/tools/perf/util/newt.c
index d54c540..cf182ca 100644
--- a/tools/perf/util/newt.c
+++ b/tools/perf/util/newt.c
@@ -1139,6 +1139,7 @@ void setup_browser(void)
 	struct newtPercentTreeColors *c = &defaultPercentTreeColors;
 
 	if (!isatty(1) || !use_browser || dump_trace) {
+		use_browser = 0;
 		setup_pager();
 		return;
 	}
diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index aaa51ba..7fd6b15 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -1695,9 +1695,20 @@ int dso__load_vmlinux_path(struct dso *self, struct map *map,
 			   symbol_filter_t filter)
 {
 	int i, err = 0;
+	char *filename;
 
 	pr_debug("Looking at the vmlinux_path (%d entries long)\n",
-		 vmlinux_path__nr_entries);
+		 vmlinux_path__nr_entries + 1);
+
+	filename = dso__build_id_filename(self, NULL, 0);
+	if (filename != NULL) {
+		err = dso__load_vmlinux(self, map, filename, filter);
+		if (err > 0) {
+			dso__set_long_name(self, filename);
+			goto out;
+		}
+		free(filename);
+	}
 
 	for (i = 0; i < vmlinux_path__nr_entries; ++i) {
 		err = dso__load_vmlinux(self, map, vmlinux_path[i], filter);
@@ -1706,7 +1717,7 @@ int dso__load_vmlinux_path(struct dso *self, struct map *map,
 			break;
 		}
 	}
-
+out:
 	return err;
 }
 
@@ -2102,13 +2113,21 @@ out_fail:
 	return -1;
 }
 
-size_t vmlinux_path__fprintf(FILE *fp)
+size_t machine__fprintf_vmlinux_path(struct machine *self, FILE *fp)
 {
 	int i;
 	size_t printed = 0;
+	struct dso *kdso = self->vmlinux_maps[MAP__FUNCTION]->dso;
+
+	if (kdso->has_build_id) {
+		char filename[PATH_MAX];
+		if (dso__build_id_filename(kdso, filename, sizeof(filename)))
+			printed += fprintf(fp, "[0] %s\n", filename);
+	}
 
 	for (i = 0; i < vmlinux_path__nr_entries; ++i)
-		printed += fprintf(fp, "[%d] %s\n", i, vmlinux_path[i]);
+		printed += fprintf(fp, "[%d] %s\n",
+				   i + kdso->has_build_id, vmlinux_path[i]);
 
 	return printed;
 }
diff --git a/tools/perf/util/symbol.h b/tools/perf/util/symbol.h
index 5d25b5e..5e02d2c 100644
--- a/tools/perf/util/symbol.h
+++ b/tools/perf/util/symbol.h
@@ -216,6 +216,6 @@ int machines__create_guest_kernel_maps(struct rb_root *self);
 int symbol__init(void);
 bool symbol_type__is_a(char symbol_type, enum map_type map_type);
 
-size_t vmlinux_path__fprintf(FILE *fp);
+size_t machine__fprintf_vmlinux_path(struct machine *self, FILE *fp);
 
 #endif /* __PERF_SYMBOL */
