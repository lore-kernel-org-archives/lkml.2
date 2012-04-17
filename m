Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932260Ab2DQLTu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2012 07:19:50 -0400
Received: from mx1.redhat.com ([209.132.183.28]:16232 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932222Ab2DQLTa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2012 07:19:30 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: acme@redhat.com, a.p.zijlstra@chello.nl, mingo@elte.hu, paulus@samba.org,
        cjashfor@linux.vnet.ibm.com, fweisbec@gmail.com
Cc: eranian@google.com, gorcunov@openvz.org, tzanussi@gmail.com,
        mhiramat@redhat.com, rostedt@goodmis.org, robert.richter@amd.com,
        fche@redhat.com, linux-kernel@vger.kernel.org,
        masami.hiramatsu.pt@hitachi.com, drepper@gmail.com,
        Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 15/16] perf, tool: Add dso data caching
Date: Tue, 17 Apr 2012 13:17:20 +0200
Message-Id: <1334661441-4420-16-git-send-email-jolsa@redhat.com>
In-Reply-To: <1334661441-4420-1-git-send-email-jolsa@redhat.com>
References: <1334661441-4420-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding dso data caching so we dont need to open/read/close,
each time we want dso data.

The DSO data caching affects following functions:
  dso__data_read_offset
  dso__data_read_addr

Each DSO read tries to find the data (based on offset) inside
the cache. If it's not present it fills the cache from file,
and returns the data. If it is present, data are returned
with no file read.

Each data read is cached by reading cache page sized/alligned
amount of DSO data. The cache page size is hardcoded to 4096.
The cache is using RB tree with file offset as a sort key.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
---
 tools/perf/util/symbol.c |  154 ++++++++++++++++++++++++++++++++++++++++------
 tools/perf/util/symbol.h |   11 +++
 2 files changed, 147 insertions(+), 18 deletions(-)

diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index 9c0fa32..b7b0c2a 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -29,6 +29,7 @@
 #define NT_GNU_BUILD_ID 3
 #endif
 
+static void data_cache__free(struct rb_root *root);
 static bool dso__build_id_equal(const struct dso *dso, u8 *build_id);
 static int elf_read_build_id(Elf *elf, void *bf, size_t size);
 static void dsos__add(struct list_head *head, struct dso *dso);
@@ -342,6 +343,7 @@ struct dso *dso__new(const char *name)
 		dso__set_short_name(dso, dso->name);
 		for (i = 0; i < MAP__NR_TYPES; ++i)
 			dso->symbols[i] = dso->symbol_names[i] = RB_ROOT;
+		dso->data_cache = RB_ROOT;
 		dso->symtab_type = DSO_BINARY_TYPE__NOT_FOUND;
 		dso->data_type   = DSO_BINARY_TYPE__NOT_FOUND;
 		dso->loaded = 0;
@@ -376,6 +378,7 @@ void dso__delete(struct dso *dso)
 		free((char *)dso->short_name);
 	if (dso->lname_alloc)
 		free(dso->long_name);
+	data_cache__free(&dso->data_cache);
 	free(dso);
 }
 
@@ -2893,22 +2896,87 @@ int dso__data_fd(struct dso *dso, struct machine *machine)
 	return -EINVAL;
 }
 
-static ssize_t dso_cache_read(struct dso *dso __used, u64 offset __used,
-			      u8 *data __used, ssize_t size __used)
+static void
+data_cache__free(struct rb_root *root)
 {
-	return -EINVAL;
+	struct rb_node *next = rb_first(root);
+
+	while (next) {
+		struct dso__data_cache *cache;
+
+		cache = rb_entry(next, struct dso__data_cache, rb_node);
+		next = rb_next(&cache->rb_node);
+		rb_erase(&cache->rb_node, root);
+		free(cache);
+	}
 }
 
