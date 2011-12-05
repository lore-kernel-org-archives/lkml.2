Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932404Ab1LENj1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 08:39:27 -0500
Received: from va3ehsobe002.messaging.microsoft.com ([216.32.180.12]:53292
	"EHLO VA3EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932363Ab1LENfK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 08:35:10 -0500
X-SpamScore: 0
X-BigFish: VPS0(zzzz1202hzz8275bhz2dh668h839h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LVQGEE-01-IPN-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: <iommu@lists.linux-foundation.org>
CC: <linux-kernel@vger.kernel.org>, Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 11/22] iommu/amd: Implement IOMMUv2 TLB flushing routines
Date: Mon, 5 Dec 2011 14:34:26 +0100
Message-ID: <1323092077-25501-12-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1323092077-25501-1-git-send-email-joerg.roedel@amd.com>
References: <1323092077-25501-1-git-send-email-joerg.roedel@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The functions added with this patch allow to manage the
IOMMU and the device TLBs for all devices in an IOMMUv2
domain.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 drivers/iommu/amd_iommu.c       |  136 +++++++++++++++++++++++++++++++++++++++
 drivers/iommu/amd_iommu_proto.h |    3 +
 drivers/iommu/amd_iommu_types.h |    1 +
 3 files changed, 140 insertions(+), 0 deletions(-)

diff --git a/drivers/iommu/amd_iommu.c b/drivers/iommu/amd_iommu.c
index eaa1af2..bd18a04 100644
--- a/drivers/iommu/amd_iommu.c
+++ b/drivers/iommu/amd_iommu.c
@@ -698,6 +698,44 @@ static void build_inv_iotlb_pages(struct iommu_cmd *cmd, u16 devid, int qdep,
 		cmd->data[2] |= CMD_INV_IOMMU_PAGES_SIZE_MASK;
 }
 
+static void build_inv_iommu_pasid(struct iommu_cmd *cmd, u16 domid, int pasid,
+				  u64 address, bool size)
+{
+	memset(cmd, 0, sizeof(*cmd));
+
+	address &= ~(0xfffULL);
+
+	cmd->data[0]  = pasid & PASID_MASK;
+	cmd->data[1]  = domid;
+	cmd->data[2]  = lower_32_bits(address);
+	cmd->data[3]  = upper_32_bits(address);
+	cmd->data[2] |= CMD_INV_IOMMU_PAGES_PDE_MASK;
+	cmd->data[2] |= CMD_INV_IOMMU_PAGES_GN_MASK;
+	if (size)
+		cmd->data[2] |= CMD_INV_IOMMU_PAGES_SIZE_MASK;
+	CMD_SET_TYPE(cmd, CMD_INV_IOMMU_PAGES);
+}
+
+static void build_inv_iotlb_pasid(struct iommu_cmd *cmd, u16 devid, int pasid,
+				  int qdep, u64 address, bool size)
+{
+	memset(cmd, 0, sizeof(*cmd));
+
+	address &= ~(0xfffULL);
+
+	cmd->data[0]  = devid;
+	cmd->data[0] |= (pasid & 0xff) << 16;
+	cmd->data[0] |= (qdep  & 0xff) << 24;
+	cmd->data[1]  = devid;
+	cmd->data[1] |= ((pasid >> 8) & 0xfff) << 16;
+	cmd->data[2]  = lower_32_bits(address);
+	cmd->data[2] |= CMD_INV_IOMMU_PAGES_GN_MASK;
+	cmd->data[3]  = upper_32_bits(address);
+	if (size)
+		cmd->data[2] |= CMD_INV_IOMMU_PAGES_SIZE_MASK;
+	CMD_SET_TYPE(cmd, CMD_INV_IOTLB_PAGES);
+}
+
 static void build_inv_all(struct iommu_cmd *cmd)
 {
 	memset(cmd, 0, sizeof(*cmd));
@@ -3146,3 +3184,101 @@ out:
 	return ret;
 }
 EXPORT_SYMBOL(amd_iommu_domain_enable_v2);
+
+static int __flush_pasid(struct protection_domain *domain, int pasid,
+			 u64 address, bool size)
+{
+	struct iommu_dev_data *dev_data;
+	struct iommu_cmd cmd;
+	int i, ret;
+
+	if (!(domain->flags & PD_IOMMUV2_MASK))
+		return -EINVAL;
+
+	build_inv_iommu_pasid(&cmd, domain->id, pasid, address, size);
+
+	/*
+	 * IOMMU TLB needs to be flushed before Device TLB to
+	 * prevent device TLB refill from IOMMU TLB
+	 */
+	for (i = 0; i < amd_iommus_present; ++i) {
+		if (domain->dev_iommu[i] == 0)
+			continue;
+
+		ret = iommu_queue_command(amd_iommus[i], &cmd);
+		if (ret != 0)
+			goto out;
+	}
+
+	/* Wait until IOMMU TLB flushes are complete */
+	domain_flush_complete(domain);
+
+	/* Now flush device TLBs */
+	list_for_each_entry(dev_data, &domain->dev_list, list) {
+		struct amd_iommu *iommu;
+		int qdep;
+
+		BUG_ON(!dev_data->ats.enabled);
+
+		qdep  = dev_data->ats.qdep;
+		iommu = amd_iommu_rlookup_table[dev_data->devid];
+
+		build_inv_iotlb_pasid(&cmd, dev_data->devid, pasid,
+				      qdep, address, size);
+
+		ret = iommu_queue_command(iommu, &cmd);
+		if (ret != 0)
+			goto out;
+	}
+
+	/* Wait until all device TLBs are flushed */
+	domain_flush_complete(domain);
+
+	ret = 0;
+
+out:
+
+	return ret;
+}
+
+static int __amd_iommu_flush_page(struct protection_domain *domain, int pasid,
+				  u64 address)
+{
+	return __flush_pasid(domain, pasid, address, false);
+}
+
+int amd_iommu_flush_page(struct iommu_domain *dom, int pasid,
+			 u64 address)
+{
+	struct protection_domain *domain = dom->priv;
+	unsigned long flags;
+	int ret;
+
+	spin_lock_irqsave(&domain->lock, flags);
+	ret = __amd_iommu_flush_page(domain, pasid, address);
+	spin_unlock_irqrestore(&domain->lock, flags);
+
+	return ret;
+}
+EXPORT_SYMBOL(amd_iommu_flush_page);
+
+static int __amd_iommu_flush_tlb(struct protection_domain *domain, int pasid)
+{
+	return __flush_pasid(domain, pasid, CMD_INV_IOMMU_ALL_PAGES_ADDRESS,
+			     true);
+}
+
+int amd_iommu_flush_tlb(struct iommu_domain *dom, int pasid)
+{
+	struct protection_domain *domain = dom->priv;
+	unsigned long flags;
+	int ret;
+
+	spin_lock_irqsave(&domain->lock, flags);
+	ret = __amd_iommu_flush_tlb(domain, pasid);
+	spin_unlock_irqrestore(&domain->lock, flags);
+
+	return ret;
+}
+EXPORT_SYMBOL(amd_iommu_flush_tlb);
+
diff --git a/drivers/iommu/amd_iommu_proto.h b/drivers/iommu/amd_iommu_proto.h
index d207b1d..a92dc61 100644
--- a/drivers/iommu/amd_iommu_proto.h
+++ b/drivers/iommu/amd_iommu_proto.h
@@ -40,6 +40,9 @@ extern int amd_iommu_register_ppr_notifier(struct notifier_block *nb);
 extern int amd_iommu_unregister_ppr_notifier(struct notifier_block *nb);
 extern void amd_iommu_domain_direct_map(struct iommu_domain *dom);
 extern int amd_iommu_domain_enable_v2(struct iommu_domain *dom, int pasids);
+extern int amd_iommu_flush_page(struct iommu_domain *dom, int pasid,
+				u64 address);
+extern int amd_iommu_flush_tlb(struct iommu_domain *dom, int pasid);
 
 #ifndef CONFIG_AMD_IOMMU_STATS
 
diff --git a/drivers/iommu/amd_iommu_types.h b/drivers/iommu/amd_iommu_types.h
index 905eca5..64a7642 100644
--- a/drivers/iommu/amd_iommu_types.h
+++ b/drivers/iommu/amd_iommu_types.h
@@ -148,6 +148,7 @@
 #define CMD_COMPL_WAIT_INT_MASK		0x02
 #define CMD_INV_IOMMU_PAGES_SIZE_MASK	0x01
 #define CMD_INV_IOMMU_PAGES_PDE_MASK	0x02
+#define CMD_INV_IOMMU_PAGES_GN_MASK	0x04
 
 #define CMD_INV_IOMMU_ALL_PAGES_ADDRESS	0x7fffffffffffffffULL
 
-- 
1.7.5.4


