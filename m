Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754938Ab2IEUnF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 16:43:05 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:36921 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752684Ab2IEUnC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 16:43:02 -0400
Date: Wed, 5 Sep 2012 16:32:17 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Jiang Liu <liuj97@gmail.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>, Jiang Liu <jiang.liu@huawei.com>,
        Don Dutile <ddutile@redhat.com>, Yinghai Lu <yinghai@kernel.org>,
        Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
        Yijing Wang <wangyijing@huawei.com>, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org
Subject: Re: [PATCH 5/5] PCI/xen-pcifront: simplify code by hotplug safe
 pci_get_domain_bus_and_slot()
Message-ID: <20120905203217.GA28018@phenom.dumpdata.com>
References: <1346168638-32724-1-git-send-email-jiang.liu@huawei.com>
 <1346168638-32724-6-git-send-email-jiang.liu@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1346168638-32724-6-git-send-email-jiang.liu@huawei.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 28, 2012 at 11:43:58PM +0800, Jiang Liu wrote:
> Following code has a race window between pci_find_bus() and pci_get_slot()
> if PCI hotplug operation happens between them which removes the pci_bus.
> So use PCI hotplug safe interface pci_get_domain_bus_and_slot() instead,
> which also reduces code complexity.
> 
> struct pci_bus *pci_bus = pci_find_bus(domain, busno);
> struct pci_dev *pci_dev = pci_get_slot(pci_bus, devfn);
> 
> Signed-off-by: Jiang Liu <jiang.liu@huawei.com>

So:

Acked-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Tested-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>

> ---
>  drivers/pci/xen-pcifront.c |   10 ++--------
>  1 file changed, 2 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/pci/xen-pcifront.c b/drivers/pci/xen-pcifront.c
> index d6cc62c..def8d0b 100644
> --- a/drivers/pci/xen-pcifront.c
> +++ b/drivers/pci/xen-pcifront.c
> @@ -982,7 +982,6 @@ static int pcifront_detach_devices(struct pcifront_device *pdev)
>  	int err = 0;
>  	int i, num_devs;
>  	unsigned int domain, bus, slot, func;
> -	struct pci_bus *pci_bus;
>  	struct pci_dev *pci_dev;
>  	char str[64];
>  
> @@ -1032,13 +1031,8 @@ static int pcifront_detach_devices(struct pcifront_device *pdev)
>  			goto out;
>  		}
>  
> -		pci_bus = pci_find_bus(domain, bus);
> -		if (!pci_bus) {
> -			dev_dbg(&pdev->xdev->dev, "Cannot get bus %04x:%02x\n",
> -				domain, bus);
> -			continue;
> -		}
> -		pci_dev = pci_get_slot(pci_bus, PCI_DEVFN(slot, func));
> +		pci_dev = pci_get_domain_bus_and_slot(domain, bus,
> +				PCI_DEVFN(slot, func));
>  		if (!pci_dev) {
>  			dev_dbg(&pdev->xdev->dev,
>  				"Cannot get PCI device %04x:%02x:%02x.%d\n",
> -- 
> 1.7.9.5
