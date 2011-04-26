Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932616Ab1DZVV1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 17:21:27 -0400
Received: from mga01.intel.com ([192.55.52.88]:1301 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932477Ab1DZVO5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 17:14:57 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,270,1301900400"; 
   d="scan'208";a="684327691"
From: Andi Kleen <andi@firstfloor.org>
References: <20110426212.641772347@firstfloor.org>
In-Reply-To: <20110426212.641772347@firstfloor.org>
To: alex.williamson@redhat.com, ddutile@redhat.com, David.Woodhouse@intel.com,
        gregkh@suse.de, ak@linux.intel.com, linux-kernel@vger.kernel.org,
        stable@kernel.org, tim.bird@am.sony.com
Subject: [PATCH] [86/106] intel-iommu: Unlink domain from iommu
Message-Id: <20110426211408.3719F3E1886@tassilo.jf.intel.com>
Date: Tue, 26 Apr 2011 14:14:08 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Alex Williamson <alex.williamson@redhat.com>

commit a97590e56d0d58e1dd262353f7cbd84e81d8e600 upstream.

When we remove a device, we unlink the iommu from the domain, but
we never do the reverse unlinking of the domain from the iommu.
This means that we never clear iommu->domain_ids, eventually leading
to resource exhaustion if we repeatedly bind and unbind a device
to a driver.  Also free empty domains to avoid a resource leak.

Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
Acked-by: Donald Dutile <ddutile@redhat.com>
Signed-off-by: David Woodhouse <David.Woodhouse@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 drivers/pci/intel-iommu.c |   13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

Index: linux-2.6.35.y/drivers/pci/intel-iommu.c
===================================================================
--- linux-2.6.35.y.orig/drivers/pci/intel-iommu.c
+++ linux-2.6.35.y/drivers/pci/intel-iommu.c
@@ -3260,9 +3260,15 @@ static int device_notifier(struct notifi
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
 
@@ -3411,6 +3417,11 @@ static void domain_remove_one_dev_info(s
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
