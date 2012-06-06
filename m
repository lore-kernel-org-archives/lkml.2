Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756610Ab2FFPRp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 11:17:45 -0400
Received: from terminus.zytor.com ([198.137.202.10]:39890 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752543Ab2FFPRn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 11:17:43 -0400
Date: Wed, 6 Jun 2012 08:17:03 -0700
From: tip-bot for Xiaotian Feng <xtfeng@gmail.com>
Message-ID: <tip-aff5a62d52ff03956ff6992b9fe4b561fd855804@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        dannyfeng@tencent.com, tj@kernel.org, tglx@linutronix.de,
        xtfeng@gmail.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        dannyfeng@tencent.com, tj@kernel.org, tglx@linutronix.de,
        xtfeng@gmail.com
In-Reply-To: <1338922831-2847-1-git-send-email-xtfeng@gmail.com>
References: <1338922831-2847-1-git-send-email-xtfeng@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86/gart: Fix kmemleak warning
Git-Commit-ID: aff5a62d52ff03956ff6992b9fe4b561fd855804
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Wed, 06 Jun 2012 08:17:10 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  aff5a62d52ff03956ff6992b9fe4b561fd855804
Gitweb:     http://git.kernel.org/tip/aff5a62d52ff03956ff6992b9fe4b561fd855804
Author:     Xiaotian Feng <xtfeng@gmail.com>
AuthorDate: Tue, 5 Jun 2012 15:00:31 -0400
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 6 Jun 2012 11:58:38 +0200

x86/gart: Fix kmemleak warning

aperture_64.c now is using memblock, the previous
kmemleak_ignore() for alloc_bootmem() should be removed then.

Otherwise, with kmemleak enabled, kernel will throw warnings
like:

[    0.000000] kmemleak: Trying to color unknown object at 0xffff8800c4000000 as Black
[    0.000000] Pid: 0, comm: swapper/0 Not tainted 3.5.0-rc1-next-20120605+ #130
[    0.000000] Call Trace:
[    0.000000]  [<ffffffff811b27e6>] paint_ptr+0x66/0xc0
[    0.000000]  [<ffffffff816b90fb>] kmemleak_ignore+0x2b/0x60
[    0.000000]  [<ffffffff81ef7bc0>] kmemleak_init+0x217/0x2c1
[    0.000000]  [<ffffffff81ed2b97>] start_kernel+0x32d/0x3eb
[    0.000000]  [<ffffffff81ed25e4>] ? repair_env_string+0x5a/0x5a
[    0.000000]  [<ffffffff81ed2356>] x86_64_start_reservations+0x131/0x135
[    0.000000]  [<ffffffff81ed2120>] ? early_idt_handlers+0x120/0x120
[    0.000000]  [<ffffffff81ed245c>] x86_64_start_kernel+0x102/0x111
[    0.000000] kmemleak: Early log backtrace:
[    0.000000]    [<ffffffff816b911b>] kmemleak_ignore+0x4b/0x60
[    0.000000]    [<ffffffff81ee6a38>] gart_iommu_hole_init+0x3e7/0x547
[    0.000000]    [<ffffffff81edb20b>] pci_iommu_alloc+0x44/0x6f
[    0.000000]    [<ffffffff81ee81ad>] mem_init+0x19/0xec
[    0.000000]    [<ffffffff81ed2a54>] start_kernel+0x1ea/0x3eb
[    0.000000]    [<ffffffff81ed2356>] x86_64_start_reservations+0x131/0x135
[    0.000000]    [<ffffffff81ed245c>] x86_64_start_kernel+0x102/0x111
[    0.000000]    [<ffffffffffffffff>] 0xffffffffffffffff

Signed-off-by: Xiaotian Feng <dannyfeng@tencent.com>
Cc: Xiaotian Feng <xtfeng@gmail.com>
Cc: Tejun Heo <tj@kernel.org>
Link: http://lkml.kernel.org/r/1338922831-2847-1-git-send-email-xtfeng@gmail.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/kernel/aperture_64.c |    6 ------
 1 files changed, 0 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kernel/aperture_64.c b/arch/x86/kernel/aperture_64.c
index 6e76c19..d5fd66f 100644
--- a/arch/x86/kernel/aperture_64.c
+++ b/arch/x86/kernel/aperture_64.c
@@ -20,7 +20,6 @@
 #include <linux/bitops.h>
 #include <linux/ioport.h>
 #include <linux/suspend.h>
-#include <linux/kmemleak.h>
 #include <asm/e820.h>
 #include <asm/io.h>
 #include <asm/iommu.h>
@@ -95,11 +94,6 @@ static u32 __init allocate_aperture(void)
 		return 0;
 	}
 	memblock_reserve(addr, aper_size);
-	/*
-	 * Kmemleak should not scan this block as it may not be mapped via the
-	 * kernel direct mapping.
-	 */
-	kmemleak_ignore(phys_to_virt(addr));
 	printk(KERN_INFO "Mapping aperture over %d KB of RAM @ %lx\n",
 			aper_size >> 10, addr);
 	insert_aperture_resource((u32)addr, aper_size);
