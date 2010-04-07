Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757938Ab0DGMt3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Apr 2010 08:49:29 -0400
Received: from tx2ehsobe004.messaging.microsoft.com ([65.55.88.14]:30320 "EHLO
	TX2EHSOBE008.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757815Ab0DGMsH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Apr 2010 08:48:07 -0400
X-SpamScore: 1
X-BigFish: VPS1(zzab9bhzz1202hzzz32i6bh2a8h87h43h63h)
X-Spam-TCS-SCL: 2:0
X-FB-SS: 5,
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0L0IBJT-01-9UR-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: Ingo Molnar <mingo@redhat.com>
CC: x86@kernel.org, iommu@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org, Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 12/12] x86/gart: Disable GART explicitly before initialization
Date: Wed, 7 Apr 2010 14:46:49 +0200
Message-ID: <1270644409-10123-13-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1270644409-10123-1-git-send-email-joerg.roedel@amd.com>
References: <1270644409-10123-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 07 Apr 2010 12:46:56.0164 (UTC) FILETIME=[67DB6640:01CAD650]
MIME-Version: 1.0
Content-Type: text/plain
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If we boot into a crash-kernel the gart might still be
enabled and its caches might be dirty. This can result in
undefined behavior later. Fix it by explicitly disabling the
gart hardware before initialization and flushing the caches
after enablement.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kernel/aperture_64.c |   15 ++++++++++++++-
 arch/x86/kernel/pci-gart_64.c |    3 +++
 2 files changed, 17 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/aperture_64.c b/arch/x86/kernel/aperture_64.c
index 3704997..b5d8b0b 100644
--- a/arch/x86/kernel/aperture_64.c
+++ b/arch/x86/kernel/aperture_64.c
@@ -393,6 +393,7 @@ void __init gart_iommu_hole_init(void)
 	for (i = 0; i < ARRAY_SIZE(bus_dev_ranges); i++) {
 		int bus;
 		int dev_base, dev_limit;
+		u32 ctl;
 
 		bus = bus_dev_ranges[i].bus;
 		dev_base = bus_dev_ranges[i].dev_base;
@@ -406,7 +407,19 @@ void __init gart_iommu_hole_init(void)
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
diff --git a/arch/x86/kernel/pci-gart_64.c b/arch/x86/kernel/pci-gart_64.c
index f3af115..0ae24d9 100644
--- a/arch/x86/kernel/pci-gart_64.c
+++ b/arch/x86/kernel/pci-gart_64.c
@@ -564,6 +564,9 @@ static void enable_gart_translations(void)
 
 		enable_gart_translation(dev, __pa(agp_gatt_table));
 	}
+
+	/* Flush the GART-TLB to remove stale entries */
+	k8_flush_garts();
 }
 
 /*
-- 
1.7.0.4


