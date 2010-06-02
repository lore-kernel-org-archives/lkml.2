Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932648Ab0FBSHy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jun 2010 14:07:54 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48648 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932486Ab0FBSHw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jun 2010 14:07:52 -0400
Date: Wed, 2 Jun 2010 11:01:06 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Rusty Russell <rusty@rustcorp.com.au>
cc: Brandon Philips <brandon@ifup.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, LKML <linux-kernel@vger.kernel.org>,
       Jon Masters <jonathan@jonmasters.org>, Tejun Heo <htejun@gmail.com>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: [PATCH 2/2] module: fix bne2 "gave up waiting for init of module
 libcrc32c"
In-Reply-To: <201006022336.53024.rusty@rustcorp.com.au>
Message-ID: <alpine.LFD.2.00.1006021038200.8175@i5.linux-foundation.org>
References: <201005252300.07739.rjw@sisk.pl> <201006021523.00357.rusty@rustcorp.com.au> <alpine.LFD.2.00.1006020006420.8175@i5.linux-foundation.org> <201006022336.53024.rusty@rustcorp.com.au>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 2 Jun 2010, Rusty Russell wrote:
> 
> And load_module is down to 259 lines.  The label chain at the end is no
> shorter tho :(  I'll leave those cleanups until next merge window.

Btw, here's a patch that _looks_ large, but it really pretty trivial, and 
sets things up so that it would be way easier to split off pieces of the 
module loading.

The reason it looks large is that it creates a "module_info" structure 
that contains all the module state that we're building up while loading, 
instead of having individual variables for all the indices etc.

So the patch ends up being large, because every "symindex" access instead 
becomes "info.index.sym" etc. That may be a few characters longer, but it 
then means that we can just pass a pointer to that "info" structure 
around. and let all the pieces fill it in very naturally.

As an example of that, the patch also moves the initialization of all 
those convenience variables into a "setup_module_info()" function. And at 
this point it really does become very natural to start to peel off some of 
the error labels and move them into the helper functions - now the 
"truncated" case is gone, and is handled inside that setup function 
instead.

So maybe you don't like this approach, and it does make the variable 
accesses a bit longer, but I don't think unreadably so. And the patch 
really does look big and scary, but there really should be absolutely no 
semantic changes - most of it was a trivial and mindless rename.

In fact, it was so mindless that I on purpose kept the existing helper 
functions looking like this:

-       err = check_modinfo(mod, sechdrs, infoindex, versindex);
+       err = check_modinfo(mod, info.sechdrs, info.index.info, info.index.vers);

rather than changing them to just take the "info" pointer. IOW, a second 
phase (if you think the approach is ok) would change that calling 
convention to just do

	err = check_modinfo(mod, &info);

(and same for "layout_sections()", "layout_symtabs()" etc.) Similarly, 
while right now it makes things _look_ bigger, with things like this:

	versindex = find_sec(hdr, sechdrs, secstrings, "__versions");

becoming

	info->index.vers = find_sec(info->hdr, info->sechdrs, info->secstrings, "__versions");

in the new "setup_module_info()" function, that's again just a result of 
it being a search-and-replace patch. By using the 'info' pointer, we could 
just change the 'find_sec()' interface so that it ends up being

	info->index.vers = find_sec(info, "__versions");

instead, and then we'd actually have a shorter and more readable line. So 
for a lot of those mindless variable name expansions there's would be room 
for separate cleanups.

I didn't move quite everything in there - if we do this to layout_symtabs, 
for example, we'd want to move the percpu, symoffs, stroffs, *strmap 
variables to be fields in that module_info structure too. But that's a 
much smaller patch, I moved just the really core stuff that is currently 
being set up and used in various parts.

But even in this rough form, it removes close to 70 lines from that 
function (but adds 22 lines overall, of course - the structure definition, 
the helper function declarations and call-sites etc etc).

		Linus

---
 kernel/module.c |  228 ++++++++++++++++++++++++++++++-------------------------
 1 files changed, 125 insertions(+), 103 deletions(-)

diff --git a/kernel/module.c b/kernel/module.c
index 01e8874..5cfe82a 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -2139,8 +2139,17 @@ static inline void kmemleak_load_module(struct module *mod, Elf_Ehdr *hdr,
 }
 #endif
 
-static int copy_and_check(Elf_Ehdr **hdrp,
-			  const void __user *umod, unsigned long len)
+struct module_info {
+	Elf_Ehdr *hdr;
+	unsigned long len;
+	Elf_Shdr *sechdrs;
+	char *secstrings, *args, *strtab;
+	struct {
+		unsigned int sym, str, mod, vers, info, pcpu;
+	} index;
+};
+
+static int copy_and_check(struct module_info *info, const void __user *umod, unsigned long len)
 {
 	int err;
 	Elf_Ehdr *hdr;
@@ -2150,7 +2159,7 @@ static int copy_and_check(Elf_Ehdr **hdrp,
 
 	/* Suck in entire file: we'll want most of it. */
 	/* vmalloc barfs on "unusual" numbers.  Check here */
-	if (len > 64 * 1024 * 1024 || (hdr = *hdrp = vmalloc(len)) == NULL)
+	if (len > 64 * 1024 * 1024 || (hdr = vmalloc(len)) == NULL)
 		return -ENOMEM;
 
 	if (copy_from_user(hdr, umod, len) != 0) {
@@ -2172,6 +2181,8 @@ static int copy_and_check(Elf_Ehdr **hdrp,
 		err = -ENOEXEC;
 		goto free_hdr;
 	}
+	info->hdr = hdr;
+	info->len = len;
 	return 0;
 
 free_hdr:
@@ -2179,6 +2190,80 @@ free_hdr:
 	return err;
 }
 
+/*
+ * Set up our basic convenience variables (pointers to section headers,
+ * search for module section index etc), and do some basic section
+ * verification.
+ *
+ * Return the temporary module pointer (we'll replace it with the final
+ * one when we move the module sections around).
+ */
+static struct module *setup_module_info(struct module_info *info)
+{
+	unsigned int i;
+	struct module *mod;
+
+	/* Set up the convenience variables */
+	info->sechdrs = (void *)info->hdr + info->hdr->e_shoff;
+	info->secstrings = (void *)info->hdr + info->sechdrs[info->hdr->e_shstrndx].sh_offset;
+	info->sechdrs[0].sh_addr = 0;
+
+	for (i = 1; i < info->hdr->e_shnum; i++) {
+		if (info->sechdrs[i].sh_type != SHT_NOBITS
+		    && info->len < info->sechdrs[i].sh_offset + info->sechdrs[i].sh_size)
+			goto truncated;
+
+		/* Mark all sections sh_addr with their address in the
+		   temporary image. */
+		info->sechdrs[i].sh_addr = (size_t)info->hdr + info->sechdrs[i].sh_offset;
+
+		/* Internal symbols and strings. */
+		if (info->sechdrs[i].sh_type == SHT_SYMTAB) {
+			info->index.sym = i;
+			info->index.str = info->sechdrs[i].sh_link;
+			info->strtab = (char *)info->hdr + info->sechdrs[info->index.str].sh_offset;
+		}
+#ifndef CONFIG_MODULE_UNLOAD
+		/* Don't load .exit sections */
+		if (strstarts(info->secstrings+info->sechdrs[i].sh_name, ".exit"))
+			info->sechdrs[i].sh_flags &= ~(unsigned long)SHF_ALLOC;
+#endif
+	}
+
+	info->index.mod = find_sec(info->hdr, info->sechdrs, info->secstrings,
+			    ".gnu.linkonce.this_module");
+	if (!info->index.mod) {
+		printk(KERN_WARNING "No module found in object\n");
+		return ERR_PTR(-ENOEXEC);
+	}
+	/* This is temporary: point mod into copy of data. */
+	mod = (void *)info->sechdrs[info->index.mod].sh_addr;
+
+	if (info->index.sym == 0) {
+		printk(KERN_WARNING "%s: module has no symbols (stripped?)\n",
+		       mod->name);
+		return ERR_PTR(-ENOEXEC);
+	}
+
+	info->index.vers = find_sec(info->hdr, info->sechdrs, info->secstrings, "__versions");
+	info->index.info = find_sec(info->hdr, info->sechdrs, info->secstrings, ".modinfo");
+	info->index.pcpu = find_pcpusec(info->hdr, info->sechdrs, info->secstrings);
+
+	/* Don't keep modinfo and version sections. */
+	info->sechdrs[info->index.info].sh_flags &= ~(unsigned long)SHF_ALLOC;
+	info->sechdrs[info->index.vers].sh_flags &= ~(unsigned long)SHF_ALLOC;
+
+	/* Check module struct version now, before we try to use module. */
+	if (!check_modstruct_version(info->sechdrs, info->index.vers, mod))
+		return ERR_PTR(-ENOEXEC);
+
+	return mod;
+
+ truncated:
+	printk(KERN_ERR "Module len %lu truncated\n", info->len);
+	return ERR_PTR(-ENOEXEC);
+}
+
 static int check_modinfo(struct module *mod,
 			 const Elf_Shdr *sechdrs,
 			 unsigned int infoindex, unsigned int versindex)
@@ -2404,13 +2489,7 @@ static noinline struct module *load_module(void __user *umod,
 				  unsigned long len,
 				  const char __user *uargs)
 {
-	Elf_Ehdr *hdr;
-	Elf_Shdr *sechdrs;
-	char *secstrings, *args, *strtab = NULL;
-	unsigned int i;
-	unsigned int symindex = 0;
-	unsigned int strindex = 0;
-	unsigned int modindex, versindex, infoindex, pcpuindex;
+	struct module_info info = { NULL, };
 	struct module *mod;
 	long err;
 	unsigned long symoffs, stroffs, *strmap;
@@ -2419,80 +2498,28 @@ static noinline struct module *load_module(void __user *umod,
 	DEBUGP("load_module: umod=%p, len=%lu, uargs=%p\n",
 	       umod, len, uargs);
 
-	err = copy_and_check(&hdr, umod, len);
+	err = copy_and_check(&info, umod, len);
 	if (err)
 		return ERR_PTR(err);
 
-	/* Convenience variables */
-	sechdrs = (void *)hdr + hdr->e_shoff;
-	secstrings = (void *)hdr + sechdrs[hdr->e_shstrndx].sh_offset;
-	sechdrs[0].sh_addr = 0;
-
-	for (i = 1; i < hdr->e_shnum; i++) {
-		if (sechdrs[i].sh_type != SHT_NOBITS
-		    && len < sechdrs[i].sh_offset + sechdrs[i].sh_size)
-			goto truncated;
-
-		/* Mark all sections sh_addr with their address in the
-		   temporary image. */
-		sechdrs[i].sh_addr = (size_t)hdr + sechdrs[i].sh_offset;
-
-		/* Internal symbols and strings. */
-		if (sechdrs[i].sh_type == SHT_SYMTAB) {
-			symindex = i;
-			strindex = sechdrs[i].sh_link;
-			strtab = (char *)hdr + sechdrs[strindex].sh_offset;
-		}
-#ifndef CONFIG_MODULE_UNLOAD
-		/* Don't load .exit sections */
-		if (strstarts(secstrings+sechdrs[i].sh_name, ".exit"))
-			sechdrs[i].sh_flags &= ~(unsigned long)SHF_ALLOC;
-#endif
-	}
-
-	modindex = find_sec(hdr, sechdrs, secstrings,
-			    ".gnu.linkonce.this_module");
-	if (!modindex) {
-		printk(KERN_WARNING "No module found in object\n");
-		err = -ENOEXEC;
-		goto free_hdr;
-	}
-	/* This is temporary: point mod into copy of data. */
-	mod = (void *)sechdrs[modindex].sh_addr;
-
-	if (symindex == 0) {
-		printk(KERN_WARNING "%s: module has no symbols (stripped?)\n",
-		       mod->name);
-		err = -ENOEXEC;
-		goto free_hdr;
-	}
-
-	versindex = find_sec(hdr, sechdrs, secstrings, "__versions");
-	infoindex = find_sec(hdr, sechdrs, secstrings, ".modinfo");
-	pcpuindex = find_pcpusec(hdr, sechdrs, secstrings);
-
-	/* Don't keep modinfo and version sections. */
-	sechdrs[infoindex].sh_flags &= ~(unsigned long)SHF_ALLOC;
-	sechdrs[versindex].sh_flags &= ~(unsigned long)SHF_ALLOC;
-
-	/* Check module struct version now, before we try to use module. */
-	if (!check_modstruct_version(sechdrs, versindex, mod)) {
-		err = -ENOEXEC;
+	mod = setup_module_info(&info);
+	if (IS_ERR(mod)) {
+		err = PTR_ERR(mod);
 		goto free_hdr;
 	}
 
-	err = check_modinfo(mod, sechdrs, infoindex, versindex);
+	err = check_modinfo(mod, info.sechdrs, info.index.info, info.index.vers);
 	if (err)
 		goto free_hdr;
 
 	/* Now copy in args */
-	args = strndup_user(uargs, ~0UL >> 1);
-	if (IS_ERR(args)) {
-		err = PTR_ERR(args);
+	info.args = strndup_user(uargs, ~0UL >> 1);
+	if (IS_ERR(info.args)) {
+		err = PTR_ERR(info.args);
 		goto free_hdr;
 	}
 
-	strmap = kzalloc(BITS_TO_LONGS(sechdrs[strindex].sh_size)
+	strmap = kzalloc(BITS_TO_LONGS(info.sechdrs[info.index.str].sh_size)
 			 * sizeof(long), GFP_KERNEL);
 	if (!strmap) {
 		err = -ENOMEM;
@@ -2502,17 +2529,17 @@ static noinline struct module *load_module(void __user *umod,
 	mod->state = MODULE_STATE_COMING;
 
 	/* Allow arches to frob section contents and sizes.  */
-	err = module_frob_arch_sections(hdr, sechdrs, secstrings, mod);
+	err = module_frob_arch_sections(info.hdr, info.sechdrs, info.secstrings, mod);
 	if (err < 0)
 		goto free_mod;
 
-	if (pcpuindex) {
+	if (info.index.pcpu) {
 		/* We have a special allocation for this section. */
-		err = percpu_modalloc(mod, sechdrs[pcpuindex].sh_size,
-				      sechdrs[pcpuindex].sh_addralign);
+		err = percpu_modalloc(mod, info.sechdrs[info.index.pcpu].sh_size,
+				      info.sechdrs[info.index.pcpu].sh_addralign);
 		if (err)
 			goto free_mod;
-		sechdrs[pcpuindex].sh_flags &= ~(unsigned long)SHF_ALLOC;
+		info.sechdrs[info.index.pcpu].sh_flags &= ~(unsigned long)SHF_ALLOC;
 	}
 	/* Keep this around for failure path. */
 	percpu = mod_percpu(mod);
@@ -2520,12 +2547,12 @@ static noinline struct module *load_module(void __user *umod,
 	/* Determine total sizes, and put offsets in sh_entsize.  For now
 	   this is done generically; there doesn't appear to be any
 	   special cases for the architectures. */
-	layout_sections(mod, hdr, sechdrs, secstrings);
-	symoffs = layout_symtab(mod, sechdrs, symindex, strindex, hdr,
-				secstrings, &stroffs, strmap);
+	layout_sections(mod, info.hdr, info.sechdrs, info.secstrings);
+	symoffs = layout_symtab(mod, info.sechdrs, info.index.sym, info.index.str, info.hdr,
+				info.secstrings, &stroffs, strmap);
 
 	/* Allocate and move to the final place */
-	mod = move_module(mod, hdr, sechdrs, secstrings, modindex);
+	mod = move_module(mod, info.hdr, info.sechdrs, info.secstrings, info.index.mod);
 	if (IS_ERR(mod)) {
 		err = PTR_ERR(mod);
 		goto free_percpu;
@@ -2538,36 +2565,36 @@ static noinline struct module *load_module(void __user *umod,
 
 	/* Now we've got everything in the final locations, we can
 	 * find optional sections. */
-	find_module_sections(mod, hdr, sechdrs, secstrings);
+	find_module_sections(mod, info.hdr, info.sechdrs, info.secstrings);
 
-	err = check_module_license_and_versions(mod, sechdrs);
+	err = check_module_license_and_versions(mod, info.sechdrs);
 	if (err)
 		goto free_unload;
 
 	/* Set up MODINFO_ATTR fields */
-	setup_modinfo(mod, sechdrs, infoindex);
+	setup_modinfo(mod, info.sechdrs, info.index.info);
 
 	/* Fix up syms, so that st_value is a pointer to location. */
-	err = simplify_symbols(sechdrs, symindex, strtab, versindex, pcpuindex,
+	err = simplify_symbols(info.sechdrs, info.index.sym, info.strtab, info.index.vers, info.index.pcpu,
 			       mod);
 	if (err < 0)
 		goto cleanup;
 
-	err = apply_relocations(mod, hdr, sechdrs, symindex, strindex);
+	err = apply_relocations(mod, info.hdr, info.sechdrs, info.index.sym, info.index.str);
 	if (err < 0)
 		goto cleanup;
 
   	/* Set up and sort exception table */
-	mod->extable = section_objs(hdr, sechdrs, secstrings, "__ex_table",
+	mod->extable = section_objs(info.hdr, info.sechdrs, info.secstrings, "__ex_table",
 				    sizeof(*mod->extable), &mod->num_exentries);
 	sort_extable(mod->extable, mod->extable + mod->num_exentries);
 
 	/* Finally, copy percpu area over. */
-	percpu_modcopy(mod, (void *)sechdrs[pcpuindex].sh_addr,
-		       sechdrs[pcpuindex].sh_size);
+	percpu_modcopy(mod, (void *)info.sechdrs[info.index.pcpu].sh_addr,
+		       info.sechdrs[info.index.pcpu].sh_size);
 
-	add_kallsyms(mod, sechdrs, hdr->e_shnum, symindex, strindex,
-		     symoffs, stroffs, secstrings, strmap);
+	add_kallsyms(mod, info.sechdrs, info.hdr->e_shnum, info.index.sym, info.index.str,
+		     symoffs, stroffs, info.secstrings, strmap);
 	kfree(strmap);
 	strmap = NULL;
 
@@ -2575,19 +2602,19 @@ static noinline struct module *load_module(void __user *umod,
 		struct _ddebug *debug;
 		unsigned int num_debug;
 
-		debug = section_objs(hdr, sechdrs, secstrings, "__verbose",
+		debug = section_objs(info.hdr, info.sechdrs, info.secstrings, "__verbose",
 				     sizeof(*debug), &num_debug);
 		if (debug)
 			dynamic_debug_setup(debug, num_debug);
 	}
 
-	err = module_finalize(hdr, sechdrs, mod);
+	err = module_finalize(info.hdr, info.sechdrs, mod);
 	if (err < 0)
 		goto cleanup;
 
 	flush_module_icache(mod);
 
-	mod->args = args;
+	mod->args = info.args;
 
 	/* Now sew it into the lists so we can get lockdep and oops
 	 * info during argument parsing.  Noone should access us, since
@@ -2618,11 +2645,11 @@ static noinline struct module *load_module(void __user *umod,
 	if (err < 0)
 		goto unlink;
 
-	add_sect_attrs(mod, hdr->e_shnum, secstrings, sechdrs);
-	add_notes_attrs(mod, hdr->e_shnum, secstrings, sechdrs);
+	add_sect_attrs(mod, info.hdr->e_shnum, info.secstrings, info.sechdrs);
+	add_notes_attrs(mod, info.hdr->e_shnum, info.secstrings, info.sechdrs);
 
 	/* Get rid of temporary copy */
-	vfree(hdr);
+	vfree(info.hdr);
 
 	trace_module_load(mod);
 
@@ -2648,16 +2675,11 @@ static noinline struct module *load_module(void __user *umod,
  free_percpu:
 	free_percpu(percpu);
  free_mod:
-	kfree(args);
+	kfree(info.args);
 	kfree(strmap);
  free_hdr:
-	vfree(hdr);
+	vfree(info.hdr);
 	return ERR_PTR(err);
-
- truncated:
-	printk(KERN_ERR "Module len %lu truncated\n", len);
-	err = -ENOEXEC;
-	goto free_hdr;
 }
 
 /* Call module constructors. */
