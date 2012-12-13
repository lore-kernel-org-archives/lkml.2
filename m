Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932428Ab2LMPBv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 10:01:51 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:44178 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756053Ab2LMODj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 09:03:39 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 048/241] module: fix out-by-one error in kallsyms
Date: Thu, 13 Dec 2012 11:56:53 -0200
Message-Id: <1355407206-17100-49-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1355407206-17100-1-git-send-email-herton.krzesinski@canonical.com>
References: <1355407206-17100-1-git-send-email-herton.krzesinski@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.2 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rusty Russell <rusty@rustcorp.com.au>

commit 59ef28b1f14899b10d6b2682c7057ca00a9a3f47 upstream.

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
Reported-by: Masaki Kimura <masaki.kimura.kz@hitachi.com>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 kernel/module.c |   27 ++++++++++++++++-----------
 1 file changed, 16 insertions(+), 11 deletions(-)

diff --git a/kernel/module.c b/kernel/module.c
index 9ad9ee9..2a15c59 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -2273,12 +2273,17 @@ static void layout_symtab(struct module *mod, struct load_info *info)
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
@@ -2312,15 +2317,15 @@ static void add_kallsyms(struct module *mod, const struct load_info *info)
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
-- 
1.7.9.5

