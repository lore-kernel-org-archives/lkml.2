Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757048Ab0LIU1M (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Dec 2010 15:27:12 -0500
Received: from sj-iport-5.cisco.com ([171.68.10.87]:57466 "EHLO
	sj-iport-5.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753239Ab0LIU1L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Dec 2010 15:27:11 -0500
Authentication-Results: sj-iport-5.cisco.com; dkim=neutral (message not signed) header.i=none
X-IronPort-AV: E=Sophos;i="4.59,322,1288569600"; 
   d="scan'208";a="300098434"
From: David Ahern <daahern@cisco.com>
To: linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: David Ahern <daahern@cisco.com>
Subject: [PATCH v3] perf tools: Add symfs option for off-box analysis using specified tree
Date: Thu,  9 Dec 2010 13:27:07 -0700
Message-Id: <1291926427-28846-1-git-send-email-daahern@cisco.com>
X-Mailer: git-send-email 1.7.2.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The symfs argument allows analysis of perf.data file using a locally
accessible filesystem tree with debug symbols - e.g., tree created
during image builds, sshfs mount, loop mounted KVM disk images,
USB keys, initrds, etc. Anything with an OS tree can be analyzed from
anywhere without the need to populate a local data store with
build-ids.

Signed-off-by: David Ahern <daahern@cisco.com>

v2 --> v3: handle symfs="/"

v1 --> v2: removed symfs changes from builtin-annotate.c
           fixed tab/space inconsistencies
           changed new strlen() to symbol_conf.symfs[0]
           added symfs option to Documentation files

---
 tools/perf/Documentation/perf-diff.txt      |    2 +
 tools/perf/Documentation/perf-report.txt    |    3 +
 tools/perf/Documentation/perf-timechart.txt |    2 +
 tools/perf/builtin-diff.c                   |    2 +
 tools/perf/builtin-report.c                 |    2 +
 tools/perf/builtin-timechart.c              |    2 +
 tools/perf/util/hist.c                      |   14 +++++-
 tools/perf/util/symbol.c                    |   57 ++++++++++++++++++++-------
 tools/perf/util/symbol.h                    |    1 +
 9 files changed, 67 insertions(+), 18 deletions(-)

diff --git a/tools/perf/Documentation/perf-diff.txt b/tools/perf/Documentation/perf-diff.txt
index 6a9ec2b..74d7481 100644
--- a/tools/perf/Documentation/perf-diff.txt
+++ b/tools/perf/Documentation/perf-diff.txt
@@ -66,6 +66,8 @@ OPTIONS
 --force::
        Don't complain, do it.
 
+--symfs=<directory>::
+        Look for files with symbols relative to this directory.
 
 SEE ALSO
 --------
diff --git a/tools/perf/Documentation/perf-report.txt b/tools/perf/Documentation/perf-report.txt
index 59a1f57..9ed6079 100644
--- a/tools/perf/Documentation/perf-report.txt
+++ b/tools/perf/Documentation/perf-report.txt
@@ -113,6 +113,9 @@ OPTIONS
 --force::
         Don't complain, do it.
 
+--symfs=<directory>::
+        Look for files with symbols relative to this directory.
+
 SEE ALSO
 --------
 linkperf:perf-stat[1]
diff --git a/tools/perf/Documentation/perf-timechart.txt b/tools/perf/Documentation/perf-timechart.txt
index 4b17883..d7b79e2 100644
--- a/tools/perf/Documentation/perf-timechart.txt
+++ b/tools/perf/Documentation/perf-timechart.txt
@@ -38,6 +38,8 @@ OPTIONS
 --process::
         Select the processes to display, by name or PID
 
+--symfs=<directory>::
+        Look for files with symbols relative to this directory.
 
 SEE ALSO
 --------
diff --git a/tools/perf/builtin-diff.c b/tools/perf/builtin-diff.c
index 5e1a043..71126a6 100644
--- a/tools/perf/builtin-diff.c
+++ b/tools/perf/builtin-diff.c
@@ -192,6 +192,8 @@ static const struct option options[] = {
 	OPT_STRING('t', "field-separator", &symbol_conf.field_sep, "separator",
 		   "separator for columns, no spaces will be added between "
 		   "columns '.' is reserved."),
+	OPT_STRING(0, "symfs", &symbol_conf.symfs, "directory",
+		    "Look for files with symbols relative to this directory"),
 	OPT_END()
 };
 
diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index 904519f..57b0f49 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -479,6 +479,8 @@ static const struct option options[] = {
 		   "columns '.' is reserved."),
 	OPT_BOOLEAN('U', "hide-unresolved", &hide_unresolved,
 		    "Only display entries resolved to a symbol"),
+	OPT_STRING(0, "symfs", &symbol_conf.symfs, "directory",
+		    "Look for files with symbols relative to this directory"),
 	OPT_END()
 };
 
diff --git a/tools/perf/builtin-timechart.c b/tools/perf/builtin-timechart.c
index d2fc461..965aa4e 100644
--- a/tools/perf/builtin-timechart.c
+++ b/tools/perf/builtin-timechart.c
@@ -1021,6 +1021,8 @@ static const struct option options[] = {
 	OPT_CALLBACK('p', "process", NULL, "process",
 		      "process selector. Pass a pid or process name.",
 		       parse_process),
+	OPT_STRING(0, "symfs", &symbol_conf.symfs, "directory",
+		    "Look for files with symbols relative to this directory"),
 	OPT_END()
 };
 
diff --git a/tools/perf/util/hist.c b/tools/perf/util/hist.c
index 2022e87..b6f9f3b 100644
--- a/tools/perf/util/hist.c
+++ b/tools/perf/util/hist.c
@@ -1092,6 +1092,12 @@ int hist_entry__annotate(struct hist_entry *self, struct list_head *head,
 	FILE *file;
 	int err = 0;
 	u64 len;
+	char symfs_filename[PATH_MAX];
+
+	if (filename) {
+		snprintf(symfs_filename, sizeof(symfs_filename), "%s%s",
+			 symbol_conf.symfs, filename);
+	}
 
 	if (filename == NULL) {
 		if (dso->has_build_id) {
@@ -1100,9 +1106,9 @@ int hist_entry__annotate(struct hist_entry *self, struct list_head *head,
 			return -ENOMEM;
 		}
 		goto fallback;
-	} else if (readlink(filename, command, sizeof(command)) < 0 ||
+	} else if (readlink(symfs_filename, command, sizeof(command)) < 0 ||
 		   strstr(command, "[kernel.kallsyms]") ||
-		   access(filename, R_OK)) {
+		   access(symfs_filename, R_OK)) {
 		free(filename);
 fallback:
 		/*
@@ -1111,6 +1117,8 @@ fallback:
 		 * DSO is the same as when 'perf record' ran.
 		 */
 		filename = dso->long_name;
+		snprintf(symfs_filename, sizeof(symfs_filename), "%s%s",
+			 symbol_conf.symfs, filename);
 		free_filename = false;
 	}
 
@@ -1137,7 +1145,7 @@ fallback:
 		 "objdump --start-address=0x%016Lx --stop-address=0x%016Lx -dS -C %s|grep -v %s|expand",
 		 map__rip_2objdump(map, sym->start),
 		 map__rip_2objdump(map, sym->end),
-		 filename, filename);
+		 symfs_filename, filename);
 
 	pr_debug("Executing: %s\n", command);
 
diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index a348906..f61b419 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -41,6 +41,7 @@ struct symbol_conf symbol_conf = {
 	.exclude_other	  = true,
 	.use_modules	  = true,
 	.try_vmlinux_path = true,
+	.symfs            = "",
 };
 
 int dso__name_len(const struct dso *self)
@@ -833,8 +834,11 @@ static int dso__synthesize_plt_symbols(struct  dso *self, struct map *map,
 	char sympltname[1024];
 	Elf *elf;
 	int nr = 0, symidx, fd, err = 0;
+	char name[PATH_MAX];
 
-	fd = open(self->long_name, O_RDONLY);
+	snprintf(name, sizeof(name), "%s%s",
+		 symbol_conf.symfs, self->long_name);
+	fd = open(name, O_RDONLY);
 	if (fd < 0)
 		goto out;
 
@@ -1446,16 +1450,19 @@ int dso__load(struct dso *self, struct map *map, symbol_filter_t filter)
 	     self->origin++) {
 		switch (self->origin) {
 		case DSO__ORIG_BUILD_ID_CACHE:
-			if (dso__build_id_filename(self, name, size) == NULL)
+			/* skip the locally configured cache if a symfs is given */
+			if (symbol_conf.symfs[0] ||
+			    (dso__build_id_filename(self, name, size) == NULL)) {
 				continue;
+			}
 			break;
 		case DSO__ORIG_FEDORA:
-			snprintf(name, size, "/usr/lib/debug%s.debug",
-				 self->long_name);
+			snprintf(name, size, "%s/usr/lib/debug%s.debug",
+				 symbol_conf.symfs, self->long_name);
 			break;
 		case DSO__ORIG_UBUNTU:
-			snprintf(name, size, "/usr/lib/debug%s",
-				 self->long_name);
+			snprintf(name, size, "%s/usr/lib/debug%s",
+				 symbol_conf.symfs, self->long_name);
 			break;
 		case DSO__ORIG_BUILDID: {
 			char build_id_hex[BUILD_ID_SIZE * 2 + 1];
@@ -1467,12 +1474,13 @@ int dso__load(struct dso *self, struct map *map, symbol_filter_t filter)
 					  sizeof(self->build_id),
 					  build_id_hex);
 			snprintf(name, size,
-				 "/usr/lib/debug/.build-id/%.2s/%s.debug",
-				 build_id_hex, build_id_hex + 2);
+				 "%s/usr/lib/debug/.build-id/%.2s/%s.debug",
+				 symbol_conf.symfs, build_id_hex, build_id_hex + 2);
 			}
 			break;
 		case DSO__ORIG_DSO:
-			snprintf(name, size, "%s", self->long_name);
+			snprintf(name, size, "%s%s",
+			     symbol_conf.symfs, self->long_name);
 			break;
 		case DSO__ORIG_GUEST_KMODULE:
 			if (map->groups && map->groups->machine)
@@ -1778,17 +1786,20 @@ static int dso__load_vmlinux(struct dso *self, struct map *map,
 			     const char *vmlinux, symbol_filter_t filter)
 {
 	int err = -1, fd;
+	char symfs_vmlinux[PATH_MAX];
 
-	fd = open(vmlinux, O_RDONLY);
+	snprintf(symfs_vmlinux, sizeof(symfs_vmlinux), "%s/%s",
+		 symbol_conf.symfs, vmlinux);
+	fd = open(symfs_vmlinux, O_RDONLY);
 	if (fd < 0)
 		return -1;
 
 	dso__set_loaded(self, map->type);
-	err = dso__load_sym(self, map, vmlinux, fd, filter, 0, 0);
+	err = dso__load_sym(self, map, symfs_vmlinux, fd, filter, 0, 0);
 	close(fd);
 
 	if (err > 0)
-		pr_debug("Using %s for symbols\n", vmlinux);
+		pr_debug("Using %s for symbols\n", symfs_vmlinux);
 
 	return err;
 }
@@ -1861,6 +1872,10 @@ static int dso__load_kernel_sym(struct dso *self, struct map *map,
 			goto out_fixup;
 	}
 
+	/* do not try local files if a symfs was given */
+	if (symbol_conf.symfs[0] != 0)
+		return -1;
+
 	/*
 	 * Say the kernel DSO was created when processing the build-id header table,
 	 * we have a build-id, so check if it is the same as the running kernel,
@@ -2210,9 +2225,6 @@ static int vmlinux_path__init(void)
 	struct utsname uts;
 	char bf[PATH_MAX];
 
-	if (uname(&uts) < 0)
-		return -1;
-
 	vmlinux_path = malloc(sizeof(char *) * 5);
 	if (vmlinux_path == NULL)
 		return -1;
@@ -2225,6 +2237,14 @@ static int vmlinux_path__init(void)
 	if (vmlinux_path[vmlinux_path__nr_entries] == NULL)
 		goto out_fail;
 	++vmlinux_path__nr_entries;
+
+	/* only try running kernel version if no symfs was given */
+	if (symbol_conf.symfs[0] != 0)
+		return 0;
+
+	if (uname(&uts) < 0)
+		return -1;
+
 	snprintf(bf, sizeof(bf), "/boot/vmlinux-%s", uts.release);
 	vmlinux_path[vmlinux_path__nr_entries] = strdup(bf);
 	if (vmlinux_path[vmlinux_path__nr_entries] == NULL)
@@ -2312,6 +2332,13 @@ int symbol__init(void)
 		       symbol_conf.sym_list_str, "symbol") < 0)
 		goto out_free_comm_list;
 
+	/* a path to symbols of "/" is identical to "" 
+	 * reset here for simplicity.
+	 */
+	if ((symbol_conf.symfs[0] == '/') &&
+	    (symbol_conf.symfs[1] == '\0'))
+		symbol_conf.symfs = "";
+
 	symbol_conf.initialized = true;
 	return 0;
 
diff --git a/tools/perf/util/symbol.h b/tools/perf/util/symbol.h
index 038f220..bbe90d1 100644
--- a/tools/perf/util/symbol.h
+++ b/tools/perf/util/symbol.h
@@ -85,6 +85,7 @@ struct symbol_conf {
        struct strlist	*dso_list,
 			*comm_list,
 			*sym_list;
+	const char	*symfs;
 };
 
 extern struct symbol_conf symbol_conf;
-- 
1.7.2.3

