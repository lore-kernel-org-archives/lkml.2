Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752473Ab0LWM4m (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Dec 2010 07:56:42 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:44994 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751836Ab0LWM4k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Dec 2010 07:56:40 -0500
Date: Thu, 23 Dec 2010 13:56:17 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] perf fixes
Message-ID: <20101223125617.GA6339@elte.hu>
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
Arnaldo Carvalho de Melo (1):
      perf buildid-list: Fix error return for success

Franck Bui-Huu (3):
      perf probe: Fix use of kernel image path given by 'k' option
      perf symbols: Stop using vmlinux files with no symbols
      perf buildid-cache: Fix symbolic link handling

Masami Hiramatsu (2):
      perf tools: Fix lazy wildcard matching
      perf probe: Fix to support libdwfl older than 0.148


 tools/perf/builtin-buildid-list.c |    3 +-
 tools/perf/builtin-probe.c        |    5 ++
 tools/perf/util/header.c          |   10 +++--
 tools/perf/util/probe-event.c     |   15 +++++-
 tools/perf/util/probe-finder.c    |   85 ++++++++++++++++++++++++-------------
 tools/perf/util/string.c          |    2 +-
 tools/perf/util/symbol.c          |    4 +-
 tools/perf/util/symbol.h          |    2 +
 8 files changed, 84 insertions(+), 42 deletions(-)

diff --git a/tools/perf/builtin-buildid-list.c b/tools/perf/builtin-buildid-list.c
index 44a47e1..c49837d 100644
--- a/tools/perf/builtin-buildid-list.c
+++ b/tools/perf/builtin-buildid-list.c
@@ -36,7 +36,6 @@ static const struct option options[] = {
 
 static int __cmd_buildid_list(void)
 {
-	int err = -1;
 	struct perf_session *session;
 
 	session = perf_session__new(input_name, O_RDONLY, force, false);
@@ -49,7 +48,7 @@ static int __cmd_buildid_list(void)
 	perf_session__fprintf_dsos_buildid(session, stdout, with_hits);
 
 	perf_session__delete(session);
-	return err;
+	return 0;
 }
 
 int cmd_buildid_list(int argc, const char **argv, const char *prefix __used)
diff --git a/tools/perf/builtin-probe.c b/tools/perf/builtin-probe.c
index 2e000c0..add163c 100644
--- a/tools/perf/builtin-probe.c
+++ b/tools/perf/builtin-probe.c
@@ -249,6 +249,11 @@ int cmd_probe(int argc, const char **argv, const char *prefix __used)
 	     !params.show_lines))
 		usage_with_options(probe_usage, options);
 
