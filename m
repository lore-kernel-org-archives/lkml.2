Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933476Ab1ERSdW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 May 2011 14:33:22 -0400
Received: from hera.kernel.org ([140.211.167.34]:44737 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933459Ab1ERSdS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 May 2011 14:33:18 -0400
Date: Wed, 18 May 2011 18:32:50 GMT
From: tip-bot for Steven Rostedt <srostedt@redhat.com>
Message-ID: <tip-ffd618fa39284f8cc343894b566dd42ec6e74e77@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        rostedt@goodmis.org, srostedt@redhat.com, jreiser@bitwagon.com,
        tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        rostedt@goodmis.org, srostedt@redhat.com, jreiser@bitwagon.com,
        tglx@linutronix.de
In-Reply-To: <20110421023738.237101176@goodmis.org>
References: <20110421023738.237101176@goodmis.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] ftrace/recordmcount: Make ignored mcount calls into nops at compile time
Git-Commit-ID: ffd618fa39284f8cc343894b566dd42ec6e74e77
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 18 May 2011 18:32:52 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  ffd618fa39284f8cc343894b566dd42ec6e74e77
Gitweb:     http://git.kernel.org/tip/ffd618fa39284f8cc343894b566dd42ec6e74e77
Author:     Steven Rostedt <srostedt@redhat.com>
AuthorDate: Fri, 8 Apr 2011 03:58:48 -0400
Committer:  Steven Rostedt <rostedt@goodmis.org>
CommitDate: Mon, 16 May 2011 14:43:32 -0400

ftrace/recordmcount: Make ignored mcount calls into nops at compile time

There are sections that are ignored by ftrace for the function tracing because
the text is in a section that can be removed without notice. The mcount calls
in these sections are ignored and ftrace never sees them. The downside of this
is that the functions in these sections still call mcount. Although the mcount
function is defined in assembly simply as a return, this added overhead is
unnecessary.

The solution is to convert these callers into nops at compile time.
A better solution is to add 'notrace' to the section markers, but as new sections
come up all the time, it would be nice that they are delt with when they
are created.

Later patches will deal with finding these sections and doing the proper solution.

Thanks to H. Peter Anvin for giving me the right nops to use for x86.

Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: John Reiser <jreiser@bitwagon.com>
Link: http://lkml.kernel.org/r/20110421023738.237101176@goodmis.org
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 scripts/recordmcount.c |   40 ++++++++++++++++++++++-
 scripts/recordmcount.h |   82 +++++++++++++++++++++++++++++++++++++++++++++--
 2 files changed, 116 insertions(+), 6 deletions(-)

diff --git a/scripts/recordmcount.c b/scripts/recordmcount.c
index 37c5965..78054a4 100644
--- a/scripts/recordmcount.c
+++ b/scripts/recordmcount.c
@@ -118,6 +118,34 @@ umalloc(size_t size)
 	return addr;
 }
 
+static unsigned char ideal_nop5_x86_64[5] = { 0x0f, 0x1f, 0x44, 0x00, 0x00 };
+static unsigned char ideal_nop5_x86_32[5] = { 0x3e, 0x8d, 0x74, 0x26, 0x00 };
+static unsigned char *ideal_nop;
+
+static char rel_type_nop;
+
+static int (*make_nop)(void *map, size_t const offset);
+
+static int make_nop_x86(void *map, size_t const offset)
+{
+	uint32_t *ptr;
+	unsigned char *op;
+
+	/* Confirm we have 0xe8 0x0 0x0 0x0 0x0 */
+	ptr = map + offset;
+	if (*ptr != 0)
+		return -1;
+
+	op = map + offset - 1;
+	if (*op != 0xe8)
+		return -1;
+
+	/* convert to nop */
+	ulseek(fd_map, offset - 1, SEEK_SET);
+	uwrite(fd_map, ideal_nop, 5);
+	return 0;
+}
+
 /*
  * Get the whole file as a programming convenience in order to avoid
  * malloc+lseek+read+free of many pieces.  If successful, then mmap
@@ -301,7 +329,11 @@ do_file(char const *const fname)
 			w2(ehdr->e_machine), fname);
 		fail_file();
 		break;
-	case EM_386:	 reltype = R_386_32;                   break;
+	case EM_386:
+		reltype = R_386_32;
+		make_nop = make_nop_x86;
+		ideal_nop = ideal_nop5_x86_32;
+		break;
 	case EM_ARM:	 reltype = R_ARM_ABS32;
 			 altmcount = "__gnu_mcount_nc";
 			 break;
@@ -312,7 +344,11 @@ do_file(char const *const fname)
 	case EM_S390:    /* reltype: e_class    */ gpfx = '_'; break;
 	case EM_SH:	 reltype = R_SH_DIR32;                 break;
 	case EM_SPARCV9: reltype = R_SPARC_64;     gpfx = '_'; break;
