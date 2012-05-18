Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754030Ab2ERQLk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 12:11:40 -0400
Received: from terminus.zytor.com ([198.137.202.10]:45167 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751642Ab2ERQLh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 12:11:37 -0400
Message-ID: <4FB674A5.1090100@intel.com>
Date: Fri, 18 May 2012 09:11:17 -0700
From: "H. Peter Anvin" <h.peter.anvin@intel.com>
Organization: Intel Corporation
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "H.J. Lu" <hjl.tools@gmail.com>, Greg KH <gregkh@linuxfoundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Jarkko Sakkinen <jarkko.sakkinen@intel.com>
Subject: Re: Urgent: x86-32 and GNU ld 2.22.52.0.1
References: <4FB67146.9080804@zytor.com>
In-Reply-To: <4FB67146.9080804@zytor.com>
Content-Type: multipart/mixed;
 boundary="------------000702090605070509030205"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------000702090605070509030205
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 05/18/2012 08:56 AM, H. Peter Anvin wrote:
> I need an urgent opinion.  It seems we have an epic mess on our hands.
> 
> GNU ld 2.22.52.0.1 silently changed the semantics of section-relative
> symbols that are part of otherwise empty sections, and silently changes
> them to absolute.  We rely on section-relative symbols staying
> section-relative, and actually have several sections in the linker
> script solely for this purpose.
> 
> The postprocessor for the x86-32 kernel, relocs.c, currently doesn't
> enforce its audited absolute symbols list.  As part of the
> tip:x86/trampoline rework, however, I made it error out rather that
> silently producing bad output.
> 
> Ingo has found that with this particular version of GNU ld, the error
> triggers.  I want to emphasize that this merely catches an error which
> the current version of the tool would have allowed to silently go by,
> which would have (possibly) caused a failure if the kernel was
> subsequently booted in anything but its default location.
> 
> There are a few ways we can deal with this, but I think we need to do
> one or the other:
> 
> 1. We can blacklist this version of GNU ld.
> 2. We can uprev the tool to the one from the tip:x86/trampoline work,
>    with error checking, and give it a list of symbols that should
>    be relative but may end up as absolute.  We risk build errors for
>    some people if the list isn't complete.
> 3. We do a minimal forward-port of the error checking into the current
>    tool.
> 4. We add to the list of relative symbols in the current version of
>    the tool without adding the error checking.
> 
> However, since it seems clear that we're silently producing corrupt
> kernels out of the current build, I think we need a fix for this for 3.4.
> 

For the record, these are the checkins out of the -tip tree.  They are a
little bigger than necessary because they move the tool around to make
it available for reuse, and of course introduce additional functionality.

	-hpa

	

--------------000702090605070509030205
Content-Type: text/x-patch;
 name="0001-x86-relocs-Workaround-for-binutils-2.22.52.0.1-secti.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="0001-x86-relocs-Workaround-for-binutils-2.22.52.0.1-secti.pa";
 filename*1="tch"

>From bea3f8781e30d0abc0bd0da80aa528d44c71959e Mon Sep 17 00:00:00 2001
From: "H. Peter Anvin" <hpa@linux.intel.com>
Date: Fri, 18 May 2012 00:24:09 -0700
Subject: [PATCH] x86, relocs: Workaround for binutils 2.22.52.0.1 section bug

GNU ld 2.22.52.0.1 has a bug that it blindly changes symbols from
section-relative to absolute if they are in a section of zero length.
This turns the symbols __init_begin and __init_end into absolute
symbols.  Let the relocs program know that those should be treated as
relative symbols.

Reported-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
Cc: H.J. Lu <hjl.tools@gmail.com>
---
 arch/x86/tools/relocs.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/tools/relocs.c b/arch/x86/tools/relocs.c
index 74e16bb..4df2854 100644
--- a/arch/x86/tools/relocs.c
+++ b/arch/x86/tools/relocs.c
@@ -56,7 +56,7 @@ static const char * const sym_regex_kernel[S_NSYMTYPES] = {
  * as absolute (typically defined outside any section in the linker script.)
  */
 	[S_REL] =
-	"^_end$",
+	"^(__init_begin|__init_end|_end)$"
 };
 
 
-- 
1.7.6.5


--------------000702090605070509030205
Content-Type: text/x-patch;
 name="0021-x86-realmode-move-relocs-from-scripts-to-arch-x86-to.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="0021-x86-realmode-move-relocs-from-scripts-to-arch-x86-to.pa";
 filename*1="tch"

>From f2604c141a00c00b92b7fd2f9d2455517fdd6c15 Mon Sep 17 00:00:00 2001
From: Jarkko Sakkinen <jarkko.sakkinen@intel.com>
Date: Tue, 8 May 2012 21:22:44 +0300
Subject: [PATCH 21/34] x86, realmode: move relocs from scripts/ to
 arch/x86/tools

Moved relocs tool from scripts/ to arch/x86/tools because
it is architecture specific script. Added new target archscripts
that can be used to build scripts needed building an architecture.

Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@intel.com>
Link: http://lkml.kernel.org/r/1336501366-28617-22-git-send-email-jarkko.sakkinen@intel.com
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
Cc: Sam Ravnborg <sam@ravnborg.org>
Cc: Michal Marek <mmarek@suse.cz>
---
 Makefile                          |    9 +-
 arch/x86/Makefile                 |    3 +
 arch/x86/boot/compressed/Makefile |    4 +-
 arch/x86/realmode/rm/Makefile     |    2 +-
 arch/x86/tools/.gitignore         |    1 +
 arch/x86/tools/Makefile           |    4 +
 arch/x86/tools/relocs.c           |  804 +++++++++++++++++++++++++++++++++++++
 scripts/Makefile                  |    1 -
 scripts/x86-relocs.c              |  804 -------------------------------------
 9 files changed, 821 insertions(+), 811 deletions(-)
 create mode 100644 arch/x86/tools/.gitignore
 create mode 100644 arch/x86/tools/relocs.c
 delete mode 100644 scripts/x86-relocs.c

diff --git a/Makefile b/Makefile
index 9e384ae..ed1bd29 100644
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
index 0435e8a..e398bb5 100644
--- a/arch/x86/boot/compressed/Makefile
+++ b/arch/x86/boot/compressed/Makefile
@@ -42,8 +42,8 @@ $(obj)/vmlinux.bin: vmlinux FORCE
 
 targets += vmlinux.bin.all vmlinux.relocs
 
-CMD_RELOCS = scripts/x86-relocs
-quiet_cmd_relocs = RELOCS $@
+CMD_RELOCS = arch/x86/tools/relocs
+quiet_cmd_relocs = RELOCS  $@
       cmd_relocs = $(CMD_RELOCS) $< > $@;$(CMD_RELOCS) --abs-relocs $<
 $(obj)/vmlinux.relocs: vmlinux FORCE
 	$(call if_changed,relocs)
diff --git a/arch/x86/realmode/rm/Makefile b/arch/x86/realmode/rm/Makefile
index fc8854b..de40bc4 100644
--- a/arch/x86/realmode/rm/Makefile
+++ b/arch/x86/realmode/rm/Makefile
@@ -52,7 +52,7 @@ $(obj)/realmode.bin: $(obj)/realmode.elf
 	$(call if_changed,objcopy)
 
 quiet_cmd_relocs = RELOCS  $@
-      cmd_relocs = scripts/x86-relocs --realmode $< > $@
+      cmd_relocs = arch/x86/tools/relocs --realmode $< > $@
 $(obj)/realmode.relocs: $(obj)/realmode.elf FORCE
 	$(call if_changed,relocs)
 
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
diff --git a/arch/x86/tools/relocs.c b/arch/x86/tools/relocs.c
new file mode 100644
index 0000000..74e16bb
--- /dev/null
+++ b/arch/x86/tools/relocs.c
@@ -0,0 +1,804 @@
+#include <stdio.h>
+#include <stdarg.h>
+#include <stdlib.h>
+#include <stdint.h>
+#include <string.h>
+#include <errno.h>
+#include <unistd.h>
+#include <elf.h>
+#include <byteswap.h>
+#define USE_BSD
+#include <endian.h>
+#include <regex.h>
+#include <tools/le_byteshift.h>
+
+static void die(char *fmt, ...);
+
+#define ARRAY_SIZE(x) (sizeof(x) / sizeof((x)[0]))
+static Elf32_Ehdr ehdr;
+static unsigned long reloc_count, reloc_idx;
+static unsigned long *relocs;
+static unsigned long reloc16_count, reloc16_idx;
+static unsigned long *relocs16;
+
+struct section {
+	Elf32_Shdr     shdr;
+	struct section *link;
+	Elf32_Sym      *symtab;
+	Elf32_Rel      *reltab;
+	char           *strtab;
+};
+static struct section *secs;
+
+enum symtype {
+	S_ABS,
+	S_REL,
+	S_SEG,
+	S_LIN,
+	S_NSYMTYPES
+};
+
+static const char * const sym_regex_kernel[S_NSYMTYPES] = {
+/*
+ * Following symbols have been audited. There values are constant and do
+ * not change if bzImage is loaded at a different physical address than
+ * the address for which it has been compiled. Don't warn user about
+ * absolute relocations present w.r.t these symbols.
+ */
+	[S_ABS] =
+	"^(xen_irq_disable_direct_reloc$|"
+	"xen_save_fl_direct_reloc$|"
+	"VDSO|"
+	"__crc_)",
+
+/*
+ * These symbols are known to be relative, even if the linker marks them
+ * as absolute (typically defined outside any section in the linker script.)
+ */
+	[S_REL] =
+	"^_end$",
+};
+
+
+static const char * const sym_regex_realmode[S_NSYMTYPES] = {
+/*
+ * These symbols are known to be relative, even if the linker marks them
+ * as absolute (typically defined outside any section in the linker script.)
+ */
+	[S_REL] =
+	"^pa_",
+
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
+{
+	return sym_regex[type] &&
+		!regexec(&sym_regex_c[type], sym_name, 0, NULL, 0);
+}
+
+static void regex_init(int use_real_mode)
+{
+        char errbuf[128];
+        int err;
+	int i;
+
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
+        }
+}
+
+static void die(char *fmt, ...)
+{
+	va_list ap;
+	va_start(ap, fmt);
+	vfprintf(stderr, fmt, ap);
+	va_end(ap);
+	exit(1);
+}
+
+static const char *sym_type(unsigned type)
+{
+	static const char *type_name[] = {
+#define SYM_TYPE(X) [X] = #X
+		SYM_TYPE(STT_NOTYPE),
+		SYM_TYPE(STT_OBJECT),
+		SYM_TYPE(STT_FUNC),
+		SYM_TYPE(STT_SECTION),
+		SYM_TYPE(STT_FILE),
+		SYM_TYPE(STT_COMMON),
+		SYM_TYPE(STT_TLS),
+#undef SYM_TYPE
+	};
+	const char *name = "unknown sym type name";
+	if (type < ARRAY_SIZE(type_name)) {
+		name = type_name[type];
+	}
+	return name;
+}
+
+static const char *sym_bind(unsigned bind)
+{
+	static const char *bind_name[] = {
+#define SYM_BIND(X) [X] = #X
+		SYM_BIND(STB_LOCAL),
+		SYM_BIND(STB_GLOBAL),
+		SYM_BIND(STB_WEAK),
+#undef SYM_BIND
+	};
+	const char *name = "unknown sym bind name";
+	if (bind < ARRAY_SIZE(bind_name)) {
+		name = bind_name[bind];
+	}
+	return name;
+}
+
+static const char *sym_visibility(unsigned visibility)
+{
+	static const char *visibility_name[] = {
+#define SYM_VISIBILITY(X) [X] = #X
+		SYM_VISIBILITY(STV_DEFAULT),
+		SYM_VISIBILITY(STV_INTERNAL),
+		SYM_VISIBILITY(STV_HIDDEN),
+		SYM_VISIBILITY(STV_PROTECTED),
+#undef SYM_VISIBILITY
+	};
+	const char *name = "unknown sym visibility name";
+	if (visibility < ARRAY_SIZE(visibility_name)) {
+		name = visibility_name[visibility];
+	}
+	return name;
+}
+
+static const char *rel_type(unsigned type)
+{
+	static const char *type_name[] = {
+#define REL_TYPE(X) [X] = #X
+		REL_TYPE(R_386_NONE),
+		REL_TYPE(R_386_32),
+		REL_TYPE(R_386_PC32),
+		REL_TYPE(R_386_GOT32),
+		REL_TYPE(R_386_PLT32),
+		REL_TYPE(R_386_COPY),
+		REL_TYPE(R_386_GLOB_DAT),
+		REL_TYPE(R_386_JMP_SLOT),
+		REL_TYPE(R_386_RELATIVE),
+		REL_TYPE(R_386_GOTOFF),
+		REL_TYPE(R_386_GOTPC),
+		REL_TYPE(R_386_8),
+		REL_TYPE(R_386_PC8),
+		REL_TYPE(R_386_16),
+		REL_TYPE(R_386_PC16),
+#undef REL_TYPE
+	};
+	const char *name = "unknown type rel type name";
+	if (type < ARRAY_SIZE(type_name) && type_name[type]) {
+		name = type_name[type];
+	}
+	return name;
+}
+
+static const char *sec_name(unsigned shndx)
+{
+	const char *sec_strtab;
+	const char *name;
+	sec_strtab = secs[ehdr.e_shstrndx].strtab;
+	name = "<noname>";
+	if (shndx < ehdr.e_shnum) {
+		name = sec_strtab + secs[shndx].shdr.sh_name;
+	}
+	else if (shndx == SHN_ABS) {
+		name = "ABSOLUTE";
+	}
+	else if (shndx == SHN_COMMON) {
+		name = "COMMON";
+	}
+	return name;
+}
+
+static const char *sym_name(const char *sym_strtab, Elf32_Sym *sym)
+{
+	const char *name;
+	name = "<noname>";
+	if (sym->st_name) {
+		name = sym_strtab + sym->st_name;
+	}
+	else {
+		name = sec_name(sym->st_shndx);
+	}
+	return name;
+}
+
+
+
+#if BYTE_ORDER == LITTLE_ENDIAN
+#define le16_to_cpu(val) (val)
+#define le32_to_cpu(val) (val)
+#endif
+#if BYTE_ORDER == BIG_ENDIAN
+#define le16_to_cpu(val) bswap_16(val)
+#define le32_to_cpu(val) bswap_32(val)
+#endif
+
+static uint16_t elf16_to_cpu(uint16_t val)
+{
+	return le16_to_cpu(val);
+}
+
+static uint32_t elf32_to_cpu(uint32_t val)
+{
+	return le32_to_cpu(val);
+}
+
+static void read_ehdr(FILE *fp)
+{
+	if (fread(&ehdr, sizeof(ehdr), 1, fp) != 1) {
+		die("Cannot read ELF header: %s\n",
+			strerror(errno));
+	}
+	if (memcmp(ehdr.e_ident, ELFMAG, SELFMAG) != 0) {
+		die("No ELF magic\n");
+	}
+	if (ehdr.e_ident[EI_CLASS] != ELFCLASS32) {
+		die("Not a 32 bit executable\n");
+	}
+	if (ehdr.e_ident[EI_DATA] != ELFDATA2LSB) {
+		die("Not a LSB ELF executable\n");
+	}
+	if (ehdr.e_ident[EI_VERSION] != EV_CURRENT) {
+		die("Unknown ELF version\n");
+	}
+	/* Convert the fields to native endian */
+	ehdr.e_type      = elf16_to_cpu(ehdr.e_type);
+	ehdr.e_machine   = elf16_to_cpu(ehdr.e_machine);
+	ehdr.e_version   = elf32_to_cpu(ehdr.e_version);
+	ehdr.e_entry     = elf32_to_cpu(ehdr.e_entry);
+	ehdr.e_phoff     = elf32_to_cpu(ehdr.e_phoff);
+	ehdr.e_shoff     = elf32_to_cpu(ehdr.e_shoff);
+	ehdr.e_flags     = elf32_to_cpu(ehdr.e_flags);
+	ehdr.e_ehsize    = elf16_to_cpu(ehdr.e_ehsize);
+	ehdr.e_phentsize = elf16_to_cpu(ehdr.e_phentsize);
+	ehdr.e_phnum     = elf16_to_cpu(ehdr.e_phnum);
+	ehdr.e_shentsize = elf16_to_cpu(ehdr.e_shentsize);
+	ehdr.e_shnum     = elf16_to_cpu(ehdr.e_shnum);
+	ehdr.e_shstrndx  = elf16_to_cpu(ehdr.e_shstrndx);
+
+	if ((ehdr.e_type != ET_EXEC) && (ehdr.e_type != ET_DYN)) {
+		die("Unsupported ELF header type\n");
+	}
+	if (ehdr.e_machine != EM_386) {
+		die("Not for x86\n");
+	}
+	if (ehdr.e_version != EV_CURRENT) {
+		die("Unknown ELF version\n");
+	}
+	if (ehdr.e_ehsize != sizeof(Elf32_Ehdr)) {
+		die("Bad Elf header size\n");
+	}
+	if (ehdr.e_phentsize != sizeof(Elf32_Phdr)) {
+		die("Bad program header entry\n");
+	}
+	if (ehdr.e_shentsize != sizeof(Elf32_Shdr)) {
+		die("Bad section header entry\n");
+	}
+	if (ehdr.e_shstrndx >= ehdr.e_shnum) {
+		die("String table index out of bounds\n");
+	}
+}
+
+static void read_shdrs(FILE *fp)
+{
+	int i;
+	Elf32_Shdr shdr;
+
+	secs = calloc(ehdr.e_shnum, sizeof(struct section));
+	if (!secs) {
+		die("Unable to allocate %d section headers\n",
+		    ehdr.e_shnum);
+	}
+	if (fseek(fp, ehdr.e_shoff, SEEK_SET) < 0) {
+		die("Seek to %d failed: %s\n",
+			ehdr.e_shoff, strerror(errno));
+	}
+	for (i = 0; i < ehdr.e_shnum; i++) {
+		struct section *sec = &secs[i];
+		if (fread(&shdr, sizeof shdr, 1, fp) != 1)
+			die("Cannot read ELF section headers %d/%d: %s\n",
+			    i, ehdr.e_shnum, strerror(errno));
+		sec->shdr.sh_name      = elf32_to_cpu(shdr.sh_name);
+		sec->shdr.sh_type      = elf32_to_cpu(shdr.sh_type);
+		sec->shdr.sh_flags     = elf32_to_cpu(shdr.sh_flags);
+		sec->shdr.sh_addr      = elf32_to_cpu(shdr.sh_addr);
+		sec->shdr.sh_offset    = elf32_to_cpu(shdr.sh_offset);
+		sec->shdr.sh_size      = elf32_to_cpu(shdr.sh_size);
+		sec->shdr.sh_link      = elf32_to_cpu(shdr.sh_link);
+		sec->shdr.sh_info      = elf32_to_cpu(shdr.sh_info);
+		sec->shdr.sh_addralign = elf32_to_cpu(shdr.sh_addralign);
+		sec->shdr.sh_entsize   = elf32_to_cpu(shdr.sh_entsize);
+		if (sec->shdr.sh_link < ehdr.e_shnum)
+			sec->link = &secs[sec->shdr.sh_link];
+	}
+
+}
+
+static void read_strtabs(FILE *fp)
+{
+	int i;
+	for (i = 0; i < ehdr.e_shnum; i++) {
+		struct section *sec = &secs[i];
+		if (sec->shdr.sh_type != SHT_STRTAB) {
+			continue;
+		}
+		sec->strtab = malloc(sec->shdr.sh_size);
+		if (!sec->strtab) {
+			die("malloc of %d bytes for strtab failed\n",
+				sec->shdr.sh_size);
+		}
+		if (fseek(fp, sec->shdr.sh_offset, SEEK_SET) < 0) {
+			die("Seek to %d failed: %s\n",
+				sec->shdr.sh_offset, strerror(errno));
+		}
+		if (fread(sec->strtab, 1, sec->shdr.sh_size, fp)
+		    != sec->shdr.sh_size) {
+			die("Cannot read symbol table: %s\n",
+				strerror(errno));
+		}
+	}
+}
+
+static void read_symtabs(FILE *fp)
+{
+	int i,j;
+	for (i = 0; i < ehdr.e_shnum; i++) {
+		struct section *sec = &secs[i];
+		if (sec->shdr.sh_type != SHT_SYMTAB) {
+			continue;
+		}
+		sec->symtab = malloc(sec->shdr.sh_size);
+		if (!sec->symtab) {
+			die("malloc of %d bytes for symtab failed\n",
+				sec->shdr.sh_size);
+		}
+		if (fseek(fp, sec->shdr.sh_offset, SEEK_SET) < 0) {
+			die("Seek to %d failed: %s\n",
+				sec->shdr.sh_offset, strerror(errno));
+		}
+		if (fread(sec->symtab, 1, sec->shdr.sh_size, fp)
+		    != sec->shdr.sh_size) {
+			die("Cannot read symbol table: %s\n",
+				strerror(errno));
+		}
+		for (j = 0; j < sec->shdr.sh_size/sizeof(Elf32_Sym); j++) {
+			Elf32_Sym *sym = &sec->symtab[j];
+			sym->st_name  = elf32_to_cpu(sym->st_name);
+			sym->st_value = elf32_to_cpu(sym->st_value);
+			sym->st_size  = elf32_to_cpu(sym->st_size);
+			sym->st_shndx = elf16_to_cpu(sym->st_shndx);
+		}
+	}
+}
+
+
+static void read_relocs(FILE *fp)
+{
+	int i,j;
+	for (i = 0; i < ehdr.e_shnum; i++) {
+		struct section *sec = &secs[i];
+		if (sec->shdr.sh_type != SHT_REL) {
+			continue;
+		}
+		sec->reltab = malloc(sec->shdr.sh_size);
+		if (!sec->reltab) {
+			die("malloc of %d bytes for relocs failed\n",
+				sec->shdr.sh_size);
+		}
+		if (fseek(fp, sec->shdr.sh_offset, SEEK_SET) < 0) {
+			die("Seek to %d failed: %s\n",
+				sec->shdr.sh_offset, strerror(errno));
+		}
+		if (fread(sec->reltab, 1, sec->shdr.sh_size, fp)
+		    != sec->shdr.sh_size) {
+			die("Cannot read symbol table: %s\n",
+				strerror(errno));
+		}
+		for (j = 0; j < sec->shdr.sh_size/sizeof(Elf32_Rel); j++) {
+			Elf32_Rel *rel = &sec->reltab[j];
+			rel->r_offset = elf32_to_cpu(rel->r_offset);
+			rel->r_info   = elf32_to_cpu(rel->r_info);
+		}
+	}
+}
+
+
+static void print_absolute_symbols(void)
+{
+	int i;
+	printf("Absolute symbols\n");
+	printf(" Num:    Value Size  Type       Bind        Visibility  Name\n");
+	for (i = 0; i < ehdr.e_shnum; i++) {
+		struct section *sec = &secs[i];
+		char *sym_strtab;
+		int j;
+
+		if (sec->shdr.sh_type != SHT_SYMTAB) {
+			continue;
+		}
+		sym_strtab = sec->link->strtab;
+		for (j = 0; j < sec->shdr.sh_size/sizeof(Elf32_Sym); j++) {
+			Elf32_Sym *sym;
+			const char *name;
+			sym = &sec->symtab[j];
+			name = sym_name(sym_strtab, sym);
+			if (sym->st_shndx != SHN_ABS) {
+				continue;
+			}
+			printf("%5d %08x %5d %10s %10s %12s %s\n",
+				j, sym->st_value, sym->st_size,
+				sym_type(ELF32_ST_TYPE(sym->st_info)),
+				sym_bind(ELF32_ST_BIND(sym->st_info)),
+				sym_visibility(ELF32_ST_VISIBILITY(sym->st_other)),
+				name);
+		}
+	}
+	printf("\n");
+}
+
+static void print_absolute_relocs(void)
+{
+	int i, printed = 0;
+
+	for (i = 0; i < ehdr.e_shnum; i++) {
+		struct section *sec = &secs[i];
+		struct section *sec_applies, *sec_symtab;
+		char *sym_strtab;
+		Elf32_Sym *sh_symtab;
+		int j;
+		if (sec->shdr.sh_type != SHT_REL) {
+			continue;
+		}
+		sec_symtab  = sec->link;
+		sec_applies = &secs[sec->shdr.sh_info];
+		if (!(sec_applies->shdr.sh_flags & SHF_ALLOC)) {
+			continue;
+		}
+		sh_symtab  = sec_symtab->symtab;
+		sym_strtab = sec_symtab->link->strtab;
+		for (j = 0; j < sec->shdr.sh_size/sizeof(Elf32_Rel); j++) {
+			Elf32_Rel *rel;
+			Elf32_Sym *sym;
+			const char *name;
+			rel = &sec->reltab[j];
+			sym = &sh_symtab[ELF32_R_SYM(rel->r_info)];
+			name = sym_name(sym_strtab, sym);
+			if (sym->st_shndx != SHN_ABS) {
+				continue;
+			}
+
+			/* Absolute symbols are not relocated if bzImage is
+			 * loaded at a non-compiled address. Display a warning
+			 * to user at compile time about the absolute
+			 * relocations present.
+			 *
+			 * User need to audit the code to make sure
+			 * some symbols which should have been section
+			 * relative have not become absolute because of some
+			 * linker optimization or wrong programming usage.
+			 *
+			 * Before warning check if this absolute symbol
+			 * relocation is harmless.
+			 */
+			if (is_reloc(S_ABS, name) || is_reloc(S_REL, name))
+				continue;
+
+			if (!printed) {
+				printf("WARNING: Absolute relocations"
+					" present\n");
+				printf("Offset     Info     Type     Sym.Value "
+					"Sym.Name\n");
+				printed = 1;
+			}
+
+			printf("%08x %08x %10s %08x  %s\n",
+				rel->r_offset,
+				rel->r_info,
+				rel_type(ELF32_R_TYPE(rel->r_info)),
+				sym->st_value,
+				name);
+		}
+	}
+
+	if (printed)
+		printf("\n");
+}
+
+static void walk_relocs(void (*visit)(Elf32_Rel *rel, Elf32_Sym *sym),
+			int use_real_mode)
+{
+	int i;
+	/* Walk through the relocations */
+	for (i = 0; i < ehdr.e_shnum; i++) {
+		char *sym_strtab;
+		Elf32_Sym *sh_symtab;
+		struct section *sec_applies, *sec_symtab;
+		int j;
+		struct section *sec = &secs[i];
+
+		if (sec->shdr.sh_type != SHT_REL) {
+			continue;
+		}
+		sec_symtab  = sec->link;
+		sec_applies = &secs[sec->shdr.sh_info];
+		if (!(sec_applies->shdr.sh_flags & SHF_ALLOC)) {
+			continue;
+		}
+		sh_symtab = sec_symtab->symtab;
+		sym_strtab = sec_symtab->link->strtab;
+		for (j = 0; j < sec->shdr.sh_size/sizeof(Elf32_Rel); j++) {
+			Elf32_Rel *rel;
+			Elf32_Sym *sym;
+			unsigned r_type;
+			const char *symname;
+			rel = &sec->reltab[j];
+			sym = &sh_symtab[ELF32_R_SYM(rel->r_info)];
+			r_type = ELF32_R_TYPE(rel->r_info);
+
+			switch (r_type) {
+			case R_386_NONE:
+			case R_386_PC32:
+			case R_386_PC16:
+			case R_386_PC8:
+				/*
+				 * NONE can be ignored and and PC relative
+				 * relocations don't need to be adjusted.
+				 */
+				break;
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
+			case R_386_32:
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
+				visit(rel, sym);
+				break;
+			default:
+				die("Unsupported relocation type: %s (%d)\n",
+				    rel_type(r_type), r_type);
+				break;
+			bad:
+				symname = sym_name(sym_strtab, sym);
+				die("Invalid %s relocation: %s\n",
+				    rel_type(r_type), symname);
+			}
+		}
+	}
+}
+
+static void count_reloc(Elf32_Rel *rel, Elf32_Sym *sym)
+{
+	if (ELF32_R_TYPE(rel->r_info) == R_386_16)
+		reloc16_count++;
+	else
+		reloc_count++;
+}
+
+static void collect_reloc(Elf32_Rel *rel, Elf32_Sym *sym)
+{
+	/* Remember the address that needs to be adjusted. */
+	if (ELF32_R_TYPE(rel->r_info) == R_386_16)
+		relocs16[reloc16_idx++] = rel->r_offset;
+	else
+		relocs[reloc_idx++] = rel->r_offset;
+}
+
+static int cmp_relocs(const void *va, const void *vb)
+{
+	const unsigned long *a, *b;
+	a = va; b = vb;
+	return (*a == *b)? 0 : (*a > *b)? 1 : -1;
+}
+
+static int write32(unsigned int v, FILE *f)
+{
+	unsigned char buf[4];
+
+	put_unaligned_le32(v, buf);
+	return fwrite(buf, 1, 4, f) == 4 ? 0 : -1;
+}
+
+static void emit_relocs(int as_text, int use_real_mode)
+{
+	int i;
+	/* Count how many relocations I have and allocate space for them. */
+	reloc_count = 0;
+	walk_relocs(count_reloc, use_real_mode);
+	relocs = malloc(reloc_count * sizeof(relocs[0]));
+	if (!relocs) {
+		die("malloc of %d entries for relocs failed\n",
+			reloc_count);
+	}
+
+	relocs16 = malloc(reloc16_count * sizeof(relocs[0]));
+	if (!relocs16) {
+		die("malloc of %d entries for relocs16 failed\n",
+			reloc16_count);
+	}
+	/* Collect up the relocations */
+	reloc_idx = 0;
+	walk_relocs(collect_reloc, use_real_mode);
+
+	if (reloc16_count && !use_real_mode)
+		die("Segment relocations found but --realmode not specified\n");
+
+	/* Order the relocations for more efficient processing */
+	qsort(relocs, reloc_count, sizeof(relocs[0]), cmp_relocs);
+	qsort(relocs16, reloc16_count, sizeof(relocs16[0]), cmp_relocs);
+
+	/* Print the relocations */
+	if (as_text) {
+		/* Print the relocations in a form suitable that
+		 * gas will like.
+		 */
+		printf(".section \".data.reloc\",\"a\"\n");
+		printf(".balign 4\n");
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
+		}
+
+		printf("\n");
+	}
+	else {
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
+		}
+	}
+}
+
+static void usage(void)
+{
+	die("relocs [--abs-syms|--abs-relocs|--text|--realmode] vmlinux\n");
+}
+
+int main(int argc, char **argv)
+{
+	int show_absolute_syms, show_absolute_relocs;
+	int as_text, use_real_mode;
+	const char *fname;
+	FILE *fp;
+	int i;
+
+	show_absolute_syms = 0;
+	show_absolute_relocs = 0;
+	as_text = 0;
+	use_real_mode = 0;
+	fname = NULL;
+	for (i = 1; i < argc; i++) {
+		char *arg = argv[i];
+		if (*arg == '-') {
+			if (strcmp(arg, "--abs-syms") == 0) {
+				show_absolute_syms = 1;
+				continue;
+			}
+			if (strcmp(arg, "--abs-relocs") == 0) {
+				show_absolute_relocs = 1;
+				continue;
+			}
+			if (strcmp(arg, "--text") == 0) {
+				as_text = 1;
+				continue;
+			}
+			if (strcmp(arg, "--realmode") == 0) {
+				use_real_mode = 1;
+				continue;
+			}
+		}
+		else if (!fname) {
+			fname = arg;
+			continue;
+		}
+		usage();
+	}
+	if (!fname) {
+		usage();
+	}
+	regex_init(use_real_mode);
+	fp = fopen(fname, "r");
+	if (!fp) {
+		die("Cannot open %s: %s\n",
+			fname, strerror(errno));
+	}
+	read_ehdr(fp);
+	read_shdrs(fp);
+	read_strtabs(fp);
+	read_symtabs(fp);
+	read_relocs(fp);
+	if (show_absolute_syms) {
+		print_absolute_symbols();
+		return 0;
+	}
+	if (show_absolute_relocs) {
+		print_absolute_relocs();
+		return 0;
+	}
+	emit_relocs(as_text, use_real_mode);
+	return 0;
+}
diff --git a/scripts/Makefile b/scripts/Makefile
index a241359d..3626666 100644
--- a/scripts/Makefile
+++ b/scripts/Makefile
@@ -15,7 +15,6 @@ hostprogs-$(CONFIG_LOGO)         += pnmtologo
 hostprogs-$(CONFIG_VT)           += conmakehash
 hostprogs-$(CONFIG_IKCONFIG)     += bin2c
 hostprogs-$(BUILD_C_RECORDMCOUNT) += recordmcount
