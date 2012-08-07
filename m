Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753890Ab2HGJoG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 05:44:06 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:55377 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751170Ab2HGJoD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 05:44:03 -0400
From: Jonas Gorski <jonas.gorski@gmail.com>
To: David Howells <dhowells@redhat.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>, Ralf Baechle <ralf@linux-mips.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-mips@linux-mips.org
Subject: [PATCH] MIPS: fix module.c build for 32 bit
Date: Tue,  7 Aug 2012 11:41:13 +0200
Message-Id: <1344332473-19842-1-git-send-email-jonas.gorski@gmail.com>
X-Mailer: git-send-email 1.7.2.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixes the following build failure introduced by "Make most arch
asm/module.h files use asm-generic/module.h".

  CC      arch/mips/kernel/module.o
arch/mips/kernel/module.c:250:14: error: 'reloc_handlers_rela' defined but not used [-Werror=unused-variable]
cc1: all warnings being treated as errors

make[6]: *** [arch/mips/kernel/module.o] Error 1

Signed-off-by: Jonas Gorski <jonas.gorski@gmail.com>

---
I don't mind this patch being squashed into the original patch. The
patch isn't in any stable git yet, so I assume any git id would be
outdated soon anyway.

Linus, I CC'd you because there already is a pending pull request for
this patch.

David, it would have been nice if the mentioned patch had made it to 
linux-mips. I just caught this more or less by accident by building
linux-next.

 arch/mips/kernel/module.c |   10 ++++++++++
 1 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/arch/mips/kernel/module.c b/arch/mips/kernel/module.c
index 1500c80..afbd717 100644
--- a/arch/mips/kernel/module.c
+++ b/arch/mips/kernel/module.c
@@ -65,12 +65,14 @@ static int apply_r_mips_32_rel(struct module *me, u32 *location, Elf_Addr v)
 	return 0;
 }
 
+#ifdef CONFIG_MODULES_USE_ELF_RELA
 static int apply_r_mips_32_rela(struct module *me, u32 *location, Elf_Addr v)
 {
 	*location = v;
 
 	return 0;
 }
+#endif
 
 static int apply_r_mips_26_rel(struct module *me, u32 *location, Elf_Addr v)
 {
@@ -93,6 +95,7 @@ static int apply_r_mips_26_rel(struct module *me, u32 *location, Elf_Addr v)
 	return 0;
 }
 
+#ifdef CONFIG_MODULES_USE_ELF_RELA
 static int apply_r_mips_26_rela(struct module *me, u32 *location, Elf_Addr v)
 {
 	if (v % 4) {
@@ -112,6 +115,7 @@ static int apply_r_mips_26_rela(struct module *me, u32 *location, Elf_Addr v)
 
 	return 0;
 }
+#endif
 
 static int apply_r_mips_hi16_rel(struct module *me, u32 *location, Elf_Addr v)
 {
@@ -134,6 +138,7 @@ static int apply_r_mips_hi16_rel(struct module *me, u32 *location, Elf_Addr v)
 	return 0;
 }
 
+#ifdef CONFIG_MODULES_USE_ELF_RELA
 static int apply_r_mips_hi16_rela(struct module *me, u32 *location, Elf_Addr v)
 {
 	*location = (*location & 0xffff0000) |
@@ -141,6 +146,7 @@ static int apply_r_mips_hi16_rela(struct module *me, u32 *location, Elf_Addr v)
 
 	return 0;
 }
+#endif
 
 static int apply_r_mips_lo16_rel(struct module *me, u32 *location, Elf_Addr v)
 {
@@ -206,6 +212,7 @@ out_danger:
 	return -ENOEXEC;
 }
 
+#ifdef CONFIG_MODULES_USE_ELF_RELA
 static int apply_r_mips_lo16_rela(struct module *me, u32 *location, Elf_Addr v)
 {
 	*location = (*location & 0xffff0000) | (v & 0xffff);
@@ -237,6 +244,7 @@ static int apply_r_mips_highest_rela(struct module *me, u32 *location,
 
 	return 0;
 }
+#endif
 
 static int (*reloc_handlers_rel[]) (struct module *me, u32 *location,
 				Elf_Addr v) = {
@@ -247,6 +255,7 @@ static int (*reloc_handlers_rel[]) (struct module *me, u32 *location,
 	[R_MIPS_LO16]		= apply_r_mips_lo16_rel
 };
 
+#ifdef CONFIG_MODULES_USE_ELF_RELA
 static int (*reloc_handlers_rela[]) (struct module *me, u32 *location,
 				Elf_Addr v) = {
 	[R_MIPS_NONE]		= apply_r_mips_none,
@@ -258,6 +267,7 @@ static int (*reloc_handlers_rela[]) (struct module *me, u32 *location,
 	[R_MIPS_HIGHER]		= apply_r_mips_higher_rela,
 	[R_MIPS_HIGHEST]	= apply_r_mips_highest_rela
 };
+#endif
 
 int apply_relocate(Elf_Shdr *sechdrs, const char *strtab,
 		   unsigned int symindex, unsigned int relsec,
-- 
1.7.2.5

