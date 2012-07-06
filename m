Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933010Ab2GFVQp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2012 17:16:45 -0400
Received: from service87.mimecast.com ([91.220.42.44]:60855 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758301Ab2GFVGh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2012 17:06:37 -0400
From: Catalin Marinas <catalin.marinas@arm.com>
To: linux-kernel@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>, Grant Likely <grant.likely@secretlab.ca>
Subject: [PATCH 06/36] fdt: Add generic dt_memblock_reserve() function
Date: Fri,  6 Jul 2012 22:05:47 +0100
Message-Id: <1341608777-12982-7-git-send-email-catalin.marinas@arm.com>
X-Mailer: git-send-email 1.7.9.111.gf3fb0
In-Reply-To: <1341608777-12982-1-git-send-email-catalin.marinas@arm.com>
References: <1341608777-12982-1-git-send-email-catalin.marinas@arm.com>
X-OriginalArrivalTime: 06 Jul 2012 21:07:30.0906 (UTC) FILETIME=[5B1A13A0:01CD5BBB]
X-MC-Unique: 112070622063600501
Content-Type: text/plain; charset=WINDOWS-1252
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from quoted-printable to 8bit by nfs id q66LH3Fm005506

This function reserves initial_boot_params total size and reserve map.

Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Cc: Grant Likely <grant.likely@secretlab.ca>
---
 drivers/of/fdt.c       |   28 ++++++++++++++++++++++++++++
 include/linux/of_fdt.h |    1 +
 2 files changed, 29 insertions(+), 0 deletions(-)

diff --git a/drivers/of/fdt.c b/drivers/of/fdt.c
index 91a375f..7e9b5b0 100644
--- a/drivers/of/fdt.c
+++ b/drivers/of/fdt.c
@@ -17,6 +17,7 @@
 #include <linux/string.h>
 #include <linux/errno.h>
 #include <linux/slab.h>
+#include <linux/memblock.h>
 
 #include <asm/setup.h>  /* for COMMAND_LINE_SIZE */
 #ifdef CONFIG_PPC
@@ -436,6 +437,33 @@ int __initdata dt_root_size_cells;
 
 struct boot_param_header *initial_boot_params;
 
+void __init dt_memblock_reserve(void)
+{
+	u64 *reserve_map, base, size;
+
+	if (!initial_boot_params)
+		return;
+
+	/* Reserve the dtb region */
+	memblock_reserve(virt_to_phys(initial_boot_params),
+			 be32_to_cpu(initial_boot_params->totalsize));
+
+	/*
+	 * Process the reserve map.  This will probably overlap the initrd
+	 * and dtb locations which are already reserved, but overlapping
+	 * doesn't hurt anything
+	 */
+	reserve_map = ((void*)initial_boot_params) +
+			be32_to_cpu(initial_boot_params->off_mem_rsvmap);
+	while (1) {
+		base = be64_to_cpup(reserve_map++);
+		size = be64_to_cpup(reserve_map++);
+		if (!size)
+			break;
+		memblock_reserve(base, size);
+	}
+}
+
 #ifdef CONFIG_OF_EARLY_FLATTREE
 
 /**
diff --git a/include/linux/of_fdt.h b/include/linux/of_fdt.h
index ed136ad..bf4fe1e 100644
--- a/include/linux/of_fdt.h
+++ b/include/linux/of_fdt.h
@@ -117,6 +117,7 @@ extern int early_init_dt_scan_root(unsigned long node, const char *uname,
 /* Other Prototypes */
 extern void unflatten_device_tree(void);
 extern void early_init_devtree(void *);
+extern void dt_memblock_reserve(void);
 #else /* CONFIG_OF_FLATTREE */
 static inline void unflatten_device_tree(void) {}
 #endif /* CONFIG_OF_FLATTREE */

