Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756163Ab1KRDUT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Nov 2011 22:20:19 -0500
Received: from [69.28.251.93] ([69.28.251.93]:36148 "EHLO b32.net"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1756045Ab1KRDUR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Nov 2011 22:20:17 -0500
From: Kevin Cernekee <cernekee@gmail.com>
To: "'Jan Beulich'" <JBeulich@suse.com>
Cc: "'Rusty Russell'" <rusty@rustcorp.com.au>, <linux-kbuild@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH V2 2/2] module: Fix performance regression on
 modules with large symbol tables
Date: Thu, 17 Nov 2011 19:15:02 -0800
Message-Id: <63fcc782681c8b3bd330164871ad4785@localhost>
In-Reply-To: <4EC0E4040200007800060B1C@nat28.tlf.novell.com>
References: <4EC0E4040200007800060B1C@nat28.tlf.novell.com>
User-Agent: vim 7.2
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 14 Nov 2011 08:48:52 +0000, "Jan Beulich" <JBeulich@suse.com> wrote:
> > +                   for (dup = mod->core_strtab; strcmp(dup, name); dup++)
> > +                           BUG_ON(dup > s);
>
> Aren't you concerned that this again will be rather slow? It would be
> pretty easy to accelerate by comparing only with the tail of each string
> (as nothing else can possibly match), moving from string to string instead
> of from character to character.

I reinstalled an old laptop today and then ran a few numbers for fun.

System: Linux 3.0.4, Ubuntu 11.10, x86 32-bit, Intel Core 2 P8700,
nvidia 280.13 driver

Looking at /proc/kallsyms, one starts to ponder whether all of the extra
strtab-related complexity in module.c is worth the memory savings:

nvidia.ko: 33,785 entries (3,037 are duplicates)
Other *.ko files: 5,972 entries (3 are duplicates)
Kernel image: 62,737 entries

Sum of lengths of all *.ko core symbol names + terminating bytes:
542,824 bytes; 408,585 of that is from nvidia.ko

Potential memory savings from suffix merging (shorter strings refer to a
longer strtab entry, exact matches excluded): 13,156 bytes total; 487
from nvidia.ko.  These mostly came from entries starting with __kcrctab*
or __param* .

Potential memory savings from reusing EXACT strtab matches: 36,475 bytes
total; 35,432 from nvidia.ko.  For comparison, discarding non-core
strtab entries saved about 91KB on my system.

Instead of making the add_kallsyms() loop even more complex, I tried the
other route of deleting the strmap logic and naively copying each string
into core_strtab with no consideration for consolidating duplicates.
According to the above figures, this would unnecessarily cost me about
49KB (10%) if binutils did suffix merging.

Performance on an "already exists" insmod of nvidia.ko (runs
add_kallsyms() but does not actually initialize the module):

Original scheme: 1.230s
With patch V2: 0.280s
With naive copying: 0.058s

I am posting the "naive copying" patch in case anybody else wants to
follow up on this.  I am satisfied enough with the way the "V2" code
works and do not know if any additional tweaking is warranted.  But if
you can make good use of my patch, feel free:

Signed-off-by: Kevin Cernekee <cernekee@gmail.com>
---

diff --git a/kernel/module.c b/kernel/module.c
index 6c87305..b07f71c 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -138,7 +138,6 @@ struct load_info {
 	unsigned long len;
 	Elf_Shdr *sechdrs;
 	char *secstrings, *strtab;
-	unsigned long *strmap;
 	unsigned long symoffs, stroffs;
 	struct _ddebug *debug;
 	unsigned int num_debug;
@@ -2183,7 +2182,7 @@ static void layout_symtab(struct module *mod, struct load_info *info)
 	Elf_Shdr *symsect = info->sechdrs + info->index.sym;
 	Elf_Shdr *strsect = info->sechdrs + info->index.str;
 	const Elf_Sym *src;
-	unsigned int i, nsrc, ndst;
+	unsigned int i, nsrc, ndst, strtab_size;
 
 	/* Put symbol section at end of init part of module. */
 	symsect->sh_flags |= SHF_ALLOC;
@@ -2194,38 +2193,23 @@ static void layout_symtab(struct module *mod, struct load_info *info)
 	src = (void *)info->hdr + symsect->sh_offset;
 	nsrc = symsect->sh_size / sizeof(*src);
 
-	/*
-	 * info->strmap has a '1' bit for each byte of .strtab we want to
-	 * keep resident in mod->core_strtab.  Everything else in .strtab
-	 * is unreferenced by the symbols in mod->core_symtab, and will be
-	 * discarded when add_kallsyms() compacts the string table.
-	 */
-	for (ndst = i = 1; i < nsrc; ++i, ++src)
+	/* Compute total space required for the core symbols' strtab. */
+	for (ndst = i = strtab_size = 1; i < nsrc; ++i, ++src)
 		if (is_core_symbol(src, info->sechdrs, info->hdr->e_shnum)) {
-			unsigned int j = src->st_name;
-
-			while (!__test_and_set_bit(j, info->strmap)
-			       && info->strtab[j])
-				++j;
-			++ndst;
+			strtab_size += strlen(&info->strtab[src->st_name]) + 1;
+			ndst++;
 		}
 
 	/* Append room for core symbols at end of core part. */
 	info->symoffs = ALIGN(mod->core_size, symsect->sh_addralign ?: 1);
-	mod->core_size = info->symoffs + ndst * sizeof(Elf_Sym);
+	info->stroffs = mod->core_size = info->symoffs + ndst * sizeof(Elf_Sym);
+	mod->core_size += strtab_size;
 
 	/* Put string table section at end of init part of module. */
 	strsect->sh_flags |= SHF_ALLOC;
 	strsect->sh_entsize = get_offset(mod, &mod->init_size, strsect,
 					 info->index.str) | INIT_OFFSET_MASK;
 	DEBUGP("\t%s\n", info->secstrings + strsect->sh_name);
-
-	/* Append room for core symbols' strings at end of core part. */
-	info->stroffs = mod->core_size;
-
-	/* First strtab byte (and first symtab entry) are zeroes. */
-	__set_bit(0, info->strmap);
-	mod->core_size += bitmap_weight(info->strmap, strsect->sh_size);
 }
 
 static void add_kallsyms(struct module *mod, const struct load_info *info)
