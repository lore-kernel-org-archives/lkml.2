Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753646Ab0FBIR2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jun 2010 04:17:28 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58075 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753252Ab0FBIRZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jun 2010 04:17:25 -0400
Date: Wed, 2 Jun 2010 01:12:32 -0700 (PDT)
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
In-Reply-To: <alpine.LFD.2.00.1006020022000.8175@i5.linux-foundation.org>
Message-ID: <alpine.LFD.2.00.1006020102520.8175@i5.linux-foundation.org>
References: <201005252300.07739.rjw@sisk.pl> <alpine.LFD.2.00.1006012039570.8175@i5.linux-foundation.org> <alpine.LFD.2.00.1006012137390.8175@i5.linux-foundation.org> <201006021605.38817.rusty@rustcorp.com.au>
 <alpine.LFD.2.00.1006020022000.8175@i5.linux-foundation.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 2 Jun 2010, Linus Torvalds wrote:
> 
> IOW, things like this.. Pure code movement to peel off some stuff.

Here's a second one. It's slightly less trivial - since we now have error 
cases - and equally untested so it may well be totally broken. But it also 
cleans up a bit more, and avoids one of the goto targets, because the 
"move_module()" helper now does both allocations or none.

But now I'm bored and tired, so I think this will be all for tonight. The 
load_module function has gone from ~490 lines to ~370 lines, but that's 
still so many that I don't honestly think this makes any readability 
improvement yet.

But add a few more helper functions (say, one for doing relocations, one 
for doing some of the verification, one for doing the license and 
tainting, one to trivially push the icache flush into its own helper etc), 
and it probably will never fit in 50 lines, but maybe it could be 150.

			Linus

---
 kernel/module.c |  119 ++++++++++++++++++++++++++++++-------------------------
 1 files changed, 65 insertions(+), 54 deletions(-)

diff --git a/kernel/module.c b/kernel/module.c
index 165d97e..72567e6 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -2170,6 +2170,67 @@ static void find_module_sections(struct module *mod, Elf_Ehdr *hdr, Elf_Shdr *se
 #endif
 }
 
