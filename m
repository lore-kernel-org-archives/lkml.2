Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758072Ab1LHD2g (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Dec 2011 22:28:36 -0500
Received: from mga03.intel.com ([143.182.124.21]:14032 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757092Ab1LHDZz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Dec 2011 22:25:55 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="45071341"
From: Huang Ying <ying.huang@intel.com>
To: Len Brown <lenb@kernel.org>
Cc: linux-kernel@vger.kernel.org, Tony Luck <tony.luck@intel.com>,
        ying.huang@intel.com, linux-acpi@vger.kernel.org
Subject: [PATCH 01/11] ACPI, Add 64bit read/write support to atomicio on i386
Date: Thu,  8 Dec 2011 11:25:40 +0800
Message-Id: <1323314750-8185-2-git-send-email-ying.huang@intel.com>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1323314750-8185-1-git-send-email-ying.huang@intel.com>
References: <1323314750-8185-1-git-send-email-ying.huang@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is no 64bit read/write support in ACPI atomicio because
readq/writeq is used to implement 64bit read/write, but readq/writeq
is not available on i386.  This patch implement 64bit read/write
support in atomicio via two readl/writel.

Signed-off-by: Huang Ying <ying.huang@intel.com>
---
 drivers/acpi/atomicio.c |   36 ++++++++++++++++++++++++++++++------
 1 file changed, 30 insertions(+), 6 deletions(-)

--- a/drivers/acpi/atomicio.c
+++ b/drivers/acpi/atomicio.c
@@ -260,6 +260,21 @@ int acpi_post_unmap_gar(struct acpi_gene
 }
 EXPORT_SYMBOL_GPL(acpi_post_unmap_gar);
 
+#ifdef readq
+static inline u64 read64(const volatile void __iomem *addr)
+{
+	return readq(addr);
+}
+#else
+static inline u64 read64(const volatile void __iomem *addr)
+{
+	u64 l, h;
+	l = readl(addr);
+	h = readl(addr+4);
+	return l | (h << 32);
+}
+#endif
+
 /*
  * Can be used in atomic (including NMI) or process context. RCU read
  * lock can only be released after the IO memory area accessing.
@@ -280,11 +295,9 @@ static int acpi_atomic_read_mem(u64 padd
 	case 32:
 		*val = readl(addr);
 		break;
-#ifdef readq
 	case 64:
-		*val = readq(addr);
+		*val = read64(addr);
 		break;
-#endif
 	default:
 		return -EINVAL;
 	}
@@ -293,6 +306,19 @@ static int acpi_atomic_read_mem(u64 padd
 	return 0;
 }
 
+#ifdef writeq
+static inline void write64(u64 val, volatile void __iomem *addr)
+{
+	writeq(val, addr);
+}
+#else
+static inline void write64(u64 val, volatile void __iomem *addr)
+{
+	writel(val, addr);
+	writel(val>>32, addr+4);
+}
+#endif
+
 static int acpi_atomic_write_mem(u64 paddr, u64 val, u32 width)
 {
 	void __iomem *addr;
@@ -309,11 +335,9 @@ static int acpi_atomic_write_mem(u64 pad
 	case 32:
 		writel(val, addr);
 		break;
-#ifdef writeq
 	case 64:
-		writeq(val, addr);
+		write64(val, addr);
 		break;
-#endif
 	default:
 		return -EINVAL;
 	}
