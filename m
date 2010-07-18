Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756356Ab0GRPDf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jul 2010 11:03:35 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:64013 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756296Ab0GRPDa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jul 2010 11:03:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-type
         :message-id;
        b=wbEOxicLG8eIFuyctHMYQ/r0+6tHhSvU+GHUOTykq03AkGo9MqPSCdCyLBlGrSbE4U
         eg0a2gp5zv5fPja4h+1CjY+pRT2zVLig5J7MhiSioAWkJMgg6aI0xKpmhwsoKyzVQy9H
         ORkaTEmbdXvb7CkpCch23Z8unuCenXKXNWhvU=
From: Denys Vlasenko <vda.linux@googlemail.com>
To: Tim Abbott <tabbott@ksplice.com>, Tim Bird <tim.bird@am.sony.com>
Subject: Testing of function/data-sections on linux-2.6.35-rc4
Date: Sun, 18 Jul 2010 17:03:16 +0200
User-Agent: KMail/1.8.2
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>,
        linux-kernel@vger.kernel.org, Matt Fleming <matt@console-pimps.org>,
        linux-arch@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Sam Ravnborg <sam@ravnborg.org>, Michal Marek <mmarek@suse.cz>,
        Denys Vlasenko <vda.linux@googlemail.com>,
        Parisc List <linux-parisc@vger.kernel.org>
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_1exQMv9z7xuz/lL"
Message-Id: <201007181703.17022.vda.linux@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_1exQMv9z7xuz/lL
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi Tim, Tim, folks,

Update on -ffunction-sections status:

I re-tested linux-2.6.35-rc4 today.

Most of work needed for -ffunction-sections -fdata-sections
is already in this kernel. This mail explains what is
still missing.

In order to have a working kernel with this make invocation:

	make KCFLAGS="-ffunction-sections -fdata-sections"

linux-2.6.35-rc4 needs three patches:

* modpost fix for 64k+ sections: linux-2.6.35-rc4-fs.modpost.patch
  This patch is in -mm, it still not reach mainline...

* fix for kernel linker stripts: linux-2.6.35-rc4-fs.fix-kernel-linker-scripts.patch
  It makes _all_ linker scripts -ffunction/data-sections safe via:
  -       *(.data)
  +       *(.data .data.*)
  
* fix for module linker script: linux-2.6.35-rc4-fs.fix-ko-module-linker-script.patch
  Prevents kernel modules from having unnecessarily many
  sections and thus prevents module size growth.


Then, in order to also garbage-collect the sections, I added

LDFLAGS_vmlinux += --gc-sections

in top-level Makefile.

This requires the additional patch (linux-2.6.35-rc4-fsgs.patch)
which adds KEEP(section) directives to kernel linker stripts.
Otherwise, linker will discard some crucial sections.


All four patches are attached.

I am sending this email from the machine which runs the kernel
built with -ffunction-sections -fdata-sections --gc-sections.

-- 
vda

--Boundary-00=_1exQMv9z7xuz/lL
Content-Type: text/x-diff;
  charset="us-ascii";
  name="linux-2.6.35-rc4-fs.modpost.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="linux-2.6.35-rc4-fs.modpost.patch"

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
+	info->secindex_strings = hdr->e_shstrndx;
+	if (info->secindex_strings == SHN_XINDEX)
+		info->secindex_strings =
+		    shndx2secindex(TO_NATIVE(sechdrs[0].sh_link));
+
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

--Boundary-00=_1exQMv9z7xuz/lL
Content-Type: text/x-diff;
  charset="us-ascii";
  name="linux-2.6.35-rc4-fs.fix-kernel-linker-scripts.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="linux-2.6.35-rc4-fs.fix-kernel-linker-scripts.patch"

--- linux-2.6.35-rc4/arch/alpha/boot/bootloader.lds
+++ linux-2.6.35-rc4.new/arch/alpha/boot/bootloader.lds
@@ -4,17 +4,17 @@
 SECTIONS
 {
   . = 0x20000000;
-  .text : { *(.text) }
+  .text : { *(.text .text.*) }
   _etext = .;
   PROVIDE (etext = .);
-  .rodata : { *(.rodata) *(.rodata.*) }
-  .data : { *(.data) CONSTRUCTORS }
+  .rodata : { *(.rodata .rodata.*) }
+  .data : { *(.data .data.*) CONSTRUCTORS }
   .got : { *(.got) }
   .sdata : { *(.sdata) }
   _edata = .;
   PROVIDE (edata = .);
   .sbss : { *(.sbss) *(.scommon) }
-  .bss : { *(.bss) *(COMMON) }
+  .bss : { *(.bss .bss.*) *(COMMON) }
   _end = . ;
   PROVIDE (end = .);
 
--- linux-2.6.35-rc4/arch/arm/boot/bootp/bootp.lds
+++ linux-2.6.35-rc4.new/arch/arm/boot/bootp/bootp.lds
@@ -15,7 +15,7 @@
   .text : {
    _stext = .;
    *(.start)
-   *(.text)
+   *(.text .text.*)
    initrd_size = initrd_end - initrd_start;
    _etext = .;
   }
--- linux-2.6.35-rc4/arch/arm/boot/compressed/vmlinux.lds.in
+++ linux-2.6.35-rc4.new/arch/arm/boot/compressed/vmlinux.lds.in
@@ -29,12 +29,10 @@
   .text : {
     _start = .;
     *(.start)
-    *(.text)
-    *(.text.*)
+    *(.text .text.*)
     *(.fixup)
     *(.gnu.warning)
-    *(.rodata)
-    *(.rodata.*)
+    *(.rodata .rodata.*)
     *(.glue_7)
     *(.glue_7t)
     *(.piggydata)
--- linux-2.6.35-rc4/arch/arm/kernel/vmlinux.lds.S
+++ linux-2.6.35-rc4.new/arch/arm/kernel/vmlinux.lds.S
@@ -95,8 +95,7 @@
 			*(.fixup)
 #endif
 			*(.gnu.warning)
-			*(.rodata)
-			*(.rodata.*)
+			*(.rodata .rodata.*)
 			*(.glue_7)
 			*(.glue_7t)
 		*(.got)			/* Global offset table		*/
--- linux-2.6.35-rc4/arch/cris/boot/compressed/decompress_v10.lds
+++ linux-2.6.35-rc4.new/arch/cris/boot/compressed/decompress_v10.lds
@@ -12,19 +12,18 @@
 	.text :
 	{
 		_stext = . ;
-		*(.text)
-		*(.rodata)
-		*(.rodata.*)
+		*(.text .text.*)
+		*(.rodata .rodata.*)
 		_etext = . ;
 	} > dram
 	.data :
 	{
-		*(.data)
+		*(.data .data.*)
 		_edata = . ;
 	} > dram
 	.bss :
 	{
-		*(.bss)
+		*(.bss .bss.*)
 		_end = ALIGN( 0x10 ) ;
 	} > dram
 }
--- linux-2.6.35-rc4/arch/cris/boot/compressed/decompress_v32.lds
+++ linux-2.6.35-rc4.new/arch/cris/boot/compressed/decompress_v32.lds
@@ -12,19 +12,18 @@
 	.text :
 	{
 		_stext = . ;
-		*(.text)
-		*(.rodata)
-		*(.rodata.*)
+		*(.text .text.*)
+		*(.rodata .rodata.*)
 		_etext = . ;
 	} > dram
 	.data :
 	{
-		*(.data)
+		*(.data .data.*)
 		_edata = . ;
 	} > dram
 	.bss :
 	{
-		*(.bss)
+		*(.bss .bss.*)
 		_end = ALIGN( 0x10 ) ;
 	} > dram
 }
