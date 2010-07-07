Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754241Ab0GGDkq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jul 2010 23:40:46 -0400
Received: from casper.infradead.org ([85.118.1.10]:55861 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752247Ab0GGDkp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jul 2010 23:40:45 -0400
Subject: Re: BUG in drivers/dma/ioat/dma_v2.c:314
From: David Woodhouse <dwmw2@infradead.org>
To: Dan Williams <dan.j.williams@intel.com>
Cc: Chris Li <lkml@chrisli.org>, linux-kernel <linux-kernel@vger.kernel.org>,
       Matthew Wilcox <willy@linux.intel.com>
In-Reply-To: <1278463901.20082.34.camel@dwillia2-linux>
References: <AANLkTinMqI7hmBYt4eN2oTLZt9_FkoNDHb-9ZF3Z7vls@mail.gmail.com>
	 <4C29420D.2010406@intel.com>
	 <AANLkTikJvUIcx744weazBmOfyZzEu8NgYZ4oaLP2TbZ0@mail.gmail.com>
	 <4C2A8879.8010000@intel.com>
	 <AANLkTinhbjuyDNYQ_meDpewacApahDoY2z6h956JE2Xj@mail.gmail.com>
	 <4C2AC55E.3040303@intel.com>
	 <AANLkTimzQHwVYZU73hoV4S3w9Ez43xNUrvdMkEDWCrvF@mail.gmail.com>
	 <1277923422.16256.8.camel@localhost>	<4C2B9DAC.1030806@intel.com>
	 <1277928125.18854.0.camel@localhost>	<4C2BBACF.3080405@intel.com>
	 <1277965264.18854.16.camel@localhost>	<4C2C3B07.7050200@intel.com>
	 <1277968336.4945.3.camel@localhost>	<4C2C4319.6090906@intel.com>
	 <1277972137.12558.2.camel@localhost>	<4C2CCE67.6070600@intel.com>
	 <AANLkTimeNp4mMI-6IEl-zlv1DcFF5SyAD4k5O3ZLuCwM@mail.gmail.com>
	 <AANLkTimNPP00pJewLtlk0SJQYjGUCyBWoxzGbTYltGsM@mail.gmail.com>
	 <1278324973.16975.68.camel@localhost>
	 <AANLkTimToKAxKLyONyk7KP4WXCS_FpjRjr1yWB3GCaQk@mail.gmail.com>
	 <1278463901.20082.34.camel@dwillia2-linux>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 07 Jul 2010 04:40:39 +0100
Message-ID: <1278474039.31393.8.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.31.4 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-07-06 at 17:51 -0700, Dan Williams wrote:
> It should always trigger, and I have verified as much with the attached
> replacement patch (by forcing the error on a working system), but we run
> into a new problem.  
> 
> IOMMU: can't find DMAR for device 0000:00:0f.0
> Allocating domain for 0000:00:0f.0 failed

Yeah, we're actually doing the check in the wrong place. This should
work better, I think.

(I'm still only checking for include_all rather than checking for
!cap_write_drain() because that _really_ ought to work; looking at
Chris' latest dmesg it _is_ being assigned to the catch-all unit.)

diff --git a/drivers/pci/intel-iommu.c b/drivers/pci/intel-iommu.c
index c9171be..7df8102 100644
--- a/drivers/pci/intel-iommu.c
+++ b/drivers/pci/intel-iommu.c
@@ -3030,6 +3030,32 @@ static void __init iommu_exit_mempool(void)
 
 }
 
+static void quirk_ioat_snb_no_catchall(struct pci_dev *pdev)
+{
+	struct dmar_drhd_unit *drhd;
+	int i;
+
+	/* We know that this device on this chipset has its own
+	   IOMMU. If we find it under the catch-all IOMMU, then
+	   the BIOS is lying to us. Hope that the IOMMU for
+	   this device is actually disabled, and it needs no
+	   translation... */
+
+	for_each_drhd_unit(drhd) {
+		if (!drhd->include_all)
+			continue;
+		for (i = 0; i < drhd->devices_cnt; i++) {
+			if (drhd->devices[i] == pdev) {
+				WARN_TAINT_ONCE(1, TAINT_FIRMWARE_WORKAROUND,
+						"BIOS wrongly included I/OAT device under catch-all VT-d unit\n");
+				pdev->dev.archdata.iommu = DUMMY_DEVICE_DOMAIN_INFO;
+				return;
+			}
+		}
+	}
+}
+DECLARE_PCI_FIXUP_ENABLE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_IOAT_SNB, quirk_ioat_snb_no_catchall);
+
 static void __init init_no_remapping_devices(void)
 {
 	struct dmar_drhd_unit *drhd;


-- 
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation

