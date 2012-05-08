Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757239Ab2EHWOJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2012 18:14:09 -0400
Received: from terminus.zytor.com ([198.137.202.10]:34392 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752438Ab2EHWOG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2012 18:14:06 -0400
Date: Tue, 8 May 2012 15:13:53 -0700
From: "tip-bot for H. Peter Anvin" <hpa@linux.intel.com>
Message-ID: <tip-433de739bbc22a5b2c87602116566ce27e3b4cab@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        jarkko.sakkinen@intel.com, tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, jarkko.sakkinen@intel.com, hpa@linux.intel.com
In-Reply-To: <1336501366-28617-2-git-send-email-jarkko.sakkinen@intel.com>
References: <1336501366-28617-2-git-send-email-jarkko.sakkinen@intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/trampoline] x86, realmode:
  16-bit real-mode code support for relocs tool
Git-Commit-ID: 433de739bbc22a5b2c87602116566ce27e3b4cab
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Tue, 08 May 2012 15:14:00 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  433de739bbc22a5b2c87602116566ce27e3b4cab
Gitweb:     http://git.kernel.org/tip/433de739bbc22a5b2c87602116566ce27e3b4cab
Author:     H. Peter Anvin <hpa@linux.intel.com>
AuthorDate: Tue, 8 May 2012 21:22:24 +0300
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Tue, 8 May 2012 11:41:43 -0700

x86, realmode: 16-bit real-mode code support for relocs tool

A new option is added to the relocs tool called '--realmode'.
This option causes the generation of 16-bit segment relocations
and 32-bit linear relocations for the real-mode code. When
the real-mode code is moved to the low-memory during kernel
initialization, these relocation entries can be used to
relocate the code properly.

In the assembly code 16-bit segment relocations must be relative
to the 'real_mode_seg' absolute symbol. Linear relocations must be
relative to a symbol prefixed with 'pa_'.

16-bit segment relocation is used to load cs:ip in 16-bit code.
Linear relocations are used in the 32-bit code for relocatable
data references. They are declared in the linker script of the
real-mode code.

The relocs tool is moved to scripts/x86-relocs.c so it will
be compiled before building the arch/x86 tree.

Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
Link: http://lkml.kernel.org/r/1336501366-28617-2-git-send-email-jarkko.sakkinen@intel.com
Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@intel.com>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/boot/compressed/Makefile                  |   11 +-
 scripts/.gitignore                                 |    1 +
 scripts/Makefile                                   |    3 +
 .../compressed/relocs.c => scripts/x86-relocs.c    |  233 +++++++++++++++-----
 4 files changed, 185 insertions(+), 63 deletions(-)

diff --git a/arch/x86/boot/compressed/Makefile b/arch/x86/boot/compressed/Makefile
index fd55a2f..0435e8a 100644
--- a/arch/x86/boot/compressed/Makefile
+++ b/arch/x86/boot/compressed/Makefile
@@ -40,13 +40,12 @@ OBJCOPYFLAGS_vmlinux.bin :=  -R .comment -S
 $(obj)/vmlinux.bin: vmlinux FORCE
 	$(call if_changed,objcopy)
 
+targets += vmlinux.bin.all vmlinux.relocs
 
-targets += vmlinux.bin.all vmlinux.relocs relocs
-hostprogs-$(CONFIG_X86_NEED_RELOCS) += relocs
-
-quiet_cmd_relocs = RELOCS  $@
-      cmd_relocs = $(obj)/relocs $< > $@;$(obj)/relocs --abs-relocs $<
-$(obj)/vmlinux.relocs: vmlinux $(obj)/relocs FORCE
+CMD_RELOCS = scripts/x86-relocs
+quiet_cmd_relocs = RELOCS $@
+      cmd_relocs = $(CMD_RELOCS) $< > $@;$(CMD_RELOCS) --abs-relocs $<
+$(obj)/vmlinux.relocs: vmlinux FORCE
 	$(call if_changed,relocs)
 
 vmlinux.bin.all-y := $(obj)/vmlinux.bin
diff --git a/scripts/.gitignore b/scripts/.gitignore
index 105b21f..68c0f32 100644
--- a/scripts/.gitignore
+++ b/scripts/.gitignore
@@ -9,3 +9,4 @@ unifdef
 ihex2fw
 recordmcount
 docproc
+x86-relocs
diff --git a/scripts/Makefile b/scripts/Makefile
index df7678f..a241359d 100644
--- a/scripts/Makefile
+++ b/scripts/Makefile
@@ -8,11 +8,14 @@
 # conmakehash:	 Create arrays for initializing the kernel console tables
 # docproc:       Used in Documentation/DocBook
 
