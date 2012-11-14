Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932618Ab2KNHkk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 02:40:40 -0500
Received: from terminus.zytor.com ([198.137.202.10]:44312 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756315Ab2KNHkj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 02:40:39 -0500
Date: Tue, 13 Nov 2012 23:40:09 -0800
From: tip-bot for Arnaldo Carvalho de Melo <acme@redhat.com>
Message-ID: <tip-j1vtux3vnu6wzmrjutpxnjcz@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, paulus@samba.org,
        acme@redhat.com, hpa@zytor.com, mingo@kernel.org, peterz@infradead.org,
        efault@gmx.de, namhyung@gmail.com, jolsa@redhat.com,
        fweisbec@gmail.com, dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, efault@gmx.de,
        peterz@infradead.org, namhyung@gmail.com, jolsa@redhat.com,
        fweisbec@gmail.com, dsahern@gmail.com, tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf machine: Move more methods to machine.[ch]
Git-Commit-ID: 69d2591a829132492662bbfe164fcde5e44ad1c4
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Tue, 13 Nov 2012 23:40:16 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  69d2591a829132492662bbfe164fcde5e44ad1c4
Gitweb:     http://git.kernel.org/tip/69d2591a829132492662bbfe164fcde5e44ad1c4
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Fri, 9 Nov 2012 11:32:52 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Fri, 9 Nov 2012 11:32:52 -0300

perf machine: Move more methods to machine.[ch]

This time out of map.[ch] mostly, just code move plus a buch of 'self'
removal, using machine or machines instead.

Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-j1vtux3vnu6wzmrjutpxnjcz@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/tests/builtin-test.c |    1 +
 tools/perf/tests/dso-data.c     |    1 +
 tools/perf/util/dso.c           |    1 +
 tools/perf/util/machine.c       |  183 +++++++++++++++++++++++++++++++++++++++
 tools/perf/util/machine.h       |  131 +++++++++++++++++++++++++++-
 tools/perf/util/map.c           |  179 --------------------------------------
 tools/perf/util/map.h           |   93 --------------------
 tools/perf/util/session.h       |    5 +-
 tools/perf/util/symbol.c        |    1 +
 tools/perf/util/symbol.h        |   20 ----
 10 files changed, 318 insertions(+), 297 deletions(-)

diff --git a/tools/perf/tests/builtin-test.c b/tools/perf/tests/builtin-test.c
index 1aa9e99..b5a544d 100644
--- a/tools/perf/tests/builtin-test.c
+++ b/tools/perf/tests/builtin-test.c
@@ -10,6 +10,7 @@
 #include "util/debug.h"
 #include "util/debugfs.h"
 #include "util/evlist.h"
+#include "util/machine.h"
 #include "util/parse-options.h"
 #include "util/parse-events.h"
 #include "util/symbol.h"
diff --git a/tools/perf/tests/dso-data.c b/tools/perf/tests/dso-data.c
index c6caede..0cd42fc 100644
--- a/tools/perf/tests/dso-data.c
+++ b/tools/perf/tests/dso-data.c
@@ -6,6 +6,7 @@
 #include <fcntl.h>
 #include <string.h>
 
+#include "machine.h"
 #include "symbol.h"
 
 #define TEST_ASSERT_VAL(text, cond) \
diff --git a/tools/perf/util/dso.c b/tools/perf/util/dso.c
index db24a3f..d6d9a46 100644
--- a/tools/perf/util/dso.c
+++ b/tools/perf/util/dso.c
@@ -1,5 +1,6 @@
 #include "symbol.h"
 #include "dso.h"
+#include "machine.h"
 #include "util.h"
 #include "debug.h"
 
diff --git a/tools/perf/util/machine.c b/tools/perf/util/machine.c
index 4c6754a..1f09d05 100644
--- a/tools/perf/util/machine.c
+++ b/tools/perf/util/machine.c
@@ -2,9 +2,192 @@
 #include "event.h"
 #include "machine.h"
 #include "map.h"
+#include "strlist.h"
 #include "thread.h"
 #include <stdbool.h>
 
+int machine__init(struct machine *machine, const char *root_dir, pid_t pid)
+{
+	map_groups__init(&machine->kmaps);
+	RB_CLEAR_NODE(&machine->rb_node);
+	INIT_LIST_HEAD(&machine->user_dsos);
+	INIT_LIST_HEAD(&machine->kernel_dsos);
+
+	machine->threads = RB_ROOT;
+	INIT_LIST_HEAD(&machine->dead_threads);
+	machine->last_match = NULL;
+
+	machine->kmaps.machine = machine;
+	machine->pid = pid;
+
+	machine->root_dir = strdup(root_dir);
+	if (machine->root_dir == NULL)
+		return -ENOMEM;
+
+	if (pid != HOST_KERNEL_ID) {
+		struct thread *thread = machine__findnew_thread(machine, pid);
+		char comm[64];
+
+		if (thread == NULL)
+			return -ENOMEM;
+
+		snprintf(comm, sizeof(comm), "[guest/%d]", pid);
+		thread__set_comm(thread, comm);
+	}
+
+	return 0;
+}
+
+static void dsos__delete(struct list_head *dsos)
+{
+	struct dso *pos, *n;
+
+	list_for_each_entry_safe(pos, n, dsos, node) {
+		list_del(&pos->node);
+		dso__delete(pos);
+	}
+}
+
+void machine__exit(struct machine *machine)
+{
+	map_groups__exit(&machine->kmaps);
+	dsos__delete(&machine->user_dsos);
+	dsos__delete(&machine->kernel_dsos);
+	free(machine->root_dir);
+	machine->root_dir = NULL;
+}
+
+void machine__delete(struct machine *machine)
+{
+	machine__exit(machine);
+	free(machine);
+}
+
+struct machine *machines__add(struct rb_root *machines, pid_t pid,
+			      const char *root_dir)
+{
+	struct rb_node **p = &machines->rb_node;
+	struct rb_node *parent = NULL;
+	struct machine *pos, *machine = malloc(sizeof(*machine));
+
+	if (machine == NULL)
+		return NULL;
+
+	if (machine__init(machine, root_dir, pid) != 0) {
+		free(machine);
+		return NULL;
+	}
+
+	while (*p != NULL) {
+		parent = *p;
+		pos = rb_entry(parent, struct machine, rb_node);
+		if (pid < pos->pid)
+			p = &(*p)->rb_left;
+		else
+			p = &(*p)->rb_right;
+	}
+
+	rb_link_node(&machine->rb_node, parent, p);
+	rb_insert_color(&machine->rb_node, machines);
+
+	return machine;
+}
+
+struct machine *machines__find(struct rb_root *machines, pid_t pid)
+{
+	struct rb_node **p = &machines->rb_node;
+	struct rb_node *parent = NULL;
+	struct machine *machine;
+	struct machine *default_machine = NULL;
+
+	while (*p != NULL) {
+		parent = *p;
+		machine = rb_entry(parent, struct machine, rb_node);
+		if (pid < machine->pid)
+			p = &(*p)->rb_left;
+		else if (pid > machine->pid)
+			p = &(*p)->rb_right;
+		else
+			return machine;
+		if (!machine->pid)
+			default_machine = machine;
+	}
+
+	return default_machine;
+}
+
+struct machine *machines__findnew(struct rb_root *machines, pid_t pid)
+{
+	char path[PATH_MAX];
+	const char *root_dir = "";
+	struct machine *machine = machines__find(machines, pid);
+
+	if (machine && (machine->pid == pid))
+		goto out;
+
+	if ((pid != HOST_KERNEL_ID) &&
+	    (pid != DEFAULT_GUEST_KERNEL_ID) &&
+	    (symbol_conf.guestmount)) {
+		sprintf(path, "%s/%d", symbol_conf.guestmount, pid);
+		if (access(path, R_OK)) {
+			static struct strlist *seen;
+
+			if (!seen)
+				seen = strlist__new(true, NULL);
+
+			if (!strlist__has_entry(seen, path)) {
+				pr_err("Can't access file %s\n", path);
+				strlist__add(seen, path);
+			}
+			machine = NULL;
+			goto out;
+		}
+		root_dir = path;
+	}
+
+	machine = machines__add(machines, pid, root_dir);
+out:
+	return machine;
+}
+
+void machines__process(struct rb_root *machines,
+		       machine__process_t process, void *data)
+{
+	struct rb_node *nd;
+
+	for (nd = rb_first(machines); nd; nd = rb_next(nd)) {
+		struct machine *pos = rb_entry(nd, struct machine, rb_node);
+		process(pos, data);
+	}
+}
+
+char *machine__mmap_name(struct machine *machine, char *bf, size_t size)
+{
+	if (machine__is_host(machine))
+		snprintf(bf, size, "[%s]", "kernel.kallsyms");
+	else if (machine__is_default_guest(machine))
+		snprintf(bf, size, "[%s]", "guest.kernel.kallsyms");
+	else {
+		snprintf(bf, size, "[%s.%d]", "guest.kernel.kallsyms",
+			 machine->pid);
+	}
+
+	return bf;
+}
+
+void machines__set_id_hdr_size(struct rb_root *machines, u16 id_hdr_size)
+{
+	struct rb_node *node;
+	struct machine *machine;
+
+	for (node = rb_first(machines); node; node = rb_next(node)) {
+		machine = rb_entry(node, struct machine, rb_node);
+		machine->id_hdr_size = id_hdr_size;
+	}
+
+	return;
+}
+
 static struct thread *__machine__findnew_thread(struct machine *machine, pid_t pid,
 						bool create)
 {
diff --git a/tools/perf/util/machine.h b/tools/perf/util/machine.h
index df152f1..b7cde74 100644
--- a/tools/perf/util/machine.h
+++ b/tools/perf/util/machine.h
@@ -2,11 +2,40 @@
 #define __PERF_MACHINE_H
 
 #include <sys/types.h>
+#include <linux/rbtree.h>
+#include "map.h"
 
+struct branch_stack;
+struct perf_evsel;
+struct perf_sample;
+struct symbol;
 struct thread;
-struct machine;
 union perf_event;
 
+/* Native host kernel uses -1 as pid index in machine */
+#define	HOST_KERNEL_ID			(-1)
+#define	DEFAULT_GUEST_KERNEL_ID		(0)
+
+struct machine {
+	struct rb_node	  rb_node;
+	pid_t		  pid;
+	u16		  id_hdr_size;
+	char		  *root_dir;
+	struct rb_root	  threads;
+	struct list_head  dead_threads;
+	struct thread	  *last_match;
+	struct list_head  user_dsos;
+	struct list_head  kernel_dsos;
+	struct map_groups kmaps;
+	struct map	  *vmlinux_maps[MAP__NR_TYPES];
+};
+
+static inline
+struct map *machine__kernel_map(struct machine *machine, enum map_type type)
+{
+	return machine->vmlinux_maps[type];
+}
+
 struct thread *machine__find_thread(struct machine *machine, pid_t pid);
 
 int machine__process_comm_event(struct machine *machine, union perf_event *event);
@@ -16,4 +45,104 @@ int machine__process_lost_event(struct machine *machine, union perf_event *event
 int machine__process_mmap_event(struct machine *machine, union perf_event *event);
 int machine__process_event(struct machine *machine, union perf_event *event);
 
+typedef void (*machine__process_t)(struct machine *machine, void *data);
+
+void machines__process(struct rb_root *machines,
+		       machine__process_t process, void *data);
+
+struct machine *machines__add(struct rb_root *machines, pid_t pid,
+			      const char *root_dir);
+struct machine *machines__find_host(struct rb_root *machines);
+struct machine *machines__find(struct rb_root *machines, pid_t pid);
+struct machine *machines__findnew(struct rb_root *machines, pid_t pid);
+
+void machines__set_id_hdr_size(struct rb_root *machines, u16 id_hdr_size);
+char *machine__mmap_name(struct machine *machine, char *bf, size_t size);
+
+int machine__init(struct machine *machine, const char *root_dir, pid_t pid);
+void machine__exit(struct machine *machine);
+void machine__delete(struct machine *machine);
+
+
+struct branch_info *machine__resolve_bstack(struct machine *machine,
+					    struct thread *thread,
+					    struct branch_stack *bs);
+int machine__resolve_callchain(struct machine *machine,
+			       struct perf_evsel *evsel,
+			       struct thread *thread,
+			       struct perf_sample *sample,
+			       struct symbol **parent);
+
+/*
+ * Default guest kernel is defined by parameter --guestkallsyms
+ * and --guestmodules
+ */
+static inline bool machine__is_default_guest(struct machine *machine)
+{
+	return machine ? machine->pid == DEFAULT_GUEST_KERNEL_ID : false;
+}
+
+static inline bool machine__is_host(struct machine *machine)
+{
+	return machine ? machine->pid == HOST_KERNEL_ID : false;
+}
+
+struct thread *machine__findnew_thread(struct machine *machine, pid_t pid);
+void machine__remove_thread(struct machine *machine, struct thread *th);
+
+size_t machine__fprintf(struct machine *machine, FILE *fp);
+
+static inline
+struct symbol *machine__find_kernel_symbol(struct machine *machine,
+					   enum map_type type, u64 addr,
+					   struct map **mapp,
+					   symbol_filter_t filter)
+{
+	return map_groups__find_symbol(&machine->kmaps, type, addr,
+				       mapp, filter);
+}
+
+static inline
+struct symbol *machine__find_kernel_function(struct machine *machine, u64 addr,
+					     struct map **mapp,
+					     symbol_filter_t filter)
+{
+	return machine__find_kernel_symbol(machine, MAP__FUNCTION, addr,
+					   mapp, filter);
+}
+
+static inline
+struct symbol *machine__find_kernel_function_by_name(struct machine *machine,
+						     const char *name,
+						     struct map **mapp,
+						     symbol_filter_t filter)
+{
+	return map_groups__find_function_by_name(&machine->kmaps, name, mapp,
+						 filter);
+}
+
+struct map *machine__new_module(struct machine *machine, u64 start,
+				const char *filename);
+
+int machine__load_kallsyms(struct machine *machine, const char *filename,
+			   enum map_type type, symbol_filter_t filter);
+int machine__load_vmlinux_path(struct machine *machine, enum map_type type,
+			       symbol_filter_t filter);
+
+size_t machine__fprintf_dsos_buildid(struct machine *machine,
+				     FILE *fp, bool with_hits);
+size_t machines__fprintf_dsos(struct rb_root *machines, FILE *fp);
+size_t machines__fprintf_dsos_buildid(struct rb_root *machines,
+				      FILE *fp, bool with_hits);
+
+void machine__destroy_kernel_maps(struct machine *machine);
+int __machine__create_kernel_maps(struct machine *machine, struct dso *kernel);
+int machine__create_kernel_maps(struct machine *machine);
+
+int machines__create_kernel_maps(struct rb_root *machines, pid_t pid);
+int machines__create_guest_kernel_maps(struct rb_root *machines);
+void machines__destroy_guest_kernel_maps(struct rb_root *machines);
+
+size_t machine__fprintf_vmlinux_path(struct machine *machine, FILE *fp);
+
 #endif /* __PERF_MACHINE_H */
diff --git a/tools/perf/util/map.c b/tools/perf/util/map.c
index 5791878..0328d45 100644
--- a/tools/perf/util/map.c
+++ b/tools/perf/util/map.c
@@ -590,182 +590,3 @@ struct map *maps__find(struct rb_root *maps, u64 ip)
 
 	return NULL;
 }
-
-int machine__init(struct machine *self, const char *root_dir, pid_t pid)
-{
-	map_groups__init(&self->kmaps);
-	RB_CLEAR_NODE(&self->rb_node);
-	INIT_LIST_HEAD(&self->user_dsos);
-	INIT_LIST_HEAD(&self->kernel_dsos);
-
-	self->threads = RB_ROOT;
-	INIT_LIST_HEAD(&self->dead_threads);
-	self->last_match = NULL;
-
-	self->kmaps.machine = self;
-	self->pid	    = pid;
-	self->root_dir      = strdup(root_dir);
-	if (self->root_dir == NULL)
-		return -ENOMEM;
-
-	if (pid != HOST_KERNEL_ID) {
-		struct thread *thread = machine__findnew_thread(self, pid);
-		char comm[64];
-
-		if (thread == NULL)
-			return -ENOMEM;
-
-		snprintf(comm, sizeof(comm), "[guest/%d]", pid);
-		thread__set_comm(thread, comm);
-	}
-
-	return 0;
-}
-
-static void dsos__delete(struct list_head *self)
-{
-	struct dso *pos, *n;
-
-	list_for_each_entry_safe(pos, n, self, node) {
-		list_del(&pos->node);
-		dso__delete(pos);
-	}
-}
-
-void machine__exit(struct machine *self)
-{
-	map_groups__exit(&self->kmaps);
-	dsos__delete(&self->user_dsos);
-	dsos__delete(&self->kernel_dsos);
-	free(self->root_dir);
-	self->root_dir = NULL;
-}
-
-void machine__delete(struct machine *self)
-{
-	machine__exit(self);
-	free(self);
-}
-
-struct machine *machines__add(struct rb_root *self, pid_t pid,
-			      const char *root_dir)
-{
-	struct rb_node **p = &self->rb_node;
-	struct rb_node *parent = NULL;
-	struct machine *pos, *machine = malloc(sizeof(*machine));
-
-	if (!machine)
-		return NULL;
-
-	if (machine__init(machine, root_dir, pid) != 0) {
-		free(machine);
-		return NULL;
-	}
-
-	while (*p != NULL) {
-		parent = *p;
-		pos = rb_entry(parent, struct machine, rb_node);
-		if (pid < pos->pid)
-			p = &(*p)->rb_left;
-		else
-			p = &(*p)->rb_right;
-	}
-
-	rb_link_node(&machine->rb_node, parent, p);
-	rb_insert_color(&machine->rb_node, self);
-
-	return machine;
-}
-
-struct machine *machines__find(struct rb_root *self, pid_t pid)
-{
-	struct rb_node **p = &self->rb_node;
-	struct rb_node *parent = NULL;
-	struct machine *machine;
-	struct machine *default_machine = NULL;
-
-	while (*p != NULL) {
-		parent = *p;
-		machine = rb_entry(parent, struct machine, rb_node);
-		if (pid < machine->pid)
-			p = &(*p)->rb_left;
-		else if (pid > machine->pid)
-			p = &(*p)->rb_right;
-		else
-			return machine;
-		if (!machine->pid)
-			default_machine = machine;
-	}
-
-	return default_machine;
-}
-
-struct machine *machines__findnew(struct rb_root *self, pid_t pid)
-{
-	char path[PATH_MAX];
-	const char *root_dir = "";
-	struct machine *machine = machines__find(self, pid);
-
-	if (machine && (machine->pid == pid))
-		goto out;
-
-	if ((pid != HOST_KERNEL_ID) &&
-	    (pid != DEFAULT_GUEST_KERNEL_ID) &&
-	    (symbol_conf.guestmount)) {
-		sprintf(path, "%s/%d", symbol_conf.guestmount, pid);
-		if (access(path, R_OK)) {
-			static struct strlist *seen;
-
-			if (!seen)
-				seen = strlist__new(true, NULL);
-
-			if (!strlist__has_entry(seen, path)) {
-				pr_err("Can't access file %s\n", path);
-				strlist__add(seen, path);
-			}
-			machine = NULL;
-			goto out;
-		}
-		root_dir = path;
-	}
-
-	machine = machines__add(self, pid, root_dir);
-
-out:
-	return machine;
-}
-
-void machines__process(struct rb_root *self, machine__process_t process, void *data)
-{
-	struct rb_node *nd;
-
-	for (nd = rb_first(self); nd; nd = rb_next(nd)) {
-		struct machine *pos = rb_entry(nd, struct machine, rb_node);
-		process(pos, data);
-	}
-}
-
-char *machine__mmap_name(struct machine *self, char *bf, size_t size)
-{
-	if (machine__is_host(self))
-		snprintf(bf, size, "[%s]", "kernel.kallsyms");
-	else if (machine__is_default_guest(self))
-		snprintf(bf, size, "[%s]", "guest.kernel.kallsyms");
-	else
-		snprintf(bf, size, "[%s.%d]", "guest.kernel.kallsyms", self->pid);
-
-	return bf;
-}
-
-void machines__set_id_hdr_size(struct rb_root *machines, u16 id_hdr_size)
-{
-	struct rb_node *node;
-	struct machine *machine;
-
-	for (node = rb_first(machines); node; node = rb_next(node)) {
-		machine = rb_entry(node, struct machine, rb_node);
-		machine->id_hdr_size = id_hdr_size;
-	}
-
-	return;
-}
diff --git a/tools/perf/util/map.h b/tools/perf/util/map.h
index d2250fc..bcb39e2 100644
--- a/tools/perf/util/map.h
+++ b/tools/perf/util/map.h
@@ -57,30 +57,6 @@ struct map_groups {
 	struct machine	 *machine;
 };
 
-/* Native host kernel uses -1 as pid index in machine */
-#define	HOST_KERNEL_ID			(-1)
-#define	DEFAULT_GUEST_KERNEL_ID		(0)
-
-struct machine {
-	struct rb_node	  rb_node;
-	pid_t		  pid;
-	u16		  id_hdr_size;
-	char		  *root_dir;
-	struct rb_root	  threads;
-	struct list_head  dead_threads;
-	struct thread	  *last_match;
-	struct list_head  user_dsos;
-	struct list_head  kernel_dsos;
-	struct map_groups kmaps;
-	struct map	  *vmlinux_maps[MAP__NR_TYPES];
-};
-
-static inline
-struct map *machine__kernel_map(struct machine *self, enum map_type type)
-{
-	return self->vmlinux_maps[type];
-}
-
 static inline struct kmap *map__kmap(struct map *self)
 {
 	return (struct kmap *)(self + 1);
@@ -143,44 +119,9 @@ int map_groups__clone(struct map_groups *mg,
 size_t map_groups__fprintf(struct map_groups *mg, int verbose, FILE *fp);
 size_t map_groups__fprintf_maps(struct map_groups *mg, int verbose, FILE *fp);
 
-typedef void (*machine__process_t)(struct machine *self, void *data);
-
-void machines__process(struct rb_root *self, machine__process_t process, void *data);
-struct machine *machines__add(struct rb_root *self, pid_t pid,
-			      const char *root_dir);
-struct machine *machines__find_host(struct rb_root *self);
-struct machine *machines__find(struct rb_root *self, pid_t pid);
-struct machine *machines__findnew(struct rb_root *self, pid_t pid);
-void machines__set_id_hdr_size(struct rb_root *self, u16 id_hdr_size);
-char *machine__mmap_name(struct machine *self, char *bf, size_t size);
-int machine__init(struct machine *self, const char *root_dir, pid_t pid);
-void machine__exit(struct machine *self);
-void machine__delete(struct machine *self);
-
-struct perf_evsel;
-struct perf_sample;
-int machine__resolve_callchain(struct machine *machine,
-			       struct perf_evsel *evsel,
-			       struct thread *thread,
-			       struct perf_sample *sample,
-			       struct symbol **parent);
 int maps__set_kallsyms_ref_reloc_sym(struct map **maps, const char *symbol_name,
 				     u64 addr);
 
-/*
- * Default guest kernel is defined by parameter --guestkallsyms
- * and --guestmodules
- */
-static inline bool machine__is_default_guest(struct machine *self)
-{
-	return self ? self->pid == DEFAULT_GUEST_KERNEL_ID : false;
-}
-
-static inline bool machine__is_host(struct machine *self)
-{
-	return self ? self->pid == HOST_KERNEL_ID : false;
-}
-
 static inline void map_groups__insert(struct map_groups *mg, struct map *map)
 {
 	maps__insert(&mg->maps[map->type], map);
@@ -209,29 +150,6 @@ struct symbol *map_groups__find_symbol_by_name(struct map_groups *mg,
 					       struct map **mapp,
 					       symbol_filter_t filter);
 
-
-struct thread *machine__findnew_thread(struct machine *machine, pid_t pid);
-void machine__remove_thread(struct machine *machine, struct thread *th);
-
-size_t machine__fprintf(struct machine *machine, FILE *fp);
-
-static inline
-struct symbol *machine__find_kernel_symbol(struct machine *self,
-					   enum map_type type, u64 addr,
-					   struct map **mapp,
-					   symbol_filter_t filter)
-{
-	return map_groups__find_symbol(&self->kmaps, type, addr, mapp, filter);
-}
-
-static inline
-struct symbol *machine__find_kernel_function(struct machine *self, u64 addr,
-					     struct map **mapp,
-					     symbol_filter_t filter)
-{
-	return machine__find_kernel_symbol(self, MAP__FUNCTION, addr, mapp, filter);
-}
-
 static inline
 struct symbol *map_groups__find_function_by_name(struct map_groups *mg,
 						 const char *name, struct map **mapp,
@@ -240,22 +158,11 @@ struct symbol *map_groups__find_function_by_name(struct map_groups *mg,
 	return map_groups__find_symbol_by_name(mg, MAP__FUNCTION, name, mapp, filter);
 }
 
-static inline
-struct symbol *machine__find_kernel_function_by_name(struct machine *self,
-						     const char *name,
-						     struct map **mapp,
-						     symbol_filter_t filter)
-{
-	return map_groups__find_function_by_name(&self->kmaps, name, mapp,
-						 filter);
-}
-
 int map_groups__fixup_overlappings(struct map_groups *mg, struct map *map,
 				   int verbose, FILE *fp);
 
 struct map *map_groups__find_by_name(struct map_groups *mg,
 				     enum map_type type, const char *name);
-struct map *machine__new_module(struct machine *self, u64 start, const char *filename);
 
 void map_groups__flush(struct map_groups *mg);
 
diff --git a/tools/perf/util/session.h b/tools/perf/util/session.h
index dd64261..18d1222 100644
--- a/tools/perf/util/session.h
+++ b/tools/perf/util/session.h
@@ -4,6 +4,7 @@
 #include "hist.h"
 #include "event.h"
 #include "header.h"
+#include "machine.h"
 #include "symbol.h"
 #include "thread.h"
 #include <linux/rbtree.h>
@@ -68,10 +69,6 @@ int perf_session__resolve_callchain(struct perf_session *self, struct perf_evsel
 				    struct ip_callchain *chain,
 				    struct symbol **parent);
 
-struct branch_info *machine__resolve_bstack(struct machine *self,
-					    struct thread *thread,
-					    struct branch_stack *bs);
-
 bool perf_session__has_traces(struct perf_session *self, const char *msg);
 
 void mem_bswap_64(void *src, int byte_size);
diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index 624c65e..295f8d4 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -12,6 +12,7 @@
 #include "build-id.h"
 #include "util.h"
 #include "debug.h"
+#include "machine.h"
 #include "symbol.h"
 #include "strlist.h"
 
diff --git a/tools/perf/util/symbol.h b/tools/perf/util/symbol.h
index 863b05b..04ccf29 100644
--- a/tools/perf/util/symbol.h
+++ b/tools/perf/util/symbol.h
@@ -200,16 +200,6 @@ int dso__load_vmlinux_path(struct dso *dso, struct map *map,
 			   symbol_filter_t filter);
 int dso__load_kallsyms(struct dso *dso, const char *filename, struct map *map,
 		       symbol_filter_t filter);
-int machine__load_kallsyms(struct machine *machine, const char *filename,
-			   enum map_type type, symbol_filter_t filter);
-int machine__load_vmlinux_path(struct machine *machine, enum map_type type,
-			       symbol_filter_t filter);
-
-size_t machine__fprintf_dsos_buildid(struct machine *machine,
-				     FILE *fp, bool with_hits);
-size_t machines__fprintf_dsos(struct rb_root *machines, FILE *fp);
-size_t machines__fprintf_dsos_buildid(struct rb_root *machines,
-				      FILE *fp, bool with_hits);
 
 struct symbol *dso__find_symbol(struct dso *dso, enum map_type type,
 				u64 addr);
@@ -224,14 +214,6 @@ int kallsyms__parse(const char *filename, void *arg,
 int filename__read_debuglink(const char *filename, char *debuglink,
 			     size_t size);
 
-void machine__destroy_kernel_maps(struct machine *machine);
-int __machine__create_kernel_maps(struct machine *machine, struct dso *kernel);
-int machine__create_kernel_maps(struct machine *machine);
-
-int machines__create_kernel_maps(struct rb_root *machines, pid_t pid);
-int machines__create_guest_kernel_maps(struct rb_root *machines);
-void machines__destroy_guest_kernel_maps(struct rb_root *machines);
-
 int symbol__init(void);
 void symbol__exit(void);
 void symbol__elf_init(void);
@@ -242,8 +224,6 @@ size_t symbol__fprintf_symname(const struct symbol *sym, FILE *fp);
 size_t symbol__fprintf(struct symbol *sym, FILE *fp);
 bool symbol_type__is_a(char symbol_type, enum map_type map_type);
 
-size_t machine__fprintf_vmlinux_path(struct machine *machine, FILE *fp);
-
 int dso__test_data(void);
 int dso__load_sym(struct dso *dso, struct map *map, struct symsrc *syms_ss,
 		  struct symsrc *runtime_ss, symbol_filter_t filter,
