Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755578Ab0DFP5U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Apr 2010 11:57:20 -0400
Received: from mail.windriver.com ([147.11.1.11]:36390 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752218Ab0DFP5O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Apr 2010 11:57:14 -0400
From: Liang Li <liang.li@windriver.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, akpm@linux-foundation.org, wangchen@cn.fujitsu.com
Subject: [RFC PATCH] x86: let 'reservetop' functioning right
Date: Tue,  6 Apr 2010 23:55:25 +0800
Message-Id: <1270569325-8161-1-git-send-email-liang.li@windriver.com>
X-Mailer: git-send-email 1.6.6
X-OriginalArrivalTime: 06 Apr 2010 15:56:21.0101 (UTC) FILETIME=[B37969D0:01CAD5A1]
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

Signed-off-by: Liang Li <liang.li@windriver.com>
---
Hi,

I am not sure if kernel command line option 'reservetop' will block boot
is the normal situation or not. Could someone tell me if we should fix
it or just leave it as is or someone is doing something to replace
'reservetop' with some other stuff?

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

