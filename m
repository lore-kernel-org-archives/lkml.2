Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759402Ab2BNEsM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Feb 2012 23:48:12 -0500
Received: from mga11.intel.com ([192.55.52.93]:9236 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753638Ab2BNEsJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Feb 2012 23:48:09 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="117279765"
Subject: Re: [RFT] USB: Try MSI first before line IRQ for Intel PCIe USB3
 HCD
From: "Alex,Shi" <alex.shi@intel.com>
To: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Cc: stern@rowland.harvard.edu, Greg KH <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, andiry.xu@amd.com,
        linux-kernel@vger.kernel.org, Oliver Neukum <oneukum@suse.de>,
        Takashi Iwai <tiwai@suse.de>, trenn@suse.de, linux-pci@vger.kernel.org,
        Michal Marek <MMarek@suse.com>
In-Reply-To: <20120214002557.GA13003@xanatos>
References: <20120214002557.GA13003@xanatos>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 14 Feb 2012 12:43:56 +0800
Message-ID: <1329194636.12669.1725.camel@debian>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-02-13 at 16:25 -0800, Sarah Sharp wrote:
> We have a PCI USB xhci host controller on a new platform. It doesn't
> have a line IRQ definition in BIOS. The Linux driver refuses to
> initial this controller, but Windows works well because it only depends
> on MSI.
> 
> Actually, Linux also can work for MSI. This patch skips the first line
> IRQ checking for our HCD in usb-core pci probe, then try to enable MSI
> firstly. That make this HCD works well under Linux.
> 
> This patch should be backported to kernels as old as 2.6.32.
> 
> Signed-off-by: Alex Shi <alex.shi@intel.com>
> Signed-off-by: Sarah Sharp <sarah.a.sharp@linux.intel.com>
> Cc: stable@vger.kernel.org
> ---
> 
> Hi Alex,
> 
> Please test this on your Panther Point system that doesn't have a BIOS
> provided IRQ line.  I think this is a much simpler solution.

It is Ok on the platform. 
Thanks!
> 
> Sarah Sharp
> 
>  drivers/usb/core/hcd-pci.c |    5 ++++-
>  drivers/usb/core/hcd.c     |    6 ++++--
>  drivers/usb/host/xhci.c    |    5 +++++
>  3 files changed, 13 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/usb/core/hcd-pci.c b/drivers/usb/core/hcd-pci.c
> index d136b8f..81e2c0d 100644
> --- a/drivers/usb/core/hcd-pci.c
> +++ b/drivers/usb/core/hcd-pci.c
> @@ -187,7 +187,10 @@ int usb_hcd_pci_probe(struct pci_dev *dev, const struct pci_device_id *id)
>  		return -ENODEV;
>  	dev->current_state = PCI_D0;
>  
> -	if (!dev->irq) {
> +	/* The xHCI driver supports MSI and MSI-X,
> +	 * so don't fail if the BIOS doesn't provide a legacy IRQ.
> +	 */
> +	if (!dev->irq && (driver->flags & HCD_MASK) != HCD_USB3) {
>  		dev_err(&dev->dev,
>  			"Found HC with no IRQ.  Check BIOS/PCI %s setup!\n",
>  			pci_name(dev));
> diff --git a/drivers/usb/core/hcd.c b/drivers/usb/core/hcd.c
> index eb19cba..e128232 100644
> --- a/drivers/usb/core/hcd.c
> +++ b/drivers/usb/core/hcd.c
> @@ -2447,8 +2447,10 @@ int usb_add_hcd(struct usb_hcd *hcd,
>  			&& device_can_wakeup(&hcd->self.root_hub->dev))
>  		dev_dbg(hcd->self.controller, "supports USB remote wakeup\n");
>  
> -	/* enable irqs just before we start the controller */
> -	if (usb_hcd_is_primary_hcd(hcd)) {
> +	/* enable irqs just before we start the controller,
> +	 * if the BIOS provides legacy PCI irqs.
> +	 */
> +	if (usb_hcd_is_primary_hcd(hcd) && irqnum) {
>  		retval = usb_hcd_request_irqs(hcd, irqnum, irqflags);
>  		if (retval)
>  			goto err_request_irq;
> diff --git a/drivers/usb/host/xhci.c b/drivers/usb/host/xhci.c
> index 6bbe3c3..c939f5f 100644
> --- a/drivers/usb/host/xhci.c
> +++ b/drivers/usb/host/xhci.c
> @@ -352,6 +352,11 @@ static int xhci_try_enable_msi(struct usb_hcd *hcd)
>  		/* hcd->irq is -1, we have MSI */
>  		return 0;
>  
> +	if (!pdev->irq) {
> +		xhci_err(xhci, "No msi-x/msi found and no IRQ in BIOS\n");
> +		return -EINVAL;
> +	}
> +
>  	/* fall back to legacy interrupt*/
>  	ret = request_irq(pdev->irq, &usb_hcd_irq, IRQF_SHARED,
>  			hcd->irq_descr, hcd);