+	/*
+	 * Only consider the user's kernel image path if given.
+	 */
+	symbol_conf.try_vmlinux_path = (symbol_conf.vmlinux_name == NULL);
+
 	if (params.list_events) {
 		if (params.mod_events) {
 			pr_err("  Error: Don't use --list with --add/--del.\n");
diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
index 64a85ba..7cba055 100644
--- a/tools/perf/util/header.c
+++ b/tools/perf/util/header.c
@@ -265,15 +265,16 @@ int build_id_cache__add_s(const char *sbuild_id, const char *debugdir,
 			  const char *name, bool is_kallsyms)
 {
 	const size_t size = PATH_MAX;
-	char *filename = malloc(size),
+	char *realname = realpath(name, NULL),
+	     *filename = malloc(size),
 	     *linkname = malloc(size), *targetname;
 	int len, err = -1;
 
-	if (filename == NULL || linkname == NULL)
+	if (realname == NULL || filename == NULL || linkname == NULL)
 		goto out_free;
 
 	len = snprintf(filename, size, "%s%s%s",
-		       debugdir, is_kallsyms ? "/" : "", name);
+		       debugdir, is_kallsyms ? "/" : "", realname);
 	if (mkdir_p(filename, 0755))
 		goto out_free;
 
@@ -283,7 +284,7 @@ int build_id_cache__add_s(const char *sbuild_id, const char *debugdir,
 		if (is_kallsyms) {
 			 if (copyfile("/proc/kallsyms", filename))
 				goto out_free;
-		} else if (link(name, filename) && copyfile(name, filename))
+		} else if (link(realname, filename) && copyfile(name, filename))
 			goto out_free;
 	}
 
@@ -300,6 +301,7 @@ int build_id_cache__add_s(const char *sbuild_id, const char *debugdir,
 	if (symlink(targetname, linkname) == 0)
 		err = 0;
 out_free:
+	free(realname);
 	free(filename);
 	free(linkname);
 	return err;
diff --git a/tools/perf/util/probe-event.c b/tools/perf/util/probe-event.c
index 3b6a529..61191c6 100644
--- a/tools/perf/util/probe-event.c
+++ b/tools/perf/util/probe-event.c
@@ -114,6 +114,8 @@ static struct symbol *__find_kernel_function_by_name(const char *name,
 const char *kernel_get_module_path(const char *module)
 {
 	struct dso *dso;
+	struct map *map;
+	const char *vmlinux_name;
 
 	if (module) {
 		list_for_each_entry(dso, &machine.kernel_dsos, node) {
@@ -123,10 +125,17 @@ const char *kernel_get_module_path(const char *module)
 		}
 		pr_debug("Failed to find module %s.\n", module);
 		return NULL;
+	}
+
+	map = machine.vmlinux_maps[MAP__FUNCTION];
+	dso = map->dso;
+
+	vmlinux_name = symbol_conf.vmlinux_name;
+	if (vmlinux_name) {
+		if (dso__load_vmlinux(dso, map, vmlinux_name, NULL) <= 0)
+			return NULL;
 	} else {
-		dso = machine.vmlinux_maps[MAP__FUNCTION]->dso;
-		if (dso__load_vmlinux_path(dso,
-			 machine.vmlinux_maps[MAP__FUNCTION], NULL) < 0) {
+		if (dso__load_vmlinux_path(dso, map, NULL) <= 0) {
 			pr_debug("Failed to load kernel map.\n");
 			return NULL;
 		}
diff --git a/tools/perf/util/probe-finder.c b/tools/perf/util/probe-finder.c
index 3991d73..ddf4d45 100644
--- a/tools/perf/util/probe-finder.c
+++ b/tools/perf/util/probe-finder.c
@@ -117,28 +117,6 @@ static void line_list__free(struct list_head *head)
 }
 
 /* Dwarf FL wrappers */
-
-static int __linux_kernel_find_elf(Dwfl_Module *mod,
-				   void **userdata,
-				   const char *module_name,
-				   Dwarf_Addr base,
-				   char **file_name, Elf **elfp)
-{
-	int fd;
-	const char *path = kernel_get_module_path(module_name);
-
-	if (path) {
-		fd = open(path, O_RDONLY);
-		if (fd >= 0) {
-			*file_name = strdup(path);
-			return fd;
-		}
-	}
-	/* If failed, try to call standard method */
-	return dwfl_linux_kernel_find_elf(mod, userdata, module_name, base,
-					  file_name, elfp);
-}
-
 static char *debuginfo_path;	/* Currently dummy */
 
 static const Dwfl_Callbacks offline_callbacks = {
@@ -151,14 +129,6 @@ static const Dwfl_Callbacks offline_callbacks = {
 	.find_elf = dwfl_build_id_find_elf,
 };
 
-static const Dwfl_Callbacks kernel_callbacks = {
-	.find_debuginfo = dwfl_standard_find_debuginfo,
-	.debuginfo_path = &debuginfo_path,
-
-	.find_elf = __linux_kernel_find_elf,
-	.section_address = dwfl_linux_kernel_module_section_address,
-};
-
 /* Get a Dwarf from offline image */
 static Dwarf *dwfl_init_offline_dwarf(int fd, Dwfl **dwflp, Dwarf_Addr *bias)
 {
@@ -185,6 +155,38 @@ error:
 	return dbg;
 }
 
+#if _ELFUTILS_PREREQ(0, 148)
+/* This method is buggy if elfutils is older than 0.148 */
+static int __linux_kernel_find_elf(Dwfl_Module *mod,
+				   void **userdata,
+				   const char *module_name,
+				   Dwarf_Addr base,
+				   char **file_name, Elf **elfp)
+{
+	int fd;
+	const char *path = kernel_get_module_path(module_name);
+
+	pr_debug2("Use file %s for %s\n", path, module_name);
+	if (path) {
+		fd = open(path, O_RDONLY);
+		if (fd >= 0) {
+			*file_name = strdup(path);
+			return fd;
+		}
+	}
+	/* If failed, try to call standard method */
+	return dwfl_linux_kernel_find_elf(mod, userdata, module_name, base,
+					  file_name, elfp);
+}
+
+static const Dwfl_Callbacks kernel_callbacks = {
+	.find_debuginfo = dwfl_standard_find_debuginfo,
+	.debuginfo_path = &debuginfo_path,
+
+	.find_elf = __linux_kernel_find_elf,
+	.section_address = dwfl_linux_kernel_module_section_address,
+};
+
 /* Get a Dwarf from live kernel image */
 static Dwarf *dwfl_init_live_kernel_dwarf(Dwarf_Addr addr, Dwfl **dwflp,
 					  Dwarf_Addr *bias)
@@ -205,11 +207,34 @@ static Dwarf *dwfl_init_live_kernel_dwarf(Dwarf_Addr addr, Dwfl **dwflp,
 	dbg = dwfl_addrdwarf(*dwflp, addr, bias);
 	/* Here, check whether we could get a real dwarf */
 	if (!dbg) {
+		pr_debug("Failed to find kernel dwarf at %lx\n",
+			 (unsigned long)addr);
 		dwfl_end(*dwflp);
 		*dwflp = NULL;
 	}
 	return dbg;
 }
+#else
+/* With older elfutils, this just support kernel module... */
+static Dwarf *dwfl_init_live_kernel_dwarf(Dwarf_Addr addr __used, Dwfl **dwflp,
+					  Dwarf_Addr *bias)
+{
+	int fd;
+	const char *path = kernel_get_module_path("kernel");
+
+	if (!path) {
+		pr_err("Failed to find vmlinux path\n");
+		return NULL;
+	}
+
+	pr_debug2("Use file %s for debuginfo\n", path);
+	fd = open(path, O_RDONLY);
+	if (fd < 0)
+		return NULL;
+
+	return dwfl_init_offline_dwarf(fd, dwflp, bias);
+}
+#endif
 
 /* Dwarf wrappers */
 
diff --git a/tools/perf/util/string.c b/tools/perf/util/string.c
index 0409fc7..8fc0bd3 100644
--- a/tools/perf/util/string.c
+++ b/tools/perf/util/string.c
@@ -259,7 +259,7 @@ static bool __match_glob(const char *str, const char *pat, bool ignore_space)
 		if (!*pat)	/* Tail wild card matches all */
 			return true;
 		while (*str)
-			if (strglobmatch(str++, pat))
+			if (__match_glob(str++, pat, ignore_space))
 				return true;
 	}
 	return !*str && !*pat;
diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index d628c8d..439ab94 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -1780,8 +1780,8 @@ out_failure:
 	return -1;
 }
 
-static int dso__load_vmlinux(struct dso *self, struct map *map,
-			     const char *vmlinux, symbol_filter_t filter)
+int dso__load_vmlinux(struct dso *self, struct map *map,
+		      const char *vmlinux, symbol_filter_t filter)
 {
 	int err = -1, fd;
 
diff --git a/tools/perf/util/symbol.h b/tools/perf/util/symbol.h
index 038f220..6c6eafd 100644
--- a/tools/perf/util/symbol.h
+++ b/tools/perf/util/symbol.h
@@ -166,6 +166,8 @@ void dso__sort_by_name(struct dso *self, enum map_type type);
 struct dso *__dsos__findnew(struct list_head *head, const char *name);
 
 int dso__load(struct dso *self, struct map *map, symbol_filter_t filter);
+int dso__load_vmlinux(struct dso *self, struct map *map,
+		      const char *vmlinux, symbol_filter_t filter);
 int dso__load_vmlinux_path(struct dso *self, struct map *map,
 			   symbol_filter_t filter);
 int dso__load_kallsyms(struct dso *self, const char *filename, struct map *map,