-hostprogs-$(CONFIG_X86)          += x86-relocs
 
 always		:= $(hostprogs-y) $(hostprogs-m)
 
diff --git a/scripts/x86-relocs.c b/scripts/x86-relocs.c
deleted file mode 100644
index 74e16bb..0000000
--- a/scripts/x86-relocs.c
+++ /dev/null
@@ -1,804 +0,0 @@
-#include <stdio.h>
-#include <stdarg.h>
-#include <stdlib.h>
-#include <stdint.h>
-#include <string.h>
-#include <errno.h>
-#include <unistd.h>
-#include <elf.h>
-#include <byteswap.h>
-#define USE_BSD
-#include <endian.h>
-#include <regex.h>
-#include <tools/le_byteshift.h>
-
-static void die(char *fmt, ...);
-
-#define ARRAY_SIZE(x) (sizeof(x) / sizeof((x)[0]))
-static Elf32_Ehdr ehdr;
-static unsigned long reloc_count, reloc_idx;
-static unsigned long *relocs;
-static unsigned long reloc16_count, reloc16_idx;
-static unsigned long *relocs16;
-
-struct section {
-	Elf32_Shdr     shdr;
-	struct section *link;
-	Elf32_Sym      *symtab;
-	Elf32_Rel      *reltab;
-	char           *strtab;
-};
-static struct section *secs;
-
-enum symtype {
-	S_ABS,
-	S_REL,
-	S_SEG,
-	S_LIN,
-	S_NSYMTYPES
-};
-
-static const char * const sym_regex_kernel[S_NSYMTYPES] = {
-/*
- * Following symbols have been audited. There values are constant and do
- * not change if bzImage is loaded at a different physical address than
- * the address for which it has been compiled. Don't warn user about
- * absolute relocations present w.r.t these symbols.
- */
-	[S_ABS] =
-	"^(xen_irq_disable_direct_reloc$|"
-	"xen_save_fl_direct_reloc$|"
-	"VDSO|"
-	"__crc_)",
-
-/*
- * These symbols are known to be relative, even if the linker marks them
- * as absolute (typically defined outside any section in the linker script.)
- */
-	[S_REL] =
-	"^_end$",
-};
-
-
-static const char * const sym_regex_realmode[S_NSYMTYPES] = {
-/*
- * These symbols are known to be relative, even if the linker marks them
- * as absolute (typically defined outside any section in the linker script.)
- */
-	[S_REL] =
-	"^pa_",
-
-/*
- * These are 16-bit segment symbols when compiling 16-bit code.
- */
-	[S_SEG] =
-	"^real_mode_seg$",
-
-/*
- * These are offsets belonging to segments, as opposed to linear addresses,
- * when compiling 16-bit code.
- */
-	[S_LIN] =
-	"^pa_",
-};
-
-static const char * const *sym_regex;
-
-static regex_t sym_regex_c[S_NSYMTYPES];
-static int is_reloc(enum symtype type, const char *sym_name)
-{
-	return sym_regex[type] &&
-		!regexec(&sym_regex_c[type], sym_name, 0, NULL, 0);
-}
-
-static void regex_init(int use_real_mode)
-{
-        char errbuf[128];
-        int err;
-	int i;
-
-	if (use_real_mode)
-		sym_regex = sym_regex_realmode;
-	else
-		sym_regex = sym_regex_kernel;
-
-	for (i = 0; i < S_NSYMTYPES; i++) {
-		if (!sym_regex[i])
-			continue;
-
-		err = regcomp(&sym_regex_c[i], sym_regex[i],
-			      REG_EXTENDED|REG_NOSUB);
-
-		if (err) {
-			regerror(err, &sym_regex_c[i], errbuf, sizeof errbuf);
-			die("%s", errbuf);
-		}
-        }
-}
-
-static void die(char *fmt, ...)
-{
-	va_list ap;
-	va_start(ap, fmt);
-	vfprintf(stderr, fmt, ap);
-	va_end(ap);
-	exit(1);
-}
-
-static const char *sym_type(unsigned type)
-{
-	static const char *type_name[] = {
-#define SYM_TYPE(X) [X] = #X
-		SYM_TYPE(STT_NOTYPE),
-		SYM_TYPE(STT_OBJECT),
-		SYM_TYPE(STT_FUNC),
-		SYM_TYPE(STT_SECTION),
-		SYM_TYPE(STT_FILE),
-		SYM_TYPE(STT_COMMON),
-		SYM_TYPE(STT_TLS),
-#undef SYM_TYPE
-	};
-	const char *name = "unknown sym type name";
-	if (type < ARRAY_SIZE(type_name)) {
-		name = type_name[type];
-	}
-	return name;
-}
-
-static const char *sym_bind(unsigned bind)
-{
-	static const char *bind_name[] = {
-#define SYM_BIND(X) [X] = #X
-		SYM_BIND(STB_LOCAL),
-		SYM_BIND(STB_GLOBAL),
-		SYM_BIND(STB_WEAK),
-#undef SYM_BIND
-	};
-	const char *name = "unknown sym bind name";
-	if (bind < ARRAY_SIZE(bind_name)) {
-		name = bind_name[bind];
-	}
-	return name;
-}
-
-static const char *sym_visibility(unsigned visibility)
-{
-	static const char *visibility_name[] = {
-#define SYM_VISIBILITY(X) [X] = #X
-		SYM_VISIBILITY(STV_DEFAULT),
-		SYM_VISIBILITY(STV_INTERNAL),
-		SYM_VISIBILITY(STV_HIDDEN),
-		SYM_VISIBILITY(STV_PROTECTED),
-#undef SYM_VISIBILITY
-	};
-	const char *name = "unknown sym visibility name";
-	if (visibility < ARRAY_SIZE(visibility_name)) {
-		name = visibility_name[visibility];
-	}
-	return name;
-}
-
-static const char *rel_type(unsigned type)
-{
-	static const char *type_name[] = {
-#define REL_TYPE(X) [X] = #X
-		REL_TYPE(R_386_NONE),
-		REL_TYPE(R_386_32),
-		REL_TYPE(R_386_PC32),
-		REL_TYPE(R_386_GOT32),
-		REL_TYPE(R_386_PLT32),
-		REL_TYPE(R_386_COPY),
-		REL_TYPE(R_386_GLOB_DAT),
-		REL_TYPE(R_386_JMP_SLOT),
-		REL_TYPE(R_386_RELATIVE),
-		REL_TYPE(R_386_GOTOFF),
-		REL_TYPE(R_386_GOTPC),
-		REL_TYPE(R_386_8),
-		REL_TYPE(R_386_PC8),
-		REL_TYPE(R_386_16),
-		REL_TYPE(R_386_PC16),
-#undef REL_TYPE
-	};
-	const char *name = "unknown type rel type name";
-	if (type < ARRAY_SIZE(type_name) && type_name[type]) {
-		name = type_name[type];
-	}
-	return name;
-}
-
-static const char *sec_name(unsigned shndx)
-{
-	const char *sec_strtab;
-	const char *name;
-	sec_strtab = secs[ehdr.e_shstrndx].strtab;
-	name = "<noname>";
-	if (shndx < ehdr.e_shnum) {
-		name = sec_strtab + secs[shndx].shdr.sh_name;
-	}
-	else if (shndx == SHN_ABS) {
-		name = "ABSOLUTE";
-	}
-	else if (shndx == SHN_COMMON) {
-		name = "COMMON";
-	}
-	return name;
-}
-
-static const char *sym_name(const char *sym_strtab, Elf32_Sym *sym)
-{
-	const char *name;
-	name = "<noname>";
-	if (sym->st_name) {
-		name = sym_strtab + sym->st_name;
-	}
-	else {
-		name = sec_name(sym->st_shndx);
-	}
-	return name;
-}
-
-
-
-#if BYTE_ORDER == LITTLE_ENDIAN
-#define le16_to_cpu(val) (val)
-#define le32_to_cpu(val) (val)
-#endif
-#if BYTE_ORDER == BIG_ENDIAN
-#define le16_to_cpu(val) bswap_16(val)
-#define le32_to_cpu(val) bswap_32(val)
-#endif
-
-static uint16_t elf16_to_cpu(uint16_t val)
-{
-	return le16_to_cpu(val);
-}
-
-static uint32_t elf32_to_cpu(uint32_t val)
-{
-	return le32_to_cpu(val);
-}
-
-static void read_ehdr(FILE *fp)
-{
-	if (fread(&ehdr, sizeof(ehdr), 1, fp) != 1) {
-		die("Cannot read ELF header: %s\n",
-			strerror(errno));
-	}
-	if (memcmp(ehdr.e_ident, ELFMAG, SELFMAG) != 0) {
-		die("No ELF magic\n");
-	}
-	if (ehdr.e_ident[EI_CLASS] != ELFCLASS32) {
-		die("Not a 32 bit executable\n");
-	}
-	if (ehdr.e_ident[EI_DATA] != ELFDATA2LSB) {
-		die("Not a LSB ELF executable\n");
-	}
-	if (ehdr.e_ident[EI_VERSION] != EV_CURRENT) {
-		die("Unknown ELF version\n");
-	}
-	/* Convert the fields to native endian */
-	ehdr.e_type      = elf16_to_cpu(ehdr.e_type);
-	ehdr.e_machine   = elf16_to_cpu(ehdr.e_machine);
-	ehdr.e_version   = elf32_to_cpu(ehdr.e_version);
-	ehdr.e_entry     = elf32_to_cpu(ehdr.e_entry);
-	ehdr.e_phoff     = elf32_to_cpu(ehdr.e_phoff);
-	ehdr.e_shoff     = elf32_to_cpu(ehdr.e_shoff);
-	ehdr.e_flags     = elf32_to_cpu(ehdr.e_flags);
-	ehdr.e_ehsize    = elf16_to_cpu(ehdr.e_ehsize);
-	ehdr.e_phentsize = elf16_to_cpu(ehdr.e_phentsize);
-	ehdr.e_phnum     = elf16_to_cpu(ehdr.e_phnum);
-	ehdr.e_shentsize = elf16_to_cpu(ehdr.e_shentsize);
-	ehdr.e_shnum     = elf16_to_cpu(ehdr.e_shnum);
-	ehdr.e_shstrndx  = elf16_to_cpu(ehdr.e_shstrndx);
-
-	if ((ehdr.e_type != ET_EXEC) && (ehdr.e_type != ET_DYN)) {
-		die("Unsupported ELF header type\n");
-	}
-	if (ehdr.e_machine != EM_386) {
-		die("Not for x86\n");
-	}
-	if (ehdr.e_version != EV_CURRENT) {
-		die("Unknown ELF version\n");
-	}
-	if (ehdr.e_ehsize != sizeof(Elf32_Ehdr)) {
-		die("Bad Elf header size\n");
-	}
-	if (ehdr.e_phentsize != sizeof(Elf32_Phdr)) {
-		die("Bad program header entry\n");
-	}
-	if (ehdr.e_shentsize != sizeof(Elf32_Shdr)) {
-		die("Bad section header entry\n");
-	}
-	if (ehdr.e_shstrndx >= ehdr.e_shnum) {
-		die("String table index out of bounds\n");
-	}
-}
-
-static void read_shdrs(FILE *fp)
-{
-	int i;
-	Elf32_Shdr shdr;
-
-	secs = calloc(ehdr.e_shnum, sizeof(struct section));
-	if (!secs) {
-		die("Unable to allocate %d section headers\n",
-		    ehdr.e_shnum);
-	}
-	if (fseek(fp, ehdr.e_shoff, SEEK_SET) < 0) {
-		die("Seek to %d failed: %s\n",
-			ehdr.e_shoff, strerror(errno));
-	}
-	for (i = 0; i < ehdr.e_shnum; i++) {
-		struct section *sec = &secs[i];
-		if (fread(&shdr, sizeof shdr, 1, fp) != 1)
-			die("Cannot read ELF section headers %d/%d: %s\n",
-			    i, ehdr.e_shnum, strerror(errno));
-		sec->shdr.sh_name      = elf32_to_cpu(shdr.sh_name);
-		sec->shdr.sh_type      = elf32_to_cpu(shdr.sh_type);
-		sec->shdr.sh_flags     = elf32_to_cpu(shdr.sh_flags);
-		sec->shdr.sh_addr      = elf32_to_cpu(shdr.sh_addr);
-		sec->shdr.sh_offset    = elf32_to_cpu(shdr.sh_offset);
-		sec->shdr.sh_size      = elf32_to_cpu(shdr.sh_size);
-		sec->shdr.sh_link      = elf32_to_cpu(shdr.sh_link);
-		sec->shdr.sh_info      = elf32_to_cpu(shdr.sh_info);
-		sec->shdr.sh_addralign = elf32_to_cpu(shdr.sh_addralign);
-		sec->shdr.sh_entsize   = elf32_to_cpu(shdr.sh_entsize);
-		if (sec->shdr.sh_link < ehdr.e_shnum)
-			sec->link = &secs[sec->shdr.sh_link];
-	}
-
-}
-
-static void read_strtabs(FILE *fp)
-{
-	int i;
-	for (i = 0; i < ehdr.e_shnum; i++) {
-		struct section *sec = &secs[i];
-		if (sec->shdr.sh_type != SHT_STRTAB) {
-			continue;
-		}
-		sec->strtab = malloc(sec->shdr.sh_size);
-		if (!sec->strtab) {
-			die("malloc of %d bytes for strtab failed\n",
-				sec->shdr.sh_size);
-		}
-		if (fseek(fp, sec->shdr.sh_offset, SEEK_SET) < 0) {
-			die("Seek to %d failed: %s\n",
-				sec->shdr.sh_offset, strerror(errno));
-		}
-		if (fread(sec->strtab, 1, sec->shdr.sh_size, fp)
-		    != sec->shdr.sh_size) {
-			die("Cannot read symbol table: %s\n",
-				strerror(errno));
-		}
-	}
-}
-
-static void read_symtabs(FILE *fp)
-{
-	int i,j;
-	for (i = 0; i < ehdr.e_shnum; i++) {
-		struct section *sec = &secs[i];
-		if (sec->shdr.sh_type != SHT_SYMTAB) {
-			continue;
-		}
-		sec->symtab = malloc(sec->shdr.sh_size);
-		if (!sec->symtab) {
-			die("malloc of %d bytes for symtab failed\n",
-				sec->shdr.sh_size);
-		}
-		if (fseek(fp, sec->shdr.sh_offset, SEEK_SET) < 0) {
-			die("Seek to %d failed: %s\n",
-				sec->shdr.sh_offset, strerror(errno));
-		}
-		if (fread(sec->symtab, 1, sec->shdr.sh_size, fp)
-		    != sec->shdr.sh_size) {
-			die("Cannot read symbol table: %s\n",
-				strerror(errno));
-		}
-		for (j = 0; j < sec->shdr.sh_size/sizeof(Elf32_Sym); j++) {
-			Elf32_Sym *sym = &sec->symtab[j];
-			sym->st_name  = elf32_to_cpu(sym->st_name);
-			sym->st_value = elf32_to_cpu(sym->st_value);
-			sym->st_size  = elf32_to_cpu(sym->st_size);
-			sym->st_shndx = elf16_to_cpu(sym->st_shndx);
-		}
-	}
-}
-
-
-static void read_relocs(FILE *fp)
-{
-	int i,j;
-	for (i = 0; i < ehdr.e_shnum; i++) {
-		struct section *sec = &secs[i];
-		if (sec->shdr.sh_type != SHT_REL) {
-			continue;
-		}
-		sec->reltab = malloc(sec->shdr.sh_size);
-		if (!sec->reltab) {
-			die("malloc of %d bytes for relocs failed\n",
-				sec->shdr.sh_size);
-		}
-		if (fseek(fp, sec->shdr.sh_offset, SEEK_SET) < 0) {
-			die("Seek to %d failed: %s\n",
-				sec->shdr.sh_offset, strerror(errno));
-		}
-		if (fread(sec->reltab, 1, sec->shdr.sh_size, fp)
-		    != sec->shdr.sh_size) {
-			die("Cannot read symbol table: %s\n",
-				strerror(errno));
-		}
-		for (j = 0; j < sec->shdr.sh_size/sizeof(Elf32_Rel); j++) {
-			Elf32_Rel *rel = &sec->reltab[j];
-			rel->r_offset = elf32_to_cpu(rel->r_offset);
-			rel->r_info   = elf32_to_cpu(rel->r_info);
-		}
-	}
-}
-
-
-static void print_absolute_symbols(void)
-{
-	int i;
-	printf("Absolute symbols\n");
-	printf(" Num:    Value Size  Type       Bind        Visibility  Name\n");
-	for (i = 0; i < ehdr.e_shnum; i++) {
-		struct section *sec = &secs[i];
-		char *sym_strtab;
-		int j;
-
-		if (sec->shdr.sh_type != SHT_SYMTAB) {
-			continue;
-		}
-		sym_strtab = sec->link->strtab;
-		for (j = 0; j < sec->shdr.sh_size/sizeof(Elf32_Sym); j++) {
-			Elf32_Sym *sym;
-			const char *name;
-			sym = &sec->symtab[j];
-			name = sym_name(sym_strtab, sym);
-			if (sym->st_shndx != SHN_ABS) {
-				continue;
-			}
-			printf("%5d %08x %5d %10s %10s %12s %s\n",
-				j, sym->st_value, sym->st_size,
-				sym_type(ELF32_ST_TYPE(sym->st_info)),
-				sym_bind(ELF32_ST_BIND(sym->st_info)),
-				sym_visibility(ELF32_ST_VISIBILITY(sym->st_other)),
-				name);
-		}
-	}
-	printf("\n");
-}
-
-static void print_absolute_relocs(void)
-{
-	int i, printed = 0;
-
-	for (i = 0; i < ehdr.e_shnum; i++) {
-		struct section *sec = &secs[i];
-		struct section *sec_applies, *sec_symtab;
-		char *sym_strtab;
-		Elf32_Sym *sh_symtab;
-		int j;
-		if (sec->shdr.sh_type != SHT_REL) {
-			continue;
-		}
-		sec_symtab  = sec->link;
-		sec_applies = &secs[sec->shdr.sh_info];
-		if (!(sec_applies->shdr.sh_flags & SHF_ALLOC)) {
-			continue;
-		}
-		sh_symtab  = sec_symtab->symtab;
-		sym_strtab = sec_symtab->link->strtab;
-		for (j = 0; j < sec->shdr.sh_size/sizeof(Elf32_Rel); j++) {
-			Elf32_Rel *rel;
-			Elf32_Sym *sym;
-			const char *name;
-			rel = &sec->reltab[j];
-			sym = &sh_symtab[ELF32_R_SYM(rel->r_info)];
-			name = sym_name(sym_strtab, sym);
-			if (sym->st_shndx != SHN_ABS) {
-				continue;
-			}
-
-			/* Absolute symbols are not relocated if bzImage is
-			 * loaded at a non-compiled address. Display a warning
-			 * to user at compile time about the absolute
-			 * relocations present.
-			 *
-			 * User need to audit the code to make sure
-			 * some symbols which should have been section
-			 * relative have not become absolute because of some
-			 * linker optimization or wrong programming usage.
-			 *
-			 * Before warning check if this absolute symbol
-			 * relocation is harmless.
-			 */
-			if (is_reloc(S_ABS, name) || is_reloc(S_REL, name))
-				continue;
-
-			if (!printed) {
-				printf("WARNING: Absolute relocations"
-					" present\n");
-				printf("Offset     Info     Type     Sym.Value "
-					"Sym.Name\n");
-				printed = 1;
-			}
-
-			printf("%08x %08x %10s %08x  %s\n",
-				rel->r_offset,
-				rel->r_info,
-				rel_type(ELF32_R_TYPE(rel->r_info)),
-				sym->st_value,
-				name);
-		}
-	}
-
-	if (printed)
-		printf("\n");
-}
-
-static void walk_relocs(void (*visit)(Elf32_Rel *rel, Elf32_Sym *sym),
-			int use_real_mode)
-{
-	int i;
-	/* Walk through the relocations */
-	for (i = 0; i < ehdr.e_shnum; i++) {
-		char *sym_strtab;
-		Elf32_Sym *sh_symtab;
-		struct section *sec_applies, *sec_symtab;
-		int j;
-		struct section *sec = &secs[i];
-
-		if (sec->shdr.sh_type != SHT_REL) {
-			continue;
-		}
-		sec_symtab  = sec->link;
-		sec_applies = &secs[sec->shdr.sh_info];
-		if (!(sec_applies->shdr.sh_flags & SHF_ALLOC)) {
-			continue;
-		}
-		sh_symtab = sec_symtab->symtab;
-		sym_strtab = sec_symtab->link->strtab;
-		for (j = 0; j < sec->shdr.sh_size/sizeof(Elf32_Rel); j++) {
-			Elf32_Rel *rel;
-			Elf32_Sym *sym;
-			unsigned r_type;
-			const char *symname;
-			rel = &sec->reltab[j];
-			sym = &sh_symtab[ELF32_R_SYM(rel->r_info)];
-			r_type = ELF32_R_TYPE(rel->r_info);
-
-			switch (r_type) {
-			case R_386_NONE:
-			case R_386_PC32:
-			case R_386_PC16:
-			case R_386_PC8:
-				/*
-				 * NONE can be ignored and and PC relative
-				 * relocations don't need to be adjusted.
-				 */
-				break;
-
-			case R_386_16:
-				symname = sym_name(sym_strtab, sym);
-				if (!use_real_mode)
-					goto bad;
-				if (sym->st_shndx == SHN_ABS) {
-					if (is_reloc(S_ABS, symname))
-						break;
-					else if (!is_reloc(S_SEG, symname))
-						goto bad;
-				} else {
-					if (is_reloc(S_LIN, symname))
-						goto bad;
-					else
-						break;
-				}
-				visit(rel, sym);
-				break;
-
-			case R_386_32:
-				symname = sym_name(sym_strtab, sym);
-				if (sym->st_shndx == SHN_ABS) {
-					if (is_reloc(S_ABS, symname))
-						break;
-					else if (!is_reloc(S_REL, symname))
-						goto bad;
-				} else {
-					if (use_real_mode &&
-					    !is_reloc(S_LIN, symname))
-						break;
-				}
-				visit(rel, sym);
-				break;
-			default:
-				die("Unsupported relocation type: %s (%d)\n",
-				    rel_type(r_type), r_type);
-				break;
-			bad:
-				symname = sym_name(sym_strtab, sym);
-				die("Invalid %s relocation: %s\n",
-				    rel_type(r_type), symname);
-			}
-		}
-	}
-}
-
-static void count_reloc(Elf32_Rel *rel, Elf32_Sym *sym)
-{
-	if (ELF32_R_TYPE(rel->r_info) == R_386_16)
-		reloc16_count++;
-	else
-		reloc_count++;
-}
-
-static void collect_reloc(Elf32_Rel *rel, Elf32_Sym *sym)
-{
-	/* Remember the address that needs to be adjusted. */
-	if (ELF32_R_TYPE(rel->r_info) == R_386_16)
-		relocs16[reloc16_idx++] = rel->r_offset;
-	else
-		relocs[reloc_idx++] = rel->r_offset;
-}
-
-static int cmp_relocs(const void *va, const void *vb)
-{
-	const unsigned long *a, *b;
-	a = va; b = vb;
-	return (*a == *b)? 0 : (*a > *b)? 1 : -1;
-}
-
-static int write32(unsigned int v, FILE *f)
-{
-	unsigned char buf[4];
-
-	put_unaligned_le32(v, buf);
-	return fwrite(buf, 1, 4, f) == 4 ? 0 : -1;
-}
-
-static void emit_relocs(int as_text, int use_real_mode)
-{
-	int i;
-	/* Count how many relocations I have and allocate space for them. */
-	reloc_count = 0;
-	walk_relocs(count_reloc, use_real_mode);
-	relocs = malloc(reloc_count * sizeof(relocs[0]));
-	if (!relocs) {
-		die("malloc of %d entries for relocs failed\n",
-			reloc_count);
-	}
-
-	relocs16 = malloc(reloc16_count * sizeof(relocs[0]));
-	if (!relocs16) {
-		die("malloc of %d entries for relocs16 failed\n",
-			reloc16_count);
-	}
-	/* Collect up the relocations */
-	reloc_idx = 0;
-	walk_relocs(collect_reloc, use_real_mode);
-
-	if (reloc16_count && !use_real_mode)
-		die("Segment relocations found but --realmode not specified\n");
-
-	/* Order the relocations for more efficient processing */
-	qsort(relocs, reloc_count, sizeof(relocs[0]), cmp_relocs);
-	qsort(relocs16, reloc16_count, sizeof(relocs16[0]), cmp_relocs);
-
-	/* Print the relocations */
-	if (as_text) {
-		/* Print the relocations in a form suitable that
-		 * gas will like.
-		 */
-		printf(".section \".data.reloc\",\"a\"\n");
-		printf(".balign 4\n");
-		if (use_real_mode) {
-			printf("\t.long %lu\n", reloc16_count);
-			for (i = 0; i < reloc16_count; i++)
-				printf("\t.long 0x%08lx\n", relocs16[i]);
-			printf("\t.long %lu\n", reloc_count);
-			for (i = 0; i < reloc_count; i++) {
-				printf("\t.long 0x%08lx\n", relocs[i]);
-			}
-		} else {
-			/* Print a stop */
-			printf("\t.long 0x%08lx\n", (unsigned long)0);
-			for (i = 0; i < reloc_count; i++) {
-				printf("\t.long 0x%08lx\n", relocs[i]);
-			}
-		}
-
-		printf("\n");
-	}
-	else {
-		if (use_real_mode) {
-			write32(reloc16_count, stdout);
-			for (i = 0; i < reloc16_count; i++)
-				write32(relocs16[i], stdout);
-			write32(reloc_count, stdout);
-
-			/* Now print each relocation */
-			for (i = 0; i < reloc_count; i++)
-				write32(relocs[i], stdout);
-		} else {
-			/* Print a stop */
-			write32(0, stdout);
-
-			/* Now print each relocation */
-			for (i = 0; i < reloc_count; i++) {
-				write32(relocs[i], stdout);
-			}
-		}
-	}
-}
-
-static void usage(void)
-{
-	die("relocs [--abs-syms|--abs-relocs|--text|--realmode] vmlinux\n");
-}
-
-int main(int argc, char **argv)
-{
-	int show_absolute_syms, show_absolute_relocs;
-	int as_text, use_real_mode;
-	const char *fname;
-	FILE *fp;
-	int i;
-
-	show_absolute_syms = 0;
-	show_absolute_relocs = 0;
-	as_text = 0;
-	use_real_mode = 0;
-	fname = NULL;
-	for (i = 1; i < argc; i++) {
-		char *arg = argv[i];
-		if (*arg == '-') {
-			if (strcmp(arg, "--abs-syms") == 0) {
-				show_absolute_syms = 1;
-				continue;
-			}
-			if (strcmp(arg, "--abs-relocs") == 0) {
-				show_absolute_relocs = 1;
-				continue;
-			}
-			if (strcmp(arg, "--text") == 0) {
-				as_text = 1;
-				continue;
-			}
-			if (strcmp(arg, "--realmode") == 0) {
-				use_real_mode = 1;
-				continue;
-			}
-		}
-		else if (!fname) {
-			fname = arg;
-			continue;
-		}
-		usage();
-	}
-	if (!fname) {
-		usage();
-	}
-	regex_init(use_real_mode);
-	fp = fopen(fname, "r");
-	if (!fp) {
-		die("Cannot open %s: %s\n",
-			fname, strerror(errno));
-	}
-	read_ehdr(fp);
-	read_shdrs(fp);
-	read_strtabs(fp);
-	read_symtabs(fp);
-	read_relocs(fp);
-	if (show_absolute_syms) {
-		print_absolute_symbols();
-		return 0;
-	}
-	if (show_absolute_relocs) {
-		print_absolute_relocs();
-		return 0;
-	}
-	emit_relocs(as_text, use_real_mode);
-	return 0;
-}
-- 
1.7.6.5


