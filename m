Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759856Ab0HEH0F (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 03:26:05 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:51573 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759671Ab0HEH0D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 03:26:03 -0400
Date: Thu, 5 Aug 2010 09:25:55 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Joerg Roedel <joerg.roedel@amd.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: [GIT PULL] core/iommu updates for v2.6.36
Message-ID: <20100805072555.GA5297@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest core-iommu-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git core-iommu-for-linus

 Thanks,

	Ingo

------------------>
Joerg Roedel (1):
      x86/amd-iommu: Export cache-coherency capability

Kulikov Vasiliy (1):
      x86/amd-iommu: Use for_each_pci_dev()

Tom Lyon (1):
      iommu-api: Extension to check for interrupt remapping


 arch/x86/kernel/amd_iommu.c |    8 ++++++--
 drivers/pci/intel-iommu.c   |    2 ++
 include/linux/iommu.h       |    1 +
 3 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/amd_iommu.c b/arch/x86/kernel/amd_iommu.c
index 0d20286..fa044e1 100644
--- a/arch/x86/kernel/amd_iommu.c
+++ b/arch/x86/kernel/amd_iommu.c
@@ -2572,6 +2572,11 @@ static phys_addr_t amd_iommu_iova_to_phys(struct iommu_domain *dom,
 static int amd_iommu_domain_has_cap(struct iommu_domain *domain,
 				    unsigned long cap)
 {
+	switch (cap) {
+	case IOMMU_CAP_CACHE_COHERENCY:
+		return 1;
+	}
+
 	return 0;
 }
 
@@ -2609,8 +2614,7 @@ int __init amd_iommu_init_passthrough(void)
 
 	pt_domain->mode |= PAGE_MODE_NONE;
 
-	while ((dev = pci_get_device(PCI_ANY_ID, PCI_ANY_ID, dev)) != NULL) {
-
+	for_each_pci_dev(dev) {
 		if (!check_device(&dev->dev))
 			continue;
 
diff --git a/drivers/pci/intel-iommu.c b/drivers/pci/intel-iommu.c
index c9171be..6a5af18 100644
--- a/drivers/pci/intel-iommu.c
+++ b/drivers/pci/intel-iommu.c
@@ -3698,6 +3698,8 @@ static int intel_iommu_domain_has_cap(struct iommu_domain *domain,
 
 	if (cap == IOMMU_CAP_CACHE_COHERENCY)
 		return dmar_domain->iommu_snooping;
+	if (cap == IOMMU_CAP_INTR_REMAP)
+		return intr_remapping_enabled;
 
 	return 0;
 }
diff --git a/include/linux/iommu.h b/include/linux/iommu.h
index be22ad8..0a2ba40 100644
--- a/include/linux/iommu.h
+++ b/include/linux/iommu.h
@@ -30,6 +30,7 @@ struct iommu_domain {
 };
 
 #define IOMMU_CAP_CACHE_COHERENCY	0x1
+#define IOMMU_CAP_INTR_REMAP		0x2	/* isolates device intrs */
 
 struct iommu_ops {
 	int (*domain_init)(struct iommu_domain *domain);