+static struct module *move_module(struct module *mod, Elf_Ehdr *hdr, Elf_Shdr *sechdrs, char *secstrings, unsigned modindex)
+{
+	int i;
+	void *ptr;
+
+	/* Do the allocs. */
+	ptr = module_alloc_update_bounds(mod->core_size);
+	/*
+	 * The pointer to this block is stored in the module structure
+	 * which is inside the block. Just mark it as not being a
+	 * leak.
+	 */
+	kmemleak_not_leak(ptr);
+	if (!ptr)
+		return ERR_PTR(-ENOMEM);
+
+	memset(ptr, 0, mod->core_size);
+	mod->module_core = ptr;
+
+	ptr = module_alloc_update_bounds(mod->init_size);
+	/*
+	 * The pointer to this block is stored in the module structure
+	 * which is inside the block. This block doesn't need to be
+	 * scanned as it contains data and code that will be freed
+	 * after the module is initialized.
+	 */
+	kmemleak_ignore(ptr);
+	if (!ptr && mod->init_size) {
+		module_free(mod, mod->module_core);
+		return ERR_PTR(-ENOMEM);
+	}
+	memset(ptr, 0, mod->init_size);
+	mod->module_init = ptr;
+
+	/* Transfer each section which specifies SHF_ALLOC */
+	DEBUGP("final section addresses:\n");
+	for (i = 0; i < hdr->e_shnum; i++) {
+		void *dest;
+
+		if (!(sechdrs[i].sh_flags & SHF_ALLOC))
+			continue;
+
+		if (sechdrs[i].sh_entsize & INIT_OFFSET_MASK)
+			dest = mod->module_init
+				+ (sechdrs[i].sh_entsize & ~INIT_OFFSET_MASK);
+		else
+			dest = mod->module_core + sechdrs[i].sh_entsize;
+
+		if (sechdrs[i].sh_type != SHT_NOBITS)
+			memcpy(dest, (void *)sechdrs[i].sh_addr,
+			       sechdrs[i].sh_size);
+		/* Update sh_addr to point to copy in image. */
+		sechdrs[i].sh_addr = (unsigned long)dest;
+		DEBUGP("\t0x%lx %s\n", sechdrs[i].sh_addr, secstrings + sechdrs[i].sh_name);
+	}
+	/* Module has been moved. */
+	mod = (void *)sechdrs[modindex].sh_addr;
+	kmemleak_load_module(mod, hdr, sechdrs, secstrings);
+	return mod;
+}
+
 /* Allocate and load the module: note that size of section 0 is always
    zero, and we rely on this for optional sections. */
 static noinline struct module *load_module(void __user *umod,
@@ -2186,7 +2247,6 @@ static noinline struct module *load_module(void __user *umod,
 	unsigned int modindex, versindex, infoindex, pcpuindex;
 	struct module *mod;
 	long err = 0;
-	void *ptr = NULL; /* Stops spurious gcc warning */
 	unsigned long symoffs, stroffs, *strmap;
 	void __percpu *percpu;
 
@@ -2338,60 +2398,12 @@ static noinline struct module *load_module(void __user *umod,
 	symoffs = layout_symtab(mod, sechdrs, symindex, strindex, hdr,
 				secstrings, &stroffs, strmap);
 
-	/* Do the allocs. */
-	ptr = module_alloc_update_bounds(mod->core_size);
-	/*
-	 * The pointer to this block is stored in the module structure
-	 * which is inside the block. Just mark it as not being a
-	 * leak.
-	 */
-	kmemleak_not_leak(ptr);
-	if (!ptr) {
-		err = -ENOMEM;
+	/* Allocate and move to the final place */
+	mod = move_module(mod, hdr, sechdrs, secstrings, modindex);
+	if (IS_ERR(mod)) {
+		err = PTR_ERR(mod);
 		goto free_percpu;
 	}
-	memset(ptr, 0, mod->core_size);
-	mod->module_core = ptr;
-
-	ptr = module_alloc_update_bounds(mod->init_size);
-	/*
-	 * The pointer to this block is stored in the module structure
-	 * which is inside the block. This block doesn't need to be
-	 * scanned as it contains data and code that will be freed
-	 * after the module is initialized.
-	 */
-	kmemleak_ignore(ptr);
-	if (!ptr && mod->init_size) {
-		err = -ENOMEM;
-		goto free_core;
-	}
-	memset(ptr, 0, mod->init_size);
-	mod->module_init = ptr;
-
-	/* Transfer each section which specifies SHF_ALLOC */
-	DEBUGP("final section addresses:\n");
-	for (i = 0; i < hdr->e_shnum; i++) {
-		void *dest;
-
-		if (!(sechdrs[i].sh_flags & SHF_ALLOC))
-			continue;
-
-		if (sechdrs[i].sh_entsize & INIT_OFFSET_MASK)
-			dest = mod->module_init
-				+ (sechdrs[i].sh_entsize & ~INIT_OFFSET_MASK);
-		else
-			dest = mod->module_core + sechdrs[i].sh_entsize;
-
-		if (sechdrs[i].sh_type != SHT_NOBITS)
-			memcpy(dest, (void *)sechdrs[i].sh_addr,
-			       sechdrs[i].sh_size);
-		/* Update sh_addr to point to copy in image. */
-		sechdrs[i].sh_addr = (unsigned long)dest;
-		DEBUGP("\t0x%lx %s\n", sechdrs[i].sh_addr, secstrings + sechdrs[i].sh_name);
-	}
-	/* Module has been moved. */
-	mod = (void *)sechdrs[modindex].sh_addr;
-	kmemleak_load_module(mod, hdr, sechdrs, secstrings);
 
 #if defined(CONFIG_MODULE_UNLOAD)
 	mod->refptr = alloc_percpu(struct module_ref);
@@ -2577,7 +2589,6 @@ static noinline struct module *load_module(void __user *umod,
  free_init:
 #endif
 	module_free(mod, mod->module_init);
- free_core:
 	module_free(mod, mod->module_core);
 	/* mod will be freed with core. Don't access it beyond this line! */
  free_percpu:
