Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932113Ab0JNVB7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Oct 2010 17:01:59 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:35487 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756018Ab0JNVBi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Oct 2010 17:01:38 -0400
X-Authority-Analysis: v=1.1 cv=iGF3DqghDyT/uy4mV2LvOKNXCATMSjL+tOl9cucoGVk= c=1 sm=0 a=hU7gZzbIXHsA:10 a=bbbx4UPp9XUA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=20KFwNOVAAAA:8 a=SyI_GHdlAAAA:8 a=meVymXHHAAAA:8 a=FP58Ms26AAAA:8 a=rI5t-QbD1Pwc1OUgBrMA:9 a=joITOeZxDN50Nxs23KwA:7 a=-B1zgzJXOFFgPHdA8xb1bNHWdgQA:4 a=jEp0ucaQiEUA:10 a=UQxMgyrMzRwA:10 a=jeBq3FmKZ4MA:10 a=RNKDq65X0GBJeTg5:21 a=czXVWUSPv3XM7qeu:21 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Message-Id: <20101014210136.530500680@goodmis.org>
User-Agent: quilt/0.48-1
Date: Thu, 14 Oct 2010 17:00:17 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        John Reiser <jreiser@bitwagon.com>
Subject: [PATCH 3/3] ftrace: Remove duplicate code for 64 and 32 bit in recordmcount.c
References: <20101014210014.895157788@goodmis.org>
Content-Disposition: inline; filename=0003-ftrace-Remove-duplicate-code-for-64-and-32-bit-in-re.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

The elf reader for recordmcount.c had duplicate functions for both
32 bit and 64 bit elf handling. This was due to the need of using
the 32 and 64 bit elf structures.

This patch consolidates the two by using macros to define the 32
and 64 bit names in a recordmcount.h file, and then by just defining
a RECORD_MCOUNT_64 macro and including recordmcount.h twice we
create the funtions for both the 32 bit version as well as the
64 bit version using one code source.

Cc: John Reiser <jreiser@bitwagon.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 scripts/recordmcount.c |  548 +-----------------------------------------------
 scripts/recordmcount.h |  366 ++++++++++++++++++++++++++++++++
 2 files changed, 370 insertions(+), 544 deletions(-)
 create mode 100644 scripts/recordmcount.h

diff --git a/scripts/recordmcount.c b/scripts/recordmcount.c
index 34f32be..7f7f718 100644
--- a/scripts/recordmcount.c
+++ b/scripts/recordmcount.c
@@ -212,550 +212,10 @@ is_mcounted_section_name(char const *const txtname)
 		0 == strcmp(".text.unlikely", txtname);
 }
 
