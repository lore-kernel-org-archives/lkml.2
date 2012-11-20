Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752697Ab2KTTnW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 14:43:22 -0500
Received: from g6t0187.atlanta.hp.com ([15.193.32.64]:16211 "EHLO
	g6t0187.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752141Ab2KTTnU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 14:43:20 -0500
From: Tom Mingarelli <thomas.mingarelli@hp.com>
To: Alex Williamson <alex.williamson@redhat.com>,
        Don Dutile <ddutile@redhat.com>
Cc: Linda Knippers <linda.knippers@hp.com>, iommu@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, Shuah Khan <shuah.khan@hp.com>,
        Tom Mingarelli <thomas.mingarelli@hp.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Joerg Roedel <joerg.roedel@amd.com>
Message-Id: <20120917082234.22091.84161.sendpatchset@RHEL63BL460c>
Subject: [PATCH v4] intel-iommu: Prevent devices with RMRRs from being placed into SI Domain
Date: Tue, 20 Nov 2012 19:43:17 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch is to prevent non-USB devices that have RMRRs associated with them from
being placed into the SI Domain during init. This fixes the issue where the RMRR info
for devices being placed in and out of the SI Domain gets lost.

Signed-off-by: Thomas Mingarelli <thomas.mingarelli@hp.com>
Tested-by: Shuah Khan <shuah.khan@hp.com>
---
PATCH v1: https://lkml.org/lkml/2012/6/15/204
PATCH v2: https://lkml.org/lkml/2012/9/18/354
PATCH v3: https://lkml.org/lkml/2012/10/16/375

 drivers/iommu/intel-iommu.c |   31 +++++++++++++++++++++++++++++++
 1 files changed, 31 insertions(+), 0 deletions(-)

diff --git a/drivers/iommu/intel-iommu.c b/drivers/iommu/intel-iommu.c
index d4a4cd4..8c064df 100644
--- a/drivers/iommu/intel-iommu.c
+++ b/drivers/iommu/intel-iommu.c
@@ -2320,8 +2320,39 @@ static int domain_add_dev_info(struct dmar_domain *domain,
 	return 0;
 }
 
+static bool device_has_rmrr(struct pci_dev *dev)
+{
+	struct dmar_rmrr_unit *rmrr;
+	int i;
+
+	for_each_rmrr_units(rmrr) {
+		for (i = 0; i < rmrr->devices_cnt; i++) {
+			/*
+			 * Return TRUE if this RMRR contains the device that
+			 * is passed in.
+			 */
+			if (rmrr->devices[i] == dev)
+				return true;
+		}
+	}
+	return false;
+}
+
 static int iommu_should_identity_map(struct pci_dev *pdev, int startup)
 {
+
+	/*
+	 * We want to prevent any device associated with an RMRR from
+	 * getting placed into the SI Domain. This is done because
+	 * problems exist when devices are moved in and out of domains
+	 * and their respective RMRR info is lost. We exempt USB devices
+	 * from this process due to their usage of RMRRs that are known
+	 * to not be needed after BIOS hand-off to OS.
+	 */
+	if (device_has_rmrr(pdev) &&
+	    (pdev->class >> 8) != PCI_CLASS_SERIAL_USB)
+		return 0;
+
 	if ((iommu_identity_mapping & IDENTMAP_AZALIA) && IS_AZALIA(pdev))
 		return 1;
 
-- 
1.7.1

