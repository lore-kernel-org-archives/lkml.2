Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751877Ab2H1RAX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2012 13:00:23 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:20516 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751274Ab2H1RAV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2012 13:00:21 -0400
Date: Tue, 28 Aug 2012 12:59:59 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Jiang Liu <liuj97@gmail.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>, Jiang Liu <jiang.liu@huawei.com>,
        Don Dutile <ddutile@redhat.com>, Yinghai Lu <yinghai@kernel.org>,
        Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
        Yijing Wang <wangyijing@huawei.com>, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org
Subject: Re: [PATCH 5/5] PCI/xen-pcifront: simplify code by hotplug safe
 pci_get_domain_bus_and_slot()
Message-ID: <20120828165959.GA23312@localhost.localdomain>
References: <1346168638-32724-1-git-send-email-jiang.liu@huawei.com>
 <1346168638-32724-6-git-send-email-jiang.liu@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1346168638-32724-6-git-send-email-jiang.liu@huawei.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 28, 2012 at 11:43:58PM +0800, Jiang Liu wrote:
> Following code has a race window between pci_find_bus() and pci_get_slot()
> if PCI hotplug operation happens between them which removes the pci_bus.
> So use PCI hotplug safe interface pci_get_domain_bus_and_slot() instead,
> which also reduces code complexity.

Has this happend in practice? Is this something one can reproduce
by manipulating SysFS and at the same time unplugging the PCI
devices?
> 
> struct pci_bus *pci_bus = pci_find_bus(domain, busno);
> struct pci_dev *pci_dev = pci_get_slot(pci_bus, devfn);
> 
> Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
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
> 
