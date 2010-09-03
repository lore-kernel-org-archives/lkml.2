Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756473Ab0ICQtM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Sep 2010 12:49:12 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:51269 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752395Ab0ICQtK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Sep 2010 12:49:10 -0400
From: Borislav Petkov <bp@amd64.org>
To: Dave Airlie <airlied@redhat.com>, <hpa@zytor.com>, <mingo@elte.hu>,
        <tglx@linutronix.de>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: <akpm@linux-foundation.org>, <x86@kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Borislav Petkov <borislav.petkov@amd.com>
Subject: [PATCH 2/3] x86, GART: Disable GART table walk probes
Date: Fri,  3 Sep 2010 18:39:40 +0200
Message-Id: <1283531981-7495-3-git-send-email-bp@amd64.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1283531981-7495-1-git-send-email-bp@amd64.org>
References: <1283531981-7495-1-git-send-email-bp@amd64.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <borislav.petkov@amd.com>

Current code tramples over bit F3x90[6] which can be used to disable
GART table walk probes. However, this bit should be set for performance
reasons (speed up GART table walks). We are allowed to do that since we
put GART tables in UC memory later anyway. Make it so.

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 arch/x86/include/asm/gart.h   |   14 ++++++++++++++
 arch/x86/kernel/aperture_64.c |   14 ++++++++------
 arch/x86/kernel/pci-gart_64.c |    2 +-
 drivers/char/agp/amd64-agp.c  |    2 +-
 4 files changed, 24 insertions(+), 8 deletions(-)

diff --git a/arch/x86/include/asm/gart.h b/arch/x86/include/asm/gart.h
index fba0a72..bf357f9 100644
--- a/arch/x86/include/asm/gart.h
+++ b/arch/x86/include/asm/gart.h
@@ -17,6 +17,7 @@ extern int fix_aperture;
 #define GARTEN		(1<<0)
 #define DISGARTCPU	(1<<4)
 #define DISGARTIO	(1<<5)
+#define DISTLBWALKPRB	(1<<6)
 
 /* GART cache control register bits. */
 #define INVGART		(1<<0)
@@ -56,6 +57,19 @@ static inline void gart_iommu_hole_init(void)
 
 extern int agp_amd64_init(void);
 
+static inline void gart_set_size_and_enable(struct pci_dev *dev, u32 order)
+{
+	u32 ctl;
+
+	/*
+	 * Don't enable translation but enable GART IO and CPU accesses.
+	 * Also, set DISTLBWALKPRB since GART tables memory is UC.
+	 */
+	ctl = DISTLBWALKPRB | order << 1;
+
+	pci_write_config_dword(dev, AMD64_GARTAPERTURECTL, ctl);
+}
+
 static inline void enable_gart_translation(struct pci_dev *dev, u64 addr)
 {
 	u32 tmp, ctl;
diff --git a/arch/x86/kernel/aperture_64.c b/arch/x86/kernel/aperture_64.c
index 6fabd40..c9cb173 100644
--- a/arch/x86/kernel/aperture_64.c
+++ b/arch/x86/kernel/aperture_64.c
@@ -505,8 +505,13 @@ out:
 
 	/* Fix up the north bridges */
 	for (i = 0; i < ARRAY_SIZE(bus_dev_ranges); i++) {
-		int bus;
-		int dev_base, dev_limit;
+		int bus, dev_base, dev_limit;
+
+		/*
+		 * Don't enable translation yet but enable GART IO and CPU
+		 * accesses and set DISTLBWALKPRB since GART table memory is UC.
+		 */
+		u32 ctl = DISTLBWALKPRB | aper_order << 1;
 
 		bus = bus_dev_ranges[i].bus;
 		dev_base = bus_dev_ranges[i].dev_base;
@@ -515,10 +520,7 @@ out:
 			if (!early_is_k8_nb(read_pci_config(bus, slot, 3, 0x00)))
 				continue;
 
-			/* Don't enable translation yet. That is done later.
-			   Assume this BIOS didn't initialise the GART so
-			   just overwrite all previous bits */
-			write_pci_config(bus, slot, 3, AMD64_GARTAPERTURECTL, aper_order << 1);
+			write_pci_config(bus, slot, 3, AMD64_GARTAPERTURECTL, ctl);
 			write_pci_config(bus, slot, 3, AMD64_GARTAPERTUREBASE, aper_alloc >> 25);
 		}
 	}
diff --git a/arch/x86/kernel/pci-gart_64.c b/arch/x86/kernel/pci-gart_64.c
index 0f7f130..6015ee1 100644
--- a/arch/x86/kernel/pci-gart_64.c
+++ b/arch/x86/kernel/pci-gart_64.c
@@ -601,7 +601,7 @@ static void gart_fixup_northbridges(struct sys_device *dev)
 		 * Don't enable translations just yet.  That is the next
 		 * step.  Restore the pre-suspend aperture settings.
 		 */
-		pci_write_config_dword(dev, AMD64_GARTAPERTURECTL, aperture_order << 1);
+		gart_set_size_and_enable(dev, aperture_order);
 		pci_write_config_dword(dev, AMD64_GARTAPERTUREBASE, aperture_alloc >> 25);
 	}
 }
diff --git a/drivers/char/agp/amd64-agp.c b/drivers/char/agp/amd64-agp.c
index bfe372b..564808a 100644
--- a/drivers/char/agp/amd64-agp.c
+++ b/drivers/char/agp/amd64-agp.c
@@ -313,7 +313,7 @@ static __devinit int fix_northbridge(struct pci_dev *nb, struct pci_dev *agp,
 	if (order < 0 || !agp_aperture_valid(aper, (32*1024*1024)<<order))
 		return -1;
 
-	pci_write_config_dword(nb, AMD64_GARTAPERTURECTL, order << 1);
+	gart_set_size_and_enable(nb, order);
 	pci_write_config_dword(nb, AMD64_GARTAPERTUREBASE, aper >> 25);
 
 	return 0;
-- 
1.7.1

