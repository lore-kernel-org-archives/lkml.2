Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753467Ab1ARU3R (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jan 2011 15:29:17 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:37742 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753432Ab1ARU3K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jan 2011 15:29:10 -0500
Subject: [PATCH 2/8] arm/dt: allow bootmem reservation for device tree blob
	and initrd
To: linux-arm-kernel@lists.infradead.org
From: Grant Likely <grant.likely@secretlab.ca>
Cc: Nicolas Pitre <nicolas.pitre@linaro.org>,
        Russell King <linux@arm.linux.org.uk>,
        Catalin Marinas <catalin.marinas@arm.com>,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        Olof Johansson <olof@lixom.net>,
        Jeremy Kerr <jeremy.kerr@canonical.com>,
        John Linn <John.Linn@xilinx.com>,
        Lennert Buijtenhek <buytenh@wantstofly.org>
Date: Tue, 18 Jan 2011 13:29:07 -0700
Message-ID: <20110118202907.13011.35108.stgit@localhost6.localdomain6>
In-Reply-To: <20110118195933.13011.56098.stgit@localhost6.localdomain6>
References: <20110118195933.13011.56098.stgit@localhost6.localdomain6>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds a function, arm_reserve_devtree(), to allow the device
tree code to reserve the memory used by the FDT blob.  It also adds
early_init_dt_setup_initrd() which is the hook used by the flat device
tree code to register the region of memory occupied by an initrd.

[based on original patch written by Jeremy Kerr <jeremy.kerr@canonical.com>]
Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
---
 arch/arm/include/asm/setup.h |    2 ++
 arch/arm/mm/init.c           |   23 +++++++++++++++++++++++
 2 files changed, 25 insertions(+), 0 deletions(-)

diff --git a/arch/arm/include/asm/setup.h b/arch/arm/include/asm/setup.h
index f1e5a9b..0f3e0ac 100644
--- a/arch/arm/include/asm/setup.h
+++ b/arch/arm/include/asm/setup.h
@@ -221,6 +221,8 @@ extern struct meminfo meminfo;
 #define bank_phys_end(bank)	((bank)->start + (bank)->size)
 #define bank_phys_size(bank)	(bank)->size
 
+extern void arm_reserve_devtree(unsigned long start, unsigned long size);
+
 #endif  /*  __KERNEL__  */
 
 #endif
diff --git a/arch/arm/mm/init.c b/arch/arm/mm/init.c
index 5164069..28ccb21 100644
--- a/arch/arm/mm/init.c
+++ b/arch/arm/mm/init.c
@@ -71,6 +71,25 @@ static int __init parse_tag_initrd2(const struct tag *tag)
 
 __tagtable(ATAG_INITRD2, parse_tag_initrd2);
 
+#ifdef CONFIG_OF_FLATTREE
+#include <linux/of_fdt.h>
+
+static unsigned long phys_devtree_start __initdata = 0;
+static unsigned long phys_devtree_size __initdata = 0;
+
+void __init early_init_dt_setup_initrd_arch(unsigned long start, unsigned long end)
+{
+	phys_initrd_start = start;
+	phys_initrd_size = end - start + 1;
+}
+
+void __init arm_reserve_devtree(unsigned long start, unsigned long size)
+{
+	phys_devtree_start = start;
+	phys_devtree_size = size;
+}
+#endif /* CONFIG_OF_FLATTREE */
+
 /*
  * This keeps memory configuration data used by a couple memory
  * initialization functions, as well as show_mem() for the skipping
@@ -305,6 +324,10 @@ void __init arm_memblock_init(struct meminfo *mi, struct machine_desc *mdesc)
 		initrd_end = initrd_start + phys_initrd_size;
 	}
 #endif
+#ifdef CONFIG_OF_FLATTREE
+	if (phys_devtree_size)
+		memblock_reserve(phys_devtree_start, phys_devtree_size);
+#endif
 
 	arm_mm_memblock_reserve();
 

