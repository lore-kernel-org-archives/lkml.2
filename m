Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754367Ab2DCCVx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2012 22:21:53 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:21878 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754236Ab2DCCVY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2012 22:21:24 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Bjorn Helgaas <bhelgaas@google.com>, Len Brown <len.brown@intel.com>,
        Jiang Liu <jiang.liu@huawei.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>, x86 <x86@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yinghai Lu <yinghai@kernel.org>, David Woodhouse <dwmw2@infradead.org>,
        iommu@lists.linux-foundation.org
Subject: [RFC PATCH 06/14] IOMMU: Fix tboot force iommu logic
Date: Mon,  2 Apr 2012 19:19:33 -0700
Message-Id: <1333419581-7836-7-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1333419581-7836-1-git-send-email-yinghai@kernel.org>
References: <1333419581-7836-1-git-send-email-yinghai@kernel.org>
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A020204.4F7A5E4B.0063,ss=1,re=0.000,fgs=0
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
index be867e6..b7e5a7e 100644
--- a/drivers/iommu/intel-iommu.c
+++ b/drivers/iommu/intel-iommu.c
@@ -3630,6 +3630,9 @@ int __init intel_iommu_init(void)
 	/* VT-d is required for a TXT/tboot launch, so enforce that */
 	force_on = tboot_force_iommu();
 
+	if (no_iommu || dmar_disabled)
+		return -ENODEV;
+
 	if (dmar_table_init()) {
 		if (force_on)
 			panic("tboot: Failed to initialize DMAR table\n");
@@ -3642,9 +3645,6 @@ int __init intel_iommu_init(void)
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

