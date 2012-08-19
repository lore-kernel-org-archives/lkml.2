Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755748Ab2HSDAy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Aug 2012 23:00:54 -0400
Received: from mga02.intel.com ([134.134.136.20]:14941 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753707Ab2HSC5l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Aug 2012 22:57:41 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.77,792,1336374000"; 
   d="scan'208";a="182422059"
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org
Cc: x86@kernel.org, mmarek@suse.cz, linux-kbuild@vger.kernel.org,
        JBeulich@suse.com, akpm@linux-foundation.org,
        Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 28/74] lto: Make ksymtab and kcrctab symbols and __this_module __visible
Date: Sat, 18 Aug 2012 19:56:24 -0700
Message-Id: <1345345030-22211-29-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1345345030-22211-1-git-send-email-andi@firstfloor.org>
References: <1345345030-22211-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

Make the ksymtab symbols for EXPORT_SYMBOL visible.
This prevents the LTO compiler from adding a .NUMBER prefix,
which avoids various problems in later export processing.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 include/linux/export.h |    4 ++--
 scripts/mod/modpost.c  |    2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/include/linux/export.h b/include/linux/export.h
index 784617e..77a3e8c 100644
--- a/include/linux/export.h
+++ b/include/linux/export.h
@@ -36,7 +36,7 @@ extern struct module __this_module;
 /* Mark the CRC weak since genksyms apparently decides not to
  * generate a checksums for some symbols */
 #define __CRC_SYMBOL(sym, sec)					\
-	extern void *__crc_##sym __attribute__((weak));		\
+	extern __visible void *__crc_##sym __attribute__((weak));		\
 	static const unsigned long __kcrctab_##sym		\
 	__used							\
 	__attribute__((section("___kcrctab" sec "+" #sym), unused))	\
@@ -52,7 +52,7 @@ extern struct module __this_module;
 	static const char __kstrtab_##sym[]			\
 	__attribute__((section("__ksymtab_strings"), aligned(1))) \
 	= MODULE_SYMBOL_PREFIX #sym;				\
-	static const struct kernel_symbol __ksymtab_##sym	\
+	__visible const struct kernel_symbol __ksymtab_##sym	\
 	__used							\
 	__attribute__((section("___ksymtab" sec "+" #sym), unused))	\
 	= { (unsigned long)&sym, __kstrtab_##sym }
diff --git a/scripts/mod/modpost.c b/scripts/mod/modpost.c
index 68e9f5e..c797e95 100644
--- a/scripts/mod/modpost.c
+++ b/scripts/mod/modpost.c
@@ -1862,7 +1862,7 @@ static void add_header(struct buffer *b, struct module *mod)
 	buf_printf(b, "\n");
 	buf_printf(b, "MODULE_INFO(vermagic, VERMAGIC_STRING);\n");
 	buf_printf(b, "\n");
-	buf_printf(b, "struct module __this_module\n");
+	buf_printf(b, "__visible struct module __this_module\n");
 	buf_printf(b, "__attribute__((section(\".gnu.linkonce.this_module\"))) = {\n");
 	buf_printf(b, "\t.name = KBUILD_MODNAME,\n");
 	if (mod->has_init)
-- 
1.7.7.6