-static int dso_cache_add(struct dso *dso __used, u64 offset __used,
-			 u8 *data __used, ssize_t size __used)
+static struct dso__data_cache*
+data_cache__find(struct rb_root *root, u64 offset)
 {
-	return 0;
+	struct rb_node **p = &root->rb_node;
+	struct rb_node *parent = NULL;
+	struct dso__data_cache *cache;
+
+	while (*p != NULL) {
+		u64 end;
+
+		parent = *p;
+		cache = rb_entry(parent, struct dso__data_cache, rb_node);
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
+data_cache__insert(struct rb_root *root, struct dso__data_cache *new)
+{
+	struct rb_node **p = &root->rb_node;
+	struct rb_node *parent = NULL;
+	struct dso__data_cache *cache;
+	u64 offset = new->offset;
+
+	while (*p != NULL) {
+		u64 end;
+
+		parent = *p;
+		cache = rb_entry(parent, struct dso__data_cache, rb_node);
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
+data_cache__data(struct dso__data_cache *cache, u64 offset,
+		 u8 *data, u64 size)
+{
+	u64 cache_offset = offset - cache->offset;
+	u64 cache_size   = min(cache->size - cache_offset, size);
+
+	memcpy(data, cache->data + cache_offset, cache_size);
+	return cache_size;
 }
 
-static ssize_t read_dso_data(struct dso *dso, struct machine *machine,
-		     u64 offset, u8 *data, ssize_t size)
+static ssize_t
+data_cache__read(struct dso *dso, struct machine *machine,
+		 u64 offset, u8 *data, ssize_t size)
 {
-	ssize_t rsize = -1;
+	struct dso__data_cache *cache;
+	ssize_t ret;
 	int fd;
 
 	fd = dso__data_fd(dso, machine);
@@ -2916,28 +2984,78 @@ static ssize_t read_dso_data(struct dso *dso, struct machine *machine,
 		return -1;
 
 	do {
-		if (-1 == lseek(fd, offset, SEEK_SET))
+		u64 cache_offset;
+
+		ret = -ENOMEM;
+
+		cache = zalloc(sizeof(*cache) + DSO__DATA_CACHE_SIZE);
+		if (!cache)
 			break;
 
-		rsize = read(fd, data, size);
-		if (-1 == rsize)
+		cache_offset = offset & DSO__DATA_CACHE_MASK;
+		ret = -EINVAL;
+
+		if (-1 == lseek(fd, cache_offset, SEEK_SET))
 			break;
 
-		if (dso_cache_add(dso, offset, data, size))
-			pr_err("Failed to add data int dso cache.");
+		ret = read(fd, cache->data, DSO__DATA_CACHE_SIZE);
+		if (ret <= 0)
+			break;
+
+		cache->offset = cache_offset;
+		cache->size   = ret;
+		data_cache__insert(&dso->data_cache, cache);
+
+		ret = data_cache__data(cache, offset, data, size);
 
 	} while (0);
 
+	if (ret <= 0)
+		free(cache);
+
 	close(fd);
-	return rsize;
+	return ret;
+}
+
+static ssize_t dso_cache_read(struct dso *dso, struct machine *machine,
+			      u64 offset, u8 *data, ssize_t size)
+{
+	struct dso__data_cache *cache;
+
+	cache = data_cache__find(&dso->data_cache, offset);
+	if (cache)
+		return data_cache__data(cache, offset, data, size);
+	else
+		return data_cache__read(dso, machine, offset, data, size);
 }
 
 ssize_t dso__data_read_offset(struct dso *dso, struct machine *machine,
 			      u64 offset, u8 *data, ssize_t size)
 {
-	if (dso_cache_read(dso, offset, data, size))
-		return read_dso_data(dso, machine, offset, data, size);
-	return 0;
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
 }
 
 ssize_t dso__data_read_addr(struct dso *dso, struct map *map,
diff --git a/tools/perf/util/symbol.h b/tools/perf/util/symbol.h
index b62321f..e5744c0 100644
--- a/tools/perf/util/symbol.h
+++ b/tools/perf/util/symbol.h
@@ -169,10 +169,21 @@ enum dso_kernel_type {
 	DSO_TYPE_GUEST_KERNEL
 };
 
+#define DSO__DATA_CACHE_SIZE 4096
+#define DSO__DATA_CACHE_MASK ~(DSO__DATA_CACHE_SIZE - 1)
+
+struct dso__data_cache {
+	struct rb_node	rb_node;
+	u64 offset;
+	u64 size;
+	char data[0];
+};
+
 struct dso {
 	struct list_head node;
 	struct rb_root	 symbols[MAP__NR_TYPES];
 	struct rb_root	 symbol_names[MAP__NR_TYPES];
+	struct rb_root	 data_cache;
 	enum dso_kernel_type	kernel;
 	enum dso_binary_type	symtab_type;
 	enum dso_binary_type	data_type;
-- 
1.7.7.6

