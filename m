Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754052Ab1IBRdz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Sep 2011 13:33:55 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:41213 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753803Ab1IBRdM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Sep 2011 13:33:12 -0400
From: Ohad Ben-Cohen <ohad@wizery.com>
To: <iommu@lists.linux-foundation.org>
Cc: <linux-omap@vger.kernel.org>, Hiroshi DOYU <Hiroshi.DOYU@nokia.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Joerg Roedel <Joerg.Roedel@amd.com>,
        David Woodhouse <dwmw2@infradead.org>,
        <linux-arm-kernel@lists.infradead.org>,
        David Brown <davidb@codeaurora.org>, Arnd Bergmann <arnd@arndb.de>,
        <linux-kernel@vger.kernel.org>, Ohad Ben-Cohen <ohad@wizery.com>,
        Stepan Moskovchenko <stepanm@codeaurora.org>
Subject: [PATCH 5/7] iommu/msm: ->unmap() should return order of unmapped page
Date: Fri,  2 Sep 2011 20:32:34 +0300
Message-Id: <1314984756-4400-6-git-send-email-ohad@wizery.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1314984756-4400-1-git-send-email-ohad@wizery.com>
References: <1314984756-4400-1-git-send-email-ohad@wizery.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Users of the IOMMU API (kvm specifically) assume that iommu_unmap()
returns the order of the unmapped page (on success).

Fix msm_iommu_unmap() accordingly.

Signed-off-by: Ohad Ben-Cohen <ohad@wizery.com>
Cc: Stepan Moskovchenko <stepanm@codeaurora.org>
Cc: David Brown <davidb@codeaurora.org>
---
 drivers/iommu/msm_iommu.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/drivers/iommu/msm_iommu.c b/drivers/iommu/msm_iommu.c
index 1a584e0..d1733f6 100644
--- a/drivers/iommu/msm_iommu.c
+++ b/drivers/iommu/msm_iommu.c
@@ -543,6 +543,13 @@ static int msm_iommu_unmap(struct iommu_domain *domain, unsigned long va,
 	}
 
 	ret = __flush_iotlb(domain);
+
+	/*
+	 * the IOMMU API requires us to return the order of the unmapped
+	 * page (on success).
+	 */
+	if (!ret)
+		ret = order;
 fail:
 	spin_unlock_irqrestore(&msm_iommu_lock, flags);
 	return ret;
-- 
1.7.4.1

