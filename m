Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755220Ab0DBQnS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Apr 2010 12:43:18 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:52290 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752640Ab0DBQnK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Apr 2010 12:43:10 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [Regression, post-rc2] Commit a5ee4eb7541 breaks OpenGL on RS780 (was: Re: Linux 2.6.34-rc3)
Date: Fri, 2 Apr 2010 18:46:06 +0200
User-Agent: KMail/1.12.4 (Linux/2.6.34-rc3-rjw; KDE/4.3.5; x86_64; ; )
Cc: Alex Deucher <alexdeucher@gmail.com>, Clemens Ladisch <clemens@ladisch.de>,
       Linux PCI <linux-pci@vger.kernel.org>, Greg KH <gregkh@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       dri-devel@lists.sourceforge.net, stable@kernel.org,
       Dave Airlie <airlied@gmail.com>
References: <alpine.LFD.2.00.1003301029250.3707@i5.linux-foundation.org> <201004020120.50398.rjw@sisk.pl> <alpine.LFD.2.00.1004011723010.3634@i5.linux-foundation.org>
In-Reply-To: <alpine.LFD.2.00.1004011723010.3634@i5.linux-foundation.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201004021846.06522.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 02 April 2010, Linus Torvalds wrote:
> 
> On Fri, 2 Apr 2010, Rafael J. Wysocki wrote:
> > 
> > Appended, with sign-offs and changelog.
> > 
> > ---
> > Subject: PCI quirk: RS780/RS880: disable MSI completely
> 
> Hmm. Isn't this missing a
> 
> 	From: Clemens Ladisch <clemens@ladisch.de>
> 
> too?

Ouch, yes it is, sorry.

This one should be complete.

---
From: Clemens Ladisch <clemens@ladisch.de>
Subject: PCI quirk: RS780/RS880: disable MSI completely

The missing initialization of the nb_cntl.strap_msi_enable does not
seem to be the only problem that prevents MSI, so that quirk is not
sufficient to enable MSI on all machines.  To be safe, disable MSI
unconditionally for the internal graphics and HDMI audio on these
chipsets.

[rjw: Added the PCI_VENDOR_ID_AI quirk.]

Signed-off-by: Clemens Ladisch <clemens@ladisch.de>
Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 drivers/pci/quirks.c |   36 +++---------------------------------
 1 file changed, 3 insertions(+), 33 deletions(-)

Index: linux-2.6/drivers/pci/quirks.c
===================================================================
--- linux-2.6.orig/drivers/pci/quirks.c
+++ linux-2.6/drivers/pci/quirks.c
@@ -2123,6 +2123,9 @@ static void __devinit quirk_disable_msi(
 	}
 }
 DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_8131_BRIDGE, quirk_disable_msi);
+DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_AMD, 0x9602, quirk_disable_msi);
+DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_ASUSTEK, 0x9602, quirk_disable_msi);
+DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_AI, 0x9602, quirk_disable_msi);
 DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_VIA, 0xa238, quirk_disable_msi);
 
 /* Go through the list of Hypertransport capabilities and
@@ -2495,39 +2498,6 @@ DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_AT
 DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_ATI, 0x4375,
 			quirk_msi_intx_disable_bug);
 
-/*
- * MSI does not work with the AMD RS780/RS880 internal graphics and HDMI audio
- * devices unless the BIOS has initialized the nb_cntl.strap_msi_enable bit.
- */
-static void __init rs780_int_gfx_disable_msi(struct pci_dev *int_gfx_bridge)
-{
-	u32 nb_cntl;
-
-	if (!int_gfx_bridge->subordinate)
-		return;
-
-	pci_bus_write_config_dword(int_gfx_bridge->bus, PCI_DEVFN(0, 0),
-				   0x60, 0);
-	pci_bus_read_config_dword(int_gfx_bridge->bus, PCI_DEVFN(0, 0),
-				  0x64, &nb_cntl);
-
-	if (!(nb_cntl & BIT(10))) {
-		dev_warn(&int_gfx_bridge->dev,
-			 FW_WARN "RS780: MSI for internal graphics disabled\n");
-		int_gfx_bridge->subordinate->bus_flags |= PCI_BUS_FLAGS_NO_MSI;
-	}
-}
-
-#define PCI_DEVICE_ID_AMD_RS780_P2P_INT_GFX	0x9602
-
-DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_AMD,
-			PCI_DEVICE_ID_AMD_RS780_P2P_INT_GFX,
-			rs780_int_gfx_disable_msi);
-/* wrong vendor ID on M4A785TD motherboard: */
-DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_ASUSTEK,
-			PCI_DEVICE_ID_AMD_RS780_P2P_INT_GFX,
-			rs780_int_gfx_disable_msi);
-
 #endif /* CONFIG_PCI_MSI */
 
 #ifdef CONFIG_PCI_IOV