--- linux-2.6.35-rc4/arch/cris/boot/rescue/rescue_v10.lds
+++ linux-2.6.35-rc4.new/arch/cris/boot/rescue/rescue_v10.lds
@@ -9,12 +9,12 @@
 	.text :
 	{
 		stext = . ;
-		*(.text)
+		*(.text .text.*)
 		etext = . ;
 	} > flash
 	.data :
 	{
-		*(.data)
+		*(.data .data.*)
 		edata = . ;
 	} > flash
 }
--- linux-2.6.35-rc4/arch/cris/boot/rescue/rescue_v32.lds
+++ linux-2.6.35-rc4.new/arch/cris/boot/rescue/rescue_v32.lds
@@ -16,21 +16,20 @@
 	.text :
 	{
 		_stext = . ;
-		*(.text)
+		*(.text .text.*)
 		*(.init.text)
-		*(.rodata)
-		*(.rodata.*)
+		*(.rodata .rodata.*)
 		_etext = . ;
 	} > bootblk
 	.data :
 	{
-		*(.data)
+		*(.data .data.*)
 		_edata = . ;
 	} > bootblk
 	.bss :
 	{
 		_bss = . ;
-		*(.bss)
+		*(.bss .bss.*)
 		_end = ALIGN( 0x10 ) ;
 	} > intmem
 
--- linux-2.6.35-rc4/arch/frv/kernel/vmlinux.lds.S
+++ linux-2.6.35-rc4.new/arch/frv/kernel/vmlinux.lds.S
@@ -114,7 +114,7 @@
 
   .sbss		: { *(.sbss .sbss.*) }
   .bss		: { *(.bss .bss.*) }
-  .bss..stack	: { *(.bss) }
+  .bss..stack	: { *(.bss) } /* BUG??? we already absorbed it into .bss */
 
   __bss_stop = .;
   _end = . ;
--- linux-2.6.35-rc4/arch/h8300/boot/compressed/vmlinux.lds
+++ linux-2.6.35-rc4.new/arch/h8300/boot/compressed/vmlinux.lds
@@ -5,13 +5,13 @@
         __stext = . ;
 	__text = .;
 	       *(.text..startup)
-	       *(.text)
+	       *(.text .text.*)
         __etext = . ;
         }
 
 	.rodata :
 	{
-		*(.rodata)
+		*(.rodata .rodata.*)
 	}
         .data :
 
--- linux-2.6.35-rc4/arch/h8300/boot/compressed/vmlinux.scr
+++ linux-2.6.35-rc4.new/arch/h8300/boot/compressed/vmlinux.scr
@@ -3,7 +3,7 @@
   .data : {
 	_input_len = .;
 	LONG(_input_data_end - _input_data) _input_data = .;
-	*(.data)
+	*(.data .data.*)
 	_input_data_end = .;
 	}
 }
--- linux-2.6.35-rc4/arch/ia64/hp/sim/boot/bootloader.lds
+++ linux-2.6.35-rc4.new/arch/ia64/hp/sim/boot/bootloader.lds
@@ -7,13 +7,13 @@
   . = 0x100000;
 
   _text = .;
-  .text : { *(__ivt_section) *(.text) }
+  .text : { *(__ivt_section) *(.text .text.*) }
   _etext = .;
 
   /* Global data */
   _data = .;
