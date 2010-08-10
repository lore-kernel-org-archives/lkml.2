Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932479Ab0HJWYX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Aug 2010 18:24:23 -0400
Received: from 8bytes.org ([88.198.83.132]:55682 "EHLO 8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757748Ab0HJWYU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Aug 2010 18:24:20 -0400
Date: Wed, 11 Aug 2010 00:24:19 +0200
From: Joerg Roedel <joro@8bytes.org>
To: Sander Eikelenboom <linux@eikelenboom.it>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [2.6.35] AMD-Vi: Enabling IOMMU at 0000:00:00.2 cap 0x40  BUG:
	unable to handle kernel NULL pointer dereference at 0000000000000198
Message-ID: <20100810222419.GW23755@8bytes.org>
References: <1154489525.20100810164850@eikelenboom.it> <20100810162606.GQ23755@8bytes.org> <419601760.20100810185745@eikelenboom.it> <20100810180122.GR23755@8bytes.org> <1609756756.20100810200514@eikelenboom.it> <20100810202839.GS23755@8bytes.org> <618241473.20100810223635@eikelenboom.it> <20100810204721.GT23755@8bytes.org> <1498209076.20100810233659@eikelenboom.it>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="MW5yreqqjyrRcusr"
Content-Disposition: inline
In-Reply-To: <1498209076.20100810233659@eikelenboom.it>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--MW5yreqqjyrRcusr
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Aug 10, 2010 at 11:36:59PM +0200, Sander Eikelenboom wrote:
> It boots now, dmesg attached.

Ok, here is a quick and dirty patch wich should make your system boot
again. It introduces other issues which will show up when you try to
assign the devices to a virtual machine. But at least the devices should
work again on bare-metal.

	Joerg


--MW5yreqqjyrRcusr
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="iommu-alias-fix.diff"

diff --git a/arch/x86/include/asm/amd_iommu_types.h b/arch/x86/include/asm/amd_iommu_types.h
index 7014e88..b667e80 100644
--- a/arch/x86/include/asm/amd_iommu_types.h
+++ b/arch/x86/include/asm/amd_iommu_types.h
@@ -285,6 +285,8 @@ struct protection_domain {
 
 };
 
+#define INVALID_ALIAS_ID (~0U)
+
 /*
  * This struct contains device specific data for the IOMMU
  */
@@ -294,6 +296,9 @@ struct iommu_dev_data {
 	struct device *alias;		  /* The Alias Device */
 	struct protection_domain *domain; /* Domain the device is bound to */
 	atomic_t bind;			  /* Domain attach reverent count */
+
+	u32	alias_id;		  /* Use in case device aliases to
+					     non-existend PCI BDF */
 };
 
 /*
diff --git a/arch/x86/kernel/amd_iommu.c b/arch/x86/kernel/amd_iommu.c
index 0d20286..673d0a4 100644
--- a/arch/x86/kernel/amd_iommu.c
+++ b/arch/x86/kernel/amd_iommu.c
@@ -148,11 +148,17 @@ static int iommu_init_device(struct device *dev)
 
 	dev_data->dev = dev;
 
+	dev_data->alias_id = INVALID_ALIAS_ID;
+
 	devid = get_device_id(dev);
 	alias = amd_iommu_alias_table[devid];
 	pdev = pci_get_bus_and_slot(PCI_BUS(alias), alias & 0xff);
 	if (pdev)
 		dev_data->alias = &pdev->dev;
+	else {
+		dev_data->alias = dev;
+		dev_data->alias_id = alias;
+	}
 
 	atomic_set(&dev_data->bind, 0);
 
@@ -1448,6 +1454,9 @@ static void do_attach(struct device *dev, struct protection_domain *domain)
 	list_add(&dev_data->list, &domain->dev_list);
 	set_dte_entry(devid, domain);
 
+	if (dev_data->alias_id != INVALID_ALIAS_ID)
+		set_dte_enry(dev_data->alias_id, domain);
+
 	/* Do reference counting */
 	domain->dev_iommu[iommu->index] += 1;
 	domain->dev_cnt                 += 1;
@@ -1475,6 +1484,9 @@ static void do_detach(struct device *dev)
 	list_del(&dev_data->list);
 	clear_dte_entry(devid);
 
+	if (dev_data->alias_id != INVALID_ALIAS_ID)
+		clear_dte_enry(dev_data->alias_id);
+
 	/* Flush the DTE entry */
 	iommu_flush_device(dev);
 }

--MW5yreqqjyrRcusr--
