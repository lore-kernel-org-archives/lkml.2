Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752823Ab2HWEax (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2012 00:30:53 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:65373 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751347Ab2HWEau (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2012 00:30:50 -0400
Message-ID: <5035B1F6.3030703@gmail.com>
Date: Wed, 22 Aug 2012 22:30:46 -0600
From: Robert Hancock <hancockrwd@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: Sarah Sharp <sarah.a.sharp@linux.intel.com>
CC: Denis Turischev <denis@compulab.co.il>, linux-usb@vger.kernel.org,
        Greg KH <gregkh@linuxfoundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [RFT] xhci: Switch PPT ports to EHCI on shutdown.
References: <20120807173532.GD10298@xanatos> <20120807173922.GA12037@xanatos>
In-Reply-To: <20120807173922.GA12037@xanatos>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/07/2012 11:39 AM, Sarah Sharp wrote:
> The Intel desktop boards DH77EB and DH77DF have a hardware issue that
> can be worked around by BIOS.  If the USB ports are switched to xHCI on
> shutdown, the xHCI host will send a spurious interrupt, which will wake
> the system.  Some BIOS will work around this, but not all.
>
> The bug can be avoided if the USB ports are switched back to EHCI on
> shutdown.  The Intel Windows driver switches the ports back to EHCI, so
> change the Linux xHCI driver to do the same.
>
> Unfortunately, we can't tell the two effected boards apart from other
> working motherboards, because the vendors will change the DMI strings
> for the DH77EB and DH77DF boards to their own custom names.  One example
> is Compulab's mini-desktop, the Intense-PC.  Instead, key off the
> Panther Point xHCI host PCI vendor and device ID, and switch the ports
> over for all PPT xHCI hosts.
>
> The only impact this will have on non-effected boards is to add a couple
> hundred milliseconds delay on boot when the BIOS has to switch the ports
> over from EHCI to xHCI.
>
> This patch should be backported to kernels as old as 3.0, that contain
> the commit 69e848c2090aebba5698a1620604c7dccb448684 "Intel xhci: Support
> EHCI/xHCI port switching."
>
> Signed-off-by: Sarah Sharp <sarah.a.sharp@linux.intel.com>
> Reported-by: Denis Turischev <denis@compulab.co.il>
> Cc: stable@vger.kernel.org
> ---
>   drivers/usb/host/pci-quirks.c |    7 +++++++
>   drivers/usb/host/pci-quirks.h |    1 +
>   drivers/usb/host/xhci-pci.c   |    9 +++++++++
>   drivers/usb/host/xhci.c       |    3 +++
>   drivers/usb/host/xhci.h       |    1 +
>   5 files changed, 21 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/usb/host/pci-quirks.c b/drivers/usb/host/pci-quirks.c
> index df0828c..c5e9e4a 100644
> --- a/drivers/usb/host/pci-quirks.c
> +++ b/drivers/usb/host/pci-quirks.c
> @@ -800,6 +800,13 @@ void usb_enable_xhci_ports(struct pci_dev *xhci_pdev)
>   }
>   EXPORT_SYMBOL_GPL(usb_enable_xhci_ports);
>
> +void usb_disable_xhci_ports(struct pci_dev *xhci_pdev)
> +{
> +	pci_write_config_dword(xhci_pdev, USB_INTEL_USB3_PSSEN, 0x0);
> +	pci_write_config_dword(xhci_pdev, USB_INTEL_XUSB2PR, 0x0);
> +}
> +EXPORT_SYMBOL_GPL(usb_disable_xhci_ports);
> +
>   /**
>    * PCI Quirks for xHCI.
>    *
> diff --git a/drivers/usb/host/pci-quirks.h b/drivers/usb/host/pci-quirks.h
> index b1002a8..ef004a5 100644
> --- a/drivers/usb/host/pci-quirks.h
> +++ b/drivers/usb/host/pci-quirks.h
> @@ -10,6 +10,7 @@ void usb_amd_quirk_pll_disable(void);
>   void usb_amd_quirk_pll_enable(void);
>   bool usb_is_intel_switchable_xhci(struct pci_dev *pdev);
>   void usb_enable_xhci_ports(struct pci_dev *xhci_pdev);
> +void usb_disable_xhci_ports(struct pci_dev *xhci_pdev);
>   #else
>   static inline void usb_amd_quirk_pll_disable(void) {}
>   static inline void usb_amd_quirk_pll_enable(void) {}
> diff --git a/drivers/usb/host/xhci-pci.c b/drivers/usb/host/xhci-pci.c
> index 92eaff6..9bfd4ca11 100644
> --- a/drivers/usb/host/xhci-pci.c
> +++ b/drivers/usb/host/xhci-pci.c
> @@ -94,6 +94,15 @@ static void xhci_pci_quirks(struct device *dev, struct xhci_hcd *xhci)
>   		xhci->quirks |= XHCI_EP_LIMIT_QUIRK;
>   		xhci->limit_active_eps = 64;
>   		xhci->quirks |= XHCI_SW_BW_CHECKING;
> +		/*
> +		 * PPT desktop boards DH77EB and DH77DF will power back on after
> +		 * a few seconds of being shutdown.  The fix for this is to
> +		 * switch the ports from xHCI to EHCI on shutdown.  We can't use
> +		 * DMI information to find those particular boards (since each
> +		 * vendor will change the board name), so we have to key off all
> +		 * PPT chipsets.
> +		 */
> +		xhci->quirks |= XHCI_SPURIOUS_REBOOT;
>   	}
>   	if (pdev->vendor == PCI_VENDOR_ID_ETRON &&
>   			pdev->device == PCI_DEVICE_ID_ASROCK_P67) {
> diff --git a/drivers/usb/host/xhci.c b/drivers/usb/host/xhci.c
> index 95394e5..81aa10c 100644
> --- a/drivers/usb/host/xhci.c
> +++ b/drivers/usb/host/xhci.c
> @@ -659,6 +659,9 @@ void xhci_shutdown(struct usb_hcd *hcd)
>   {
>   	struct xhci_hcd *xhci = hcd_to_xhci(hcd);
>
> +	if (xhci->quirks && XHCI_SPURIOUS_REBOOT)
> +		usb_disable_xhci_ports(to_pci_dev(hcd->self.controller));

This looks like a typo, think it should be & not &&. With this code, it 
appears the quirk will always be triggered since XHCI_SPURIOUS_REBOOT is 
non-zero.

> +
>   	spin_lock_irq(&xhci->lock);
>   	xhci_halt(xhci);
>   	spin_unlock_irq(&xhci->lock);
> diff --git a/drivers/usb/host/xhci.h b/drivers/usb/host/xhci.h
> index 96f49db..c713256 100644
> --- a/drivers/usb/host/xhci.h
> +++ b/drivers/usb/host/xhci.h
> @@ -1494,6 +1494,7 @@ struct xhci_hcd {
>   #define XHCI_TRUST_TX_LENGTH	(1 << 10)
>   #define XHCI_LPM_SUPPORT	(1 << 11)
>   #define XHCI_INTEL_HOST		(1 << 12)
> +#define XHCI_SPURIOUS_REBOOT	(1 << 13)
>   	unsigned int		num_active_eps;
>   	unsigned int		limit_active_eps;
>   	/* There are two roothubs to keep track of bus suspend info for */
>

