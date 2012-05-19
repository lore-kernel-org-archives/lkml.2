Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968295Ab2ESC4N (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 22:56:13 -0400
Received: from terminus.zytor.com ([198.137.202.10]:49993 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753626Ab2ESC4I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 22:56:08 -0400
Date: Fri, 18 May 2012 19:55:44 -0700
Message-Id: <201205190255.q4J2tiGR019358@terminus.zytor.com>
From: "H. Peter Anvin" <hpa@linux.intel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [GIT PULL/RFC] x86/relocs fixes for ld 2.22.52.0.x bug
Cc: <stable@vger.kernel.org>, "H. Peter Anvin" <hpa@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>, "H.J. Lu" <hjl.tools@gmail.com>,
        Ingo Molnar <mingo@elte.hu>, Ingo Molnar <mingo@kernel.org>,
        Jarkko Sakkinen <jarkko.sakkinen@intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Fri, 18 May 2012 19:55:50 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

This is in case you want to take the patches for the GNU ld
2.22.52.0.x bug at this time -- the code is a direct cherry-pick from
the tip:x86/trampoline branch, except I have folded five patches on
that branch into three.

This is not a minimal fix, not at all, but it is a tested code base.

The following changes since commit 36be50515fe2aef61533b516fa2576a2c7fe7664:

  Linux 3.4-rc7 (2012-05-12 18:37:47 -0700)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git x86/ld-fix

The head of this tree is 24ab82bd9bf18f3efc69a131d73577940941e1b7.

H. Peter Anvin (3):
      x86, realmode: 16-bit real-mode code support for relocs tool
      x86, relocs: Workaround for binutils 2.22.52.0.1 section bug
      x86, relocs: When printing an error, say relative or absolute

 Makefile                                     |    9 +-
 arch/x86/Makefile                            |    3 +
 arch/x86/boot/compressed/Makefile            |    9 +-
 arch/x86/tools/.gitignore                    |    1 +
 arch/x86/tools/Makefile                      |    4 +
 arch/x86/{boot/compressed => tools}/relocs.c |  242 ++++++++++++++++++++------
 scripts/Makefile                             |    2 +
 7 files changed, 205 insertions(+), 65 deletions(-)

diff --git a/Makefile b/Makefile
index 48bd1f5..db2bcf3 100644
--- a/Makefile
+++ b/Makefile
@@ -442,7 +442,7 @@ asm-generic:
 
 no-dot-config-targets := clean mrproper distclean \
 			 cscope gtags TAGS tags help %docs check% coccicheck \
-			 include/linux/version.h headers_% archheaders \
+			 include/linux/version.h headers_% archheaders archscripts \
 			 kernelversion %src-pkg
 
 config-targets := 0
@@ -979,7 +979,7 @@ prepare1: prepare2 include/linux/version.h include/generated/utsrelease.h \
                    include/config/auto.conf
 	$(cmd_crmodverdir)
 
-archprepare: archheaders prepare1 scripts_basic
+archprepare: archheaders archscripts prepare1 scripts_basic
 
 prepare0: archprepare FORCE
 	$(Q)$(MAKE) $(build)=.
@@ -1049,8 +1049,11 @@ hdr-dst = $(if $(KBUILD_HEADERS), dst=include/asm-$(hdr-arch), dst=include/asm)
 PHONY += archheaders
 archheaders:
 
+PHONY += archscripts
+archscripts:
+
 PHONY += __headers
-__headers: include/linux/version.h scripts_basic asm-generic archheaders FORCE
+__headers: include/linux/version.h scripts_basic asm-generic archheaders archscripts FORCE
 	$(Q)$(MAKE) $(build)=scripts build_unifdef
 
 PHONY += headers_install_all
diff --git a/arch/x86/Makefile b/arch/x86/Makefile
index 41a7237..94e91e4 100644
--- a/arch/x86/Makefile
+++ b/arch/x86/Makefile
@@ -134,6 +134,9 @@ KBUILD_CFLAGS += $(call cc-option,-mno-avx,)
 KBUILD_CFLAGS += $(mflags-y)
 KBUILD_AFLAGS += $(mflags-y)
 
+archscripts:
+	$(Q)$(MAKE) $(build)=arch/x86/tools relocs
+
 ###
 # Syscall table generation
 
diff --git a/arch/x86/boot/compressed/Makefile b/arch/x86/boot/compressed/Makefile
index fd55a2f..e398bb5 100644
--- a/arch/x86/boot/compressed/Makefile
+++ b/arch/x86/boot/compressed/Makefile
@@ -40,13 +40,12 @@ OBJCOPYFLAGS_vmlinux.bin :=  -R .comment -S
 $(obj)/vmlinux.bin: vmlinux FORCE
 	$(call if_changed,objcopy)
 
+targets += vmlinux.bin.all vmlinux.relocs
 
-targets += vmlinux.bin.all vmlinux.relocs relocs
-hostprogs-$(CONFIG_X86_NEED_RELOCS) += relocs
-
+CMD_RELOCS = arch/x86/tools/relocs
 quiet_cmd_relocs = RELOCS  $@
-      cmd_relocs = $(obj)/relocs $< > $@;$(obj)/relocs --abs-relocs $<
-$(obj)/vmlinux.relocs: vmlinux $(obj)/relocs FORCE
+      cmd_relocs = $(CMD_RELOCS) $< > $@;$(CMD_RELOCS) --abs-relocs $<
+$(obj)/vmlinux.relocs: vmlinux FORCE
 	$(call if_changed,relocs)
 
 vmlinux.bin.all-y := $(obj)/vmlinux.bin
diff --git a/arch/x86/tools/.gitignore b/arch/x86/tools/.gitignore
new file mode 100644
index 0000000..be0ed06
--- /dev/null
+++ b/arch/x86/tools/.gitignore
@@ -0,0 +1 @@
+relocs
diff --git a/arch/x86/tools/Makefile b/arch/x86/tools/Makefile
index d511aa9..733057b 100644
--- a/arch/x86/tools/Makefile
+++ b/arch/x86/tools/Makefile
@@ -36,3 +36,7 @@ HOSTCFLAGS_insn_sanity.o := -Wall -I$(objtree)/arch/x86/lib/ -I$(srctree)/arch/x
 $(obj)/test_get_len.o: $(srctree)/arch/x86/lib/insn.c $(srctree)/arch/x86/lib/inat.c $(srctree)/arch/x86/include/asm/inat_types.h $(srctree)/arch/x86/include/asm/inat.h $(srctree)/arch/x86/include/asm/insn.h $(objtree)/arch/x86/lib/inat-tables.c
 
 $(obj)/insn_sanity.o: $(srctree)/arch/x86/lib/insn.c $(srctree)/arch/x86/lib/inat.c $(srctree)/arch/x86/include/asm/inat_types.h $(srctree)/arch/x86/include/asm/inat.h $(srctree)/arch/x86/include/asm/insn.h $(objtree)/arch/x86/lib/inat-tables.c
+
+HOST_EXTRACFLAGS += -I$(srctree)/tools/include
+hostprogs-y	+= relocs
+relocs: $(obj)/relocs
diff --git a/arch/x86/boot/compressed/relocs.c b/arch/x86/tools/relocs.c
similarity index 76%
rename from arch/x86/boot/compressed/relocs.c
rename to arch/x86/tools/relocs.c
index fb7117a..b43cfcd 100644
--- a/arch/x86/boot/compressed/relocs.c
+++ b/arch/x86/tools/relocs.c
@@ -18,6 +18,8 @@ static void die(char *fmt, ...);
 static Elf32_Ehdr ehdr;
 static unsigned long reloc_count, reloc_idx;
 static unsigned long *relocs;
+static unsigned long reloc16_count, reloc16_idx;
+static unsigned long *relocs16;
 
 struct section {
 	Elf32_Shdr     shdr;
@@ -28,52 +30,86 @@ struct section {
 };
 static struct section *secs;
 
+enum symtype {
+	S_ABS,
+	S_REL,
+	S_SEG,
+	S_LIN,
+	S_NSYMTYPES
+};
+
+static const char * const sym_regex_kernel[S_NSYMTYPES] = {
 /*
  * Following symbols have been audited. There values are constant and do
  * not change if bzImage is loaded at a different physical address than
  * the address for which it has been compiled. Don't warn user about
  * absolute relocations present w.r.t these symbols.
  */
-static const char abs_sym_regex[] =
+	[S_ABS] =
 	"^(xen_irq_disable_direct_reloc$|"
 	"xen_save_fl_direct_reloc$|"
 	"VDSO|"
-	"__crc_)";
-static regex_t abs_sym_regex_c;
-static int is_abs_reloc(const char *sym_name)
-{
-	return !regexec(&abs_sym_regex_c, sym_name, 0, NULL, 0);
-}
+	"__crc_)",
 
 /*
  * These symbols are known to be relative, even if the linker marks them
  * as absolute (typically defined outside any section in the linker script.)
  */
-static const char rel_sym_regex[] =
-	"^_end$";
-static regex_t rel_sym_regex_c;
-static int is_rel_reloc(const char *sym_name)
+	[S_REL] =
+	"^(__init_(begin|end)|"
+	"__x86_cpu_dev_(start|end)|"
+	"(__parainstructions|__alt_instructions)(|_end)|"
+	"(__iommu_table|__apicdrivers|__smp_locks)(|_end)|"
+	"_end)$"
+};
+
+
+static const char * const sym_regex_realmode[S_NSYMTYPES] = {
+/*
+ * These are 16-bit segment symbols when compiling 16-bit code.
+ */
+	[S_SEG] =
+	"^real_mode_seg$",
+
+/*
+ * These are offsets belonging to segments, as opposed to linear addresses,
+ * when compiling 16-bit code.
+ */
+	[S_LIN] =
+	"^pa_",
+};
+
+static const char * const *sym_regex;
+
+static regex_t sym_regex_c[S_NSYMTYPES];
+static int is_reloc(enum symtype type, const char *sym_name)
 {
-	return !regexec(&rel_sym_regex_c, sym_name, 0, NULL, 0);
+	return sym_regex[type] &&
+		!regexec(&sym_regex_c[type], sym_name, 0, NULL, 0);
 }
 
-static void regex_init(void)
+static void regex_init(int use_real_mode)
 {
         char errbuf[128];
         int err;
-	
-        err = regcomp(&abs_sym_regex_c, abs_sym_regex,
-                      REG_EXTENDED|REG_NOSUB);
-        if (err) {
-                regerror(err, &abs_sym_regex_c, errbuf, sizeof errbuf);
-                die("%s", errbuf);
-        }
+	int i;
+
+	if (use_real_mode)
+		sym_regex = sym_regex_realmode;
+	else
+		sym_regex = sym_regex_kernel;
 
-        err = regcomp(&rel_sym_regex_c, rel_sym_regex,
-                      REG_EXTENDED|REG_NOSUB);
-        if (err) {
-                regerror(err, &rel_sym_regex_c, errbuf, sizeof errbuf);
-                die("%s", errbuf);
+	for (i = 0; i < S_NSYMTYPES; i++) {
+		if (!sym_regex[i])
+			continue;
+
+		err = regcomp(&sym_regex_c[i], sym_regex[i],
+			      REG_EXTENDED|REG_NOSUB);
+
+		if (err) {
+			regerror(err, &sym_regex_c[i], errbuf, sizeof errbuf);
+			die("%s", errbuf);
+		}
         }
 }
 
@@ -154,6 +190,10 @@ static const char *rel_type(unsigned type)
 		REL_TYPE(R_386_RELATIVE),
 		REL_TYPE(R_386_GOTOFF),
 		REL_TYPE(R_386_GOTPC),
+		REL_TYPE(R_386_8),
+		REL_TYPE(R_386_PC8),
+		REL_TYPE(R_386_16),
+		REL_TYPE(R_386_PC16),
 #undef REL_TYPE
 	};
 	const char *name = "unknown type rel type name";
@@ -189,7 +229,7 @@ static const char *sym_name(const char *sym_strtab, Elf32_Sym *sym)
 		name = sym_strtab + sym->st_name;
 	}
 	else {
-		name = sec_name(secs[sym->st_shndx].shdr.sh_name);
+		name = sec_name(sym->st_shndx);
 	}
 	return name;
 }
@@ -472,7 +512,7 @@ static void print_absolute_relocs(void)
 			 * Before warning check if this absolute symbol
 			 * relocation is harmless.
 			 */
-			if (is_abs_reloc(name) || is_rel_reloc(name))
+			if (is_reloc(S_ABS, name) || is_reloc(S_REL, name))
 				continue;
 
 			if (!printed) {
@@ -496,7 +536,8 @@ static void print_absolute_relocs(void)
 		printf("\n");
 }
 
-static void walk_relocs(void (*visit)(Elf32_Rel *rel, Elf32_Sym *sym))
+static void walk_relocs(void (*visit)(Elf32_Rel *rel, Elf32_Sym *sym),
+			int use_real_mode)
 {
 	int i;
 	/* Walk through the relocations */
@@ -521,30 +562,67 @@ static void walk_relocs(void (*visit)(Elf32_Rel *rel, Elf32_Sym *sym))
 			Elf32_Rel *rel;
 			Elf32_Sym *sym;
 			unsigned r_type;
+			const char *symname;
+			int shn_abs;
+
 			rel = &sec->reltab[j];
 			sym = &sh_symtab[ELF32_R_SYM(rel->r_info)];
 			r_type = ELF32_R_TYPE(rel->r_info);
-			/* Don't visit relocations to absolute symbols */
-			if (sym->st_shndx == SHN_ABS &&
-			    !is_rel_reloc(sym_name(sym_strtab, sym))) {
-				continue;
-			}
+
+			shn_abs = sym->st_shndx == SHN_ABS;
+
 			switch (r_type) {
 			case R_386_NONE:
 			case R_386_PC32:
+			case R_386_PC16:
+			case R_386_PC8:
 				/*
 				 * NONE can be ignored and and PC relative
 				 * relocations don't need to be adjusted.
 				 */
 				break;
+
+			case R_386_16:
+				symname = sym_name(sym_strtab, sym);
+				if (!use_real_mode)
+					goto bad;
+				if (shn_abs) {
+					if (is_reloc(S_ABS, symname))
+						break;
+					else if (!is_reloc(S_SEG, symname))
+						goto bad;
+				} else {
+					if (is_reloc(S_LIN, symname))
+						goto bad;
+					else
+						break;
+				}
+				visit(rel, sym);
+				break;
+
 			case R_386_32:
-				/* Visit relocations that need to be adjusted */
+				symname = sym_name(sym_strtab, sym);
+				if (shn_abs) {
+					if (is_reloc(S_ABS, symname))
+						break;
+					else if (!is_reloc(S_REL, symname))
+						goto bad;
+				} else {
+					if (use_real_mode &&
+					    !is_reloc(S_LIN, symname))
+						break;
+				}
 				visit(rel, sym);
 				break;
 			default:
 				die("Unsupported relocation type: %s (%d)\n",
 				    rel_type(r_type), r_type);
 				break;
+			bad:
+				symname = sym_name(sym_strtab, sym);
+				die("Invalid %s %s relocation: %s\n",
+				    shn_abs ? "absolute" : "relative",
+				    rel_type(r_type), symname);
 			}
 		}
 	}
