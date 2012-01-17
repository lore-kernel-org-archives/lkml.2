Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754469Ab2AQNWp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jan 2012 08:22:45 -0500
Received: from vms173001pub.verizon.net ([206.46.173.1]:43513 "EHLO
	vms173001pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754439Ab2AQNWn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jan 2012 08:22:43 -0500
From: Len Brown <lenb@kernel.org>
To: linux-acpi@vger.kernel.org, linux-pm@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org
Cc: Huang Ying <ying.huang@intel.com>, Len Brown <len.brown@intel.com>
Subject: [PATCH 25/50] ACPI, Add 64bit read/write support to atomicio on i386
Date: Tue, 17 Jan 2012 07:21:17 -0500
Message-id: <04c25997c97e57d95d1f5a7a6e5fff2411dbd48b.1326802230.git.len.brown@intel.com>
X-Mailer: git-send-email 1.7.9.rc1
In-reply-to: <1326802902-21583-1-git-send-email-lenb@kernel.org>
References: <1326802902-21583-1-git-send-email-lenb@kernel.org>
In-reply-to: <553575f1ae048aa44682b46b3c51929a0b3ad337.1326802228.git.len.brown@intel.com>
References: <553575f1ae048aa44682b46b3c51929a0b3ad337.1326802228.git.len.brown@intel.com>
Reply-to: Len Brown <lenb@kernel.org>
Organization: Intel Open Source Technology Center
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Huang Ying <ying.huang@intel.com>

There is no 64bit read/write support in ACPI atomicio because
readq/writeq is used to implement 64bit read/write, but readq/writeq
is not available on i386.  This patch implement 64bit read/write
support in atomicio via two readl/writel.

Signed-off-by: Huang Ying <ying.huang@intel.com>
Signed-off-by: Len Brown <len.brown@intel.com>
---
 drivers/acpi/atomicio.c |   36 ++++++++++++++++++++++++++++++------
 1 files changed, 30 insertions(+), 6 deletions(-)

diff --git a/drivers/acpi/atomicio.c b/drivers/acpi/atomicio.c
index cfc0cc1..1016f18 100644
--- a/drivers/acpi/atomicio.c
+++ b/drivers/acpi/atomicio.c
@@ -260,6 +260,21 @@ int acpi_post_unmap_gar(struct acpi_generic_address *reg)
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
@@ -280,11 +295,9 @@ static int acpi_atomic_read_mem(u64 paddr, u64 *val, u32 width)
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
@@ -293,6 +306,19 @@ static int acpi_atomic_read_mem(u64 paddr, u64 *val, u32 width)
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
@@ -309,11 +335,9 @@ static int acpi_atomic_write_mem(u64 paddr, u64 val, u32 width)
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
-- 
1.7.9.rc1

