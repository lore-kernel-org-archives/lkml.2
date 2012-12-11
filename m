Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755328Ab2LKW4j (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2012 17:56:39 -0500
Received: from merlin.infradead.org ([205.233.59.134]:43843 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755194Ab2LKWsj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2012 17:48:39 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 24/37] perf machine: Move more machine methods to machine.c
Date: Tue, 11 Dec 2012 19:48:10 -0300
Message-Id: <1355266103-17238-25-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
In-Reply-To: <1355266103-17238-1-git-send-email-acme@infradead.org>
References: <1355266103-17238-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

Mechanical, no functional changes.

Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-9ib6qtqge1jmms2luwu4udbx@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/machine.c |  742 +++++++++++++++++++++++++++++++++++++++++++++
 tools/perf/util/machine.h |    3 +-
 tools/perf/util/session.c |  210 -------------
 tools/perf/util/symbol.c  |  522 +------------------------------
 tools/perf/util/symbol.h  |    4 +
 tools/perf/util/thread.c  |   20 +-
 tools/perf/util/thread.h  |    1 +
 7 files changed, 756 insertions(+), 746 deletions(-)

diff --git a/tools/perf/util/machine.c b/tools/perf/util/machine.c
index 1f09d05..71fa903 100644
--- a/tools/perf/util/machine.c
+++ b/tools/perf/util/machine.c
@@ -1,10 +1,15 @@
+#include "callchain.h"
 #include "debug.h"
 #include "event.h"
+#include "evsel.h"
+#include "hist.h"
 #include "machine.h"
 #include "map.h"
+#include "sort.h"
 #include "strlist.h"
 #include "thread.h"
 #include <stdbool.h>
+#include "unwind.h"
 
 int machine__init(struct machine *machine, const char *root_dir, pid_t pid)
 {
@@ -48,6 +53,29 @@ static void dsos__delete(struct list_head *dsos)
 	}
 }
 
