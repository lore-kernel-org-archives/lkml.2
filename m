Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754506Ab0GGAkQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jul 2010 20:40:16 -0400
Received: from mga09.intel.com ([134.134.136.24]:37137 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751377Ab0GGAkO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jul 2010 20:40:14 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.53,549,1272870000"; 
   d="scan'208";a="533096927"
Subject: Re: BUG in drivers/dma/ioat/dma_v2.c:314
From: Dan Williams <dan.j.williams@intel.com>
To: Chris Li <lkml@chrisli.org>
Cc: David Woodhouse <dwmw2@infradead.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Matthew Wilcox <willy@linux.intel.com>
In-Reply-To: <AANLkTimToKAxKLyONyk7KP4WXCS_FpjRjr1yWB3GCaQk@mail.gmail.com>
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
Content-Type: multipart/mixed; boundary="=-w8pcJFKcFTrb25lYELra"
Date: Tue, 06 Jul 2010 17:51:41 -0700
Message-ID: <1278463901.20082.34.camel@dwillia2-linux>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-1.fc12) 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-w8pcJFKcFTrb25lYELra
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit

[ adding Matthew as one of last people to touch mm/dmapool.c ]

On Tue, 2010-07-06 at 16:40 -0700, Chris Li wrote:
> On Mon, Jul 5, 2010 at 3:16 AM, David Woodhouse <dwmw2@infradead.org> wrote:
> > On Fri, 2010-07-02 at 20:00 +0100, Chris Li wrote:
> >> But I don't see the line that print out BIOS is lying.
> >
> > Hrm. Want to augment the dmar_find_matched_drhd_unit() function to
> > _always_ print the DRHD returned for the offending PCI device? And if
> > that still doesn't show, make it print pdev->vendor, pdev->device and
> > the returned DRHD pointer for _every_ call?
> 
> I just did some experiment, my PCI device ID is  PCI_DEVICE_ID_INTEL_ESB2_0
> (0x2670) instead of PCI_DEVICE_ID_INTEL_IOAT_SNB.

No, it should be PCI_DEVICE_ID_INTEL_IOAT_SNB (0x402f) for the dma
engine at 00:0f.0 .  PCI_DEVICE_ID_INTEL_ESB2_0 is the LPC controller at
00:1f.0,

> That seems to be the reason preventing the warning to be print out. I am not
> sure the warning should be always print out. Just curious why it did
> not trigger.

It should always trigger, and I have verified as much with the attached
replacement patch (by forcing the error on a working system), but we run
into a new problem.  dma_pool_alloc() assumes that any dma_mapping error
is transient.  Do we need a new type of dma_mapping_error() that
indicates permanent failure versus ENOMEM?  The driver can handle the
allocation failure, but it never gets the chance.

------------[ cut here ]------------
WARNING: at drivers/pci/dmar.c:574 dmar_find_matched_drhd_unit+0xe4/0xfa()
Hardware name: [redacted to protect the innocent]
BIOS wrongly assigned I/OAT IOMMU 5: reg_base_addr fe71a000 cap 4900800c2f0462 ecap e01
Modules linked in: ioatdma(+) dca ipv6 snd_pcsp snd_pcm snd_timer snd soundcore i2c_i801 snd_page_alloc serio_raw i2c_core joydev
Pid: 1166, comm: modprobe Not tainted 2.6.35-rc3+ #2
Call Trace:
 [<ffffffff8104bfd0>] warn_slowpath_common+0x85/0x9d
 [<ffffffff8104c043>] warn_slowpath_fmt_taint+0x3f/0x41
 [<ffffffff8125dd4b>] dmar_find_matched_drhd_unit+0xe4/0xfa
 [<ffffffff8126179d>] get_domain_for_dev.clone.3+0x111/0x471
 [<ffffffff81261cbb>] get_valid_domain_for_dev+0x26/0x9a
 [<ffffffff81261f51>] __intel_map_single+0x4c/0x175
 [<ffffffff81262184>] intel_alloc_coherent+0xc7/0xef
 [<ffffffff810edcd2>] dma_pool_alloc+0x179/0x2ab
 [<ffffffffa00ed606>] ? kzalloc+0x14/0x16 [ioatdma]
 [<ffffffffa00efe58>] ioat2_alloc_chan_resources+0x4f/0x219 [ioatdma]
 [<ffffffffa00f33b9>] ioat_dma_self_test+0x94/0x2af [ioatdma]
 [<ffffffff8109bff2>] ? devm_request_threaded_irq+0x98/0xaa
 [<ffffffffa00f31cd>] ioat_probe+0x338/0x3aa [ioatdma]
 [<ffffffffa00f3657>] ioat2_dma_probe+0x83/0x106 [ioatdma]
 [<ffffffffa00f2ded>] ioat_pci_probe+0x133/0x195 [ioatdma]
 [<ffffffff8124b539>] local_pci_probe+0x17/0x1b
 [<ffffffff8124c2f5>] pci_device_probe+0xcd/0xfd
 [<ffffffff812ee5f5>] ? driver_sysfs_add+0x4c/0x71
 [<ffffffff812ee81a>] driver_probe_device+0x12f/0x240
 [<ffffffff812ee97a>] __driver_attach+0x4f/0x6b
 [<ffffffff812ee92b>] ? __driver_attach+0x0/0x6b
 [<ffffffff812edc66>] bus_for_each_dev+0x53/0x88
 [<ffffffff812ee554>] driver_attach+0x1e/0x20
 [<ffffffff812ee19a>] bus_add_driver+0xd5/0x23b
 [<ffffffff812eec54>] driver_register+0x9d/0x10e
 [<ffffffff8124c521>] __pci_register_driver+0x58/0xc8
 [<ffffffffa00fc000>] ? ioat_init_module+0x0/0x85 [ioatdma]
 [<ffffffffa00fc000>] ? ioat_init_module+0x0/0x85 [ioatdma]
 [<ffffffffa00fc06d>] ioat_init_module+0x6d/0x85 [ioatdma]
 [<ffffffff81002069>] do_one_initcall+0x5e/0x159
 [<ffffffff8107bd01>] sys_init_module+0xa1/0x1e0
 [<ffffffff81009c32>] system_call_fastpath+0x16/0x1b
