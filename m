Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758673Ab1E0Bc0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 21:32:26 -0400
Received: from relay1.sgi.com ([192.48.179.29]:58593 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753013Ab1E0BcZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 21:32:25 -0400
Message-Id: <20110527013221.551591112@gulag1.americas.sgi.com>
References: <20110527013221.231071058@gulag1.americas.sgi.com>
User-Agent: quilt/0.46-1
Date: Thu, 26 May 2011 20:32:23 -0500
From: Mike Travis <travis@sgi.com>
To: David Woodhouse <dwmw2@infradead.org>, Chris Wright <chrisw@sous-sol.org>,
        Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>
Cc: Mike Habeck <habeck@sgi.com>, Jesse Barnes <jbarnes@virtuousgeek.org>,
        stable@kernel.org, iommu@lists.linux-foundation.org,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/7] Intel pci: Speed up processing of the identity_mapping function
Content-Disposition: inline; filename=speed-up-iommu_no_mapping.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

    When there are a large count of PCI devices, and the pass
    through option for iommu is set, much time is spent in the
    identity_mapping function hunting though the iommu domains to
    check if a specific device is "identity mapped".

    Speed up the function by checking the cached info to see if
    it's mapped to the static identity domain.

Signed-off-by: Mike Travis <travis@sgi.com>
---
 drivers/pci/intel-iommu.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- linux.orig/drivers/pci/intel-iommu.c
+++ linux/drivers/pci/intel-iommu.c
@@ -2106,10 +2106,10 @@ static int identity_mapping(struct pci_d
 	if (likely(!iommu_identity_mapping))
 		return 0;
 
+	info = pdev->dev.archdata.iommu;
+	if (info && info != DUMMY_DEVICE_DOMAIN_INFO)
+		return (info->domain == si_domain);
 
-	list_for_each_entry(info, &si_domain->devices, link)
-		if (info->dev == pdev)
-			return 1;
 	return 0;
 }
 

-- 