+void machine__delete_dead_threads(struct machine *machine)
+{
+	struct thread *n, *t;
+
+	list_for_each_entry_safe(t, n, &machine->dead_threads, node) {
+		list_del(&t->node);
+		thread__delete(t);
+	}
+}
+
+void machine__delete_threads(struct machine *machine)
+{
+	struct rb_node *nd = rb_first(&machine->threads);
+
+	while (nd) {
+		struct thread *t = rb_entry(nd, struct thread, rb_node);
+
+		rb_erase(&t->rb_node, &machine->threads);
+		nd = rb_next(nd);
+		thread__delete(t);
+	}
+}
+
 void machine__exit(struct machine *machine)
 {
 	map_groups__exit(&machine->kmaps);
@@ -264,6 +292,534 @@ int machine__process_lost_event(struct machine *machine __maybe_unused,
 	return 0;
 }
 
+struct map *machine__new_module(struct machine *machine, u64 start,
+				const char *filename)
+{
+	struct map *map;
+	struct dso *dso = __dsos__findnew(&machine->kernel_dsos, filename);
+
+	if (dso == NULL)
+		return NULL;
+
+	map = map__new2(start, dso, MAP__FUNCTION);
+	if (map == NULL)
+		return NULL;
+
+	if (machine__is_host(machine))
+		dso->symtab_type = DSO_BINARY_TYPE__SYSTEM_PATH_KMODULE;
+	else
+		dso->symtab_type = DSO_BINARY_TYPE__GUEST_KMODULE;
+	map_groups__insert(&machine->kmaps, map);
+	return map;
+}
+
+size_t machines__fprintf_dsos(struct rb_root *machines, FILE *fp)
+{
+	struct rb_node *nd;
+	size_t ret = 0;
+
+	for (nd = rb_first(machines); nd; nd = rb_next(nd)) {
+		struct machine *pos = rb_entry(nd, struct machine, rb_node);
+		ret += __dsos__fprintf(&pos->kernel_dsos, fp);
+		ret += __dsos__fprintf(&pos->user_dsos, fp);
+	}
+
+	return ret;
+}
+
+size_t machine__fprintf_dsos_buildid(struct machine *machine, FILE *fp,
+				     bool (skip)(struct dso *dso, int parm), int parm)
+{
+	return __dsos__fprintf_buildid(&machine->kernel_dsos, fp, skip, parm) +
+	       __dsos__fprintf_buildid(&machine->user_dsos, fp, skip, parm);
+}
+
+size_t machines__fprintf_dsos_buildid(struct rb_root *machines, FILE *fp,
+				     bool (skip)(struct dso *dso, int parm), int parm)
+{
+	struct rb_node *nd;
+	size_t ret = 0;
+
+	for (nd = rb_first(machines); nd; nd = rb_next(nd)) {
+		struct machine *pos = rb_entry(nd, struct machine, rb_node);
+		ret += machine__fprintf_dsos_buildid(pos, fp, skip, parm);
+	}
+	return ret;
+}
+
+size_t machine__fprintf_vmlinux_path(struct machine *machine, FILE *fp)
+{
+	int i;
+	size_t printed = 0;
+	struct dso *kdso = machine->vmlinux_maps[MAP__FUNCTION]->dso;
+
+	if (kdso->has_build_id) {
+		char filename[PATH_MAX];
+		if (dso__build_id_filename(kdso, filename, sizeof(filename)))
+			printed += fprintf(fp, "[0] %s\n", filename);
+	}
+
+	for (i = 0; i < vmlinux_path__nr_entries; ++i)
+		printed += fprintf(fp, "[%d] %s\n",
+				   i + kdso->has_build_id, vmlinux_path[i]);
+
+	return printed;
+}
+
+size_t machine__fprintf(struct machine *machine, FILE *fp)
+{
+	size_t ret = 0;
+	struct rb_node *nd;
+
+	for (nd = rb_first(&machine->threads); nd; nd = rb_next(nd)) {
+		struct thread *pos = rb_entry(nd, struct thread, rb_node);
+
+		ret += thread__fprintf(pos, fp);
+	}
+
+	return ret;
+}
+
+static struct dso *machine__get_kernel(struct machine *machine)
+{
+	const char *vmlinux_name = NULL;
+	struct dso *kernel;
+
+	if (machine__is_host(machine)) {
+		vmlinux_name = symbol_conf.vmlinux_name;
+		if (!vmlinux_name)
+			vmlinux_name = "[kernel.kallsyms]";
+
+		kernel = dso__kernel_findnew(machine, vmlinux_name,
+					     "[kernel]",
+					     DSO_TYPE_KERNEL);
+	} else {
+		char bf[PATH_MAX];
+
+		if (machine__is_default_guest(machine))
+			vmlinux_name = symbol_conf.default_guest_vmlinux_name;
+		if (!vmlinux_name)
+			vmlinux_name = machine__mmap_name(machine, bf,
+							  sizeof(bf));
+
+		kernel = dso__kernel_findnew(machine, vmlinux_name,
+					     "[guest.kernel]",
+					     DSO_TYPE_GUEST_KERNEL);
+	}
+
+	if (kernel != NULL && (!kernel->has_build_id))
+		dso__read_running_kernel_build_id(kernel, machine);
+
+	return kernel;
+}
+
+struct process_args {
+	u64 start;
+};
+
+static int symbol__in_kernel(void *arg, const char *name,
+			     char type __maybe_unused, u64 start)
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
+	if (symbol__restricted_filename(filename, "/proc/kallsyms"))
+		return 0;
+
+	if (kallsyms__parse(filename, &args, symbol__in_kernel) <= 0)
+		return 0;
+
+	return args.start;
+}
+
+int __machine__create_kernel_maps(struct machine *machine, struct dso *kernel)
+{
+	enum map_type type;
+	u64 start = machine__get_kernel_start_addr(machine);
+
+	for (type = 0; type < MAP__NR_TYPES; ++type) {
+		struct kmap *kmap;
+
+		machine->vmlinux_maps[type] = map__new2(start, kernel, type);
+		if (machine->vmlinux_maps[type] == NULL)
+			return -1;
+
+		machine->vmlinux_maps[type]->map_ip =
+			machine->vmlinux_maps[type]->unmap_ip =
+				identity__map_ip;
+		kmap = map__kmap(machine->vmlinux_maps[type]);
+		kmap->kmaps = &machine->kmaps;
+		map_groups__insert(&machine->kmaps,
+				   machine->vmlinux_maps[type]);
+	}
+
+	return 0;
+}
+
+void machine__destroy_kernel_maps(struct machine *machine)
+{
+	enum map_type type;
+
+	for (type = 0; type < MAP__NR_TYPES; ++type) {
+		struct kmap *kmap;
+
+		if (machine->vmlinux_maps[type] == NULL)
+			continue;
+
+		kmap = map__kmap(machine->vmlinux_maps[type]);
+		map_groups__remove(&machine->kmaps,
+				   machine->vmlinux_maps[type]);
+		if (kmap->ref_reloc_sym) {
+			/*
+			 * ref_reloc_sym is shared among all maps, so free just
+			 * on one of them.
+			 */
+			if (type == MAP__FUNCTION) {
+				free((char *)kmap->ref_reloc_sym->name);
+				kmap->ref_reloc_sym->name = NULL;
+				free(kmap->ref_reloc_sym);
+			}
+			kmap->ref_reloc_sym = NULL;
+		}
+
+		map__delete(machine->vmlinux_maps[type]);
+		machine->vmlinux_maps[type] = NULL;
+	}
+}
+
+int machines__create_guest_kernel_maps(struct rb_root *machines)
+{
+	int ret = 0;
+	struct dirent **namelist = NULL;
+	int i, items = 0;
+	char path[PATH_MAX];
+	pid_t pid;
+	char *endp;
+
+	if (symbol_conf.default_guest_vmlinux_name ||
+	    symbol_conf.default_guest_modules ||
+	    symbol_conf.default_guest_kallsyms) {
+		machines__create_kernel_maps(machines, DEFAULT_GUEST_KERNEL_ID);
+	}
+
+	if (symbol_conf.guestmount) {
+		items = scandir(symbol_conf.guestmount, &namelist, NULL, NULL);
+		if (items <= 0)
+			return -ENOENT;
+		for (i = 0; i < items; i++) {
+			if (!isdigit(namelist[i]->d_name[0])) {
+				/* Filter out . and .. */
+				continue;
+			}
+			pid = (pid_t)strtol(namelist[i]->d_name, &endp, 10);
+			if ((*endp != '\0') ||
+			    (endp == namelist[i]->d_name) ||
+			    (errno == ERANGE)) {
+				pr_debug("invalid directory (%s). Skipping.\n",
+					 namelist[i]->d_name);
+				continue;
+			}
+			sprintf(path, "%s/%s/proc/kallsyms",
+				symbol_conf.guestmount,
+				namelist[i]->d_name);
+			ret = access(path, R_OK);
+			if (ret) {
+				pr_debug("Can't access file %s\n", path);
+				goto failure;
+			}
+			machines__create_kernel_maps(machines, pid);
+		}
+failure:
+		free(namelist);
+	}
+
+	return ret;
+}
+
+void machines__destroy_guest_kernel_maps(struct rb_root *machines)
+{
+	struct rb_node *next = rb_first(machines);
+
+	while (next) {
+		struct machine *pos = rb_entry(next, struct machine, rb_node);
+
+		next = rb_next(&pos->rb_node);
+		rb_erase(&pos->rb_node, machines);
+		machine__delete(pos);
+	}
+}
+
+int machines__create_kernel_maps(struct rb_root *machines, pid_t pid)
+{
+	struct machine *machine = machines__findnew(machines, pid);
+
+	if (machine == NULL)
+		return -1;
+
+	return machine__create_kernel_maps(machine);
+}
+
+int machine__load_kallsyms(struct machine *machine, const char *filename,
+			   enum map_type type, symbol_filter_t filter)
+{
+	struct map *map = machine->vmlinux_maps[type];
+	int ret = dso__load_kallsyms(map->dso, filename, map, filter);
+
+	if (ret > 0) {
+		dso__set_loaded(map->dso, type);
+		/*
+		 * Since /proc/kallsyms will have multiple sessions for the
+		 * kernel, with modules between them, fixup the end of all
+		 * sections.
+		 */
+		__map_groups__fixup_end(&machine->kmaps, type);
+	}
+
+	return ret;
+}
+
+int machine__load_vmlinux_path(struct machine *machine, enum map_type type,
+			       symbol_filter_t filter)
+{
+	struct map *map = machine->vmlinux_maps[type];
+	int ret = dso__load_vmlinux_path(map->dso, map, filter);
+
+	if (ret > 0) {
+		dso__set_loaded(map->dso, type);
+		map__reloc_vmlinux(map);
+	}
+
+	return ret;
+}
+
+static void map_groups__fixup_end(struct map_groups *mg)
+{
+	int i;
+	for (i = 0; i < MAP__NR_TYPES; ++i)
+		__map_groups__fixup_end(mg, i);
+}
+
+static char *get_kernel_version(const char *root_dir)
+{
+	char version[PATH_MAX];
+	FILE *file;
+	char *name, *tmp;
+	const char *prefix = "Linux version ";
+
+	sprintf(version, "%s/proc/version", root_dir);
+	file = fopen(version, "r");
+	if (!file)
+		return NULL;
+
+	version[0] = '\0';
+	tmp = fgets(version, sizeof(version), file);
+	fclose(file);
+
+	name = strstr(version, prefix);
+	if (!name)
+		return NULL;
+	name += strlen(prefix);
+	tmp = strchr(name, ' ');
+	if (tmp)
+		*tmp = '\0';
+
+	return strdup(name);
+}
+
+static int map_groups__set_modules_path_dir(struct map_groups *mg,
+				const char *dir_name)
+{
+	struct dirent *dent;
+	DIR *dir = opendir(dir_name);
+	int ret = 0;
+
+	if (!dir) {
+		pr_debug("%s: cannot open %s dir\n", __func__, dir_name);
+		return -1;
+	}
+
+	while ((dent = readdir(dir)) != NULL) {
+		char path[PATH_MAX];
+		struct stat st;
+
+		/*sshfs might return bad dent->d_type, so we have to stat*/
+		snprintf(path, sizeof(path), "%s/%s", dir_name, dent->d_name);
+		if (stat(path, &st))
+			continue;
+
+		if (S_ISDIR(st.st_mode)) {
+			if (!strcmp(dent->d_name, ".") ||
+			    !strcmp(dent->d_name, ".."))
+				continue;
+
+			ret = map_groups__set_modules_path_dir(mg, path);
+			if (ret < 0)
+				goto out;
+		} else {
+			char *dot = strrchr(dent->d_name, '.'),
+			     dso_name[PATH_MAX];
+			struct map *map;
+			char *long_name;
+
+			if (dot == NULL || strcmp(dot, ".ko"))
+				continue;
+			snprintf(dso_name, sizeof(dso_name), "[%.*s]",
+				 (int)(dot - dent->d_name), dent->d_name);
+
+			strxfrchar(dso_name, '-', '_');
+			map = map_groups__find_by_name(mg, MAP__FUNCTION,
+						       dso_name);
+			if (map == NULL)
+				continue;
+
+			long_name = strdup(path);
+			if (long_name == NULL) {
+				ret = -1;
+				goto out;
+			}
+			dso__set_long_name(map->dso, long_name);
+			map->dso->lname_alloc = 1;
+			dso__kernel_module_get_build_id(map->dso, "");
+		}
+	}
+
+out:
+	closedir(dir);
+	return ret;
+}
+
+static int machine__set_modules_path(struct machine *machine)
+{
+	char *version;
+	char modules_path[PATH_MAX];
+
+	version = get_kernel_version(machine->root_dir);
+	if (!version)
+		return -1;
+
+	snprintf(modules_path, sizeof(modules_path), "%s/lib/modules/%s/kernel",
+		 machine->root_dir, version);
+	free(version);
+
+	return map_groups__set_modules_path_dir(&machine->kmaps, modules_path);
+}
+
+static int machine__create_modules(struct machine *machine)
+{
+	char *line = NULL;
+	size_t n;
+	FILE *file;
+	struct map *map;
+	const char *modules;
+	char path[PATH_MAX];
+
+	if (machine__is_default_guest(machine))
+		modules = symbol_conf.default_guest_modules;
+	else {
+		sprintf(path, "%s/proc/modules", machine->root_dir);
+		modules = path;
+	}
+
+	if (symbol__restricted_filename(path, "/proc/modules"))
+		return -1;
+
+	file = fopen(modules, "r");
+	if (file == NULL)
+		return -1;
+
+	while (!feof(file)) {
+		char name[PATH_MAX];
+		u64 start;
+		char *sep;
+		int line_len;
+
+		line_len = getline(&line, &n, file);
+		if (line_len < 0)
+			break;
+
+		if (!line)
+			goto out_failure;
+
+		line[--line_len] = '\0'; /* \n */
+
+		sep = strrchr(line, 'x');
+		if (sep == NULL)
+			continue;
+
+		hex2u64(sep + 1, &start);
+
+		sep = strchr(line, ' ');
+		if (sep == NULL)
+			continue;
+
+		*sep = '\0';
+
+		snprintf(name, sizeof(name), "[%s]", line);
+		map = machine__new_module(machine, start, name);
+		if (map == NULL)
+			goto out_delete_line;
+		dso__kernel_module_get_build_id(map->dso, machine->root_dir);
+	}
+
+	free(line);
+	fclose(file);
+
+	return machine__set_modules_path(machine);
+
+out_delete_line:
+	free(line);
+out_failure:
+	return -1;
+}
+
+int machine__create_kernel_maps(struct machine *machine)
+{
+	struct dso *kernel = machine__get_kernel(machine);
+
+	if (kernel == NULL ||
+	    __machine__create_kernel_maps(machine, kernel) < 0)
+		return -1;
+
+	if (symbol_conf.use_modules && machine__create_modules(machine) < 0) {
+		if (machine__is_host(machine))
+			pr_debug("Problems creating module maps, "
+				 "continuing anyway...\n");
+		else
+			pr_debug("Problems creating module maps for guest %d, "
+				 "continuing anyway...\n", machine->pid);
+	}
+
+	/*
+	 * Now that we have all the maps created, just set the ->end of them:
+	 */
+	map_groups__fixup_end(&machine->kmaps);
+	return 0;
+}
+
 static void machine__set_kernel_mmap_len(struct machine *machine,
 					 union perf_event *event)
 {
@@ -462,3 +1018,189 @@ int machine__process_event(struct machine *machine, union perf_event *event)
 
 	return ret;
 }
