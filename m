Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758156Ab0FRKQt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jun 2010 06:16:49 -0400
Received: from hera.kernel.org ([140.211.167.34]:46801 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756850Ab0FRKQr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jun 2010 06:16:47 -0400
Date: Fri, 18 Jun 2010 10:16:23 GMT
From: tip-bot for Eric B Munson <ebmunson@us.ibm.com>
Cc: acme@redhat.com, anton@samba.org, linux-kernel@vger.kernel.org,
       paulus@samba.org, hpa@zytor.com, mingo@redhat.com, peterz@infradead.org,
       ebmunson@us.ibm.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, anton@samba.org, acme@redhat.com,
       ebmunson@us.ibm.com, peterz@infradead.org, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <1276523793-15422-1-git-send-email-ebmunson@us.ibm.com>
References: <1276523793-15422-1-git-send-email-ebmunson@us.ibm.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf symbols: Function descriptor symbol lookup
Message-ID: <tip-70c3856b2f1304e0abc65f1b96a8c60ddfc0fb9e@git.kernel.org>
Git-Commit-ID: 70c3856b2f1304e0abc65f1b96a8c60ddfc0fb9e
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 18 Jun 2010 10:16:24 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  70c3856b2f1304e0abc65f1b96a8c60ddfc0fb9e
Gitweb:     http://git.kernel.org/tip/70c3856b2f1304e0abc65f1b96a8c60ddfc0fb9e
Author:     Eric B Munson <ebmunson@us.ibm.com>
AuthorDate: Mon, 14 Jun 2010 14:56:33 +0100
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Thu, 17 Jun 2010 10:06:27 -0300

perf symbols: Function descriptor symbol lookup

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
