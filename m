Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933134Ab2JYAXV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 20:23:21 -0400
Received: from ozlabs.org ([203.10.76.45]:51295 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754017Ab2JYAXU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 20:23:20 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Masaki Kimura <masaki.kimura.kz@hitachi.com>, linux-kernel@vger.kernel.org
Subject: Re: [RESEND PATCH] module: Fix kallsyms to show the last symbol properly
In-Reply-To: <508781AD.80902@hitachi.com>
References: <508781AD.80902@hitachi.com>
User-Agent: Notmuch/0.14 (http://notmuchmail.org) Emacs/23.4.1 (i686-pc-linux-gnu)
Date: Thu, 25 Oct 2012 10:50:28 +1030
Message-ID: <87y5ivmmgj.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Masaki Kimura <masaki.kimura.kz@hitachi.com> writes:
> This patch fixes a bug that the last symbol in the .symtab section of
> kernel modules is not displayed with /proc/kallsyms. This happens
> because the first symbol is processed twice before and inside the loop
> without incrementing "src".

Hi Misaki!

        Sorry I dropped this the first time, thanks for the re-send!

        The real problem is that we use 1-based counters, because we
always want to copy the 0th entry (which is always empty).  This results
in the truncation you found.

So I prefer the following fix:

module: fix out-by-one error in kallsyms

Masaki found and patched a kallsyms issue: the last symbol in a
module's symtab wasn't transferred.  This is because we manually copy
the zero'th entry (which is always empty) then copy the rest in a loop
starting at 1, though from src[0].  His fix was minimal, I prefer to
rewrite the loops in more standard form.

There are two loops: one to get the size, and one to copy.  Make these
identical: always count entry 0 and any defined symbol in an allocated
non-init section.

This bug exists since the following commit was introduced.
   module: reduce symbol table for loaded modules (v2)
   commit: 4a4962263f07d14660849ec134ee42b63e95ea9a

LKML: http://lkml.org/lkml/2012/10/24/27
Cc: stable@kernel.org
Reported-by: Masaki Kimura <masaki.kimura.kz@hitachi.com>
Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

diff --git a/kernel/module.c b/kernel/module.c
index 261bf82..879a154 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -2295,12 +2295,17 @@ static void layout_symtab(struct module *mod, struct load_info *info)
 	src = (void *)info->hdr + symsect->sh_offset;
 	nsrc = symsect->sh_size / sizeof(*src);
 
+	/* strtab always starts with a nul, so offset 0 is the empty string. */
+	strtab_size = 1;
+
 	/* Compute total space required for the core symbols' strtab. */
-	for (ndst = i = strtab_size = 1; i < nsrc; ++i, ++src)
-		if (is_core_symbol(src, info->sechdrs, info->hdr->e_shnum)) {
-			strtab_size += strlen(&info->strtab[src->st_name]) + 1;
+	for (ndst = i = 0; i < nsrc; i++) {
+		if (i == 0 ||
+		    is_core_symbol(src+i, info->sechdrs, info->hdr->e_shnum)) {
+			strtab_size += strlen(&info->strtab[src[i].st_name])+1;
 			ndst++;
 		}
+	}
 
 	/* Append room for core symbols at end of core part. */
 	info->symoffs = ALIGN(mod->core_size, symsect->sh_addralign ?: 1);
@@ -2334,15 +2339,15 @@ static void add_kallsyms(struct module *mod, const struct load_info *info)
 	mod->core_symtab = dst = mod->module_core + info->symoffs;
 	mod->core_strtab = s = mod->module_core + info->stroffs;
 	src = mod->symtab;
-	*dst = *src;
 	*s++ = 0;
-	for (ndst = i = 1; i < mod->num_symtab; ++i, ++src) {
-		if (!is_core_symbol(src, info->sechdrs, info->hdr->e_shnum))
-			continue;
-
-		dst[ndst] = *src;
-		dst[ndst++].st_name = s - mod->core_strtab;
-		s += strlcpy(s, &mod->strtab[src->st_name], KSYM_NAME_LEN) + 1;
+	for (ndst = i = 0; i < mod->num_symtab; i++) {
+		if (i == 0 ||
+		    is_core_symbol(src+i, info->sechdrs, info->hdr->e_shnum)) {
+			dst[ndst] = src[i];
+			dst[ndst++].st_name = s - mod->core_strtab;
+			s += strlcpy(s, &mod->strtab[src[i].st_name],
+				     KSYM_NAME_LEN) + 1;
+		}
 	}
 	mod->core_num_syms = ndst;
 }