+
+void machine__remove_thread(struct machine *machine, struct thread *th)
+{
+	machine->last_match = NULL;
+	rb_erase(&th->rb_node, &machine->threads);
+	/*
+	 * We may have references to this thread, for instance in some hist_entry
+	 * instances, so just move them to a separate list.
+	 */
+	list_add_tail(&th->node, &machine->dead_threads);
+}
+
+static bool symbol__match_parent_regex(struct symbol *sym)
+{
+	if (sym->name && !regexec(&parent_regex, sym->name, 0, NULL, 0))
+		return 1;
+
+	return 0;
+}
+
+static const u8 cpumodes[] = {
+	PERF_RECORD_MISC_USER,
+	PERF_RECORD_MISC_KERNEL,
+	PERF_RECORD_MISC_GUEST_USER,
+	PERF_RECORD_MISC_GUEST_KERNEL
+};
+#define NCPUMODES (sizeof(cpumodes)/sizeof(u8))
+
+static void ip__resolve_ams(struct machine *machine, struct thread *thread,
+			    struct addr_map_symbol *ams,
+			    u64 ip)
+{
+	struct addr_location al;
+	size_t i;
+	u8 m;
+
+	memset(&al, 0, sizeof(al));
+
+	for (i = 0; i < NCPUMODES; i++) {
+		m = cpumodes[i];
+		/*
+		 * We cannot use the header.misc hint to determine whether a
+		 * branch stack address is user, kernel, guest, hypervisor.
+		 * Branches may straddle the kernel/user/hypervisor boundaries.
+		 * Thus, we have to try consecutively until we find a match
+		 * or else, the symbol is unknown
+		 */
+		thread__find_addr_location(thread, machine, m, MAP__FUNCTION,
+				ip, &al, NULL);
+		if (al.sym)
+			goto found;
+	}
+found:
+	ams->addr = ip;
+	ams->al_addr = al.addr;
+	ams->sym = al.sym;
+	ams->map = al.map;
+}
+
+struct branch_info *machine__resolve_bstack(struct machine *machine,
+					    struct thread *thr,
+					    struct branch_stack *bs)
+{
+	struct branch_info *bi;
+	unsigned int i;
+
+	bi = calloc(bs->nr, sizeof(struct branch_info));
+	if (!bi)
+		return NULL;
+
+	for (i = 0; i < bs->nr; i++) {
+		ip__resolve_ams(machine, thr, &bi[i].to, bs->entries[i].to);
+		ip__resolve_ams(machine, thr, &bi[i].from, bs->entries[i].from);
+		bi[i].flags = bs->entries[i].flags;
+	}
+	return bi;
+}
+
+static int machine__resolve_callchain_sample(struct machine *machine,
+					     struct thread *thread,
+					     struct ip_callchain *chain,
+					     struct symbol **parent)
+
+{
+	u8 cpumode = PERF_RECORD_MISC_USER;
+	unsigned int i;
+	int err;
+
+	callchain_cursor_reset(&callchain_cursor);
+
+	if (chain->nr > PERF_MAX_STACK_DEPTH) {
+		pr_warning("corrupted callchain. skipping...\n");
+		return 0;
+	}
+
+	for (i = 0; i < chain->nr; i++) {
+		u64 ip;
+		struct addr_location al;
+
+		if (callchain_param.order == ORDER_CALLEE)
+			ip = chain->ips[i];
+		else
+			ip = chain->ips[chain->nr - i - 1];
+
+		if (ip >= PERF_CONTEXT_MAX) {
+			switch (ip) {
+			case PERF_CONTEXT_HV:
+				cpumode = PERF_RECORD_MISC_HYPERVISOR;
+				break;
+			case PERF_CONTEXT_KERNEL:
+				cpumode = PERF_RECORD_MISC_KERNEL;
+				break;
+			case PERF_CONTEXT_USER:
+				cpumode = PERF_RECORD_MISC_USER;
+				break;
+			default:
+				pr_debug("invalid callchain context: "
+					 "%"PRId64"\n", (s64) ip);
+				/*
+				 * It seems the callchain is corrupted.
+				 * Discard all.
+				 */
+				callchain_cursor_reset(&callchain_cursor);
+				return 0;
+			}
+			continue;
+		}
+
+		al.filtered = false;
+		thread__find_addr_location(thread, machine, cpumode,
+					   MAP__FUNCTION, ip, &al, NULL);
+		if (al.sym != NULL) {
+			if (sort__has_parent && !*parent &&
+			    symbol__match_parent_regex(al.sym))
+				*parent = al.sym;
+			if (!symbol_conf.use_callchain)
+				break;
+		}
+
+		err = callchain_cursor_append(&callchain_cursor,
+					      ip, al.map, al.sym);
+		if (err)
+			return err;
+	}
+
+	return 0;
+}
+
+static int unwind_entry(struct unwind_entry *entry, void *arg)
+{
+	struct callchain_cursor *cursor = arg;
+	return callchain_cursor_append(cursor, entry->ip,
+				       entry->map, entry->sym);
+}
+
+int machine__resolve_callchain(struct machine *machine,
+			       struct perf_evsel *evsel,
+			       struct thread *thread,
+			       struct perf_sample *sample,
+			       struct symbol **parent)
+
+{
+	int ret;
+
+	callchain_cursor_reset(&callchain_cursor);
+
+	ret = machine__resolve_callchain_sample(machine, thread,
+						sample->callchain, parent);
+	if (ret)
+		return ret;
+
+	/* Can we do dwarf post unwind? */
+	if (!((evsel->attr.sample_type & PERF_SAMPLE_REGS_USER) &&
+	      (evsel->attr.sample_type & PERF_SAMPLE_STACK_USER)))
+		return 0;
+
+	/* Bail out if nothing was captured. */
+	if ((!sample->user_regs.regs) ||
+	    (!sample->user_stack.size))
+		return 0;
+
+	return unwind__get_entries(unwind_entry, &callchain_cursor, machine,
+				   thread, evsel->attr.sample_regs_user,
+				   sample);
+
+}
diff --git a/tools/perf/util/machine.h b/tools/perf/util/machine.h
index 646ad13..e112368 100644
--- a/tools/perf/util/machine.h
+++ b/tools/perf/util/machine.h
@@ -61,9 +61,10 @@ char *machine__mmap_name(struct machine *machine, char *bf, size_t size);
 
 int machine__init(struct machine *machine, const char *root_dir, pid_t pid);
 void machine__exit(struct machine *machine);
