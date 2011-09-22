Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752226Ab1IVQPg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Sep 2011 12:15:36 -0400
Received: from ch1ehsobe006.messaging.microsoft.com ([216.32.181.186]:39659
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751643Ab1IVQP2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Sep 2011 12:15:28 -0400
X-SpamScore: 1
X-BigFish: VPS1(zzzz1202hzz8275bhz32i668h839h)
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-FB-SS: 0,
X-WSS-ID: 0LRXMHH-02-J7U-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: <iommu@lists.linux-foundation.org>
CC: Greg Kroah-Hartman <gregkh@suse.de>,
        Alex Williamson <alex.williamson@redhat.com>,
        Ohad Ben-Cohen <ohad@wizery.com>,
        David Woodhouse <dwmw2@infradead.org>,
        David Brown <davidb@codeaurora.org>, <joro@8bytes.org>,
        <linux-kernel@vger.kernel.org>, Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 04/10] iommu/core: Convert iommu_found to iommu_present
Date: Thu, 22 Sep 2011 18:14:56 +0200
Message-ID: <1316708102-16250-5-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1316708102-16250-1-git-send-email-joerg.roedel@amd.com>
References: <1316708102-16250-1-git-send-email-joerg.roedel@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With per-bus iommu_ops the iommu_found function needs to
work on a bus_type too. This patch adds a bus_type parameter
to that function and converts all call-places.
The function is also renamed to iommu_present because the
function now checks if an iommu is present for a given bus
and does not check for a global iommu anymore.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/ia64/kvm/kvm-ia64.c |    3 ++-
 arch/x86/kvm/x86.c       |    3 ++-
 drivers/iommu/iommu.c    |    9 ++++++---
 include/linux/iommu.h    |    4 ++--
 virt/kvm/iommu.c         |    2 +-
 5 files changed, 13 insertions(+), 8 deletions(-)

diff --git a/arch/ia64/kvm/kvm-ia64.c b/arch/ia64/kvm/kvm-ia64.c
index 8213efe..43f4c92 100644
--- a/arch/ia64/kvm/kvm-ia64.c
+++ b/arch/ia64/kvm/kvm-ia64.c
@@ -33,6 +33,7 @@
 #include <linux/uaccess.h>
 #include <linux/iommu.h>
 #include <linux/intel-iommu.h>
+#include <linux/pci.h>
 
 #include <asm/pgtable.h>
 #include <asm/gcc_intrin.h>
@@ -204,7 +205,7 @@ int kvm_dev_ioctl_check_extension(long ext)
 		r = KVM_COALESCED_MMIO_PAGE_OFFSET;
 		break;
 	case KVM_CAP_IOMMU:
-		r = iommu_found();
+		r = iommu_present(&pci_bus_type);
 		break;
 	default:
 		r = 0;
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 84a28ea..73c6a42 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -44,6 +44,7 @@
 #include <linux/perf_event.h>
 #include <linux/uaccess.h>
 #include <linux/hash.h>
+#include <linux/pci.h>
 #include <trace/events/kvm.h>
 
 #define CREATE_TRACE_POINTS
@@ -2095,7 +2096,7 @@ int kvm_dev_ioctl_check_extension(long ext)
 		r = 0;
 		break;
 	case KVM_CAP_IOMMU:
-		r = iommu_found();
+		r = iommu_present(&pci_bus_type);
 		break;
 	case KVM_CAP_MCE:
 		r = KVM_MAX_MCE_BANKS;
diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
index adaee9b..2270127 100644
--- a/drivers/iommu/iommu.c
+++ b/drivers/iommu/iommu.c
@@ -39,11 +39,14 @@ void iommu_bus_init(struct bus_type *bus, struct iommu_ops *ops)
 {
 }
 
-bool iommu_found(void)
+bool iommu_present(struct bus_type *bus)
 {
-	return iommu_ops != NULL;
+	if (bus->iommu_ops != NULL)
+		return true;
+	else
+		return iommu_ops != NULL;
 }
-EXPORT_SYMBOL_GPL(iommu_found);
+EXPORT_SYMBOL_GPL(iommu_present);
 
 struct iommu_domain *iommu_domain_alloc(struct bus_type *bus)
 {
diff --git a/include/linux/iommu.h b/include/linux/iommu.h
index 3bd6892..de73219 100644
--- a/include/linux/iommu.h
+++ b/include/linux/iommu.h
@@ -56,7 +56,7 @@ struct iommu_ops {
 
 extern void register_iommu(struct iommu_ops *ops);
 extern void iommu_bus_init(struct bus_type *bus, struct iommu_ops *ops);
-extern bool iommu_found(void);
+extern bool iommu_present(struct bus_type *bus);
 extern struct iommu_domain *iommu_domain_alloc(struct bus_type *bus);
 extern void iommu_domain_free(struct iommu_domain *domain);
 extern int iommu_attach_device(struct iommu_domain *domain,
@@ -76,7 +76,7 @@ extern int iommu_domain_has_cap(struct iommu_domain *domain,
 
 struct iommu_ops {};
 
-static inline bool iommu_found(void)
+static inline bool iommu_present(struct bus_type *bus)
 {
 	return false;
 }
diff --git a/virt/kvm/iommu.c b/virt/kvm/iommu.c
index 20115b1..d149940 100644
--- a/virt/kvm/iommu.c
+++ b/virt/kvm/iommu.c
@@ -228,7 +228,7 @@ int kvm_iommu_map_guest(struct kvm *kvm)
 {
 	int r;
 
-	if (!iommu_found()) {
+	if (!iommu_present(&pci_bus_type)) {
 		printk(KERN_ERR "%s: iommu not found\n", __func__);
 		return -ENODEV;
 	}
-- 
1.7.4.1


