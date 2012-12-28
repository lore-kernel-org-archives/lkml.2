Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754365Ab2L1UlA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Dec 2012 15:41:00 -0500
Received: from jacques.telenet-ops.be ([195.130.132.50]:38925 "EHLO
	jacques.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754003Ab2L1Uk7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Dec 2012 15:40:59 -0500
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Ralf Baechle <ralf@linux-mips.org>, linux-mips@linux-mips.org
Cc: linux-kernel@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH] mips: Export min_low_pfn if CONFIG_FLATMEM
Date: Fri, 28 Dec 2012 21:40:56 +0100
Message-Id: <1356727256-3172-1-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If CONFIG_FLATMEM=y on MIPS, pfn_valid() (and thus virt_addr_valid()) uses
min_low_pfn. However, min_low_pfn is not exported by the generic bootmem
code.

As of commit e52a29326462badd9ceec90a9eb2ac2a8550e02e ("aoe: avoid races
between device destruction and discovery"), aoeblk_open() uses
virt_addr_valid(), causing a link error in the modular case:

    ERROR: "min_low_pfn" [drivers/block/aoe/aoe.ko] undefined!

Add a custom export to fix this, just like is done for ia64 in
arch/ia64/kernel/ia64_ksyms.c.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
http://kisskb.ellerman.id.au/kisskb/buildresult/7864918/

 arch/mips/kernel/mips_ksyms.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/arch/mips/kernel/mips_ksyms.c b/arch/mips/kernel/mips_ksyms.c
index df1e3e4..8579bb8 100644
--- a/arch/mips/kernel/mips_ksyms.c
+++ b/arch/mips/kernel/mips_ksyms.c
@@ -60,3 +60,8 @@ EXPORT_SYMBOL(invalid_pte_table);
 /* _mcount is defined in arch/mips/kernel/mcount.S */
 EXPORT_SYMBOL(_mcount);
 #endif
+
+#ifdef CONFIG_FLATMEM
+#include <linux/bootmem.h>
+EXPORT_SYMBOL(min_low_pfn);	/* defined by bootmem.c, but not exported by generic code */
+#endif
-- 
1.7.0.4

