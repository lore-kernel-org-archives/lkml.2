Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932286Ab1LENja (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 08:39:30 -0500
Received: from ch1ehsobe003.messaging.microsoft.com ([216.32.181.183]:10557
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932350Ab1LENfJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 08:35:09 -0500
X-SpamScore: 0
X-BigFish: VPS0(zzzz1202hzz8275bhz2dh668h839h)
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-FB-SS: 13,
X-WSS-ID: 0LVQGEC-02-AUK-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: <iommu@lists.linux-foundation.org>
CC: <linux-kernel@vger.kernel.org>, Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 08/22] iommu/amd: Implement notifier for PPR faults
Date: Mon, 5 Dec 2011 14:34:23 +0100
Message-ID: <1323092077-25501-9-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1323092077-25501-1-git-send-email-joerg.roedel@amd.com>
References: <1323092077-25501-1-git-send-email-joerg.roedel@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a notifer at which a module can attach to get informed
about incoming PPR faults.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 drivers/iommu/amd_iommu.c       |   90 ++++++++++++++++++++++++++++++++++++++-
 drivers/iommu/amd_iommu_proto.h |    3 +
 drivers/iommu/amd_iommu_types.h |   34 ++++++++++++++-
 3 files changed, 125 insertions(+), 2 deletions(-)

diff --git a/drivers/iommu/amd_iommu.c b/drivers/iommu/amd_iommu.c
index bde2776..81a709a 100644
--- a/drivers/iommu/amd_iommu.c
+++ b/drivers/iommu/amd_iommu.c
@@ -17,6 +17,7 @@
  * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307 USA
  */
 
+#include <linux/ratelimit.h>
 #include <linux/pci.h>
 #include <linux/pci-ats.h>
 #include <linux/bitmap.h>
@@ -28,6 +29,8 @@
 #include <linux/iommu.h>
 #include <linux/delay.h>
 #include <linux/amd-iommu.h>
+#include <linux/notifier.h>
+#include <linux/export.h>
 #include <asm/msidef.h>
 #include <asm/proto.h>
 #include <asm/iommu.h>
@@ -59,6 +62,8 @@ static struct protection_domain *pt_domain;
 
 static struct iommu_ops amd_iommu_ops;
 
+static ATOMIC_NOTIFIER_HEAD(ppr_notifier);
+
 /*
  * general struct to manage commands send to an IOMMU
  */
@@ -488,12 +493,82 @@ static void iommu_poll_events(struct amd_iommu *iommu)
 	spin_unlock_irqrestore(&iommu->lock, flags);
 }
 
+static void iommu_handle_ppr_entry(struct amd_iommu *iommu, u32 head)
+{
+	struct amd_iommu_fault fault;
+	volatile u64 *raw;
+	int i;
+
+	raw = (u64 *)(iommu->ppr_log + head);
+
+	/*
+	 * Hardware bug: Interrupt may arrive before the entry is written to
+	 * memory. If this happens we need to wait for the entry to arrive.
+	 */
+	for (i = 0; i < LOOP_TIMEOUT; ++i) {
+		if (PPR_REQ_TYPE(raw[0]) != 0)
+			break;
+		udelay(1);
+	}
+
+	if (PPR_REQ_TYPE(raw[0]) != PPR_REQ_FAULT) {
+		pr_err_ratelimited("AMD-Vi: Unknown PPR request received\n");
+		return;
+	}
+
+	fault.address   = raw[1];
+	fault.pasid     = PPR_PASID(raw[0]);
+	fault.device_id = PPR_DEVID(raw[0]);
+	fault.tag       = PPR_TAG(raw[0]);
+	fault.flags     = PPR_FLAGS(raw[0]);
+
+	/*
+	 * To detect the hardware bug we need to clear the entry
+	 * to back to zero.
+	 */
+	raw[0] = raw[1] = 0;
+
+	atomic_notifier_call_chain(&ppr_notifier, 0, &fault);
+}
+
+static void iommu_poll_ppr_log(struct amd_iommu *iommu)
+{
+	unsigned long flags;
+	u32 head, tail;
+
+	if (iommu->ppr_log == NULL)
+		return;
+
+	spin_lock_irqsave(&iommu->lock, flags);
+
+	head = readl(iommu->mmio_base + MMIO_PPR_HEAD_OFFSET);
+	tail = readl(iommu->mmio_base + MMIO_PPR_TAIL_OFFSET);
+
+	while (head != tail) {
+
+		/* Handle PPR entry */
+		iommu_handle_ppr_entry(iommu, head);
+
+		/* Update and refresh ring-buffer state*/
+		head = (head + PPR_ENTRY_SIZE) % PPR_LOG_SIZE;
+		writel(head, iommu->mmio_base + MMIO_PPR_HEAD_OFFSET);
+		tail = readl(iommu->mmio_base + MMIO_PPR_TAIL_OFFSET);
+	}
+
+	/* enable ppr interrupts again */
+	writel(MMIO_STATUS_PPR_INT_MASK, iommu->mmio_base + MMIO_STATUS_OFFSET);
+
+	spin_unlock_irqrestore(&iommu->lock, flags);
+}
+
 irqreturn_t amd_iommu_int_thread(int irq, void *data)
 {
 	struct amd_iommu *iommu;
 
-	for_each_iommu(iommu)
+	for_each_iommu(iommu) {
 		iommu_poll_events(iommu);
+		iommu_poll_ppr_log(iommu);
+	}
 
 	return IRQ_HANDLED;
 }
