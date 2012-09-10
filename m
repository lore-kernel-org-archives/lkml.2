Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757404Ab2IJLJ2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2012 07:09:28 -0400
Received: from softlayer.compulab.co.il ([50.23.254.55]:50273 "EHLO
	compulab.co.il" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757076Ab2IJLJ0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2012 07:09:26 -0400
Message-ID: <504DCA58.2030202@compulab.co.il>
Date: Mon, 10 Sep 2012 14:09:12 +0300
From: Denis Turischev <denis@compulab.co.il>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120827 Thunderbird/15.0
MIME-Version: 1.0
To: Ben Hutchings <ben@decadent.org.uk>
CC: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        Robert Hancock <hancockrwd@gmail.com>
Subject: Re: [ 12/95] xhci: Switch PPT ports to EHCI on shutdown.
References: <20120909224152.583178513@decadent.org.uk>
In-Reply-To: <20120909224152.583178513@decadent.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - softlayer.compulab.co.il
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - compulab.co.il
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ben,

As reported by Robert Hancock there is a typo in if statement below.
Do you want I resubmit it? Or should we wait for Sarah Sharp review?

Denis Turischev

On 09/10/2012 01:42 AM, Ben Hutchings wrote:
> 3.2-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Sarah Sharp <sarah.a.sharp@linux.intel.com>
> 
> commit e95829f474f0db3a4d940cae1423783edd966027 upstream.
> 
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
> Tested-by: Denis Turischev <denis@compulab.co.il>
> Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
> ---
>  drivers/usb/host/pci-quirks.c |    7 +++++++
>  drivers/usb/host/pci-quirks.h |    1 +
>  drivers/usb/host/xhci-pci.c   |    9 +++++++++
>  drivers/usb/host/xhci.c       |    3 +++
>  drivers/usb/host/xhci.h       |    1 +
>  5 files changed, 21 insertions(+)
> 
> --- a/drivers/usb/host/pci-quirks.c
> +++ b/drivers/usb/host/pci-quirks.c
> @@ -800,6 +800,13 @@ void usb_enable_xhci_ports(struct pci_de
>  }
>  EXPORT_SYMBOL_GPL(usb_enable_xhci_ports);
>  
> +void usb_disable_xhci_ports(struct pci_dev *xhci_pdev)
> +{
> +	pci_write_config_dword(xhci_pdev, USB_INTEL_USB3_PSSEN, 0x0);
> +	pci_write_config_dword(xhci_pdev, USB_INTEL_XUSB2PR, 0x0);
> +}
> +EXPORT_SYMBOL_GPL(usb_disable_xhci_ports);
> +
>  /**
>   * PCI Quirks for xHCI.
>   *
> --- a/drivers/usb/host/pci-quirks.h
> +++ b/drivers/usb/host/pci-quirks.h
> @@ -10,6 +10,7 @@ void usb_amd_quirk_pll_disable(void);
>  void usb_amd_quirk_pll_enable(void);
>  bool usb_is_intel_switchable_xhci(struct pci_dev *pdev);
>  void usb_enable_xhci_ports(struct pci_dev *xhci_pdev);
> +void usb_disable_xhci_ports(struct pci_dev *xhci_pdev);
>  #else
>  static inline void usb_amd_quirk_pll_disable(void) {}
>  static inline void usb_amd_quirk_pll_enable(void) {}
> --- a/drivers/usb/host/xhci-pci.c
> +++ b/drivers/usb/host/xhci-pci.c
> @@ -90,6 +90,15 @@ static void xhci_pci_quirks(struct devic
>  		xhci->quirks |= XHCI_EP_LIMIT_QUIRK;
>  		xhci->limit_active_eps = 64;
>  		xhci->quirks |= XHCI_SW_BW_CHECKING;
> +		/*
> +		 * PPT desktop boards DH77EB and DH77DF will power back on after
> +		 * a few seconds of being shutdown.  The fix for this is to
> +		 * switch the ports from xHCI to EHCI on shutdown.  We can't use
> +		 * DMI information to find those particular boards (since each
> +		 * vendor will change the board name), so we have to key off all
> +		 * PPT chipsets.
> +		 */
> +		xhci->quirks |= XHCI_SPURIOUS_REBOOT;
>  	}
>  	if (pdev->vendor == PCI_VENDOR_ID_ETRON &&
>  			pdev->device == PCI_DEVICE_ID_ASROCK_P67) {
> --- a/drivers/usb/host/xhci.c
> +++ b/drivers/usb/host/xhci.c
> @@ -648,6 +648,9 @@ void xhci_shutdown(struct usb_hcd *hcd)
>  {
>  	struct xhci_hcd *xhci = hcd_to_xhci(hcd);
>  
> +	if (xhci->quirks && XHCI_SPURIOUS_REBOOT)


This looks like a typo, think it should be & not &&. With this code, it
appears the quirk will always be triggered since XHCI_SPURIOUS_REBOOT is
non-zero.


> +		usb_disable_xhci_ports(to_pci_dev(hcd->self.controller));
> +
>  	spin_lock_irq(&xhci->lock);
>  	xhci_halt(xhci);
>  	spin_unlock_irq(&xhci->lock);
> --- a/drivers/usb/host/xhci.h
> +++ b/drivers/usb/host/xhci.h
> @@ -1471,6 +1471,7 @@ struct xhci_hcd {
>  #define	XHCI_SW_BW_CHECKING	(1 << 8)
>  #define XHCI_AMD_0x96_HOST	(1 << 9)
>  #define XHCI_TRUST_TX_LENGTH	(1 << 10)
> +#define XHCI_SPURIOUS_REBOOT	(1 << 13)
>  	unsigned int		num_active_eps;
>  	unsigned int		limit_active_eps;
>  	/* There are two roothubs to keep track of bus suspend info for */
> 
> 

