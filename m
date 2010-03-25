Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754380Ab0CYAzy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Mar 2010 20:55:54 -0400
Received: from mail.windriver.com ([147.11.1.11]:56554 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753925Ab0CYAzx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Mar 2010 20:55:53 -0400
From: Liang Li <liang.li@windriver.com>
To: mingo@elte.hu
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] x86: let 'reservetop' functioning right
Date: Thu, 25 Mar 2010 08:54:05 +0800
Message-Id: <1269478445-4335-1-git-send-email-liang.li@windriver.com>
X-Mailer: git-send-email 1.6.6
X-OriginalArrivalTime: 25 Mar 2010 00:55:41.0852 (UTC) FILETIME=[E49D65C0:01CACBB5]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When specify 'reservetop=0xabc000' kernel parameter, kernel will hang
on boot due to a early_ioremap bug that relate to commit 8827247ff.

The root cause of boot failure problem is the value of 'slot_virt[i]'
was initialized in setup_arch->early_ioremap_init. But later in
setup_arch, the function 'parse_early_param' will modify 'FIXADDR_TOP'
when 'reservetop=0xbadc0de' being specified.

The simplest fix might be use __fix_to_virt(idx0) to get updated value
of 'FIXADDR_TOP' in '__early_ioremap' instead of reference old value
from slot_virt[slot] directly.

Signed-off-by: Liang Li <liang.li@windriver.com>
---
 arch/x86/mm/ioremap.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/mm/ioremap.c b/arch/x86/mm/ioremap.c
index 5eb1ba7..ea82ef0 100644
--- a/arch/x86/mm/ioremap.c
+++ b/arch/x86/mm/ioremap.c
@@ -537,9 +537,9 @@ __early_ioremap(resource_size_t phys_addr, unsigned long size, pgprot_t prot)
 		--nrpages;
 	}
 	if (early_ioremap_debug)
-		printk(KERN_CONT "%08lx + %08lx\n", offset, slot_virt[slot]);
+		printk(KERN_CONT "%08lx + %08lx\n", offset, __fix_to_virt(idx0));
 
-	prev_map[slot] = (void __iomem *)(offset + slot_virt[slot]);
+	prev_map[slot] = (void __iomem *)(offset + __fix_to_virt(idx0));
 	return prev_map[slot];
 }
 
-- 
1.6.6

