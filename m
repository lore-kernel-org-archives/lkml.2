Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754875Ab2E1Dgf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 May 2012 23:36:35 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:52241 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754116Ab2E1D3o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 May 2012 23:29:44 -0400
Message-Id: <20120528031216.926897101@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 28 May 2012 04:13:44 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, David Woodhouse <dwmw2@infradead.org>,
        Xudong Hao <xudong.hao@intel.com>,
        Xiantao Zhang <xiantao.zhang@intel.com>,
        Chris Wright <chrisw@sous-sol.org>,
        David Woodhouse <David.Woodhouse@intel.com>
Subject: [ 102/117] intel-iommu: Add device info into list before doing context mapping
In-Reply-To: <20120528031202.829379252@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.185
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Woodhouse <dwmw2@infradead.org>

commit e2ad23d04c1304431ab5176c89b7b476ded2d995 upstream.

Add device info into list before doing context mapping, because device
info will be used by iommu_enable_dev_iotlb(). Without it, ATS won't get
enabled as it should be.

ATS, while a dubious decision from a security point of view, can be very
important for performance.

Signed-off-by: Xudong Hao <xudong.hao@intel.com>
Signed-off-by: Xiantao Zhang <xiantao.zhang@intel.com>
Acked-by: Chris Wright <chrisw@sous-sol.org>
Signed-off-by: David Woodhouse <David.Woodhouse@intel.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/iommu/intel-iommu.c |   17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

diff --git a/drivers/iommu/intel-iommu.c b/drivers/iommu/intel-iommu.c
index bf2fbaa..abab245 100644
--- a/drivers/iommu/intel-iommu.c
+++ b/drivers/iommu/intel-iommu.c
@@ -2287,12 +2287,6 @@ static int domain_add_dev_info(struct dmar_domain *domain,
 	if (!info)
 		return -ENOMEM;
 
-	ret = domain_context_mapping(domain, pdev, translation);
-	if (ret) {
-		free_devinfo_mem(info);
-		return ret;
-	}
-
 	info->segment = pci_domain_nr(pdev->bus);
 	info->bus = pdev->bus->number;
 	info->devfn = pdev->devfn;
@@ -2305,6 +2299,17 @@ static int domain_add_dev_info(struct dmar_domain *domain,
 	pdev->dev.archdata.iommu = info;
 	spin_unlock_irqrestore(&device_domain_lock, flags);
 
+	ret = domain_context_mapping(domain, pdev, translation);
+	if (ret) {
+		spin_lock_irqsave(&device_domain_lock, flags);
+		list_del(&info->link);
+		list_del(&info->global);
+		pdev->dev.archdata.iommu = NULL;
+		spin_unlock_irqrestore(&device_domain_lock, flags);
+		free_devinfo_mem(info);
+		return ret;
+	}
+
 	return 0;
 }
 


