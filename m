Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753607Ab3AGHwq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2013 02:52:46 -0500
Received: from mail-ia0-f169.google.com ([209.85.210.169]:54473 "EHLO
	mail-ia0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751423Ab3AGHwp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2013 02:52:45 -0500
From: Alexey Kardashevskiy <aik@ozlabs.ru>
To: Joerg Roedel <joerg.roedel@amd.com>
Cc: Alexey Kardashevskiy <aik@ozlabs.ru>,
        Alex Williamson <alex.williamson@redhat.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org
Subject: [PATCH] iommu: moving initialization earlier
Date: Mon,  7 Jan 2013 18:51:52 +1100
Message-Id: <1357545112-17375-1-git-send-email-aik@ozlabs.ru>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The iommu_init() initializes IOMMU internal structures and data
required for the IOMMU API as iommu_group_alloc().
It is registered as a subsys_initcall now.

One of the IOMMU users is going to be a PCI subsystem on POWER.
It discovers new IOMMU tables during the PCI scan so the logical
place to call iommu_group_alloc() is the moment when a new group
is discovered. However PCI scan is done from subsys_initcall hook
as IOMMU does so PCI hook can be (and is) called before the IOMMU one.

The patch moves IOMMU subsystem initialization one step earlier
to make sure that IOMMU is initialized before PCI scan begins.

Signed-off-by: Alexey Kardashevskiy <aik@ozlabs.ru>
---
 drivers/iommu/iommu.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
index ddbdaca..1065a1a 100644
--- a/drivers/iommu/iommu.c
+++ b/drivers/iommu/iommu.c
@@ -861,7 +861,7 @@ static int __init iommu_init(void)
 
 	return 0;
 }
-subsys_initcall(iommu_init);
+arch_initcall(iommu_init);
 
 int iommu_domain_get_attr(struct iommu_domain *domain,
 			  enum iommu_attr attr, void *data)
-- 
1.7.10.4