--------------000702090605070509030205
Content-Type: text/x-patch;
 name="0033-x86-relocs-Workaround-for-binutils-2.22.52.0.1-secti.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="0033-x86-relocs-Workaround-for-binutils-2.22.52.0.1-secti.pa";
 filename*1="tch"

>From bea3f8781e30d0abc0bd0da80aa528d44c71959e Mon Sep 17 00:00:00 2001
From: "H. Peter Anvin" <hpa@linux.intel.com>
Date: Fri, 18 May 2012 00:24:09 -0700
Subject: [PATCH 33/34] x86, relocs: Workaround for binutils 2.22.52.0.1
 section bug

GNU ld 2.22.52.0.1 has a bug that it blindly changes symbols from
section-relative to absolute if they are in a section of zero length.
This turns the symbols __init_begin and __init_end into absolute
symbols.  Let the relocs program know that those should be treated as
relative symbols.

Reported-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
Cc: H.J. Lu <hjl.tools@gmail.com>
---
 arch/x86/tools/relocs.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/tools/relocs.c b/arch/x86/tools/relocs.c
index 74e16bb..4df2854 100644
--- a/arch/x86/tools/relocs.c
+++ b/arch/x86/tools/relocs.c
@@ -56,7 +56,7 @@ static const char * const sym_regex_kernel[S_NSYMTYPES] = {
  * as absolute (typically defined outside any section in the linker script.)
  */
 	[S_REL] =
-	"^_end$",
+	"^(__init_begin|__init_end|_end)$"
 };
 
 
