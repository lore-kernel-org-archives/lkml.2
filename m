Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758396Ab2CFHPz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2012 02:15:55 -0500
Received: from acsinet15.oracle.com ([141.146.126.227]:31773 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758305Ab2CFHPx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2012 02:15:53 -0500
From: Yinghai Lu <yinghai@kernel.org>
To: Jesse Barnes <jbarnes@virtuousgeek.org>, x86 <x86@kernel.org>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yinghai Lu <yinghai@kernel.org>, David Woodhouse <dwmw2@infradead.org>,
        iommu@lists.linux-foundation.org
Subject: [PATCH 09/23] IOMMU: Fix tboot force iommu logic
Date: Mon,  5 Mar 2012 23:13:46 -0800
Message-Id: <1331018040-30725-10-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1331018040-30725-1-git-send-email-yinghai@kernel.org>
References: <1331018040-30725-1-git-send-email-yinghai@kernel.org>
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
X-CT-RefId: str=0001.0A090207.4F55B9A4.002D,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Should check dmar_disabled just after tboot_force_iommu.

otherwise when tboot is not used, and intel_iommu=off, and nointrmap
still get dmar_table_init() called. that will cause some get_device
calling, and it will have some device refcount leaking.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: iommu@lists.linux-foundation.org
---
 drivers/iommu/intel-iommu.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/iommu/intel-iommu.c b/drivers/iommu/intel-iommu.c
index 39ef2ce..f1879d3 100644
--- a/drivers/iommu/intel-iommu.c
+++ b/drivers/iommu/intel-iommu.c
@@ -3771,6 +3771,9 @@ int __init intel_iommu_init(void)
 	/* VT-d is required for a TXT/tboot launch, so enforce that */
 	force_on = tboot_force_iommu();
 
+	if (no_iommu || dmar_disabled)
+		return -ENODEV;
+
 	if (dmar_table_init()) {
 		if (force_on)
 			panic("tboot: Failed to initialize DMAR table\n");
@@ -3783,9 +3786,6 @@ int __init intel_iommu_init(void)
 		return 	-ENODEV;
 	}
 
-	if (no_iommu || dmar_disabled)
-		return -ENODEV;
-
 	if (iommu_init_mempool()) {
 		if (force_on)
 			panic("tboot: Failed to initialize iommu memory\n");
-- 
1.7.7

