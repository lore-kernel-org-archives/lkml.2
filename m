Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756290Ab0GWTK7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jul 2010 15:10:59 -0400
Received: from pfepb.post.tele.dk ([195.41.46.236]:53393 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752025Ab0GWTK6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jul 2010 15:10:58 -0400
Date: Fri, 23 Jul 2010 21:10:55 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Denys Vlasenko <vda.linux@googlemail.com>
Cc: Tim Abbott <tabbott@ksplice.com>, Tim Bird <tim.bird@am.sony.com>,
        James Bottomley <James.Bottomley@hansenpartnership.com>,
        linux-kernel@vger.kernel.org, Matt Fleming <matt@console-pimps.org>,
        linux-arch@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Michal Marek <mmarek@suse.cz>,
        Parisc List <linux-parisc@vger.kernel.org>
Subject: Re: Testing of function/data-sections on linux-2.6.35-rc4
Message-ID: <20100723191055.GA27054@merkur.ravnborg.org>
References: <201007181703.17022.vda.linux@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201007181703.17022.vda.linux@googlemail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> * modpost fix for 64k+ sections: linux-2.6.35-rc4-fs.modpost.patch
>   This patch is in -mm, it still not reach mainline...
> 

Some comments below - but noting fundamental.

	Sam

--- linux-2.6.35-rc4/scripts/mod/file2alias.c
+++ linux-2.6.35-rc4-fs.obj1/scripts/mod/file2alias.c
@@ -884,16 +884,16 @@
 	char *zeros = NULL;
 
 	/* We're looking for a section relative symbol */
-	if (!sym->st_shndx || sym->st_shndx >= info->hdr->e_shnum)
+	if (!sym->st_shndx || get_secindex(info, sym) >= info->num_sections)
 		return;
 
 	/* Handle all-NULL symbols allocated into .bss */
-	if (info->sechdrs[sym->st_shndx].sh_type & SHT_NOBITS) {
+	if (info->sechdrs[get_secindex(info, sym)].sh_type & SHT_NOBITS) {
 		zeros = calloc(1, sym->st_size);
 		symval = zeros;
 	} else {
 		symval = (void *)info->hdr
-			+ info->sechdrs[sym->st_shndx].sh_offset
+			+ info->sechdrs[get_secindex(info, sym)].sh_offset
 			+ sym->st_value;
 	}
 
--- linux-2.6.35-rc4/scripts/mod/modpost.c
+++ linux-2.6.35-rc4-fs.obj1/scripts/mod/modpost.c
@@ -253,7 +253,7 @@
 	return export_unknown;
 }
 
-static enum export export_from_sec(struct elf_info *elf, Elf_Section sec)
+static enum export export_from_sec(struct elf_info *elf, unsigned int sec)
 {
 	if (sec == elf->export_sec)
 		return export_plain;
@@ -373,6 +373,8 @@
 	Elf_Ehdr *hdr;
 	Elf_Shdr *sechdrs;
 	Elf_Sym  *sym;
+	const char *secstrings;
+	unsigned int symtab_idx = ~0U, symtab_shndx_idx = ~0U;
 
 	hdr = grab_file(filename, &info->size);
 	if (!hdr) {
@@ -417,8 +419,19 @@
 		return 0;
 	}
 
+	/* Fixup for more than 64k sections */
+	info->num_sections = hdr->e_shnum;
+	if (info->num_sections == 0) { /* more than 64k sections? */
+		/* note: it doesn't need shndx2secindex() */
+		info->num_sections = TO_NATIVE(sechdrs[0].sh_size);
+	}
I had to read the above twice to get it.
How about something like this:

	/* Fixup for more than 64k sections */
	if (hdr->e_shnum == 0) {
		/*
		 * There are more than 64k sections,
		 * read count from .sh_size.
		 * note: it doesn't need shndx2secindex()
		 */
		info->num_sections = TO_NATIVE(sechdrs[0].sh_size);
	}
	else {
		info->num_sections = hdr->e_shnum;
	}


+	info->secindex_strings = hdr->e_shstrndx;
+	if (info->secindex_strings == SHN_XINDEX)
+		info->secindex_strings =
+		    shndx2secindex(TO_NATIVE(sechdrs[0].sh_link));

Likewise here...

	/* e_shstrndx == SHN_XINDEX if we have > 64k strings */
	if (hdr->e_shstrndx != SHN_XINDEX)
		info->secindex_strings = hdr->e_shstrndx;
	else
		info->secindex_strings = shndx2secindex(TO_NATIVE(sechdrs[0].sh_link));


 	/* Fix endianness in section headers */
-	for (i = 0; i < hdr->e_shnum; i++) {
+	for (i = 0; i < info->num_sections; i++) {
 		sechdrs[i].sh_name      = TO_NATIVE(sechdrs[i].sh_name);
 		sechdrs[i].sh_type      = TO_NATIVE(sechdrs[i].sh_type);
 		sechdrs[i].sh_flags     = TO_NATIVE(sechdrs[i].sh_flags);
@@ -431,9 +444,8 @@
 		sechdrs[i].sh_entsize   = TO_NATIVE(sechdrs[i].sh_entsize);
 	}
 	/* Find symbol table. */
-	for (i = 1; i < hdr->e_shnum; i++) {
-		const char *secstrings
-			= (void *)hdr + sechdrs[hdr->e_shstrndx].sh_offset;
+	secstrings = (void *)hdr + sechdrs[info->secindex_strings].sh_offset;

Moving this assignnet out of the loop is an unrelated
but welcome change.


+	for (i = 1; i < info->num_sections; i++) {
 		const char *secname;
 		int nobits = sechdrs[i].sh_type == SHT_NOBITS;
 
@@ -461,14 +473,26 @@
 		else if (strcmp(secname, "__ksymtab_gpl_future") == 0)
 			info->export_gpl_future_sec = i;
 
-		if (sechdrs[i].sh_type != SHT_SYMTAB)
-			continue;
+		if (sechdrs[i].sh_type == SHT_SYMTAB) {
+			unsigned int sh_link_idx;
+			symtab_idx = i;
+			info->symtab_start = (void *)hdr +
+			    sechdrs[i].sh_offset;
+			info->symtab_stop  = (void *)hdr +
+			    sechdrs[i].sh_offset + sechdrs[i].sh_size;
+			sh_link_idx = shndx2secindex(sechdrs[i].sh_link);
+			info->strtab       = (void *)hdr +
+			    sechdrs[sh_link_idx].sh_offset;
+		}
 
-		info->symtab_start = (void *)hdr + sechdrs[i].sh_offset;
-		info->symtab_stop  = (void *)hdr + sechdrs[i].sh_offset
-			                         + sechdrs[i].sh_size;
-		info->strtab       = (void *)hdr +
-			             sechdrs[sechdrs[i].sh_link].sh_offset;
+		/* 32bit section no. table? ("more than 64k sections") */
+		if (sechdrs[i].sh_type == SHT_SYMTAB_SHNDX) {
+			symtab_shndx_idx = i;
+			info->symtab_shndx_start = (void *)hdr +
+			    sechdrs[i].sh_offset;
+			info->symtab_shndx_stop  = (void *)hdr +
+			    sechdrs[i].sh_offset + sechdrs[i].sh_size;
+		}
 	}
 	if (!info->symtab_start)
 		fatal("%s has no symtab?\n", filename);
@@ -480,6 +504,21 @@
 		sym->st_value = TO_NATIVE(sym->st_value);
 		sym->st_size  = TO_NATIVE(sym->st_size);
 	}
+
+	if (symtab_shndx_idx != ~0U) {
+		Elf32_Word *p;
+		if (symtab_idx !=
+		    shndx2secindex(sechdrs[symtab_shndx_idx].sh_link))
+			fatal("%s: SYMTAB_SHNDX has bad sh_link: %u!=%u\n",
+			      filename,
+			      shndx2secindex(sechdrs[symtab_shndx_idx].sh_link),
+			      symtab_idx);
+		/* Fix endianness */
+		for (p = info->symtab_shndx_start; p < info->symtab_shndx_stop;
+		     p++)
+			*p = TO_NATIVE(*p);
+	}
+
 	return 1;
 }
 
@@ -514,7 +553,7 @@
 			       Elf_Sym *sym, const char *symname)
 {
 	unsigned int crc;
-	enum export export = export_from_sec(info, sym->st_shndx);
+	enum export export = export_from_sec(info, get_secindex(info, sym));
 
 	switch (sym->st_shndx) {
 	case SHN_COMMON:
@@ -656,19 +695,19 @@
 		return "(unknown)";
 }
 
-static const char *sec_name(struct elf_info *elf, int shndx)
+static const char *sec_name(struct elf_info *elf, int secindex)
 {
 	Elf_Shdr *sechdrs = elf->sechdrs;
 	return (void *)elf->hdr +
-	        elf->sechdrs[elf->hdr->e_shstrndx].sh_offset +
-	        sechdrs[shndx].sh_name;
+		elf->sechdrs[elf->secindex_strings].sh_offset +
+		sechdrs[secindex].sh_name;
 }
 
 static const char *sech_name(struct elf_info *elf, Elf_Shdr *sechdr)
 {
 	return (void *)elf->hdr +
-	        elf->sechdrs[elf->hdr->e_shstrndx].sh_offset +
-	        sechdr->sh_name;
+		elf->sechdrs[elf->secindex_strings].sh_offset +
+		sechdr->sh_name;
 }
 
 /* if sym is empty or point to a string
@@ -1047,11 +1086,14 @@
 	Elf_Sym *near = NULL;
 	Elf64_Sword distance = 20;
 	Elf64_Sword d;
+	unsigned int relsym_secindex;
 
 	if (relsym->st_name != 0)
 		return relsym;
+
+	relsym_secindex = get_secindex(elf, relsym);
 	for (sym = elf->symtab_start; sym < elf->symtab_stop; sym++) {
-		if (sym->st_shndx != relsym->st_shndx)
+		if (get_secindex(elf, sym) != relsym_secindex)
 			continue;
 		if (ELF_ST_TYPE(sym->st_info) == STT_SECTION)
 			continue;
@@ -1113,9 +1155,9 @@
 	for (sym = elf->symtab_start; sym < elf->symtab_stop; sym++) {
 		const char *symsec;
 
-		if (sym->st_shndx >= SHN_LORESERVE)
+		if (is_shndx_special(sym->st_shndx))
 			continue;
-		symsec = sec_name(elf, sym->st_shndx);
+		symsec = sec_name(elf, get_secindex(elf, sym));
 		if (strcmp(symsec, sec) != 0)
 			continue;
 		if (!is_valid_name(elf, sym))
@@ -1311,7 +1353,7 @@
 	const char *tosec;
 	const struct sectioncheck *mismatch;
 
-	tosec = sec_name(elf, sym->st_shndx);
+	tosec = sec_name(elf, get_secindex(elf, sym));
 	mismatch = section_mismatch(fromsec, tosec);
 	if (mismatch) {
 		Elf_Sym *to;
@@ -1339,7 +1381,7 @@
 				    Elf_Shdr *sechdr, Elf_Rela *r)
 {
 	Elf_Shdr *sechdrs = elf->sechdrs;
-	int section = sechdr->sh_info;
+	int section = shndx2secindex(sechdr->sh_info);
 
 	return (void *)elf->hdr + sechdrs[section].sh_offset +
 		r->r_offset - sechdrs[section].sh_addr;
@@ -1447,7 +1489,7 @@
 		r.r_addend = TO_NATIVE(rela->r_addend);
 		sym = elf->symtab_start + r_sym;
 		/* Skip special sections */
-		if (sym->st_shndx >= SHN_LORESERVE)
+		if (is_shndx_special(sym->st_shndx))
 			continue;
 		check_section_mismatch(modname, elf, &r, sym, fromsec);
 	}
@@ -1505,7 +1547,7 @@
 		}
 		sym = elf->symtab_start + r_sym;
 		/* Skip special sections */
