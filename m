Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752027Ab2GVMPx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jul 2012 08:15:53 -0400
Received: from mx1.redhat.com ([209.132.183.28]:2916 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751807Ab2GVMPr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jul 2012 08:15:47 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: acme@redhat.com, a.p.zijlstra@chello.nl, mingo@elte.hu, paulus@samba.org,
        cjashfor@linux.vnet.ibm.com, fweisbec@gmail.com
Cc: eranian@google.com, gorcunov@openvz.org, tzanussi@gmail.com,
        mhiramat@redhat.com, robert.richter@amd.com, fche@redhat.com,
        linux-kernel@vger.kernel.org, masami.hiramatsu.pt@hitachi.com,
        drepper@gmail.com, asharma@fb.com, benjamin.redelings@nescent.org,
        Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 10/17] perf, tool: Add interface to read DSO image data
Date: Sun, 22 Jul 2012 14:14:33 +0200
Message-Id: <1342959280-5361-11-git-send-email-jolsa@redhat.com>
In-Reply-To: <1342959280-5361-1-git-send-email-jolsa@redhat.com>
References: <1342959280-5361-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding following interface for DSO object to allow
reading of DSO image data:

  dso__data_fd
    - opens DSO and returns file descriptor
      Binary types are used to locate/open DSO in following order:
        DSO_BINARY_TYPE__BUILD_ID_CACHE
        DSO_BINARY_TYPE__SYSTEM_PATH_DSO
      In other word we first try to open DSO build-id path,
      and if that fails we try to open DSO system path.

  dso__data_read_offset
    - reads DSO data from specified offset

  dso__data_read_addr
    - reads DSO data from specified address/map.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
---
 tools/perf/util/symbol.c |  109 ++++++++++++++++++++++++++++++++++++++++++++++
 tools/perf/util/symbol.h |    8 +++
 2 files changed, 117 insertions(+), 0 deletions(-)

diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index 79fc779..ff4d603 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -65,6 +65,14 @@ static enum dso_binary_type binary_type_symtab[] = {
 
 #define DSO_BINARY_TYPE__SYMTAB_CNT sizeof(binary_type_symtab)
 
+static enum dso_binary_type binary_type_data[] = {
+	DSO_BINARY_TYPE__BUILD_ID_CACHE,
+	DSO_BINARY_TYPE__SYSTEM_PATH_DSO,
+	DSO_BINARY_TYPE__NOT_FOUND,
+};
+
+#define DSO_BINARY_TYPE__DATA_CNT sizeof(binary_type_data)
+
 int dso__name_len(const struct dso *dso)
 {
 	if (!dso)
@@ -336,6 +344,7 @@ struct dso *dso__new(const char *name)
 		for (i = 0; i < MAP__NR_TYPES; ++i)
 			dso->symbols[i] = dso->symbol_names[i] = RB_ROOT;
 		dso->symtab_type = DSO_BINARY_TYPE__NOT_FOUND;
+		dso->data_type   = DSO_BINARY_TYPE__NOT_FOUND;
 		dso->loaded = 0;
 		dso->sorted_by_name = 0;
 		dso->has_build_id = 0;
@@ -2946,3 +2955,103 @@ struct map *dso__new_map(const char *name)
 
 	return map;
 }
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
+static ssize_t dso_cache_read(struct dso *dso __used, u64 offset __used,
+			      u8 *data __used, ssize_t size __used)
+{
+	return -EINVAL;
+}
+
+static int dso_cache_add(struct dso *dso __used, u64 offset __used,
+			 u8 *data __used, ssize_t size __used)
+{
+	return 0;
+}
+
+static ssize_t read_dso_data(struct dso *dso, struct machine *machine,
+		     u64 offset, u8 *data, ssize_t size)
+{
+	ssize_t rsize = -1;
+	int fd;
+
+	fd = dso__data_fd(dso, machine);
+	if (fd < 0)
+		return -1;
+
+	do {
+		if (-1 == lseek(fd, offset, SEEK_SET))
+			break;
+
+		rsize = read(fd, data, size);
+		if (-1 == rsize)
+			break;
+
+		if (dso_cache_add(dso, offset, data, size))
+			pr_err("Failed to add data int dso cache.");
+
+	} while (0);
+
+	close(fd);
+	return rsize;
+}
+
+ssize_t dso__data_read_offset(struct dso *dso, struct machine *machine,
+			      u64 offset, u8 *data, ssize_t size)
+{
+	if (dso_cache_read(dso, offset, data, size))
+		return read_dso_data(dso, machine, offset, data, size);
+	return 0;
+}
+
+ssize_t dso__data_read_addr(struct dso *dso, struct map *map,
+			    struct machine *machine, u64 addr,
+			    u8 *data, ssize_t size)
+{
+	u64 offset = map->map_ip(map, addr);
+	return dso__data_read_offset(dso, machine, offset, data, size);
+}
diff --git a/tools/perf/util/symbol.h b/tools/perf/util/symbol.h
index dc474f0..9b9ea00 100644
--- a/tools/perf/util/symbol.h
+++ b/tools/perf/util/symbol.h
@@ -189,6 +189,7 @@ struct dso {
 	enum dso_kernel_type	kernel;
 	enum dso_swap_type	needs_swap;
 	enum dso_binary_type	symtab_type;
+	enum dso_binary_type	data_type;
 	u8		 adjust_symbols:1;
 	u8		 has_build_id:1;
 	u8		 hit:1;
@@ -306,4 +307,11 @@ size_t machine__fprintf_vmlinux_path(struct machine *machine, FILE *fp);
 
 int dso__binary_type_file(struct dso *dso, enum dso_binary_type type,
 			  char *root_dir, char *file, size_t size);
+
+int dso__data_fd(struct dso *dso, struct machine *machine);
+ssize_t dso__data_read_offset(struct dso *dso, struct machine *machine,
+			      u64 offset, u8 *data, ssize_t size);
+ssize_t dso__data_read_addr(struct dso *dso, struct map *map,
+			    struct machine *machine, u64 addr,
+			    u8 *data, ssize_t size);
 #endif /* __PERF_SYMBOL */
-- 
1.7.7.6

