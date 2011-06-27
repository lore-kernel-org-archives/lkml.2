Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757654Ab1F1MET (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jun 2011 08:04:19 -0400
Received: from mail7.hitachi.co.jp ([133.145.228.42]:54312 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757480Ab1F1L6K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jun 2011 07:58:10 -0400
X-AuditID: b753bd60-a28c6ba000003bac-3d-4e09c1cf466d
X-AuditID: b753bd60-a28c6ba000003bac-3d-4e09c1cf466d
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Subject: [PATCH -tip 11/13] [RESEND]perf probe: Introduce debuginfo to
 encapsulate dwarf information
To: Steven Rostedt <rostedt@goodmis.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Ingo Molnar <mingo@elte.hu>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        yrl.pp-manager.tt@hitachi.com,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Date: Mon, 27 Jun 2011 16:27:39 +0900
Message-ID: <20110627072739.6528.12438.stgit@fedora15>
In-Reply-To: <20110627072626.6528.41792.stgit@fedora15>
References: <20110627072626.6528.41792.stgit@fedora15>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introduce debuginfo to encapsulate dwarf information.
This new object allows us to reuse and expand debuginfo easily.

Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
---

 tools/perf/util/probe-event.c  |   78 ++++++++++------
 tools/perf/util/probe-finder.c |  201 +++++++++++++++++++++-------------------
 tools/perf/util/probe-finder.h |   39 ++++++--
 3 files changed, 182 insertions(+), 136 deletions(-)

diff --git a/tools/perf/util/probe-event.c b/tools/perf/util/probe-event.c
index f022316..920c195 100644
--- a/tools/perf/util/probe-event.c
+++ b/tools/perf/util/probe-event.c
@@ -170,16 +170,17 @@ const char *kernel_get_module_path(const char *module)
 }
 
 #ifdef DWARF_SUPPORT
-static int open_vmlinux(const char *module)
+/* Open new debuginfo of given module */
+static struct debuginfo *open_debuginfo(const char *module)
 {
 	const char *path = kernel_get_module_path(module);
+
 	if (!path) {
 		pr_err("Failed to find path of %s module.\n",
 		       module ?: "kernel");
-		return -ENOENT;
+		return NULL;
 	}
-	pr_debug("Try to open %s\n", path);
-	return open(path, O_RDONLY);
+	return debuginfo__new(path);
 }
 
 /*
@@ -193,13 +194,24 @@ static int kprobe_convert_to_perf_probe(struct probe_trace_point *tp,
 	struct map *map;
 	u64 addr;
 	int ret = -ENOENT;
+	struct debuginfo *dinfo;
 
 	sym = __find_kernel_function_by_name(tp->symbol, &map);
 	if (sym) {
 		addr = map->unmap_ip(map, sym->start + tp->offset);
 		pr_debug("try to find %s+%ld@%" PRIx64 "\n", tp->symbol,
 			 tp->offset, addr);
-		ret = find_perf_probe_point((unsigned long)addr, pp);
+
+		dinfo = debuginfo__new_online_kernel(addr);
+		if (dinfo) {
+			ret = debuginfo__find_probe_point(dinfo,
+						 (unsigned long)addr, pp);
+			debuginfo__delete(dinfo);
+		} else {
+			pr_debug("Failed to open debuginfo at 0x%" PRIx64 "\n",
+				 addr);
+			ret = -ENOENT;
+		}
 	}
 	if (ret <= 0) {
 		pr_debug("Failed to find corresponding probes from "
@@ -220,20 +232,22 @@ static int try_to_find_probe_trace_events(struct perf_probe_event *pev,
 					   int max_tevs, const char *module)
 {
 	bool need_dwarf = perf_probe_event_need_dwarf(pev);
-	int fd, ntevs;
+	struct debuginfo *dinfo = open_debuginfo(module);
+	int ntevs;
 
-	fd = open_vmlinux(module);
-	if (fd < 0) {
+	if (!dinfo) {
 		if (need_dwarf) {
 			pr_warning("Failed to open debuginfo file.\n");
-			return fd;
+			return -ENOENT;
 		}
-		pr_debug("Could not open vmlinux. Try to use symbols.\n");
+		pr_debug("Could not open debuginfo. Try to use symbols.\n");
 		return 0;
 	}
 
-	/* Searching trace events corresponding to probe event */
-	ntevs = find_probe_trace_events(fd, pev, tevs, max_tevs);
+	/* Searching trace events corresponding to a probe event */
+	ntevs = debuginfo__find_trace_events(dinfo, pev, tevs, max_tevs);
+
+	debuginfo__delete(dinfo);
 
 	if (ntevs > 0) {	/* Succeeded to find trace events */
 		pr_debug("find %d probe_trace_events.\n", ntevs);
@@ -371,8 +385,9 @@ int show_line_range(struct line_range *lr, const char *module)
 {
 	int l = 1;
 	struct line_node *ln;
+	struct debuginfo *dinfo;
 	FILE *fp;
-	int fd, ret;
+	int ret;
 	char *tmp;
 
 	/* Search a line range */
@@ -380,13 +395,14 @@ int show_line_range(struct line_range *lr, const char *module)
 	if (ret < 0)
 		return ret;
 
-	fd = open_vmlinux(module);
-	if (fd < 0) {
+	dinfo = open_debuginfo(module);
+	if (!dinfo) {
 		pr_warning("Failed to open debuginfo file.\n");
-		return fd;
+		return -ENOENT;
 	}
 
-	ret = find_line_range(fd, lr);
+	ret = debuginfo__find_line_range(dinfo, lr);
+	debuginfo__delete(dinfo);
 	if (ret == 0) {
 		pr_warning("Specified source line is not found.\n");
 		return -ENOENT;
@@ -448,7 +464,8 @@ end:
 	return ret;
 }
 
-static int show_available_vars_at(int fd, struct perf_probe_event *pev,
+static int show_available_vars_at(struct debuginfo *dinfo,
+				  struct perf_probe_event *pev,
 				  int max_vls, struct strfilter *_filter,
 				  bool externs)
 {
@@ -463,7 +480,8 @@ static int show_available_vars_at(int fd, struct perf_probe_event *pev,
 		return -EINVAL;
 	pr_debug("Searching variables at %s\n", buf);
 
-	ret = find_available_vars_at(fd, pev, &vls, max_vls, externs);
+	ret = debuginfo__find_available_vars_at(dinfo, pev, &vls,
+						max_vls, externs);
 	if (ret <= 0) {
 		pr_err("Failed to find variables at %s (%d)\n", buf, ret);
 		goto end;
@@ -504,24 +522,26 @@ int show_available_vars(struct perf_probe_event *pevs, int npevs,
 			int max_vls, const char *module,
 			struct strfilter *_filter, bool externs)
 {
-	int i, fd, ret = 0;
+	int i, ret = 0;
+	struct debuginfo *dinfo;
 
 	ret = init_vmlinux();
 	if (ret < 0)
 		return ret;
 
+	dinfo = open_debuginfo(module);
+	if (!dinfo) {
+		pr_warning("Failed to open debuginfo file.\n");
+		return -ENOENT;
+	}
+
 	setup_pager();
 
-	for (i = 0; i < npevs && ret >= 0; i++) {
-		fd = open_vmlinux(module);
-		if (fd < 0) {
-			pr_warning("Failed to open debug information file.\n");
-			ret = fd;
-			break;
-		}
-		ret = show_available_vars_at(fd, &pevs[i], max_vls, _filter,
+	for (i = 0; i < npevs && ret >= 0; i++)
+		ret = show_available_vars_at(dinfo, &pevs[i], max_vls, _filter,
 					     externs);
-	}
+
+	debuginfo__delete(dinfo);
 	return ret;
 }
 
diff --git a/tools/perf/util/probe-finder.c b/tools/perf/util/probe-finder.c
index 53d219b..3e44a3e 100644
--- a/tools/perf/util/probe-finder.c
+++ b/tools/perf/util/probe-finder.c
@@ -116,29 +116,37 @@ static const Dwfl_Callbacks offline_callbacks = {
 };
 
 /* Get a Dwarf from offline image */
-static Dwarf *dwfl_init_offline_dwarf(int fd, Dwfl **dwflp, Dwarf_Addr *bias)
+static int debuginfo__init_offline_dwarf(struct debuginfo *self,
+					 const char *path)
 {
 	Dwfl_Module *mod;
-	Dwarf *dbg = NULL;
+	int fd;
 
-	if (!dwflp)
-		return NULL;
+	fd = open(path, O_RDONLY);
+	if (fd < 0)
+		return fd;
 
-	*dwflp = dwfl_begin(&offline_callbacks);
-	if (!*dwflp)
-		return NULL;
+	self->dwfl = dwfl_begin(&offline_callbacks);
+	if (!self->dwfl)
+		goto error;
 
-	mod = dwfl_report_offline(*dwflp, "", "", fd);
+	mod = dwfl_report_offline(self->dwfl, "", "", fd);
 	if (!mod)
 		goto error;
 
-	dbg = dwfl_module_getdwarf(mod, bias);
-	if (!dbg) {
+	self->dbg = dwfl_module_getdwarf(mod, &self->bias);
+	if (!self->dbg)
+		goto error;
+
+	return 0;
 error:
-		dwfl_end(*dwflp);
-		*dwflp = NULL;
-	}
-	return dbg;
+	if (self->dwfl)
+		dwfl_end(self->dwfl);
+	else
+		close(fd);
+	memset(self, 0, sizeof(*self));
+
+	return -ENOENT;
 }
 
 #if _ELFUTILS_PREREQ(0, 148)
@@ -174,53 +182,82 @@ static const Dwfl_Callbacks kernel_callbacks = {
 };
 
 /* Get a Dwarf from live kernel image */
-static Dwarf *dwfl_init_live_kernel_dwarf(Dwarf_Addr addr, Dwfl **dwflp,
-					  Dwarf_Addr *bias)
+static int debuginfo__init_online_kernel_dwarf(struct debuginfo *self,
+					       Dwarf_Addr addr)
 {
-	Dwarf *dbg;
-
-	if (!dwflp)
-		return NULL;
-
-	*dwflp = dwfl_begin(&kernel_callbacks);
-	if (!*dwflp)
-		return NULL;
+	self->dwfl = dwfl_begin(&kernel_callbacks);
+	if (!self->dwfl)
+		return -EINVAL;
 
 	/* Load the kernel dwarves: Don't care the result here */
-	dwfl_linux_kernel_report_kernel(*dwflp);
-	dwfl_linux_kernel_report_modules(*dwflp);
+	dwfl_linux_kernel_report_kernel(self->dwfl);
+	dwfl_linux_kernel_report_modules(self->dwfl);
 
-	dbg = dwfl_addrdwarf(*dwflp, addr, bias);
+	self->dbg = dwfl_addrdwarf(self->dwfl, addr, &self->bias);
 	/* Here, check whether we could get a real dwarf */
-	if (!dbg) {
+	if (!self->dbg) {
 		pr_debug("Failed to find kernel dwarf at %lx\n",
 			 (unsigned long)addr);
-		dwfl_end(*dwflp);
-		*dwflp = NULL;
+		dwfl_end(self->dwfl);
+		memset(self, 0, sizeof(*self));
+		return -ENOENT;
 	}
-	return dbg;
+
+	return 0;
 }
 #else
 /* With older elfutils, this just support kernel module... */
-static Dwarf *dwfl_init_live_kernel_dwarf(Dwarf_Addr addr __used, Dwfl **dwflp,
-					  Dwarf_Addr *bias)
+static int debuginfo__init_online_kernel_dwarf(struct debuginfo *self,
+					       Dwarf_Addr addr __used)
 {
-	int fd;
 	const char *path = kernel_get_module_path("kernel");
 
 	if (!path) {
 		pr_err("Failed to find vmlinux path\n");
-		return NULL;
+		return -ENOENT;
 	}
 
 	pr_debug2("Use file %s for debuginfo\n", path);
-	fd = open(path, O_RDONLY);
-	if (fd < 0)
+	return debuginfo__init_offline_dwarf(self, path);
+}
+#endif
+
+struct debuginfo *debuginfo__new(const char *path)
+{
+	struct debuginfo *self = zalloc(sizeof(struct debuginfo));
+	if (!self)
 		return NULL;
 
-	return dwfl_init_offline_dwarf(fd, dwflp, bias);
+	if (debuginfo__init_offline_dwarf(self, path) < 0) {
+		free(self);
+		self = NULL;
+	}
+
+	return self;
+}
+
+struct debuginfo *debuginfo__new_online_kernel(unsigned long addr)
+{
+	struct debuginfo *self = zalloc(sizeof(struct debuginfo));
+	if (!self)
+		return NULL;
+
+	if (debuginfo__init_online_kernel_dwarf(self, (Dwarf_Addr)addr) < 0) {
+		free(self);
+		self = NULL;
+	}
+
+	return self;
+}
+
+void debuginfo__delete(struct debuginfo *self)
+{
+	if (self) {
+		if (self->dwfl)
+			dwfl_end(self->dwfl);
+		free(self);
+	}
 }
-#endif
 
 /*
  * Probe finder related functions
@@ -949,28 +986,18 @@ static int pubname_search_cb(Dwarf *dbg, Dwarf_Global *gl, void *data)
 }
 
 /* Find probe points from debuginfo */
-static int find_probes(int fd, struct probe_finder *pf)
+static int debuginfo__find_probes(struct debuginfo *self,
+				  struct probe_finder *pf)
 {
 	struct perf_probe_point *pp = &pf->pev->point;
 	Dwarf_Off off, noff;
 	size_t cuhl;
 	Dwarf_Die *diep;
-	Dwarf *dbg = NULL;
-	Dwfl *dwfl;
-	Dwarf_Addr bias;	/* Currently ignored */
 	int ret = 0;
 
-	dbg = dwfl_init_offline_dwarf(fd, &dwfl, &bias);
-	if (!dbg) {
-		pr_warning("No debug information found in the vmlinux - "
-			"please rebuild with CONFIG_DEBUG_INFO=y.\n");
-		close(fd);	/* Without dwfl_end(), fd isn't closed. */
-		return -EBADF;
-	}
-
 #if _ELFUTILS_PREREQ(0, 142)
 	/* Get the call frame information from this dwarf */
-	pf->cfi = dwarf_getcfi(dbg);
+	pf->cfi = dwarf_getcfi(self->dbg);
 #endif
 
 	off = 0;
@@ -989,7 +1016,8 @@ static int find_probes(int fd, struct probe_finder *pf)
 			.data = pf,
 		};
 
-		dwarf_getpubnames(dbg, pubname_search_cb, &pubname_param, 0);
+		dwarf_getpubnames(self->dbg, pubname_search_cb,
+				  &pubname_param, 0);
 		if (pubname_param.found) {
 			ret = probe_point_search_cb(&pf->sp_die, &probe_param);
 			if (ret)
@@ -998,9 +1026,9 @@ static int find_probes(int fd, struct probe_finder *pf)
 	}
 
 	/* Loop on CUs (Compilation Unit) */
-	while (!dwarf_nextcu(dbg, off, &noff, &cuhl, NULL, NULL, NULL)) {
+	while (!dwarf_nextcu(self->dbg, off, &noff, &cuhl, NULL, NULL, NULL)) {
 		/* Get the DIE(Debugging Information Entry) of this CU */
-		diep = dwarf_offdie(dbg, off + cuhl, &pf->cu_die);
+		diep = dwarf_offdie(self->dbg, off + cuhl, &pf->cu_die);
 		if (!diep)
 			continue;
 
@@ -1027,8 +1055,6 @@ static int find_probes(int fd, struct probe_finder *pf)
 
 found:
 	line_list__free(&pf->lcache);
-	if (dwfl)
-		dwfl_end(dwfl);
 
 	return ret;
 }
@@ -1074,8 +1100,9 @@ static int add_probe_trace_event(Dwarf_Die *sp_die, struct probe_finder *pf)
 }
 
 /* Find probe_trace_events specified by perf_probe_event from debuginfo */
-int find_probe_trace_events(int fd, struct perf_probe_event *pev,
-			    struct probe_trace_event **tevs, int max_tevs)
+int debuginfo__find_trace_events(struct debuginfo *self,
+				 struct perf_probe_event *pev,
+				 struct probe_trace_event **tevs, int max_tevs)
 {
 	struct trace_event_finder tf = {
 			.pf = {.pev = pev, .callback = add_probe_trace_event},
@@ -1090,7 +1117,7 @@ int find_probe_trace_events(int fd, struct perf_probe_event *pev,
 	tf.tevs = *tevs;
 	tf.ntevs = 0;
 
-	ret = find_probes(fd, &tf.pf);
+	ret = debuginfo__find_probes(self, &tf.pf);
 	if (ret < 0) {
 		free(*tevs);
 		*tevs = NULL;
@@ -1184,9 +1211,10 @@ out:
 }
 
 /* Find available variables at given probe point */
-int find_available_vars_at(int fd, struct perf_probe_event *pev,
-			   struct variable_list **vls, int max_vls,
-			   bool externs)
+int debuginfo__find_available_vars_at(struct debuginfo *self,
+				      struct perf_probe_event *pev,
+				      struct variable_list **vls,
+				      int max_vls, bool externs)
 {
 	struct available_var_finder af = {
 			.pf = {.pev = pev, .callback = add_available_vars},
@@ -1201,7 +1229,7 @@ int find_available_vars_at(int fd, struct perf_probe_event *pev,
 	af.vls = *vls;
 	af.nvls = 0;
 
-	ret = find_probes(fd, &af.pf);
+	ret = debuginfo__find_probes(self, &af.pf);
 	if (ret < 0) {
 		/* Free vlist for error */
 		while (af.nvls--) {
@@ -1219,28 +1247,19 @@ int find_available_vars_at(int fd, struct perf_probe_event *pev,
 }
 
 /* Reverse search */
-int find_perf_probe_point(unsigned long addr, struct perf_probe_point *ppt)
+int debuginfo__find_probe_point(struct debuginfo *self, unsigned long addr,
+				struct perf_probe_point *ppt)
 {
 	Dwarf_Die cudie, spdie, indie;
-	Dwarf *dbg = NULL;
-	Dwfl *dwfl = NULL;
-	Dwarf_Addr _addr, baseaddr, bias = 0;
+	Dwarf_Addr _addr, baseaddr;
 	const char *fname = NULL, *func = NULL, *tmp;
 	int baseline = 0, lineno = 0, ret = 0;
 
-	/* Open the live linux kernel */
-	dbg = dwfl_init_live_kernel_dwarf(addr, &dwfl, &bias);
-	if (!dbg) {
-		pr_warning("No debug information found in the vmlinux - "
-			"please rebuild with CONFIG_DEBUG_INFO=y.\n");
-		ret = -EINVAL;
-		goto end;
-	}
-
 	/* Adjust address with bias */
-	addr += bias;
+	addr += self->bias;
+
 	/* Find cu die */
-	if (!dwarf_addrdie(dbg, (Dwarf_Addr)addr - bias, &cudie)) {
+	if (!dwarf_addrdie(self->dbg, (Dwarf_Addr)addr - self->bias, &cudie)) {
 		pr_warning("Failed to find debug information for address %lx\n",
 			   addr);
 		ret = -EINVAL;
@@ -1316,8 +1335,6 @@ post:
 		}
 	}
 end:
-	if (dwfl)
-		dwfl_end(dwfl);
 	if (ret == 0 && (fname || func))
 		ret = 1;	/* Found a point */
 	return ret;
@@ -1427,26 +1444,15 @@ static int find_line_range_by_func(struct line_finder *lf)
 	return param.retval;
 }
 
-int find_line_range(int fd, struct line_range *lr)
+int debuginfo__find_line_range(struct debuginfo *self, struct line_range *lr)
 {
 	struct line_finder lf = {.lr = lr, .found = 0};
 	int ret = 0;
 	Dwarf_Off off = 0, noff;
 	size_t cuhl;
 	Dwarf_Die *diep;
-	Dwarf *dbg = NULL;
-	Dwfl *dwfl;
-	Dwarf_Addr bias;	/* Currently ignored */
 	const char *comp_dir;
 
-	dbg = dwfl_init_offline_dwarf(fd, &dwfl, &bias);
-	if (!dbg) {
-		pr_warning("No debug information found in the vmlinux - "
-			"please rebuild with CONFIG_DEBUG_INFO=y.\n");
-		close(fd);	/* Without dwfl_end(), fd isn't closed. */
-		return -EBADF;
-	}
-
 	/* Fastpath: lookup by function name from .debug_pubnames section */
 	if (lr->function) {
 		struct pubname_callback_param pubname_param = {
@@ -1455,7 +1461,8 @@ int find_line_range(int fd, struct line_range *lr)
 		struct dwarf_callback_param line_range_param = {
 			.data = (void *)&lf, .retval = 0};
 
-		dwarf_getpubnames(dbg, pubname_search_cb, &pubname_param, 0);
+		dwarf_getpubnames(self->dbg, pubname_search_cb,
+				  &pubname_param, 0);
 		if (pubname_param.found) {
 			line_range_search_cb(&lf.sp_die, &line_range_param);
 			if (lf.found)
@@ -1465,11 +1472,12 @@ int find_line_range(int fd, struct line_range *lr)
 
 	/* Loop on CUs (Compilation Unit) */
 	while (!lf.found && ret >= 0) {
-		if (dwarf_nextcu(dbg, off, &noff, &cuhl, NULL, NULL, NULL) != 0)
+		if (dwarf_nextcu(self->dbg, off, &noff, &cuhl,
+				 NULL, NULL, NULL) != 0)
 			break;
 
 		/* Get the DIE(Debugging Information Entry) of this CU */
-		diep = dwarf_offdie(dbg, off + cuhl, &lf.cu_die);
+		diep = dwarf_offdie(self->dbg, off + cuhl, &lf.cu_die);
 		if (!diep)
 			continue;
 
@@ -1503,7 +1511,6 @@ found:
 	}
 
 	pr_debug("path: %s\n", lr->path);
-	dwfl_end(dwfl);
 	return (ret < 0) ? ret : lf.found;
 }
 
diff --git a/tools/perf/util/probe-finder.h b/tools/perf/util/probe-finder.h
index 0f1ed3d..c478b42 100644
--- a/tools/perf/util/probe-finder.h
+++ b/tools/perf/util/probe-finder.h
@@ -16,23 +16,42 @@ static inline int is_c_varname(const char *name)
 }
 
 #ifdef DWARF_SUPPORT
+
+#include "dwarf-aux.h"
+
+/* TODO: export debuginfo data structure even if no dwarf support */
+
+/* debug information structure */
+struct debuginfo {
+	Dwarf		*dbg;
+	Dwfl		*dwfl;
+	Dwarf_Addr	bias;
+};
+
+extern struct debuginfo *debuginfo__new(const char *path);
+extern struct debuginfo *debuginfo__new_online_kernel(unsigned long addr);
+extern void debuginfo__delete(struct debuginfo *self);
+
 /* Find probe_trace_events specified by perf_probe_event from debuginfo */
-extern int find_probe_trace_events(int fd, struct perf_probe_event *pev,
-				    struct probe_trace_event **tevs,
-				    int max_tevs);
+extern int debuginfo__find_trace_events(struct debuginfo *self,
+					struct perf_probe_event *pev,
+					struct probe_trace_event **tevs,
+					int max_tevs);
 
 /* Find a perf_probe_point from debuginfo */
-extern int find_perf_probe_point(unsigned long addr,
-				 struct perf_probe_point *ppt);
+extern int debuginfo__find_probe_point(struct debuginfo *self,
+				       unsigned long addr,
+				       struct perf_probe_point *ppt);
 
 /* Find a line range */
-extern int find_line_range(int fd, struct line_range *lr);
+extern int debuginfo__find_line_range(struct debuginfo *self,
+				      struct line_range *lr);
 
 /* Find available variables */
-extern int find_available_vars_at(int fd, struct perf_probe_event *pev,
-				  struct variable_list **vls, int max_points,
-				  bool externs);
-#include "dwarf-aux.h"
+extern int debuginfo__find_available_vars_at(struct debuginfo *self,
+					     struct perf_probe_event *pev,
+					     struct variable_list **vls,
+					     int max_points, bool externs);
 
 struct probe_finder {
 	struct perf_probe_event	*pev;		/* Target probe event */

