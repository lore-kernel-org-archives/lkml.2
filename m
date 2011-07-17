Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756209Ab1GQPKo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jul 2011 11:10:44 -0400
Received: from mail.southpole.se ([193.12.106.18]:34900 "EHLO
	mail.southpole.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755908Ab1GQPJk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jul 2011 11:09:40 -0400
From: Jonas Bonn <jonas@southpole.se>
To: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Cc: Jonas Bonn <jonas@southpole.se>
Subject: [PATCH v3 14/19] OpenRISC: Module support
Date: Sun, 17 Jul 2011 17:08:24 +0200
Message-Id: <41fa99ff7e0eb9d55ace8ebc628c667b8545e104.1310913472.git.jonas@southpole.se>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <cover.1310913472.git.jonas@southpole.se>
References: <cover.1310913472.git.jonas@southpole.se>
In-Reply-To: <cover.1310913472.git.jonas@southpole.se>
References: <cover.1310913472.git.jonas@southpole.se>
X-Assp-Client-SSL: yes
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Jonas Bonn <jonas@southpole.se>
Reviewed-by: Arnd Bergmann <arnd@arndb.de>
---
 arch/openrisc/kernel/module.c |   72 +++++++++++++++++++++++++++++++++++++++++
 1 files changed, 72 insertions(+), 0 deletions(-)
 create mode 100644 arch/openrisc/kernel/module.c

diff --git a/arch/openrisc/kernel/module.c b/arch/openrisc/kernel/module.c
new file mode 100644
index 0000000..10ff50f
--- /dev/null
+++ b/arch/openrisc/kernel/module.c
@@ -0,0 +1,72 @@
+/*
+ * OpenRISC module.c
+ *
+ * Linux architectural port borrowing liberally from similar works of
+ * others.  All original copyrights apply as per the original source
+ * declaration.
+ *
+ * Modifications for the OpenRISC architecture:
+ * Copyright (C) 2010-2011 Jonas Bonn <jonas@southpole.se>
+ *
+ *      This program is free software; you can redistribute it and/or
+ *      modify it under the terms of the GNU General Public License
+ *      as published by the Free Software Foundation; either version
+ *      2 of the License, or (at your option) any later version.
+ */
+
+#include <linux/moduleloader.h>
+#include <linux/elf.h>
+
+int apply_relocate_add(Elf32_Shdr *sechdrs,
+		       const char *strtab,
+		       unsigned int symindex,
+		       unsigned int relsec,
+		       struct module *me)
+{
+	unsigned int i;
+	Elf32_Rela *rel = (void *)sechdrs[relsec].sh_addr;
+	Elf32_Sym *sym;
+	uint32_t *location;
+	uint32_t value;
+
+	pr_debug("Applying relocate section %u to %u\n", relsec,
+		 sechdrs[relsec].sh_info);
+	for (i = 0; i < sechdrs[relsec].sh_size / sizeof(*rel); i++) {
+		/* This is where to make the change */
+		location = (void *)sechdrs[sechdrs[relsec].sh_info].sh_addr
+			+ rel[i].r_offset;
+
+		/* This is the symbol it is referring to.  Note that all
+		   undefined symbols have been resolved.  */
+		sym = (Elf32_Sym *)sechdrs[symindex].sh_addr
+			+ ELF32_R_SYM(rel[i].r_info);
+		value = sym->st_value + rel[i].r_addend;
+
+		switch (ELF32_R_TYPE(rel[i].r_info)) {
+		case R_OR32_32:
+			*location = value;
+			break;
+		case R_OR32_CONST:
+			location = (uint16_t *)location + 1;
+			*((uint16_t *)location) = (uint16_t) (value);
+			break;
+		case R_OR32_CONSTH:
+			location = (uint16_t *)location + 1;
+			*((uint16_t *)location) = (uint16_t) (value >> 16);
+			break;
+		case R_OR32_JUMPTARG:
+			value -= (uint32_t)location;
+			value >>= 2;
+			value &= 0x03ffffff;
+			value |= *location & 0xfc000000;
+			*location = value;
+			break;
+		default:
+			pr_err("module %s: Unknown relocation: %u\n",
+			       me->name, ELF32_R_TYPE(rel[i].r_info));
+			break;
+		}
+	}
+
+	return 0;
+}
-- 
1.7.4.1

