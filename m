Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755224Ab2IKRjz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2012 13:39:55 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:45955 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754762Ab2IKRjw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2012 13:39:52 -0400
From: Cyril Chemparathy <cyril@ti.com>
To: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
CC: <arnd@arndb.de>, <catalin.marinas@arm.com>, <grant.likely@secretlab.ca>,
        <nico@linaro.org>, <linux@arm.linux.org.uk>, <will.deacon@arm.com>,
        Cyril Chemparathy <cyril@ti.com>, Vitaly Andrianov <vitalya@ti.com>
Subject: [PATCH v3 16/17] ARM: mm: cleanup checks for membank overlap with vmalloc area
Date: Tue, 11 Sep 2012 13:39:14 -0400
Message-ID: <1347385155-11643-17-git-send-email-cyril@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1347385155-11643-1-git-send-email-cyril@ti.com>
References: <1347385155-11643-1-git-send-email-cyril@ti.com>
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
Acked-by: Nicolas Pitre <nico@linaro.org>
---
 arch/arm/mm/mmu.c |   19 +------------------
 1 file changed, 1 insertion(+), 18 deletions(-)

diff --git a/arch/arm/mm/mmu.c b/arch/arm/mm/mmu.c
index ac4e7ae..6c35483 100644
--- a/arch/arm/mm/mmu.c
+++ b/arch/arm/mm/mmu.c
@@ -919,15 +919,12 @@ void __init sanity_check_meminfo(void)
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
@@ -950,8 +947,6 @@ void __init sanity_check_meminfo(void)
 			bank->size = vmalloc_limit - bank->start;
 		}
 #else
-		bank->highmem = highmem;
-
 		/*
 		 * Highmem banks not allowed with !CONFIG_HIGHMEM.
 		 */
@@ -964,18 +959,6 @@ void __init sanity_check_meminfo(void)
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

