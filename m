Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162025Ab2CSFyE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 01:54:04 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:31303 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161945Ab2CSFto (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 01:49:44 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Jesse Barnes <jbarnes@virtuousgeek.org>, x86 <x86@kernel.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH -v2 10/26] PCI: Use for_each_pci_dev_resource pci_enable_dev
Date: Sun, 18 Mar 2012 22:48:33 -0700
Message-Id: <1332136129-14010-11-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1332136129-14010-1-git-send-email-yinghai@kernel.org>
References: <1332136129-14010-1-git-send-email-yinghai@kernel.org>
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
X-CT-RefId: str=0001.0A090203.4F66C8F5.0080,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 drivers/pci/pci.c |   15 ++++++++-------
 1 files changed, 8 insertions(+), 7 deletions(-)

diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
index 82ed56a..44b4835 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -486,8 +486,9 @@ static void
 pci_restore_bars(struct pci_dev *dev)
 {
 	int i;
+	struct resource *res;
 
-	for (i = 0; i < PCI_BRIDGE_RESOURCES; i++)
+	for_each_pci_dev_nobridge_resource(dev, res, i)
 		pci_update_resource(dev, i);
 }
 
@@ -1141,6 +1142,7 @@ static int __pci_enable_device_flags(struct pci_dev *dev,
 {
 	int err;
 	int i, bars = 0;
+	struct resource *res;
 
 	/*
 	 * Power state could be unknown at this point, either due to a fresh
@@ -1158,12 +1160,11 @@ static int __pci_enable_device_flags(struct pci_dev *dev,
 		return 0;		/* already enabled */
 
 	/* only skip sriov related */
-	for (i = 0; i <= PCI_ROM_RESOURCE; i++)
-		if (dev->resource[i].flags & flags)
-			bars |= (1 << i);
-	for (i = PCI_BRIDGE_RESOURCES; i < DEVICE_COUNT_RESOURCE; i++)
-		if (dev->resource[i].flags & flags)
+	for_each_pci_dev_noiov_resource(dev, res, i) {
+		/* TODO: check i with bits of bars */
+		if (res->flags & flags)
 			bars |= (1 << i);
+	}
 
 	err = do_pci_enable_device(dev, bars);
 	if (err < 0)
@@ -2465,7 +2466,7 @@ static int __pci_request_region(struct pci_dev *pdev, int bar, const char *res_n
 
 err_out:
 	dev_warn(&pdev->dev, "BAR %d: can't reserve %pR\n", bar,
-		 &pdev->resource[bar]);
+		 pci_dev_resource_n(pdev, bar));
 	return -EBUSY;
 }
 
-- 
1.7.7

