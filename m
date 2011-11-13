Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752793Ab1KMDOV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Nov 2011 22:14:21 -0500
Received: from [69.28.251.93] ([69.28.251.93]:48179 "EHLO b32.net"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750984Ab1KMDOU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Nov 2011 22:14:20 -0500
From: Kevin Cernekee <cernekee@gmail.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org,
        Jan Beulich <JBeulich@novell.com>
Subject: [PATCH V2 2/2] module: Fix performance regression on modules with large
 symbol tables
Date: Sat, 12 Nov 2011 19:08:56 -0800
Message-Id: <e80b536093214489c32ce319b54b0f80@localhost>
In-Reply-To: <73defb5e4bca04a6431392cc341112b1@localhost>
References: <73defb5e4bca04a6431392cc341112b1@localhost>
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

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Kevin Cernekee <cernekee@gmail.com>
---

V2:

Properly handle cases where different symtab entries point to strtab
substrings (suffix merging).  Mostly Rusty's work.  Also, add comments.

My test case for suffix merging was:

$ nm --no-sort alphabet.ko
00000000 t hello
00000014 t init
00000000 d retcode
00000000 r __mod_retcodetype8
00000000 r __param_retcode
00000000 r __param_str_retcode
00000000 r $LC0
00000018 r __module_depends
00000000 r ____versions
00000021 r __mod_vermagic5
00000050 T uvwxyz
00000000 D __this_module
00000048 T yz
00000000 T qrstuvwxyz
00000060 T rstuvwxyz
00000014 T init_module
00000040 T wxyz
00000068 T tuvwxyz
         U printk
00000058 T vwxyz
         U param_ops_int

"qrstuvwxyz" is in .init.text (non-core symbol); all others were core
symbols.  The symtab entries for all substrings were hexedited to
point to the respective portion of the "qrstuvwxyz" strtab entry.

I verified that "rstuvwxyz" (without the 'q') was copied to core_strtab
when the loop hit "uvwxyz", and that the substrings all used that entry.


 kernel/module.c |   40 +++++++++++++++++++++++++++++++++-------
 1 files changed, 33 insertions(+), 7 deletions(-)

diff --git a/kernel/module.c b/kernel/module.c
index cf9f1b6..6c87305 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -2246,22 +2246,48 @@ static void add_kallsyms(struct module *mod, const struct load_info *info)
 		mod->symtab[i].st_info = elf_type(&mod->symtab[i], info);
 
 	mod->core_symtab = dst = mod->module_core + info->symoffs;
+	mod->core_strtab = s = mod->module_core + info->stroffs;
 	src = mod->symtab;
 	*dst = *src;
+	*s++ = 0;
 	for (ndst = i = 1; i < mod->num_symtab; ++i, ++src) {
+		const char *name;
 		if (!is_core_symbol(src, info->sechdrs, info->hdr->e_shnum))
 			continue;
 		dst[ndst] = *src;
-		dst[ndst].st_name = bitmap_weight(info->strmap,
-						  dst[ndst].st_name);
+
+		name = &mod->strtab[src->st_name];
+		if (unlikely(!test_bit(src->st_name, info->strmap))) {
+			/* Symbol name has already been copied; find it. */
+			char *dup;
+
+			for (dup = mod->core_strtab; strcmp(dup, name); dup++)
+				BUG_ON(dup > s);
+
+			dst[ndst].st_name = dup - mod->core_strtab;
+		} else {
+			/*
+			 * Copy the symbol name to mod->core_strtab.
+			 * "name" might point to the middle of a longer strtab
+			 * entry, so backtrack to the first "required" byte
+			 * of the string.
+			 */
+			unsigned start = src->st_name, len = 0;
+
+			for (; test_bit(start - 1, info->strmap) &&
+			       mod->strtab[start - 1]; start--)
+				len++;
+
+			dst[ndst].st_name = len + s - mod->core_strtab;
+			len += strlen(name) + 1;
+
+			memcpy(s, &mod->strtab[start], len);
+			s += len;
+			bitmap_clear(info->strmap, start, len);
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