-		if (sym->st_shndx >= SHN_LORESERVE)
+		if (is_shndx_special(sym->st_shndx))
 			continue;
 		check_section_mismatch(modname, elf, &r, sym, fromsec);
 	}
@@ -1530,7 +1572,7 @@
 	Elf_Shdr *sechdrs = elf->sechdrs;
 
 	/* Walk through all sections */
-	for (i = 0; i < elf->hdr->e_shnum; i++) {
+	for (i = 0; i < elf->num_sections; i++) {
 		check_section(modname, elf, &elf->sechdrs[i]);
 		/* We want to process only relocation sections and not .init */
 		if (sechdrs[i].sh_type == SHT_RELA)
--- linux-2.6.35-rc4/scripts/mod/modpost.h
+++ linux-2.6.35-rc4-fs.obj1/scripts/mod/modpost.h
@@ -129,7 +129,50 @@
 	const char   *strtab;
 	char	     *modinfo;
 	unsigned int modinfo_len;
+
+	/* support for 32bit section numbers */
+
+	unsigned int num_sections; /* max_secindex + 1 */
+	unsigned int secindex_strings;
+	/* if Nth symbol table entry has .st_shndx = SHN_XINDEX,
+	 * take shndx from symtab_shndx_start[N] instead */
+	Elf32_Word   *symtab_shndx_start;
+	Elf32_Word   *symtab_shndx_stop;
 };
+
+static inline int is_shndx_special(unsigned int i)
+{
+	return i != SHN_XINDEX && i >= SHN_LORESERVE && i <= SHN_HIRESERVE;
+}
+
+/* shndx is in [0..SHN_LORESERVE) U (SHN_HIRESERVE, 0xfffffff], thus:
+ * shndx == 0               <=> sechdrs[0]
+ * ......
+ * shndx == SHN_LORESERVE-1 <=> sechdrs[SHN_LORESERVE-1]
+ * shndx == SHN_HIRESERVE+1 <=> sechdrs[SHN_LORESERVE]
+ * shndx == SHN_HIRESERVE+2 <=> sechdrs[SHN_LORESERVE+1]
+ * ......
+ * fyi: sym->st_shndx is uint16, SHN_LORESERVE = ff00, SHN_HIRESERVE = ffff,
+ * so basically we map  0000..feff -> 0000..feff
+ *                      ff00..ffff -> (you are a bad boy, dont do it)
+ *                     10000..xxxx -> ff00..(xxxx-0x100)
+ */
+static inline unsigned int shndx2secindex(unsigned int i)
+{
+	if (i <= SHN_HIRESERVE)
+		return i;
+	return i - (SHN_HIRESERVE + 1 - SHN_LORESERVE);
+}
+
+/* Accessor for sym->st_shndx, hides ugliness of "64k sections" */
+static inline unsigned int get_secindex(const struct elf_info *info,
+					const Elf_Sym *sym)
+{
+	if (sym->st_shndx != SHN_XINDEX)
+		return sym->st_shndx;
+	return shndx2secindex(info->symtab_shndx_start[sym -
+						       info->symtab_start]);
+}
 
 /* file2alias.c */
 extern unsigned int cross_build;
