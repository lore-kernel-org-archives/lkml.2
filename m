Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757706Ab1KVA77 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Nov 2011 19:59:59 -0500
Received: from ozlabs.org ([203.10.76.45]:48647 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757657Ab1KVA74 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Nov 2011 19:59:56 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Kevin Cernekee <cernekee@gmail.com>
Cc: Jan Beulich <JBeulich@suse.com>, linux-kbuild@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH V2 2/2] module: Fix performance regression on modules with large symbol tables
In-Reply-To: <CAJiQ=7CEg0g=By1bKab9A8n6yLqYVKKhAB0TRRczjU9M6vk=xg@mail.gmail.com>
References: <4EC0E4040200007800060B1C@nat28.tlf.novell.com> <63fcc782681c8b3bd330164871ad4785@localhost> <87ipme9i9o.fsf@rustcorp.com.au> <CAJiQ=7CEg0g=By1bKab9A8n6yLqYVKKhAB0TRRczjU9M6vk=xg@mail.gmail.com>
User-Agent: Notmuch/0.6.1-1 (http://notmuchmail.org) Emacs/23.3.1 (i686-pc-linux-gnu)
Date: Tue, 22 Nov 2011 10:27:50 +1030
Message-ID: <87obw5xc3l.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 20 Nov 2011 22:29:55 -0800, Kevin Cernekee <cernekee@gmail.com> wrote:
> On Sun, Nov 20, 2011 at 9:06 PM, Rusty Russell <rusty@rustcorp.com.au> wrote:
> > On Thu, 17 Nov 2011 19:15:02 -0800, Kevin Cernekee <cernekee@gmail.com> wrote:
> > I'm deeply tempted.  It's very simple, 46 lines shorter, preserves exact
> > matches, and doesn't have any strange slowdowns on corner cases.
> 
> Unfortunately, the last patch I posted still makes duplicate copies of
> the exact matches.  And the copy of nvidia.ko I'm looking at right now
> does reuse strtab entries for the duplicated symbols.

Ah, I read it too fast.

Still, simplicity wins.  I like Jan's point, I'll put in a comment and
reference to this thread for future adventurers.  Result below.

Thanks!
Rusty.

From: Kevin Cernekee <cernekee@gmail.com>
Subject: module: Fix performance regression on modules with large symbol tables

Looking at /proc/kallsyms, one starts to ponder whether all of the extra
strtab-related complexity in module.c is worth the memory savings.

Instead of making the add_kallsyms() loop even more complex, I tried the
other route of deleting the strmap logic and naively copying each string
into core_strtab with no consideration for consolidating duplicates.

Performance on an "already exists" insmod of nvidia.ko (runs
add_kallsyms() but does not actually initialize the module):

	Original scheme: 1.230s
	With naive copying: 0.058s

Extra space used: 35k (of a 408k module).

Signed-off-by: Kevin Cernekee <cernekee@gmail.com>
Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
LKML-Reference: <73defb5e4bca04a6431392cc341112b1@localhost>
---
 kernel/module.c |   65 ++++++++++++++++++--------------------------------------
 1 file changed, 21 insertions(+), 44 deletions(-)

diff --git a/kernel/module.c b/kernel/module.c
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
@@ -2178,12 +2177,19 @@ static bool is_core_symbol(const Elf_Sym
 	return true;
 }
 
+/*
+ * We only allocate and copy the strings needed by the parts of symtab
+ * we keep.  This is simple, but has the effect of making multiple
+ * copies of duplicates.  We could be more sophisticated, see
+ * linux-kernel thread starting with
+ * <73defb5e4bca04a6431392cc341112b1@localhost>.
+ */
 static void layout_symtab(struct module *mod, struct load_info *info)
 {
 	Elf_Shdr *symsect = info->sechdrs + info->index.sym;
 	Elf_Shdr *strsect = info->sechdrs + info->index.str;
 	const Elf_Sym *src;
-	unsigned int i, nsrc, ndst;
+	unsigned int i, nsrc, ndst, strtab_size;
 
 	/* Put symbol section at end of init part of module. */
 	symsect->sh_flags |= SHF_ALLOC;
@@ -2194,38 +2200,23 @@ static void layout_symtab(struct module 
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
@@ -2246,22 +2237,19 @@ static void add_kallsyms(struct module *
 		mod->symtab[i].st_info = elf_type(&mod->symtab[i], info);
 
 	mod->core_symtab = dst = mod->module_core + info->symoffs;
+	mod->core_strtab = s = mod->module_core + info->stroffs;
 	src = mod->symtab;
 	*dst = *src;
+	*s++ = 0;
 	for (ndst = i = 1; i < mod->num_symtab; ++i, ++src) {
 		if (!is_core_symbol(src, info->sechdrs, info->hdr->e_shnum))
 			continue;
+
 		dst[ndst] = *src;
-		dst[ndst].st_name = bitmap_weight(info->strmap,
-						  dst[ndst].st_name);
-		++ndst;
+		dst[ndst++].st_name = s - mod->core_strtab;
+		s += strlcpy(s, &mod->strtab[src->st_name], KSYM_NAME_LEN) + 1;
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
@@ -2751,27 +2739,18 @@ static struct module *layout_and_allocat
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
@@ -2781,7 +2760,6 @@ out:
 /* mod is no longer valid after this! */
 static void module_deallocate(struct module *mod, struct load_info *info)
 {
-	kfree(info->strmap);
 	percpu_modfree(mod);
 	module_free(mod, mod->module_init);
 	module_free(mod, mod->module_core);
@@ -2911,8 +2889,7 @@ static struct module *load_module(void _
 	if (err < 0)
 		goto unlink;
 
-	/* Get rid of temporary copy and strmap. */
-	kfree(info.strmap);
+	/* Get rid of temporary copy. */
 	free_copy(&info);
 
 	/* Done! */
