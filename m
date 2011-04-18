Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754363Ab1DRNqO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Apr 2011 09:46:14 -0400
Received: from va3ehsobe004.messaging.microsoft.com ([216.32.180.14]:42331
	"EHLO VA3EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753745Ab1DRNqC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Apr 2011 09:46:02 -0400
X-SpamScore: -2
X-BigFish: VPS-2(zzbb2cKzz1202hzz8275bh8275dhz32i668h839h62h)
X-Spam-TCS-SCL: 1:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LJUOWF-01-FT9-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>
CC: <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
        Joerg Roedel <joerg.roedel@amd.com>, <stable@kernel.org>,
        Borislav Petkov <borislav.petkov@amd.com>
Subject: [PATCH 3/4] x86, gart: Set DISTLBWALKPRB bit always
Date: Mon, 18 Apr 2011 15:45:45 +0200
Message-ID: <1303134346-5805-4-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1303134346-5805-1-git-send-email-joerg.roedel@amd.com>
References: <1303134346-5805-1-git-send-email-joerg.roedel@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The DISTLBWALKPRB bit must be set for the GART because the
gatt table is mapped UC. But the current code does not set
the bit at boot when the BIOS setup the aperture correctly.
Fix that by setting this bit when enabling the GART instead
of the other places.

Cc: stable@kernel.org
Cc: Borislav Petkov <borislav.petkov@amd.com>
Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/include/asm/gart.h   |    4 ++--
 arch/x86/kernel/aperture_64.c |    2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/include/asm/gart.h b/arch/x86/include/asm/gart.h
index 88c1ebe..156cd5d 100644
--- a/arch/x86/include/asm/gart.h
+++ b/arch/x86/include/asm/gart.h
@@ -66,7 +66,7 @@ static inline void gart_set_size_and_enable(struct pci_dev *dev, u32 order)
 	 * Don't enable translation but enable GART IO and CPU accesses.
 	 * Also, set DISTLBWALKPRB since GART tables memory is UC.
 	 */
-	ctl = DISTLBWALKPRB | order << 1;
+	ctl = order << 1;
 
 	pci_write_config_dword(dev, AMD64_GARTAPERTURECTL, ctl);
 }
@@ -83,7 +83,7 @@ static inline void enable_gart_translation(struct pci_dev *dev, u64 addr)
 
 	/* Enable GART translation for this hammer. */
 	pci_read_config_dword(dev, AMD64_GARTAPERTURECTL, &ctl);
-	ctl |= GARTEN;
+	ctl |= GARTEN | DISTLBWALKPRB;
 	ctl &= ~(DISGARTCPU | DISGARTIO);
 	pci_write_config_dword(dev, AMD64_GARTAPERTURECTL, ctl);
 }
diff --git a/arch/x86/kernel/aperture_64.c b/arch/x86/kernel/aperture_64.c
index 5c66a2f..3d2661c 100644
--- a/arch/x86/kernel/aperture_64.c
+++ b/arch/x86/kernel/aperture_64.c
@@ -503,7 +503,7 @@ out:
 		 * Don't enable translation yet but enable GART IO and CPU
 		 * accesses and set DISTLBWALKPRB since GART table memory is UC.
 		 */
-		u32 ctl = DISTLBWALKPRB | aper_order << 1;
+		u32 ctl = aper_order << 1;
 
 		bus = amd_nb_bus_dev_ranges[i].bus;
 		dev_base = amd_nb_bus_dev_ranges[i].dev_base;
-- 
1.7.1


