Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752950Ab0HBBNI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Aug 2010 21:13:08 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:38009 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752383Ab0HBBJH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Aug 2010 21:09:07 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Dave Martin <dave.martin@linaro.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 15/19] perf symbols: Improve debug image search when loading symbols
Date: Sun,  1 Aug 2010 22:08:50 -0300
Message-Id: <1280711334-30000-16-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1280711334-30000-1-git-send-email-acme@infradead.org>
References: <1280711334-30000-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dave Martin <dave.martin@linaro.org>

Changes:
	* Simplification of the main search loop on dso__load()
	* Replace the search with a 2-pass search:
		* First, try to find an image with a proper symtab.
		* Second, repeat the search, accepting dynsym.

A second scan should only ever happen when needed debug images are
missing from the buildid cache or stale, i.e., when the cache is out of
sync.

Currently, the second scan also happens when using separated debug
images, since the caching logic doesn't currently know how to cache
those.  Improvements to the cache behaviour ought to solve that.

Signed-off-by: Dave Martin <dave.martin@linaro.org>
LKML-Reference: <new-submission>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/symbol.c |   96 +++++++++++++++++++++++++++++-----------------
 1 files changed, 61 insertions(+), 35 deletions(-)

diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index e0d9480..d99497e 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -966,7 +966,8 @@ static size_t elf_addr_to_index(Elf *elf, GElf_Addr addr)
 }
 
 static int dso__load_sym(struct dso *self, struct map *map, const char *name,
-			 int fd, symbol_filter_t filter, int kmodule)
+			 int fd, symbol_filter_t filter, int kmodule,
+			 int want_symtab)
 {
 	struct kmap *kmap = self->kernel ? map__kmap(map) : NULL;
 	struct map *curr_map = map;
@@ -995,6 +996,7 @@ static int dso__load_sym(struct dso *self, struct map *map, const char *name,
 		goto out_elf_end;
 	}
 
+	/* Always reject images with a mismatched build-id: */
 	if (self->has_build_id) {
 		u8 build_id[BUILD_ID_SIZE];
 
@@ -1008,6 +1010,9 @@ static int dso__load_sym(struct dso *self, struct map *map, const char *name,
 
 	sec = elf_section_by_name(elf, &ehdr, &shdr, ".symtab", NULL);
 	if (sec == NULL) {
+		if (want_symtab)
+			goto out_elf_end;
+
 		sec = elf_section_by_name(elf, &ehdr, &shdr, ".dynsym", NULL);
 		if (sec == NULL)
 			goto out_elf_end;
@@ -1365,6 +1370,7 @@ int dso__load(struct dso *self, struct map *map, symbol_filter_t filter)
 	int fd;
 	struct machine *machine;
 	const char *root_dir;
+	int want_symtab;
 
 	dso__set_loaded(self, map->type);
 
@@ -1391,13 +1397,18 @@ int dso__load(struct dso *self, struct map *map, symbol_filter_t filter)
 		return ret;
 	}
 
-	self->origin = DSO__ORIG_BUILD_ID_CACHE;
-	if (dso__build_id_filename(self, name, size) != NULL)
-		goto open_file;
-more:
-	do {
-		self->origin++;
+	/* Iterate over candidate debug images.
+	 * On the first pass, only load images if they have a full symtab.
+	 * Failing that, do a second pass where we accept .dynsym also
+	 */
+	for (self->origin = DSO__ORIG_BUILD_ID_CACHE, want_symtab = 1;
+	     self->origin != DSO__ORIG_NOT_FOUND;
+	     self->origin++) {
 		switch (self->origin) {
+		case DSO__ORIG_BUILD_ID_CACHE:
+			if (dso__build_id_filename(self, name, size) == NULL)
+				continue;
+			break;
 		case DSO__ORIG_FEDORA:
 			snprintf(name, size, "/usr/lib/debug%s.debug",
 				 self->long_name);
@@ -1406,19 +1417,20 @@ more:
 			snprintf(name, size, "/usr/lib/debug%s",
 				 self->long_name);
 			break;
-		case DSO__ORIG_BUILDID:
-			if (self->has_build_id) {
-				char build_id_hex[BUILD_ID_SIZE * 2 + 1];
-				build_id__sprintf(self->build_id,
-						  sizeof(self->build_id),
-						  build_id_hex);
-				snprintf(name, size,
-					 "/usr/lib/debug/.build-id/%.2s/%s.debug",
-					build_id_hex, build_id_hex + 2);
-				break;
+		case DSO__ORIG_BUILDID: {
+			char build_id_hex[BUILD_ID_SIZE * 2 + 1];
+
+			if (!self->has_build_id)
+				continue;
+
+			build_id__sprintf(self->build_id,
+					  sizeof(self->build_id),
+					  build_id_hex);
+			snprintf(name, size,
+				 "/usr/lib/debug/.build-id/%.2s/%s.debug",
+				 build_id_hex, build_id_hex + 2);
 			}
-			self->origin++;
-			/* Fall thru */
+			break;
 		case DSO__ORIG_DSO:
 			snprintf(name, size, "%s", self->long_name);
 			break;
@@ -1431,27 +1443,41 @@ more:
 			break;
 
 		default:
-			goto out;
+			/*
+			 * If we wanted a full symtab but no image had one,
+			 * relax our requirements and repeat the search.
+			 */
+			if (want_symtab) {
+				want_symtab = 0;
+				self->origin = DSO__ORIG_BUILD_ID_CACHE;
+			} else
+				continue;
 		}
-open_file:
+
+		/* Name is now the name of the next image to try */
 		fd = open(name, O_RDONLY);
-	} while (fd < 0);
+		if (fd < 0)
+			continue;
 
-	ret = dso__load_sym(self, map, name, fd, filter, 0);
-	close(fd);
+		ret = dso__load_sym(self, map, name, fd, filter, 0,
+				    want_symtab);
+		close(fd);
 
-	/*
-	 * Some people seem to have debuginfo files _WITHOUT_ debug info!?!?
-	 */
-	if (!ret)
-		goto more;
+		/*
+		 * Some people seem to have debuginfo files _WITHOUT_ debug
+		 * info!?!?
+		 */
+		if (!ret)
+			continue;
 
-	if (ret > 0) {
-		int nr_plt = dso__synthesize_plt_symbols(self, map, filter);
-		if (nr_plt > 0)
-			ret += nr_plt;
+		if (ret > 0) {
+			int nr_plt = dso__synthesize_plt_symbols(self, map, filter);
+			if (nr_plt > 0)
+				ret += nr_plt;
+			break;
+		}
 	}
-out:
+
 	free(name);
 	if (ret < 0 && strstr(self->name, " (deleted)") != NULL)
 		return 0;
@@ -1715,7 +1741,7 @@ static int dso__load_vmlinux(struct dso *self, struct map *map,
 		return -1;
 
 	dso__set_loaded(self, map->type);
-	err = dso__load_sym(self, map, vmlinux, fd, filter, 0);
+	err = dso__load_sym(self, map, vmlinux, fd, filter, 0, 0);
 	close(fd);
 
 	if (err > 0)
-- 
1.6.2.5

