Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752388Ab0FCMPI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jun 2010 08:15:08 -0400
Received: from smtp.nokia.com ([192.100.105.134]:19313 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751998Ab0FCMOs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jun 2010 08:14:48 -0400
From: Phil Carmody <ext-phil.2.carmody@nokia.com>
To: linux@arm.linux.org.uk, catalin.marinas@arm.com
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/3] ARM: module - simplify unwind table handling
Date: Thu,  3 Jun 2010 15:17:21 +0300
Message-Id: <1275567442-11370-3-git-send-email-ext-phil.2.carmody@nokia.com>
X-Mailer: git-send-email 1.6.0.4
In-Reply-To: <1275567442-11370-2-git-send-email-ext-phil.2.carmody@nokia.com>
References: <1275567442-11370-1-git-send-email-ext-phil.2.carmody@nokia.com>
 <1275567442-11370-2-git-send-email-ext-phil.2.carmody@nokia.com>
X-OriginalArrivalTime: 03 Jun 2010 12:14:25.0682 (UTC) FILETIME=[4ED33720:01CB0316]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The various sections are all dealt with similarly, so factor out
that common behaviour.

Signed-off-by: Phil Carmody <ext-phil.2.carmody@nokia.com>
---
 arch/arm/include/asm/module.h |   29 +++++++++++++++----------
 arch/arm/kernel/module.c      |   46 +++++++++++++++++------------------------
 2 files changed, 36 insertions(+), 39 deletions(-)

diff --git a/arch/arm/include/asm/module.h b/arch/arm/include/asm/module.h
index e4dfa69..2164061 100644
--- a/arch/arm/include/asm/module.h
+++ b/arch/arm/include/asm/module.h
@@ -7,20 +7,25 @@
 
 struct unwind_table;
 
-struct mod_arch_specific
-{
 #ifdef CONFIG_ARM_UNWIND
-	Elf_Shdr *unw_sec_init;
-	Elf_Shdr *unw_sec_devinit;
-	Elf_Shdr *unw_sec_core;
-	Elf_Shdr *sec_init_text;
-	Elf_Shdr *sec_devinit_text;
-	Elf_Shdr *sec_core_text;
-	struct unwind_table *unwind_init;
-	struct unwind_table *unwind_devinit;
-	struct unwind_table *unwind_core;
-#endif
+struct arm_unwind_mapping {
+	Elf_Shdr *unw_sec;
+	Elf_Shdr *sec_text;
+	struct unwind_table *unwind;
+};
+enum {
+	ARM_SEC_INIT,
+	ARM_SEC_DEVINIT,
+	ARM_SEC_CORE,
+	ARM_SEC_MAX,
 };
+struct mod_arch_specific {
+	struct arm_unwind_mapping map[ARM_SEC_MAX];
+};
+#else
+struct mod_arch_specific {
+}
+#endif
 
 /*
  * Include the ARM architecture version.
diff --git a/arch/arm/kernel/module.c b/arch/arm/kernel/module.c
index d531a63..bcf928e 100644
--- a/arch/arm/kernel/module.c
+++ b/arch/arm/kernel/module.c
@@ -69,22 +69,23 @@ int module_frob_arch_sections(Elf_Ehdr *hdr,
 {
 #ifdef CONFIG_ARM_UNWIND
 	Elf_Shdr *s, *sechdrs_end = sechdrs + hdr->e_shnum;
+	struct arm_unwind_mapping *maps = mod->arch.map;
 
 	for (s = sechdrs; s < sechdrs_end; s++) {
 		char const *secname = secstrings + s->sh_name;
 
 		if (strcmp(".ARM.exidx.init.text", secname) == 0)
-			mod->arch.unw_sec_init = s;
+			maps[ARM_SEC_INIT].unw_sec = s;
 		else if (strcmp(".ARM.exidx.devinit.text", secname) == 0)
-			mod->arch.unw_sec_devinit = s;
+			maps[ARM_SEC_DEVINIT].unw_sec = s;
 		else if (strcmp(".ARM.exidx", secname) == 0)
-			mod->arch.unw_sec_core = s;
+			maps[ARM_SEC_CORE].unw_sec = s;
 		else if (strcmp(".init.text", secname) == 0)
-			mod->arch.sec_init_text = s;
+			maps[ARM_SEC_INIT].sec_text = s;
 		else if (strcmp(".devinit.text", secname) == 0)
-			mod->arch.sec_devinit_text = s;
+			maps[ARM_SEC_DEVINIT].sec_text = s;
 		else if (strcmp(".text", secname) == 0)
-			mod->arch.sec_core_text = s;
+			maps[ARM_SEC_CORE].sec_text = s;
 	}
 #endif
 	return 0;
@@ -260,31 +261,22 @@ apply_relocate_add(Elf32_Shdr *sechdrs, const char *strtab,
 #ifdef CONFIG_ARM_UNWIND
 static void register_unwind_tables(struct module *mod)
 {
-	if (mod->arch.unw_sec_init && mod->arch.sec_init_text)
-		mod->arch.unwind_init =
-			unwind_table_add(mod->arch.unw_sec_init->sh_addr,
-					 mod->arch.unw_sec_init->sh_size,
-					 mod->arch.sec_init_text->sh_addr,
-					 mod->arch.sec_init_text->sh_size);
-	if (mod->arch.unw_sec_devinit && mod->arch.sec_devinit_text)
-		mod->arch.unwind_devinit =
-			unwind_table_add(mod->arch.unw_sec_devinit->sh_addr,
-					 mod->arch.unw_sec_devinit->sh_size,
-					 mod->arch.sec_devinit_text->sh_addr,
-					 mod->arch.sec_devinit_text->sh_size);
-	if (mod->arch.unw_sec_core && mod->arch.sec_core_text)
-		mod->arch.unwind_core =
-			unwind_table_add(mod->arch.unw_sec_core->sh_addr,
-					 mod->arch.unw_sec_core->sh_size,
-					 mod->arch.sec_core_text->sh_addr,
-					 mod->arch.sec_core_text->sh_size);
+	int i;
+	for (i = 0; i < ARM_SEC_MAX; ++i) {
+		struct arm_unwind_mapping *map = &mod->arch.map[i];
+		if (map->unw_sec && map->sec_text)
+			map->unwind = unwind_table_add(map->unw_sec->sh_addr,
+						       map->unw_sec->sh_size,
+						       map->sec_text->sh_addr,
+						       map->sec_text->sh_size);
+	}
 }
 
 static void unregister_unwind_tables(struct module *mod)
 {
-	unwind_table_del(mod->arch.unwind_init);
-	unwind_table_del(mod->arch.unwind_devinit);
-	unwind_table_del(mod->arch.unwind_core);
+	int i = ARM_SEC_MAX;
+	while (--i >= 0)
+		unwind_table_del(mod->arch.map[i].unwind);
 }
 #else
 static inline void register_unwind_tables(struct module *mod) { }
-- 
1.6.0.4

