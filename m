Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752670Ab1KEBAz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Nov 2011 21:00:55 -0400
Received: from [69.28.251.93] ([69.28.251.93]:55314 "EHLO b32.net"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752454Ab1KEBAy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Nov 2011 21:00:54 -0400
From: Kevin Cernekee <cernekee@gmail.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org,
        Jan Beulich <JBeulich@novell.com>
Subject: [PATCH] module: Fix performance regression on modules with large
 symbol tables
Date: Fri, 04 Nov 2011 17:48:58 -0700
Message-Id: <467be983bed865e1b772136ed488f9ff@localhost>
User-Agent: vim 7.2
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 554bdfe5acf3715e87c8d5e25a4f9a896ac9f014 (module: reduce string
table for loaded modules) introduced an optimization to shrink the size of
the resident string table.  Part of this involves calling bitmap_weight()
on the strmap bitmap once for each core symbol.  strmap contains one bit
for each byte of the module's strtab.

For kernel modules with a large number of symbols, the addition of the
bitmap_weight() operation to each iteration of the add_kallsyms() loop
resulted in a significant "insmod" performance regression from 2.6.31
to 2.6.32.  bitmap_weight() is expensive when the bitmap is large.

The proposed alternative optimizes the common case in this loop
(is_core_symbol() == true, and the symbol name is not a duplicate), while
penalizing the exceptional case of a duplicate symbol.

My test was run on a 600 MHz MIPS processor, using a kernel module with
15,000 "core" symbols and 10,000 symbols in .init.text.  .strtab takes up
250,227 bytes.

Original code: insmod takes 3.39 seconds
Patched code: insmod takes 0.07 seconds

Signed-off-by: Kevin Cernekee <cernekee@gmail.com>
---

Since the new code performs an exhaustive string compare search when it
encounters duplicate symbols inside a module (i.e. multiple symtab entries
referring to the same strtab index), I did some extra checking on my
Linux PC to see how common this is:

For modules other than nvidia, there were 35 duplicate symbols out of
9,956 total LKM symbols (0.4%).  This is with KALLSYMS and KALLSYMS_ALL
enabled.  Many were ".LCx" literal constants, and others were random
duplications of trace_kmalloc(), cache_put(), do_vfs_lock(), etc.
Probably caused by combining multiple *.o files into a single *.ko file.

The nvidia module has 29,296 total entries, and 3,045 duplicates (10%).
There were 597 instances of each of: _nv009058rm, _nv009059rm,
_nv009060rm, and _nv009061rm.

To make sure the degenerate case of nvidia.ko was still covered, I ran
additional tests with qemu-system-arm (ARM Versatile) on Linus' head of
tree:

Latest kernel (commit 15831714), 25,000 symbol test (as above): 4.5s

Latest kernel with 2,400 (16%) of my module's core symbols turned into
duplicates through hex editing: 4.4s

Patched kernel, 25,000 symbol test: 0.1s

Patched kernel, with 2,400 duplicate symbols: 0.8s

So, even a module with large numbers of duplicate symbols loads more
quickly with my patch, than without it.


 kernel/module.c |   26 ++++++++++++++++++--------
 1 files changed, 18 insertions(+), 8 deletions(-)

diff --git a/kernel/module.c b/kernel/module.c
index 93342d9..7f5dcbf 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -2221,7 +2221,7 @@ static void layout_symtab(struct module *mod, struct load_info *info)
 
 static void add_kallsyms(struct module *mod, const struct load_info *info)
 {
-	unsigned int i, ndst;
+	unsigned int i, j, stridx = 1, ndst;
 	const Elf_Sym *src;
 	Elf_Sym *dst;
 	char *s;
@@ -2237,22 +2237,32 @@ static void add_kallsyms(struct module *mod, const struct load_info *info)
 		mod->symtab[i].st_info = elf_type(&mod->symtab[i], info);
 
 	mod->core_symtab = dst = mod->module_core + info->symoffs;
+	mod->core_strtab = s = mod->module_core + info->stroffs;
 	src = mod->symtab;
 	*dst = *src;
+	*s++ = 0;
 	for (ndst = i = 1; i < mod->num_symtab; ++i, ++src) {
 		if (!is_core_symbol(src, info->sechdrs, info->hdr->e_shnum))
 			continue;
 		dst[ndst] = *src;
-		dst[ndst].st_name = bitmap_weight(info->strmap,
-						  dst[ndst].st_name);
+		if (unlikely(!test_bit(src->st_name, info->strmap))) {
+			dst[ndst].st_name = 0;
+			for (j = 1; j < ndst; j++)
+				if (!strcmp(&mod->strtab[src->st_name],
+					    &mod->core_strtab[dst[j].st_name]))
+					dst[ndst].st_name = dst[j].st_name;
+		} else {
+			dst[ndst].st_name = stridx;
+			j = src->st_name;
+			clear_bit(j, info->strmap);
+			do {
+				*s = mod->strtab[j++];
+				stridx++;
+			} while (*s++);
+		}
 		++ndst;
 	}
 	mod->core_num_syms = ndst;
-
-	mod->core_strtab = s = mod->module_core + info->stroffs;
-	for (*s = 0, i = 1; i < info->sechdrs[info->index.str].sh_size; ++i)
-		if (test_bit(i, info->strmap))
-			*++s = mod->strtab[i];
 }
 #else
 static inline void layout_symtab(struct module *mod, struct load_info *info)
-- 
1.7.6.3