-/* Append the new shstrtab, Elf32_Shdr[], __mcount_loc and its relocations. */
-static void append32(Elf32_Ehdr *const ehdr,
-		     Elf32_Shdr *const shstr,
-		     uint32_t const *const mloc0,
-		     uint32_t const *const mlocp,
-		     Elf32_Rel const *const mrel0,
-		     Elf32_Rel const *const mrelp,
-		     unsigned int const rel_entsize,
-		     unsigned int const symsec_sh_link)
-{
-	/* Begin constructing output file */
-	Elf32_Shdr mcsec;
-	char const *mc_name = (sizeof(Elf32_Rela) == rel_entsize)
-		? ".rela__mcount_loc"
-		:  ".rel__mcount_loc";
-	unsigned const old_shnum = w2(ehdr->e_shnum);
-	uint32_t const old_shoff = w(ehdr->e_shoff);
-	uint32_t const old_shstr_sh_size   = w(shstr->sh_size);
-	uint32_t const old_shstr_sh_offset = w(shstr->sh_offset);
-	uint32_t t = 1 + strlen(mc_name) + w(shstr->sh_size);
-	uint32_t new_e_shoff;
-
-	shstr->sh_size = w(t);
-	shstr->sh_offset = w(sb.st_size);
-	t += sb.st_size;
-	t += (3u & -t);  /* 4-byte align */
-	new_e_shoff = t;
-
-	/* body for new shstrtab */
-	ulseek(fd_map, sb.st_size, SEEK_SET);
-	uwrite(fd_map, old_shstr_sh_offset + (void *)ehdr, old_shstr_sh_size);
-	uwrite(fd_map, mc_name, 1 + strlen(mc_name));
-
-	/* old(modified) Elf32_Shdr table, 4-byte aligned */
-	ulseek(fd_map, t, SEEK_SET);
-	t += sizeof(Elf32_Shdr) * old_shnum;
-	uwrite(fd_map, old_shoff + (void *)ehdr,
-	       sizeof(Elf32_Shdr) * old_shnum);
-
-	/* new sections __mcount_loc and .rel__mcount_loc */
-	t += 2*sizeof(mcsec);
-	mcsec.sh_name = w((sizeof(Elf32_Rela) == rel_entsize) + strlen(".rel")
-		+ old_shstr_sh_size);
-	mcsec.sh_type = w(SHT_PROGBITS);
-	mcsec.sh_flags = w(SHF_ALLOC);
-	mcsec.sh_addr = 0;
-	mcsec.sh_offset = w(t);
-	mcsec.sh_size = w((void *)mlocp - (void *)mloc0);
-	mcsec.sh_link = 0;
-	mcsec.sh_info = 0;
-	mcsec.sh_addralign = w(4);
-	mcsec.sh_entsize = w(4);
-	uwrite(fd_map, &mcsec, sizeof(mcsec));
-
-	mcsec.sh_name = w(old_shstr_sh_size);
-	mcsec.sh_type = (sizeof(Elf32_Rela) == rel_entsize)
-		? w(SHT_RELA)
-		: w(SHT_REL);
-	mcsec.sh_flags = 0;
-	mcsec.sh_addr = 0;
-	mcsec.sh_offset = w((void *)mlocp - (void *)mloc0 + t);
-	mcsec.sh_size   = w((void *)mrelp - (void *)mrel0);
-	mcsec.sh_link = w(symsec_sh_link);
-	mcsec.sh_info = w(old_shnum);
-	mcsec.sh_addralign = w(4);
-	mcsec.sh_entsize = w(rel_entsize);
-	uwrite(fd_map, &mcsec, sizeof(mcsec));
-
-	uwrite(fd_map, mloc0, (void *)mlocp - (void *)mloc0);
-	uwrite(fd_map, mrel0, (void *)mrelp - (void *)mrel0);
-
-	ehdr->e_shoff = w(new_e_shoff);
-	ehdr->e_shnum = w2(2 + w2(ehdr->e_shnum));  /* {.rel,}__mcount_loc */
-	ulseek(fd_map, 0, SEEK_SET);
-	uwrite(fd_map, ehdr, sizeof(*ehdr));
-}
-
-/*
- * append64 and append32 (and other analogous pairs) could be templated
- * using C++, but the complexity is high.  (For an example, look at p_elf.h
- * in the source for UPX, http://upx.sourceforge.net)  So: remember to make
- * the corresponding change in the routine for the other size.
- */
-static void append64(Elf64_Ehdr *const ehdr,
-		     Elf64_Shdr *const shstr,
-		     uint64_t const *const mloc0,
-		     uint64_t const *const mlocp,
-		     Elf64_Rel const *const mrel0,
-		     Elf64_Rel const *const mrelp,
-		     unsigned int const rel_entsize,
-		     unsigned int const symsec_sh_link)
-{
-	/* Begin constructing output file */
-	Elf64_Shdr mcsec;
-	char const *mc_name = (sizeof(Elf64_Rela) == rel_entsize)
-		? ".rela__mcount_loc"
-		:  ".rel__mcount_loc";
-	unsigned const old_shnum = w2(ehdr->e_shnum);
-	uint64_t const old_shoff = w8(ehdr->e_shoff);
-	uint64_t const old_shstr_sh_size   = w8(shstr->sh_size);
-	uint64_t const old_shstr_sh_offset = w8(shstr->sh_offset);
-	uint64_t t = 1 + strlen(mc_name) + w8(shstr->sh_size);
-	uint64_t new_e_shoff;
-
-	shstr->sh_size = w8(t);
-	shstr->sh_offset = w8(sb.st_size);
-	t += sb.st_size;
-	t += (7u & -t);  /* 8-byte align */
-	new_e_shoff = t;
-
-	/* body for new shstrtab */
-	ulseek(fd_map, sb.st_size, SEEK_SET);
-	uwrite(fd_map, old_shstr_sh_offset + (void *)ehdr, old_shstr_sh_size);
-	uwrite(fd_map, mc_name, 1 + strlen(mc_name));
-
-	/* old(modified) Elf64_Shdr table, 8-byte aligned */
-	ulseek(fd_map, t, SEEK_SET);
-	t += sizeof(Elf64_Shdr) * old_shnum;
-	uwrite(fd_map, old_shoff + (void *)ehdr,
-		sizeof(Elf64_Shdr) * old_shnum);
-
-	/* new sections __mcount_loc and .rel__mcount_loc */
-	t += 2*sizeof(mcsec);
-	mcsec.sh_name = w((sizeof(Elf64_Rela) == rel_entsize) + strlen(".rel")
-		+ old_shstr_sh_size);
-	mcsec.sh_type = w(SHT_PROGBITS);
-	mcsec.sh_flags = w8(SHF_ALLOC);
-	mcsec.sh_addr = 0;
-	mcsec.sh_offset = w8(t);
-	mcsec.sh_size = w8((void *)mlocp - (void *)mloc0);
-	mcsec.sh_link = 0;
-	mcsec.sh_info = 0;
-	mcsec.sh_addralign = w8(8);
-	mcsec.sh_entsize = w8(8);
-	uwrite(fd_map, &mcsec, sizeof(mcsec));
-
-	mcsec.sh_name = w(old_shstr_sh_size);
-	mcsec.sh_type = (sizeof(Elf64_Rela) == rel_entsize)
-		? w(SHT_RELA)
-		: w(SHT_REL);
-	mcsec.sh_flags = 0;
-	mcsec.sh_addr = 0;
-	mcsec.sh_offset = w8((void *)mlocp - (void *)mloc0 + t);
-	mcsec.sh_size   = w8((void *)mrelp - (void *)mrel0);
-	mcsec.sh_link = w(symsec_sh_link);
-	mcsec.sh_info = w(old_shnum);
-	mcsec.sh_addralign = w8(8);
-	mcsec.sh_entsize = w8(rel_entsize);
-	uwrite(fd_map, &mcsec, sizeof(mcsec));
-
-	uwrite(fd_map, mloc0, (void *)mlocp - (void *)mloc0);
-	uwrite(fd_map, mrel0, (void *)mrelp - (void *)mrel0);
-
-	ehdr->e_shoff = w8(new_e_shoff);
-	ehdr->e_shnum = w2(2 + w2(ehdr->e_shnum));  /* {.rel,}__mcount_loc */
-	ulseek(fd_map, 0, SEEK_SET);
-	uwrite(fd_map, ehdr, sizeof(*ehdr));
-}
-
-/*
- * Look at the relocations in order to find the calls to mcount.
- * Accumulate the section offsets that are found, and their relocation info,
- * onto the end of the existing arrays.
- */
-static uint32_t *sift32_rel_mcount(uint32_t *mlocp,
-				   unsigned const offbase,
-				   Elf32_Rel **const mrelpp,
-				   Elf32_Shdr const *const relhdr,
-				   Elf32_Ehdr const *const ehdr,
-				   unsigned const recsym,
-				   uint32_t const recval,
-				   unsigned const reltype)
-{
-	uint32_t *const mloc0 = mlocp;
-	Elf32_Rel *mrelp = *mrelpp;
-	Elf32_Shdr *const shdr0 = (Elf32_Shdr *)(w(ehdr->e_shoff)
-		+ (void *)ehdr);
-	unsigned const symsec_sh_link = w(relhdr->sh_link);
-	Elf32_Shdr const *const symsec = &shdr0[symsec_sh_link];
-	Elf32_Sym const *const sym0 = (Elf32_Sym const *)(w(symsec->sh_offset)
-		+ (void *)ehdr);
-
-	Elf32_Shdr const *const strsec = &shdr0[w(symsec->sh_link)];
-	char const *const str0 = (char const *)(w(strsec->sh_offset)
-		+ (void *)ehdr);
-
-	Elf32_Rel const *const rel0 = (Elf32_Rel const *)(w(relhdr->sh_offset)
-		+ (void *)ehdr);
-	unsigned rel_entsize = w(relhdr->sh_entsize);
-	unsigned const nrel = w(relhdr->sh_size) / rel_entsize;
-	Elf32_Rel const *relp = rel0;
-
-	unsigned mcountsym = 0;
-	unsigned t;
-
-	for (t = nrel; t; --t) {
-		if (!mcountsym) {
-			Elf32_Sym const *const symp =
-				&sym0[ELF32_R_SYM(w(relp->r_info))];
-
-			if (0 == strcmp((('_' == gpfx) ? "_mcount" : "mcount"),
-					&str0[w(symp->st_name)]))
-				mcountsym = ELF32_R_SYM(w(relp->r_info));
-		}
-		if (mcountsym == ELF32_R_SYM(w(relp->r_info))) {
-			uint32_t const addend = w(w(relp->r_offset) - recval);
-			mrelp->r_offset = w(offbase
-				+ ((void *)mlocp - (void *)mloc0));
-			mrelp->r_info = w(ELF32_R_INFO(recsym, reltype));
-			if (sizeof(Elf32_Rela) == rel_entsize) {
-				((Elf32_Rela *)mrelp)->r_addend = addend;
-				*mlocp++ = 0;
-			} else
-				*mlocp++ = addend;
-
-			mrelp = (Elf32_Rel *)(rel_entsize + (void *)mrelp);
-		}
-		relp = (Elf32_Rel const *)(rel_entsize + (void *)relp);
-	}
-	*mrelpp = mrelp;
-	return mlocp;
-}
-
-static uint64_t *sift64_rel_mcount(uint64_t *mlocp,
-				   unsigned const offbase,
-				   Elf64_Rel **const mrelpp,
-				   Elf64_Shdr const *const relhdr,
-				   Elf64_Ehdr const *const ehdr,
-				   unsigned const recsym,
-				   uint64_t const recval,
-				   unsigned const reltype)
-{
-	uint64_t *const mloc0 = mlocp;
-	Elf64_Rel *mrelp = *mrelpp;
-	Elf64_Shdr *const shdr0 = (Elf64_Shdr *)(w8(ehdr->e_shoff)
-		+ (void *)ehdr);
-	unsigned const symsec_sh_link = w(relhdr->sh_link);
-	Elf64_Shdr const *const symsec = &shdr0[symsec_sh_link];
-	Elf64_Sym const *const sym0 = (Elf64_Sym const *)(w8(symsec->sh_offset)
-		+ (void *)ehdr);
-
-	Elf64_Shdr const *const strsec = &shdr0[w(symsec->sh_link)];
-	char const *const str0 = (char const *)(w8(strsec->sh_offset)
-		+ (void *)ehdr);
-
-	Elf64_Rel const *const rel0 = (Elf64_Rel const *)(w8(relhdr->sh_offset)
-		+ (void *)ehdr);
-	unsigned rel_entsize = w8(relhdr->sh_entsize);
-	unsigned const nrel = w8(relhdr->sh_size) / rel_entsize;
-	Elf64_Rel const *relp = rel0;
-
-	unsigned mcountsym = 0;
-	unsigned t;
-
-	for (t = nrel; 0 != t; --t) {
-		if (!mcountsym) {
-			Elf64_Sym const *const symp =
-				&sym0[ELF64_R_SYM(w8(relp->r_info))];
-			char const *symname = &str0[w(symp->st_name)];
-
-			if ('.' == symname[0])
-				++symname;  /* ppc64 hack */
-			if (0 == strcmp((('_' == gpfx) ? "_mcount" : "mcount"),
-					symname))
-				mcountsym = ELF64_R_SYM(w8(relp->r_info));
-		}
-
-		if (mcountsym == ELF64_R_SYM(w8(relp->r_info))) {
-			uint64_t const addend = w8(w8(relp->r_offset) - recval);
-
-			mrelp->r_offset = w8(offbase
-				+ ((void *)mlocp - (void *)mloc0));
-			mrelp->r_info = w8(ELF64_R_INFO(recsym, reltype));
-			if (sizeof(Elf64_Rela) == rel_entsize) {
-				((Elf64_Rela *)mrelp)->r_addend = addend;
-				*mlocp++ = 0;
-			} else
-				*mlocp++ = addend;
-
-			mrelp = (Elf64_Rel *)(rel_entsize + (void *)mrelp);
-		}
-		relp = (Elf64_Rel const *)(rel_entsize + (void *)relp);
-	}
-	*mrelpp = mrelp;
-
-	return mlocp;
-}
-
-/*
- * Find a symbol in the given section, to be used as the base for relocating
- * the table of offsets of calls to mcount.  A local or global symbol suffices,
- * but avoid a Weak symbol because it may be overridden; the change in value
- * would invalidate the relocations of the offsets of the calls to mcount.
- * Often the found symbol will be the unnamed local symbol generated by
- * GNU 'as' for the start of each section.  For example:
- *    Num:    Value  Size Type    Bind   Vis      Ndx Name
- *      2: 00000000     0 SECTION LOCAL  DEFAULT    1
- */
-static unsigned find32_secsym_ndx(unsigned const txtndx,
-				  char const *const txtname,
-				  uint32_t *const recvalp,
-				  Elf32_Shdr const *const symhdr,
-				  Elf32_Ehdr const *const ehdr)
-{
-	Elf32_Sym const *const sym0 = (Elf32_Sym const *)(w(symhdr->sh_offset)
-		+ (void *)ehdr);
-	unsigned const nsym = w(symhdr->sh_size) / w(symhdr->sh_entsize);
-	Elf32_Sym const *symp;
-	unsigned t;
-
-	for (symp = sym0, t = nsym; t; --t, ++symp) {
-		unsigned int const st_bind = ELF32_ST_BIND(symp->st_info);
-
-		if (txtndx == w2(symp->st_shndx)
-			/* avoid STB_WEAK */
-		    && (STB_LOCAL == st_bind || STB_GLOBAL == st_bind)) {
-			*recvalp = w(symp->st_value);
-			return symp - sym0;
-		}
-	}
-	fprintf(stderr, "Cannot find symbol for section %d: %s.\n",
-		txtndx, txtname);
-	fail_file();
-}
-
-static unsigned find64_secsym_ndx(unsigned const txtndx,
-				  char const *const txtname,
-				  uint64_t *const recvalp,
-				  Elf64_Shdr const *const symhdr,
-				  Elf64_Ehdr const *const ehdr)
-{
-	Elf64_Sym const *const sym0 = (Elf64_Sym const *)(w8(symhdr->sh_offset)
-		+ (void *)ehdr);
-	unsigned const nsym = w8(symhdr->sh_size) / w8(symhdr->sh_entsize);
-	Elf64_Sym const *symp;
-	unsigned t;
-
-	for (symp = sym0, t = nsym; t; --t, ++symp) {
-		unsigned int const st_bind = ELF64_ST_BIND(symp->st_info);
-
-		if (txtndx == w2(symp->st_shndx)
-			/* avoid STB_WEAK */
-		    && (STB_LOCAL == st_bind || STB_GLOBAL == st_bind)) {
-			*recvalp = w8(symp->st_value);
-			return symp - sym0;
-		}
-	}
-	fprintf(stderr, "Cannot find symbol for section %d: %s.\n",
-		txtndx, txtname);
-	fail_file();
-}
-
-/*
- * Evade ISO C restriction: no declaration after statement in
- * has32_rel_mcount.
- */
-static char const *
-__has32_rel_mcount(Elf32_Shdr const *const relhdr,  /* is SHT_REL or SHT_RELA */
-		   Elf32_Shdr const *const shdr0,
-		   char const *const shstrtab,
-		   char const *const fname)
-{
-	/* .sh_info depends on .sh_type == SHT_REL[,A] */
-	Elf32_Shdr const *const txthdr = &shdr0[w(relhdr->sh_info)];
-	char const *const txtname = &shstrtab[w(txthdr->sh_name)];
-
-	if (0 == strcmp("__mcount_loc", txtname)) {
-		fprintf(stderr, "warning: __mcount_loc already exists: %s\n",
-			fname);
-		succeed_file();
-	}
-	if (SHT_PROGBITS != w(txthdr->sh_type) ||
-	    !is_mcounted_section_name(txtname))
-		return NULL;
-	return txtname;
-}
-
-static char const *has32_rel_mcount(Elf32_Shdr const *const relhdr,
-				    Elf32_Shdr const *const shdr0,
-				    char const *const shstrtab,
-				    char const *const fname)
-{
-	if (SHT_REL  != w(relhdr->sh_type) && SHT_RELA != w(relhdr->sh_type))
-		return NULL;
-	return __has32_rel_mcount(relhdr, shdr0, shstrtab, fname);
-}
-
-static char const *__has64_rel_mcount(Elf64_Shdr const *const relhdr,
-				      Elf64_Shdr const *const shdr0,
-				      char const *const shstrtab,
-				      char const *const fname)
-{
-	/* .sh_info depends on .sh_type == SHT_REL[,A] */
-	Elf64_Shdr const *const txthdr = &shdr0[w(relhdr->sh_info)];
-	char const *const txtname = &shstrtab[w(txthdr->sh_name)];
-
-	if (0 == strcmp("__mcount_loc", txtname)) {
-		fprintf(stderr, "warning: __mcount_loc already exists: %s\n",
-			fname);
-		succeed_file();
-	}
-	if (SHT_PROGBITS != w(txthdr->sh_type) ||
-	    !is_mcounted_section_name(txtname))
-		return NULL;
-	return txtname;
-}
-
-static char const *has64_rel_mcount(Elf64_Shdr const *const relhdr,
-				    Elf64_Shdr const *const shdr0,
-				    char const *const shstrtab,
-				    char const *const fname)
-{
-	if (SHT_REL  != w(relhdr->sh_type) && SHT_RELA != w(relhdr->sh_type))
-		return NULL;
-	return __has64_rel_mcount(relhdr, shdr0, shstrtab, fname);
-}
-
-static unsigned tot32_relsize(Elf32_Shdr const *const shdr0,
-			      unsigned nhdr,
-			      const char *const shstrtab,
-			      const char *const fname)
-{
-	unsigned totrelsz = 0;
-	Elf32_Shdr const *shdrp = shdr0;
-	for (; 0 != nhdr; --nhdr, ++shdrp) {
-		if (has32_rel_mcount(shdrp, shdr0, shstrtab, fname))
-			totrelsz += w(shdrp->sh_size);
-	}
-	return totrelsz;
-}
-
-static unsigned tot64_relsize(Elf64_Shdr const *const shdr0,
-			      unsigned nhdr,
-			      const char *const shstrtab,
-			      const char *const fname)
-{
-	unsigned totrelsz = 0;
-	Elf64_Shdr const *shdrp = shdr0;
-
-	for (; nhdr; --nhdr, ++shdrp) {
-		if (has64_rel_mcount(shdrp, shdr0, shstrtab, fname))
-			totrelsz += w8(shdrp->sh_size);
-	}
-	return totrelsz;
-}
-
-/* Overall supervision for Elf32 ET_REL file. */
-static void
-do32(Elf32_Ehdr *const ehdr, char const *const fname, unsigned const reltype)
-{
-	Elf32_Shdr *const shdr0 = (Elf32_Shdr *)(w(ehdr->e_shoff)
-		+ (void *)ehdr);
-	unsigned const nhdr = w2(ehdr->e_shnum);
-	Elf32_Shdr *const shstr = &shdr0[w2(ehdr->e_shstrndx)];
-	char const *const shstrtab = (char const *)(w(shstr->sh_offset)
-		+ (void *)ehdr);
-
-	Elf32_Shdr const *relhdr;
-	unsigned k;
-
-	/* Upper bound on space: assume all relevant relocs are for mcount. */
-	unsigned const totrelsz = tot32_relsize(shdr0, nhdr, shstrtab, fname);
-	Elf32_Rel *const mrel0 = umalloc(totrelsz);
-	Elf32_Rel *      mrelp = mrel0;
-
-	/* 2*sizeof(address) <= sizeof(Elf32_Rel) */
-	uint32_t *const mloc0 = umalloc(totrelsz>>1);
-	uint32_t *      mlocp = mloc0;
-
-	unsigned rel_entsize = 0;
-	unsigned symsec_sh_link = 0;
-
-	for (relhdr = shdr0, k = nhdr; k; --k, ++relhdr) {
-		char const *const txtname = has32_rel_mcount(relhdr, shdr0,
-			shstrtab, fname);
-		if (txtname) {
-			uint32_t recval = 0;
-			unsigned const recsym = find32_secsym_ndx(
-				w(relhdr->sh_info), txtname, &recval,
-				&shdr0[symsec_sh_link = w(relhdr->sh_link)],
-				ehdr);
-
-			rel_entsize = w(relhdr->sh_entsize);
-			mlocp = sift32_rel_mcount(mlocp,
-				(void *)mlocp - (void *)mloc0, &mrelp,
-				relhdr, ehdr, recsym, recval, reltype);
-		}
-	}
-	if (mloc0 != mlocp) {
-		append32(ehdr, shstr, mloc0, mlocp, mrel0, mrelp,
-			rel_entsize, symsec_sh_link);
-	}
-	free(mrel0);
-	free(mloc0);
-}
-
-static void
-do64(Elf64_Ehdr *const ehdr, char const *const fname, unsigned const reltype)
-{
-	Elf64_Shdr *const shdr0 = (Elf64_Shdr *)(w8(ehdr->e_shoff)
-		+ (void *)ehdr);
-	unsigned const nhdr = w2(ehdr->e_shnum);
-	Elf64_Shdr *const shstr = &shdr0[w2(ehdr->e_shstrndx)];
-	char const *const shstrtab = (char const *)(w8(shstr->sh_offset)
-		+ (void *)ehdr);
-
-	Elf64_Shdr const *relhdr;
-	unsigned k;
-
-	/* Upper bound on space: assume all relevant relocs are for mcount. */
-	unsigned const totrelsz = tot64_relsize(shdr0, nhdr, shstrtab, fname);
-	Elf64_Rel *const mrel0 = umalloc(totrelsz);
-	Elf64_Rel *      mrelp = mrel0;
-
-	/* 2*sizeof(address) <= sizeof(Elf64_Rel) */
-	uint64_t *const mloc0 = umalloc(totrelsz>>1);
-	uint64_t *      mlocp = mloc0;
-
-	unsigned rel_entsize = 0;
-	unsigned symsec_sh_link = 0;
-
-	for ((relhdr = shdr0), k = nhdr; k; --k, ++relhdr) {
-		char const *const txtname = has64_rel_mcount(relhdr, shdr0,
-			shstrtab, fname);
-		if (txtname) {
-			uint64_t recval = 0;
-			unsigned const recsym = find64_secsym_ndx(
-				w(relhdr->sh_info), txtname, &recval,
-				&shdr0[symsec_sh_link = w(relhdr->sh_link)],
-				ehdr);
-
-			rel_entsize = w8(relhdr->sh_entsize);
-			mlocp = sift64_rel_mcount(mlocp,
-				(void *)mlocp - (void *)mloc0, &mrelp,
-				relhdr, ehdr, recsym, recval, reltype);
-		}
-	}
-	if (mloc0 != mlocp) {
-		append64(ehdr, shstr, mloc0, mlocp, mrel0, mrelp,
-			rel_entsize, symsec_sh_link);
-	}
-	free(mrel0);
-	free(mloc0);
-}
+/* 32 bit and 64 bit are very similar */
+#include "recordmcount.h"
+#define RECORD_MCOUNT_64
+#include "recordmcount.h"
 
 static void
 do_file(char const *const fname)
diff --git a/scripts/recordmcount.h b/scripts/recordmcount.h
new file mode 100644
index 0000000..7f39d09
--- /dev/null
+++ b/scripts/recordmcount.h
@@ -0,0 +1,366 @@
+/*
+ * recordmcount.h
+ *
+ * This code was taken out of recordmcount.c written by
+ * Copyright 2009 John F. Reiser <jreiser@BitWagon.com>.  All rights reserved.
+ *
+ * The original code had the same algorithms for both 32bit
+ * and 64bit ELF files, but the code was duplicated to support
+ * the difference in structures that were used. This
+ * file creates a macro of everything that is different between
+ * the 64 and 32 bit code, such that by including this header
+ * twice we can create both sets of functions by including this
+ * header once with RECORD_MCOUNT_64 undefined, and again with
+ * it defined.
+ *
+ * This conversion to macros was done by:
+ * Copyright 2010 Steven Rostedt <srostedt@redhat.com>, Red Hat Inc.
+ *
+ * Licensed under the GNU General Public License, version 2 (GPLv2).
+ */
+#undef append_func
+#undef sift_rel_mcount
+#undef find_secsym_ndx
+#undef __has_rel_mcount
+#undef has_rel_mcount
+#undef tot_relsize
+#undef do_func
+#undef Elf_Ehdr
+#undef Elf_Shdr
+#undef Elf_Rel
+#undef Elf_Rela
+#undef Elf_Sym
+#undef ELF_R_SYM
+#undef ELF_R_INFO
+#undef ELF_ST_BIND
+#undef uint_t
+#undef _w
+#undef _align
+#undef _size
+
+#ifdef RECORD_MCOUNT_64
+# define append_func		append64
+# define sift_rel_mcount	sift64_rel_mcount
+# define find_secsym_ndx	find64_secsym_ndx
+# define __has_rel_mcount	__has64_rel_mcount
+# define has_rel_mcount		has64_rel_mcount
+# define tot_relsize		tot64_relsize
+# define do_func		do64
+# define Elf_Ehdr		Elf64_Ehdr
+# define Elf_Shdr		Elf64_Shdr
+# define Elf_Rel		Elf64_Rel
+# define Elf_Rela		Elf64_Rela
+# define Elf_Sym		Elf64_Sym
+# define ELF_R_SYM		ELF64_R_SYM
+# define ELF_R_INFO		ELF64_R_INFO
+# define ELF_ST_BIND		ELF64_ST_BIND
+# define uint_t			uint64_t
+# define _w			w8
+# define _align			7u
+# define _size			8
+#else
+# define append_func		append32
+# define sift_rel_mcount	sift32_rel_mcount
+# define find_secsym_ndx	find32_secsym_ndx
+# define __has_rel_mcount	__has32_rel_mcount
+# define has_rel_mcount		has32_rel_mcount
+# define tot_relsize		tot32_relsize
+# define do_func		do32
+# define Elf_Ehdr		Elf32_Ehdr
+# define Elf_Shdr		Elf32_Shdr
+# define Elf_Rel		Elf32_Rel
+# define Elf_Rela		Elf32_Rela
+# define Elf_Sym		Elf32_Sym
+# define ELF_R_SYM		ELF32_R_SYM
+# define ELF_R_INFO		ELF32_R_INFO
+# define ELF_ST_BIND		ELF32_ST_BIND
+# define uint_t			uint32_t
+# define _w			w
+# define _align			3u
+# define _size			4
+#endif
+
+/* Append the new shstrtab, Elf_Shdr[], __mcount_loc and its relocations. */
+static void append_func(Elf_Ehdr *const ehdr,
+			Elf_Shdr *const shstr,
+			uint_t const *const mloc0,
+			uint_t const *const mlocp,
+			Elf_Rel const *const mrel0,
+			Elf_Rel const *const mrelp,
+			unsigned int const rel_entsize,
+			unsigned int const symsec_sh_link)
+{
+	/* Begin constructing output file */
+	Elf_Shdr mcsec;
+	char const *mc_name = (sizeof(Elf_Rela) == rel_entsize)
+		? ".rela__mcount_loc"
+		:  ".rel__mcount_loc";
+	unsigned const old_shnum = w2(ehdr->e_shnum);
+	uint_t const old_shoff = _w(ehdr->e_shoff);
+	uint_t const old_shstr_sh_size   = _w(shstr->sh_size);
+	uint_t const old_shstr_sh_offset = _w(shstr->sh_offset);
+	uint_t t = 1 + strlen(mc_name) + _w(shstr->sh_size);
+	uint_t new_e_shoff;
+
+	shstr->sh_size = _w(t);
+	shstr->sh_offset = _w(sb.st_size);
+	t += sb.st_size;
+	t += (_align & -t);  /* word-byte align */
+	new_e_shoff = t;
+
+	/* body for new shstrtab */
+	ulseek(fd_map, sb.st_size, SEEK_SET);
+	uwrite(fd_map, old_shstr_sh_offset + (void *)ehdr, old_shstr_sh_size);
+	uwrite(fd_map, mc_name, 1 + strlen(mc_name));
+
+	/* old(modified) Elf_Shdr table, word-byte aligned */
+	ulseek(fd_map, t, SEEK_SET);
+	t += sizeof(Elf_Shdr) * old_shnum;
+	uwrite(fd_map, old_shoff + (void *)ehdr,
+	       sizeof(Elf_Shdr) * old_shnum);
+
+	/* new sections __mcount_loc and .rel__mcount_loc */
+	t += 2*sizeof(mcsec);
+	mcsec.sh_name = w((sizeof(Elf_Rela) == rel_entsize) + strlen(".rel")
+		+ old_shstr_sh_size);
+	mcsec.sh_type = w(SHT_PROGBITS);
+	mcsec.sh_flags = _w(SHF_ALLOC);
+	mcsec.sh_addr = 0;
+	mcsec.sh_offset = _w(t);
+	mcsec.sh_size = _w((void *)mlocp - (void *)mloc0);
+	mcsec.sh_link = 0;
+	mcsec.sh_info = 0;
+	mcsec.sh_addralign = _w(_size);
+	mcsec.sh_entsize = _w(_size);
+	uwrite(fd_map, &mcsec, sizeof(mcsec));
+
+	mcsec.sh_name = w(old_shstr_sh_size);
+	mcsec.sh_type = (sizeof(Elf_Rela) == rel_entsize)
+		? w(SHT_RELA)
+		: w(SHT_REL);
+	mcsec.sh_flags = 0;
+	mcsec.sh_addr = 0;
+	mcsec.sh_offset = _w((void *)mlocp - (void *)mloc0 + t);
+	mcsec.sh_size   = _w((void *)mrelp - (void *)mrel0);
+	mcsec.sh_link = w(symsec_sh_link);
+	mcsec.sh_info = w(old_shnum);
+	mcsec.sh_addralign = _w(_size);
+	mcsec.sh_entsize = _w(rel_entsize);
+	uwrite(fd_map, &mcsec, sizeof(mcsec));
+
+	uwrite(fd_map, mloc0, (void *)mlocp - (void *)mloc0);
+	uwrite(fd_map, mrel0, (void *)mrelp - (void *)mrel0);
+
+	ehdr->e_shoff = _w(new_e_shoff);
+	ehdr->e_shnum = w2(2 + w2(ehdr->e_shnum));  /* {.rel,}__mcount_loc */
+	ulseek(fd_map, 0, SEEK_SET);
+	uwrite(fd_map, ehdr, sizeof(*ehdr));
+}
+
+
+/*
+ * Look at the relocations in order to find the calls to mcount.
+ * Accumulate the section offsets that are found, and their relocation info,
+ * onto the end of the existing arrays.
+ */
+static uint_t *sift_rel_mcount(uint_t *mlocp,
+			       unsigned const offbase,
+			       Elf_Rel **const mrelpp,
+			       Elf_Shdr const *const relhdr,
+			       Elf_Ehdr const *const ehdr,
+			       unsigned const recsym,
+			       uint_t const recval,
+			       unsigned const reltype)
+{
+	uint_t *const mloc0 = mlocp;
+	Elf_Rel *mrelp = *mrelpp;
+	Elf_Shdr *const shdr0 = (Elf_Shdr *)(_w(ehdr->e_shoff)
+		+ (void *)ehdr);
+	unsigned const symsec_sh_link = w(relhdr->sh_link);
+	Elf_Shdr const *const symsec = &shdr0[symsec_sh_link];
+	Elf_Sym const *const sym0 = (Elf_Sym const *)(_w(symsec->sh_offset)
+		+ (void *)ehdr);
+
+	Elf_Shdr const *const strsec = &shdr0[w(symsec->sh_link)];
+	char const *const str0 = (char const *)(_w(strsec->sh_offset)
+		+ (void *)ehdr);
+
+	Elf_Rel const *const rel0 = (Elf_Rel const *)(_w(relhdr->sh_offset)
+		+ (void *)ehdr);
+	unsigned rel_entsize = _w(relhdr->sh_entsize);
+	unsigned const nrel = _w(relhdr->sh_size) / rel_entsize;
+	Elf_Rel const *relp = rel0;
+
+	unsigned mcountsym = 0;
+	unsigned t;
+
+	for (t = nrel; t; --t) {
+		if (!mcountsym) {
+			Elf_Sym const *const symp =
+				&sym0[ELF_R_SYM(_w(relp->r_info))];
+			char const *symname = &str0[w(symp->st_name)];
+
+			if ('.' == symname[0])
+				++symname;  /* ppc64 hack */
+			if (0 == strcmp((('_' == gpfx) ? "_mcount" : "mcount"),
+					symname))
+				mcountsym = ELF_R_SYM(_w(relp->r_info));
+		}
+
+		if (mcountsym == ELF_R_SYM(_w(relp->r_info))) {
+			uint_t const addend = _w(_w(relp->r_offset) - recval);
+
+			mrelp->r_offset = _w(offbase
+				+ ((void *)mlocp - (void *)mloc0));
+			mrelp->r_info = _w(ELF_R_INFO(recsym, reltype));
+			if (sizeof(Elf_Rela) == rel_entsize) {
+				((Elf_Rela *)mrelp)->r_addend = addend;
+				*mlocp++ = 0;
+			} else
+				*mlocp++ = addend;
+
+			mrelp = (Elf_Rel *)(rel_entsize + (void *)mrelp);
+		}
+		relp = (Elf_Rel const *)(rel_entsize + (void *)relp);
+	}
+	*mrelpp = mrelp;
+	return mlocp;
+}
+
+
+/*
+ * Find a symbol in the given section, to be used as the base for relocating
+ * the table of offsets of calls to mcount.  A local or global symbol suffices,
+ * but avoid a Weak symbol because it may be overridden; the change in value
+ * would invalidate the relocations of the offsets of the calls to mcount.
+ * Often the found symbol will be the unnamed local symbol generated by
+ * GNU 'as' for the start of each section.  For example:
+ *    Num:    Value  Size Type    Bind   Vis      Ndx Name
+ *      2: 00000000     0 SECTION LOCAL  DEFAULT    1
+ */
+static unsigned find_secsym_ndx(unsigned const txtndx,
+				char const *const txtname,
+				uint_t *const recvalp,
+				Elf_Shdr const *const symhdr,
+				Elf_Ehdr const *const ehdr)
+{
+	Elf_Sym const *const sym0 = (Elf_Sym const *)(_w(symhdr->sh_offset)
+		+ (void *)ehdr);
+	unsigned const nsym = _w(symhdr->sh_size) / _w(symhdr->sh_entsize);
+	Elf_Sym const *symp;
+	unsigned t;
+
+	for (symp = sym0, t = nsym; t; --t, ++symp) {
+		unsigned int const st_bind = ELF_ST_BIND(symp->st_info);
+
+		if (txtndx == w2(symp->st_shndx)
+			/* avoid STB_WEAK */
+		    && (STB_LOCAL == st_bind || STB_GLOBAL == st_bind)) {
+			*recvalp = _w(symp->st_value);
+			return symp - sym0;
+		}
+	}
+	fprintf(stderr, "Cannot find symbol for section %d: %s.\n",
+		txtndx, txtname);
+	fail_file();
+}
+
+
+/* Evade ISO C restriction: no declaration after statement in has_rel_mcount. */
+static char const *
+__has_rel_mcount(Elf_Shdr const *const relhdr,  /* is SHT_REL or SHT_RELA */
+		 Elf_Shdr const *const shdr0,
+		 char const *const shstrtab,
+		 char const *const fname)
+{
+	/* .sh_info depends on .sh_type == SHT_REL[,A] */
+	Elf_Shdr const *const txthdr = &shdr0[w(relhdr->sh_info)];
+	char const *const txtname = &shstrtab[w(txthdr->sh_name)];
+
+	if (0 == strcmp("__mcount_loc", txtname)) {
+		fprintf(stderr, "warning: __mcount_loc already exists: %s\n",
+			fname);
+		succeed_file();
+	}
+	if (SHT_PROGBITS != w(txthdr->sh_type) ||
+	    !is_mcounted_section_name(txtname))
+		return NULL;
+	return txtname;
+}
+
+static char const *has_rel_mcount(Elf_Shdr const *const relhdr,
+				  Elf_Shdr const *const shdr0,
+				  char const *const shstrtab,
+				  char const *const fname)
+{
+	if (SHT_REL  != w(relhdr->sh_type) && SHT_RELA != w(relhdr->sh_type))
+		return NULL;
+	return __has_rel_mcount(relhdr, shdr0, shstrtab, fname);
+}
+
+
+static unsigned tot_relsize(Elf_Shdr const *const shdr0,
+			    unsigned nhdr,
+			    const char *const shstrtab,
+			    const char *const fname)
+{
+	unsigned totrelsz = 0;
+	Elf_Shdr const *shdrp = shdr0;
+
+	for (; nhdr; --nhdr, ++shdrp) {
+		if (has_rel_mcount(shdrp, shdr0, shstrtab, fname))
+			totrelsz += _w(shdrp->sh_size);
+	}
+	return totrelsz;
+}
+
+
+/* Overall supervision for Elf32 ET_REL file. */
+static void
+do_func(Elf_Ehdr *const ehdr, char const *const fname, unsigned const reltype)
+{
+	Elf_Shdr *const shdr0 = (Elf_Shdr *)(_w(ehdr->e_shoff)
+		+ (void *)ehdr);
+	unsigned const nhdr = w2(ehdr->e_shnum);
+	Elf_Shdr *const shstr = &shdr0[w2(ehdr->e_shstrndx)];
+	char const *const shstrtab = (char const *)(_w(shstr->sh_offset)
+		+ (void *)ehdr);
+
+	Elf_Shdr const *relhdr;
+	unsigned k;
+
+	/* Upper bound on space: assume all relevant relocs are for mcount. */
+	unsigned const totrelsz = tot_relsize(shdr0, nhdr, shstrtab, fname);
+	Elf_Rel *const mrel0 = umalloc(totrelsz);
+	Elf_Rel *      mrelp = mrel0;
+
+	/* 2*sizeof(address) <= sizeof(Elf_Rel) */
+	uint_t *const mloc0 = umalloc(totrelsz>>1);
+	uint_t *      mlocp = mloc0;
+
+	unsigned rel_entsize = 0;
+	unsigned symsec_sh_link = 0;
+
+	for (relhdr = shdr0, k = nhdr; k; --k, ++relhdr) {
+		char const *const txtname = has_rel_mcount(relhdr, shdr0,
+			shstrtab, fname);
+		if (txtname) {
+			uint_t recval = 0;
+			unsigned const recsym = find_secsym_ndx(
+				w(relhdr->sh_info), txtname, &recval,
+				&shdr0[symsec_sh_link = w(relhdr->sh_link)],
+				ehdr);
+
+			rel_entsize = _w(relhdr->sh_entsize);
+			mlocp = sift_rel_mcount(mlocp,
+				(void *)mlocp - (void *)mloc0, &mrelp,
+				relhdr, ehdr, recsym, recval, reltype);
+		}
+	}
+	if (mloc0 != mlocp) {
+		append_func(ehdr, shstr, mloc0, mlocp, mrel0, mrelp,
+			    rel_entsize, symsec_sh_link);
+	}
+	free(mrel0);
+	free(mloc0);
+}
-- 
1.7.1


