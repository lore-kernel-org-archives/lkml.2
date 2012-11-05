Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753580Ab2KEJGv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 04:06:51 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:37255 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753060Ab2KEJGt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 04:06:49 -0500
From: Jamie Iles <jamie.iles@oracle.com>
To: linux-kernel@vger.kernel.org
Cc: Jamie Iles <jamie.iles@oracle.com>, David Daney <david.daney@cavium.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH] scripts/sortextable: support objects with more than 64K sections.
Date: Mon,  5 Nov 2012 09:06:44 +0000
Message-Id: <1352106404-11038-1-git-send-email-jamie.iles@oracle.com>
X-Mailer: git-send-email 1.7.10.4
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Building with a large config and -ffunction-sections results in a large
number of sections and sortextable needs to be able to handle that.
Implement support for > 64K sections as modpost does.

Cc: David Daney <david.daney@cavium.com>
Cc: H. Peter Anvin <hpa@zytor.com>
Signed-off-by: Jamie Iles <jamie.iles@oracle.com>
---
 scripts/sortextable.c |   24 ++++++++++++++++++++++++
 scripts/sortextable.h |   26 +++++++++++++++++++++++---
 2 files changed, 47 insertions(+), 3 deletions(-)

diff --git a/scripts/sortextable.c b/scripts/sortextable.c
index f19ddc4..1bd0c60 100644
--- a/scripts/sortextable.c
+++ b/scripts/sortextable.c
@@ -156,6 +156,30 @@ static void (*w2)(uint16_t, uint16_t *);
 
 typedef void (*table_sort_t)(char *, int);
 
+/*
+ * Move reserved section indices SHN_LORESERVE..SHN_HIRESERVE out of
+ * the way to -256..-1, to avoid conflicting with real section
+ * indices.
+ */
+#define SPECIAL(i) ((i) - (SHN_HIRESERVE + 1))
+
+static inline int is_shndx_special(unsigned int i)
+{
+	return i != SHN_XINDEX && i >= SHN_LORESERVE && i <= SHN_HIRESERVE;
+}
+
+/* Accessor for sym->st_shndx, hides ugliness of "64k sections" */
+static inline unsigned int get_secindex(unsigned int shndx,
+					unsigned int sym_offs,
+					const Elf32_Word *symtab_shndx_start)
+{
+	if (is_shndx_special(shndx))
+		return SPECIAL(shndx);
+	if (shndx != SHN_XINDEX)
+		return shndx;
+	return r(&symtab_shndx_start[sym_offs]);
+}
+
 /* 32 bit and 64 bit are very similar */
 #include "sortextable.h"
 #define SORTEXTABLE_64
diff --git a/scripts/sortextable.h b/scripts/sortextable.h
index e4fd45b..8206594 100644
--- a/scripts/sortextable.h
+++ b/scripts/sortextable.h
@@ -98,6 +98,8 @@ do_func(Elf_Ehdr *ehdr, char const *const fname, table_sort_t custom_sort)
 	Elf_Shdr *symtab_sec = NULL;
 	Elf_Shdr *extab_sec = NULL;
 	Elf_Sym *sym;
+	const Elf_Sym *symtab;
+	Elf32_Word *symtab_shndx_start = NULL;
 	Elf_Sym *sort_needed_sym;
 	Elf_Shdr *sort_needed_sec;
 	Elf_Rel *relocs = NULL;
@@ -109,11 +111,22 @@ do_func(Elf_Ehdr *ehdr, char const *const fname, table_sort_t custom_sort)
 	int extab_index = 0;
 	int i;
 	int idx;
+	unsigned int num_sections;
+	unsigned int secindex_strings;
 
 	shdr = (Elf_Shdr *)((char *)ehdr + _r(&ehdr->e_shoff));
-	shstrtab_sec = shdr + r2(&ehdr->e_shstrndx);
+
+	num_sections = r2(&ehdr->e_shnum);
+	if (num_sections == SHN_UNDEF)
+		num_sections = _r(&shdr[0].sh_size);
+
+	secindex_strings = r2(&ehdr->e_shstrndx);
+	if (secindex_strings == SHN_XINDEX)
+		secindex_strings = r(&shdr[0].sh_link);
+
+	shstrtab_sec = shdr + secindex_strings;
 	secstrtab = (const char *)ehdr + _r(&shstrtab_sec->sh_offset);
-	for (i = 0; i < r2(&ehdr->e_shnum); i++) {
+	for (i = 0; i < num_sections; i++) {
 		idx = r(&shdr[i].sh_name);
 		if (strcmp(secstrtab + idx, "__ex_table") == 0) {
 			extab_sec = shdr + i;
@@ -129,6 +142,9 @@ do_func(Elf_Ehdr *ehdr, char const *const fname, table_sort_t custom_sort)
 			symtab_sec = shdr + i;
 		if (strcmp(secstrtab + idx, ".strtab") == 0)
 			strtab_sec = shdr + i;
+		if (r(&shdr[i].sh_type) == SHT_SYMTAB_SHNDX)
+			symtab_shndx_start = (Elf32_Word *)(
+				(const char *)ehdr + _r(&shdr[i].sh_offset));
 	}
 	if (strtab_sec == NULL) {
 		fprintf(stderr,	"no .strtab in  file: %s\n", fname);
@@ -138,6 +154,8 @@ do_func(Elf_Ehdr *ehdr, char const *const fname, table_sort_t custom_sort)
 		fprintf(stderr,	"no .symtab in  file: %s\n", fname);
 		fail_file();
 	}
+	symtab = (const Elf_Sym *)((const char *)ehdr +
+				   _r(&symtab_sec->sh_offset));
 	if (extab_sec == NULL) {
 		fprintf(stderr,	"no __ex_table in  file: %s\n", fname);
 		fail_file();
@@ -176,7 +194,9 @@ do_func(Elf_Ehdr *ehdr, char const *const fname, table_sort_t custom_sort)
 			fname);
 		fail_file();
 	}
-	sort_needed_sec = &shdr[r2(&sort_needed_sym->st_shndx)];
+	sort_needed_sec = &shdr[get_secindex(r2(&sym->st_shndx),
+					     sort_needed_sym - symtab,
+					     symtab_shndx_start)];
 	sort_done_location = (void *)ehdr +
 		_r(&sort_needed_sec->sh_offset) +
 		_r(&sort_needed_sym->st_value) -
-- 
1.7.10.4

