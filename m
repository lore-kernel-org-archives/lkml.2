Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753305Ab2LMG2n (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 01:28:43 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:46292 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751300Ab2LMG2m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 01:28:42 -0500
From: Alexey Kardashevskiy <aik@ozlabs.ru>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: Alexey Kardashevskiy <aik@ozlabs.ru>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        linux-kernel@vger.kernel.org
Subject: [PATCH] iommu: moving initialization earlier
Date: Thu, 13 Dec 2012 17:28:35 +1100
Message-Id: <1355380115-4518-1-git-send-email-aik@ozlabs.ru>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1355365763.19932.75.camel@pasglop>
References: <1355365763.19932.75.camel@pasglop>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The iommu_init() call initializes IOMMU internal structures and data
required for the API to function such as iommu_group_alloc().
It is registered as a subsys_initcall.

One of the IOMMU users is a PCI subsystem on POWER which discovers new
IOMMU tables during the PCI scan so the most logical place to call
iommu_group_alloc() is when a new group is just discovered. However
PCI scan is done from subsys_initcall hook as well what makes
using of the IOMMU API impossible.

The patch moves IOMMU subsystem initialization one step earlier.

Signed-off-by: Alexey Kardashevskiy <aik@ozlabs.ru>
---
 drivers/iommu/iommu.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
index de857bb..b0afd3d 100644
--- a/drivers/iommu/iommu.c
+++ b/drivers/iommu/iommu.c
@@ -865,7 +865,7 @@ printk("%s %u\n", __func__, __LINE__);
 
 	return 0;
 }
-subsys_initcall(iommu_init);
+arch_initcall(iommu_init);
 
 int iommu_domain_get_attr(struct iommu_domain *domain,
 			  enum iommu_attr attr, void *data)
-- 
1.7.10.4

