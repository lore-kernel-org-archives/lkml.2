Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759018Ab2J3MFg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 08:05:36 -0400
Received: from terminus.zytor.com ([198.137.202.10]:40885 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751682Ab2J3MFe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 08:05:34 -0400
Date: Tue, 30 Oct 2012 05:04:47 -0700
From: tip-bot for Jiri Olsa <jolsa@redhat.com>
Message-ID: <tip-cdd059d731eeb466f51a404ee6cbfafb0fc7c20b@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@kernel.org, a.p.zijlstra@chello.nl,
        namhyung@kernel.org, jolsa@redhat.com, fweisbec@gmail.com,
        tglx@linutronix.de, cjashfor@linux.vnet.ibm.com, mingo@elte.hu
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        namhyung@kernel.org, jolsa@redhat.com, fweisbec@gmail.com,
        tglx@linutronix.de, cjashfor@linux.vnet.ibm.com, mingo@elte.hu
In-Reply-To: <1351372712-21104-6-git-send-email-jolsa@redhat.com>
References: <1351372712-21104-6-git-send-email-jolsa@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools:
  Move dso_* related functions into dso object
Git-Commit-ID: cdd059d731eeb466f51a404ee6cbfafb0fc7c20b
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Tue, 30 Oct 2012 05:04:54 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  cdd059d731eeb466f51a404ee6cbfafb0fc7c20b
Gitweb:     http://git.kernel.org/tip/cdd059d731eeb466f51a404ee6cbfafb0fc7c20b
Author:     Jiri Olsa <jolsa@redhat.com>
AuthorDate: Sat, 27 Oct 2012 23:18:32 +0200
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 29 Oct 2012 11:37:25 -0200

perf tools: Move dso_* related functions into dso object

Moving dso_* related functions into dso object.

Keeping symbol loading related functions still in the symbol object as
it seems more convenient.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Reviewed-by: Namhyung Kim <namhyung@kernel.org>
Tested-by: Namhyung Kim <namhyung@kernel.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1351372712-21104-6-git-send-email-jolsa@redhat.com
[ committer note: Use "symbol.h" instead of <symbol.h> to make it build with O= ]
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Makefile      |    2 +
 tools/perf/util/dso.c    |  594 +++++++++++++++++++++++++++++++++++++++++++++
 tools/perf/util/dso.h    |  148 ++++++++++++
 tools/perf/util/symbol.c |  599 +---------------------------------------------
 tools/perf/util/symbol.h |  134 +----------
 5 files changed, 751 insertions(+), 726 deletions(-)

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 629fc6a..ec63d53 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -327,6 +327,7 @@ LIB_H += util/svghelper.h
 LIB_H += util/tool.h
 LIB_H += util/run-command.h
 LIB_H += util/sigchain.h
+LIB_H += util/dso.h
 LIB_H += util/symbol.h
 LIB_H += util/color.h
 LIB_H += util/values.h
@@ -385,6 +386,7 @@ LIB_OBJS += $(OUTPUT)util/top.o
 LIB_OBJS += $(OUTPUT)util/usage.o
 LIB_OBJS += $(OUTPUT)util/wrapper.o
 LIB_OBJS += $(OUTPUT)util/sigchain.o
+LIB_OBJS += $(OUTPUT)util/dso.o
 LIB_OBJS += $(OUTPUT)util/symbol.o
 LIB_OBJS += $(OUTPUT)util/symbol-elf.o
 LIB_OBJS += $(OUTPUT)util/dso-test-data.o
diff --git a/tools/perf/util/dso.c b/tools/perf/util/dso.c
new file mode 100644
index 0000000..db24a3f
--- /dev/null
+++ b/tools/perf/util/dso.c
@@ -0,0 +1,594 @@
+#include "symbol.h"
+#include "dso.h"
+#include "util.h"
+#include "debug.h"
+
+char dso__symtab_origin(const struct dso *dso)
+{
+	static const char origin[] = {
+		[DSO_BINARY_TYPE__KALLSYMS]		= 'k',
+		[DSO_BINARY_TYPE__VMLINUX]		= 'v',
+		[DSO_BINARY_TYPE__JAVA_JIT]		= 'j',
+		[DSO_BINARY_TYPE__DEBUGLINK]		= 'l',
+		[DSO_BINARY_TYPE__BUILD_ID_CACHE]	= 'B',
+		[DSO_BINARY_TYPE__FEDORA_DEBUGINFO]	= 'f',
+		[DSO_BINARY_TYPE__UBUNTU_DEBUGINFO]	= 'u',
+		[DSO_BINARY_TYPE__BUILDID_DEBUGINFO]	= 'b',
+		[DSO_BINARY_TYPE__SYSTEM_PATH_DSO]	= 'd',
+		[DSO_BINARY_TYPE__SYSTEM_PATH_KMODULE]	= 'K',
+		[DSO_BINARY_TYPE__GUEST_KALLSYMS]	= 'g',
+		[DSO_BINARY_TYPE__GUEST_KMODULE]	= 'G',
+		[DSO_BINARY_TYPE__GUEST_VMLINUX]	= 'V',
+	};
+
+	if (dso == NULL || dso->symtab_type == DSO_BINARY_TYPE__NOT_FOUND)
+		return '!';
+	return origin[dso->symtab_type];
+}
+
+int dso__binary_type_file(struct dso *dso, enum dso_binary_type type,
+			  char *root_dir, char *file, size_t size)
+{
+	char build_id_hex[BUILD_ID_SIZE * 2 + 1];
+	int ret = 0;
+
+	switch (type) {
+	case DSO_BINARY_TYPE__DEBUGLINK: {
+		char *debuglink;
+
+		strncpy(file, dso->long_name, size);
+		debuglink = file + dso->long_name_len;
+		while (debuglink != file && *debuglink != '/')
+			debuglink--;
+		if (*debuglink == '/')
+			debuglink++;
+		filename__read_debuglink(dso->long_name, debuglink,
+					 size - (debuglink - file));
+		}
+		break;
+	case DSO_BINARY_TYPE__BUILD_ID_CACHE:
+		/* skip the locally configured cache if a symfs is given */
+		if (symbol_conf.symfs[0] ||
+		    (dso__build_id_filename(dso, file, size) == NULL))
+			ret = -1;
+		break;
+
+	case DSO_BINARY_TYPE__FEDORA_DEBUGINFO:
+		snprintf(file, size, "%s/usr/lib/debug%s.debug",
+			 symbol_conf.symfs, dso->long_name);
+		break;
+
+	case DSO_BINARY_TYPE__UBUNTU_DEBUGINFO:
+		snprintf(file, size, "%s/usr/lib/debug%s",
+			 symbol_conf.symfs, dso->long_name);
+		break;
+
+	case DSO_BINARY_TYPE__BUILDID_DEBUGINFO:
+		if (!dso->has_build_id) {
+			ret = -1;
+			break;
+		}
+
+		build_id__sprintf(dso->build_id,
+				  sizeof(dso->build_id),
+				  build_id_hex);
+		snprintf(file, size,
+			 "%s/usr/lib/debug/.build-id/%.2s/%s.debug",
+			 symbol_conf.symfs, build_id_hex, build_id_hex + 2);
+		break;
+
+	case DSO_BINARY_TYPE__SYSTEM_PATH_DSO:
+		snprintf(file, size, "%s%s",
+			 symbol_conf.symfs, dso->long_name);
+		break;
+
+	case DSO_BINARY_TYPE__GUEST_KMODULE:
+		snprintf(file, size, "%s%s%s", symbol_conf.symfs,
+			 root_dir, dso->long_name);
+		break;
+
+	case DSO_BINARY_TYPE__SYSTEM_PATH_KMODULE:
+		snprintf(file, size, "%s%s", symbol_conf.symfs,
+			 dso->long_name);
+		break;
+
+	default:
+	case DSO_BINARY_TYPE__KALLSYMS:
+	case DSO_BINARY_TYPE__VMLINUX:
+	case DSO_BINARY_TYPE__GUEST_KALLSYMS:
+	case DSO_BINARY_TYPE__GUEST_VMLINUX:
+	case DSO_BINARY_TYPE__JAVA_JIT:
+	case DSO_BINARY_TYPE__NOT_FOUND:
+		ret = -1;
+		break;
+	}
+
+	return ret;
+}
+
+static int open_dso(struct dso *dso, struct machine *machine)
+{
+	char *root_dir = (char *) "";
+	char *name;
+	int fd;
+
+	name = malloc(PATH_MAX);
+	if (!name)
+		return -ENOMEM;
+
+	if (machine)
+		root_dir = machine->root_dir;
+
+	if (dso__binary_type_file(dso, dso->data_type,
+				  root_dir, name, PATH_MAX)) {
+		free(name);
+		return -EINVAL;
+	}
+
+	fd = open(name, O_RDONLY);
+	free(name);
+	return fd;
+}
+
+int dso__data_fd(struct dso *dso, struct machine *machine)
+{
+	static enum dso_binary_type binary_type_data[] = {
+		DSO_BINARY_TYPE__BUILD_ID_CACHE,
+		DSO_BINARY_TYPE__SYSTEM_PATH_DSO,
+		DSO_BINARY_TYPE__NOT_FOUND,
+	};
+	int i = 0;
+
+	if (dso->data_type != DSO_BINARY_TYPE__NOT_FOUND)
+		return open_dso(dso, machine);
+
+	do {
+		int fd;
+
+		dso->data_type = binary_type_data[i++];
+
+		fd = open_dso(dso, machine);
+		if (fd >= 0)
+			return fd;
+
+	} while (dso->data_type != DSO_BINARY_TYPE__NOT_FOUND);
+
+	return -EINVAL;
+}
+
+static void
+dso_cache__free(struct rb_root *root)
+{
+	struct rb_node *next = rb_first(root);
+
+	while (next) {
+		struct dso_cache *cache;
+
+		cache = rb_entry(next, struct dso_cache, rb_node);
+		next = rb_next(&cache->rb_node);
+		rb_erase(&cache->rb_node, root);
+		free(cache);
+	}
+}
+
+static struct dso_cache*
+dso_cache__find(struct rb_root *root, u64 offset)
+{
+	struct rb_node **p = &root->rb_node;
+	struct rb_node *parent = NULL;
+	struct dso_cache *cache;
+
+	while (*p != NULL) {
+		u64 end;
+
+		parent = *p;
+		cache = rb_entry(parent, struct dso_cache, rb_node);
+		end = cache->offset + DSO__DATA_CACHE_SIZE;
+
+		if (offset < cache->offset)
+			p = &(*p)->rb_left;
+		else if (offset >= end)
+			p = &(*p)->rb_right;
+		else
+			return cache;
+	}
+	return NULL;
+}
+
+static void
+dso_cache__insert(struct rb_root *root, struct dso_cache *new)
+{
+	struct rb_node **p = &root->rb_node;
+	struct rb_node *parent = NULL;
+	struct dso_cache *cache;
+	u64 offset = new->offset;
+
+	while (*p != NULL) {
+		u64 end;
+
+		parent = *p;
+		cache = rb_entry(parent, struct dso_cache, rb_node);
+		end = cache->offset + DSO__DATA_CACHE_SIZE;
+
+		if (offset < cache->offset)
+			p = &(*p)->rb_left;
+		else if (offset >= end)
+			p = &(*p)->rb_right;
+	}
+
+	rb_link_node(&new->rb_node, parent, p);
+	rb_insert_color(&new->rb_node, root);
+}
+
+static ssize_t
+dso_cache__memcpy(struct dso_cache *cache, u64 offset,
+		  u8 *data, u64 size)
+{
+	u64 cache_offset = offset - cache->offset;
+	u64 cache_size   = min(cache->size - cache_offset, size);
+
+	memcpy(data, cache->data + cache_offset, cache_size);
+	return cache_size;
+}
+
+static ssize_t
+dso_cache__read(struct dso *dso, struct machine *machine,
+		 u64 offset, u8 *data, ssize_t size)
+{
+	struct dso_cache *cache;
+	ssize_t ret;
+	int fd;
+
+	fd = dso__data_fd(dso, machine);
+	if (fd < 0)
+		return -1;
+
+	do {
+		u64 cache_offset;
+
+		ret = -ENOMEM;
+
+		cache = zalloc(sizeof(*cache) + DSO__DATA_CACHE_SIZE);
+		if (!cache)
+			break;
+
+		cache_offset = offset & DSO__DATA_CACHE_MASK;
+		ret = -EINVAL;
+
+		if (-1 == lseek(fd, cache_offset, SEEK_SET))
+			break;
+
+		ret = read(fd, cache->data, DSO__DATA_CACHE_SIZE);
+		if (ret <= 0)
+			break;
+
+		cache->offset = cache_offset;
+		cache->size   = ret;
+		dso_cache__insert(&dso->cache, cache);
+
+		ret = dso_cache__memcpy(cache, offset, data, size);
+
+	} while (0);
+
+	if (ret <= 0)
+		free(cache);
+
+	close(fd);
+	return ret;
+}
+
+static ssize_t dso_cache_read(struct dso *dso, struct machine *machine,
+			      u64 offset, u8 *data, ssize_t size)
+{
+	struct dso_cache *cache;
+
+	cache = dso_cache__find(&dso->cache, offset);
+	if (cache)
+		return dso_cache__memcpy(cache, offset, data, size);
+	else
+		return dso_cache__read(dso, machine, offset, data, size);
+}
+
+ssize_t dso__data_read_offset(struct dso *dso, struct machine *machine,
+			      u64 offset, u8 *data, ssize_t size)
+{
+	ssize_t r = 0;
+	u8 *p = data;
+
+	do {
+		ssize_t ret;
+
+		ret = dso_cache_read(dso, machine, offset, p, size);
+		if (ret < 0)
+			return ret;
+
+		/* Reached EOF, return what we have. */
+		if (!ret)
+			break;
+
+		BUG_ON(ret > size);
+
+		r      += ret;
+		p      += ret;
+		offset += ret;
+		size   -= ret;
+
+	} while (size);
+
+	return r;
+}
+
+ssize_t dso__data_read_addr(struct dso *dso, struct map *map,
+			    struct machine *machine, u64 addr,
+			    u8 *data, ssize_t size)
+{
+	u64 offset = map->map_ip(map, addr);
+	return dso__data_read_offset(dso, machine, offset, data, size);
+}
+
+struct map *dso__new_map(const char *name)
+{
+	struct map *map = NULL;
+	struct dso *dso = dso__new(name);
+
+	if (dso)
+		map = map__new2(0, dso, MAP__FUNCTION);
+
+	return map;
+}
+
+struct dso *dso__kernel_findnew(struct machine *machine, const char *name,
+		    const char *short_name, int dso_type)
+{
+	/*
+	 * The kernel dso could be created by build_id processing.
+	 */
+	struct dso *dso = __dsos__findnew(&machine->kernel_dsos, name);
+
+	/*
+	 * We need to run this in all cases, since during the build_id
+	 * processing we had no idea this was the kernel dso.
+	 */
+	if (dso != NULL) {
+		dso__set_short_name(dso, short_name);
+		dso->kernel = dso_type;
+	}
+
+	return dso;
+}
+
+void dso__set_long_name(struct dso *dso, char *name)
+{
+	if (name == NULL)
+		return;
+	dso->long_name = name;
+	dso->long_name_len = strlen(name);
+}
+
+void dso__set_short_name(struct dso *dso, const char *name)
+{
+	if (name == NULL)
+		return;
+	dso->short_name = name;
+	dso->short_name_len = strlen(name);
+}
+
+static void dso__set_basename(struct dso *dso)
+{
+	dso__set_short_name(dso, basename(dso->long_name));
+}
+
+int dso__name_len(const struct dso *dso)
+{
+	if (!dso)
+		return strlen("[unknown]");
+	if (verbose)
+		return dso->long_name_len;
+
+	return dso->short_name_len;
+}
+
+bool dso__loaded(const struct dso *dso, enum map_type type)
+{
+	return dso->loaded & (1 << type);
+}
+
+bool dso__sorted_by_name(const struct dso *dso, enum map_type type)
+{
+	return dso->sorted_by_name & (1 << type);
+}
+
+void dso__set_sorted_by_name(struct dso *dso, enum map_type type)
+{
+	dso->sorted_by_name |= (1 << type);
+}
+
+struct dso *dso__new(const char *name)
+{
+	struct dso *dso = calloc(1, sizeof(*dso) + strlen(name) + 1);
+
+	if (dso != NULL) {
+		int i;
+		strcpy(dso->name, name);
+		dso__set_long_name(dso, dso->name);
+		dso__set_short_name(dso, dso->name);
+		for (i = 0; i < MAP__NR_TYPES; ++i)
+			dso->symbols[i] = dso->symbol_names[i] = RB_ROOT;
+		dso->cache = RB_ROOT;
+		dso->symtab_type = DSO_BINARY_TYPE__NOT_FOUND;
+		dso->data_type   = DSO_BINARY_TYPE__NOT_FOUND;
+		dso->loaded = 0;
+		dso->sorted_by_name = 0;
+		dso->has_build_id = 0;
+		dso->kernel = DSO_TYPE_USER;
+		dso->needs_swap = DSO_SWAP__UNSET;
+		INIT_LIST_HEAD(&dso->node);
+	}
+
+	return dso;
+}
+
+void dso__delete(struct dso *dso)
+{
+	int i;
+	for (i = 0; i < MAP__NR_TYPES; ++i)
+		symbols__delete(&dso->symbols[i]);
+	if (dso->sname_alloc)
+		free((char *)dso->short_name);
+	if (dso->lname_alloc)
+		free(dso->long_name);
+	dso_cache__free(&dso->cache);
+	free(dso);
+}
+
+void dso__set_build_id(struct dso *dso, void *build_id)
+{
+	memcpy(dso->build_id, build_id, sizeof(dso->build_id));
+	dso->has_build_id = 1;
+}
+
+bool dso__build_id_equal(const struct dso *dso, u8 *build_id)
+{
+	return memcmp(dso->build_id, build_id, sizeof(dso->build_id)) == 0;
+}
+
+void dso__read_running_kernel_build_id(struct dso *dso, struct machine *machine)
+{
+	char path[PATH_MAX];
+
+	if (machine__is_default_guest(machine))
+		return;
+	sprintf(path, "%s/sys/kernel/notes", machine->root_dir);
+	if (sysfs__read_build_id(path, dso->build_id,
+				 sizeof(dso->build_id)) == 0)
+		dso->has_build_id = true;
+}
+
+int dso__kernel_module_get_build_id(struct dso *dso,
+				    const char *root_dir)
+{
+	char filename[PATH_MAX];
+	/*
+	 * kernel module short names are of the form "[module]" and
+	 * we need just "module" here.
+	 */
+	const char *name = dso->short_name + 1;
+
+	snprintf(filename, sizeof(filename),
+		 "%s/sys/module/%.*s/notes/.note.gnu.build-id",
+		 root_dir, (int)strlen(name) - 1, name);
+
+	if (sysfs__read_build_id(filename, dso->build_id,
+				 sizeof(dso->build_id)) == 0)
+		dso->has_build_id = true;
+
+	return 0;
+}
+
+bool __dsos__read_build_ids(struct list_head *head, bool with_hits)
+{
+	bool have_build_id = false;
+	struct dso *pos;
+
+	list_for_each_entry(pos, head, node) {
+		if (with_hits && !pos->hit)
+			continue;
+		if (pos->has_build_id) {
+			have_build_id = true;
+			continue;
+		}
+		if (filename__read_build_id(pos->long_name, pos->build_id,
+					    sizeof(pos->build_id)) > 0) {
+			have_build_id	  = true;
+			pos->has_build_id = true;
+		}
+	}
+
+	return have_build_id;
+}
+
+void dsos__add(struct list_head *head, struct dso *dso)
+{
+	list_add_tail(&dso->node, head);
+}
+
+struct dso *dsos__find(struct list_head *head, const char *name)
+{
+	struct dso *pos;
+
+	list_for_each_entry(pos, head, node)
+		if (strcmp(pos->long_name, name) == 0)
+			return pos;
+	return NULL;
+}
+
+struct dso *__dsos__findnew(struct list_head *head, const char *name)
+{
+	struct dso *dso = dsos__find(head, name);
+
+	if (!dso) {
+		dso = dso__new(name);
+		if (dso != NULL) {
+			dsos__add(head, dso);
+			dso__set_basename(dso);
+		}
+	}
+
+	return dso;
+}
+
+size_t __dsos__fprintf_buildid(struct list_head *head, FILE *fp,
+			       bool with_hits)
+{
+	struct dso *pos;
+	size_t ret = 0;
+
+	list_for_each_entry(pos, head, node) {
+		if (with_hits && !pos->hit)
+			continue;
+		ret += dso__fprintf_buildid(pos, fp);
+		ret += fprintf(fp, " %s\n", pos->long_name);
+	}
+	return ret;
+}
+
+size_t __dsos__fprintf(struct list_head *head, FILE *fp)
+{
+	struct dso *pos;
+	size_t ret = 0;
+
+	list_for_each_entry(pos, head, node) {
+		int i;
+		for (i = 0; i < MAP__NR_TYPES; ++i)
+			ret += dso__fprintf(pos, i, fp);
+	}
+
+	return ret;
+}
+
+size_t dso__fprintf_buildid(struct dso *dso, FILE *fp)
+{
+	char sbuild_id[BUILD_ID_SIZE * 2 + 1];
+
+	build_id__sprintf(dso->build_id, sizeof(dso->build_id), sbuild_id);
+	return fprintf(fp, "%s", sbuild_id);
+}
+
+size_t dso__fprintf(struct dso *dso, enum map_type type, FILE *fp)
+{
+	struct rb_node *nd;
+	size_t ret = fprintf(fp, "dso: %s (", dso->short_name);
+
+	if (dso->short_name != dso->long_name)
+		ret += fprintf(fp, "%s, ", dso->long_name);
+	ret += fprintf(fp, "%s, %sloaded, ", map_type__name[type],
+		       dso->loaded ? "" : "NOT ");
+	ret += dso__fprintf_buildid(dso, fp);
+	ret += fprintf(fp, ")\n");
+	for (nd = rb_first(&dso->symbols[type]); nd; nd = rb_next(nd)) {
+		struct symbol *pos = rb_entry(nd, struct symbol, rb_node);
+		ret += symbol__fprintf(pos, fp);
+	}
+
+	return ret;
+}
diff --git a/tools/perf/util/dso.h b/tools/perf/util/dso.h
new file mode 100644
index 0000000..e032769
--- /dev/null
+++ b/tools/perf/util/dso.h
@@ -0,0 +1,148 @@
+#ifndef __PERF_DSO
+#define __PERF_DSO
+
+#include <linux/types.h>
+#include <linux/rbtree.h>
+#include "types.h"
+#include "map.h"
+
+enum dso_binary_type {
+	DSO_BINARY_TYPE__KALLSYMS = 0,
+	DSO_BINARY_TYPE__GUEST_KALLSYMS,
+	DSO_BINARY_TYPE__VMLINUX,
+	DSO_BINARY_TYPE__GUEST_VMLINUX,
+	DSO_BINARY_TYPE__JAVA_JIT,
+	DSO_BINARY_TYPE__DEBUGLINK,
+	DSO_BINARY_TYPE__BUILD_ID_CACHE,
+	DSO_BINARY_TYPE__FEDORA_DEBUGINFO,
+	DSO_BINARY_TYPE__UBUNTU_DEBUGINFO,
+	DSO_BINARY_TYPE__BUILDID_DEBUGINFO,
+	DSO_BINARY_TYPE__SYSTEM_PATH_DSO,
+	DSO_BINARY_TYPE__GUEST_KMODULE,
+	DSO_BINARY_TYPE__SYSTEM_PATH_KMODULE,
+	DSO_BINARY_TYPE__NOT_FOUND,
+};
+
+enum dso_kernel_type {
+	DSO_TYPE_USER = 0,
+	DSO_TYPE_KERNEL,
+	DSO_TYPE_GUEST_KERNEL
+};
+
+enum dso_swap_type {
+	DSO_SWAP__UNSET,
+	DSO_SWAP__NO,
+	DSO_SWAP__YES,
+};
+
+#define DSO__SWAP(dso, type, val)			\
+({							\
+	type ____r = val;				\
+	BUG_ON(dso->needs_swap == DSO_SWAP__UNSET);	\
+	if (dso->needs_swap == DSO_SWAP__YES) {		\
+		switch (sizeof(____r)) {		\
+		case 2:					\
+			____r = bswap_16(val);		\
+			break;				\
+		case 4:					\
+			____r = bswap_32(val);		\
+			break;				\
+		case 8:					\
+			____r = bswap_64(val);		\
+			break;				\
+		default:				\
+			BUG_ON(1);			\
+		}					\
+	}						\
+	____r;						\
+})
+
+#define DSO__DATA_CACHE_SIZE 4096
+#define DSO__DATA_CACHE_MASK ~(DSO__DATA_CACHE_SIZE - 1)
+
+struct dso_cache {
+	struct rb_node	rb_node;
+	u64 offset;
+	u64 size;
+	char data[0];
+};
+
+struct dso {
+	struct list_head node;
+	struct rb_root	 symbols[MAP__NR_TYPES];
+	struct rb_root	 symbol_names[MAP__NR_TYPES];
+	struct rb_root	 cache;
+	enum dso_kernel_type	kernel;
+	enum dso_swap_type	needs_swap;
+	enum dso_binary_type	symtab_type;
+	enum dso_binary_type	data_type;
+	u8		 adjust_symbols:1;
+	u8		 has_build_id:1;
+	u8		 hit:1;
+	u8		 annotate_warned:1;
+	u8		 sname_alloc:1;
+	u8		 lname_alloc:1;
+	u8		 sorted_by_name;
+	u8		 loaded;
+	u8		 build_id[BUILD_ID_SIZE];
+	const char	 *short_name;
+	char		 *long_name;
+	u16		 long_name_len;
+	u16		 short_name_len;
+	char		 name[0];
+};
+
+static inline void dso__set_loaded(struct dso *dso, enum map_type type)
+{
+	dso->loaded |= (1 << type);
+}
+
+struct dso *dso__new(const char *name);
+void dso__delete(struct dso *dso);
+
+void dso__set_short_name(struct dso *dso, const char *name);
+void dso__set_long_name(struct dso *dso, char *name);
+
+int dso__name_len(const struct dso *dso);
+
+bool dso__loaded(const struct dso *dso, enum map_type type);
+
+bool dso__sorted_by_name(const struct dso *dso, enum map_type type);
+void dso__set_sorted_by_name(struct dso *dso, enum map_type type);
+void dso__sort_by_name(struct dso *dso, enum map_type type);
+
+void dso__set_build_id(struct dso *dso, void *build_id);
+bool dso__build_id_equal(const struct dso *dso, u8 *build_id);
+void dso__read_running_kernel_build_id(struct dso *dso,
+				       struct machine *machine);
+int dso__kernel_module_get_build_id(struct dso *dso, const char *root_dir);
+
+char dso__symtab_origin(const struct dso *dso);
+int dso__binary_type_file(struct dso *dso, enum dso_binary_type type,
+			  char *root_dir, char *file, size_t size);
+
+int dso__data_fd(struct dso *dso, struct machine *machine);
+ssize_t dso__data_read_offset(struct dso *dso, struct machine *machine,
+			      u64 offset, u8 *data, ssize_t size);
+ssize_t dso__data_read_addr(struct dso *dso, struct map *map,
+			    struct machine *machine, u64 addr,
+			    u8 *data, ssize_t size);
+
+struct map *dso__new_map(const char *name);
+struct dso *dso__kernel_findnew(struct machine *machine, const char *name,
+				const char *short_name, int dso_type);
+
+void dsos__add(struct list_head *head, struct dso *dso);
+struct dso *dsos__find(struct list_head *head, const char *name);
+struct dso *__dsos__findnew(struct list_head *head, const char *name);
+bool __dsos__read_build_ids(struct list_head *head, bool with_hits);
+
+size_t __dsos__fprintf_buildid(struct list_head *head, FILE *fp,
+			       bool with_hits);
+size_t __dsos__fprintf(struct list_head *head, FILE *fp);
+
+size_t dso__fprintf_buildid(struct dso *dso, FILE *fp);
+size_t dso__fprintf_symbols_by_name(struct dso *dso,
+				    enum map_type type, FILE *fp);
+size_t dso__fprintf(struct dso *dso, enum map_type type, FILE *fp);
+#endif /* __PERF_DSO */
diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index d3b1ecc..624c65e 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -23,7 +23,6 @@
 #define KSYM_NAME_LEN 256
 #endif
 
-static void dso_cache__free(struct rb_root *root);
 static int dso__load_kernel_sym(struct dso *dso, struct map *map,
 				symbol_filter_t filter);
 static int dso__load_guest_kernel_sym(struct dso *dso, struct map *map,
@@ -56,39 +55,6 @@ static enum dso_binary_type binary_type_symtab[] = {
 
 #define DSO_BINARY_TYPE__SYMTAB_CNT ARRAY_SIZE(binary_type_symtab)
 
-static enum dso_binary_type binary_type_data[] = {
-	DSO_BINARY_TYPE__BUILD_ID_CACHE,
-	DSO_BINARY_TYPE__SYSTEM_PATH_DSO,
-	DSO_BINARY_TYPE__NOT_FOUND,
-};
-
-#define DSO_BINARY_TYPE__DATA_CNT ARRAY_SIZE(binary_type_data)
-
-int dso__name_len(const struct dso *dso)
-{
-	if (!dso)
-		return strlen("[unknown]");
-	if (verbose)
-		return dso->long_name_len;
-
-	return dso->short_name_len;
-}
-
-bool dso__loaded(const struct dso *dso, enum map_type type)
-{
-	return dso->loaded & (1 << type);
-}
-
-bool dso__sorted_by_name(const struct dso *dso, enum map_type type)
-{
-	return dso->sorted_by_name & (1 << type);
-}
-
-static void dso__set_sorted_by_name(struct dso *dso, enum map_type type)
-{
-	dso->sorted_by_name |= (1 << type);
-}
-
 bool symbol_type__is_a(char symbol_type, enum map_type map_type)
 {
 	symbol_type = toupper(symbol_type);
@@ -270,7 +236,7 @@ void symbol__delete(struct symbol *sym)
 	free(((void *)sym) - symbol_conf.priv_size);
 }
 
-static size_t symbol__fprintf(struct symbol *sym, FILE *fp)
+size_t symbol__fprintf(struct symbol *sym, FILE *fp)
 {
 	return fprintf(fp, " %" PRIx64 "-%" PRIx64 " %c %s\n",
 		       sym->start, sym->end,
@@ -301,53 +267,7 @@ size_t symbol__fprintf_symname(const struct symbol *sym, FILE *fp)
 	return symbol__fprintf_symname_offs(sym, NULL, fp);
 }
 
-void dso__set_long_name(struct dso *dso, char *name)
-{
-	if (name == NULL)
-		return;
-	dso->long_name = name;
-	dso->long_name_len = strlen(name);
-}
-
-static void dso__set_short_name(struct dso *dso, const char *name)
-{
-	if (name == NULL)
-		return;
-	dso->short_name = name;
-	dso->short_name_len = strlen(name);
-}
-
-static void dso__set_basename(struct dso *dso)
-{
-	dso__set_short_name(dso, basename(dso->long_name));
-}
-
-struct dso *dso__new(const char *name)
-{
-	struct dso *dso = calloc(1, sizeof(*dso) + strlen(name) + 1);
-
-	if (dso != NULL) {
-		int i;
-		strcpy(dso->name, name);
-		dso__set_long_name(dso, dso->name);
-		dso__set_short_name(dso, dso->name);
-		for (i = 0; i < MAP__NR_TYPES; ++i)
-			dso->symbols[i] = dso->symbol_names[i] = RB_ROOT;
-		dso->cache = RB_ROOT;
-		dso->symtab_type = DSO_BINARY_TYPE__NOT_FOUND;
-		dso->data_type   = DSO_BINARY_TYPE__NOT_FOUND;
-		dso->loaded = 0;
-		dso->sorted_by_name = 0;
-		dso->has_build_id = 0;
-		dso->kernel = DSO_TYPE_USER;
-		dso->needs_swap = DSO_SWAP__UNSET;
-		INIT_LIST_HEAD(&dso->node);
-	}
-
-	return dso;
-}
-
-static void symbols__delete(struct rb_root *symbols)
+void symbols__delete(struct rb_root *symbols)
 {
 	struct symbol *pos;
 	struct rb_node *next = rb_first(symbols);
@@ -360,25 +280,6 @@ static void symbols__delete(struct rb_root *symbols)
 	}
 }
 
-void dso__delete(struct dso *dso)
-{
-	int i;
-	for (i = 0; i < MAP__NR_TYPES; ++i)
-		symbols__delete(&dso->symbols[i]);
-	if (dso->sname_alloc)
-		free((char *)dso->short_name);
-	if (dso->lname_alloc)
-		free(dso->long_name);
-	dso_cache__free(&dso->cache);
-	free(dso);
-}
-
-void dso__set_build_id(struct dso *dso, void *build_id)
-{
-	memcpy(dso->build_id, build_id, sizeof(dso->build_id));
-	dso->has_build_id = 1;
-}
-
 void symbols__insert(struct rb_root *symbols, struct symbol *sym)
 {
 	struct rb_node **p = &symbols->rb_node;
@@ -504,14 +405,6 @@ void dso__sort_by_name(struct dso *dso, enum map_type type)
 				     &dso->symbols[type]);
 }
 
-size_t dso__fprintf_buildid(struct dso *dso, FILE *fp)
-{
-	char sbuild_id[BUILD_ID_SIZE * 2 + 1];
-
-	build_id__sprintf(dso->build_id, sizeof(dso->build_id), sbuild_id);
-	return fprintf(fp, "%s", sbuild_id);
-}
-
 size_t dso__fprintf_symbols_by_name(struct dso *dso,
 				    enum map_type type, FILE *fp)
 {
@@ -527,25 +420,6 @@ size_t dso__fprintf_symbols_by_name(struct dso *dso,
 	return ret;
 }
 
-size_t dso__fprintf(struct dso *dso, enum map_type type, FILE *fp)
-{
-	struct rb_node *nd;
-	size_t ret = fprintf(fp, "dso: %s (", dso->short_name);
-
-	if (dso->short_name != dso->long_name)
-		ret += fprintf(fp, "%s, ", dso->long_name);
-	ret += fprintf(fp, "%s, %sloaded, ", map_type__name[type],
-		       dso->loaded ? "" : "NOT ");
-	ret += dso__fprintf_buildid(dso, fp);
-	ret += fprintf(fp, ")\n");
-	for (nd = rb_first(&dso->symbols[type]); nd; nd = rb_next(nd)) {
-		struct symbol *pos = rb_entry(nd, struct symbol, rb_node);
-		ret += symbol__fprintf(pos, fp);
-	}
-
-	return ret;
-}
-
 int kallsyms__parse(const char *filename, void *arg,
 		    int (*process_symbol)(void *arg, const char *name,
 					  char type, u64 start))
@@ -877,136 +751,6 @@ out_failure:
 	return -1;
 }
 
-bool dso__build_id_equal(const struct dso *dso, u8 *build_id)
-{
-	return memcmp(dso->build_id, build_id, sizeof(dso->build_id)) == 0;
-}
-
-bool __dsos__read_build_ids(struct list_head *head, bool with_hits)
-{
-	bool have_build_id = false;
-	struct dso *pos;
-
-	list_for_each_entry(pos, head, node) {
-		if (with_hits && !pos->hit)
-			continue;
-		if (pos->has_build_id) {
-			have_build_id = true;
-			continue;
-		}
-		if (filename__read_build_id(pos->long_name, pos->build_id,
-					    sizeof(pos->build_id)) > 0) {
-			have_build_id	  = true;
-			pos->has_build_id = true;
-		}
-	}
-
-	return have_build_id;
-}
-
-char dso__symtab_origin(const struct dso *dso)
-{
-	static const char origin[] = {
-		[DSO_BINARY_TYPE__KALLSYMS]		= 'k',
-		[DSO_BINARY_TYPE__VMLINUX]		= 'v',
-		[DSO_BINARY_TYPE__JAVA_JIT]		= 'j',
-		[DSO_BINARY_TYPE__DEBUGLINK]		= 'l',
-		[DSO_BINARY_TYPE__BUILD_ID_CACHE]	= 'B',
-		[DSO_BINARY_TYPE__FEDORA_DEBUGINFO]	= 'f',
-		[DSO_BINARY_TYPE__UBUNTU_DEBUGINFO]	= 'u',
-		[DSO_BINARY_TYPE__BUILDID_DEBUGINFO]	= 'b',
-		[DSO_BINARY_TYPE__SYSTEM_PATH_DSO]	= 'd',
-		[DSO_BINARY_TYPE__SYSTEM_PATH_KMODULE]	= 'K',
-		[DSO_BINARY_TYPE__GUEST_KALLSYMS]	= 'g',
-		[DSO_BINARY_TYPE__GUEST_KMODULE]	= 'G',
-		[DSO_BINARY_TYPE__GUEST_VMLINUX]	= 'V',
-	};
-
-	if (dso == NULL || dso->symtab_type == DSO_BINARY_TYPE__NOT_FOUND)
-		return '!';
-	return origin[dso->symtab_type];
-}
-
-int dso__binary_type_file(struct dso *dso, enum dso_binary_type type,
-			  char *root_dir, char *file, size_t size)
-{
-	char build_id_hex[BUILD_ID_SIZE * 2 + 1];
-	int ret = 0;
-
-	switch (type) {
-	case DSO_BINARY_TYPE__DEBUGLINK: {
-		char *debuglink;
-
-		strncpy(file, dso->long_name, size);
-		debuglink = file + dso->long_name_len;
-		while (debuglink != file && *debuglink != '/')
-			debuglink--;
-		if (*debuglink == '/')
-			debuglink++;
-		filename__read_debuglink(dso->long_name, debuglink,
-					 size - (debuglink - file));
-		}
-		break;
-	case DSO_BINARY_TYPE__BUILD_ID_CACHE:
-		/* skip the locally configured cache if a symfs is given */
-		if (symbol_conf.symfs[0] ||
-		    (dso__build_id_filename(dso, file, size) == NULL))
-			ret = -1;
-		break;
-
-	case DSO_BINARY_TYPE__FEDORA_DEBUGINFO:
-		snprintf(file, size, "%s/usr/lib/debug%s.debug",
-			 symbol_conf.symfs, dso->long_name);
-		break;
-
-	case DSO_BINARY_TYPE__UBUNTU_DEBUGINFO:
-		snprintf(file, size, "%s/usr/lib/debug%s",
-			 symbol_conf.symfs, dso->long_name);
-		break;
-
-	case DSO_BINARY_TYPE__BUILDID_DEBUGINFO:
-		if (!dso->has_build_id) {
-			ret = -1;
-			break;
-		}
-
-		build_id__sprintf(dso->build_id,
-				  sizeof(dso->build_id),
-				  build_id_hex);
-		snprintf(file, size,
-			 "%s/usr/lib/debug/.build-id/%.2s/%s.debug",
-			 symbol_conf.symfs, build_id_hex, build_id_hex + 2);
-		break;
-
-	case DSO_BINARY_TYPE__SYSTEM_PATH_DSO:
-		snprintf(file, size, "%s%s",
-			 symbol_conf.symfs, dso->long_name);
-		break;
-
-	case DSO_BINARY_TYPE__GUEST_KMODULE:
-		snprintf(file, size, "%s%s%s", symbol_conf.symfs,
-			 root_dir, dso->long_name);
-		break;
-
-	case DSO_BINARY_TYPE__SYSTEM_PATH_KMODULE:
-		snprintf(file, size, "%s%s", symbol_conf.symfs,
-			 dso->long_name);
-		break;
-
-	default:
-	case DSO_BINARY_TYPE__KALLSYMS:
-	case DSO_BINARY_TYPE__VMLINUX:
-	case DSO_BINARY_TYPE__GUEST_KALLSYMS:
-	case DSO_BINARY_TYPE__GUEST_VMLINUX:
-	case DSO_BINARY_TYPE__JAVA_JIT:
-	case DSO_BINARY_TYPE__NOT_FOUND:
-		ret = -1;
-		break;
-	}
-
-	return ret;
-}
-
 int dso__load(struct dso *dso, struct map *map, symbol_filter_t filter)
 {
 	char *name;
@@ -1142,27 +886,6 @@ struct map *map_groups__find_by_name(struct map_groups *mg,
 	return NULL;
 }
 
-static int dso__kernel_module_get_build_id(struct dso *dso,
-					   const char *root_dir)
-{
-	char filename[PATH_MAX];
-	/*
-	 * kernel module short names are of the form "[module]" and
-	 * we need just "module" here.
-	 */
-	const char *name = dso->short_name + 1;
-
-	snprintf(filename, sizeof(filename),
-		 "%s/sys/module/%.*s/notes/.note.gnu.build-id",
-		 root_dir, (int)strlen(name) - 1, name);
-
-	if (sysfs__read_build_id(filename, dso->build_id,
-				 sizeof(dso->build_id)) == 0)
-		dso->has_build_id = true;
-
-	return 0;
-}
-
 static int map_groups__set_modules_path_dir(struct map_groups *mg,
 				const char *dir_name)
 {
@@ -1576,50 +1299,6 @@ out_try_fixup:
 	return err;
 }
 
-void dsos__add(struct list_head *head, struct dso *dso)
-{
-	list_add_tail(&dso->node, head);
-}
-
-struct dso *dsos__find(struct list_head *head, const char *name)
-{
-	struct dso *pos;
-
-	list_for_each_entry(pos, head, node)
-		if (strcmp(pos->long_name, name) == 0)
-			return pos;
-	return NULL;
-}
-
-struct dso *__dsos__findnew(struct list_head *head, const char *name)
-{
-	struct dso *dso = dsos__find(head, name);
-
-	if (!dso) {
-		dso = dso__new(name);
-		if (dso != NULL) {
-			dsos__add(head, dso);
-			dso__set_basename(dso);
-		}
-	}
-
-	return dso;
-}
-
-size_t __dsos__fprintf(struct list_head *head, FILE *fp)
-{
-	struct dso *pos;
-	size_t ret = 0;
-
-	list_for_each_entry(pos, head, node) {
-		int i;
-		for (i = 0; i < MAP__NR_TYPES; ++i)
-			ret += dso__fprintf(pos, i, fp);
-	}
-
-	return ret;
-}
-
 size_t machines__fprintf_dsos(struct rb_root *machines, FILE *fp)
 {
 	struct rb_node *nd;
@@ -1634,21 +1313,6 @@ size_t machines__fprintf_dsos(struct rb_root *machines, FILE *fp)
 	return ret;
 }
 
-static size_t __dsos__fprintf_buildid(struct list_head *head, FILE *fp,
-				      bool with_hits)
-{
-	struct dso *pos;
-	size_t ret = 0;
-
-	list_for_each_entry(pos, head, node) {
-		if (with_hits && !pos->hit)
-			continue;
-		ret += dso__fprintf_buildid(pos, fp);
-		ret += fprintf(fp, " %s\n", pos->long_name);
-	}
-	return ret;
-}
-
 size_t machine__fprintf_dsos_buildid(struct machine *machine, FILE *fp,
 				     bool with_hits)
 {
@@ -1669,39 +1333,6 @@ size_t machines__fprintf_dsos_buildid(struct rb_root *machines,
 	return ret;
 }
 
-static struct dso*
-dso__kernel_findnew(struct machine *machine, const char *name,
-		    const char *short_name, int dso_type)
-{
-	/*
-	 * The kernel dso could be created by build_id processing.
-	 */
-	struct dso *dso = __dsos__findnew(&machine->kernel_dsos, name);
-
-	/*
-	 * We need to run this in all cases, since during the build_id
-	 * processing we had no idea this was the kernel dso.
-	 */
-	if (dso != NULL) {
-		dso__set_short_name(dso, short_name);
-		dso->kernel = dso_type;
-	}
-
-	return dso;
-}
-
-void dso__read_running_kernel_build_id(struct dso *dso, struct machine *machine)
-{
-	char path[PATH_MAX];
-
-	if (machine__is_default_guest(machine))
-		return;
-	sprintf(path, "%s/sys/kernel/notes", machine->root_dir);
-	if (sysfs__read_build_id(path, dso->build_id,
-				 sizeof(dso->build_id)) == 0)
-		dso->has_build_id = true;
-}
-
 static struct dso *machine__get_kernel(struct machine *machine)
 {
 	const char *vmlinux_name = NULL;
@@ -2144,229 +1775,3 @@ int machine__load_vmlinux_path(struct machine *machine, enum map_type type,
 
 	return ret;
 }
-
-struct map *dso__new_map(const char *name)
-{
-	struct map *map = NULL;
-	struct dso *dso = dso__new(name);
-
-	if (dso)
-		map = map__new2(0, dso, MAP__FUNCTION);
-
-	return map;
-}
-
-static int open_dso(struct dso *dso, struct machine *machine)
-{
-	char *root_dir = (char *) "";
-	char *name;
-	int fd;
-
-	name = malloc(PATH_MAX);
-	if (!name)
-		return -ENOMEM;
-
-	if (machine)
-		root_dir = machine->root_dir;
-
-	if (dso__binary_type_file(dso, dso->data_type,
-				  root_dir, name, PATH_MAX)) {
-		free(name);
-		return -EINVAL;
-	}
-
-	fd = open(name, O_RDONLY);
-	free(name);
-	return fd;
-}
-
-int dso__data_fd(struct dso *dso, struct machine *machine)
-{
-	int i = 0;
-
-	if (dso->data_type != DSO_BINARY_TYPE__NOT_FOUND)
-		return open_dso(dso, machine);
-
-	do {
-		int fd;
-
-		dso->data_type = binary_type_data[i++];
-
-		fd = open_dso(dso, machine);
-		if (fd >= 0)
-			return fd;
-
-	} while (dso->data_type != DSO_BINARY_TYPE__NOT_FOUND);
-
-	return -EINVAL;
-}
-
-static void
-dso_cache__free(struct rb_root *root)
-{
-	struct rb_node *next = rb_first(root);
-
-	while (next) {
-		struct dso_cache *cache;
-
-		cache = rb_entry(next, struct dso_cache, rb_node);
-		next = rb_next(&cache->rb_node);
-		rb_erase(&cache->rb_node, root);
-		free(cache);
-	}
-}
-
-static struct dso_cache*
-dso_cache__find(struct rb_root *root, u64 offset)
-{
-	struct rb_node **p = &root->rb_node;
-	struct rb_node *parent = NULL;
-	struct dso_cache *cache;
-
-	while (*p != NULL) {
-		u64 end;
-
-		parent = *p;
-		cache = rb_entry(parent, struct dso_cache, rb_node);
-		end = cache->offset + DSO__DATA_CACHE_SIZE;
-
-		if (offset < cache->offset)
-			p = &(*p)->rb_left;
-		else if (offset >= end)
-			p = &(*p)->rb_right;
-		else
-			return cache;
-	}
-	return NULL;
-}
-
-static void
-dso_cache__insert(struct rb_root *root, struct dso_cache *new)
-{
-	struct rb_node **p = &root->rb_node;
-	struct rb_node *parent = NULL;
-	struct dso_cache *cache;
-	u64 offset = new->offset;
-
-	while (*p != NULL) {
-		u64 end;
-
-		parent = *p;
-		cache = rb_entry(parent, struct dso_cache, rb_node);
-		end = cache->offset + DSO__DATA_CACHE_SIZE;
-
-		if (offset < cache->offset)
-			p = &(*p)->rb_left;
-		else if (offset >= end)
-			p = &(*p)->rb_right;
-	}
-
-	rb_link_node(&new->rb_node, parent, p);
-	rb_insert_color(&new->rb_node, root);
-}
-
-static ssize_t
-dso_cache__memcpy(struct dso_cache *cache, u64 offset,
-		  u8 *data, u64 size)
-{
-	u64 cache_offset = offset - cache->offset;
-	u64 cache_size   = min(cache->size - cache_offset, size);
-
-	memcpy(data, cache->data + cache_offset, cache_size);
-	return cache_size;
-}
-
-static ssize_t
-dso_cache__read(struct dso *dso, struct machine *machine,
-		 u64 offset, u8 *data, ssize_t size)
-{
-	struct dso_cache *cache;
-	ssize_t ret;
-	int fd;
-
-	fd = dso__data_fd(dso, machine);
-	if (fd < 0)
-		return -1;
-
-	do {
-		u64 cache_offset;
-
-		ret = -ENOMEM;
-
-		cache = zalloc(sizeof(*cache) + DSO__DATA_CACHE_SIZE);
-		if (!cache)
-			break;
-
-		cache_offset = offset & DSO__DATA_CACHE_MASK;
-		ret = -EINVAL;
-
-		if (-1 == lseek(fd, cache_offset, SEEK_SET))
-			break;
-
-		ret = read(fd, cache->data, DSO__DATA_CACHE_SIZE);
-		if (ret <= 0)
-			break;
-
-		cache->offset = cache_offset;
-		cache->size   = ret;
-		dso_cache__insert(&dso->cache, cache);
-
-		ret = dso_cache__memcpy(cache, offset, data, size);
-
-	} while (0);
-
-	if (ret <= 0)
-		free(cache);
-
-	close(fd);
-	return ret;
-}
-
-static ssize_t dso_cache_read(struct dso *dso, struct machine *machine,
-			      u64 offset, u8 *data, ssize_t size)
-{
-	struct dso_cache *cache;
-
-	cache = dso_cache__find(&dso->cache, offset);
-	if (cache)
-		return dso_cache__memcpy(cache, offset, data, size);
-	else
-		return dso_cache__read(dso, machine, offset, data, size);
-}
-
-ssize_t dso__data_read_offset(struct dso *dso, struct machine *machine,
-			      u64 offset, u8 *data, ssize_t size)
-{
-	ssize_t r = 0;
-	u8 *p = data;
-
-	do {
-		ssize_t ret;
-
-		ret = dso_cache_read(dso, machine, offset, p, size);
-		if (ret < 0)
-			return ret;
-
-		/* Reached EOF, return what we have. */
-		if (!ret)
-			break;
-
-		BUG_ON(ret > size);
-
-		r      += ret;
-		p      += ret;
-		offset += ret;
-		size   -= ret;
-
-	} while (size);
-
-	return r;
-}
-
-ssize_t dso__data_read_addr(struct dso *dso, struct map *map,
-			    struct machine *machine, u64 addr,
-			    u8 *data, ssize_t size)
-{
-	u64 offset = map->map_ip(map, addr);
-	return dso__data_read_offset(dso, machine, offset, data, size);
-}
diff --git a/tools/perf/util/symbol.h b/tools/perf/util/symbol.h
index 45d3df8..863b05b 100644
--- a/tools/perf/util/symbol.h
+++ b/tools/perf/util/symbol.h
@@ -19,6 +19,8 @@
 #include <elf.h>
 #endif
 
+#include "dso.h"
+
 #ifdef HAVE_CPLUS_DEMANGLE
 extern char *cplus_demangle(const char *, int);
 
@@ -70,6 +72,7 @@ struct symbol {
 };
 
 void symbol__delete(struct symbol *sym);
+void symbols__delete(struct rb_root *symbols);
 
 static inline size_t symbol__size(const struct symbol *sym)
 {
@@ -160,70 +163,6 @@ struct addr_location {
 	s32	      cpu;
 };
 
-enum dso_binary_type {
-	DSO_BINARY_TYPE__KALLSYMS = 0,
-	DSO_BINARY_TYPE__GUEST_KALLSYMS,
-	DSO_BINARY_TYPE__VMLINUX,
-	DSO_BINARY_TYPE__GUEST_VMLINUX,
-	DSO_BINARY_TYPE__JAVA_JIT,
-	DSO_BINARY_TYPE__DEBUGLINK,
-	DSO_BINARY_TYPE__BUILD_ID_CACHE,
-	DSO_BINARY_TYPE__FEDORA_DEBUGINFO,
-	DSO_BINARY_TYPE__UBUNTU_DEBUGINFO,
-	DSO_BINARY_TYPE__BUILDID_DEBUGINFO,
-	DSO_BINARY_TYPE__SYSTEM_PATH_DSO,
-	DSO_BINARY_TYPE__GUEST_KMODULE,
-	DSO_BINARY_TYPE__SYSTEM_PATH_KMODULE,
-	DSO_BINARY_TYPE__NOT_FOUND,
-};
-
-enum dso_kernel_type {
-	DSO_TYPE_USER = 0,
-	DSO_TYPE_KERNEL,
-	DSO_TYPE_GUEST_KERNEL
-};
-
-enum dso_swap_type {
-	DSO_SWAP__UNSET,
-	DSO_SWAP__NO,
-	DSO_SWAP__YES,
-};
-
-#define DSO__DATA_CACHE_SIZE 4096
-#define DSO__DATA_CACHE_MASK ~(DSO__DATA_CACHE_SIZE - 1)
-
-struct dso_cache {
-	struct rb_node	rb_node;
-	u64 offset;
-	u64 size;
-	char data[0];
-};
-
-struct dso {
-	struct list_head node;
-	struct rb_root	 symbols[MAP__NR_TYPES];
-	struct rb_root	 symbol_names[MAP__NR_TYPES];
-	struct rb_root	 cache;
-	enum dso_kernel_type	kernel;
-	enum dso_swap_type	needs_swap;
-	enum dso_binary_type	symtab_type;
-	enum dso_binary_type	data_type;
-	u8		 adjust_symbols:1;
-	u8		 has_build_id:1;
-	u8		 hit:1;
-	u8		 annotate_warned:1;
-	u8		 sname_alloc:1;
-	u8		 lname_alloc:1;
-	u8		 sorted_by_name;
-	u8		 loaded;
-	u8		 build_id[BUILD_ID_SIZE];
-	const char	 *short_name;
-	char	 	 *long_name;
-	u16		 long_name_len;
-	u16		 short_name_len;
-	char		 name[0];
-};
-
 struct symsrc {
 	char *name;
 	int fd;
@@ -254,47 +193,6 @@ int symsrc__init(struct symsrc *ss, struct dso *dso, const char *name,
 bool symsrc__has_symtab(struct symsrc *ss);
 bool symsrc__possibly_runtime(struct symsrc *ss);
 
-#define DSO__SWAP(dso, type, val)			\
-({							\
-	type ____r = val;				\
-	BUG_ON(dso->needs_swap == DSO_SWAP__UNSET);	\
-	if (dso->needs_swap == DSO_SWAP__YES) {		\
-		switch (sizeof(____r)) {		\
-		case 2:					\
-			____r = bswap_16(val);		\
-			break;				\
-		case 4:					\
-			____r = bswap_32(val);		\
-			break;				\
-		case 8:					\
-			____r = bswap_64(val);		\
-			break;				\
-		default:				\
-			BUG_ON(1);			\
-		}					\
-	}						\
-	____r;						\
-})
-
-struct dso *dso__new(const char *name);
-void dso__delete(struct dso *dso);
-
-int dso__name_len(const struct dso *dso);
-
-bool dso__loaded(const struct dso *dso, enum map_type type);
-bool dso__sorted_by_name(const struct dso *dso, enum map_type type);
-
-static inline void dso__set_loaded(struct dso *dso, enum map_type type)
-{
-	dso->loaded |= (1 << type);
-}
-
-void dso__sort_by_name(struct dso *dso, enum map_type type);
-
-void dsos__add(struct list_head *head, struct dso *dso);
-struct dso *dsos__find(struct list_head *head, const char *name);
-struct dso *__dsos__findnew(struct list_head *head, const char *name);
-
 int dso__load(struct dso *dso, struct map *map, symbol_filter_t filter);
 int dso__load_vmlinux(struct dso *dso, struct map *map,
 		      const char *vmlinux, symbol_filter_t filter);
@@ -307,25 +205,12 @@ int machine__load_kallsyms(struct machine *machine, const char *filename,
 int machine__load_vmlinux_path(struct machine *machine, enum map_type type,
 			       symbol_filter_t filter);
 
-size_t __dsos__fprintf(struct list_head *head, FILE *fp);
-
 size_t machine__fprintf_dsos_buildid(struct machine *machine,
 				     FILE *fp, bool with_hits);
 size_t machines__fprintf_dsos(struct rb_root *machines, FILE *fp);
 size_t machines__fprintf_dsos_buildid(struct rb_root *machines,
 				      FILE *fp, bool with_hits);
-size_t dso__fprintf_buildid(struct dso *dso, FILE *fp);
-size_t dso__fprintf_symbols_by_name(struct dso *dso,
-				    enum map_type type, FILE *fp);
-size_t dso__fprintf(struct dso *dso, enum map_type type, FILE *fp);
-
-char dso__symtab_origin(const struct dso *dso);
-void dso__set_long_name(struct dso *dso, char *name);
-void dso__set_build_id(struct dso *dso, void *build_id);
-bool dso__build_id_equal(const struct dso *dso, u8 *build_id);
-void dso__read_running_kernel_build_id(struct dso *dso,
-				       struct machine *machine);
-struct map *dso__new_map(const char *name);
+
 struct symbol *dso__find_symbol(struct dso *dso, enum map_type type,
 				u64 addr);
 struct symbol *dso__find_symbol_by_name(struct dso *dso, enum map_type type,
@@ -333,7 +218,6 @@ struct symbol *dso__find_symbol_by_name(struct dso *dso, enum map_type type,
 
 int filename__read_build_id(const char *filename, void *bf, size_t size);
 int sysfs__read_build_id(const char *filename, void *bf, size_t size);
-bool __dsos__read_build_ids(struct list_head *head, bool with_hits);
 int kallsyms__parse(const char *filename, void *arg,
 		    int (*process_symbol)(void *arg, const char *name,
 					  char type, u64 start));
@@ -355,19 +239,11 @@ struct symbol *symbol__new(u64 start, u64 len, u8 binding, const char *name);
 size_t symbol__fprintf_symname_offs(const struct symbol *sym,
 				    const struct addr_location *al, FILE *fp);
 size_t symbol__fprintf_symname(const struct symbol *sym, FILE *fp);
+size_t symbol__fprintf(struct symbol *sym, FILE *fp);
 bool symbol_type__is_a(char symbol_type, enum map_type map_type);
 
 size_t machine__fprintf_vmlinux_path(struct machine *machine, FILE *fp);
 
-int dso__binary_type_file(struct dso *dso, enum dso_binary_type type,
-			  char *root_dir, char *file, size_t size);
-
-int dso__data_fd(struct dso *dso, struct machine *machine);
-ssize_t dso__data_read_offset(struct dso *dso, struct machine *machine,
-			      u64 offset, u8 *data, ssize_t size);
-ssize_t dso__data_read_addr(struct dso *dso, struct map *map,
-			    struct machine *machine, u64 addr,
-			    u8 *data, ssize_t size);
 int dso__test_data(void);
 int dso__load_sym(struct dso *dso, struct map *map, struct symsrc *syms_ss,
 		  struct symsrc *runtime_ss, symbol_filter_t filter,
