Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932133Ab1KGBaf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Nov 2011 20:30:35 -0500
Received: from ozlabs.org ([203.10.76.45]:55832 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755010Ab1KGBad (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Nov 2011 20:30:33 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Kevin Cernekee <cernekee@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org,
        Jan Beulich <JBeulich@novell.com>
Subject: Re: [PATCH] module: Fix performance regression on modules with large symbol tables
In-Reply-To: <467be983bed865e1b772136ed488f9ff@localhost>
References: <467be983bed865e1b772136ed488f9ff@localhost>
User-Agent: Notmuch/0.6.1-1 (http://notmuchmail.org) Emacs/23.3.1 (i686-pc-linux-gnu)
Date: Mon, 07 Nov 2011 11:59:54 +1030
Message-ID: <874nygu3cd.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 04 Nov 2011 17:48:58 -0700, Kevin Cernekee <cernekee@gmail.com> wrote:
> Commit 554bdfe5acf3715e87c8d5e25a4f9a896ac9f014 (module: reduce string
> table for loaded modules) introduced an optimization to shrink the size of
> the resident string table.  Part of this involves calling bitmap_weight()
> on the strmap bitmap once for each core symbol.  strmap contains one bit
> for each byte of the module's strtab.
> 
> For kernel modules with a large number of symbols, the addition of the
> bitmap_weight() operation to each iteration of the add_kallsyms() loop
> resulted in a significant "insmod" performance regression from 2.6.31
> to 2.6.32.  bitmap_weight() is expensive when the bitmap is large.
> 
> The proposed alternative optimizes the common case in this loop
> (is_core_symbol() == true, and the symbol name is not a duplicate), while
> penalizing the exceptional case of a duplicate symbol.

I see you honored Jan's original patch by leaving it mysterious and
undocumented.  I was totally confused by your patch.

I finally figured out that you pack the compacted strtab in symtab
order, and override the strmap bit to detect duplicates.  Clever.

But I don't think it quite works in general.  gcc is allowed to compact
the strtab itself, eg with two names "foobar" and "bar", it can reuse
the tail of the first strtab entry.  It may not yet, but it could.

This makes your job a bit harder, but not too bad.  See below...

I've started a separate patch to add comments to all this.

Cheers,
Rusty.

module: fix overlapping entries in symtab case.

The prior patch didn't handle the (theoretical?) case where strings in
the strtab are partially shared by two symtab entries.  This detects
that correctly, and does an exhaustive search for that case.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

diff --git a/kernel/module.c b/kernel/module.c
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -2221,7 +2221,7 @@ static void layout_symtab(struct module 
 
 static void add_kallsyms(struct module *mod, const struct load_info *info)
 {
-	unsigned int i, j, stridx = 1, ndst;
+	unsigned int i, ndst;
 	const Elf_Sym *src;
 	Elf_Sym *dst;
 	char *s;
@@ -2242,23 +2242,26 @@ static void add_kallsyms(struct module *
 	*dst = *src;
 	*s++ = 0;
 	for (ndst = i = 1; i < mod->num_symtab; ++i, ++src) {
+		const char *name;
 		if (!is_core_symbol(src, info->sechdrs, info->hdr->e_shnum))
 			continue;
 		dst[ndst] = *src;
+
+		name = &mod->strtab[src->st_name];
 		if (unlikely(!test_bit(src->st_name, info->strmap))) {
-			dst[ndst].st_name = 0;
-			for (j = 1; j < ndst; j++)
-				if (!strcmp(&mod->strtab[src->st_name],
-					    &mod->core_strtab[dst[j].st_name]))
-					dst[ndst].st_name = dst[j].st_name;
+			char *dup;
+
+			for (dup = mod->core_strtab; strcmp(dup, name); dup++)
+				BUG_ON(dup > s);
+
+			dst[ndst].st_name = dup - mod->core_strtab;
 		} else {
-			dst[ndst].st_name = stridx;
-			j = src->st_name;
-			clear_bit(j, info->strmap);
-			do {
-				*s = mod->strtab[j++];
-				stridx++;
-			} while (*s++);
+			unsigned len = strlen(name) + 1;
+
+			dst[ndst].st_name = s - mod->core_strtab;
+			memcpy(s, name, len);
+			s += len;
+			bitmap_clear(info->strmap, src->st_name, len);
 		}
 		++ndst;
 	}