-	case EM_X86_64:	 reltype = R_X86_64_64;                break;
+	case EM_X86_64:
+		make_nop = make_nop_x86;
+		ideal_nop = ideal_nop5_x86_64;
+		reltype = R_X86_64_64;
+		break;
 	}  /* end switch */
 
 	switch (ehdr->e_ident[EI_CLASS]) {
diff --git a/scripts/recordmcount.h b/scripts/recordmcount.h
index 7f8d5c4..657dbed 100644
--- a/scripts/recordmcount.h
+++ b/scripts/recordmcount.h
@@ -23,6 +23,7 @@
 #undef fn_is_fake_mcount
 #undef MIPS_is_fake_mcount
 #undef sift_rel_mcount
+#undef nop_mcount
 #undef find_secsym_ndx
 #undef __has_rel_mcount
 #undef has_rel_mcount
@@ -49,6 +50,7 @@
 #ifdef RECORD_MCOUNT_64
 # define append_func		append64
 # define sift_rel_mcount	sift64_rel_mcount
+# define nop_mcount		nop_mcount_64
 # define find_secsym_ndx	find64_secsym_ndx
 # define __has_rel_mcount	__has64_rel_mcount
 # define has_rel_mcount		has64_rel_mcount
@@ -77,6 +79,7 @@
 #else
 # define append_func		append32
 # define sift_rel_mcount	sift32_rel_mcount
+# define nop_mcount		nop_mcount_32
 # define find_secsym_ndx	find32_secsym_ndx
 # define __has_rel_mcount	__has32_rel_mcount
 # define has_rel_mcount		has32_rel_mcount
@@ -304,6 +307,70 @@ static uint_t *sift_rel_mcount(uint_t *mlocp,
 	return mlocp;
 }
 
+/*
+ * Read the relocation table again, but this time its called on sections
+ * that are not going to be traced. The mcount calls here will be converted
+ * into nops.
+ */
+static void nop_mcount(Elf_Shdr const *const relhdr,
+		       Elf_Ehdr const *const ehdr)
+{
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
+	Elf_Shdr const *const shdr = &shdr0[w(relhdr->sh_info)];
+
+	unsigned mcountsym = 0;
+	unsigned t;
+
+	for (t = nrel; t; --t) {
+		int ret = -1;
+
+		if (!mcountsym) {
+			Elf_Sym const *const symp =
+				&sym0[Elf_r_sym(relp)];
+			char const *symname = &str0[w(symp->st_name)];
+			char const *mcount = gpfx == '_' ? "_mcount" : "mcount";
+
+			if (symname[0] == '.')
+				++symname;  /* ppc64 hack */
+			if (strcmp(mcount, symname) == 0 ||
+			    (altmcount && strcmp(altmcount, symname) == 0))
+				mcountsym = Elf_r_sym(relp);
+		}
+
+		if (mcountsym == Elf_r_sym(relp) && !is_fake_mcount(relp))
+			ret = make_nop((void *)ehdr, shdr->sh_offset + relp->r_offset);
+
+		/*
+		 * If we successfully removed the mcount, mark the relocation
+		 * as a nop (don't do anything with it).
+		 */
+		if (!ret) {
+			Elf_Rel rel;
+			rel = *(Elf_Rel *)relp;
+			Elf_r_info(&rel, Elf_r_sym(relp), rel_type_nop);
+			ulseek(fd_map, (void *)relp - (void *)ehdr, SEEK_SET);
+			uwrite(fd_map, &rel, sizeof(rel));
+		}
+		relp = (Elf_Rel const *)(rel_entsize + (void *)relp);
+	}
+}
+
 
 /*
  * Find a symbol in the given section, to be used as the base for relocating
@@ -360,8 +427,7 @@ __has_rel_mcount(Elf_Shdr const *const relhdr,  /* is SHT_REL or SHT_RELA */
 		succeed_file();
 	}
 	if (w(txthdr->sh_type) != SHT_PROGBITS ||
-	    !(w(txthdr->sh_flags) & SHF_EXECINSTR) ||
-	    !is_mcounted_section_name(txtname))
+	    !(w(txthdr->sh_flags) & SHF_EXECINSTR))
 		return NULL;
 	return txtname;
 }
@@ -384,9 +450,11 @@ static unsigned tot_relsize(Elf_Shdr const *const shdr0,
 {
 	unsigned totrelsz = 0;
 	Elf_Shdr const *shdrp = shdr0;
+	char const *txtname;
 
 	for (; nhdr; --nhdr, ++shdrp) {
-		if (has_rel_mcount(shdrp, shdr0, shstrtab, fname))
+		txtname = has_rel_mcount(shdrp, shdr0, shstrtab, fname);
+		if (txtname && is_mcounted_section_name(txtname))
 			totrelsz += _w(shdrp->sh_size);
 	}
 	return totrelsz;
@@ -422,7 +490,7 @@ do_func(Elf_Ehdr *const ehdr, char const *const fname, unsigned const reltype)
 	for (relhdr = shdr0, k = nhdr; k; --k, ++relhdr) {
 		char const *const txtname = has_rel_mcount(relhdr, shdr0,
 			shstrtab, fname);
-		if (txtname) {
+		if (txtname && is_mcounted_section_name(txtname)) {
 			uint_t recval = 0;
 			unsigned const recsym = find_secsym_ndx(
 				w(relhdr->sh_info), txtname, &recval,
@@ -433,6 +501,12 @@ do_func(Elf_Ehdr *const ehdr, char const *const fname, unsigned const reltype)
 			mlocp = sift_rel_mcount(mlocp,
 				(void *)mlocp - (void *)mloc0, &mrelp,
 				relhdr, ehdr, recsym, recval, reltype);
+		} else if (make_nop && txtname) {
+			/*
+			 * This section is ignored by ftrace, but still
+			 * has mcount calls. Convert them to nops now.
+			 */
+			nop_mcount(relhdr, ehdr);
 		}
 	}
 	if (mloc0 != mlocp) {
