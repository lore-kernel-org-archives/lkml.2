Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752325Ab1KPELS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Nov 2011 23:11:18 -0500
Received: from mx1.redhat.com ([209.132.183.28]:37277 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751586Ab1KPELQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Nov 2011 23:11:16 -0500
From: Alex Williamson <alex.williamson@redhat.com>
Subject: [PATCH] intel-iommu: Manage iommu_coherency globally
To: dwmw2@infradead.org
Cc: iommu@lists.linux-foundation.org, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, chrisw@sous-sol.org, ddutile@redhat.com,
        alex.williamson@redhat.com
Date: Tue, 15 Nov 2011 21:11:09 -0700
Message-ID: <20111116040752.11878.18642.stgit@bling.home>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We currently manage iommu_coherency on a per domain basis,
choosing the safest setting across the iommus attached to a
particular domain.  This unfortunately has a bug that when
no iommus are attached, the domain defaults to coherent.
If we fall into this mode, then later add a device behind a
non-coherent iommu to that domain, the context entry is
updated using the wrong coherency setting, and we get dmar
faults.

Since we expect chipsets to be consistent in their coherency
setting, we can instead determine the coherency once and use
it globally.

Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
---

As suggested, here's an updated patch to which sets the
coherency once at initalization time instead of changing
the default coherency for orphaned domains.  Thanks,

Alex

 drivers/iommu/intel-iommu.c |   40 +++++++++++++++++-----------------------
 1 files changed, 17 insertions(+), 23 deletions(-)

diff --git a/drivers/iommu/intel-iommu.c b/drivers/iommu/intel-iommu.c
index c0c7820..79e103a 100644
--- a/drivers/iommu/intel-iommu.c
+++ b/drivers/iommu/intel-iommu.c
@@ -353,7 +353,6 @@ struct dmar_domain {
 
 	int		flags;		/* flags to find out type of domain */
 
-	int		iommu_coherency;/* indicate coherency of iommu access */
 	int		iommu_snooping; /* indicate snooping control feature*/
 	int		iommu_count;	/* reference count of iommu */
 	int		iommu_superpage;/* Level of superpages supported:
@@ -419,6 +418,8 @@ static LIST_HEAD(device_domain_list);
 
 static struct iommu_ops intel_iommu_ops;
 
+static int iommu_coherency __read_mostly = 1;
+
 static int __init intel_iommu_setup(char *str)
 {
 	if (!str)
@@ -556,20 +557,6 @@ static struct intel_iommu *domain_get_iommu(struct dmar_domain *domain)
 	return g_iommus[iommu_id];
 }
 
-static void domain_update_iommu_coherency(struct dmar_domain *domain)
-{
-	int i;
-
-	domain->iommu_coherency = 1;
-
-	for_each_set_bit(i, &domain->iommu_bmp, g_num_of_iommus) {
-		if (!ecap_coherent(g_iommus[i]->ecap)) {
-			domain->iommu_coherency = 0;
-			break;
-		}
-	}
-}
-
 static void domain_update_iommu_snooping(struct dmar_domain *domain)
 {
 	int i;
@@ -608,7 +595,6 @@ static void domain_update_iommu_superpage(struct dmar_domain *domain)
 /* Some capabilities may be different across iommus */
 static void domain_update_iommu_cap(struct dmar_domain *domain)
 {
-	domain_update_iommu_coherency(domain);
 	domain_update_iommu_snooping(domain);
 	domain_update_iommu_superpage(domain);
 }
@@ -646,7 +632,7 @@ static struct intel_iommu *device_to_iommu(int segment, u8 bus, u8 devfn)
 static void domain_flush_cache(struct dmar_domain *domain,
 			       void *addr, int size)
 {
-	if (!domain->iommu_coherency)
+	if (!iommu_coherency)
 		clflush_cache_range(addr, size);
 }
 
@@ -1459,11 +1445,6 @@ static int domain_init(struct dmar_domain *domain, int guest_width)
 	domain->agaw = agaw;
 	INIT_LIST_HEAD(&domain->devices);
 
-	if (ecap_coherent(iommu->ecap))
-		domain->iommu_coherency = 1;
-	else
-		domain->iommu_coherency = 0;
-
 	if (ecap_sc_support(iommu->ecap))
 		domain->iommu_snooping = 1;
 	else
@@ -3583,6 +3564,8 @@ static struct notifier_block device_nb = {
 
 int __init intel_iommu_init(void)
 {
+	struct dmar_drhd_unit *drhd;
+	struct intel_iommu *iommu;
 	int ret = 0;
 
 	/* VT-d is required for a TXT/tboot launch, so enforce that */
@@ -3643,6 +3626,18 @@ int __init intel_iommu_init(void)
 
 	init_iommu_pm_ops();
 
+	/*
+	 * Check for coherency support across all iommus.  If unsupported
+	 * by any, force cache flushes.  Expected to be consistent across
+	 * all iommus in the system.
+	 */
+	for_each_active_iommu(iommu, drhd) {
+		if (!ecap_coherent(iommu->ecap)) {
+			iommu_coherency = 0;
+			break;
+		}
+	}
+
 	bus_set_iommu(&pci_bus_type, &intel_iommu_ops);
 
 	bus_register_notifier(&pci_bus_type, &device_nb);
@@ -3820,7 +3815,6 @@ static int md_domain_init(struct dmar_domain *domain, int guest_width)
 	INIT_LIST_HEAD(&domain->devices);
 
 	domain->iommu_count = 0;
-	domain->iommu_coherency = 0;
 	domain->iommu_snooping = 0;
 	domain->iommu_superpage = 0;
 	domain->max_addr = 0;