+void machine__delete_dead_threads(struct machine *machine);
+void machine__delete_threads(struct machine *machine);
 void machine__delete(struct machine *machine);
 
-
 struct branch_info *machine__resolve_bstack(struct machine *machine,
 					    struct thread *thread,
 					    struct branch_stack *bs);
diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index 8d04dfb..76d6e25 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -16,7 +16,6 @@
 #include "cpumap.h"
 #include "event-parse.h"
 #include "perf_regs.h"
-#include "unwind.h"
 #include "vdso.h"
 
 static int perf_session__open(struct perf_session *self, bool force)
@@ -162,34 +161,11 @@ out_delete:
 	return NULL;
 }
 
-static void machine__delete_dead_threads(struct machine *machine)
-{
-	struct thread *n, *t;
-
-	list_for_each_entry_safe(t, n, &machine->dead_threads, node) {
-		list_del(&t->node);
-		thread__delete(t);
-	}
-}
-
 static void perf_session__delete_dead_threads(struct perf_session *session)
 {
 	machine__delete_dead_threads(&session->host_machine);
 }
 
-static void machine__delete_threads(struct machine *self)
-{
-	struct rb_node *nd = rb_first(&self->threads);
-
-	while (nd) {
-		struct thread *t = rb_entry(nd, struct thread, rb_node);
-
-		rb_erase(&t->rb_node, &self->threads);
-		nd = rb_next(nd);
-		thread__delete(t);
-	}
-}
-
 static void perf_session__delete_threads(struct perf_session *session)
 {
 	machine__delete_threads(&session->host_machine);
@@ -223,192 +199,6 @@ void perf_session__delete(struct perf_session *self)
 	vdso__exit();
 }
 
