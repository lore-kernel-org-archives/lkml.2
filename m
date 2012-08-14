Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752169Ab2HNPOG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2012 11:14:06 -0400
Received: from eddie.linux-mips.org ([78.24.191.182]:51341 "EHLO
	cvs.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751109Ab2HNPOE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2012 11:14:04 -0400
Date: Tue, 14 Aug 2012 17:13:45 +0200
From: Ralf Baechle <ralf@linux-mips.org>
To: David Howells <dhowells@redhat.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>,
        Jonas Gorski <jonas.gorski@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-mips@linux-mips.org
Subject: [PATCH] MIPS: Fix module.c build for 32 bit
Message-ID: <20120814151345.GB30856@linux-mips.org>
References: <87d32us55c.fsf@rustcorp.com.au>
 <1344332473-19842-1-git-send-email-jonas.gorski@gmail.com>
 <31154.1344872382@warthog.procyon.org.uk>
 <32504.1344953290@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <32504.1344953290@warthog.procyon.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixes build failure introduced by "Make most arch asm/module.h files use
asm-generic/module.h" by moving all the RELA processing code to a
separate file to be used only for RELA processing on 64-bit kernels.

  CC      arch/mips/kernel/module.o
arch/mips/kernel/module.c:250:14: error: 'reloc_handlers_rela' defined but not 
used [-Werror=unused-variable]
cc1: all warnings being treated as errors

make[6]: *** [arch/mips/kernel/module.o] Error 1

Signed-off-by: Ralf Baechle <ralf@linux-mips.org>

---
This is bigger than Jonas' suggested patch but far less #ifdefy.
A minimal fix would be to add __maybe_unused to the definition of
reloc_handlers_rela but imho __maybe_unused should be avoided where
possible.

I tested this on top of today's -next but ideally to keep bisectability
it should be applied early in the series before CONFIG_MODULES_USE_ELF_RELA
is introduced which would require trivial tweaking arch/mips/kernel/Makefile
tweaking.

 arch/mips/kernel/Makefile      |   1 +
 arch/mips/kernel/module-rela.c | 145 +++++++++++++++++++++++++++++++++++++++++
 arch/mips/kernel/module.c      | 123 +---------------------------------
 3 files changed, 147 insertions(+), 122 deletions(-)

diff --git a/arch/mips/kernel/Makefile b/arch/mips/kernel/Makefile
index fdaf65e..cd1e6c2 100644
--- a/arch/mips/kernel/Makefile
+++ b/arch/mips/kernel/Makefile
@@ -31,6 +31,7 @@ obj-$(CONFIG_SYNC_R4K)		+= sync-r4k.o
 
 obj-$(CONFIG_STACKTRACE)	+= stacktrace.o
 obj-$(CONFIG_MODULES)		+= mips_ksyms.o module.o
+obj-$(CONFIG_MODULES_USE_ELF_RELA) += module-rela.o
 
 obj-$(CONFIG_FUNCTION_TRACER)	+= mcount.o ftrace.o
 
diff --git a/arch/mips/kernel/module-rela.c b/arch/mips/kernel/module-rela.c
new file mode 100644
index 0000000..61d6002
--- /dev/null
+++ b/arch/mips/kernel/module-rela.c
@@ -0,0 +1,145 @@
+/*
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License as published by
+ *  the Free Software Foundation; either version 2 of the License, or
+ *  (at your option) any later version.
+ *
+ *  This program is distributed in the hope that it will be useful,
+ *  but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ *  GNU General Public License for more details.
+ *
+ *  You should have received a copy of the GNU General Public License
+ *  along with this program; if not, write to the Free Software
+ *  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
+ *
+ *  Copyright (C) 2001 Rusty Russell.
+ *  Copyright (C) 2003, 2004 Ralf Baechle (ralf@linux-mips.org)
+ *  Copyright (C) 2005 Thiemo Seufer
+ */
+
+#include <linux/elf.h>
+#include <linux/err.h>
+#include <linux/errno.h>
+#include <linux/moduleloader.h>
+
+extern int apply_r_mips_none(struct module *me, u32 *location, Elf_Addr v);
+
+static int apply_r_mips_32_rela(struct module *me, u32 *location, Elf_Addr v)
+{
+	*location = v;
+
+	return 0;
+}
+
+static int apply_r_mips_26_rela(struct module *me, u32 *location, Elf_Addr v)
+{
+	if (v % 4) {
+		pr_err("module %s: dangerous R_MIPS_26 RELArelocation\n",
+		       me->name);
+		return -ENOEXEC;
+	}
+
+	if ((v & 0xf0000000) != (((unsigned long)location + 4) & 0xf0000000)) {
+		printk(KERN_ERR
+		       "module %s: relocation overflow\n",
+		       me->name);
+		return -ENOEXEC;
+	}
+
+	*location = (*location & ~0x03ffffff) | ((v >> 2) & 0x03ffffff);
+
+	return 0;
+}
+
+static int apply_r_mips_hi16_rela(struct module *me, u32 *location, Elf_Addr v)
+{
+	*location = (*location & 0xffff0000) |
+	            ((((long long) v + 0x8000LL) >> 16) & 0xffff);
+
+	return 0;
+}
+
+static int apply_r_mips_lo16_rela(struct module *me, u32 *location, Elf_Addr v)
+{
+	*location = (*location & 0xffff0000) | (v & 0xffff);
+
+	return 0;
+}
+
+static int apply_r_mips_64_rela(struct module *me, u32 *location, Elf_Addr v)
+{
+	*(Elf_Addr *)location = v;
+
+	return 0;
+}
+
+static int apply_r_mips_higher_rela(struct module *me, u32 *location,
+				    Elf_Addr v)
+{
+	*location = (*location & 0xffff0000) |
+	            ((((long long) v + 0x80008000LL) >> 32) & 0xffff);
+
+	return 0;
+}
+
+static int apply_r_mips_highest_rela(struct module *me, u32 *location,
+				     Elf_Addr v)
+{
+	*location = (*location & 0xffff0000) |
+	            ((((long long) v + 0x800080008000LL) >> 48) & 0xffff);
+
+	return 0;
+}
+
+static int (*reloc_handlers_rela[]) (struct module *me, u32 *location,
+				Elf_Addr v) = {
+	[R_MIPS_NONE]		= apply_r_mips_none,
+	[R_MIPS_32]		= apply_r_mips_32_rela,
+	[R_MIPS_26]		= apply_r_mips_26_rela,
+	[R_MIPS_HI16]		= apply_r_mips_hi16_rela,
+	[R_MIPS_LO16]		= apply_r_mips_lo16_rela,
+	[R_MIPS_64]		= apply_r_mips_64_rela,
+	[R_MIPS_HIGHER]		= apply_r_mips_higher_rela,
+	[R_MIPS_HIGHEST]	= apply_r_mips_highest_rela
+};
+
+int apply_relocate_add(Elf_Shdr *sechdrs, const char *strtab,
+		       unsigned int symindex, unsigned int relsec,
+		       struct module *me)
+{
+	Elf_Mips_Rela *rel = (void *) sechdrs[relsec].sh_addr;
+	Elf_Sym *sym;
+	u32 *location;
+	unsigned int i;
+	Elf_Addr v;
+	int res;
+
+	pr_debug("Applying relocate section %u to %u\n", relsec,
+	       sechdrs[relsec].sh_info);
+
+	for (i = 0; i < sechdrs[relsec].sh_size / sizeof(*rel); i++) {
+		/* This is where to make the change */
+		location = (void *)sechdrs[sechdrs[relsec].sh_info].sh_addr
+			+ rel[i].r_offset;
+		/* This is the symbol it is referring to */
+		sym = (Elf_Sym *)sechdrs[symindex].sh_addr
+			+ ELF_MIPS_R_SYM(rel[i]);
+		if (IS_ERR_VALUE(sym->st_value)) {
+			/* Ignore unresolved weak symbol */
+			if (ELF_ST_BIND(sym->st_info) == STB_WEAK)
+				continue;
+			printk(KERN_WARNING "%s: Unknown symbol %s\n",
+			       me->name, strtab + sym->st_name);
+			return -ENOENT;
+		}
+
+		v = sym->st_value + rel[i].r_addend;
+
+		res = reloc_handlers_rela[ELF_MIPS_R_TYPE(rel[i])](me, location, v);
+		if (res)
+			return res;
+	}
+
+	return 0;
+}
diff --git a/arch/mips/kernel/module.c b/arch/mips/kernel/module.c
index 1500c80..da6dcd9 100644
--- a/arch/mips/kernel/module.c
+++ b/arch/mips/kernel/module.c
@@ -53,7 +53,7 @@ void *module_alloc(unsigned long size)
 }
 #endif
 
