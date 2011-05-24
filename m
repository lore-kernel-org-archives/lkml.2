Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756967Ab1EXQTS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 12:19:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:34731 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751831Ab1EXQTQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 12:19:16 -0400
From: Alex Williamson <alex.williamson@redhat.com>
Subject: [PATCH] intel-iommu: Only unlink device domains from iommu
To: dwmw2@infradead.org
Cc: alex.williamson@redhat.com, david.woodhouse@intel.com,
        iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org, ddutile@redhat.com, chrisw@redhat.com
Date: Tue, 24 May 2011 12:19:04 -0400
Message-ID: <20110524161745.2472.77832.stgit@virtlab9.virt.bos.redhat.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit a97590e5 added unlinking domains from iommus to reciprocate the
iommu from domains unlinking that was already done.  We actually want
to only do this for device domains and never for the static
identity map domain or VM domains.  The SI domain is special and
never freed, while VM domain->id lives in their own special address
space, separate from iommu->domain_ids.

In the current code, a VM can get domain->id zero, then mark that
domain unused when unbound from pci-stub.  This leads to DMAR
write faults when the device is re-bound to the host driver.

Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
---

This should also be queued for stable

 drivers/pci/intel-iommu.c |   11 +++++++----
 1 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/pci/intel-iommu.c b/drivers/pci/intel-iommu.c
index 284fe72..096c9ad 100644
--- a/drivers/pci/intel-iommu.c
+++ b/drivers/pci/intel-iommu.c
@@ -3447,10 +3447,13 @@ static void domain_remove_one_dev_info(struct dmar_domain *domain,
 		domain_update_iommu_cap(domain);
 		spin_unlock_irqrestore(&domain->iommu_lock, tmp_flags);
 
-		spin_lock_irqsave(&iommu->lock, tmp_flags);
-		clear_bit(domain->id, iommu->domain_ids);
-		iommu->domains[domain->id] = NULL;
-		spin_unlock_irqrestore(&iommu->lock, tmp_flags);
+		if (!(domain->flags & DOMAIN_FLAG_VIRTUAL_MACHINE) &&
+		    !(domain->flags & DOMAIN_FLAG_STATIC_IDENTITY)) {
+			spin_lock_irqsave(&iommu->lock, tmp_flags);
+			clear_bit(domain->id, iommu->domain_ids);
+			iommu->domains[domain->id] = NULL;
+			spin_unlock_irqrestore(&iommu->lock, tmp_flags);
+		}
 	}
 
 	spin_unlock_irqrestore(&device_domain_lock, flags);

