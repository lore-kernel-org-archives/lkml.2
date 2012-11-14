Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756576Ab2KNF4s (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 00:56:48 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:55241 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756427Ab2KNFvD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 00:51:03 -0500
Message-Id: <20121114053939.282743930@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Wed, 14 Nov 2012 05:40:12 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Rusty Russell <rusty@rustcorp.com.au>,
        Masaki Kimura <masaki.kimura.kz@hitachi.com>
Subject: [ 39/82] module: fix out-by-one error in kallsyms
In-Reply-To: <20121114053933.726869752@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

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
[bwh: Backported to 3.2: we're still using a bitmap to compress the string
 table]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 kernel/module.c |   27 ++++++++++++++++-----------
 1 file changed, 16 insertions(+), 11 deletions(-)

--- a/kernel/module.c
+++ b/kernel/module.c
@@ -2193,15 +2193,17 @@ static void layout_symtab(struct module
 
 	src = (void *)info->hdr + symsect->sh_offset;
 	nsrc = symsect->sh_size / sizeof(*src);
-	for (ndst = i = 1; i < nsrc; ++i, ++src)
-		if (is_core_symbol(src, info->sechdrs, info->hdr->e_shnum)) {
-			unsigned int j = src->st_name;
+	for (ndst = i = 0; i < nsrc; i++) {
+		if (i == 0 ||
+		    is_core_symbol(src+i, info->sechdrs, info->hdr->e_shnum)) {
+			unsigned int j = src[i].st_name;
 
 			while (!__test_and_set_bit(j, info->strmap)
 			       && info->strtab[j])
 				++j;
 			++ndst;
 		}
+	}
 
 	/* Append room for core symbols at end of core part. */
 	info->symoffs = ALIGN(mod->core_size, symsect->sh_addralign ?: 1);
@@ -2238,14 +2240,14 @@ static void add_kallsyms(struct module *
 
 	mod->core_symtab = dst = mod->module_core + info->symoffs;
 	src = mod->symtab;
-	*dst = *src;
-	for (ndst = i = 1; i < mod->num_symtab; ++i, ++src) {
-		if (!is_core_symbol(src, info->sechdrs, info->hdr->e_shnum))
-			continue;
-		dst[ndst] = *src;
-		dst[ndst].st_name = bitmap_weight(info->strmap,
-						  dst[ndst].st_name);
-		++ndst;
+	for (ndst = i = 0; i < mod->num_symtab; i++) {
+		if (i == 0 ||
+		    is_core_symbol(src+i, info->sechdrs, info->hdr->e_shnum)) {
+			dst[ndst] = src[i];
+			dst[ndst].st_name = bitmap_weight(info->strmap,
+							  dst[ndst].st_name);
+			++ndst;
+		}
 	}
 	mod->core_num_syms = ndst;
 