@@ -2888,3 +2963,16 @@ int __init amd_iommu_init_passthrough(void)
 
 	return 0;
 }
+
+/* IOMMUv2 specific functions */
+int amd_iommu_register_ppr_notifier(struct notifier_block *nb)
+{
+	return atomic_notifier_chain_register(&ppr_notifier, nb);
+}
+EXPORT_SYMBOL(amd_iommu_register_ppr_notifier);
+
+int amd_iommu_unregister_ppr_notifier(struct notifier_block *nb)
+{
+	return atomic_notifier_chain_unregister(&ppr_notifier, nb);
+}
+EXPORT_SYMBOL(amd_iommu_unregister_ppr_notifier);
diff --git a/drivers/iommu/amd_iommu_proto.h b/drivers/iommu/amd_iommu_proto.h
index 3a46c30..cfe2dfc 100644
--- a/drivers/iommu/amd_iommu_proto.h
+++ b/drivers/iommu/amd_iommu_proto.h
@@ -32,7 +32,10 @@ extern void amd_iommu_uninit_devices(void);
 extern void amd_iommu_init_notifier(void);
 extern void amd_iommu_init_api(void);
 
+/* IOMMUv2 specific functions */
 extern bool amd_iommu_v2_supported(void);
+extern int amd_iommu_register_ppr_notifier(struct notifier_block *nb);
+extern int amd_iommu_unregister_ppr_notifier(struct notifier_block *nb);
 
 #ifndef CONFIG_AMD_IOMMU_STATS
 
diff --git a/drivers/iommu/amd_iommu_types.h b/drivers/iommu/amd_iommu_types.h
index 6897645..f626722 100644
--- a/drivers/iommu/amd_iommu_types.h
+++ b/drivers/iommu/amd_iommu_types.h
@@ -94,7 +94,8 @@
 #define FEATURE_PASID_MASK	(0x1fULL << FEATURE_PASID_SHIFT)
 
 /* MMIO status bits */
-#define MMIO_STATUS_COM_WAIT_INT_MASK	0x04
+#define MMIO_STATUS_COM_WAIT_INT_MASK	(1 << 2)
+#define MMIO_STATUS_PPR_INT_MASK	(1 << 6)
 
 /* event logging constants */
 #define EVENT_ENTRY_SIZE	0x10
@@ -180,6 +181,16 @@
 #define PPR_ENTRY_SIZE		16
 #define PPR_LOG_SIZE		(PPR_ENTRY_SIZE * PPR_LOG_ENTRIES)
 
+#define PPR_REQ_TYPE(x)		(((x) >> 60) & 0xfULL)
+#define PPR_FLAGS(x)		(((x) >> 48) & 0xfffULL)
+#define PPR_DEVID(x)		((x) & 0xffffULL)
+#define PPR_TAG(x)		(((x) >> 32) & 0x3ffULL)
+#define PPR_PASID1(x)		(((x) >> 16) & 0xffffULL)
+#define PPR_PASID2(x)		(((x) >> 42) & 0xfULL)
+#define PPR_PASID(x)		((PPR_PASID2(x) << 16) | PPR_PASID1(x))
+
+#define PPR_REQ_FAULT		0x01
+
 #define PAGE_MODE_NONE    0x00
 #define PAGE_MODE_1_LEVEL 0x01
 #define PAGE_MODE_2_LEVEL 0x02
@@ -301,6 +312,27 @@ extern bool amd_iommu_iotlb_sup;
 #define APERTURE_RANGE_INDEX(a)	((a) >> APERTURE_RANGE_SHIFT)
 #define APERTURE_PAGE_INDEX(a)	(((a) >> 21) & 0x3fULL)
 
+
+/*
+ * This struct is used to pass information about
+ * incoming PPR faults around.
+ */
+struct amd_iommu_fault {
+	u64 address;    /* IO virtual address of the fault*/
+	u32 pasid;      /* Address space identifier */
+	u16 device_id;  /* Originating PCI device id */
+	u16 tag;        /* PPR tag */
+	u16 flags;      /* Fault flags */
+
+};
+
+#define PPR_FAULT_EXEC	(1 << 1)
+#define PPR_FAULT_READ  (1 << 2)
+#define PPR_FAULT_WRITE (1 << 5)
+#define PPR_FAULT_USER  (1 << 6)
+#define PPR_FAULT_RSVD  (1 << 7)
+#define PPR_FAULT_GN    (1 << 8)
+
 /*
  * This structure contains generic data for  IOMMU protection domains
  * independent of their use.
-- 
1.7.5.4


