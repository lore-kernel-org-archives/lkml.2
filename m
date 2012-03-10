Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752733Ab2CJHBq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Mar 2012 02:01:46 -0500
Received: from rcsinet15.oracle.com ([148.87.113.117]:39136 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752163Ab2CJHBg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Mar 2012 02:01:36 -0500
From: Yinghai Lu <yinghai@kernel.org>
To: Jesse Barnes <jbarnes@virtuousgeek.org>, x86 <x86@kernel.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yinghai Lu <yinghai@kernel.org>, David Woodhouse <dwmw2@infradead.org>,
        iommu@lists.linux-foundation.org
Subject: [PATCH v2 03/37] IOMMU: Fix tboot force iommu logic
Date: Fri,  9 Mar 2012 23:00:03 -0800
Message-Id: <1331362837-10740-4-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1331362837-10740-1-git-send-email-yinghai@kernel.org>
References: <1331362837-10740-1-git-send-email-yinghai@kernel.org>
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
X-CT-RefId: str=0001.0A090207.4F5AFC48.0051,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Should check dmar_disabled just after tboot_force_iommu.

Otherwise when tboot is not used, and intel_iommu=off, and nointrmap
still get dmar_table_init() called. that will cause some get_device
calling, and it will have some device refcount leaking.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: iommu@lists.linux-foundation.org
---
 drivers/iommu/intel-iommu.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/iommu/intel-iommu.c b/drivers/iommu/intel-iommu.c
index 49eb412..7c71a3a 100644
--- a/drivers/iommu/intel-iommu.c
+++ b/drivers/iommu/intel-iommu.c
@@ -3768,6 +3768,9 @@ int __init intel_iommu_init(void)
 	/* VT-d is required for a TXT/tboot launch, so enforce that */
 	force_on = tboot_force_iommu();
 
+	if (no_iommu || dmar_disabled)
+		return -ENODEV;
+
 	if (dmar_table_init()) {
 		if (force_on)
 			panic("tboot: Failed to initialize DMAR table\n");
@@ -3780,9 +3783,6 @@ int __init intel_iommu_init(void)
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

