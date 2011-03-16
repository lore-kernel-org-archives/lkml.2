Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752120Ab1CPNxQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Mar 2011 09:53:16 -0400
Received: from hera.kernel.org ([140.211.167.34]:32908 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750765Ab1CPNxF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Mar 2011 09:53:05 -0400
Date: Wed, 16 Mar 2011 13:52:35 GMT
From: tip-bot for Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, paulus@samba.org,
        acme@redhat.com, hpa@zytor.com, mingo@redhat.com, tzanussi@gmail.com,
        peterz@infradead.org, efault@gmx.de, fweisbec@gmail.com,
        tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, tzanussi@gmail.com,
        efault@gmx.de, peterz@infradead.org, fweisbec@gmail.com,
        tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf symbols: Rename dso->origin to dso->symtab_type
Message-ID: <tip-878b439dccd064d6908800fab0b47bd3c3a87ebb@git.kernel.org>
Git-Commit-ID: 878b439dccd064d6908800fab0b47bd3c3a87ebb
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 16 Mar 2011 13:52:36 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  878b439dccd064d6908800fab0b47bd3c3a87ebb
Gitweb:     http://git.kernel.org/tip/878b439dccd064d6908800fab0b47bd3c3a87ebb
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Fri, 11 Mar 2011 13:13:36 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Fri, 11 Mar 2011 13:28:45 -0300

perf symbols: Rename dso->origin to dso->symtab_type

And the DSO__ORIG_ enum to SYMTAB__, to clarify that this is about from
where the symtab was obtained.

Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Cc: Tom Zanussi <tzanussi@gmail.com>
LKML-Reference: <new-submission>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-top.c   |    4 +-
 tools/perf/util/annotate.c |    2 +-
 tools/perf/util/symbol.c   |   64 ++++++++++++++++++++++----------------------
 tools/perf/util/symbol.h   |   26 +++++++++---------
 4 files changed, 48 insertions(+), 48 deletions(-)

diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index 4976400..31ea7a6 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -152,7 +152,7 @@ static int parse_source(struct sym_entry *syme)
 	/*
 	 * We can't annotate with just /proc/kallsyms
 	 */
-	if (map->dso->origin == DSO__ORIG_KERNEL) {
+	if (map->dso->symtab_type == SYMTAB__KALLSYMS) {
 		pr_err("Can't annotate %s: No vmlinux file was found in the "
 		       "path\n", sym->name);
 		sleep(1);
@@ -769,7 +769,7 @@ static void perf_event__process_sample(const union perf_event *event,
 			struct symbol *sym = sym_entry__symbol(top.sym_filter_entry);
 
 			pr_err("Can't annotate %s", sym->name);
-			if (top.sym_filter_entry->map->dso->origin == DSO__ORIG_KERNEL) {
+			if (top.sym_filter_entry->map->dso->symtab_type == SYMTAB__KALLSYMS) {
 				pr_err(": No vmlinux file was found in the path:\n");
 				machine__fprintf_vmlinux_path(machine, stderr);
 			} else
diff --git a/tools/perf/util/annotate.c b/tools/perf/util/annotate.c
index 0d0830c..e01af2b 100644
--- a/tools/perf/util/annotate.c
+++ b/tools/perf/util/annotate.c
@@ -294,7 +294,7 @@ fallback:
 		free_filename = false;
 	}
 
-	if (dso->origin == DSO__ORIG_KERNEL) {
+	if (dso->symtab_type == SYMTAB__KALLSYMS) {
 		char bf[BUILD_ID_SIZE * 2 + 16] = " with build id ";
 		char *build_id_msg = NULL;
 
diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index 00014e3..651dbfe 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -207,7 +207,7 @@ struct dso *dso__new(const char *name)
 		dso__set_short_name(self, self->name);
 		for (i = 0; i < MAP__NR_TYPES; ++i)
 			self->symbols[i] = self->symbol_names[i] = RB_ROOT;
-		self->origin = DSO__ORIG_NOT_FOUND;
+		self->symtab_type = SYMTAB__NOT_FOUND;
 		self->loaded = 0;
 		self->sorted_by_name = 0;
 		self->has_build_id = 0;
@@ -680,9 +680,9 @@ int dso__load_kallsyms(struct dso *self, const char *filename,
 		return -1;
 
 	if (self->kernel == DSO_TYPE_GUEST_KERNEL)
-		self->origin = DSO__ORIG_GUEST_KERNEL;
+		self->symtab_type = SYMTAB__GUEST_KALLSYMS;
 	else
-		self->origin = DSO__ORIG_KERNEL;
+		self->symtab_type = SYMTAB__KALLSYMS;
 
 	return dso__split_kallsyms(self, map, filter);
 }
@@ -1204,7 +1204,7 @@ static int dso__load_sym(struct dso *self, struct map *map, const char *name,
 				}
 				curr_map->map_ip = identity__map_ip;
 				curr_map->unmap_ip = identity__map_ip;
-				curr_dso->origin = self->origin;
+				curr_dso->symtab_type = self->symtab_type;
 				map_groups__insert(kmap->kmaps, curr_map);
 				dsos__add(&self->node, curr_dso);
 				dso__set_loaded(curr_dso, map->type);
@@ -1430,21 +1430,21 @@ out:
 char dso__symtab_origin(const struct dso *self)
 {
 	static const char origin[] = {
-		[DSO__ORIG_KERNEL] =   'k',
-		[DSO__ORIG_JAVA_JIT] = 'j',
-		[DSO__ORIG_BUILD_ID_CACHE] = 'B',
-		[DSO__ORIG_FEDORA] =   'f',
-		[DSO__ORIG_UBUNTU] =   'u',
-		[DSO__ORIG_BUILDID] =  'b',
-		[DSO__ORIG_DSO] =      'd',
-		[DSO__ORIG_KMODULE] =  'K',
-		[DSO__ORIG_GUEST_KERNEL] =  'g',
-		[DSO__ORIG_GUEST_KMODULE] =  'G',
+		[SYMTAB__KALLSYMS]	      = 'k',
+		[SYMTAB__JAVA_JIT]	      = 'j',
+		[SYMTAB__BUILD_ID_CACHE]      = 'B',
+		[SYMTAB__FEDORA_DEBUGINFO]    = 'f',
+		[SYMTAB__UBUNTU_DEBUGINFO]    = 'u',
+		[SYMTAB__BUILDID_DEBUGINFO]   = 'b',
+		[SYMTAB__SYSTEM_PATH_DSO]     = 'd',
+		[SYMTAB__SYSTEM_PATH_KMODULE] = 'K',
+		[SYMTAB__GUEST_KALLSYMS]      =  'g',
+		[SYMTAB__GUEST_KMODULE]	      =  'G',
 	};
 
-	if (self == NULL || self->origin == DSO__ORIG_NOT_FOUND)
+	if (self == NULL || self->symtab_type == SYMTAB__NOT_FOUND)
 		return '!';
-	return origin[self->origin];
+	return origin[self->symtab_type];
 }
 
 int dso__load(struct dso *self, struct map *map, symbol_filter_t filter)
@@ -1477,8 +1477,8 @@ int dso__load(struct dso *self, struct map *map, symbol_filter_t filter)
 
 	if (strncmp(self->name, "/tmp/perf-", 10) == 0) {
 		ret = dso__load_perf_map(self, map, filter);
-		self->origin = ret > 0 ? DSO__ORIG_JAVA_JIT :
-					 DSO__ORIG_NOT_FOUND;
+		self->symtab_type = ret > 0 ? SYMTAB__JAVA_JIT :
+					      SYMTAB__NOT_FOUND;
 		return ret;
 	}
 
@@ -1486,26 +1486,26 @@ int dso__load(struct dso *self, struct map *map, symbol_filter_t filter)
 	 * On the first pass, only load images if they have a full symtab.
 	 * Failing that, do a second pass where we accept .dynsym also
 	 */
-	for (self->origin = DSO__ORIG_BUILD_ID_CACHE, want_symtab = 1;
-	     self->origin != DSO__ORIG_NOT_FOUND;
-	     self->origin++) {
-		switch (self->origin) {
-		case DSO__ORIG_BUILD_ID_CACHE:
+	for (self->symtab_type = SYMTAB__BUILD_ID_CACHE, want_symtab = 1;
+	     self->symtab_type != SYMTAB__NOT_FOUND;
+	     self->symtab_type++) {
+		switch (self->symtab_type) {
+		case SYMTAB__BUILD_ID_CACHE:
 			/* skip the locally configured cache if a symfs is given */
 			if (symbol_conf.symfs[0] ||
 			    (dso__build_id_filename(self, name, size) == NULL)) {
 				continue;
 			}
 			break;
-		case DSO__ORIG_FEDORA:
+		case SYMTAB__FEDORA_DEBUGINFO:
 			snprintf(name, size, "%s/usr/lib/debug%s.debug",
 				 symbol_conf.symfs, self->long_name);
 			break;
-		case DSO__ORIG_UBUNTU:
+		case SYMTAB__UBUNTU_DEBUGINFO:
 			snprintf(name, size, "%s/usr/lib/debug%s",
 				 symbol_conf.symfs, self->long_name);
 			break;
-		case DSO__ORIG_BUILDID: {
+		case SYMTAB__BUILDID_DEBUGINFO: {
 			char build_id_hex[BUILD_ID_SIZE * 2 + 1];
 
 			if (!self->has_build_id)
@@ -1519,11 +1519,11 @@ int dso__load(struct dso *self, struct map *map, symbol_filter_t filter)
 				 symbol_conf.symfs, build_id_hex, build_id_hex + 2);
 			}
 			break;
-		case DSO__ORIG_DSO:
+		case SYMTAB__SYSTEM_PATH_DSO:
 			snprintf(name, size, "%s%s",
 			     symbol_conf.symfs, self->long_name);
 			break;
-		case DSO__ORIG_GUEST_KMODULE:
+		case SYMTAB__GUEST_KMODULE:
 			if (map->groups && machine)
 				root_dir = machine->root_dir;
 			else
@@ -1532,7 +1532,7 @@ int dso__load(struct dso *self, struct map *map, symbol_filter_t filter)
 				 root_dir, self->long_name);
 			break;
 
-		case DSO__ORIG_KMODULE:
+		case SYMTAB__SYSTEM_PATH_KMODULE:
 			snprintf(name, size, "%s%s", symbol_conf.symfs,
 				 self->long_name);
 			break;
@@ -1544,7 +1544,7 @@ int dso__load(struct dso *self, struct map *map, symbol_filter_t filter)
 			 */
 			if (want_symtab) {
 				want_symtab = 0;
-				self->origin = DSO__ORIG_BUILD_ID_CACHE;
+				self->symtab_type = SYMTAB__BUILD_ID_CACHE;
 			} else
 				continue;
 		}
@@ -1757,9 +1757,9 @@ struct map *machine__new_module(struct machine *self, u64 start,
 		return NULL;
 
 	if (machine__is_host(self))
-		dso->origin = DSO__ORIG_KMODULE;
+		dso->symtab_type = SYMTAB__SYSTEM_PATH_KMODULE;
 	else
-		dso->origin = DSO__ORIG_GUEST_KMODULE;
+		dso->symtab_type = SYMTAB__GUEST_KMODULE;
 	map_groups__insert(&self->kmaps, map);
 	return map;
 }
diff --git a/tools/perf/util/symbol.h b/tools/perf/util/symbol.h
index 4d7ed09..db39c0c 100644
--- a/tools/perf/util/symbol.h
+++ b/tools/perf/util/symbol.h
@@ -137,7 +137,7 @@ struct dso {
 	u8		 annotate_warned:1;
 	u8		 sname_alloc:1;
 	u8		 lname_alloc:1;
-	unsigned char	 origin;
+	unsigned char	 symtab_type;
 	u8		 sorted_by_name;
 	u8		 loaded;
 	u8		 build_id[BUILD_ID_SIZE];
@@ -188,18 +188,18 @@ size_t dso__fprintf_buildid(struct dso *self, FILE *fp);
 size_t dso__fprintf_symbols_by_name(struct dso *self, enum map_type type, FILE *fp);
 size_t dso__fprintf(struct dso *self, enum map_type type, FILE *fp);
 
-enum dso_origin {
-	DSO__ORIG_KERNEL = 0,
-	DSO__ORIG_GUEST_KERNEL,
-	DSO__ORIG_JAVA_JIT,
-	DSO__ORIG_BUILD_ID_CACHE,
-	DSO__ORIG_FEDORA,
-	DSO__ORIG_UBUNTU,
-	DSO__ORIG_BUILDID,
-	DSO__ORIG_DSO,
-	DSO__ORIG_GUEST_KMODULE,
-	DSO__ORIG_KMODULE,
-	DSO__ORIG_NOT_FOUND,
+enum symtab_type {
+	SYMTAB__KALLSYMS = 0,
+	SYMTAB__GUEST_KALLSYMS,
+	SYMTAB__JAVA_JIT,
+	SYMTAB__BUILD_ID_CACHE,
+	SYMTAB__FEDORA_DEBUGINFO,
+	SYMTAB__UBUNTU_DEBUGINFO,
+	SYMTAB__BUILDID_DEBUGINFO,
+	SYMTAB__SYSTEM_PATH_DSO,
+	SYMTAB__GUEST_KMODULE,
+	SYMTAB__SYSTEM_PATH_KMODULE,
+	SYMTAB__NOT_FOUND,
 };
 
 char dso__symtab_origin(const struct dso *self);
