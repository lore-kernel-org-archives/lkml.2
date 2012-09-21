Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756702Ab2IUP50 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2012 11:57:26 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:54110 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756295Ab2IUP5F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2012 11:57:05 -0400
From: Cyril Chemparathy <cyril@ti.com>
To: <linux@arm.linux.org.uk>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <arnd@arndb.de>, <catalin.marinas@arm.com>, <davidb@codeaurora.org>,
        <frank.rowand@am.sony.com>, <hsweeten@visionengravers.com>,
        <linus.walleij@linaro.org>, <marc.zyngier@arm.com>, <nico@linaro.org>,
        <paul.gortmaker@windriver.com>, <plagnioj@jcrosoft.com>,
        <rabin@rab.in>, <rmallon@gmail.com>, <rob.herring@calxeda.com>,
        <sboyd@codeaurora.org>, <sjg@chromium.org>, <tglx@linutronix.de>,
        <tj@kernel.org>, <vincent.guittot@linaro.org>, <vitalya@ti.com>,
        <will.deacon@arm.com>, <grant.likely@secretlab.ca>,
        Cyril Chemparathy <cyril@ti.com>
Subject: [PATCH v3 RESEND 09/17] ARM: LPAE: use phys_addr_t for initrd location and size
Date: Fri, 21 Sep 2012 11:56:07 -0400
Message-ID: <1348242975-19184-10-git-send-email-cyril@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1348242975-19184-1-git-send-email-cyril@ti.com>
References: <1348242975-19184-1-git-send-email-cyril@ti.com>
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
Acked-by: Nicolas Pitre <nico@linaro.org>
---
 arch/arm/mm/init.c |   13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/arch/arm/mm/init.c b/arch/arm/mm/init.c
index 19ba70b..bae9d05 100644
--- a/arch/arm/mm/init.c
+++ b/arch/arm/mm/init.c
@@ -36,12 +36,13 @@
 
 #include "mm.h"
 
-static unsigned long phys_initrd_start __initdata = 0;
+static phys_addr_t phys_initrd_start __initdata = 0;
 static unsigned long phys_initrd_size __initdata = 0;
 
 static int __init early_initrd(char *p)
 {
-	unsigned long start, size;
+	phys_addr_t start;
+	unsigned long size;
 	char *endp;
 
 	start = memparse(p, &endp);
@@ -347,14 +348,14 @@ void __init arm_memblock_init(struct meminfo *mi, struct machine_desc *mdesc)
 #ifdef CONFIG_BLK_DEV_INITRD
 	if (phys_initrd_size &&
 	    !memblock_is_region_memory(phys_initrd_start, phys_initrd_size)) {
-		pr_err("INITRD: 0x%08lx+0x%08lx is not a memory region - disabling initrd\n",
-		       phys_initrd_start, phys_initrd_size);
+		pr_err("INITRD: 0x%08llx+0x%08lx is not a memory region - disabling initrd\n",
+		       (u64)phys_initrd_start, phys_initrd_size);
 		phys_initrd_start = phys_initrd_size = 0;
 	}
 	if (phys_initrd_size &&
 	    memblock_is_region_reserved(phys_initrd_start, phys_initrd_size)) {
-		pr_err("INITRD: 0x%08lx+0x%08lx overlaps in-use memory region - disabling initrd\n",
-		       phys_initrd_start, phys_initrd_size);
+		pr_err("INITRD: 0x%08llx+0x%08lx overlaps in-use memory region - disabling initrd\n",
+		       (u64)phys_initrd_start, phys_initrd_size);
 		phys_initrd_start = phys_initrd_size = 0;
 	}
 	if (phys_initrd_size) {
-- 
1.7.9.5

