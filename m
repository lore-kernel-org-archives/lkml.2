Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758162Ab1EZTYA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 15:24:00 -0400
Received: from hera.kernel.org ([140.211.167.34]:46854 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751992Ab1EZTX6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 15:23:58 -0400
Date: Thu, 26 May 2011 19:21:56 GMT
From: tip-bot for Arnaldo Carvalho de Melo <acme@redhat.com>
Message-ID: <tip-mt512joaxxbhhp1odop04yit@git.kernel.org>
Cc: eranian@google.com, acme@redhat.com, mingo@redhat.com,
        torvalds@linux-foundation.org, peterz@infradead.org, efault@gmx.de,
        fweisbec@gmail.com, kees.cook@canonical.com, tglx@linutronix.de,
        hpa@zytor.com, paulus@samba.org, linux-kernel@vger.kernel.org,
        tzanussi@gmail.com, penberg@cs.helsinki.fi, davej@redhat.com,
        davem@davemloft.net, mingo@elte.hu
Reply-To: linux-kernel@vger.kernel.org, paulus@samba.org, hpa@zytor.com,
        mingo@redhat.com, acme@redhat.com, eranian@google.com,
        tzanussi@gmail.com, penberg@cs.helsinki.fi,
        torvalds@linux-foundation.org, efault@gmx.de, peterz@infradead.org,
        davej@redhat.com, davem@davemloft.net, fweisbec@gmail.com,
        kees.cook@canonical.com, tglx@linutronix.de, mingo@elte.hu
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf symbols: Handle /proc/sys/kernel/kptr_restrict
Git-Commit-ID: ec80fde746e3ccf93895d25ae1a7071c9af52585
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 26 May 2011 19:21:57 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  ec80fde746e3ccf93895d25ae1a7071c9af52585
Gitweb:     http://git.kernel.org/tip/ec80fde746e3ccf93895d25ae1a7071c9af52585
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Thu, 26 May 2011 09:53:51 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Thu, 26 May 2011 11:15:25 -0300

perf symbols: Handle /proc/sys/kernel/kptr_restrict

Perf uses /proc/modules to figure out where kernel modules are loaded.

With the advent of kptr_restrict, non root users get zeroes for all module
start addresses.

So check if kptr_restrict is non zero and don't generate the syntethic
PERF_RECORD_MMAP events for them.

Warn the user about it in perf record and in perf report.

In perf report the reference relocation symbol being zero means that
kptr_restrict was set, thus /proc/kallsyms has only zeroed addresses, so don't
use it to fixup symbol addresses when using a valid kallsyms (in the buildid
cache) or vmlinux (in the vmlinux path) build-id located automatically or
specified by the user.

Provide an explanation about it in 'perf report' if kernel samples were taken,
checking if a suitable vmlinux or kallsyms was found/specified.

Restricted /proc/kallsyms don't go to the buildid cache anymore.

Example:

 [acme@emilia ~]$ perf record -F 100000 sleep 1

 WARNING: Kernel address maps (/proc/{kallsyms,modules}) are restricted, check
 /proc/sys/kernel/kptr_restrict.

 Samples in kernel functions may not be resolved if a suitable vmlinux file is
 not found in the buildid cache or in the vmlinux path.

 Samples in kernel modules won't be resolved at all.

 If some relocation was applied (e.g. kexec) symbols may be misresolved even
 with a suitable vmlinux or kallsyms file.

 [ perf record: Woken up 1 times to write data ]
 [ perf record: Captured and wrote 0.005 MB perf.data (~231 samples) ]
 [acme@emilia ~]$

 [acme@emilia ~]$ perf report --stdio
 Kernel address maps (/proc/{kallsyms,modules}) were restricted,
 check /proc/sys/kernel/kptr_restrict before running 'perf record'.

 If some relocation was applied (e.g. kexec) symbols may be misresolved.

 Samples in kernel modules can't be resolved as well.

 # Events: 13  cycles
 #
 # Overhead  Command      Shared Object                 Symbol
 # ........  .......  .................  .....................
 #
    20.24%    sleep  [kernel.kallsyms]  [k] page_fault
    20.04%    sleep  [kernel.kallsyms]  [k] filemap_fault
    19.78%    sleep  [kernel.kallsyms]  [k] __lru_cache_add
    19.69%    sleep  ld-2.12.so         [.] memcpy
    14.71%    sleep  [kernel.kallsyms]  [k] dput
     4.70%    sleep  [kernel.kallsyms]  [k] flush_signal_handlers
     0.73%    sleep  [kernel.kallsyms]  [k] perf_event_comm
     0.11%    sleep  [kernel.kallsyms]  [k] native_write_msr_safe

 #
 # (For a higher level overview, try: perf report --sort comm,dso)
 #
 [acme@emilia ~]$

This is because it found a suitable vmlinux (build-id checked) in
/lib/modules/2.6.39-rc7+/build/vmlinux (use -v in perf report to see the long
file name).

If we remove that file from the vmlinux path:

 [root@emilia ~]# mv /lib/modules/2.6.39-rc7+/build/vmlinux \
		     /lib/modules/2.6.39-rc7+/build/vmlinux.OFF
 [acme@emilia ~]$ perf report --stdio
 [kernel.kallsyms] with build id 57298cdbe0131f6871667ec0eaab4804dcf6f562
 not found, continuing without symbols

 Kernel address maps (/proc/{kallsyms,modules}) were restricted, check
 /proc/sys/kernel/kptr_restrict before running 'perf record'.

 As no suitable kallsyms nor vmlinux was found, kernel samples can't be
 resolved.

 Samples in kernel modules can't be resolved as well.

 # Events: 13  cycles
 #
 # Overhead  Command      Shared Object  Symbol
 # ........  .......  .................  ......
 #
    80.31%    sleep  [kernel.kallsyms]  [k] 0xffffffff8103425a
    19.69%    sleep  ld-2.12.so         [.] memcpy

 #
 # (For a higher level overview, try: perf report --sort comm,dso)
 #
 [acme@emilia ~]$

Reported-by: Stephane Eranian <eranian@google.com>
Suggested-by: David Miller <davem@davemloft.net>
Cc: Dave Jones <davej@redhat.com>
Cc: David Miller <davem@davemloft.net>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Kees Cook <kees.cook@canonical.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Cc: Tom Zanussi <tzanussi@gmail.com>
Link: http://lkml.kernel.org/n/tip-mt512joaxxbhhp1odop04yit@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-record.c |   13 +++++++++++
 tools/perf/builtin-report.c |   26 +++++++++++++++++++++++
 tools/perf/util/event.c     |   15 ++++++++++--
 tools/perf/util/header.c    |    8 +++++-
 tools/perf/util/symbol.c    |   48 +++++++++++++++++++++++++++++++++++++++++++
 tools/perf/util/symbol.h    |    3 +-
 6 files changed, 107 insertions(+), 6 deletions(-)

diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index 0974f95..2ca107f 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -823,6 +823,19 @@ int cmd_record(int argc, const char **argv, const char *prefix __used)
 
 	symbol__init();
 
+	if (symbol_conf.kptr_restrict)
+		pr_warning("WARNING: Kernel address maps "
+			   "(/proc/{kallsyms,modules}) are restricted, "
+			   "check /proc/sys/kernel/kptr_restrict.\n\n"
+			   "Samples in kernel functions may not be resolved "
+			   "if a suitable vmlinux file is not found in the "
+			   "buildid cache or in the vmlinux path.\n\n"
+			   "Samples in kernel modules won't be resolved "
+			   "at all.\n\n"
+			   "If some relocation was applied (e.g. kexec) "
+			   "symbols may be misresolved even with a suitable "
+			   "vmlinux or kallsyms file.\n\n");
+
 	if (no_buildid_cache || no_buildid)
 		disable_buildid_cache();
 
diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index 498c6f7..99156c3 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -116,6 +116,9 @@ static int process_sample_event(union perf_event *event,
 	if (al.filtered || (hide_unresolved && al.sym == NULL))
 		return 0;
 
+	if (al.map != NULL)
+		al.map->dso->hit = 1;
+
 	if (perf_session__add_hist_entry(session, &al, sample, evsel)) {
 		pr_debug("problem incrementing symbol period, skipping event\n");
 		return -1;
@@ -249,6 +252,8 @@ static int __cmd_report(void)
 	u64 nr_samples;
 	struct perf_session *session;
 	struct perf_evsel *pos;
+	struct map *kernel_map;
+	struct kmap *kernel_kmap;
 	const char *help = "For a higher level overview, try: perf report --sort comm,dso";
 
 	signal(SIGINT, sig_handler);
@@ -268,6 +273,27 @@ static int __cmd_report(void)
 	if (ret)
 		goto out_delete;
 
+	kernel_map = session->host_machine.vmlinux_maps[MAP__FUNCTION];
+	kernel_kmap = map__kmap(kernel_map);
+	if (kernel_map == NULL ||
+	    (kernel_map->dso->hit &&
+	     (kernel_kmap->ref_reloc_sym == NULL ||
+	      kernel_kmap->ref_reloc_sym->addr == 0))) {
+		const struct dso *kdso = kernel_map->dso;
+
+		ui__warning("Kernel address maps "
+			    "(/proc/{kallsyms,modules}) were restricted, "
+			    "check /proc/sys/kernel/kptr_restrict before "
+			    "running 'perf record'.\n\n%s\n\n"
+			    "Samples in kernel modules can't be resolved "
+			    "as well.\n\n",
+			    RB_EMPTY_ROOT(&kdso->symbols[MAP__FUNCTION]) ?
+			    "As no suitable kallsyms nor vmlinux was found, "
+			    "kernel samples can't be resolved." :
+			    "If some relocation was applied (e.g. kexec) "
+			    "symbols may be misresolved.");
+	}
+
 	if (dump_trace) {
 		perf_session__fprintf_nr_events(session, stdout);
 		goto out_delete;
diff --git a/tools/perf/util/event.c b/tools/perf/util/event.c
index 6635fcd..0fe9adf 100644
--- a/tools/perf/util/event.c
+++ b/tools/perf/util/event.c
@@ -553,9 +553,18 @@ static int perf_event__process_kernel_mmap(union perf_event *event,
 			goto out_problem;
 
 		perf_event__set_kernel_mmap_len(event, machine->vmlinux_maps);
-		perf_session__set_kallsyms_ref_reloc_sym(machine->vmlinux_maps,
-							 symbol_name,
-							 event->mmap.pgoff);
+
+		/*
+		 * Avoid using a zero address (kptr_restrict) for the ref reloc
+		 * symbol. Effectively having zero here means that at record
+		 * time /proc/sys/kernel/kptr_restrict was non zero.
+		 */
+		if (event->mmap.pgoff != 0) {
+			perf_session__set_kallsyms_ref_reloc_sym(machine->vmlinux_maps,
+								 symbol_name,
+								 event->mmap.pgoff);
+		}
+
 		if (machine__is_default_guest(machine)) {
 			/*
 			 * preload dso of guest kernel and modules
diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
index 0717beb..afb0849 100644
--- a/tools/perf/util/header.c
+++ b/tools/perf/util/header.c
@@ -193,9 +193,13 @@ int build_id_cache__add_s(const char *sbuild_id, const char *debugdir,
 	     *linkname = malloc(size), *targetname;
 	int len, err = -1;
 
-	if (is_kallsyms)
+	if (is_kallsyms) {
+		if (symbol_conf.kptr_restrict) {
+			pr_debug("Not caching a kptr_restrict'ed /proc/kallsyms\n");
+			return 0;
+		}
 		realname = (char *)name;
-	else
+	} else
 		realname = realpath(name, NULL);
 
 	if (realname == NULL || filename == NULL || linkname == NULL)
diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index 516876d..eec1963 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -676,9 +676,30 @@ discard_symbol:		rb_erase(&pos->rb_node, root);
 	return count + moved;
 }
 
+static bool symbol__restricted_filename(const char *filename,
+					const char *restricted_filename)
+{
+	bool restricted = false;
+
+	if (symbol_conf.kptr_restrict) {
+		char *r = realpath(filename, NULL);
+
+		if (r != NULL) {
+			restricted = strcmp(r, restricted_filename) == 0;
+			free(r);
+			return restricted;
+		}
+	}
+
+	return restricted;
+}
+
 int dso__load_kallsyms(struct dso *dso, const char *filename,
 		       struct map *map, symbol_filter_t filter)
 {
+	if (symbol__restricted_filename(filename, "/proc/kallsyms"))
+		return -1;
+
 	if (dso__load_all_kallsyms(dso, filename, map) < 0)
 		return -1;
 
@@ -1790,6 +1811,9 @@ static int machine__create_modules(struct machine *machine)
 		modules = path;
 	}
 
+	if (symbol__restricted_filename(path, "/proc/modules"))
+		return -1;
+
 	file = fopen(modules, "r");
 	if (file == NULL)
 		return -1;
@@ -2239,6 +2263,9 @@ static u64 machine__get_kernel_start_addr(struct machine *machine)
 		}
 	}
 
+	if (symbol__restricted_filename(filename, "/proc/kallsyms"))
+		return 0;
+
 	if (kallsyms__parse(filename, &args, symbol__in_kernel) <= 0)
 		return 0;
 
@@ -2410,6 +2437,25 @@ static int setup_list(struct strlist **list, const char *list_str,
 	return 0;
 }
 
+static bool symbol__read_kptr_restrict(void)
+{
+	bool value = false;
+
+	if (geteuid() != 0) {
+		FILE *fp = fopen("/proc/sys/kernel/kptr_restrict", "r");
+		if (fp != NULL) {
+			char line[8];
+
+			if (fgets(line, sizeof(line), fp) != NULL)
+				value = atoi(line) != 0;
+
+			fclose(fp);
+		}
+	}
+
+	return value;
+}
+
 int symbol__init(void)
 {
 	const char *symfs;
@@ -2456,6 +2502,8 @@ int symbol__init(void)
 	if (symfs != symbol_conf.symfs)
 		free((void *)symfs);
 
+	symbol_conf.kptr_restrict = symbol__read_kptr_restrict();
+
 	symbol_conf.initialized = true;
 	return 0;
 
diff --git a/tools/perf/util/symbol.h b/tools/perf/util/symbol.h
index 242de01..325ee36 100644
--- a/tools/perf/util/symbol.h
+++ b/tools/perf/util/symbol.h
@@ -75,7 +75,8 @@ struct symbol_conf {
 			use_callchain,
 			exclude_other,
 			show_cpu_utilization,
-			initialized;
+			initialized,
+			kptr_restrict;
 	const char	*vmlinux_name,
 			*kallsyms_name,
 			*source_prefix,