@@ -2251,41 +2235,12 @@ static void add_kallsyms(struct module *mod, const struct load_info *info)
 	*dst = *src;
 	*s++ = 0;
 	for (ndst = i = 1; i < mod->num_symtab; ++i, ++src) {
-		const char *name;
 		if (!is_core_symbol(src, info->sechdrs, info->hdr->e_shnum))
 			continue;
-		dst[ndst] = *src;
 
-		name = &mod->strtab[src->st_name];
-		if (unlikely(!test_bit(src->st_name, info->strmap))) {
-			/* Symbol name has already been copied; find it. */
-			char *dup;
-
-			for (dup = mod->core_strtab; strcmp(dup, name); dup++)
-				BUG_ON(dup > s);
-
-			dst[ndst].st_name = dup - mod->core_strtab;
-		} else {
-			/*
-			 * Copy the symbol name to mod->core_strtab.
-			 * "name" might point to the middle of a longer strtab
-			 * entry, so backtrack to the first "required" byte
-			 * of the string.
-			 */
-			unsigned start = src->st_name, len = 0;
-
-			for (; test_bit(start - 1, info->strmap) &&
-			       mod->strtab[start - 1]; start--)
-				len++;
-
-			dst[ndst].st_name = len + s - mod->core_strtab;
-			len += strlen(name) + 1;
-
-			memcpy(s, &mod->strtab[start], len);
-			s += len;
-			bitmap_clear(info->strmap, start, len);
-		}
-		++ndst;
+		dst[ndst] = *src;
+		dst[ndst++].st_name = s - mod->core_strtab;
+		s += strlcpy(s, &mod->strtab[src->st_name], KSYM_NAME_LEN) + 1;
 	}
 	mod->core_num_syms = ndst;
 }
@@ -2777,27 +2732,18 @@ static struct module *layout_and_allocate(struct load_info *info)
 	   this is done generically; there doesn't appear to be any
 	   special cases for the architectures. */
 	layout_sections(mod, info);
-
-	info->strmap = kzalloc(BITS_TO_LONGS(info->sechdrs[info->index.str].sh_size)
-			 * sizeof(long), GFP_KERNEL);
-	if (!info->strmap) {
-		err = -ENOMEM;
-		goto free_percpu;
-	}
 	layout_symtab(mod, info);
 
 	/* Allocate and move to the final place */
 	err = move_module(mod, info);
 	if (err)
-		goto free_strmap;
+		goto free_percpu;
 
 	/* Module has been copied to its final place now: return it. */
 	mod = (void *)info->sechdrs[info->index.mod].sh_addr;
 	kmemleak_load_module(mod, info);
 	return mod;
 
-free_strmap:
-	kfree(info->strmap);
 free_percpu:
 	percpu_modfree(mod);
 out:
@@ -2807,7 +2753,6 @@ out:
 /* mod is no longer valid after this! */
 static void module_deallocate(struct module *mod, struct load_info *info)
 {
-	kfree(info->strmap);
 	percpu_modfree(mod);
 	module_free(mod, mod->module_init);
 	module_free(mod, mod->module_core);
@@ -2937,8 +2882,7 @@ static struct module *load_module(void __user *umod,
 	if (err < 0)
 		goto unlink;
 
-	/* Get rid of temporary copy and strmap. */
-	kfree(info.strmap);
+	/* Get rid of temporary copy. */
 	free_copy(&info);
 
 	/* Done! */
--
