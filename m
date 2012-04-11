Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932605Ab2DKQks (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 12:40:48 -0400
Received: from tx2ehsobe002.messaging.microsoft.com ([65.55.88.12]:23642 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760659Ab2DKQkr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 12:40:47 -0400
X-SpamScore: -14
X-BigFish: VPS-14(z6c9Mz1432N98dKzz1202hzz8275bh8275dhz2dh668h839h944hd25h)
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0M2BQBP-02-8DS-02
X-M-MSG: 
Date: Wed, 11 Apr 2012 18:40:38 +0200
From: Joerg Roedel <joerg.roedel@amd.com>
To: Greg KH <gregkh@linuxfoundation.org>
CC: <linux-kernel@vger.kernel.org>, <stable@vger.kernel.org>
Subject: Re: [PATCH 3.2-stable] iommu/amd: Make sure IOMMU interrupts are
 re-enabled on resume
Message-ID: <20120411164038.GK2428@amd.com>
References: <1334161546-11110-1-git-send-email-joerg.roedel@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1334161546-11110-1-git-send-email-joerg.roedel@amd.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 11, 2012 at 06:25:46PM +0200, Joerg Roedel wrote:
> commit 9ddd592a191b32f2ee6c4b6ed2bd52665c3a49f5 upstream
> 
> Unfortunatly the interrupts for the event log and the
> peripheral page-faults are only enabled at boot but not
> re-enabled at resume. Fix that for 3.2.

This is the correct fix for Linux 3.2:


>From 2ff71db30bc4c1f46823a27f9d77bd2a19a9d238 Mon Sep 17 00:00:00 2001
From: Joerg Roedel <joerg.roedel@amd.com>
Date: Thu, 15 Mar 2012 16:29:47 +0100
Subject: [PATCH v3.2-stable] iommu/amd: Make sure IOMMU interrupts are re-enabled on resume

commit 9ddd592a191b32f2ee6c4b6ed2bd52665c3a49f5 upstream

Unfortunatly the interrupts for the event log and the
peripheral page-faults are only enabled at boot but not
re-enabled at resume. Fix that for 3.2.

Cc: stable@vger.kernel.org
Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 drivers/iommu/amd_iommu_init.c |   24 +++++++++++++++++-------
 1 files changed, 17 insertions(+), 7 deletions(-)

diff --git a/drivers/iommu/amd_iommu_init.c b/drivers/iommu/amd_iommu_init.c
index 5c74179..20d5852 100644
--- a/drivers/iommu/amd_iommu_init.c
+++ b/drivers/iommu/amd_iommu_init.c
@@ -1033,8 +1033,9 @@ static int iommu_setup_msi(struct amd_iommu *iommu)
 {
 	int r;
 
-	if (pci_enable_msi(iommu->dev))
-		return 1;
+	r = pci_enable_msi(iommu->dev);
+	if (r)
+		return r;
 
 	r = request_threaded_irq(iommu->dev->irq,
 				 amd_iommu_int_handler,
@@ -1044,24 +1045,33 @@ static int iommu_setup_msi(struct amd_iommu *iommu)
 
 	if (r) {
 		pci_disable_msi(iommu->dev);
-		return 1;
+		return r;
 	}
 
 	iommu->int_enabled = true;
-	iommu_feature_enable(iommu, CONTROL_EVT_INT_EN);
 
 	return 0;
 }
 
 static int iommu_init_msi(struct amd_iommu *iommu)
 {
+	int ret;
+
 	if (iommu->int_enabled)
-		return 0;
+		goto enable_faults;
 
 	if (pci_find_capability(iommu->dev, PCI_CAP_ID_MSI))
-		return iommu_setup_msi(iommu);
+		ret = iommu_setup_msi(iommu);
+	else
+		ret = -ENODEV;
 
-	return 1;
+	if (ret)
+		return ret;
+
+enable_faults:
+	iommu_feature_enable(iommu, CONTROL_EVT_INT_EN);
+
+	return 0;
 }
 
 /****************************************************************************
-- 
1.7.5.4