-  .rodata : { *(.rodata) *(.rodata.*) }
-  .data    : { *(.data) *(.gnu.linkonce.d*) CONSTRUCTORS }
+  .rodata : { *(.rodata .rodata.*) }
+  .data    : { *(.data .data.*) *(.gnu.linkonce.d*) CONSTRUCTORS }
   __gp = ALIGN (8) + 0x200000;
   .got           : { *(.got.plt) *(.got) }
   /* We want the small data sections together, so single-instruction offsets
@@ -24,7 +24,7 @@
 
   __bss_start = .;
   .sbss      : { *(.sbss) *(.scommon) }
-  .bss       : { *(.bss) *(COMMON) }
+  .bss       : { *(.bss .bss.*) *(COMMON) }
   . = ALIGN(64 / 8);
   __bss_stop = .;
   _end = . ;
--- linux-2.6.35-rc4/arch/ia64/kernel/gate.lds.S
+++ linux-2.6.35-rc4.new/arch/ia64/kernel/gate.lds.S
@@ -54,10 +54,10 @@
 	.IA_64.unwind_info	: { *(.IA_64.unwind_info*) }
 	.IA_64.unwind		: { *(.IA_64.unwind*) }	:readable	:unwind
 #ifdef HAVE_BUGGY_SEGREL
-	.text (GATE_ADDR + PAGE_SIZE) : { *(.text) *(.text.*) }	:readable
+	.text (GATE_ADDR + PAGE_SIZE) : { *(.text .text.*) }	:readable
 #else
 	. = ALIGN(PERCPU_PAGE_SIZE) + (. & (PERCPU_PAGE_SIZE - 1));
-	.text			: { *(.text) *(.text.*) }	:epc
+	.text			: { *(.text .text.*) }	:epc
 #endif
 
 	/DISCARD/		: {
--- linux-2.6.35-rc4/arch/ia64/scripts/check-segrel.lds
+++ linux-2.6.35-rc4.new/arch/ia64/scripts/check-segrel.lds
@@ -1,9 +1,9 @@
 SECTIONS {
 	. = SIZEOF_HEADERS;
-	.rodata : { *(.rodata) } :ro
+	.rodata : { *(.rodata .rodata.*) } :ro
 	.note : { *(.note*) }
 	. = 0xa0000;
-	.data : { *(.data) } :dat
+	.data : { *(.data .data.*) } :dat
 	/DISCARD/ : { *(*) }
 }
 PHDRS {
--- linux-2.6.35-rc4/arch/m32r/boot/compressed/vmlinux.lds.S
+++ linux-2.6.35-rc4.new/arch/m32r/boot/compressed/vmlinux.lds.S
@@ -6,12 +6,12 @@
   . = CONFIG_MEMORY_START + 0x00400000;
 
   _text = .;
-  .text : { *(.text) } = 0
-  .rodata : { *(.rodata) *(.rodata.*) }
+  .text : { *(.text .text.*) } = 0
+  .rodata : { *(.rodata .rodata.*) }
   _etext = .;
 
   . = ALIGN(32 / 8);
-  .data : { *(.data) }
+  .data : { *(.data .data.*) }
   . = ALIGN(32 / 8);
   _got = .;
   .got  : { *(.got) _egot = .; *(.got.*) }
@@ -19,7 +19,7 @@
 
   . = ALIGN(32 / 8);
   __bss_start = .;
-  .bss : { *(.bss) *(.sbss) }
+  .bss : { *(.bss .bss.*) *(.sbss) }
   . = ALIGN(32 / 8);
   _ebss = .;
   . = ALIGN(4096);
--- linux-2.6.35-rc4/arch/m32r/boot/compressed/vmlinux.scr
+++ linux-2.6.35-rc4.new/arch/m32r/boot/compressed/vmlinux.scr
@@ -2,7 +2,7 @@
 {
   .data : {
 	zimage_data = .;
-	*(.data)
+	*(.data .data.*)
 	zimage_data_end = .;
 	}
   zimage_len = zimage_data_end - zimage_data;
--- linux-2.6.35-rc4/arch/m68knommu/kernel/vmlinux.lds.S
+++ linux-2.6.35-rc4.new/arch/m68knommu/kernel/vmlinux.lds.S
@@ -75,7 +75,7 @@
 		*(__ex_table)
 		__stop___ex_table = .;
 
-		*(.rodata) *(.rodata.*)
+		*(.rodata .rodata.*)
 		*(__vermagic)		/* Kernel version magic */
 		*(__markers_strings)
 		*(.rodata1)
@@ -168,7 +168,7 @@
 	.bss : {
 		. = ALIGN(4);
 		_sbss = . ;
-		*(.bss)
+		*(.bss .bss.*)
 		*(COMMON)
 		. = ALIGN(4) ;
 		_ebss = . ;
--- linux-2.6.35-rc4/arch/mips/lasat/image/romscript.normal
+++ linux-2.6.35-rc4.new/arch/mips/lasat/image/romscript.normal
@@ -11,7 +11,7 @@
 
   .data ALIGN(0x10) :
   {
-    *(.data)
+    *(.data .data.*)
   }
   _image_start = ADDR(.data);
   _image_size = SIZEOF(.data);
--- linux-2.6.35-rc4/arch/mn10300/boot/compressed/vmlinux.lds
+++ linux-2.6.35-rc4.new/arch/mn10300/boot/compressed/vmlinux.lds
@@ -3,7 +3,7 @@
   .data : {
 	input_len = .;
 	LONG(input_data_end - input_data) input_data = .;
-	*(.data)
+	*(.data .data.*)
 	input_data_end = .;
 	}
 }
--- linux-2.6.35-rc4/arch/parisc/kernel/vmlinux.lds.S
+++ linux-2.6.35-rc4.new/arch/parisc/kernel/vmlinux.lds.S
@@ -111,7 +111,7 @@
 		*(.data..vm0.pte)
 	}
 	.bss : {
-		*(.bss)
+		*(.bss .bss.*)
 		*(COMMON)
 	}
 	__bss_stop = .;
--- linux-2.6.35-rc4/arch/powerpc/boot/zImage.coff.lds.S
+++ linux-2.6.35-rc4.new/arch/powerpc/boot/zImage.coff.lds.S
@@ -6,7 +6,7 @@
   _start = .;
   .text      :
   {
-    *(.text)
+    *(.text .text.*)
     *(.fixup)
   }
   _etext = .;
@@ -40,7 +40,7 @@
   .bss       :
   {
    *(.sbss)
-   *(.bss)
+   *(.bss .bss.*)
   }
   _end = . ;
 
--- linux-2.6.35-rc4/arch/powerpc/boot/zImage.lds.S
+++ linux-2.6.35-rc4.new/arch/powerpc/boot/zImage.lds.S
@@ -6,7 +6,7 @@
   _start = .;
   .text      :
   {
-    *(.text)
+    *(.text .text.*)
     *(.fixup)
   }
   _etext = .;
@@ -44,7 +44,7 @@
   .bss       :
   {
    *(.sbss)
-   *(.bss)
+   *(.bss .bss.*)
   }
   . = ALIGN(4096);
   _end = . ;
--- linux-2.6.35-rc4/arch/powerpc/boot/zImage.ps3.lds.S
+++ linux-2.6.35-rc4.new/arch/powerpc/boot/zImage.ps3.lds.S
@@ -20,7 +20,7 @@
   _start = .;
   .text      :
   {
-    *(.text)
+    *(.text .text.*)
     *(.fixup)
   }
   _etext = .;
@@ -43,7 +43,7 @@
   .bss       :
   {
    *(.sbss)
-   *(.bss)
+   *(.bss .bss.*)
   }
   . = ALIGN(4096);
   _end = . ;
--- linux-2.6.35-rc4/arch/sh/boot/compressed/vmlinux.scr
+++ linux-2.6.35-rc4.new/arch/sh/boot/compressed/vmlinux.scr
@@ -3,7 +3,7 @@
   .rodata..compressed : {
 	input_len = .;
 	LONG(input_data_end - input_data) input_data = .;
-	*(.data)
+	*(.data .data.*)
 	output_len = . - 4;
 	input_data_end = .;
 	}
--- linux-2.6.35-rc4/arch/sh/kernel/vsyscall/vsyscall.lds.S
+++ linux-2.6.35-rc4.new/arch/sh/kernel/vsyscall/vsyscall.lds.S
@@ -35,7 +35,7 @@
 	 */
 	. = 0x400;
 