-- 
1.7.6.5


--------------000702090605070509030205
Content-Type: text/x-patch;
 name="0034-x86-relocs-More-relocations-which-may-end-up-as-abso.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="0034-x86-relocs-More-relocations-which-may-end-up-as-abso.pa";
 filename*1="tch"

>From c54a354c1835e7412a53458891b9ea05361b4e8a Mon Sep 17 00:00:00 2001
From: "H. Peter Anvin" <hpa@linux.intel.com>
Date: Fri, 18 May 2012 08:31:44 -0700
Subject: [PATCH 34/34] x86, relocs: More relocations which may end up as
 absolute

GNU ld 2.22.52.0.1 has a bug that it blindly changes symbols from
section-relative to absolute if they are in a section of zero length.
This turns the symbols __init_begin and __init_end into absolute
symbols.  Let the relocs program know that those should be treated as
relative symbols.

This bug is exposed by checkin

433de739bbc2 x86, realmode: 16-bit real-mode code support for relocs tool

only in the sense that that checkin changes the relocs tool to report
an error instead of silently generating a kernel which is broken if
relocated.

Reported-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
Cc: H.J. Lu <hjl.tools@gmail.com>
Cc: Jarkko Sakkinen <jarkko.sakkinen@intel.com>
---
 arch/x86/tools/relocs.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/arch/x86/tools/relocs.c b/arch/x86/tools/relocs.c
index 4df2854..b49c211 100644
--- a/arch/x86/tools/relocs.c
+++ b/arch/x86/tools/relocs.c
@@ -56,7 +56,11 @@ static const char * const sym_regex_kernel[S_NSYMTYPES] = {
  * as absolute (typically defined outside any section in the linker script.)
  */
 	[S_REL] =
-	"^(__init_begin|__init_end|_end)$"
+	"^(__init_(begin|end)|"
+	"__x86_cpu_dev_(start|end)|"
+	"(__parainstructions|__alt_instructions)(|_end)|"
+	"(__iommu_table|__apicdrivers|__smp_locks)(|_end)|"
+	"_end)$"
 };
 
 
-- 
1.7.6.5


--------------000702090605070509030205--
