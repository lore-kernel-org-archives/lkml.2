Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752991Ab0HBBNJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Aug 2010 21:13:09 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:38005 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752358Ab0HBBJG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Aug 2010 21:09:06 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Dave Martin <dave.martin@linaro.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 13/19] perf tools: Factor out buildid reading and make it implicit in dso__load
Date: Sun,  1 Aug 2010 22:08:48 -0300
Message-Id: <1280711334-30000-14-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1280711334-30000-1-git-send-email-acme@infradead.org>
References: <1280711334-30000-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dave Martin <dave.martin@linaro.org>

If we have a buildid, then we never want to load an image which has no buildid,
or which has a different buildid, so it makes sense for the check to be built
into dso__load and not done separately.  This is fine for old distros which
don't use buildid at all since we do no check in that case.

This refactoring also alleviates some subtle race condition issues by not
opening ELF images twice to check the buildid and then load the symbols, which
could lead to weirdness if an image is replaced under our feet.

Signed-off-by: Dave Martin <dave.martin@linaro.org>
LKML-Reference: <new-submission>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/symbol.c |   80 +++++++++++++++++++++++++++-------------------
 1 files changed, 47 insertions(+), 33 deletions(-)

diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index 242d2b2..b812ace 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -26,6 +26,8 @@
 #define NT_GNU_BUILD_ID 3
 #endif
 
+static bool dso__build_id_equal(const struct dso *self, u8 *build_id);
+static int elf_read_build_id(Elf *elf, void *bf, size_t size);
 static void dsos__add(struct list_head *head, struct dso *dso);
 static struct map *map__new2(u64 start, struct dso *dso, enum map_type type);
 static int dso__load_kernel_sym(struct dso *self, struct map *map,
@@ -993,6 +995,17 @@ static int dso__load_sym(struct dso *self, struct map *map, const char *name,
 		goto out_elf_end;
 	}
 
+	if (self->has_build_id) {
+		u8 build_id[BUILD_ID_SIZE];
+
+		if (elf_read_build_id(elf, build_id,
+				      BUILD_ID_SIZE) != BUILD_ID_SIZE)
+			goto out_elf_end;
+
+		if (!dso__build_id_equal(self, build_id))
+			goto out_elf_end;
+	}
+
 	sec = elf_section_by_name(elf, &ehdr, &shdr, ".symtab", NULL);
 	if (sec == NULL) {
 		sec = elf_section_by_name(elf, &ehdr, &shdr, ".dynsym", NULL);
@@ -1193,37 +1206,26 @@ bool __dsos__read_build_ids(struct list_head *head, bool with_hits)
  */
 #define NOTE_ALIGN(n) (((n) + 3) & -4U)
 
-int filename__read_build_id(const char *filename, void *bf, size_t size)
+static int elf_read_build_id(Elf *elf, void *bf, size_t size)
 {
-	int fd, err = -1;
+	int err = -1;
 	GElf_Ehdr ehdr;
 	GElf_Shdr shdr;
 	Elf_Data *data;
 	Elf_Scn *sec;
 	Elf_Kind ek;
 	void *ptr;
-	Elf *elf;
 
 	if (size < BUILD_ID_SIZE)
 		goto out;
 
-	fd = open(filename, O_RDONLY);
-	if (fd < 0)
-		goto out;
-
-	elf = elf_begin(fd, PERF_ELF_C_READ_MMAP, NULL);
-	if (elf == NULL) {
-		pr_debug2("%s: cannot read %s ELF file.\n", __func__, filename);
-		goto out_close;
-	}
-
 	ek = elf_kind(elf);
 	if (ek != ELF_K_ELF)
-		goto out_elf_end;
+		goto out;
 
 	if (gelf_getehdr(elf, &ehdr) == NULL) {
 		pr_err("%s: cannot get elf header.\n", __func__);
-		goto out_elf_end;
+		goto out;
 	}
 
 	sec = elf_section_by_name(elf, &ehdr, &shdr,
@@ -1232,12 +1234,12 @@ int filename__read_build_id(const char *filename, void *bf, size_t size)
 		sec = elf_section_by_name(elf, &ehdr, &shdr,
 					  ".notes", NULL);
 		if (sec == NULL)
-			goto out_elf_end;
+			goto out;
 	}
 
 	data = elf_getdata(sec, NULL);
 	if (data == NULL)
-		goto out_elf_end;
+		goto out;
 
 	ptr = data->d_buf;
 	while (ptr < (data->d_buf + data->d_size)) {
@@ -1259,7 +1261,31 @@ int filename__read_build_id(const char *filename, void *bf, size_t size)
 		}
 		ptr += descsz;
 	}
-out_elf_end:
+
+out:
+	return err;
+}
+
+int filename__read_build_id(const char *filename, void *bf, size_t size)
+{
+	int fd, err = -1;
+	Elf *elf;
+
+	if (size < BUILD_ID_SIZE)
+		goto out;
+
+	fd = open(filename, O_RDONLY);
+	if (fd < 0)
+		goto out;
+
+	elf = elf_begin(fd, PERF_ELF_C_READ_MMAP, NULL);
+	if (elf == NULL) {
+		pr_debug2("%s: cannot read %s ELF file.\n", __func__, filename);
+		goto out_close;
+	}
+
+	err = elf_read_build_id(elf, bf, size);
+
 	elf_end(elf);
 out_close:
 	close(fd);
@@ -1335,7 +1361,6 @@ int dso__load(struct dso *self, struct map *map, symbol_filter_t filter)
 {
 	int size = PATH_MAX;
 	char *name;
-	u8 build_id[BUILD_ID_SIZE];
 	int ret = -1;
 	int fd;
 	struct machine *machine;
@@ -1382,16 +1407,14 @@ more:
 				 self->long_name);
 			break;
 		case DSO__ORIG_BUILDID:
-			if (filename__read_build_id(self->long_name, build_id,
-						    sizeof(build_id))) {
+			if (self->has_build_id) {
 				char build_id_hex[BUILD_ID_SIZE * 2 + 1];
-				build_id__sprintf(build_id, sizeof(build_id),
+				build_id__sprintf(self->build_id,
+						  sizeof(self->build_id),
 						  build_id_hex);
 				snprintf(name, size,
 					 "/usr/lib/debug/.build-id/%.2s/%s.debug",
 					build_id_hex, build_id_hex + 2);
-				if (self->has_build_id)
-					goto compare_build_id;
 				break;
 			}
 			self->origin++;
@@ -1410,15 +1433,6 @@ more:
 		default:
 			goto out;
 		}
-
-		if (self->has_build_id) {
-			if (filename__read_build_id(name, build_id,
-						    sizeof(build_id)) < 0)
-				goto more;
-compare_build_id:
-			if (!dso__build_id_equal(self, build_id))
-				goto more;
-		}
 open_file:
 		fd = open(name, O_RDONLY);
 	} while (fd < 0);
-- 
1.6.2.5

