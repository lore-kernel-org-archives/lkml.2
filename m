Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753006Ab0GAIPm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 04:15:42 -0400
Received: from mga02.intel.com ([134.134.136.20]:44457 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752271Ab0GAIPk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 04:15:40 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.53,518,1272870000"; 
   d="scan'208";a="532099117"
Subject: Re: BUG in drivers/dma/ioat/dma_v2.c:314
From: David Woodhouse <David.Woodhouse@intel.com>
To: "Williams, Dan J" <dan.j.williams@intel.com>
Cc: Chris Li <lkml@chrisli.org>, linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <4C2C4319.6090906@intel.com>
References: <AANLkTinMqI7hmBYt4eN2oTLZt9_FkoNDHb-9ZF3Z7vls@mail.gmail.com>
	 <4C29420D.2010406@intel.com>
	 <AANLkTikJvUIcx744weazBmOfyZzEu8NgYZ4oaLP2TbZ0@mail.gmail.com>
	 <4C2A8879.8010000@intel.com>
	 <AANLkTinhbjuyDNYQ_meDpewacApahDoY2z6h956JE2Xj@mail.gmail.com>
	 <4C2AC55E.3040303@intel.com>
	 <AANLkTimzQHwVYZU73hoV4S3w9Ez43xNUrvdMkEDWCrvF@mail.gmail.com>
	 <1277923422.16256.8.camel@localhost>  <4C2B9DAC.1030806@intel.com>
	 <1277928125.18854.0.camel@localhost>  <4C2BBACF.3080405@intel.com>
	 <1277965264.18854.16.camel@localhost>  <4C2C3B07.7050200@intel.com>
	 <1277968336.4945.3.camel@localhost>  <4C2C4319.6090906@intel.com>
Content-Type: text/plain; charset="UTF-8"
Organization: Intel Corporation
Date: Thu, 01 Jul 2010 09:15:36 +0100
Message-ID: <1277972137.12558.2.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.31.4 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-07-01 at 08:26 +0100, Williams, Dan J wrote:
> On 7/1/2010 12:12 AM, Woodhouse, David wrote:
> > On Thu, 2010-07-01 at 07:51 +0100, Williams, Dan J wrote:
> >> This version of the device only exists on the 5400 chipset and always
> >> has its own iommu, but since other platforms get the DMAR entry right I
> >> think this hammer is too big?  Wouldn't this break VT-d operation on
> >> non-busted platforms?
> >
> > That just means we have to get the quirk right. Does 'this version' of
> > the device have its own PCI ID? We can always fall back to checking the
> > ID of the device at 0000:00:00.0 to check which chipset we're on.
> >
> 
> PCI_DEVICE_ID_INTEL_IOAT_SNB only exists on this chipset 

Something like this, then?

diff --git a/drivers/pci/dmar.c b/drivers/pci/dmar.c
index 0a19708..24ac178 100644
--- a/drivers/pci/dmar.c
+++ b/drivers/pci/dmar.c
@@ -543,8 +543,20 @@ dmar_find_matched_drhd_unit(struct pci_dev *dev)
 				    header);
 
 		if (dmaru->include_all &&
-		    drhd->segment == pci_domain_nr(dev->bus))
+		    drhd->segment == pci_domain_nr(dev->bus)) {
+			/* We know that this device on this chipset has its own
+			   IOMMU. If we find it under the catch-all IOMMU, then
+			   the BIOS is lying to us. Hope that the IOMMU for
+			   this device is actually disabled, and it needs no
+			   translation... */
+			if (dev->vendor == PCI_VENDOR_ID_INTEL &&
+			    dev->device == PCI_DEVICE_ID_INTEL_IOAT_SNB) {
+				WARN_TAINT_ONCE(1, TAINT_FIRMWARE_WORKAROUND,
+						"BIOS wrongly included I/OAT device under catch-all VT-d unit\n");
+				return NULL;
+			}
 			return dmaru;
+		}
 
 		if (dmar_pci_device_match(dmaru->devices,
 					  dmaru->devices_cnt, dev))


-- 
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation

