Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756629Ab2HUPpH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 11:45:07 -0400
Received: from terminus.zytor.com ([198.137.202.10]:60130 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752025Ab2HUPpF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 11:45:05 -0400
Date: Tue, 21 Aug 2012 08:44:38 -0700
From: tip-bot for Namhyung Kim <namhyung.kim@lge.com>
Message-ID: <tip-b691f64360ecec49c44d534cf4c1798a438bfccb@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@kernel.org, a.p.zijlstra@chello.nl,
        namhyung.kim@lge.com, namhyung@kernel.org, jolsa@redhat.com,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        namhyung.kim@lge.com, tglx@linutronix.de, namhyung@kernel.org,
        jolsa@redhat.com
In-Reply-To: <1344228082-15569-5-git-send-email-namhyung@kernel.org>
References: <1344228082-15569-5-git-send-email-namhyung@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf symbols: Implement poor man's ELF parser
Git-Commit-ID: b691f64360ecec49c44d534cf4c1798a438bfccb
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Tue, 21 Aug 2012 08:44:44 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  b691f64360ecec49c44d534cf4c1798a438bfccb
Gitweb:     http://git.kernel.org/tip/b691f64360ecec49c44d534cf4c1798a438bfccb
Author:     Namhyung Kim <namhyung.kim@lge.com>
AuthorDate: Mon, 6 Aug 2012 13:41:22 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Thu, 9 Aug 2012 16:27:04 -0300

perf symbols: Implement poor man's ELF parser

Implement a minimal elf parser for getting build-id.  It assumes that
required elf.h header is provided by libc header on the system and the
parser only looks for PT_NOTE program header to check build-id.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1344228082-15569-5-git-send-email-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/symbol-minimal.c |  242 ++++++++++++++++++++++++++++++++++++-
 1 files changed, 235 insertions(+), 7 deletions(-)

diff --git a/tools/perf/util/symbol-minimal.c b/tools/perf/util/symbol-minimal.c
index 416ecf3..bd8720b 100644
--- a/tools/perf/util/symbol-minimal.c
+++ b/tools/perf/util/symbol-minimal.c
@@ -1,15 +1,71 @@
 #include "symbol.h"
 
+#include <elf.h>
+#include <stdio.h>
+#include <fcntl.h>
+#include <string.h>
+#include <byteswap.h>
+#include <sys/stat.h>
 
-int filename__read_build_id(const char *filename __used, void *bf __used,
-			    size_t size __used)
+
+static bool check_need_swap(int file_endian)
 {
-	return -1;
+	const int data = 1;
+	u8 *check = (u8 *)&data;
+	int host_endian;
+
+	if (check[0] == 1)
+		host_endian = ELFDATA2LSB;
+	else
+		host_endian = ELFDATA2MSB;
+
+	return host_endian != file_endian;
 }
 
-int sysfs__read_build_id(const char *filename __used, void *build_id __used,
-			 size_t size __used)
+#define NOTE_ALIGN(sz) (((sz) + 3) & ~3)
+
+#define NT_GNU_BUILD_ID	3
+
+static int read_build_id(void *note_data, size_t note_len, void *bf,
+			 size_t size, bool need_swap)
 {
+	struct {
+		u32 n_namesz;
+		u32 n_descsz;
+		u32 n_type;
+	} *nhdr;
+	void *ptr;
+
+	ptr = note_data;
+	while (ptr < (note_data + note_len)) {
+		const char *name;
+		size_t namesz, descsz;
+
+		nhdr = ptr;
+		if (need_swap) {
+			nhdr->n_namesz = bswap_32(nhdr->n_namesz);
+			nhdr->n_descsz = bswap_32(nhdr->n_descsz);
+			nhdr->n_type = bswap_32(nhdr->n_type);
+		}
+
+		namesz = NOTE_ALIGN(nhdr->n_namesz);
+		descsz = NOTE_ALIGN(nhdr->n_descsz);
+
+		ptr += sizeof(*nhdr);
+		name = ptr;
+		ptr += namesz;
+		if (nhdr->n_type == NT_GNU_BUILD_ID &&
+		    nhdr->n_namesz == sizeof("GNU")) {
+			if (memcmp(name, "GNU", sizeof("GNU")) == 0) {
+				size_t sz = min(size, descsz);
+				memcpy(bf, ptr, sz);
+				memset(bf + sz, 0, size - sz);
+				return 0;
+			}
+		}
+		ptr += descsz;
+	}
+
 	return -1;
 }
 
@@ -19,6 +75,172 @@ int filename__read_debuglink(const char *filename __used,
 	return -1;
 }
 
+/*
+ * Just try PT_NOTE header otherwise fails
+ */
+int filename__read_build_id(const char *filename, void *bf, size_t size)
+{
+	FILE *fp;
+	int ret = -1;
+	bool need_swap = false;
+	u8 e_ident[EI_NIDENT];
+	size_t buf_size;
+	void *buf;
+	int i;
+
+	fp = fopen(filename, "r");
+	if (fp == NULL)
+		return -1;
+
+	if (fread(e_ident, sizeof(e_ident), 1, fp) != 1)
+		goto out;
+
+	if (memcmp(e_ident, ELFMAG, SELFMAG) ||
+	    e_ident[EI_VERSION] != EV_CURRENT)
+		goto out;
+
+	need_swap = check_need_swap(e_ident[EI_DATA]);
+
+	/* for simplicity */
+	fseek(fp, 0, SEEK_SET);
+
+	if (e_ident[EI_CLASS] == ELFCLASS32) {
+		Elf32_Ehdr ehdr;
+		Elf32_Phdr *phdr;
+
+		if (fread(&ehdr, sizeof(ehdr), 1, fp) != 1)
+			goto out;
+
+		if (need_swap) {
+			ehdr.e_phoff = bswap_32(ehdr.e_phoff);
+			ehdr.e_phentsize = bswap_16(ehdr.e_phentsize);
+			ehdr.e_phnum = bswap_16(ehdr.e_phnum);
+		}
+
+		buf_size = ehdr.e_phentsize * ehdr.e_phnum;
+		buf = malloc(buf_size);
+		if (buf == NULL)
+			goto out;
+
+		fseek(fp, ehdr.e_phoff, SEEK_SET);
+		if (fread(buf, buf_size, 1, fp) != 1)
+			goto out_free;
+
+		for (i = 0, phdr = buf; i < ehdr.e_phnum; i++, phdr++) {
+			void *tmp;
+
+			if (need_swap) {
+				phdr->p_type = bswap_32(phdr->p_type);
+				phdr->p_offset = bswap_32(phdr->p_offset);
+				phdr->p_filesz = bswap_32(phdr->p_filesz);
+			}
+
+			if (phdr->p_type != PT_NOTE)
+				continue;
+
+			buf_size = phdr->p_filesz;
+			tmp = realloc(buf, buf_size);
+			if (tmp == NULL)
+				goto out_free;
+
+			buf = tmp;
+			fseek(fp, phdr->p_offset, SEEK_SET);
+			if (fread(buf, buf_size, 1, fp) != 1)
+				goto out_free;
+
+			ret = read_build_id(buf, buf_size, bf, size, need_swap);
+			if (ret == 0)
+				ret = size;
+			break;
+		}
+	} else {
+		Elf64_Ehdr ehdr;
+		Elf64_Phdr *phdr;
+
+		if (fread(&ehdr, sizeof(ehdr), 1, fp) != 1)
+			goto out;
+
+		if (need_swap) {
+			ehdr.e_phoff = bswap_64(ehdr.e_phoff);
+			ehdr.e_phentsize = bswap_16(ehdr.e_phentsize);
+			ehdr.e_phnum = bswap_16(ehdr.e_phnum);
+		}
+
+		buf_size = ehdr.e_phentsize * ehdr.e_phnum;
+		buf = malloc(buf_size);
+		if (buf == NULL)
+			goto out;
+
+		fseek(fp, ehdr.e_phoff, SEEK_SET);
+		if (fread(buf, buf_size, 1, fp) != 1)
+			goto out_free;
+
+		for (i = 0, phdr = buf; i < ehdr.e_phnum; i++, phdr++) {
+			void *tmp;
+
+			if (need_swap) {
+				phdr->p_type = bswap_32(phdr->p_type);
+				phdr->p_offset = bswap_64(phdr->p_offset);
+				phdr->p_filesz = bswap_64(phdr->p_filesz);
+			}
+
+			if (phdr->p_type != PT_NOTE)
+				continue;
+
+			buf_size = phdr->p_filesz;
+			tmp = realloc(buf, buf_size);
+			if (tmp == NULL)
+				goto out_free;
+
+			buf = tmp;
+			fseek(fp, phdr->p_offset, SEEK_SET);
+			if (fread(buf, buf_size, 1, fp) != 1)
+				goto out_free;
+
+			ret = read_build_id(buf, buf_size, bf, size, need_swap);
+			if (ret == 0)
+				ret = size;
+			break;
+		}
+	}
+out_free:
+	free(buf);
+out:
+	fclose(fp);
+	return ret;
+}
+
+int sysfs__read_build_id(const char *filename, void *build_id, size_t size)
+{
+	int fd;
+	int ret = -1;
+	struct stat stbuf;
+	size_t buf_size;
+	void *buf;
+
+	fd = open(filename, O_RDONLY);
+	if (fd < 0)
+		return -1;
+
+	if (fstat(fd, &stbuf) < 0)
+		goto out;
+
+	buf_size = stbuf.st_size;
+	buf = malloc(buf_size);
+	if (buf == NULL)
+		goto out;
+
+	if (read(fd, buf, buf_size) != (ssize_t) buf_size)
+		goto out_free;
+
+	ret = read_build_id(buf, buf_size, build_id, size, false);
+out_free:
+	free(buf);
+out:
+	close(fd);
+	return ret;
+}
+
 int dso__synthesize_plt_symbols(struct dso *dso __used, char *name __used,
 				struct map *map __used,
 				symbol_filter_t filter __used)
@@ -26,11 +248,17 @@ int dso__synthesize_plt_symbols(struct dso *dso __used, char *name __used,
 	return 0;
 }
 
-int dso__load_sym(struct dso *dso __used, struct map *map __used,
-		  const char *name __used, int fd __used,
+int dso__load_sym(struct dso *dso, struct map *map __used,
+		  const char *name, int fd __used,
 		  symbol_filter_t filter __used, int kmodule __used,
 		  int want_symtab __used)
 {
+	unsigned char *build_id[BUILD_ID_SIZE];
+
+	if (filename__read_build_id(name, build_id, BUILD_ID_SIZE) > 0) {
+		dso__set_build_id(dso, build_id);
+		return 1;
+	}
 	return 0;
 }
 