-	.text		: { *(.text) } 			:text	=0x90909090
+	.text		: { *(.text .text.*) }		:text	=0x90909090
 	.note		: { *(.note.*) }		:text	:note
 	.eh_frame_hdr	: { *(.eh_frame_hdr ) }		:text	:eh_frame_hdr
 	.eh_frame	: {
--- linux-2.6.35-rc4/arch/x86/boot/setup.ld
+++ linux-2.6.35-rc4.new/arch/x86/boot/setup.ld
@@ -20,7 +20,7 @@
 	.initdata	: { *(.initdata) }
 	__end_init = .;
 
-	.text		: { *(.text) }
+	.text		: { *(.text .text.*) }
 	.text32		: { *(.text32) }
 
 	. = ALIGN(16);
@@ -45,7 +45,7 @@
 	.bss		:
 	{
 		__bss_start = .;
-		*(.bss)
+		*(.bss .bss.*)
 		__bss_end = .;
 	}
 	. = ALIGN(16);
--- linux-2.6.35-rc4/arch/x86/kernel/acpi/realmode/wakeup.lds.S
+++ linux-2.6.35-rc4.new/arch/x86/kernel/acpi/realmode/wakeup.lds.S
@@ -41,7 +41,7 @@
 	. = ALIGN(16);
 	.bss :	{
 		__bss_start = .;
-		*(.bss)
+		*(.bss .bss.*)
 		__bss_end = .;
 	}
 
--- linux-2.6.35-rc4/arch/x86/kernel/vmlinux.lds.S
+++ linux-2.6.35-rc4.new/arch/x86/kernel/vmlinux.lds.S
@@ -306,7 +306,7 @@
 	.bss : AT(ADDR(.bss) - LOAD_OFFSET) {
 		__bss_start = .;
 		*(.bss..page_aligned)
-		*(.bss)
+		*(.bss .bss.*)
 		. = ALIGN(4);
 		__bss_stop = .;
 	}
--- linux-2.6.35-rc4/arch/xtensa/boot/boot-elf/boot.lds.S
+++ linux-2.6.35-rc4.new/arch/xtensa/boot/boot-elf/boot.lds.S
@@ -10,19 +10,19 @@
 	{
 		__reloc_start = . ;
 		_text_start = . ;
-		*(.literal .text.literal .text)
+		*(.literal .text.literal .text .text.*)
 		_text_end = . ;
 	}
 
 	.rodata ALIGN(0x04):
 	{
-		*(.rodata)
+		*(.rodata .rodata.*)
 		*(.rodata1)
 	}
 
 	.data ALIGN(0x04):
 	{
-		*(.data)
+		*(.data .data.*)
 		*(.data1)
 		*(.sdata)
 		*(.sdata2)
@@ -57,7 +57,7 @@
 		*(.sbss)
 		*(.scommon)
 		*(.dynbss)
-		*(.bss)
+		*(.bss .bss.*)
 		__bss_end = .;
 	}
 	_end = .;
--- linux-2.6.35-rc4/arch/xtensa/boot/boot-redboot/boot.ld
+++ linux-2.6.35-rc4.new/arch/xtensa/boot/boot-redboot/boot.ld
@@ -8,19 +8,19 @@
 	{
 		__reloc_start = . ;
 		_text_start = . ;
-		*(.literal .text.literal .text)
+		*(.literal .text.literal .text .text.*)
 		_text_end = . ;
 	}
 
 	.rodata ALIGN(0x04):
 	{
-		*(.rodata)
+		*(.rodata .rodata.*)
 		*(.rodata1)
 	}
 
 	.data ALIGN(0x04):
 	{
-		*(.data)
+		*(.data .data.*)
 		*(.data1)
 		*(.sdata)
 		*(.sdata2)
@@ -55,7 +55,7 @@
 		*(.sbss)
 		*(.scommon)
 		*(.dynbss)
-		*(.bss)
+		*(.bss .bss.*)
 		__bss_end = .;
 	}
 	_end = .;
--- linux-2.6.35-rc4/include/asm-generic/vmlinux.lds.h
+++ linux-2.6.35-rc4.new/include/asm-generic/vmlinux.lds.h
@@ -140,9 +140,21 @@
 #define TRACE_SYSCALLS()
 #endif
 
+/* .data.foo are generated by gcc itself with -fdata-sections,
+ * whereas double-dot sections (like .data..percpu) are generated
+ * by kernel's magic macros.
+ *
+ * arch/.../vmlinux.lds.S decides where to place various double-dot sections
+ * as needed by its arch, here DATA_DATA needs to be careful and collect
+ * only .data and .data.foo sections, skipping .data..foo
+ *
+ * Same goes for .text, .bss and .rodata. In case of .rodata, various
+ * .rodata.foo sections are generated by gcc even without -fdata-sections
+ */
+
 /* .data section */
 #define DATA_DATA							\
-	*(.data)							\
+	*(.data .data.[A-Za-z0-9_$^]*)					\
 	*(.ref.data)							\
 	DEV_KEEP(init.data)						\
 	DEV_KEEP(exit.data)						\
@@ -202,7 +214,7 @@
 	. = ALIGN((align));						\
 	.rodata           : AT(ADDR(.rodata) - LOAD_OFFSET) {		\
 		VMLINUX_SYMBOL(__start_rodata) = .;			\
-		*(.rodata) *(.rodata.*)					\
+		*(.rodata .rodata.[A-Za-z0-9_$^]*)			\
 		*(__vermagic)		/* Kernel version magic */	\
 		*(__markers_strings)	/* Markers: strings */		\
 		*(__tracepoints_strings)/* Tracepoints: strings */	\
@@ -501,7 +513,7 @@
 	.bss : AT(ADDR(.bss) - LOAD_OFFSET) {				\
 		*(.bss..page_aligned)					\
 		*(.dynbss)						\
-		*(.bss)							\
+		*(.bss .bss.[A-Za-z0-9_$^]*)				\
 		*(COMMON)						\
 	}
 

--Boundary-00=_1exQMv9z7xuz/lL
Content-Type: text/x-diff;
  charset="us-ascii";
  name="linux-2.6.35-rc4-fs.fix-ko-module-linker-script.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="linux-2.6.35-rc4-fs.fix-ko-module-linker-script.patch"

--- linux-2.6.35-rc4/scripts/module-common.lds
+++ linux-2.6.35-rc4.new/scripts/module-common.lds
@@ -3,6 +3,29 @@
  * Archs are free to supply their own linker scripts.  ld will
  * combine them automatically.
  */
+
+/* .data.foo are generated by gcc itself with -fdata-sections,
+ * whereas double-dot sections (like .data..percpu) are generated
+ * by kernel's magic macros.
+ *
+ * Since this script does not specify what to do with double-dot sections,
+ * ld -r will coalesce all .data..foo input sections into one .data..foo
+ * output section, all .data..bar input sections into one .data..bar
+ * output section and so on. This is exactly what we want.
+ *
+ * Same goes for .text, .bss and .rodata. In case of .rodata, various
+ * .rodata.foo sections are generated by gcc even without -fdata-sections
+ */
+
 SECTIONS {
+
+	/* Coalesce sections produced by gcc -ffunction-sections */
+	.text   0 : AT(0) { *(.text .text.[A-Za-z0-9_$^]*) }
+
+	/* Coalesce sections produced by gcc -fdata-sections */
+	.rodata 0 : AT(0) { *(.rodata .rodata.[A-Za-z0-9_$^]*) }
+	.data   0 : AT(0) { *(.data .data.[A-Za-z0-9_$^]*) }
+	.bss    0 : AT(0) { *(.bss .bss.[A-Za-z0-9_$^]*) }
+
 	/DISCARD/ : { *(.discard) }
 }

--Boundary-00=_1exQMv9z7xuz/lL
Content-Type: text/x-diff;
  charset="us-ascii";
  name="linux-2.6.35-rc4-fsgs.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="linux-2.6.35-rc4-fsgs.patch"

--- linux-2.6.35-rc4.fs/Makefile
+++ linux-2.6.35-rc4-fsgs.obj/Makefile
@@ -610,6 +610,8 @@
 LDFLAGS_vmlinux	+= $(call ld-option, -X,)
 endif
 
+LDFLAGS_vmlinux += --gc-sections
+
 # Default kernel image to build when no specific target is given.
 # KBUILD_IMAGE may be overruled on the command line or
 # set in the environment
@@ -705,7 +707,7 @@
 # Rule to link vmlinux - also used during CONFIG_KALLSYMS
 # May be overridden by arch/$(ARCH)/Makefile
 quiet_cmd_vmlinux__ ?= LD      $@
-      cmd_vmlinux__ ?= $(LD) $(LDFLAGS) $(LDFLAGS_vmlinux) -o $@ \
+      cmd_vmlinux__ ?= $(LD) $(LDFLAGS) $(LDFLAGS_vmlinux) -o $@ -Map $@.ldmap \
       -T $(vmlinux-lds) $(vmlinux-init)                          \
       --start-group $(vmlinux-main) --end-group                  \
       $(filter-out $(vmlinux-lds) $(vmlinux-init) $(vmlinux-main) vmlinux.o FORCE ,$^)
--- linux-2.6.35-rc4.fs/arch/arm/kernel/vmlinux.lds.S
+++ linux-2.6.35-rc4-fsgs.obj/arch/arm/kernel/vmlinux.lds.S
@@ -157,7 +157,7 @@
 		. = ALIGN(32);
 		__start___ex_table = .;
 #ifdef CONFIG_MMU
-		*(__ex_table)
+		KEEP(*(__ex_table))
 #endif
 		__stop___ex_table = .;
 
--- linux-2.6.35-rc4.fs/arch/blackfin/kernel/vmlinux.lds.S
+++ linux-2.6.35-rc4-fsgs.obj/arch/blackfin/kernel/vmlinux.lds.S
@@ -51,7 +51,7 @@
 
 		. = ALIGN(16);
 		___start___ex_table = .;
-		*(__ex_table)
+		KEEP(*(__ex_table))
 		___stop___ex_table = .;
 
 		__etext = .;
--- linux-2.6.35-rc4.fs/arch/cris/boot/rescue/rescue_v32.lds
+++ linux-2.6.35-rc4-fsgs.obj/arch/cris/boot/rescue/rescue_v32.lds
@@ -36,7 +36,7 @@
 	/* Get rid of stuff from EXPORT_SYMBOL(foo). */
 	/DISCARD/ :
 	{
-	        *(__ksymtab_strings)
-	        *(__ksymtab)
+		KEEP(*(__ksymtab_strings))
+		*(__ksymtab)
 	}
 }
--- linux-2.6.35-rc4.fs/arch/cris/kernel/vmlinux.lds.S
+++ linux-2.6.35-rc4-fsgs.obj/arch/cris/kernel/vmlinux.lds.S
@@ -72,7 +72,7 @@
 	.init.setup : { INIT_SETUP(16) }
 #ifdef CONFIG_ETRAX_ARCH_V32
 	__start___param = .;
-	__param : { *(__param) }
+	__param : { KEEP(*(__param)) }
 	__stop___param = .;
 #endif
 	.initcall.init : {
@@ -88,7 +88,7 @@
 #ifdef CONFIG_BLK_DEV_INITRD
 	.init.ramfs : {
 		__initramfs_start = .;
-		*(.init.ramfs)
+		KEEP(*(.init.ramfs))
 		__initramfs_end = .;
 	}
 #endif
--- linux-2.6.35-rc4.fs/arch/h8300/kernel/vmlinux.lds.S
+++ linux-2.6.35-rc4-fsgs.obj/arch/h8300/kernel/vmlinux.lds.S
@@ -112,7 +112,7 @@
 	. = ALIGN(0x4) ;
 	INIT_SETUP(0x4)
 	___setup_start = .;
-		*(.init.setup)
+		KEEP(*(.init.setup))
 	. = ALIGN(0x4) ;
 	___setup_end = .;
 	INIT_CALLS
--- linux-2.6.35-rc4.fs/arch/m68knommu/kernel/vmlinux.lds.S
+++ linux-2.6.35-rc4-fsgs.obj/arch/m68knommu/kernel/vmlinux.lds.S
@@ -72,7 +72,7 @@
 
 		. = ALIGN(16);          /* Exception table              */
 		__start___ex_table = .;
-		*(__ex_table)
+		KEEP(*(__ex_table))
 		__stop___ex_table = .;
 
 		*(.rodata .rodata.*)
@@ -129,16 +129,16 @@
 
 		/* Kernel symbol table: GPL-future symbols */
 		__start___kcrctab_gpl_future = .;
-		*(__kcrctab_gpl_future)
+		KEEP(*(__kcrctab_gpl_future))
 		__stop___kcrctab_gpl_future = .;
 
 		/* Kernel symbol table: strings */
-		*(__ksymtab_strings)
+		KEEP(*(__ksymtab_strings))
 
 		/* Built-in module parameters */
 		. = ALIGN(4) ;
 		__start___param = .;
-		*(__param)
+		KEEP(*(__param))
 		__stop___param = .;
 
 		. = ALIGN(4) ;
--- linux-2.6.35-rc4.fs/arch/microblaze/kernel/vmlinux.lds.S
+++ linux-2.6.35-rc4-fsgs.obj/arch/microblaze/kernel/vmlinux.lds.S
@@ -122,7 +122,7 @@
 
 	.init.ramfs ALIGN(4096) : AT(ADDR(.init.ramfs) - LOAD_OFFSET) {
 		__initramfs_start = .;
-		*(.init.ramfs)
+		KEEP(*(.init.ramfs))
 		__initramfs_end = .;
 		. = ALIGN(4);
 		LONG(0);
--- linux-2.6.35-rc4.fs/arch/mn10300/kernel/vmlinux.lds.S
+++ linux-2.6.35-rc4-fsgs.obj/arch/mn10300/kernel/vmlinux.lds.S
@@ -51,7 +51,7 @@
   . = ALIGN(PAGE_SIZE);
   .smp_locks : AT(ADDR(.smp_locks) - LOAD_OFFSET) {
   	__smp_locks = .;
-	*(.smp_locks)
+	KEEP(*(.smp_locks))
 	__smp_locks_end = .;
   }
 
@@ -62,9 +62,9 @@
   INIT_DATA_SECTION(16)
   . = ALIGN(4);
   __alt_instructions = .;
-  .altinstructions : { *(.altinstructions) }
+  .altinstructions : { KEEP(*(.altinstructions)) }
   __alt_instructions_end = .;
- .altinstr_replacement : { *(.altinstr_replacement) }
+ .altinstr_replacement : { KEEP(*(.altinstr_replacement)) }
   /* .exit.text is discard at runtime, not link time, to deal with references
      from .altinstructions and .eh_frame */
 	.exit.text : { EXIT_TEXT; }
--- linux-2.6.35-rc4.fs/arch/um/include/asm/common.lds.S
+++ linux-2.6.35-rc4-fsgs.obj/arch/um/include/asm/common.lds.S
@@ -76,10 +76,10 @@
   . = ALIGN(4);
   .altinstructions : {
 	__alt_instructions = .;
-	*(.altinstructions)
+	KEEP(*(.altinstructions))
 	__alt_instructions_end = .;
   }
-  .altinstr_replacement : { *(.altinstr_replacement) }
+  .altinstr_replacement : { KEEP(*(.altinstr_replacement)) }
   /* .exit.text is discard at runtime, not link time, to deal with references
      from .altinstructions and .eh_frame */
   .exit.text : { *(.exit.text) }
--- linux-2.6.35-rc4.fs/arch/x86/kernel/vmlinux.lds.S
+++ linux-2.6.35-rc4-fsgs.obj/arch/x86/kernel/vmlinux.lds.S
@@ -162,46 +162,46 @@
 
 	. = VSYSCALL_ADDR;
 	.vsyscall_0 : AT(VLOAD(.vsyscall_0)) {
-		*(.vsyscall_0)
+		KEEP(*(.vsyscall_0))
 	} :user
 
 	. = ALIGN(L1_CACHE_BYTES);
 	.vsyscall_fn : AT(VLOAD(.vsyscall_fn)) {
-		*(.vsyscall_fn)
+		KEEP(*(.vsyscall_fn))
 	}
 
 	. = ALIGN(L1_CACHE_BYTES);
 	.vsyscall_gtod_data : AT(VLOAD(.vsyscall_gtod_data)) {
-		*(.vsyscall_gtod_data)
+		KEEP(*(.vsyscall_gtod_data))
 	}
 
 	vsyscall_gtod_data = VVIRT(.vsyscall_gtod_data);
 	.vsyscall_clock : AT(VLOAD(.vsyscall_clock)) {
-		*(.vsyscall_clock)
+		KEEP(*(.vsyscall_clock))
 	}
 	vsyscall_clock = VVIRT(.vsyscall_clock);
 
 
 	.vsyscall_1 ADDR(.vsyscall_0) + 1024: AT(VLOAD(.vsyscall_1)) {
-		*(.vsyscall_1)
+		KEEP(*(.vsyscall_1))
 	}
 	.vsyscall_2 ADDR(.vsyscall_0) + 2048: AT(VLOAD(.vsyscall_2)) {
-		*(.vsyscall_2)
+		KEEP(*(.vsyscall_2))
 	}
 
 	.vgetcpu_mode : AT(VLOAD(.vgetcpu_mode)) {
-		*(.vgetcpu_mode)
+		KEEP(*(.vgetcpu_mode))
 	}
 	vgetcpu_mode = VVIRT(.vgetcpu_mode);
 
 	. = ALIGN(L1_CACHE_BYTES);
 	.jiffies : AT(VLOAD(.jiffies)) {
-		*(.jiffies)
+		KEEP(*(.jiffies))
 	}
 	jiffies = VVIRT(.jiffies);
 
 	.vsyscall_3 ADDR(.vsyscall_0) + 3072: AT(VLOAD(.vsyscall_3)) {
-		*(.vsyscall_3)
+		KEEP(*(.vsyscall_3))
 	}
 
 	. = __vsyscall_0 + PAGE_SIZE;
@@ -252,12 +252,12 @@
 	. = ALIGN(8);
 	.altinstructions : AT(ADDR(.altinstructions) - LOAD_OFFSET) {
 		__alt_instructions = .;
-		*(.altinstructions)
+		KEEP(*(.altinstructions))
 		__alt_instructions_end = .;
 	}
 
 	.altinstr_replacement : AT(ADDR(.altinstr_replacement) - LOAD_OFFSET) {
-		*(.altinstr_replacement)
+		KEEP(*(.altinstr_replacement))
 	}
 
 	/*
@@ -290,7 +290,7 @@
 	. = ALIGN(PAGE_SIZE);
 	.smp_locks : AT(ADDR(.smp_locks) - LOAD_OFFSET) {
 		__smp_locks = .;
-		*(.smp_locks)
+		KEEP(*(.smp_locks))
 		. = ALIGN(PAGE_SIZE);
 		__smp_locks_end = .;
 	}
--- linux-2.6.35-rc4.fs/arch/x86/vdso/vdso-layout.lds.S
+++ linux-2.6.35-rc4-fsgs.obj/arch/x86/vdso/vdso-layout.lds.S
@@ -34,8 +34,8 @@
 	      *(.gnu.linkonce.b.*)
 	}
 
-	.altinstructions	: { *(.altinstructions) }
-	.altinstr_replacement	: { *(.altinstr_replacement) }
+	.altinstructions	: { KEEP(*(.altinstructions)) }
+	.altinstr_replacement	: { KEEP(*(.altinstr_replacement)) }
 
 	/*
 	 * Align the actual code well away from the non-instruction data.
--- linux-2.6.35-rc4.fs/include/asm-generic/vmlinux.lds.h
+++ linux-2.6.35-rc4-fsgs.obj/include/asm-generic/vmlinux.lds.h
@@ -229,25 +229,25 @@
 	/* PCI quirks */						\
 	.pci_fixup        : AT(ADDR(.pci_fixup) - LOAD_OFFSET) {	\
 		VMLINUX_SYMBOL(__start_pci_fixups_early) = .;		\
-		*(.pci_fixup_early)					\
+		KEEP(*(.pci_fixup_early))				\
 		VMLINUX_SYMBOL(__end_pci_fixups_early) = .;		\
 		VMLINUX_SYMBOL(__start_pci_fixups_header) = .;		\
-		*(.pci_fixup_header)					\
+		KEEP(*(.pci_fixup_header))				\
 		VMLINUX_SYMBOL(__end_pci_fixups_header) = .;		\
 		VMLINUX_SYMBOL(__start_pci_fixups_final) = .;		\
-		*(.pci_fixup_final)					\
+		KEEP(*(.pci_fixup_final))				\
 		VMLINUX_SYMBOL(__end_pci_fixups_final) = .;		\
 		VMLINUX_SYMBOL(__start_pci_fixups_enable) = .;		\
-		*(.pci_fixup_enable)					\
+		KEEP(*(.pci_fixup_enable))				\
 		VMLINUX_SYMBOL(__end_pci_fixups_enable) = .;		\
 		VMLINUX_SYMBOL(__start_pci_fixups_resume) = .;		\
-		*(.pci_fixup_resume)					\
+		KEEP(*(.pci_fixup_resume))				\
 		VMLINUX_SYMBOL(__end_pci_fixups_resume) = .;		\
 		VMLINUX_SYMBOL(__start_pci_fixups_resume_early) = .;	\
-		*(.pci_fixup_resume_early)				\
+		KEEP(*(.pci_fixup_resume_early))			\
 		VMLINUX_SYMBOL(__end_pci_fixups_resume_early) = .;	\
 		VMLINUX_SYMBOL(__start_pci_fixups_suspend) = .;		\
-		*(.pci_fixup_suspend)					\
+		KEEP(*(.pci_fixup_suspend))				\
 		VMLINUX_SYMBOL(__end_pci_fixups_suspend) = .;		\
 	}								\
 									\
@@ -270,76 +270,76 @@
 	/* Kernel symbol table: Normal symbols */			\
 	__ksymtab         : AT(ADDR(__ksymtab) - LOAD_OFFSET) {		\
 		VMLINUX_SYMBOL(__start___ksymtab) = .;			\
-		*(__ksymtab)						\
+		KEEP(*(__ksymtab))					\
 		VMLINUX_SYMBOL(__stop___ksymtab) = .;			\
 	}								\
 									\
 	/* Kernel symbol table: GPL-only symbols */			\
 	__ksymtab_gpl     : AT(ADDR(__ksymtab_gpl) - LOAD_OFFSET) {	\
 		VMLINUX_SYMBOL(__start___ksymtab_gpl) = .;		\
-		*(__ksymtab_gpl)					\
+		KEEP(*(__ksymtab_gpl))					\
 		VMLINUX_SYMBOL(__stop___ksymtab_gpl) = .;		\
 	}								\
 									\
 	/* Kernel symbol table: Normal unused symbols */		\
 	__ksymtab_unused  : AT(ADDR(__ksymtab_unused) - LOAD_OFFSET) {	\
 		VMLINUX_SYMBOL(__start___ksymtab_unused) = .;		\
-		*(__ksymtab_unused)					\
+		KEEP(*(__ksymtab_unused))				\
 		VMLINUX_SYMBOL(__stop___ksymtab_unused) = .;		\
 	}								\
 									\
 	/* Kernel symbol table: GPL-only unused symbols */		\
 	__ksymtab_unused_gpl : AT(ADDR(__ksymtab_unused_gpl) - LOAD_OFFSET) { \
 		VMLINUX_SYMBOL(__start___ksymtab_unused_gpl) = .;	\
-		*(__ksymtab_unused_gpl)					\
+		KEEP(*(__ksymtab_unused_gpl))				\
 		VMLINUX_SYMBOL(__stop___ksymtab_unused_gpl) = .;	\
 	}								\
 									\
 	/* Kernel symbol table: GPL-future-only symbols */		\
 	__ksymtab_gpl_future : AT(ADDR(__ksymtab_gpl_future) - LOAD_OFFSET) { \
 		VMLINUX_SYMBOL(__start___ksymtab_gpl_future) = .;	\
-		*(__ksymtab_gpl_future)					\
+		KEEP(*(__ksymtab_gpl_future))				\
 		VMLINUX_SYMBOL(__stop___ksymtab_gpl_future) = .;	\
 	}								\
 									\
 	/* Kernel symbol table: Normal symbols */			\
 	__kcrctab         : AT(ADDR(__kcrctab) - LOAD_OFFSET) {		\
 		VMLINUX_SYMBOL(__start___kcrctab) = .;			\
-		*(__kcrctab)						\
+		KEEP(*(__kcrctab))					\
 		VMLINUX_SYMBOL(__stop___kcrctab) = .;			\
 	}								\
 									\
 	/* Kernel symbol table: GPL-only symbols */			\
 	__kcrctab_gpl     : AT(ADDR(__kcrctab_gpl) - LOAD_OFFSET) {	\
 		VMLINUX_SYMBOL(__start___kcrctab_gpl) = .;		\
-		*(__kcrctab_gpl)					\
+		KEEP(*(__kcrctab_gpl))					\
 		VMLINUX_SYMBOL(__stop___kcrctab_gpl) = .;		\
 	}								\
 									\
 	/* Kernel symbol table: Normal unused symbols */		\
 	__kcrctab_unused  : AT(ADDR(__kcrctab_unused) - LOAD_OFFSET) {	\
 		VMLINUX_SYMBOL(__start___kcrctab_unused) = .;		\
-		*(__kcrctab_unused)					\
+		KEEP(*(__kcrctab_unused))				\
 		VMLINUX_SYMBOL(__stop___kcrctab_unused) = .;		\
 	}								\
 									\
 	/* Kernel symbol table: GPL-only unused symbols */		\
 	__kcrctab_unused_gpl : AT(ADDR(__kcrctab_unused_gpl) - LOAD_OFFSET) { \
 		VMLINUX_SYMBOL(__start___kcrctab_unused_gpl) = .;	\
-		*(__kcrctab_unused_gpl)					\
+		KEEP(*(__kcrctab_unused_gpl))				\
 		VMLINUX_SYMBOL(__stop___kcrctab_unused_gpl) = .;	\
 	}								\
 									\
 	/* Kernel symbol table: GPL-future-only symbols */		\
 	__kcrctab_gpl_future : AT(ADDR(__kcrctab_gpl_future) - LOAD_OFFSET) { \
 		VMLINUX_SYMBOL(__start___kcrctab_gpl_future) = .;	\
-		*(__kcrctab_gpl_future)					\
+		KEEP(*(__kcrctab_gpl_future))				\
 		VMLINUX_SYMBOL(__stop___kcrctab_gpl_future) = .;	\
 	}								\
 									\
 	/* Kernel symbol table: strings */				\
         __ksymtab_strings : AT(ADDR(__ksymtab_strings) - LOAD_OFFSET) {	\
-		*(__ksymtab_strings)					\
+		KEEP(*(__ksymtab_strings))				\
 	}								\
 									\
 	/* __*init sections */						\
@@ -356,7 +356,7 @@
 	/* Built-in module parameters. */				\
 	__param : AT(ADDR(__param) - LOAD_OFFSET) {			\
 		VMLINUX_SYMBOL(__start___param) = .;			\
-		*(__param)						\
+		KEEP(*(__param))					\
 		VMLINUX_SYMBOL(__stop___param) = .;			\
 		. = ALIGN((align));					\
 		VMLINUX_SYMBOL(__end_rodata) = .;			\
@@ -371,7 +371,7 @@
 #define SECURITY_INIT							\
 	.security_initcall.init : AT(ADDR(.security_initcall.init) - LOAD_OFFSET) { \
 		VMLINUX_SYMBOL(__security_initcall_start) = .;		\
-		*(.security_initcall.init) 				\
+		KEEP(*(.security_initcall.init))			\
 		VMLINUX_SYMBOL(__security_initcall_end) = .;		\
 	}
 
@@ -424,7 +424,7 @@
 #endif
 
 /* Section used for early init (in .S files) */
-#define HEAD_TEXT  *(.head.text)
+#define HEAD_TEXT  KEEP(*(.head.text))
 
 #define HEAD_TEXT_SECTION							\
 	.head.text : AT(ADDR(.head.text) - LOAD_OFFSET) {		\
@@ -438,7 +438,7 @@
 	. = ALIGN(align);						\
 	__ex_table : AT(ADDR(__ex_table) - LOAD_OFFSET) {		\
 		VMLINUX_SYMBOL(__start___ex_table) = .;			\
-		*(__ex_table)						\
+		KEEP(*(__ex_table))					\
 		VMLINUX_SYMBOL(__stop___ex_table) = .;			\
 	}
 
@@ -591,29 +591,29 @@
 #define INIT_SETUP(initsetup_align)					\
 		. = ALIGN(initsetup_align);				\
 		VMLINUX_SYMBOL(__setup_start) = .;			\
-		*(.init.setup)						\
+		KEEP(*(.init.setup))					\
 		VMLINUX_SYMBOL(__setup_end) = .;
 
 #define INITCALLS							\
-	*(.initcallearly.init)						\
+	KEEP(*(.initcallearly.init))					\
 	VMLINUX_SYMBOL(__early_initcall_end) = .;			\
-  	*(.initcall0.init)						\
-  	*(.initcall0s.init)						\
-  	*(.initcall1.init)						\
-  	*(.initcall1s.init)						\
-  	*(.initcall2.init)						\
-  	*(.initcall2s.init)						\
-  	*(.initcall3.init)						\
-  	*(.initcall3s.init)						\
-  	*(.initcall4.init)						\
-  	*(.initcall4s.init)						\
-  	*(.initcall5.init)						\
-  	*(.initcall5s.init)						\
-	*(.initcallrootfs.init)						\
-  	*(.initcall6.init)						\
-  	*(.initcall6s.init)						\
-  	*(.initcall7.init)						\
-  	*(.initcall7s.init)
+	KEEP(*(.initcall0.init))					\
+	KEEP(*(.initcall0s.init))					\
+	KEEP(*(.initcall1.init))					\
+	KEEP(*(.initcall1s.init))					\
+	KEEP(*(.initcall2.init))					\
+	KEEP(*(.initcall2s.init))					\
+	KEEP(*(.initcall3.init))					\
+	KEEP(*(.initcall3s.init))					\
+	KEEP(*(.initcall4.init))					\
+	KEEP(*(.initcall4s.init))					\
+	KEEP(*(.initcall5.init))					\
+	KEEP(*(.initcall5s.init))					\
+	KEEP(*(.initcallrootfs.init))					\
+	KEEP(*(.initcall6.init))					\
+	KEEP(*(.initcall6s.init))					\
+	KEEP(*(.initcall7.init))					\
+	KEEP(*(.initcall7s.init))
 
 #define INIT_CALLS							\
 		VMLINUX_SYMBOL(__initcall_start) = .;			\
@@ -622,19 +622,19 @@
 
 #define CON_INITCALL							\
 		VMLINUX_SYMBOL(__con_initcall_start) = .;		\
-		*(.con_initcall.init)					\
+		KEEP(*(.con_initcall.init))				\
 		VMLINUX_SYMBOL(__con_initcall_end) = .;
 
 #define SECURITY_INITCALL						\
 		VMLINUX_SYMBOL(__security_initcall_start) = .;		\
-		*(.security_initcall.init)				\
+		KEEP(*(.security_initcall.init))			\
 		VMLINUX_SYMBOL(__security_initcall_end) = .;
 
 #ifdef CONFIG_BLK_DEV_INITRD
 #define INIT_RAM_FS							\
 	. = ALIGN(PAGE_SIZE);						\
 	VMLINUX_SYMBOL(__initramfs_start) = .;				\
-	*(.init.ramfs)							\
+	KEEP(*(.init.ramfs))						\
 	VMLINUX_SYMBOL(__initramfs_end) = .;
 #else
 #define INIT_RAM_FS

--Boundary-00=_1exQMv9z7xuz/lL--
