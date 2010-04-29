Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758070Ab0D3Rat (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Apr 2010 13:30:49 -0400
Received: from casper.infradead.org ([85.118.1.10]:42526 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933278Ab0D3RaJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Apr 2010 13:30:09 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
       =?utf-8?q?Fr=C3=A9d=C3=A9ric=20Weisbecker?= <fweisbec@gmail.com>,
       Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 1/2] perf symbols: Add machine helper routines
Date: Thu, 29 Apr 2010 19:14:03 -0300
Message-Id: <1272579244-3981-2-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1272579244-3981-1-git-send-email-acme@infradead.org>
References: <1272579244-3981-1-git-send-email-acme@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

Created when writing the first 'perf test' regression testing routine.

Cc: Frédéric Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <new-submission>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-kmem.c |    2 +-
 tools/perf/util/map.h     |   25 ++++++++++++--
 tools/perf/util/symbol.c  |   77 +++++++++++++++++++++++++++++++++------------
 tools/perf/util/symbol.h  |    7 ++++
 4 files changed, 86 insertions(+), 25 deletions(-)

diff --git a/tools/perf/builtin-kmem.c b/tools/perf/builtin-kmem.c
index 1563561..ee05dba 100644
--- a/tools/perf/builtin-kmem.c
+++ b/tools/perf/builtin-kmem.c
@@ -377,7 +377,7 @@ static void __print_result(struct rb_root *root, struct perf_session *session,
 		if (is_caller) {
 			addr = data->call_site;
 			if (!raw_ip)
-				sym = machine__find_function(machine, addr, &map, NULL);
+				sym = machine__find_kernel_function(machine, addr, &map, NULL);
 		} else
 			addr = data->ptr;
 
diff --git a/tools/perf/util/map.h b/tools/perf/util/map.h
index 881dba4..f391345 100644
--- a/tools/perf/util/map.h
+++ b/tools/perf/util/map.h
@@ -30,6 +30,7 @@ struct map {
 	u64			start;
 	u64			end;
 	enum map_type		type;
+	u32			priv;
 	u64			pgoff;
 
 	/* ip -> dso rip */
@@ -66,6 +67,12 @@ struct machine {
 	struct map	  *vmlinux_maps[MAP__NR_TYPES];
 };
 
+static inline
+struct map *machine__kernel_map(struct machine *self, enum map_type type)
+{
+	return self->vmlinux_maps[type];
+}
+
 static inline struct kmap *map__kmap(struct map *self)
 {
 	return (struct kmap *)(self + 1);
@@ -173,11 +180,21 @@ struct symbol *map_groups__find_symbol_by_name(struct map_groups *self,
 					       struct map **mapp,
 					       symbol_filter_t filter);
 
-static inline struct symbol *machine__find_function(struct machine *self,
-						    u64 addr, struct map **mapp,
-						    symbol_filter_t filter)
+static inline
+struct symbol *machine__find_kernel_symbol(struct machine *self,
+					   enum map_type type, u64 addr,
+					   struct map **mapp,
+					   symbol_filter_t filter)
+{
+	return map_groups__find_symbol(&self->kmaps, type, addr, mapp, filter);
+}
+
+static inline
+struct symbol *machine__find_kernel_function(struct machine *self, u64 addr,
+					     struct map **mapp,
+					     symbol_filter_t filter)
 {
-	return map_groups__find_symbol(&self->kmaps, MAP__FUNCTION, addr, mapp, filter);
+	return machine__find_kernel_symbol(self, MAP__FUNCTION, addr, mapp, filter);
 }
 
 static inline
diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index caa890f..4c0146a 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -1983,23 +1983,23 @@ void dso__read_running_kernel_build_id(struct dso *self, struct machine *machine
 		self->has_build_id = true;
 }
 
-static struct dso *dsos__create_kernel(struct machine *machine)
+static struct dso *machine__create_kernel(struct machine *self)
 {
 	const char *vmlinux_name = NULL;
 	struct dso *kernel;
 
-	if (machine__is_host(machine)) {
+	if (machine__is_host(self)) {
 		vmlinux_name = symbol_conf.vmlinux_name;
 		kernel = dso__new_kernel(vmlinux_name);
 	} else {
-		if (machine__is_default_guest(machine))
+		if (machine__is_default_guest(self))
 			vmlinux_name = symbol_conf.default_guest_vmlinux_name;
-		kernel = dso__new_guest_kernel(machine, vmlinux_name);
+		kernel = dso__new_guest_kernel(self, vmlinux_name);
 	}
 
 	if (kernel != NULL) {
-		dso__read_running_kernel_build_id(kernel, machine);
-		dsos__add(&machine->kernel_dsos, kernel);
+		dso__read_running_kernel_build_id(kernel, self);
+		dsos__add(&self->kernel_dsos, kernel);
 	}
 	return kernel;
 }
@@ -2026,6 +2026,23 @@ int __machine__create_kernel_maps(struct machine *self, struct dso *kernel)
 	return 0;
 }
 
+int machine__create_kernel_maps(struct machine *self)
+{
+	struct dso *kernel = machine__create_kernel(self);
+
+	if (kernel == NULL ||
+	    __machine__create_kernel_maps(self, kernel) < 0)
+		return -1;
+
+	if (symbol_conf.use_modules && machine__create_modules(self) < 0)
+		pr_debug("Problems creating module maps, continuing anyway...\n");
+	/*
+	 * Now that we have all the maps created, just set the ->end of them:
+	 */
+	map_groups__fixup_end(&self->kmaps);
+	return 0;
+}
+
 static void vmlinux_path__exit(void)
 {
 	while (--vmlinux_path__nr_entries >= 0) {
@@ -2144,25 +2161,12 @@ out_free_comm_list:
 
 int machines__create_kernel_maps(struct rb_root *self, pid_t pid)
 {
-	struct dso *kernel;
 	struct machine *machine = machines__findnew(self, pid);
 
 	if (machine == NULL)
 		return -1;
-	kernel = dsos__create_kernel(machine);
-	if (kernel == NULL)
-		return -1;
-
-	if (__machine__create_kernel_maps(machine, kernel) < 0)
-		return -1;
 
-	if (symbol_conf.use_modules && machine__create_modules(machine) < 0)
-		pr_debug("Problems creating module maps, continuing anyway...\n");
-	/*
-	 * Now that we have all the maps created, just set the ->end of them:
-	 */
-	map_groups__fixup_end(&machine->kmaps);
-	return 0;
+	return machine__create_kernel_maps(machine);
 }
 
 static int hex(char ch)
@@ -2248,3 +2252,36 @@ failure:
 
 	return ret;
 }
+
+int machine__load_kallsyms(struct machine *self, const char *filename,
+			   enum map_type type, symbol_filter_t filter)
+{
+	struct map *map = self->vmlinux_maps[type];
+	int ret = dso__load_kallsyms(map->dso, filename, map, filter);
+
+	if (ret > 0) {
+		dso__set_loaded(map->dso, type);
+		/*
+		 * Since /proc/kallsyms will have multiple sessions for the
+		 * kernel, with modules between them, fixup the end of all
+		 * sections.
+		 */
+		__map_groups__fixup_end(&self->kmaps, type);
+	}
+
+	return ret;
+}
+
+int machine__load_vmlinux_path(struct machine *self, enum map_type type,
+			       symbol_filter_t filter)
+{
+	struct map *map = self->vmlinux_maps[type];
+	int ret = dso__load_vmlinux_path(map->dso, map, filter);
+
+	if (ret > 0) {
+		dso__set_loaded(map->dso, type);
+		map__reloc_vmlinux(map);
+	}
+
+	return ret;
+}
diff --git a/tools/perf/util/symbol.h b/tools/perf/util/symbol.h
index 2cec6a1..a517c17 100644
--- a/tools/perf/util/symbol.h
+++ b/tools/perf/util/symbol.h
@@ -162,6 +162,11 @@ int dso__load_vmlinux_path(struct dso *self, struct map *map,
 			   symbol_filter_t filter);
 int dso__load_kallsyms(struct dso *self, const char *filename, struct map *map,
 		       symbol_filter_t filter);
+int machine__load_kallsyms(struct machine *self, const char *filename,
+			   enum map_type type, symbol_filter_t filter);
+int machine__load_vmlinux_path(struct machine *self, enum map_type type,
+			       symbol_filter_t filter);
+
 size_t machines__fprintf_dsos(struct rb_root *self, FILE *fp);
 size_t machines__fprintf_dsos_buildid(struct rb_root *self, FILE *fp, bool with_hits);
 
@@ -199,6 +204,8 @@ int kallsyms__parse(const char *filename, void *arg,
 					  char type, u64 start));
 
 int __machine__create_kernel_maps(struct machine *self, struct dso *kernel);
+int machine__create_kernel_maps(struct machine *self);
+
 int machines__create_kernel_maps(struct rb_root *self, pid_t pid);
 int machines__create_guest_kernel_maps(struct rb_root *self);
 
-- 
1.6.2.5

