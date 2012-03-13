Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752703Ab2CMCmk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 22:42:40 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38379 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751582Ab2CMCmj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 22:42:39 -0400
Message-ID: <1331606555.22608.6.camel@ul30vt>
Subject: Re: [PATCH] PCI: Device specific reset function
From: Alex Williamson <alex.williamson@redhat.com>
To: Tadeusz Struk <tadeusz.struk@intel.com>
Cc: bhelgaas@google.com, jbarnes@virtuousgeek.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-pci@vger.kernel.org
Date: Mon, 12 Mar 2012 20:42:35 -0600
In-Reply-To: <4f5e2a73.YyO0Gu2m5JhSVsu6%tadeusz.struk@intel.com>
References: <4f5e2a73.YyO0Gu2m5JhSVsu6%tadeusz.struk@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-03-12 at 16:55 +0000, Tadeusz Struk wrote:
> I have a use case where I need to cleanup resource allocated for Virtual
> Functions after a guest OS that used it crashed. This cleanup needs to
> be done before the VF is being FLRed. The only possible way to do this
> seems to be by using pci_dev_specific_reset() function.
> This patch adds specific reset function to the pci_driver struct.
> 
> Signed-off-by: Tadeusz Struk <tadeusz.struk@intel.com>
> ---
>  drivers/pci/quirks.c |    4 ++++
>  include/linux/pci.h  |    1 +
>  2 files changed, 5 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
> index 6476547..13d224b 100644
> --- a/drivers/pci/quirks.c
> +++ b/drivers/pci/quirks.c
> @@ -3081,8 +3081,12 @@ static const struct pci_dev_reset_methods pci_dev_reset_methods[] = {
>  
>  int pci_dev_specific_reset(struct pci_dev *dev, int probe)
>  {
> +	struct pci_driver *drv = dev->driver;
>  	const struct pci_dev_reset_methods *i;
>  
> +	if (drv && drv->reset)
> +		return drv->reset(dev, probe);
> +

Isn't this exactly what the below code is for (pci_dev_reset_methods)?
In the case of KVM device assignment, the device should be reset via
this path if the guest crashes, but it may or may not be attached to
pci-stub at the time.  I assume you're not adding a reset handler to
pci-stub, so we'll pass through here and use FLR, violating the premise
of the patch.  Thanks,

Alex

>  	for (i = pci_dev_reset_methods; i->reset; i++) {
>  		if ((i->vendor == dev->vendor ||
>  		     i->vendor == (u16)PCI_ANY_ID) &&
> diff --git a/include/linux/pci.h b/include/linux/pci.h
> index a16b1df..2ccd838 100644
> --- a/include/linux/pci.h
> +++ b/include/linux/pci.h
> @@ -560,6 +560,7 @@ struct pci_driver {
>  	int  (*resume_early) (struct pci_dev *dev);
>  	int  (*resume) (struct pci_dev *dev);	                /* Device woken up */
>  	void (*shutdown) (struct pci_dev *dev);
> +	int  (*reset) (struct pci_dev *dev, int probe);
>  	struct pci_error_handlers *err_handler;
>  	struct device_driver	driver;
>  	struct pci_dynids dynids;



