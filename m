Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964843Ab2EJXnv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 19:43:51 -0400
Received: from mx1.redhat.com ([209.132.183.28]:46699 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933007Ab2EJXns (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 19:43:48 -0400
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 25/29] MODSIGN: Check the ELF container [ver #4]
To: rusty@rustcorp.com.au
Cc: kyle@mcmartin.ca, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org, keyrings@linux-nfs.org,
        David Howells <dhowells@redhat.com>
Date: Fri, 11 May 2012 00:43:38 +0100
Message-ID: <20120510234338.4137.73678.stgit@warthog.procyon.org.uk>
In-Reply-To: <20120510233901.4137.19023.stgit@warthog.procyon.org.uk>
References: <20120510233901.4137.19023.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Check the ELF container of the kernel module to prevent the kernel from
crashing or getting corrupted whilst trying to use it and locate the module
signature note if present.

We try to check as little as possible.  We check the metadata that the
signature checker actually has to use, and leave anything that it doesn't
actually need to the signature to catch.

The stuff we need to check is:

 (1) The locations and offsets in the ELF header of important parts like the
     section table.

 (2) The section table.  Note that we only check sh_info for section types that
     we're actually interested in (string, symbol and relocation tables).  We
     also check that alignments are what we expect for those tables.

 (3) That non-empty string tables have the required NUL at the end so that we
     can be sure that all strings therein are NUL-terminated.  We don't bother
     checking for the required NUL at the beginning as it shouldn't cause a
     problem to us.

 (4) The name offset and section index in each symbol.  We could defer this to
     when we deal with the relocation tables so that we only check symbols that
     are used by relocations - but we would then end up checking some symbols
     multiple times.

 (5) The module signature note section and the first note in it if present.

 (6) That relocations applied to an allocatable section only refer to
     symbols in allocatable sections and absolute symbols (done in the module
     signing code rather than here).

Note that these checks survive "strip -x", "strip -g" and "eu-strip" being
applied to a module and detect if the module was given to "strip" or "strip -s"
and report an error.

We can skip some direct checks that turn out unnecessary or redundant:

 (1) That sh_link has a greater than 0 value for symbol tables and relocation
     tables.  These require the index of a string table and a symbol table
     respectively - and since we have already checked section 0 is of SHT_NULL
     type, checking the symbol type renders the sh_link > 0 check redundant.

 (2) That a non-empty string table begins with a NUL.  Since we check the
     string table ends with a NUL, any string in there will be NUL-terminated
     and shouldn't cause us to transgress beyond the bounds of the string table
     when using strlen().

 (3) That strings in a string table actually make sense.  We don't care, so
     long as it is NUL terminated.  Any string that refers to an undefined
     symbol is added to the crypto digest and will be checked that way.
     Strings that we directly look for (such as ".modinfo") will be validated
     by that.

 (4) That sections don't overlap.  We don't actually care if sections overlap
     in the file, provided we don't see bad metadata.  If the sections holding
     the allocatable content overlap, then the signature check is likely to
     fail.

 (5) That symbol values and relocation offsets and addends make sense.  We just
     add this data to the digest if it pertains to an allocatable section.

 (6) That allocatable note sections, other than the signature note, make sense.
     The contents of these get added to the digest in their entirety, so we
     don't need to check them manually.

If bad ELF is detected, ELIBBAD is indicated.

Note!  The "noinline" attribute on the module_verify_elf() function results in
somewhat smaller code.  Similarly, having separate loops to check basic section
parameters and to check type-specific features of sections results in smaller
code, presumably because some local variables can be discarded.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 kernel/module-verify.c |  226 ++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 226 insertions(+), 0 deletions(-)


diff --git a/kernel/module-verify.c b/kernel/module-verify.c
index b1c1d4c..5711aeb 100644
--- a/kernel/module-verify.c
+++ b/kernel/module-verify.c
@@ -50,6 +50,224 @@ static const char modsign_note_name[] = ELFNOTE_NAME(MODSIGN_NOTE_NAME);
 static const char modsign_note_section[] = ELFNOTE_SECTION(MODSIGN_NOTE_NAME);
 
 /*
+ * Verify the minimum amount of ELF structure of a module needed to check the
+ * module's signature without bad ELF crashing the kernel.
+ */
+static noinline int module_verify_elf(struct module_verify_data *mvdata)
+{
+	const struct elf_note *note;
+	const Elf_Ehdr *hdr = mvdata->hdr;
+	const Elf_Shdr *section, *secstop;
+	const Elf_Sym *symbols, *symbol, *symstop;
+	const char *strtab;
+	size_t size, secsize, secstrsize, strsize, notesize, notemetasize;
+	unsigned line;
+
+	size = mvdata->size;
+
+#define elfcheck(X)							\
+do { if (unlikely(!(X))) { line = __LINE__; goto elfcheck_error; } } while(0)
+
+#define seccheck(X)							\
+do { if (unlikely(!(X))) { line = __LINE__; goto seccheck_error; } } while(0)
+
+#define symcheck(X)							\
+do { if (unlikely(!(X))) { line = __LINE__; goto symcheck_error; } } while(0)
+
+	/* Validate the ELF header */
+	elfcheck(size > sizeof(Elf_Ehdr));
+	elfcheck(hdr->e_ehsize < size);
+
+	elfcheck(hdr->e_shnum < SHN_LORESERVE);
+	elfcheck(hdr->e_shstrndx < hdr->e_shnum);
+	elfcheck(hdr->e_shentsize == sizeof(Elf_Shdr));
+	elfcheck(hdr->e_shoff < size);
+	elfcheck(hdr->e_shoff >= hdr->e_ehsize);
+	elfcheck(hdr->e_shoff % sizeof(long) == 0);
+	elfcheck(hdr->e_shnum * sizeof(Elf_Shdr) <= size - hdr->e_shoff);
+
+	/* Validate the section table contents */
+	mvdata->nsects = hdr->e_shnum;
+	mvdata->sections = mvdata->buffer + hdr->e_shoff;
+	secstop = mvdata->sections + mvdata->nsects;
+
+	/* Section 0 is special, usually indicating an undefined symbol */
+	seccheck(mvdata->sections[SHN_UNDEF].sh_type == SHT_NULL);
+
+	/* We also want access to the section name table */
+	seccheck(mvdata->sections[hdr->e_shstrndx].sh_type == SHT_STRTAB);
+	secstrsize = mvdata->sections[hdr->e_shstrndx].sh_size;
+
+	for (section = mvdata->sections + 1; section < secstop; section++) {
+		seccheck(section->sh_name < secstrsize);
+		seccheck(section->sh_link < hdr->e_shnum);
+
+		/* Section file offsets must reside within the file, though
+		 * they don't have to actually consume file space (.bss for
+		 * example).
+		 */
+		seccheck(section->sh_offset >= hdr->e_ehsize);
+		seccheck((section->sh_offset & (section->sh_addralign - 1)) == 0);
+		seccheck(section->sh_offset <= size);
+		if (section->sh_type != SHT_NOBITS)
+			seccheck(section->sh_size <= size - section->sh_offset);
+
+		/* Some types of section should contain arrays of fixed-length
+		 * records of a predetermined size and mustn't contain partial
+		 * records.  Also, records we're going to access directly must
+		 * have appropriate alignment that we don't get a misalignment
+		 * exception.
+		 */
+		if (section->sh_entsize > 1)
+			seccheck(section->sh_size % section->sh_entsize == 0);
+
+		switch (section->sh_type) {
+		case SHT_SYMTAB:
+			seccheck(section->sh_entsize == sizeof(Elf_Sym));
+			seccheck(section->sh_addralign % sizeof(long) == 0);
+			break;
+		case SHT_REL:
+#ifndef MODULE_HAS_ELF_RELA_ONLY
+			seccheck(section->sh_entsize == sizeof(Elf_Rel));
+			seccheck(section->sh_addralign % sizeof(long) == 0);
+			break;
+#else
+			seccheck(false);
+			break;
+#endif
+		case SHT_RELA:
+#ifndef MODULE_HAS_ELF_REL_ONLY
+			seccheck(section->sh_entsize == sizeof(Elf_Rela));
+			seccheck(section->sh_addralign % sizeof(long) == 0);
+			break;
+#else
+			seccheck(false);
+			break;
+#endif
+		case SHT_NOTE:
+			seccheck(section->sh_addralign % 4 == 0);
+			break;
+		case SHT_STRTAB:
+			/* We require all string tables to be non-empty.  If
+			 * not empty, a string table must end in a NUL (it
+			 * should also begin with a NUL, but it's not a problem
+			 * for us if it doesn't).
+			 */
+			seccheck(section->sh_size >= 2);
+			strtab = mvdata->buffer + section->sh_offset;
+			seccheck(strtab[section->sh_size - 1] == '\0');
+			break;
+		}
+	}
+
+	/* Check features specific to the type of each section.
+	 *
+	 * Note that having a separate loop here allows the compiler to discard
+	 * some local variables used in the above loop thus making the code
+	 * smaller.
+	 */
+	for (section = mvdata->sections + 1; section < secstop; section++) {
+		switch (section->sh_type) {
+		case SHT_SYMTAB:
+			/* Symbol tables nominate a string table. */
+			seccheck(mvdata->sections[section->sh_link].sh_type ==
+				 SHT_STRTAB);
+
+			/* Validate the symbols in the table.  The first symbol
+			 * (STN_UNDEF) is special.
+			 */
+			symbol = symbols = mvdata->buffer + section->sh_offset;
+			symstop = mvdata->buffer +
+				(section->sh_offset + section->sh_size);
+
+			symcheck(ELF_ST_TYPE(symbols[0].st_info) == STT_NOTYPE);
+			symcheck(symbol[0].st_shndx == SHN_UNDEF);
+
+			strsize = mvdata->sections[section->sh_link].sh_size;
+			for (symbol++; symbol < symstop; symbol++) {
+				symcheck(symbol->st_name < strsize);
+				symcheck(symbol->st_shndx < hdr->e_shnum ||
+					 symbol->st_shndx >= SHN_LORESERVE);
+			}
+			break;
+
+#ifndef MODULE_HAS_ELF_RELA_ONLY
+		case SHT_REL:
+#endif
+#ifndef MODULE_HAS_ELF_REL_ONLY
+		case SHT_RELA:
+#endif
+			/* Relocation tables nominate a symbol table and a
+			 * target section to which the relocations will be
+			 * applied.
+			 */
+			seccheck(mvdata->sections[section->sh_link].sh_type ==
+				 SHT_SYMTAB);
+			seccheck(section->sh_info > 0);
+			seccheck(section->sh_info < hdr->e_shnum);
+			break;
+		}
+	}
+
+	/* We can now use section name string table section as we checked its
+	 * bounds in the loop above.
+	 *
+	 * Each name is NUL-terminated, and the table as a whole should have a
+	 * NUL at either end as there to be at least one named section for the
+	 * module information.
+	 */
+	section = &mvdata->sections[hdr->e_shstrndx];
+	mvdata->secstrings = mvdata->buffer + section->sh_offset;
+
+	for (section = mvdata->sections + 1; section < secstop; section++) {
+		const char *name = mvdata->secstrings + section->sh_name;
+
+		switch (section->sh_type) {
+		case SHT_NOTE:
+			if (strcmp(name, modsign_note_section) != 0)
+				continue;
+
+			/* We've found a note purporting to contain a signature
+			 * so we should check the structure of that.
+			 */
+			notemetasize = sizeof(struct elf_note) +
+				roundup(sizeof(modsign_note_name), 4);
+
+			seccheck(mvdata->sig_index == 0);
+			seccheck(section->sh_size > notemetasize);
+			note = mvdata->buffer + section->sh_offset;
+			seccheck(note->n_type == MODSIGN_NOTE_TYPE);
+			seccheck(note->n_namesz == sizeof(modsign_note_name));
+
+			notesize = section->sh_size - notemetasize;
+			seccheck(note->n_descsz <= notesize);
+
+			seccheck(memcmp(note + 1, modsign_note_name,
+					note->n_namesz) == 0);
+
+			mvdata->sig_size = note->n_descsz;
+			mvdata->sig = (void *)note + notemetasize;
+			mvdata->sig_index = section - mvdata->sections;
+			break;
+		}
+	}
+
+	return 0;
+
+elfcheck_error:
+	_debug("Verify ELF error (check %u)\n", line);
+	return -ELIBBAD;
+seccheck_error:
+	_debug("Verify ELF error [sec %ld] (check %u)\n",
+	       (long)(section - mvdata->sections), line);
+	return -ELIBBAD;
+symcheck_error:
+	_debug("Verify ELF error [sym %ld] (check %u)\n",
+	       (long)(symbol - symbols), line);
+	return -ELIBBAD;
+}
+
+/*
  * Verify a module's integrity
  */
 int module_verify(const Elf_Ehdr *hdr, size_t size, bool *_gpgsig_ok)
@@ -61,6 +279,14 @@ int module_verify(const Elf_Ehdr *hdr, size_t size, bool *_gpgsig_ok)
 	mvdata.buffer = hdr;
 	mvdata.size = size;
 
+	/* Minimally check the ELF to make sure building the signature digest
+	 * won't crash the kernel.
+	 */
+	ret = module_verify_elf(&mvdata);
+	if (ret < 0)
+		goto out;
+
+	/* The ELF checker found the sig for us if it exists */
 	if (mvdata.sig_index <= 0) {
 		/* Deal with an unsigned module */
 		if (modsign_signedonly) {

