Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932187Ab0DVUG3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 16:06:29 -0400
Received: from kroah.org ([198.145.64.141]:60147 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758188Ab0DVUCP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 16:02:15 -0400
X-Mailbox-Line: From gregkh@kvm.kroah.org Thu Apr 22 12:54:19 2010
Message-Id: <20100422195419.160232032@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Thu, 22 Apr 2010 12:55:15 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Joerg Roedel <joerg.roedel@amd.com>
Subject: [138/139] x86/gart: Disable GART explicitly before initialization
In-Reply-To: <20100422195715.GA25490@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Joerg Roedel <joerg.roedel@amd.com>

commit 4b83873d3da0704987cb116833818ed96214ee29 upstream.

If we boot into a crash-kernel the gart might still be
enabled and its caches might be dirty. This can result in
undefined behavior later. Fix it by explicitly disabling the
gart hardware before initialization and flushing the caches
after enablement.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/kernel/aperture_64.c |   15 ++++++++++++++-
 arch/x86/kernel/pci-gart_64.c |    3 +++
 2 files changed, 17 insertions(+), 1 deletion(-)

--- a/arch/x86/kernel/aperture_64.c
+++ b/arch/x86/kernel/aperture_64.c
@@ -394,6 +394,7 @@ void __init gart_iommu_hole_init(void)
 	for (i = 0; i < ARRAY_SIZE(bus_dev_ranges); i++) {
 		int bus;
 		int dev_base, dev_limit;
+		u32 ctl;
 
 		bus = bus_dev_ranges[i].bus;
 		dev_base = bus_dev_ranges[i].dev_base;
@@ -407,7 +408,19 @@ void __init gart_iommu_hole_init(void)
 			gart_iommu_aperture = 1;
 			x86_init.iommu.iommu_init = gart_iommu_init;
 
-			aper_order = (read_pci_config(bus, slot, 3, AMD64_GARTAPERTURECTL) >> 1) & 7;
+			ctl = read_pci_config(bus, slot, 3,
+					      AMD64_GARTAPERTURECTL);
+
+			/*
+			 * Before we do anything else disable the GART. It may
+			 * still be enabled if we boot into a crash-kernel here.
+			 * Reconfiguring the GART while it is enabled could have
+			 * unknown side-effects.
+			 */
+			ctl &= ~GARTEN;
+			write_pci_config(bus, slot, 3, AMD64_GARTAPERTURECTL, ctl);
+
+			aper_order = (ctl >> 1) & 7;
 			aper_size = (32 * 1024 * 1024) << aper_order;
 			aper_base = read_pci_config(bus, slot, 3, AMD64_GARTAPERTUREBASE) & 0x7fff;
 			aper_base <<= 25;
--- a/arch/x86/kernel/pci-gart_64.c
+++ b/arch/x86/kernel/pci-gart_64.c
@@ -564,6 +564,9 @@ static void enable_gart_translations(voi
 
 		enable_gart_translation(dev, __pa(agp_gatt_table));
 	}
+
+	/* Flush the GART-TLB to remove stale entries */
+	k8_flush_garts();
 }
 
 /*