@@ -552,13 +630,19 @@ static void walk_relocs(void (*visit)(Elf32_Rel *rel, Elf32_Sym *sym))
 
 static void count_reloc(Elf32_Rel *rel, Elf32_Sym *sym)
 {
-	reloc_count += 1;
+	if (ELF32_R_TYPE(rel->r_info) == R_386_16)
+		reloc16_count++;
+	else
+		reloc_count++;
 }
 
 static void collect_reloc(Elf32_Rel *rel, Elf32_Sym *sym)
 {
 	/* Remember the address that needs to be adjusted. */
-	relocs[reloc_idx++] = rel->r_offset;
+	if (ELF32_R_TYPE(rel->r_info) == R_386_16)
+		relocs16[reloc16_idx++] = rel->r_offset;
+	else
+		relocs[reloc_idx++] = rel->r_offset;
 }
 
 static int cmp_relocs(const void *va, const void *vb)
@@ -568,23 +652,41 @@ static int cmp_relocs(const void *va, const void *vb)
 	return (*a == *b)? 0 : (*a > *b)? 1 : -1;
 }
 
-static void emit_relocs(int as_text)
+static int write32(unsigned int v, FILE *f)
+{
+	unsigned char buf[4];
+
+	put_unaligned_le32(v, buf);
+	return fwrite(buf, 1, 4, f) == 4 ? 0 : -1;
+}
+
+static void emit_relocs(int as_text, int use_real_mode)
 {
 	int i;
 	/* Count how many relocations I have and allocate space for them. */
 	reloc_count = 0;
-	walk_relocs(count_reloc);
+	walk_relocs(count_reloc, use_real_mode);
 	relocs = malloc(reloc_count * sizeof(relocs[0]));
 	if (!relocs) {
 		die("malloc of %d entries for relocs failed\n",
 			reloc_count);
 	}
+
+	relocs16 = malloc(reloc16_count * sizeof(relocs[0]));
+	if (!relocs16) {
+		die("malloc of %d entries for relocs16 failed\n",
+			reloc16_count);
+	}
 	/* Collect up the relocations */
 	reloc_idx = 0;
-	walk_relocs(collect_reloc);
+	walk_relocs(collect_reloc, use_real_mode);
+
+	if (reloc16_count && !use_real_mode)
+		die("Segment relocations found but --realmode not specified\n");
 
 	/* Order the relocations for more efficient processing */
 	qsort(relocs, reloc_count, sizeof(relocs[0]), cmp_relocs);
+	qsort(relocs16, reloc16_count, sizeof(relocs16[0]), cmp_relocs);
 
 	/* Print the relocations */
 	if (as_text) {
@@ -593,58 +695,83 @@ static void emit_relocs(int as_text)
 		 */
 		printf(".section \".data.reloc\",\"a\"\n");
 		printf(".balign 4\n");
-		for (i = 0; i < reloc_count; i++) {
-			printf("\t .long 0x%08lx\n", relocs[i]);
+		if (use_real_mode) {
+			printf("\t.long %lu\n", reloc16_count);
+			for (i = 0; i < reloc16_count; i++)
+				printf("\t.long 0x%08lx\n", relocs16[i]);
+			printf("\t.long %lu\n", reloc_count);
+			for (i = 0; i < reloc_count; i++) {
+				printf("\t.long 0x%08lx\n", relocs[i]);
+			}
+		} else {
+			/* Print a stop */
+			printf("\t.long 0x%08lx\n", (unsigned long)0);
+			for (i = 0; i < reloc_count; i++) {
+				printf("\t.long 0x%08lx\n", relocs[i]);
+			}
 		}
+
 		printf("\n");
 	}
 	else {
-		unsigned char buf[4];
-		/* Print a stop */
-		fwrite("\0\0\0\0", 4, 1, stdout);
-		/* Now print each relocation */
-		for (i = 0; i < reloc_count; i++) {
-			put_unaligned_le32(relocs[i], buf);
-			fwrite(buf, 4, 1, stdout);
+		if (use_real_mode) {
+			write32(reloc16_count, stdout);
+			for (i = 0; i < reloc16_count; i++)
+				write32(relocs16[i], stdout);
+			write32(reloc_count, stdout);
+
+			/* Now print each relocation */
+			for (i = 0; i < reloc_count; i++)
+				write32(relocs[i], stdout);
+		} else {
+			/* Print a stop */
+			write32(0, stdout);
+
+			/* Now print each relocation */
+			for (i = 0; i < reloc_count; i++) {
+				write32(relocs[i], stdout);
+			}
 		}
 	}
 }
 
 static void usage(void)
 {
-	die("relocs [--abs-syms |--abs-relocs | --text] vmlinux\n");
+	die("relocs [--abs-syms|--abs-relocs|--text|--realmode] vmlinux\n");
 }
 
 int main(int argc, char **argv)
 {
 	int show_absolute_syms, show_absolute_relocs;
-	int as_text;
+	int as_text, use_real_mode;
 	const char *fname;
 	FILE *fp;
 	int i;
 
-	regex_init();
-
 	show_absolute_syms = 0;
 	show_absolute_relocs = 0;
 	as_text = 0;
+	use_real_mode = 0;
 	fname = NULL;
 	for (i = 1; i < argc; i++) {
 		char *arg = argv[i];
 		if (*arg == '-') {
-			if (strcmp(argv[1], "--abs-syms") == 0) {
+			if (strcmp(arg, "--abs-syms") == 0) {
 				show_absolute_syms = 1;
 				continue;
 			}
-
-			if (strcmp(argv[1], "--abs-relocs") == 0) {
+			if (strcmp(arg, "--abs-relocs") == 0) {
 				show_absolute_relocs = 1;
 				continue;
 			}
-			else if (strcmp(argv[1], "--text") == 0) {
+			if (strcmp(arg, "--text") == 0) {
 				as_text = 1;
 				continue;
 			}
+			if (strcmp(arg, "--realmode") == 0) {
+				use_real_mode = 1;
+				continue;
+			}
 		}
 		else if (!fname) {
 			fname = arg;
@@ -655,6 +782,7 @@ int main(int argc, char **argv)
 	if (!fname) {
 		usage();
 	}
+	regex_init(use_real_mode);
 	fp = fopen(fname, "r");
 	if (!fp) {
 		die("Cannot open %s: %s\n",
@@ -673,6 +801,6 @@ int main(int argc, char **argv)
 		print_absolute_relocs();
 		return 0;
 	}
-	emit_relocs(as_text);
+	emit_relocs(as_text, use_real_mode);
 	return 0;
 }
diff --git a/scripts/Makefile b/scripts/Makefile
index df7678f..3626666 100644
--- a/scripts/Makefile
+++ b/scripts/Makefile
@@ -8,6 +8,8 @@
 # conmakehash:	 Create arrays for initializing the kernel console tables
 # docproc:       Used in Documentation/DocBook
 
+HOST_EXTRACFLAGS += -I$(srctree)/tools/include
+
 hostprogs-$(CONFIG_KALLSYMS)     += kallsyms
 hostprogs-$(CONFIG_LOGO)         += pnmtologo
 hostprogs-$(CONFIG_VT)           += conmakehash
