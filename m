Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758160Ab0D3Q7E (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Apr 2010 12:59:04 -0400
Received: from hera.kernel.org ([140.211.167.34]:60359 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758018Ab0D3Q6h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Apr 2010 12:58:37 -0400
Date: Fri, 30 Apr 2010 10:52:11 GMT
From: tip-bot for Liang Li <liang.li@windriver.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       yinghai@kernel.org, konrad.wilk@oracle.com, liang.li@windriver.com,
       wangchen@cn.fujitsu.com, jeremy.fitzhardinge@citrix.com,
       akpm@linux-foundation.org, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       liang.li@windriver.com, konrad.wilk@oracle.com, yinghai@kernel.org,
       wangchen@cn.fujitsu.com, jeremy.fitzhardinge@citrix.com,
       akpm@linux-foundation.org, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1272621711-8683-1-git-send-email-liang.li@windriver.com>
References: <1272621711-8683-1-git-send-email-liang.li@windriver.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86: Fix 'reservetop=' functionality
Message-ID: <tip-e67a807f3d9a82fa91817871f1c0e2e04da993b8@git.kernel.org>
Git-Commit-ID: e67a807f3d9a82fa91817871f1c0e2e04da993b8
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 30 Apr 2010 10:52:12 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  e67a807f3d9a82fa91817871f1c0e2e04da993b8
Gitweb:     http://git.kernel.org/tip/e67a807f3d9a82fa91817871f1c0e2e04da993b8
Author:     Liang Li <liang.li@windriver.com>
AuthorDate: Fri, 30 Apr 2010 18:01:51 +0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 30 Apr 2010 12:19:53 +0200

x86: Fix 'reservetop=' functionality

When specifying the 'reservetop=0xbadc0de' kernel parameter,
the kernel will stop booting due to a early_ioremap bug that
relates to commit 8827247ff.

The root cause of boot failure problem is the value of
'slot_virt[i]' was initialized in setup_arch->early_ioremap_init().
But later in setup_arch, the function 'parse_early_param' will
modify 'FIXADDR_TOP' when 'reservetop=0xbadc0de' being specified.

The simplest fix might be use __fix_to_virt(idx0) to get updated
value of 'FIXADDR_TOP' in '__early_ioremap' instead of reference
old value from slot_virt[slot] directly.

Changelog since v0:

-v1: When reservetop being handled then FIXADDR_TOP get
     adjusted, Hence check prev_map then re-initialize slot_virt and
     PMD based on new FIXADDR_TOP.

-v2: place fixup_early_ioremap hence call early_ioremap_init in
     reserve_top_address  to re-initialize slot_virt and
     corresponding PMD when parse_reservertop

-v3: move fixup_early_ioremap out of reserve_top_address to make
     sure other clients of reserve_top_address like xen/lguest won't
     broken

Signed-off-by: Liang Li <liang.li@windriver.com>
Tested-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Acked-by: Yinghai Lu <yinghai@kernel.org>
Acked-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Cc: Wang Chen <wangchen@cn.fujitsu.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
LKML-Reference: <1272621711-8683-1-git-send-email-liang.li@windriver.com>
[ fixed three small cleanliness details in fixup_early_ioremap() ]
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/include/asm/io.h |    1 +
 arch/x86/mm/ioremap.c     |   14 ++++++++++++++
 arch/x86/mm/pgtable_32.c  |    1 +
 3 files changed, 16 insertions(+), 0 deletions(-)

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
index 5eb1ba7..12e4d2d 100644
--- a/arch/x86/mm/ioremap.c
+++ b/arch/x86/mm/ioremap.c
@@ -448,6 +448,20 @@ static inline void __init early_clear_fixmap(enum fixed_addresses idx)
 static void __iomem *prev_map[FIX_BTMAPS_SLOTS] __initdata;
 static unsigned long prev_size[FIX_BTMAPS_SLOTS] __initdata;
 
+void __init fixup_early_ioremap(void)
+{
+	int i;
+
+	for (i = 0; i < FIX_BTMAPS_SLOTS; i++) {
+		if (prev_map[i]) {
+			WARN_ON(1);
+			break;
+		}
+	}
+
+	early_ioremap_init();
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
