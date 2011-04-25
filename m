Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758278Ab1DYPaU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Apr 2011 11:30:20 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:47591 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754999Ab1DYPaQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Apr 2011 11:30:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=ksplice.com; s=google;
        h=date:from:x-x-sender:to:cc:subject:message-id:user-agent
         :mime-version:content-type;
        b=b3uADeqGTHApuNnhBacPSnPn/M8JkVufrRiKznaEHWxwlOgKYuLS7tZOh34qnB9egx
         RBP0MyvrDSJE0xmvxXOcGRjASbz19q6ndHHaXA/lZEV3ZWnl1zrHc/pzL/gW99jhRX5T
         DVrQ/DyjRL+jY7opVkFGq8Ja0xfKHNzg/WTaw=
Date: Mon, 25 Apr 2011 11:30:13 -0400 (EDT)
From: Anders Kaseorg <andersk@ksplice.com>
X-X-Sender: andersk@dr-wily.mit.edu
To: Michal Marek <mmarek@suse.cz>, Rusty Russell <rusty@rustcorp.com.au>
cc: Denys Vlasenko <vda.linux@googlemail.com>,
        Tim Abbott <tabbott@ksplice.com>, linux-kernel@vger.kernel.org
Subject: [PATCH] modpost: Update 64k section support for binutils 2.18.50
Message-ID: <alpine.DEB.2.02.1104251122320.26664@dr-wily.mit.edu>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Binutils 2.18.50 made a backwards-incompatible change in the way it
writes ELF objects with over 65280 sections, to improve conformance
with the ELF specification and interoperability with other ELF tools.
Specifically, it no longer adds 256 to section indices SHN_LORESERVE
and higher to skip over the reserved range SHN_LORESERVE through
SHN_HIRESERVE; those values are only considered special in the
st_shndx field, and not in other places where section indices are
stored.  See:

http://sourceware.org/bugzilla/show_bug.cgi?id=5900
http://groups.google.com/group/generic-abi/browse_thread/thread/e8bb63714b072e67/6c63738f12cc8a17

Signed-off-by: Anders Kaseorg <andersk@ksplice.com>
---
 scripts/mod/modpost.c |   16 ++++++----------
 scripts/mod/modpost.h |   27 ++++++++-------------------
 2 files changed, 14 insertions(+), 29 deletions(-)

diff --git a/scripts/mod/modpost.c b/scripts/mod/modpost.c
index cd104af..413c536 100644
--- a/scripts/mod/modpost.c
+++ b/scripts/mod/modpost.c
@@ -420,11 +420,10 @@ static int parse_elf(struct elf_info *info, const char *filename)
 		return 0;
 	}
 
-	if (hdr->e_shnum == 0) {
+	if (hdr->e_shnum == SHN_UNDEF) {
 		/*
 		 * There are more than 64k sections,
 		 * read count from .sh_size.
-		 * note: it doesn't need shndx2secindex()
 		 */
 		info->num_sections = TO_NATIVE(sechdrs[0].sh_size);
 	}
@@ -432,8 +431,7 @@ static int parse_elf(struct elf_info *info, const char *filename)
 		info->num_sections = hdr->e_shnum;
 	}
 	if (hdr->e_shstrndx == SHN_XINDEX) {
-		info->secindex_strings =
-		    shndx2secindex(TO_NATIVE(sechdrs[0].sh_link));
+		info->secindex_strings = TO_NATIVE(sechdrs[0].sh_link);
 	}
 	else {
 		info->secindex_strings = hdr->e_shstrndx;
@@ -489,7 +487,7 @@ static int parse_elf(struct elf_info *info, const char *filename)
 			    sechdrs[i].sh_offset;
 			info->symtab_stop  = (void *)hdr +
 			    sechdrs[i].sh_offset + sechdrs[i].sh_size;
-			sh_link_idx = shndx2secindex(sechdrs[i].sh_link);
+			sh_link_idx = sechdrs[i].sh_link;
 			info->strtab       = (void *)hdr +
 			    sechdrs[sh_link_idx].sh_offset;
 		}
