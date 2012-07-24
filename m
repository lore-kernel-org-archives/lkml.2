Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755327Ab2GXBPz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2012 21:15:55 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:37339 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755416Ab2GXBJu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2012 21:09:50 -0400
From: Cyril Chemparathy <cyril@ti.com>
To: <linux-arm-kernel@lists.infradead.org>
CC: <linux-kernel@vger.kernel.org>, <nico@linaro.org>, <will.deacon@arm.com>,
        <catalin.marinas@arm.com>, Vitaly Andrianov <vitalya@ti.com>,
        Cyril Chemparathy <cyril@ti.com>
Subject: [RFC 06/23] ARM: LPAE: use phys_addr_t for initrd location and size
Date: Mon, 23 Jul 2012 21:09:08 -0400
Message-ID: <1343092165-9470-7-git-send-email-cyril@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1343092165-9470-1-git-send-email-cyril@ti.com>
References: <1343092165-9470-1-git-send-email-cyril@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Vitaly Andrianov <vitalya@ti.com>

This patch fixes the initrd setup code to use phys_addr_t instead of assuming
32-bit addressing.  Without this we cannot boot on systems where initrd is
located above the 4G physical address limit.

Signed-off-by: Vitaly Andrianov <vitalya@ti.com>
Signed-off-by: Cyril Chemparathy <cyril@ti.com>
---
 arch/arm/mm/init.c |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/arch/arm/mm/init.c b/arch/arm/mm/init.c
index 8252c31..51f3e92 100644
--- a/arch/arm/mm/init.c
+++ b/arch/arm/mm/init.c
@@ -36,12 +36,12 @@
 
 #include "mm.h"
 
-static unsigned long phys_initrd_start __initdata = 0;
-static unsigned long phys_initrd_size __initdata = 0;
+static phys_addr_t phys_initrd_start __initdata = 0;
+static phys_addr_t phys_initrd_size __initdata = 0;
 
 static int __init early_initrd(char *p)
 {
-	unsigned long start, size;
+	phys_addr_t start, size;
 	char *endp;
 
 	start = memparse(p, &endp);
@@ -347,14 +347,14 @@ void __init arm_memblock_init(struct meminfo *mi, struct machine_desc *mdesc)
 #ifdef CONFIG_BLK_DEV_INITRD
 	if (phys_initrd_size &&
 	    !memblock_is_region_memory(phys_initrd_start, phys_initrd_size)) {
-		pr_err("INITRD: 0x%08lx+0x%08lx is not a memory region - disabling initrd\n",
-		       phys_initrd_start, phys_initrd_size);
+		pr_err("INITRD: 0x%08llx+0x%08llx is not a memory region - disabling initrd\n",
+		       (u64)phys_initrd_start, (u64)phys_initrd_size);
 		phys_initrd_start = phys_initrd_size = 0;
 	}
 	if (phys_initrd_size &&
 	    memblock_is_region_reserved(phys_initrd_start, phys_initrd_size)) {
-		pr_err("INITRD: 0x%08lx+0x%08lx overlaps in-use memory region - disabling initrd\n",
-		       phys_initrd_start, phys_initrd_size);
+		pr_err("INITRD: 0x%08llx+0x%08llx overlaps in-use memory region - disabling initrd\n",
+		       (u64)phys_initrd_start, (u64)phys_initrd_size);
 		phys_initrd_start = phys_initrd_size = 0;
 	}
 	if (phys_initrd_size) {
-- 
1.7.9.5