---[ end trace 02c1ac1f56dc9544 ]---
Disabling lock debugging due to kernel taint
IOMMU: can't find DMAR for device 0000:00:0f.0
Allocating domain for 0000:00:0f.0 failed
IOMMU: can't find DMAR for device 0000:00:0f.0
Allocating domain for 0000:00:0f.0 failed
[...ad infinitum...]

--
Dan


--=-w8pcJFKcFTrb25lYELra
Content-Disposition: attachment; filename="ioat-catch-broken-vtd-v2.patch"
Content-Type: text/x-patch; name="ioat-catch-broken-vtd-v2.patch"; charset="UTF-8"
Content-Transfer-Encoding: 7bit

diff --git a/drivers/pci/dmar.c b/drivers/pci/dmar.c
index 0a19708..f183ac9 100644
--- a/drivers/pci/dmar.c
+++ b/drivers/pci/dmar.c
@@ -532,7 +532,7 @@ static int dmar_pci_device_match(struct pci_dev *devices[], int cnt,
 struct dmar_drhd_unit *
 dmar_find_matched_drhd_unit(struct pci_dev *dev)
 {
-	struct dmar_drhd_unit *dmaru = NULL;
+	struct dmar_drhd_unit *dmaru, *found = NULL;
 	struct acpi_dmar_hardware_unit *drhd;
 
 	dev = pci_physfn(dev);
@@ -544,14 +544,38 @@ dmar_find_matched_drhd_unit(struct pci_dev *dev)
 
 		if (dmaru->include_all &&
 		    drhd->segment == pci_domain_nr(dev->bus))
-			return dmaru;
-
-		if (dmar_pci_device_match(dmaru->devices,
+			found = dmaru;
+		else if (dmar_pci_device_match(dmaru->devices,
 					  dmaru->devices_cnt, dev))
-			return dmaru;
+			found = dmaru;
+
+
+		if (found)
+			break;
+	}
+
+	/* We know that this device only exists on this chipset, has its
+	 * own IOMMU, and is uniquely identified by bit 54 being set in
+	 * its capability mask.  Catch BIOSes that specify the incorrect
+	 * IOMMU unit.
+	 */
+	if (found &&
+	    dev->vendor == PCI_VENDOR_ID_INTEL &&
+	    dev->device == PCI_DEVICE_ID_INTEL_IOAT_SNB &&
+	    !test_bit(54, (unsigned long *) &found->iommu->cap)) {
+		struct intel_iommu *iommu = found->iommu;
+
+		WARN_TAINT_ONCE(1, TAINT_FIRMWARE_WORKAROUND,
+				"BIOS wrongly assigned I/OAT IOMMU "
+				"%d: reg_base_addr %llx cap %llx ecap %llx\n",
+				iommu->seq_id,
+				(unsigned long long)found->reg_base_addr,
+				(unsigned long long)iommu->cap,
+				(unsigned long long)iommu->ecap);
+		found = NULL;
 	}
 
-	return NULL;
+	return found;
 }
 
 int __init dmar_dev_scope_init(void)

--=-w8pcJFKcFTrb25lYELra--