+HOST_EXTRACFLAGS += -I$(srctree)/tools/include
+
 hostprogs-$(CONFIG_KALLSYMS)     += kallsyms
 hostprogs-$(CONFIG_LOGO)         += pnmtologo
 hostprogs-$(CONFIG_VT)           += conmakehash
 hostprogs-$(CONFIG_IKCONFIG)     += bin2c
 hostprogs-$(BUILD_C_RECORDMCOUNT) += recordmcount
+hostprogs-$(CONFIG_X86)          += x86-relocs
 
 always		:= $(hostprogs-y) $(hostprogs-m)
 
diff --git a/arch/x86/boot/compressed/relocs.c b/scripts/x86-relocs.c
similarity index 77%
rename from arch/x86/boot/compressed/relocs.c
rename to scripts/x86-relocs.c
index fb7117a..0291470 100644
--- a/arch/x86/boot/compressed/relocs.c
+++ b/scripts/x86-relocs.c
@@ -18,6 +18,8 @@ static void die(char *fmt, ...);
 static Elf32_Ehdr ehdr;
 static unsigned long reloc_count, reloc_idx;
 static unsigned long *relocs;
+static unsigned long reloc16_count, reloc16_idx;
+static unsigned long *relocs16;
 
 struct section {
 	Elf32_Shdr     shdr;
@@ -28,52 +30,82 @@ struct section {
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
+	"^_end$",
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
 
-        err = regcomp(&rel_sym_regex_c, rel_sym_regex,
-                      REG_EXTENDED|REG_NOSUB);
-        if (err) {
-                regerror(err, &rel_sym_regex_c, errbuf, sizeof errbuf);
-                die("%s", errbuf);
+	if (use_real_mode)
+		sym_regex = sym_regex_realmode;
+	else
+		sym_regex = sym_regex_kernel;
+
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
 
@@ -154,6 +186,10 @@ static const char *rel_type(unsigned type)
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
@@ -189,7 +225,7 @@ static const char *sym_name(const char *sym_strtab, Elf32_Sym *sym)
 		name = sym_strtab + sym->st_name;
 	}
 	else {
-		name = sec_name(secs[sym->st_shndx].shdr.sh_name);
+		name = sec_name(sym->st_shndx);
 	}
 	return name;
 }
@@ -472,7 +508,7 @@ static void print_absolute_relocs(void)
 			 * Before warning check if this absolute symbol
 			 * relocation is harmless.
 			 */
-			if (is_abs_reloc(name) || is_rel_reloc(name))
+			if (is_reloc(S_ABS, name) || is_reloc(S_REL, name))
 				continue;
 
 			if (!printed) {
@@ -496,7 +532,8 @@ static void print_absolute_relocs(void)
 		printf("\n");
 }
 
-static void walk_relocs(void (*visit)(Elf32_Rel *rel, Elf32_Sym *sym))
+static void walk_relocs(void (*visit)(Elf32_Rel *rel, Elf32_Sym *sym),
+			int use_real_mode)
 {
 	int i;
 	/* Walk through the relocations */
@@ -521,30 +558,62 @@ static void walk_relocs(void (*visit)(Elf32_Rel *rel, Elf32_Sym *sym))
 			Elf32_Rel *rel;
 			Elf32_Sym *sym;
 			unsigned r_type;
+			const char *symname;
 			rel = &sec->reltab[j];
 			sym = &sh_symtab[ELF32_R_SYM(rel->r_info)];
 			r_type = ELF32_R_TYPE(rel->r_info);
-			/* Don't visit relocations to absolute symbols */
-			if (sym->st_shndx == SHN_ABS &&
-			    !is_rel_reloc(sym_name(sym_strtab, sym))) {
-				continue;
-			}
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
+				if (sym->st_shndx == SHN_ABS) {
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
+				if (sym->st_shndx == SHN_ABS) {
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
+				die("Invalid %s relocation: %s\n",
+				    rel_type(r_type), symname);
 			}
 		}
 	}
@@ -552,13 +621,19 @@ static void walk_relocs(void (*visit)(Elf32_Rel *rel, Elf32_Sym *sym))
 
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
@@ -568,23 +643,41 @@ static int cmp_relocs(const void *va, const void *vb)
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
@@ -593,58 +686,83 @@ static void emit_relocs(int as_text)
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
@@ -655,6 +773,7 @@ int main(int argc, char **argv)
 	if (!fname) {
 		usage();
 	}
+	regex_init(use_real_mode);
 	fp = fopen(fname, "r");
 	if (!fp) {
 		die("Cannot open %s: %s\n",
@@ -673,6 +792,6 @@ int main(int argc, char **argv)
 		print_absolute_relocs();
 		return 0;
 	}
-	emit_relocs(as_text);
+	emit_relocs(as_text, use_real_mode);
 	return 0;
 }
