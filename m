Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754097Ab1KKWuI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Nov 2011 17:50:08 -0500
Received: from mx1.redhat.com ([209.132.183.28]:35776 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752848Ab1KKWuG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Nov 2011 17:50:06 -0500
From: Alex Williamson <alex.williamson@redhat.com>
Subject: [PATCH] intel-iommu: Default to non-coherent for domains unattached
 to iommus
To: dwmw2@infradead.org
Cc: iommu@lists.linux-foundation.org, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, chrisw@sous-sol.org, ddutile@redhat.com,
        alex.williamson@redhat.com
Date: Fri, 11 Nov 2011 15:49:56 -0700
Message-ID: <20111111224849.9756.13368.stgit@bling.home>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

domain_update_iommu_coherency() currently default to setting domains
as coherent when the domain is not attached to any iommus.  This
allows for a window in domain_context_mapping_one() where such a
domain can update context entries non-coherenty, and only after
update the domain capability to clear iommu_coherency.

This can be seen using KVM device assignment on VT-d systems that
do not support coherency in the ecap register.  When a device is
added to a guest, a domain is created (iommu_coherency = 0), the
device is attached, and ranges are mapped.  If we then hot unplug
the device, the coherency is updated and set to the default (1)
since no iommus are attached to the domain.  A subsequenct attach
of a device makes use of the same dmar domain (now marked coherent)
updates context entries with cohrency enabled, and only disables
coherency as the last step in the process.

To fix this, switch domain_update_iommu_coherency() to use the
safer, non-coherent default for domains not attached to iommus.

Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
Tested-by: Donald Dutile <ddutile@redhat.com>
Acked-by: Donald Dutile <ddutile@redhat.com>
---

 drivers/iommu/intel-iommu.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/iommu/intel-iommu.c b/drivers/iommu/intel-iommu.c
index c0c7820..6b9d8c1 100644
--- a/drivers/iommu/intel-iommu.c
+++ b/drivers/iommu/intel-iommu.c
@@ -560,7 +560,9 @@ static void domain_update_iommu_coherency(struct dmar_domain *domain)
 {
 	int i;
 
-	domain->iommu_coherency = 1;
+	i = find_first_bit(&domain->iommu_bmp, g_num_of_iommus);
+
+	domain->iommu_coherency = i < g_num_of_iommus ? 1 : 0;
 
 	for_each_set_bit(i, &domain->iommu_bmp, g_num_of_iommus) {
 		if (!ecap_coherent(g_iommus[i]->ecap)) {

