Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753997Ab0LHHzZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Dec 2010 02:55:25 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:58570 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753949Ab0LHHzV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Dec 2010 02:55:21 -0500
Date: Wed, 8 Dec 2010 08:55:06 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] perf fixes
Message-ID: <20101208075506.GA20898@elte.hu>
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
Arnaldo Carvalho de Melo (2):
      perf symbols: Fix kallsyms kernel/module map splitting
      perf record: Fix eternal wait for stillborn child

Franck Bui-Huu (1):
      perf header: Don't assume there's no attr info if no sample ids is provided

Ming Lei (1):
      perf symbols: Figure out start address of kernel map from kallsyms


 tools/perf/builtin-record.c |    6 +++-
 tools/perf/util/header.c    |   11 ++++++--
 tools/perf/util/symbol.c    |   59 ++++++++++++++++++++++++++++++++++++++----
 3 files changed, 65 insertions(+), 11 deletions(-)

diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index e2c2de2..564491f 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -197,7 +197,7 @@ static void sig_atexit(void)
 	if (child_pid > 0)
 		kill(child_pid, SIGTERM);
 
-	if (signr == -1)
+	if (signr == -1 || signr == SIGUSR1)
 		return;
 
 	signal(signr, SIG_DFL);
@@ -515,6 +515,7 @@ static int __cmd_record(int argc, const char **argv)
 	atexit(sig_atexit);
 	signal(SIGCHLD, sig_handler);
 	signal(SIGINT, sig_handler);
+	signal(SIGUSR1, sig_handler);
 
 	if (forks && (pipe(child_ready_pipe) < 0 || pipe(go_pipe) < 0)) {
 		perror("failed to create pipes");
@@ -606,6 +607,7 @@ static int __cmd_record(int argc, const char **argv)
 			execvp(argv[0], (char **)argv);
 
 			perror(argv[0]);
+			kill(getppid(), SIGUSR1);
 			exit(-1);
 		}
 
@@ -762,7 +764,7 @@ static int __cmd_record(int argc, const char **argv)
 		}
 	}
 
-	if (quiet)
+	if (quiet || signr == SIGUSR1)
 		return 0;
 
 	fprintf(stderr, "[ perf record: Woken up %ld times to write data ]\n", waking);
diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
index d7e67b1..64a85ba 100644
--- a/tools/perf/util/header.c
+++ b/tools/perf/util/header.c
@@ -946,11 +946,16 @@ perf_header__find_attr(u64 id, struct perf_header *header)
 
 	/*
 	 * We set id to -1 if the data file doesn't contain sample
-	 * ids. Check for this and avoid walking through the entire
-	 * list of ids which may be large.
+	 * ids. This can happen when the data file contains one type
+	 * of event and in that case, the header can still store the
+	 * event attribute information. Check for this and avoid
+	 * walking through the entire list of ids which may be large.
 	 */
-	if (id == -1ULL)
+	if (id == -1ULL) {
+		if (header->attrs > 0)
+			return &header->attr[0]->attr;
 		return NULL;
+	}
 
 	for (i = 0; i < header->attrs; i++) {
 		struct perf_header_attr *attr = header->attr[i];
diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index 0500895..d628c8d 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -532,7 +532,7 @@ static int dso__split_kallsyms(struct dso *self, struct map *map,
 	struct machine *machine = kmaps->machine;
 	struct map *curr_map = map;
 	struct symbol *pos;
-	int count = 0;
+	int count = 0, moved = 0;	
 	struct rb_root *root = &self->symbols[map->type];
 	struct rb_node *next = rb_first(root);
 	int kernel_range = 0;
@@ -590,6 +590,11 @@ static int dso__split_kallsyms(struct dso *self, struct map *map,
 			char dso_name[PATH_MAX];
 			struct dso *dso;
 
+			if (count == 0) {
+				curr_map = map;
+				goto filter_symbol;
+			}
+
 			if (self->kernel == DSO_TYPE_GUEST_KERNEL)
 				snprintf(dso_name, sizeof(dso_name),
 					"[guest.kernel].%d",
@@ -615,7 +620,7 @@ static int dso__split_kallsyms(struct dso *self, struct map *map,
 			map_groups__insert(kmaps, curr_map);
 			++kernel_range;
 		}
-
+filter_symbol:
 		if (filter && filter(curr_map, pos)) {
 discard_symbol:		rb_erase(&pos->rb_node, root);
 			symbol__delete(pos);
@@ -623,8 +628,9 @@ discard_symbol:		rb_erase(&pos->rb_node, root);
 			if (curr_map != map) {
 				rb_erase(&pos->rb_node, root);
 				symbols__insert(&curr_map->dso->symbols[curr_map->type], pos);
-			}
-			count++;
+				++moved;
+			} else
+				++count;
 		}
 	}
 
@@ -634,7 +640,7 @@ discard_symbol:		rb_erase(&pos->rb_node, root);
 		dso__set_loaded(curr_map->dso, curr_map->type);
 	}
 
-	return count;
+	return count + moved;
 }
 
 int dso__load_kallsyms(struct dso *self, const char *filename,
@@ -2125,14 +2131,55 @@ static struct dso *machine__create_kernel(struct machine *self)
 	return kernel;
 }
 
+struct process_args {
+	u64 start;
+};
+
+static int symbol__in_kernel(void *arg, const char *name,
+			     char type __used, u64 start)
+{
+	struct process_args *args = arg;
+
+	if (strchr(name, '['))
+		return 0;
+
+	args->start = start;
+	return 1;
+}
+
+/* Figure out the start address of kernel map from /proc/kallsyms */
+static u64 machine__get_kernel_start_addr(struct machine *machine)
+{
+	const char *filename;
+	char path[PATH_MAX];
+	struct process_args args;
+
+	if (machine__is_host(machine)) {
+		filename = "/proc/kallsyms";
+	} else {
+		if (machine__is_default_guest(machine))
+			filename = (char *)symbol_conf.default_guest_kallsyms;
+		else {
+			sprintf(path, "%s/proc/kallsyms", machine->root_dir);
+			filename = path;
+		}
+	}
+
+	if (kallsyms__parse(filename, &args, symbol__in_kernel) <= 0)
+		return 0;
+
+	return args.start;
+}
+
 int __machine__create_kernel_maps(struct machine *self, struct dso *kernel)
 {
 	enum map_type type;
+	u64 start = machine__get_kernel_start_addr(self);
 
 	for (type = 0; type < MAP__NR_TYPES; ++type) {
 		struct kmap *kmap;
 
-		self->vmlinux_maps[type] = map__new2(0, kernel, type);
+		self->vmlinux_maps[type] = map__new2(start, kernel, type);
 		if (self->vmlinux_maps[type] == NULL)
 			return -1;
 