@@ -516,11 +514,9 @@ static int parse_elf(struct elf_info *info, const char *filename)
 
 	if (symtab_shndx_idx != ~0U) {
 		Elf32_Word *p;
-		if (symtab_idx !=
-		    shndx2secindex(sechdrs[symtab_shndx_idx].sh_link))
+		if (symtab_idx != sechdrs[symtab_shndx_idx].sh_link)
 			fatal("%s: SYMTAB_SHNDX has bad sh_link: %u!=%u\n",
-			      filename,
-			      shndx2secindex(sechdrs[symtab_shndx_idx].sh_link),
+			      filename, sechdrs[symtab_shndx_idx].sh_link,
 			      symtab_idx);
 		/* Fix endianness */
 		for (p = info->symtab_shndx_start; p < info->symtab_shndx_stop;
@@ -1446,7 +1442,7 @@ static unsigned int *reloc_location(struct elf_info *elf,
 				    Elf_Shdr *sechdr, Elf_Rela *r)
 {
 	Elf_Shdr *sechdrs = elf->sechdrs;
-	int section = shndx2secindex(sechdr->sh_info);
+	int section = sechdr->sh_info;
 
 	return (void *)elf->hdr + sechdrs[section].sh_offset +
 		r->r_offset;
diff --git a/scripts/mod/modpost.h b/scripts/mod/modpost.h
index 0388cfc..2031119 100644
--- a/scripts/mod/modpost.h
+++ b/scripts/mod/modpost.h
@@ -145,33 +145,22 @@ static inline int is_shndx_special(unsigned int i)
 	return i != SHN_XINDEX && i >= SHN_LORESERVE && i <= SHN_HIRESERVE;
 }
 
-/* shndx is in [0..SHN_LORESERVE) U (SHN_HIRESERVE, 0xfffffff], thus:
- * shndx == 0               <=> sechdrs[0]
- * ......
- * shndx == SHN_LORESERVE-1 <=> sechdrs[SHN_LORESERVE-1]
- * shndx == SHN_HIRESERVE+1 <=> sechdrs[SHN_LORESERVE]
- * shndx == SHN_HIRESERVE+2 <=> sechdrs[SHN_LORESERVE+1]
- * ......
- * fyi: sym->st_shndx is uint16, SHN_LORESERVE = ff00, SHN_HIRESERVE = ffff,
- * so basically we map  0000..feff -> 0000..feff
- *                      ff00..ffff -> (you are a bad boy, dont do it)
- *                     10000..xxxx -> ff00..(xxxx-0x100)
+/*
+ * Move reserved section indices SHN_LORESERVE..SHN_HIRESERVE out of
+ * the way to -256..-1, to avoid conflicting with real section
+ * indices.
  */
-static inline unsigned int shndx2secindex(unsigned int i)
-{
-	if (i <= SHN_HIRESERVE)
-		return i;
-	return i - (SHN_HIRESERVE + 1 - SHN_LORESERVE);
-}
+#define SPECIAL(i) ((i) - (SHN_HIRESERVE + 1))
 
 /* Accessor for sym->st_shndx, hides ugliness of "64k sections" */
 static inline unsigned int get_secindex(const struct elf_info *info,
 					const Elf_Sym *sym)
 {
+	if (is_shndx_special(sym->st_shndx))
+		return SPECIAL(sym->st_shndx);
 	if (sym->st_shndx != SHN_XINDEX)
 		return sym->st_shndx;
-	return shndx2secindex(info->symtab_shndx_start[sym -
-						       info->symtab_start]);
+	return info->symtab_shndx_start[sym - info->symtab_start];
 }
 
 /* file2alias.c */
-- 
1.7.5.rc3

