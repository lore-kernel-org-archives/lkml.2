Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965944Ab2B1R7G (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Feb 2012 12:59:06 -0500
Received: from g1t0029.austin.hp.com ([15.216.28.36]:14176 "EHLO
	g1t0029.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965908Ab2B1R7D convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Feb 2012 12:59:03 -0500
From: "Mingarelli, Thomas" <Thomas.Mingarelli@hp.com>
To: "dwmw2@infradead.org" <dwmw2@infradead.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "ddutile@redhat.com" <ddutile@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>
Subject: [Intel IOMMU PATCH] Re-evaluate RMRR info for devices removed from
 si domain
Thread-Topic: [Intel IOMMU PATCH] Re-evaluate RMRR info for devices removed
 from si domain
Thread-Index: AQHM9jqNNTub6Zb0D0Ox4UP71IzCepZSluMA
Date: Tue, 28 Feb 2012 17:58:30 +0000
Message-ID: <9774516974AF5F4C8A2C3C69CD3412332034C987@G9W0755.americas.hpqcorp.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [16.216.12.10]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch is being submitted to handle the case where a pci device is
placed into the si domain, when booting in iommu passthrough mode, then
removed. The RMRR information for such devices need to be re-processed
to avoid DMA Read errors due to the Present Bit being cleared in the
device's context entry.
Signed-off-by: Thomas Mingarelli <thomas.mingarelli@hp.com>

diff -up linux-3.2.4/drivers/iommu/intel-iommu.c.ORIG linux-3.2.4/drivers/iommu/intel-iommu.c
--- linux-3.2.4/drivers/iommu/intel-iommu.c.ORIG	2012-02-22 16:10:07.105254130 -0600
+++ linux-3.2.4/drivers/iommu/intel-iommu.c	2012-02-28 12:49:38.537694065 -0600
@@ -2676,7 +2676,8 @@ static int iommu_dummy(struct pci_dev *p
 static int iommu_no_mapping(struct device *dev)
 {
 	struct pci_dev *pdev;
-	int found;
+	struct dmar_rmrr_unit *rmrr;
+	int i, ret, found;
 
 	if (unlikely(dev->bus != &pci_bus_type))
 		return 1;
@@ -2699,7 +2700,24 @@ static int iommu_no_mapping(struct devic
 			 */
 			domain_remove_one_dev_info(si_domain, pdev);
 			printk(KERN_INFO "32bit %s uses non-identity mapping\n",
-			       pci_name(pdev));
+				pci_name(pdev));
+			printk(KERN_INFO "IOMMU: Re-processing RMRR information for device %s:\n",
+				pci_name(pdev));
+			for_each_rmrr_units(rmrr) {
+				for (i = 0; i < rmrr->devices_cnt; i++) {
+					/*
+					 * Here we are just concerned with finding the
+					 * one device that was removed from the
+					 * si_domain and re-evaluating its RMRR info.
+					 */
+					if (rmrr->devices[i] != pdev)
+						continue;
+					ret = iommu_prepare_rmrr_dev(rmrr, pdev);
+					if (ret)
+						printk(KERN_ERR
+							"IOMMU: mapping reserved region failed for device.\n");
+				}
+			}
 			return 0;
 		}
 	} else {
