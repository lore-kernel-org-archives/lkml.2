Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755873Ab0DCSIW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Apr 2010 14:08:22 -0400
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:37013 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755824Ab0DCSIO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Apr 2010 14:08:14 -0400
Message-Id: <1270318093.15869.1368145605@webmail.messagingengine.com>
X-Sasl-Enc: eIcEux8tdeBE5XFRy8/AsbRQ6EBT+hpqFP8IZjBd3LMm 1270318093
From: "Clemens Ladisch" <clemens@ladisch.de>
To: "Rafael J. Wysocki" <rjw@sisk.pl>,
       "Linus Torvalds" <torvalds@linux-foundation.org>
Cc: "Alex Deucher" <alexdeucher@gmail.com>,
       "Linux PCI" <linux-pci@vger.kernel.org>, "Greg KH" <gregkh@suse.de>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Jesse Barnes" <jbarnes@virtuousgeek.org>,
       dri-devel@lists.sourceforge.net, stable@kernel.org,
       "Dave Airlie" <airlied@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"
X-Mailer: MessagingEngine.com Webmail Interface
References: <alpine.LFD.2.00.1003301029250.3707@i5.linux-foundation.org>
 <201004020120.50398.rjw@sisk.pl>
 <alpine.LFD.2.00.1004011723010.3634@i5.linux-foundation.org>
 <201004021846.06522.rjw@sisk.pl>
Subject: Re: [Regression, post-rc2] Commit a5ee4eb7541 breaks OpenGL on RS780
 (was: Re: Linux 2.6.34-rc3)
In-Reply-To: <201004021846.06522.rjw@sisk.pl>
Date: Sat, 03 Apr 2010 20:08:13 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael J. Wysocki wrote:
> From: Clemens Ladisch <clemens@ladisch.de>
> Subject: PCI quirk: RS780/RS880: disable MSI completely
> 
> The missing initialization of the nb_cntl.strap_msi_enable does not
> seem to be the only problem that prevents MSI, so that quirk is not
> sufficient to enable MSI on all machines.  To be safe, disable MSI
> unconditionally for the internal graphics and HDMI audio on these
> chipsets.
> 
> [rjw: Added the PCI_VENDOR_ID_AI quirk.]
> ...
> +DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_AMD, 0x9602, quirk_disable_msi);
> +DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_ASUSTEK, 0x9602, quirk_disable_msi);
> +DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_AI, 0x9602, quirk_disable_msi);

I fear I have to NACK this.  The fact that two OEMs have changed the vendor
ID makes it likely that this is a bug in AMD's template BIOS code, and that
we will see the same problem on other systems using other vendor IDs.

So we should not use the vendor ID of device 0x9602 to declare the quirk, but
use some other device with an ID that is known to be correct.  We already
access the configuration space of the host bridge, so we should use that.

Furthermore, the quirk in my first patch was never run at all on the ALi
system, so it is probable that the nb_cntl.strap_msi_enable detection
would actually work.  Rafael, please test this patch; if it doesn't work
on your system, we can still remove the check for the strap_msi_enable bit.

==========

Subject: PCI quirk: RS780/RS880: work around wrong vendor IDs of RS780 bridge

On many RS780 systems, the vendor ID of the PCI/PCI bridge for the
internal graphics is set to that of the mainboard vendor, so the quirk
would not match and failed to notice the disabled MSI.

Since we do not know in advance all possible vendor IDs, we have to
declare the quirk on another device with an ID that is known to be
correct, and use that as a stepping stone to find the PCI/PCI bridge,
if present.

Signed-off-by: Clemens Ladisch <clemens@ladisch.de>
Cc: <stable@kernel.org>

--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -2483,34 +2483,38 @@ DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_AT
  * MSI does not work with the AMD RS780/RS880 internal graphics and HDMI audio
  * devices unless the BIOS has initialized the nb_cntl.strap_msi_enable bit.
  */
-static void __init rs780_int_gfx_disable_msi(struct pci_dev *int_gfx_bridge)
+static void __init rs780_int_gfx_disable_msi(struct pci_dev *host_bridge)
 {
+	struct pci_dev *int_gfx_bridge;
 	u32 nb_cntl;
 
-	if (!int_gfx_bridge->subordinate)
+	/*
+	 * Many OEMs change the vendor ID of the internal graphics PCI/PCI
+	 * bridge, so we use the possible vendor/device IDs of the host bridge
+	 * for the declared quirk, and search for the PCI/PCI bridge by slot
+	 * number.
+	 */
+	int_gfx_bridge = pci_get_slot(host_bridge->bus, PCI_DEVFN(1, 0));
+	if (!int_gfx_bridge)
 		return;
+	if (int_gfx_bridge->device != 0x9602 || !int_gfx_bridge->subordinate)
+		goto out;
 
-	pci_bus_write_config_dword(int_gfx_bridge->bus, PCI_DEVFN(0, 0),
-				   0x60, 0);
-	pci_bus_read_config_dword(int_gfx_bridge->bus, PCI_DEVFN(0, 0),
-				  0x64, &nb_cntl);
+	pci_write_config_dword(host_bridge, 0x60, 0);
+	pci_read_config_dword(host_bridge, 0x64, &nb_cntl);
 
 	if (!(nb_cntl & BIT(10))) {
 		dev_warn(&int_gfx_bridge->dev,
 			 FW_WARN "RS780: MSI for internal graphics disabled\n");
 		int_gfx_bridge->subordinate->bus_flags |= PCI_BUS_FLAGS_NO_MSI;
 	}
-}
 
-#define PCI_DEVICE_ID_AMD_RS780_P2P_INT_GFX	0x9602
+out:
+	pci_dev_put(int_gfx_bridge);
+}
 
-DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_AMD,
-			PCI_DEVICE_ID_AMD_RS780_P2P_INT_GFX,
-			rs780_int_gfx_disable_msi);
-/* wrong vendor ID on M4A785TD motherboard: */
-DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_ASUSTEK,
-			PCI_DEVICE_ID_AMD_RS780_P2P_INT_GFX,
-			rs780_int_gfx_disable_msi);
+DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_AMD, 0x9600, rs780_int_gfx_disable_msi);
+DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_AMD, 0x9601, rs780_int_gfx_disable_msi);
 
 #endif /* CONFIG_PCI_MSI */
 