-void machine__remove_thread(struct machine *self, struct thread *th)
-{
-	self->last_match = NULL;
-	rb_erase(&th->rb_node, &self->threads);
-	/*
-	 * We may have references to this thread, for instance in some hist_entry
-	 * instances, so just move them to a separate list.
-	 */
-	list_add_tail(&th->node, &self->dead_threads);
-}
-
-static bool symbol__match_parent_regex(struct symbol *sym)
-{
-	if (sym->name && !regexec(&parent_regex, sym->name, 0, NULL, 0))
-		return 1;
-
-	return 0;
-}
-
-static const u8 cpumodes[] = {
-	PERF_RECORD_MISC_USER,
-	PERF_RECORD_MISC_KERNEL,
-	PERF_RECORD_MISC_GUEST_USER,
-	PERF_RECORD_MISC_GUEST_KERNEL
-};
-#define NCPUMODES (sizeof(cpumodes)/sizeof(u8))
-
-static void ip__resolve_ams(struct machine *self, struct thread *thread,
-			    struct addr_map_symbol *ams,
-			    u64 ip)
-{
-	struct addr_location al;
-	size_t i;
-	u8 m;
-
-	memset(&al, 0, sizeof(al));
-
-	for (i = 0; i < NCPUMODES; i++) {
-		m = cpumodes[i];
-		/*
-		 * We cannot use the header.misc hint to determine whether a
-		 * branch stack address is user, kernel, guest, hypervisor.
-		 * Branches may straddle the kernel/user/hypervisor boundaries.
-		 * Thus, we have to try consecutively until we find a match
-		 * or else, the symbol is unknown
-		 */
-		thread__find_addr_location(thread, self, m, MAP__FUNCTION,
-				ip, &al, NULL);
-		if (al.sym)
-			goto found;
-	}
-found:
-	ams->addr = ip;
-	ams->al_addr = al.addr;
-	ams->sym = al.sym;
-	ams->map = al.map;
-}
-
-struct branch_info *machine__resolve_bstack(struct machine *self,
-					    struct thread *thr,
-					    struct branch_stack *bs)
-{
-	struct branch_info *bi;
-	unsigned int i;
-
-	bi = calloc(bs->nr, sizeof(struct branch_info));
-	if (!bi)
-		return NULL;
-
-	for (i = 0; i < bs->nr; i++) {
-		ip__resolve_ams(self, thr, &bi[i].to, bs->entries[i].to);
-		ip__resolve_ams(self, thr, &bi[i].from, bs->entries[i].from);
-		bi[i].flags = bs->entries[i].flags;
-	}
-	return bi;
-}
-
-static int machine__resolve_callchain_sample(struct machine *machine,
-					     struct thread *thread,
-					     struct ip_callchain *chain,
-					     struct symbol **parent)
-
-{
-	u8 cpumode = PERF_RECORD_MISC_USER;
-	unsigned int i;
-	int err;
-
-	callchain_cursor_reset(&callchain_cursor);
-
-	if (chain->nr > PERF_MAX_STACK_DEPTH) {
-		pr_warning("corrupted callchain. skipping...\n");
-		return 0;
-	}
-
-	for (i = 0; i < chain->nr; i++) {
-		u64 ip;
-		struct addr_location al;
-
-		if (callchain_param.order == ORDER_CALLEE)
-			ip = chain->ips[i];
-		else
-			ip = chain->ips[chain->nr - i - 1];
-
-		if (ip >= PERF_CONTEXT_MAX) {
-			switch (ip) {
-			case PERF_CONTEXT_HV:
-				cpumode = PERF_RECORD_MISC_HYPERVISOR;
-				break;
-			case PERF_CONTEXT_KERNEL:
-				cpumode = PERF_RECORD_MISC_KERNEL;
-				break;
-			case PERF_CONTEXT_USER:
-				cpumode = PERF_RECORD_MISC_USER;
-				break;
-			default:
-				pr_debug("invalid callchain context: "
-					 "%"PRId64"\n", (s64) ip);
-				/*
-				 * It seems the callchain is corrupted.
-				 * Discard all.
-				 */
-				callchain_cursor_reset(&callchain_cursor);
-				return 0;
-			}
-			continue;
-		}
-
-		al.filtered = false;
-		thread__find_addr_location(thread, machine, cpumode,
-					   MAP__FUNCTION, ip, &al, NULL);
-		if (al.sym != NULL) {
-			if (sort__has_parent && !*parent &&
-			    symbol__match_parent_regex(al.sym))
-				*parent = al.sym;
-			if (!symbol_conf.use_callchain)
-				break;
-		}
-
-		err = callchain_cursor_append(&callchain_cursor,
-					      ip, al.map, al.sym);
-		if (err)
-			return err;
-	}
-
-	return 0;
-}
-
-static int unwind_entry(struct unwind_entry *entry, void *arg)
-{
-	struct callchain_cursor *cursor = arg;
-	return callchain_cursor_append(cursor, entry->ip,
-				       entry->map, entry->sym);
-}
-
-int machine__resolve_callchain(struct machine *machine,
-			       struct perf_evsel *evsel,
-			       struct thread *thread,
-			       struct perf_sample *sample,
-			       struct symbol **parent)
-
-{
-	int ret;
-
-	callchain_cursor_reset(&callchain_cursor);
-
-	ret = machine__resolve_callchain_sample(machine, thread,
-						sample->callchain, parent);
-	if (ret)
-		return ret;
-
-	/* Can we do dwarf post unwind? */
-	if (!((evsel->attr.sample_type & PERF_SAMPLE_REGS_USER) &&
-	      (evsel->attr.sample_type & PERF_SAMPLE_STACK_USER)))
-		return 0;
-
-	/* Bail out if nothing was captured. */
-	if ((!sample->user_regs.regs) ||
-	    (!sample->user_stack.size))
-		return 0;
-
-	return unwind__get_entries(unwind_entry, &callchain_cursor, machine,
-				   thread, evsel->attr.sample_regs_user,
-				   sample);
-
-}
-
 static int process_event_synth_tracing_data_stub(union perf_event *event
 						 __maybe_unused,
 						 struct perf_session *session
diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index e5ba984..2960284 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -28,8 +28,8 @@ static int dso__load_kernel_sym(struct dso *dso, struct map *map,
 				symbol_filter_t filter);
 static int dso__load_guest_kernel_sym(struct dso *dso, struct map *map,
 			symbol_filter_t filter);
-static int vmlinux_path__nr_entries;
-static char **vmlinux_path;
+int vmlinux_path__nr_entries;
+char **vmlinux_path;
 
 struct symbol_conf symbol_conf = {
 	.exclude_other	  = true,
@@ -202,13 +202,6 @@ void __map_groups__fixup_end(struct map_groups *mg, enum map_type type)
 	curr->end = ~0ULL;
 }
 
-static void map_groups__fixup_end(struct map_groups *mg)
-{
-	int i;
-	for (i = 0; i < MAP__NR_TYPES; ++i)
-		__map_groups__fixup_end(mg, i);
-}
-
 struct symbol *symbol__new(u64 start, u64 len, u8 binding, const char *name)
 {
 	size_t namelen = strlen(name) + 1;
@@ -652,8 +645,8 @@ discard_symbol:		rb_erase(&pos->rb_node, root);
 	return count + moved;
 }
 
-static bool symbol__restricted_filename(const char *filename,
-					const char *restricted_filename)
+bool symbol__restricted_filename(const char *filename,
+				 const char *restricted_filename)
 {
 	bool restricted = false;
 
@@ -887,200 +880,6 @@ struct map *map_groups__find_by_name(struct map_groups *mg,
 	return NULL;
 }
 
-static int map_groups__set_modules_path_dir(struct map_groups *mg,
-				const char *dir_name)
-{
-	struct dirent *dent;
-	DIR *dir = opendir(dir_name);
-	int ret = 0;
-
-	if (!dir) {
-		pr_debug("%s: cannot open %s dir\n", __func__, dir_name);
-		return -1;
-	}
-
-	while ((dent = readdir(dir)) != NULL) {
-		char path[PATH_MAX];
-		struct stat st;
-
-		/*sshfs might return bad dent->d_type, so we have to stat*/
-		snprintf(path, sizeof(path), "%s/%s", dir_name, dent->d_name);
-		if (stat(path, &st))
-			continue;
-
-		if (S_ISDIR(st.st_mode)) {
-			if (!strcmp(dent->d_name, ".") ||
-			    !strcmp(dent->d_name, ".."))
-				continue;
-
-			ret = map_groups__set_modules_path_dir(mg, path);
-			if (ret < 0)
-				goto out;
-		} else {
-			char *dot = strrchr(dent->d_name, '.'),
-			     dso_name[PATH_MAX];
-			struct map *map;
-			char *long_name;
-
-			if (dot == NULL || strcmp(dot, ".ko"))
-				continue;
-			snprintf(dso_name, sizeof(dso_name), "[%.*s]",
-				 (int)(dot - dent->d_name), dent->d_name);
-
-			strxfrchar(dso_name, '-', '_');
-			map = map_groups__find_by_name(mg, MAP__FUNCTION,
-						       dso_name);
-			if (map == NULL)
-				continue;
-
-			long_name = strdup(path);
-			if (long_name == NULL) {
-				ret = -1;
-				goto out;
-			}
-			dso__set_long_name(map->dso, long_name);
-			map->dso->lname_alloc = 1;
-			dso__kernel_module_get_build_id(map->dso, "");
-		}
-	}
-
-out:
-	closedir(dir);
-	return ret;
-}
-
-static char *get_kernel_version(const char *root_dir)
-{
-	char version[PATH_MAX];
-	FILE *file;
-	char *name, *tmp;
-	const char *prefix = "Linux version ";
-
-	sprintf(version, "%s/proc/version", root_dir);
-	file = fopen(version, "r");
-	if (!file)
-		return NULL;
-
-	version[0] = '\0';
-	tmp = fgets(version, sizeof(version), file);
-	fclose(file);
-
-	name = strstr(version, prefix);
-	if (!name)
-		return NULL;
-	name += strlen(prefix);
-	tmp = strchr(name, ' ');
-	if (tmp)
-		*tmp = '\0';
-
-	return strdup(name);
-}
-
-static int machine__set_modules_path(struct machine *machine)
-{
-	char *version;
-	char modules_path[PATH_MAX];
-
-	version = get_kernel_version(machine->root_dir);
-	if (!version)
-		return -1;
-
-	snprintf(modules_path, sizeof(modules_path), "%s/lib/modules/%s/kernel",
-		 machine->root_dir, version);
-	free(version);
-
-	return map_groups__set_modules_path_dir(&machine->kmaps, modules_path);
-}
-
-struct map *machine__new_module(struct machine *machine, u64 start,
-				const char *filename)
-{
-	struct map *map;
-	struct dso *dso = __dsos__findnew(&machine->kernel_dsos, filename);
-
-	if (dso == NULL)
-		return NULL;
-
-	map = map__new2(start, dso, MAP__FUNCTION);
-	if (map == NULL)
-		return NULL;
-
-	if (machine__is_host(machine))
-		dso->symtab_type = DSO_BINARY_TYPE__SYSTEM_PATH_KMODULE;
-	else
-		dso->symtab_type = DSO_BINARY_TYPE__GUEST_KMODULE;
-	map_groups__insert(&machine->kmaps, map);
-	return map;
-}
-
-static int machine__create_modules(struct machine *machine)
-{
-	char *line = NULL;
-	size_t n;
-	FILE *file;
-	struct map *map;
-	const char *modules;
-	char path[PATH_MAX];
-
-	if (machine__is_default_guest(machine))
-		modules = symbol_conf.default_guest_modules;
-	else {
-		sprintf(path, "%s/proc/modules", machine->root_dir);
-		modules = path;
-	}
-
-	if (symbol__restricted_filename(path, "/proc/modules"))
-		return -1;
-
-	file = fopen(modules, "r");
-	if (file == NULL)
-		return -1;
-
-	while (!feof(file)) {
-		char name[PATH_MAX];
-		u64 start;
-		char *sep;
-		int line_len;
-
-		line_len = getline(&line, &n, file);
-		if (line_len < 0)
-			break;
-
-		if (!line)
-			goto out_failure;
-
-		line[--line_len] = '\0'; /* \n */
-
-		sep = strrchr(line, 'x');
-		if (sep == NULL)
-			continue;
-
-		hex2u64(sep + 1, &start);
-
-		sep = strchr(line, ' ');
-		if (sep == NULL)
-			continue;
-
-		*sep = '\0';
-
-		snprintf(name, sizeof(name), "[%s]", line);
-		map = machine__new_module(machine, start, name);
-		if (map == NULL)
-			goto out_delete_line;
-		dso__kernel_module_get_build_id(map->dso, machine->root_dir);
-	}
-
-	free(line);
-	fclose(file);
-
-	return machine__set_modules_path(machine);
-
-out_delete_line:
-	free(line);
-out_failure:
-	return -1;
-}
-
 int dso__load_vmlinux(struct dso *dso, struct map *map,
 		      const char *vmlinux, symbol_filter_t filter)
 {
@@ -1300,195 +1099,6 @@ out_try_fixup:
 	return err;
 }
 
-size_t machines__fprintf_dsos(struct rb_root *machines, FILE *fp)
-{
-	struct rb_node *nd;
-	size_t ret = 0;
-
-	for (nd = rb_first(machines); nd; nd = rb_next(nd)) {
-		struct machine *pos = rb_entry(nd, struct machine, rb_node);
-		ret += __dsos__fprintf(&pos->kernel_dsos, fp);
-		ret += __dsos__fprintf(&pos->user_dsos, fp);
-	}
-
-	return ret;
-}
-
-size_t machine__fprintf_dsos_buildid(struct machine *machine, FILE *fp,
-				     bool (skip)(struct dso *dso, int parm), int parm)
-{
-	return __dsos__fprintf_buildid(&machine->kernel_dsos, fp, skip, parm) +
-	       __dsos__fprintf_buildid(&machine->user_dsos, fp, skip, parm);
-}
-
-size_t machines__fprintf_dsos_buildid(struct rb_root *machines, FILE *fp,
-				     bool (skip)(struct dso *dso, int parm), int parm)
-{
-	struct rb_node *nd;
-	size_t ret = 0;
-
-	for (nd = rb_first(machines); nd; nd = rb_next(nd)) {
-		struct machine *pos = rb_entry(nd, struct machine, rb_node);
-		ret += machine__fprintf_dsos_buildid(pos, fp, skip, parm);
-	}
-	return ret;
-}
-
-static struct dso *machine__get_kernel(struct machine *machine)
-{
-	const char *vmlinux_name = NULL;
-	struct dso *kernel;
-
-	if (machine__is_host(machine)) {
-		vmlinux_name = symbol_conf.vmlinux_name;
-		if (!vmlinux_name)
-			vmlinux_name = "[kernel.kallsyms]";
-
-		kernel = dso__kernel_findnew(machine, vmlinux_name,
-					     "[kernel]",
-					     DSO_TYPE_KERNEL);
-	} else {
-		char bf[PATH_MAX];
-
-		if (machine__is_default_guest(machine))
-			vmlinux_name = symbol_conf.default_guest_vmlinux_name;
-		if (!vmlinux_name)
-			vmlinux_name = machine__mmap_name(machine, bf,
-							  sizeof(bf));
-
-		kernel = dso__kernel_findnew(machine, vmlinux_name,
-					     "[guest.kernel]",
-					     DSO_TYPE_GUEST_KERNEL);
-	}
-
-	if (kernel != NULL && (!kernel->has_build_id))
-		dso__read_running_kernel_build_id(kernel, machine);
-
-	return kernel;
-}
-
-struct process_args {
-	u64 start;
-};
-
-static int symbol__in_kernel(void *arg, const char *name,
-			     char type __maybe_unused, u64 start)
-{
-	struct process_args *args = arg;
-
-	if (strchr(name, '['))
-		return 0;
-
-	args->start = start;
-	return 1;
-}
-
-/* Figure out the start address of kernel map from /proc/kallsyms */
-static u64 machine__get_kernel_start_addr(struct machine *machine)
-{
-	const char *filename;
-	char path[PATH_MAX];
-	struct process_args args;
-
-	if (machine__is_host(machine)) {
-		filename = "/proc/kallsyms";
-	} else {
-		if (machine__is_default_guest(machine))
-			filename = (char *)symbol_conf.default_guest_kallsyms;
-		else {
-			sprintf(path, "%s/proc/kallsyms", machine->root_dir);
-			filename = path;
-		}
-	}
-
-	if (symbol__restricted_filename(filename, "/proc/kallsyms"))
-		return 0;
-
-	if (kallsyms__parse(filename, &args, symbol__in_kernel) <= 0)
-		return 0;
-
-	return args.start;
-}
-
-int __machine__create_kernel_maps(struct machine *machine, struct dso *kernel)
-{
-	enum map_type type;
-	u64 start = machine__get_kernel_start_addr(machine);
-
-	for (type = 0; type < MAP__NR_TYPES; ++type) {
-		struct kmap *kmap;
-
-		machine->vmlinux_maps[type] = map__new2(start, kernel, type);
-		if (machine->vmlinux_maps[type] == NULL)
-			return -1;
-
-		machine->vmlinux_maps[type]->map_ip =
-			machine->vmlinux_maps[type]->unmap_ip =
-				identity__map_ip;
-		kmap = map__kmap(machine->vmlinux_maps[type]);
-		kmap->kmaps = &machine->kmaps;
-		map_groups__insert(&machine->kmaps,
-				   machine->vmlinux_maps[type]);
-	}
-
-	return 0;
-}
-
-void machine__destroy_kernel_maps(struct machine *machine)
-{
-	enum map_type type;
-
-	for (type = 0; type < MAP__NR_TYPES; ++type) {
-		struct kmap *kmap;
-
-		if (machine->vmlinux_maps[type] == NULL)
-			continue;
-
-		kmap = map__kmap(machine->vmlinux_maps[type]);
-		map_groups__remove(&machine->kmaps,
-				   machine->vmlinux_maps[type]);
-		if (kmap->ref_reloc_sym) {
-			/*
-			 * ref_reloc_sym is shared among all maps, so free just
-			 * on one of them.
-			 */
-			if (type == MAP__FUNCTION) {
-				free((char *)kmap->ref_reloc_sym->name);
-				kmap->ref_reloc_sym->name = NULL;
-				free(kmap->ref_reloc_sym);
-			}
-			kmap->ref_reloc_sym = NULL;
-		}
-
-		map__delete(machine->vmlinux_maps[type]);
-		machine->vmlinux_maps[type] = NULL;
-	}
-}
-
-int machine__create_kernel_maps(struct machine *machine)
-{
-	struct dso *kernel = machine__get_kernel(machine);
-
-	if (kernel == NULL ||
-	    __machine__create_kernel_maps(machine, kernel) < 0)
-		return -1;
-
-	if (symbol_conf.use_modules && machine__create_modules(machine) < 0) {
-		if (machine__is_host(machine))
-			pr_debug("Problems creating module maps, "
-				 "continuing anyway...\n");
-		else
-			pr_debug("Problems creating module maps for guest %d, "
-				 "continuing anyway...\n", machine->pid);
-	}
-
-	/*
-	 * Now that we have all the maps created, just set the ->end of them:
-	 */
-	map_groups__fixup_end(&machine->kmaps);
-	return 0;
-}
-
 static void vmlinux_path__exit(void)
 {
 	while (--vmlinux_path__nr_entries >= 0) {
@@ -1549,25 +1159,6 @@ out_fail:
 	return -1;
 }
 
-size_t machine__fprintf_vmlinux_path(struct machine *machine, FILE *fp)
-{
-	int i;
-	size_t printed = 0;
-	struct dso *kdso = machine->vmlinux_maps[MAP__FUNCTION]->dso;
-
-	if (kdso->has_build_id) {
-		char filename[PATH_MAX];
-		if (dso__build_id_filename(kdso, filename, sizeof(filename)))
-			printed += fprintf(fp, "[0] %s\n", filename);
-	}
-
-	for (i = 0; i < vmlinux_path__nr_entries; ++i)
-		printed += fprintf(fp, "[%d] %s\n",
-				   i + kdso->has_build_id, vmlinux_path[i]);
-
-	return printed;
-}
-
 static int setup_list(struct strlist **list, const char *list_str,
 		      const char *list_name)
 {
@@ -1671,108 +1262,3 @@ void symbol__exit(void)
 	symbol_conf.sym_list = symbol_conf.dso_list = symbol_conf.comm_list = NULL;
 	symbol_conf.initialized = false;
 }
-
-int machines__create_kernel_maps(struct rb_root *machines, pid_t pid)
-{
-	struct machine *machine = machines__findnew(machines, pid);
-
-	if (machine == NULL)
-		return -1;
-
-	return machine__create_kernel_maps(machine);
-}
-
-int machines__create_guest_kernel_maps(struct rb_root *machines)
-{
-	int ret = 0;
-	struct dirent **namelist = NULL;
-	int i, items = 0;
-	char path[PATH_MAX];
-	pid_t pid;
-	char *endp;
-
-	if (symbol_conf.default_guest_vmlinux_name ||
-	    symbol_conf.default_guest_modules ||
-	    symbol_conf.default_guest_kallsyms) {
-		machines__create_kernel_maps(machines, DEFAULT_GUEST_KERNEL_ID);
-	}
-
-	if (symbol_conf.guestmount) {
-		items = scandir(symbol_conf.guestmount, &namelist, NULL, NULL);
-		if (items <= 0)
-			return -ENOENT;
-		for (i = 0; i < items; i++) {
-			if (!isdigit(namelist[i]->d_name[0])) {
-				/* Filter out . and .. */
-				continue;
-			}
-			pid = (pid_t)strtol(namelist[i]->d_name, &endp, 10);
-			if ((*endp != '\0') ||
-			    (endp == namelist[i]->d_name) ||
-			    (errno == ERANGE)) {
-				pr_debug("invalid directory (%s). Skipping.\n",
-					 namelist[i]->d_name);
-				continue;
-			}
-			sprintf(path, "%s/%s/proc/kallsyms",
-				symbol_conf.guestmount,
-				namelist[i]->d_name);
-			ret = access(path, R_OK);
-			if (ret) {
-				pr_debug("Can't access file %s\n", path);
-				goto failure;
-			}
-			machines__create_kernel_maps(machines, pid);
-		}
-failure:
-		free(namelist);
-	}
-
-	return ret;
-}
-
-void machines__destroy_guest_kernel_maps(struct rb_root *machines)
-{
-	struct rb_node *next = rb_first(machines);
-
-	while (next) {
-		struct machine *pos = rb_entry(next, struct machine, rb_node);
-
-		next = rb_next(&pos->rb_node);
-		rb_erase(&pos->rb_node, machines);
-		machine__delete(pos);
-	}
-}
-
-int machine__load_kallsyms(struct machine *machine, const char *filename,
-			   enum map_type type, symbol_filter_t filter)
-{
-	struct map *map = machine->vmlinux_maps[type];
-	int ret = dso__load_kallsyms(map->dso, filename, map, filter);
-
-	if (ret > 0) {
-		dso__set_loaded(map->dso, type);
-		/*
-		 * Since /proc/kallsyms will have multiple sessions for the
-		 * kernel, with modules between them, fixup the end of all
-		 * sections.
-		 */
-		__map_groups__fixup_end(&machine->kmaps, type);
-	}
-
-	return ret;
-}
-
-int machine__load_vmlinux_path(struct machine *machine, enum map_type type,
-			       symbol_filter_t filter)
-{
-	struct map *map = machine->vmlinux_maps[type];
-	int ret = dso__load_vmlinux_path(map->dso, map, filter);
-
-	if (ret > 0) {
-		dso__set_loaded(map->dso, type);
-		map__reloc_vmlinux(map);
-	}
-
-	return ret;
-}
diff --git a/tools/perf/util/symbol.h b/tools/perf/util/symbol.h
index de68f98..ec7b240 100644
--- a/tools/perf/util/symbol.h
+++ b/tools/perf/util/symbol.h
@@ -120,6 +120,8 @@ struct symbol_conf {
 };
 
 extern struct symbol_conf symbol_conf;
+extern int vmlinux_path__nr_entries;
+extern char **vmlinux_path;
 
 static inline void *symbol__priv(struct symbol *sym)
 {
@@ -223,6 +225,8 @@ size_t symbol__fprintf_symname_offs(const struct symbol *sym,
 size_t symbol__fprintf_symname(const struct symbol *sym, FILE *fp);
 size_t symbol__fprintf(struct symbol *sym, FILE *fp);
 bool symbol_type__is_a(char symbol_type, enum map_type map_type);
+bool symbol__restricted_filename(const char *filename,
+				 const char *restricted_filename);
 
 int dso__load_sym(struct dso *dso, struct map *map, struct symsrc *syms_ss,
 		  struct symsrc *runtime_ss, symbol_filter_t filter,
diff --git a/tools/perf/util/thread.c b/tools/perf/util/thread.c
index df59623..632e40e 100644
--- a/tools/perf/util/thread.c
+++ b/tools/perf/util/thread.c
@@ -54,10 +54,10 @@ int thread__comm_len(struct thread *self)
 	return self->comm_len;
 }
 
-static size_t thread__fprintf(struct thread *self, FILE *fp)
+size_t thread__fprintf(struct thread *thread, FILE *fp)
 {
-	return fprintf(fp, "Thread %d %s\n", self->pid, self->comm) +
-	       map_groups__fprintf(&self->mg, verbose, fp);
+	return fprintf(fp, "Thread %d %s\n", thread->pid, thread->comm) +
+	       map_groups__fprintf(&thread->mg, verbose, fp);
 }
 
 void thread__insert_map(struct thread *self, struct map *map)
@@ -84,17 +84,3 @@ int thread__fork(struct thread *self, struct thread *parent)
 			return -ENOMEM;
 	return 0;
 }
-
-size_t machine__fprintf(struct machine *machine, FILE *fp)
-{
-	size_t ret = 0;
-	struct rb_node *nd;
-
-	for (nd = rb_first(&machine->threads); nd; nd = rb_next(nd)) {
-		struct thread *pos = rb_entry(nd, struct thread, rb_node);
-
-		ret += thread__fprintf(pos, fp);
-	}
-
-	return ret;
-}
diff --git a/tools/perf/util/thread.h b/tools/perf/util/thread.h
index f2fa17c..5ad2664 100644
--- a/tools/perf/util/thread.h
+++ b/tools/perf/util/thread.h
@@ -30,6 +30,7 @@ int thread__set_comm(struct thread *self, const char *comm);
 int thread__comm_len(struct thread *self);
 void thread__insert_map(struct thread *self, struct map *map);
 int thread__fork(struct thread *self, struct thread *parent);
+size_t thread__fprintf(struct thread *thread, FILE *fp);
 
 static inline struct map *thread__find_map(struct thread *self,
 					   enum map_type type, u64 addr)
-- 
1.7.9.2.358.g22243

