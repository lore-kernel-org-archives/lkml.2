Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757080Ab0D1BxB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Apr 2010 21:53:01 -0400
Received: from casper.infradead.org ([85.118.1.10]:40904 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756802Ab0D1Bw4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Apr 2010 21:52:56 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
       Avi Kivity <avi@redhat.com>,
       =?utf-8?q?Fr=C3=A9d=C3=A9ric=20Weisbecker?= <fweisbec@gmail.com>,
       Masami Hiramatsu <mhiramat@redhat.com>, Mike Galbraith <efault@gmx.de>,
       Paul Mackerras <paulus@samba.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
Subject: [PATCH 3/5] perf machine: Adopt some map_groups functions
Date: Tue, 27 Apr 2010 22:52:38 -0300
Message-Id: <1272419560-4332-4-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1272419560-4332-1-git-send-email-acme@infradead.org>
References: <1272419560-4332-1-git-send-email-acme@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

Those functions operated on members now grouped in 'struct machine', so
move those methods to this new class.

The changes made to 'perf probe' shows that using this abstraction
inserting probes on guests almost got supported for free.

Cc: Avi Kivity <avi@redhat.com>
Cc: Frédéric Weisbecker <fweisbec@gmail.com>
Cc: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Zhang, Yanmin <yanmin_zhang@linux.intel.com>
LKML-Reference: <new-submission>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-kmem.c     |    4 +--
 tools/perf/util/event.c       |    9 ++---
 tools/perf/util/map.c         |   24 ++++++++++----
 tools/perf/util/map.h         |   12 +++---
 tools/perf/util/probe-event.c |   20 ++++++-----
 tools/perf/util/session.c     |    7 ++--
 tools/perf/util/symbol.c      |   71 +++++++++++++++++-----------------------
 tools/perf/util/symbol.h      |    8 ++---
 8 files changed, 74 insertions(+), 81 deletions(-)

diff --git a/tools/perf/builtin-kmem.c b/tools/perf/builtin-kmem.c
index 2067475..1563561 100644
--- a/tools/perf/builtin-kmem.c
+++ b/tools/perf/builtin-kmem.c
@@ -370,7 +370,6 @@ static void __print_result(struct rb_root *root, struct perf_session *session,
 		struct alloc_stat *data = rb_entry(next, struct alloc_stat,
 						   node);
 		struct symbol *sym = NULL;
-		struct map_groups *kmaps = &machine->kmaps;
 		struct map *map;
 		char buf[BUFSIZ];
 		u64 addr;
@@ -378,8 +377,7 @@ static void __print_result(struct rb_root *root, struct perf_session *session,
 		if (is_caller) {
 			addr = data->call_site;
 			if (!raw_ip)
-				sym = map_groups__find_function(kmaps, addr,
-								&map, NULL);
+				sym = machine__find_function(machine, addr, &map, NULL);
 		} else
 			addr = data->ptr;
 
diff --git a/tools/perf/util/event.c b/tools/perf/util/event.c
index 7400e51..1757b0f 100644
--- a/tools/perf/util/event.c
+++ b/tools/perf/util/event.c
@@ -429,9 +429,8 @@ static int event__process_kernel_mmap(event_t *self,
 		} else
 			strcpy(short_module_name, self->mmap.filename);
 
-		map = map_groups__new_module(&machine->kmaps,
-					     self->mmap.start,
-					     self->mmap.filename, machine);
+		map = machine__new_module(machine, self->mmap.start,
+					  self->mmap.filename);
 		if (map == NULL)
 			goto out_problem;
 
@@ -454,9 +453,7 @@ static int event__process_kernel_mmap(event_t *self,
 			goto out_problem;
 
 		kernel->kernel = kernel_type;
-		if (__map_groups__create_kernel_maps(&machine->kmaps,
-						     machine->vmlinux_maps,
-						     kernel) < 0)
+		if (__machine__create_kernel_maps(machine, kernel) < 0)
 			goto out_problem;
 
 		event_set_kernel_mmap_len(machine->vmlinux_maps, self);
diff --git a/tools/perf/util/map.c b/tools/perf/util/map.c
index ee25ee9..44a4df6 100644
--- a/tools/perf/util/map.c
+++ b/tools/perf/util/map.c
@@ -513,6 +513,19 @@ struct map *maps__find(struct rb_root *maps, u64 ip)
 	return NULL;
 }
 
+int machine__init(struct machine *self, const char *root_dir, pid_t pid)
+{
+	map_groups__init(&self->kmaps);
+	RB_CLEAR_NODE(&self->rb_node);
+	INIT_LIST_HEAD(&self->user_dsos);
+	INIT_LIST_HEAD(&self->kernel_dsos);
+
+	self->kmaps.machine = self;
+	self->pid	    = pid;
+	self->root_dir      = strdup(root_dir);
+	return self->root_dir == NULL ? -ENOMEM : 0;
+}
+
 struct machine *machines__add(struct rb_root *self, pid_t pid,
 			      const char *root_dir)
 {
@@ -523,13 +536,10 @@ struct machine *machines__add(struct rb_root *self, pid_t pid,
 	if (!machine)
 		return NULL;
 
-	machine->pid = pid;
-	map_groups__init(&machine->kmaps);
-	machine->root_dir = strdup(root_dir);
-	RB_CLEAR_NODE(&machine->rb_node);
-	INIT_LIST_HEAD(&machine->user_dsos);
-	INIT_LIST_HEAD(&machine->kernel_dsos);
-	machine->kmaps.machine = machine;
+	if (machine__init(machine, root_dir, pid) != 0) {
+		free(machine);
+		return NULL;
+	}
 
 	while (*p != NULL) {
 		parent = *p;
diff --git a/tools/perf/util/map.h b/tools/perf/util/map.h
index 6fabad1..881dba4 100644
--- a/tools/perf/util/map.h
+++ b/tools/perf/util/map.h
@@ -134,6 +134,7 @@ struct machine *machines__find_host(struct rb_root *self);
 struct machine *machines__find(struct rb_root *self, pid_t pid);
 struct machine *machines__findnew(struct rb_root *self, pid_t pid);
 char *machine__mmap_name(struct machine *self, char *bf, size_t size);
+int machine__init(struct machine *self, const char *root_dir, pid_t pid);
 
 /*
  * Default guest kernel is defined by parameter --guestkallsyms
@@ -172,11 +173,11 @@ struct symbol *map_groups__find_symbol_by_name(struct map_groups *self,
 					       struct map **mapp,
 					       symbol_filter_t filter);
 
-static inline
-struct symbol *map_groups__find_function(struct map_groups *self, u64 addr,
-					 struct map **mapp, symbol_filter_t filter)
+static inline struct symbol *machine__find_function(struct machine *self,
+						    u64 addr, struct map **mapp,
+						    symbol_filter_t filter)
 {
-	return map_groups__find_symbol(self, MAP__FUNCTION, addr, mapp, filter);
+	return map_groups__find_symbol(&self->kmaps, MAP__FUNCTION, addr, mapp, filter);
 }
 
 static inline
@@ -192,8 +193,7 @@ int map_groups__fixup_overlappings(struct map_groups *self, struct map *map,
 
 struct map *map_groups__find_by_name(struct map_groups *self,
 				     enum map_type type, const char *name);
-struct map *map_groups__new_module(struct map_groups *self, u64 start,
-				   const char *filename, struct machine *machine);
+struct map *machine__new_module(struct machine *self, u64 start, const char *filename);
 
 void map_groups__flush(struct map_groups *self);
 
diff --git a/tools/perf/util/probe-event.c b/tools/perf/util/probe-event.c
index 9ded38c..914c670 100644
--- a/tools/perf/util/probe-event.c
+++ b/tools/perf/util/probe-event.c
@@ -72,8 +72,7 @@ static int e_snprintf(char *str, size_t size, const char *format, ...)
 }
 
 static char *synthesize_perf_probe_point(struct perf_probe_point *pp);
-static struct map_groups kmap_groups;
-static struct map *kmaps[MAP__NR_TYPES];
+static struct machine machine;
 
 /* Initialize symbol maps and path of vmlinux */
 static int init_vmlinux(void)
@@ -92,12 +91,15 @@ static int init_vmlinux(void)
 		goto out;
 	}
 
+	ret = machine__init(&machine, "/", 0);
+	if (ret < 0)
+		goto out;
+
 	kernel = dso__new_kernel(symbol_conf.vmlinux_name);
 	if (kernel == NULL)
 		die("Failed to create kernel dso.");
 
-	map_groups__init(&kmap_groups);
-	ret = __map_groups__create_kernel_maps(&kmap_groups, kmaps, kernel);
+	ret = __machine__create_kernel_maps(&machine, kernel);
 	if (ret < 0)
 		pr_debug("Failed to create kernel maps.\n");
 
@@ -110,12 +112,12 @@ out:
 #ifdef DWARF_SUPPORT
 static int open_vmlinux(void)
 {
-	if (map__load(kmaps[MAP__FUNCTION], NULL) < 0) {
+	if (map__load(machine.vmlinux_maps[MAP__FUNCTION], NULL) < 0) {
 		pr_debug("Failed to load kernel map.\n");
 		return -EINVAL;
 	}
-	pr_debug("Try to open %s\n", kmaps[MAP__FUNCTION]->dso->long_name);
-	return open(kmaps[MAP__FUNCTION]->dso->long_name, O_RDONLY);
+	pr_debug("Try to open %s\n", machine.vmlinux_maps[MAP__FUNCTION]->dso->long_name);
+	return open(machine.vmlinux_maps[MAP__FUNCTION]->dso->long_name, O_RDONLY);
 }
 
 /* Convert trace point to probe point with debuginfo */
@@ -125,7 +127,7 @@ static int convert_to_perf_probe_point(struct kprobe_trace_point *tp,
 	struct symbol *sym;
 	int fd, ret = -ENOENT;
 
-	sym = map__find_symbol_by_name(kmaps[MAP__FUNCTION],
+	sym = map__find_symbol_by_name(machine.vmlinux_maps[MAP__FUNCTION],
 				       tp->symbol, NULL);
 	if (sym) {
 		fd = open_vmlinux();
@@ -1466,7 +1468,7 @@ static int convert_to_kprobe_trace_events(struct perf_probe_event *pev,
 	}
 
 	/* Currently just checking function name from symbol map */
-	sym = map__find_symbol_by_name(kmaps[MAP__FUNCTION],
+	sym = map__find_symbol_by_name(machine.vmlinux_maps[MAP__FUNCTION],
 				       tev->point.symbol, NULL);
 	if (!sym) {
 		pr_warning("Kernel symbol \'%s\' not found.\n",
diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index b745c1c..a8dd73e 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -69,12 +69,11 @@ void perf_session__update_sample_type(struct perf_session *self)
 
 int perf_session__create_kernel_maps(struct perf_session *self)
 {
-	int ret;
-	struct rb_root *root = &self->machines;
+	struct rb_root *machines = &self->machines;
+	int ret = machines__create_kernel_maps(machines, HOST_KERNEL_ID);
 
-	ret = map_groups__create_kernel_maps(root, HOST_KERNEL_ID);
 	if (ret >= 0)
-		ret = map_groups__create_guest_kernel_maps(root);
+		ret = machines__create_guest_kernel_maps(machines);
 	return ret;
 }
 
diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index c9c0bdd..12359c3 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -1528,21 +1528,20 @@ static char *get_kernel_version(const char *root_dir)
 	return strdup(name);
 }
 
-static int map_groups__set_modules_path(struct map_groups *self,
-				const char *root_dir)
+static int machine__set_modules_path(struct machine *self)
 {
 	char *version;
 	char modules_path[PATH_MAX];
 
-	version = get_kernel_version(root_dir);
+	version = get_kernel_version(self->root_dir);
 	if (!version)
 		return -1;
 
 	snprintf(modules_path, sizeof(modules_path), "%s/lib/modules/%s/kernel",
-		 root_dir, version);
+		 self->root_dir, version);
 	free(version);
 
-	return map_groups__set_modules_path_dir(self, modules_path);
+	return map_groups__set_modules_path_dir(&self->kmaps, modules_path);
 }
 
 /*
@@ -1564,14 +1563,12 @@ static struct map *map__new2(u64 start, struct dso *dso, enum map_type type)
 	return self;
 }
 
-struct map *map_groups__new_module(struct map_groups *self, u64 start,
-				const char *filename,
-				struct machine *machine)
+struct map *machine__new_module(struct machine *self, u64 start,
+				const char *filename)
 {
 	struct map *map;
-	struct dso *dso;
+	struct dso *dso = __dsos__findnew(&self->kernel_dsos, filename);
 
-	dso = __dsos__findnew(&machine->kernel_dsos, filename);
 	if (dso == NULL)
 		return NULL;
 
@@ -1579,28 +1576,27 @@ struct map *map_groups__new_module(struct map_groups *self, u64 start,
 	if (map == NULL)
 		return NULL;
 
-	if (machine__is_host(machine))
+	if (machine__is_host(self))
 		dso->origin = DSO__ORIG_KMODULE;
 	else
 		dso->origin = DSO__ORIG_GUEST_KMODULE;
-	map_groups__insert(self, map);
+	map_groups__insert(&self->kmaps, map);
 	return map;
 }
 
-static int map_groups__create_modules(struct machine *machine)
+static int machine__create_modules(struct machine *self)
 {
 	char *line = NULL;
 	size_t n;
 	FILE *file;
 	struct map *map;
-	const char *root_dir;
 	const char *modules;
 	char path[PATH_MAX];
 
-	if (machine__is_default_guest(machine))
+	if (machine__is_default_guest(self))
 		modules = symbol_conf.default_guest_modules;
 	else {
-		sprintf(path, "%s/proc/modules", machine->root_dir);
+		sprintf(path, "%s/proc/modules", self->root_dir);
 		modules = path;
 	}
 
@@ -1608,8 +1604,6 @@ static int map_groups__create_modules(struct machine *machine)
 	if (file == NULL)
 		return -1;
 
-	root_dir = machine->root_dir;
-
 	while (!feof(file)) {
 		char name[PATH_MAX];
 		u64 start;
@@ -1638,17 +1632,16 @@ static int map_groups__create_modules(struct machine *machine)
 		*sep = '\0';
 
 		snprintf(name, sizeof(name), "[%s]", line);
-		map = map_groups__new_module(&machine->kmaps, start,
-					     name, machine);
+		map = machine__new_module(self, start, name);
 		if (map == NULL)
 			goto out_delete_line;
-		dso__kernel_module_get_build_id(map->dso, root_dir);
+		dso__kernel_module_get_build_id(map->dso, self->root_dir);
 	}
 
 	free(line);
 	fclose(file);
 
-	return map_groups__set_modules_path(&machine->kmaps, root_dir);
+	return machine__set_modules_path(self);
 
 out_delete_line:
 	free(line);
@@ -2005,25 +1998,23 @@ static struct dso *dsos__create_kernel(struct machine *machine)
 	return kernel;
 }
 
-int __map_groups__create_kernel_maps(struct map_groups *self,
-				     struct map *vmlinux_maps[MAP__NR_TYPES],
-				     struct dso *kernel)
+int __machine__create_kernel_maps(struct machine *self, struct dso *kernel)
 {
 	enum map_type type;
 
 	for (type = 0; type < MAP__NR_TYPES; ++type) {
 		struct kmap *kmap;
 
-		vmlinux_maps[type] = map__new2(0, kernel, type);
-		if (vmlinux_maps[type] == NULL)
+		self->vmlinux_maps[type] = map__new2(0, kernel, type);
+		if (self->vmlinux_maps[type] == NULL)
 			return -1;
 
-		vmlinux_maps[type]->map_ip =
-			vmlinux_maps[type]->unmap_ip = identity__map_ip;
+		self->vmlinux_maps[type]->map_ip =
+			self->vmlinux_maps[type]->unmap_ip = identity__map_ip;
 
-		kmap = map__kmap(vmlinux_maps[type]);
-		kmap->kmaps = self;
-		map_groups__insert(self, vmlinux_maps[type]);
+		kmap = map__kmap(self->vmlinux_maps[type]);
+		kmap->kmaps = &self->kmaps;
+		map_groups__insert(&self->kmaps, self->vmlinux_maps[type]);
 	}
 
 	return 0;
@@ -2145,10 +2136,10 @@ out_free_comm_list:
 	return -1;
 }
 
-int map_groups__create_kernel_maps(struct rb_root *machines, pid_t pid)
+int machines__create_kernel_maps(struct rb_root *self, pid_t pid)
 {
 	struct dso *kernel;
-	struct machine *machine = machines__findnew(machines, pid);
+	struct machine *machine = machines__findnew(self, pid);
 
 	if (machine == NULL)
 		return -1;
@@ -2156,12 +2147,10 @@ int map_groups__create_kernel_maps(struct rb_root *machines, pid_t pid)
 	if (kernel == NULL)
 		return -1;
 
-	if (__map_groups__create_kernel_maps(&machine->kmaps,
-					     machine->vmlinux_maps, kernel) < 0)
+	if (__machine__create_kernel_maps(machine, kernel) < 0)
 		return -1;
 
-	if (symbol_conf.use_modules &&
-	    map_groups__create_modules(machine) < 0)
+	if (symbol_conf.use_modules && machine__create_modules(machine) < 0)
 		pr_debug("Problems creating module maps, continuing anyway...\n");
 	/*
 	 * Now that we have all the maps created, just set the ->end of them:
@@ -2213,7 +2202,7 @@ char *strxfrchar(char *s, char from, char to)
 	return s;
 }
 
-int map_groups__create_guest_kernel_maps(struct rb_root *machines)
+int machines__create_guest_kernel_maps(struct rb_root *self)
 {
 	int ret = 0;
 	struct dirent **namelist = NULL;
@@ -2224,7 +2213,7 @@ int map_groups__create_guest_kernel_maps(struct rb_root *machines)
 	if (symbol_conf.default_guest_vmlinux_name ||
 	    symbol_conf.default_guest_modules ||
 	    symbol_conf.default_guest_kallsyms) {
-		map_groups__create_kernel_maps(machines, DEFAULT_GUEST_KERNEL_ID);
+		machines__create_kernel_maps(self, DEFAULT_GUEST_KERNEL_ID);
 	}
 
 	if (symbol_conf.guestmount) {
@@ -2245,7 +2234,7 @@ int map_groups__create_guest_kernel_maps(struct rb_root *machines)
 				pr_debug("Can't access file %s\n", path);
 				goto failure;
 			}
-			map_groups__create_kernel_maps(machines, pid);
+			machines__create_kernel_maps(self, pid);
 		}
 failure:
 		free(namelist);
diff --git a/tools/perf/util/symbol.h b/tools/perf/util/symbol.h
index ed885b0..37b717b 100644
--- a/tools/perf/util/symbol.h
+++ b/tools/perf/util/symbol.h
@@ -199,11 +199,9 @@ int kallsyms__parse(const char *filename, void *arg,
 		    int (*process_symbol)(void *arg, const char *name,
 					  char type, u64 start));
 
-int __map_groups__create_kernel_maps(struct map_groups *self,
-			struct map *vmlinux_maps[MAP__NR_TYPES],
-			struct dso *kernel);
-int map_groups__create_kernel_maps(struct rb_root *kerninfo_root, pid_t pid);
-int map_groups__create_guest_kernel_maps(struct rb_root *kerninfo_root);
+int __machine__create_kernel_maps(struct machine *self, struct dso *kernel);
+int machines__create_kernel_maps(struct rb_root *self, pid_t pid);
+int machines__create_guest_kernel_maps(struct rb_root *self);
 
 int symbol__init(void);
 bool symbol_type__is_a(char symbol_type, enum map_type map_type);
-- 
1.6.2.5

