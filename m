Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933406Ab0FQUkd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jun 2010 16:40:33 -0400
Received: from casper.infradead.org ([85.118.1.10]:49945 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933375Ab0FQUkP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jun 2010 16:40:15 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Eric B Munson <ebmunson@us.ibm.com>,
       Ingo Molnar <mingo@elte.hu>, Paul Mackerras <paulus@samba.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Anton Blanchard <anton@samba.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 2/7] perf symbols: Function descriptor symbol lookup
Date: Thu, 17 Jun 2010 17:39:59 -0300
Message-Id: <1276807204-22512-3-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1276807204-22512-1-git-send-email-acme@infradead.org>
References: <1276807204-22512-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric B Munson <ebmunson@us.ibm.com>

Currently symbol resolution does not work for 64-bit programs on architectures
that use function descriptors such as ppc64.

The problem is that a symbol doesn't point to a text address, it points to a
data area that contains (amongst other things) a pointer to the text address.

We look for a section called ".opd" which is the function descriptor area. To
create the full symbol table, when we see a symbol in the function descriptor
section we load the first pointer and use that as the text address.

Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
LKML-Reference: <1276523793-15422-1-git-send-email-ebmunson@us.ibm.com>
Signed-off-by: Anton Blanchard <anton@samba.org>
Signed-off-by: Eric B Munson <ebmunson@us.ibm.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/symbol.c |   37 ++++++++++++++++++++++++++++++++++---
 1 files changed, 34 insertions(+), 3 deletions(-)

diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index b63e571..971d0a0 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -933,6 +933,25 @@ static bool elf_sec__is_a(GElf_Shdr *self, Elf_Data *secstrs, enum map_type type
 	}
 }
 
+static size_t elf_addr_to_index(Elf *elf, GElf_Addr addr)
+{
+	Elf_Scn *sec = NULL;
+	GElf_Shdr shdr;
+	size_t cnt = 1;
+
+	while ((sec = elf_nextscn(elf, sec)) != NULL) {
+		gelf_getshdr(sec, &shdr);
+
+		if ((addr >= shdr.sh_addr) &&
+		    (addr < (shdr.sh_addr + shdr.sh_size)))
+			return cnt;
+
+		++cnt;
+	}
+
+	return -1;
+}
+
 static int dso__load_sym(struct dso *self, struct map *map, const char *name,
 			 int fd, symbol_filter_t filter, int kmodule)
 {
@@ -944,12 +963,13 @@ static int dso__load_sym(struct dso *self, struct map *map, const char *name,
 	int err = -1;
 	uint32_t idx;
 	GElf_Ehdr ehdr;
-	GElf_Shdr shdr;
-	Elf_Data *syms;
+	GElf_Shdr shdr, opdshdr;
+	Elf_Data *syms, *opddata = NULL;
 	GElf_Sym sym;
-	Elf_Scn *sec, *sec_strndx;
+	Elf_Scn *sec, *sec_strndx, *opdsec;
 	Elf *elf;
 	int nr = 0;
+	size_t opdidx = 0;
 
 	elf = elf_begin(fd, PERF_ELF_C_READ_MMAP, NULL);
 	if (elf == NULL) {
@@ -969,6 +989,10 @@ static int dso__load_sym(struct dso *self, struct map *map, const char *name,
 			goto out_elf_end;
 	}
 
+	opdsec = elf_section_by_name(elf, &ehdr, &opdshdr, ".opd", &opdidx);
+	if (opdsec)
+		opddata = elf_rawdata(opdsec, NULL);
+
 	syms = elf_getdata(sec, NULL);
 	if (syms == NULL)
 		goto out_elf_end;
@@ -1013,6 +1037,13 @@ static int dso__load_sym(struct dso *self, struct map *map, const char *name,
 		if (!is_label && !elf_sym__is_a(&sym, map->type))
 			continue;
 
+		if (opdsec && sym.st_shndx == opdidx) {
+			u32 offset = sym.st_value - opdshdr.sh_addr;
+			u64 *opd = opddata->d_buf + offset;
+			sym.st_value = *opd;
+			sym.st_shndx = elf_addr_to_index(elf, sym.st_value);
+		}
+
 		sec = elf_getscn(elf, sym.st_shndx);
 		if (!sec)
 			goto out_elf_end;
-- 
1.6.2.5