-static int apply_r_mips_none(struct module *me, u32 *location, Elf_Addr v)
+int apply_r_mips_none(struct module *me, u32 *location, Elf_Addr v)
 {
 	return 0;
 }
@@ -65,13 +65,6 @@ static int apply_r_mips_32_rel(struct module *me, u32 *location, Elf_Addr v)
 	return 0;
 }
 
-static int apply_r_mips_32_rela(struct module *me, u32 *location, Elf_Addr v)
-{
-	*location = v;
-
-	return 0;
-}
-
 static int apply_r_mips_26_rel(struct module *me, u32 *location, Elf_Addr v)
 {
 	if (v % 4) {
@@ -93,26 +86,6 @@ static int apply_r_mips_26_rel(struct module *me, u32 *location, Elf_Addr v)
 	return 0;
 }
 
-static int apply_r_mips_26_rela(struct module *me, u32 *location, Elf_Addr v)
-{
-	if (v % 4) {
-		pr_err("module %s: dangerous R_MIPS_26 RELArelocation\n",
-		       me->name);
-		return -ENOEXEC;
-	}
-
-	if ((v & 0xf0000000) != (((unsigned long)location + 4) & 0xf0000000)) {
-		printk(KERN_ERR
-		       "module %s: relocation overflow\n",
-		       me->name);
-		return -ENOEXEC;
-	}
-
-	*location = (*location & ~0x03ffffff) | ((v >> 2) & 0x03ffffff);
-
-	return 0;
-}
-
 static int apply_r_mips_hi16_rel(struct module *me, u32 *location, Elf_Addr v)
 {
 	struct mips_hi16 *n;
@@ -134,14 +107,6 @@ static int apply_r_mips_hi16_rel(struct module *me, u32 *location, Elf_Addr v)
 	return 0;
 }
 
-static int apply_r_mips_hi16_rela(struct module *me, u32 *location, Elf_Addr v)
-{
-	*location = (*location & 0xffff0000) |
-	            ((((long long) v + 0x8000LL) >> 16) & 0xffff);
-
-	return 0;
-}
-
 static int apply_r_mips_lo16_rel(struct module *me, u32 *location, Elf_Addr v)
 {
 	unsigned long insnlo = *location;
@@ -206,38 +171,6 @@ out_danger:
 	return -ENOEXEC;
 }
 
-static int apply_r_mips_lo16_rela(struct module *me, u32 *location, Elf_Addr v)
-{
-	*location = (*location & 0xffff0000) | (v & 0xffff);
-
-	return 0;
-}
-
-static int apply_r_mips_64_rela(struct module *me, u32 *location, Elf_Addr v)
-{
-	*(Elf_Addr *)location = v;
-
-	return 0;
-}
-
-static int apply_r_mips_higher_rela(struct module *me, u32 *location,
-				    Elf_Addr v)
-{
-	*location = (*location & 0xffff0000) |
-	            ((((long long) v + 0x80008000LL) >> 32) & 0xffff);
-
-	return 0;
-}
-
-static int apply_r_mips_highest_rela(struct module *me, u32 *location,
-				     Elf_Addr v)
-{
-	*location = (*location & 0xffff0000) |
-	            ((((long long) v + 0x800080008000LL) >> 48) & 0xffff);
-
-	return 0;
-}
-
 static int (*reloc_handlers_rel[]) (struct module *me, u32 *location,
 				Elf_Addr v) = {
 	[R_MIPS_NONE]		= apply_r_mips_none,
@@ -247,18 +180,6 @@ static int (*reloc_handlers_rel[]) (struct module *me, u32 *location,
 	[R_MIPS_LO16]		= apply_r_mips_lo16_rel
 };
 
-static int (*reloc_handlers_rela[]) (struct module *me, u32 *location,
-				Elf_Addr v) = {
-	[R_MIPS_NONE]		= apply_r_mips_none,
-	[R_MIPS_32]		= apply_r_mips_32_rela,
-	[R_MIPS_26]		= apply_r_mips_26_rela,
-	[R_MIPS_HI16]		= apply_r_mips_hi16_rela,
-	[R_MIPS_LO16]		= apply_r_mips_lo16_rela,
-	[R_MIPS_64]		= apply_r_mips_64_rela,
-	[R_MIPS_HIGHER]		= apply_r_mips_higher_rela,
-	[R_MIPS_HIGHEST]	= apply_r_mips_highest_rela
-};
-
 int apply_relocate(Elf_Shdr *sechdrs, const char *strtab,
 		   unsigned int symindex, unsigned int relsec,
 		   struct module *me)
@@ -299,48 +220,6 @@ int apply_relocate(Elf_Shdr *sechdrs, const char *strtab,
 	return 0;
 }
 
-#ifdef CONFIG_MODULES_USE_ELF_RELA
-int apply_relocate_add(Elf_Shdr *sechdrs, const char *strtab,
-		       unsigned int symindex, unsigned int relsec,
-		       struct module *me)
-{
-	Elf_Mips_Rela *rel = (void *) sechdrs[relsec].sh_addr;
-	Elf_Sym *sym;
-	u32 *location;
-	unsigned int i;
-	Elf_Addr v;
-	int res;
-
-	pr_debug("Applying relocate section %u to %u\n", relsec,
-	       sechdrs[relsec].sh_info);
-
-	for (i = 0; i < sechdrs[relsec].sh_size / sizeof(*rel); i++) {
-		/* This is where to make the change */
-		location = (void *)sechdrs[sechdrs[relsec].sh_info].sh_addr
-			+ rel[i].r_offset;
-		/* This is the symbol it is referring to */
-		sym = (Elf_Sym *)sechdrs[symindex].sh_addr
-			+ ELF_MIPS_R_SYM(rel[i]);
-		if (IS_ERR_VALUE(sym->st_value)) {
-			/* Ignore unresolved weak symbol */
-			if (ELF_ST_BIND(sym->st_info) == STB_WEAK)
-				continue;
-			printk(KERN_WARNING "%s: Unknown symbol %s\n",
-			       me->name, strtab + sym->st_name);
-			return -ENOENT;
-		}
-
-		v = sym->st_value + rel[i].r_addend;
-
-		res = reloc_handlers_rela[ELF_MIPS_R_TYPE(rel[i])](me, location, v);
-		if (res)
-			return res;
-	}
-
-	return 0;
-}
-#endif
-
 /* Given an address, look for it in the module exception tables. */
 const struct exception_table_entry *search_module_dbetables(unsigned long addr)
 {
