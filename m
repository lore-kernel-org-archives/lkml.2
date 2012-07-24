Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932065Ab2GXBO3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2012 21:14:29 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:46972 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755238Ab2GXBKJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2012 21:10:09 -0400
From: Cyril Chemparathy <cyril@ti.com>
To: <linux-arm-kernel@lists.infradead.org>
CC: <linux-kernel@vger.kernel.org>, <nico@linaro.org>, <will.deacon@arm.com>,
        <catalin.marinas@arm.com>, Cyril Chemparathy <cyril@ti.com>,
        Vitaly Andrianov <vitalya@ti.com>
Subject: [RFC 11/23] ARM: mm: cleanup checks for membank overlap with vmalloc area
Date: Mon, 23 Jul 2012 21:09:13 -0400
Message-ID: <1343092165-9470-12-git-send-email-cyril@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1343092165-9470-1-git-send-email-cyril@ti.com>
References: <1343092165-9470-1-git-send-email-cyril@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Keystone platforms, physical memory is entirely outside the 32-bit
addressible range.  Therefore, the (bank->start > ULONG_MAX) check below marks
the entire system memory as highmem, and this causes unpleasentness all over.

This patch eliminates the extra bank start check (against ULONG_MAX) by
checking bank->start against the physical address corresponding to vmalloc_min
instead.

In the process, this patch also cleans up parts of the highmem sanity check
code by removing what has now become a redundant check for banks that entirely
overlap with the vmalloc range.

Signed-off-by: Cyril Chemparathy <cyril@ti.com>
Signed-off-by: Vitaly Andrianov <vitalya@ti.com>
---
 arch/arm/mm/mmu.c |   19 +------------------
 1 file changed, 1 insertion(+), 18 deletions(-)

diff --git a/arch/arm/mm/mmu.c b/arch/arm/mm/mmu.c
index adaf8c3..4840efa 100644
--- a/arch/arm/mm/mmu.c
+++ b/arch/arm/mm/mmu.c
@@ -907,15 +907,12 @@ void __init sanity_check_meminfo(void)
 		struct membank *bank = &meminfo.bank[j];
 		*bank = meminfo.bank[i];
 
-		if (bank->start > ULONG_MAX)
-			highmem = 1;
-
-#ifdef CONFIG_HIGHMEM
 		if (bank->start >= vmalloc_limit)
 			highmem = 1;
 
 		bank->highmem = highmem;
 
+#ifdef CONFIG_HIGHMEM
 		/*
 		 * Split those memory banks which are partially overlapping
 		 * the vmalloc area greatly simplifying things later.
@@ -938,8 +935,6 @@ void __init sanity_check_meminfo(void)
 			bank->size = vmalloc_limit - bank->start;
 		}
 #else
-		bank->highmem = highmem;
-
 		/*
 		 * Highmem banks not allowed with !CONFIG_HIGHMEM.
 		 */
@@ -952,18 +947,6 @@ void __init sanity_check_meminfo(void)
 		}
 
 		/*
-		 * Check whether this memory bank would entirely overlap
-		 * the vmalloc area.
-		 */
-		if (bank->start >= vmalloc_limit) {
-			printk(KERN_NOTICE "Ignoring RAM at %.8llx-%.8llx "
-			       "(vmalloc region overlap).\n",
-			       (unsigned long long)bank->start,
-			       (unsigned long long)bank->start + bank->size - 1);
-			continue;
-		}
-
-		/*
 		 * Check whether this memory bank would partially overlap
 		 * the vmalloc area.
 		 */
-- 
1.7.9.5

