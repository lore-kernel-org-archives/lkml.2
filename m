Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758907Ab0D3UKq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Apr 2010 16:10:46 -0400
Received: from mail.windriver.com ([147.11.1.11]:65196 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932460Ab0D3UKm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Apr 2010 16:10:42 -0400
From: Liang Li <liang.li@windriver.com>
To: linux-kernel@vger.kernel.org, mingo@elte.hu, akpm@linux-foundation.org
Cc: wangchen@cn.fujitsu.com, tglx@linutronix.de, hpa@zytor.com,
       yinghai@kernel.org, jeremy.fitzhardinge@citrix.com,
       konrad.wilk@oracle.com
Subject: [v3 PATCH] x86: let 'reservetop' functioning right
Date: Fri, 30 Apr 2010 18:01:51 +0800
Message-Id: <1272621711-8683-1-git-send-email-liang.li@windriver.com>
X-Mailer: git-send-email 1.6.6
X-OriginalArrivalTime: 30 Apr 2010 10:03:47.0599 (UTC) FILETIME=[6CEB29F0:01CAE84C]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When specify 'reservetop=0xbadc0de' kernel parameter, the kernel will
stop booting due to a early_ioremap bug that relate to commit 8827247ff.

The root cause of boot failure problem is the value of 'slot_virt[i]'
was initialized in setup_arch->early_ioremap_init. But later in
setup_arch, the function 'parse_early_param' will modify 'FIXADDR_TOP'
when 'reservetop=0xbadc0de' being specified.

The simplest fix might be use __fix_to_virt(idx0) to get updated value
of 'FIXADDR_TOP' in '__early_ioremap' instead of reference old value
from slot_virt[slot] directly.

Changelog since v0:

-v1: When reservetop being handled then FIXADDR_TOP get adjusted, Hence
check prev_map then re-initialize slot_virt and PMD based on new
FIXADDR_TOP.

-v2: place fixup_early_ioremap hence call early_ioremap_init in
reserve_top_address  to re-initialize slot_virt and corresponding PMD
when parse_reservertop

-v3: move fixup_early_ioremap out of reserve_top_address to make sure
other clients of reserve_top_address like xen/lguest won't broken

Signed-off-by: Liang Li <liang.li@windriver.com>
Cc: Wang Chen <wangchen@cn.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Acked-by: Yinghai Lu <yinghai@kernel.org>
Acked-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Tested-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
Hi all,

Just resend the patch according to Ingo's demand.
Thanks.

 arch/x86/include/asm/io.h |    1 +
 arch/x86/mm/ioremap.c     |   15 +++++++++++++++
 arch/x86/mm/pgtable_32.c  |    1 +
 3 files changed, 17 insertions(+), 0 deletions(-)

diff --git a/arch/x86/include/asm/io.h b/arch/x86/include/asm/io.h
index a1dcfa3..30a3e97 100644
--- a/arch/x86/include/asm/io.h
+++ b/arch/x86/include/asm/io.h
@@ -347,6 +347,7 @@ extern void __iomem *early_ioremap(resource_size_t phys_addr,
 extern void __iomem *early_memremap(resource_size_t phys_addr,
 				    unsigned long size);
 extern void early_iounmap(void __iomem *addr, unsigned long size);
+extern void fixup_early_ioremap(void);
 
 #define IO_SPACE_LIMIT 0xffff
 
diff --git a/arch/x86/mm/ioremap.c b/arch/x86/mm/ioremap.c
index 5eb1ba7..e4ab706 100644
--- a/arch/x86/mm/ioremap.c
+++ b/arch/x86/mm/ioremap.c
@@ -448,6 +448,21 @@ static inline void __init early_clear_fixmap(enum fixed_addresses idx)
 static void __iomem *prev_map[FIX_BTMAPS_SLOTS] __initdata;
 static unsigned long prev_size[FIX_BTMAPS_SLOTS] __initdata;
 
+void __init fixup_early_ioremap(void)
+{
+	int i;
+	for (i = 0; i < FIX_BTMAPS_SLOTS; i++) {
+		if (prev_map[i])
+			break;
+	}
+
+	if (i < FIX_BTMAPS_SLOTS)
+		BUG_ON(1);
+
+	early_ioremap_init();
+	return;
+}
+
 static int __init check_early_ioremap_leak(void)
 {
 	int count = 0;
diff --git a/arch/x86/mm/pgtable_32.c b/arch/x86/mm/pgtable_32.c
index 1a8faf0..26eadaa 100644
--- a/arch/x86/mm/pgtable_32.c
+++ b/arch/x86/mm/pgtable_32.c
@@ -128,6 +128,7 @@ static int __init parse_reservetop(char *arg)
 
 	address = memparse(arg, &arg);
 	reserve_top_address(address);
+	fixup_early_ioremap();
 	return 0;
 }
 early_param("reservetop", parse_reservetop);
-- 
1.6.6

