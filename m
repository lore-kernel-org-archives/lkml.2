Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755257Ab2K1BXf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2012 20:23:35 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:51472 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753213Ab2K1BXe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2012 20:23:34 -0500
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.8.4
Message-ID: <50B56769.3080501@jp.fujitsu.com>
Date: Wed, 28 Nov 2012 10:22:49 +0900
From: sat <takeuchi_satoru@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:14.0) Gecko/20120713 Thunderbird/14.0
MIME-Version: 1.0
To: lkml <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Masaki Kimura <masaki.kimura.kz@hitachi.com>
Subject: [PATCH] module: Remove a extra null character at the top of module->strtab.
Content-Type: text/plain; charset="ISO-2022-JP"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>

There is a extra null character('\0') at the top of module->strtab for
each module. Commit 59ef28b introduced this bug and this patch fixes it.

Live dump log of the current linus git kernel(HEAD is 2844a4870):
============================================================================
crash> mod | grep loop
ffffffffa01db0a0  loop             16689  (not loaded)  [CONFIG_KALLSYMS]
crash> module.core_symtab ffffffffa01db0a0
  core_symtab = 0xffffffffa01db320crash> rd 0xffffffffa01db320 12
ffffffffa01db320:  0000005500000001 0000000000000000   ....U...........
ffffffffa01db330:  0000000000000000 0002007400000002   ............t...
ffffffffa01db340:  ffffffffa01d8000 0000000000000038   ........8.......
ffffffffa01db350:  001a00640000000e ffffffffa01daeb0   ....d...........
ffffffffa01db360:  00000000000000a0 0002007400000019   ............t...
ffffffffa01db370:  ffffffffa01d8068 000000000000001b   h...............
crash> module.core_strtab ffffffffa01db0a0
  core_strtab = 0xffffffffa01dbb30 ""
crash> rd 0xffffffffa01dbb30 4
ffffffffa01dbb30:  615f70616d6b0000 66780063696d6f74   ..kmap_atomic.xf
ffffffffa01dbb40:  73636e75665f7265 72665f646e696600   er_funcs.find_fr
============================================================================

We expect Just first one byte of '\0', but actually first two bytes
are '\0'. Here is The relationship between symtab and strtab.

	symtab_idx	strtab_idx	symbol
	-----------------------------------------------
	0		0x1		"\0" # startab_idx should be 0
	1		0x2		"kmap_atomic"
	2		0xe		"xfer_funcs"
	3		0x19		"find_fr..."

By applying this patch, it becomes as follows.

	symtab_idx	strtab_idx	symbol
	-----------------------------------------------
	0		0x0		"\0"	# extra byte is removed
	1		0x1		"kmap_atomic"
	2		0xd		"xfer_funcs"
	3		0x18		"find_fr..."

Signed-off-by: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
Cc: Masaki Kimura <masaki.kimura.kz@hitachi.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/module.c |    6 +-----
 1 files changed, 1 insertions(+), 5 deletions(-)

diff --git a/kernel/module.c b/kernel/module.c
index 6e48c3a..7af5d5d 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -2282,7 +2282,7 @@ static void layout_symtab(struct module *mod, struct load_info *info)
 	Elf_Shdr *symsect = info->sechdrs + info->index.sym;
 	Elf_Shdr *strsect = info->sechdrs + info->index.str;
 	const Elf_Sym *src;
-	unsigned int i, nsrc, ndst, strtab_size;
+	unsigned int i, nsrc, ndst, strtab_size = 0;
 
 	/* Put symbol section at end of init part of module. */
 	symsect->sh_flags |= SHF_ALLOC;
@@ -2293,9 +2293,6 @@ static void layout_symtab(struct module *mod, struct load_info *info)
 	src = (void *)info->hdr + symsect->sh_offset;
 	nsrc = symsect->sh_size / sizeof(*src);
 
-	/* strtab always starts with a nul, so offset 0 is the empty string. */
-	strtab_size = 1;
-
 	/* Compute total space required for the core symbols' strtab. */
 	for (ndst = i = 0; i < nsrc; i++) {
 		if (i == 0 ||
@@ -2337,7 +2334,6 @@ static void add_kallsyms(struct module *mod, const struct load_info *info)
 	mod->core_symtab = dst = mod->module_core + info->symoffs;
 	mod->core_strtab = s = mod->module_core + info->stroffs;
 	src = mod->symtab;
-	*s++ = 0;
 	for (ndst = i = 0; i < mod->num_symtab; i++) {
 		if (i == 0 ||
 		    is_core_symbol(src+i, info->sechdrs, info->hdr->e_shnum)) {
-- 1.7.2.5 

