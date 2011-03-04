Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932629Ab1CDVwz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Mar 2011 16:52:55 -0500
Received: from mx1.redhat.com ([209.132.183.28]:17166 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932563Ab1CDVwx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Mar 2011 16:52:53 -0500
From: Alex Williamson <alex.williamson@redhat.com>
Subject: [RESEND PATCH v2 1/2] intel-iommu: Unlink domain from iommu
To: dwmw2@infradead.org, iommu@lists.linux-foundation.org
Cc: alex.williamson@redhat.com, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org, ddutile@redhat.com, chrisw@redhat.com
Date: Fri, 04 Mar 2011 14:52:16 -0700
Message-ID: <20110304215209.7617.11798.stgit@s20.home>
In-Reply-To: <20110304214837.7617.46438.stgit@s20.home>
References: <20110304214837.7617.46438.stgit@s20.home>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When we remove a device, we unlink the iommu from the domain, but
we never do the reverse unlinking of the domain from the iommu.
This means that we never clear iommu->domain_ids, eventually leading
to resource exhaustion if we repeatedly bind and unbind a device
to a driver.  Also free empty domains to avoid a resource leak.

Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
Acked-by: Donald Dutile <ddutile@redhat.com>
---

 drivers/pci/intel-iommu.c |   13 ++++++++++++-
 1 files changed, 12 insertions(+), 1 deletions(-)

diff --git a/drivers/pci/intel-iommu.c b/drivers/pci/intel-iommu.c
index 4789f8e..c58dbd7 100644
--- a/drivers/pci/intel-iommu.c
+++ b/drivers/pci/intel-iommu.c
@@ -3260,9 +3260,15 @@ static int device_notifier(struct notifier_block *nb,
 	if (!domain)
 		return 0;
 
-	if (action == BUS_NOTIFY_UNBOUND_DRIVER && !iommu_pass_through)
+	if (action == BUS_NOTIFY_UNBOUND_DRIVER && !iommu_pass_through) {
 		domain_remove_one_dev_info(domain, pdev);
 
+		if (!(domain->flags & DOMAIN_FLAG_VIRTUAL_MACHINE) &&
+		    !(domain->flags & DOMAIN_FLAG_STATIC_IDENTITY) &&
+		    list_empty(&domain->devices))
+			domain_exit(domain);
+	}
+
 	return 0;
 }
 
@@ -3411,6 +3417,11 @@ static void domain_remove_one_dev_info(struct dmar_domain *domain,
 		domain->iommu_count--;
 		domain_update_iommu_cap(domain);
 		spin_unlock_irqrestore(&domain->iommu_lock, tmp_flags);
+
+		spin_lock_irqsave(&iommu->lock, tmp_flags);
+		clear_bit(domain->id, iommu->domain_ids);
+		iommu->domains[domain->id] = NULL;
+		spin_unlock_irqrestore(&iommu->lock, tmp_flags);
 	}
 
 	spin_unlock_irqrestore(&device_domain_lock, flags);

