Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754424Ab2IEQjw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 12:39:52 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:19586 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750841Ab2IEQju (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 12:39:50 -0400
Date: Wed, 5 Sep 2012 12:29:04 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Jiang Liu <liuj97@gmail.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>, Jiang Liu <jiang.liu@huawei.com>,
        Don Dutile <ddutile@redhat.com>, Yinghai Lu <yinghai@kernel.org>,
        Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
        Yijing Wang <wangyijing@huawei.com>, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org
Subject: Re: [PATCH 5/5] PCI/xen-pcifront: simplify code by hotplug safe
 pci_get_domain_bus_and_slot()
Message-ID: <20120905162904.GA12653@phenom.dumpdata.com>
References: <1346168638-32724-1-git-send-email-jiang.liu@huawei.com>
 <1346168638-32724-6-git-send-email-jiang.liu@huawei.com>
 <20120828165959.GA23312@localhost.localdomain>
 <503D5ABB.6010605@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <503D5ABB.6010605@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 29, 2012 at 07:56:43AM +0800, Jiang Liu wrote:
> On 08/29/2012 12:59 AM, Konrad Rzeszutek Wilk wrote:
> > On Tue, Aug 28, 2012 at 11:43:58PM +0800, Jiang Liu wrote:
> >> Following code has a race window between pci_find_bus() and pci_get_slot()
> >> if PCI hotplug operation happens between them which removes the pci_bus.
> >> So use PCI hotplug safe interface pci_get_domain_bus_and_slot() instead,
> >> which also reduces code complexity.
> > 
> > Has this happend in practice? Is this something one can reproduce
> > by manipulating SysFS and at the same time unplugging the PCI
> > devices?
> Hi Konrad,
> 	We just noticed this issue by code inspection when improving PCI
> hotplug implementation. I guess we could trigger such issue by adding
> some delay between pci_find_bus() and pci_get_slot().
> 	Regards!

OK. Let me test it out.
> 	Gerry
> 
> >>
> >> struct pci_bus *pci_bus = pci_find_bus(domain, busno);
> >> struct pci_dev *pci_dev = pci_get_slot(pci_bus, devfn);
> >>
> >> Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
> >> ---
> >>  drivers/pci/xen-pcifront.c |   10 ++--------
> >>  1 file changed, 2 insertions(+), 8 deletions(-)
> >>
> >> diff --git a/drivers/pci/xen-pcifront.c b/drivers/pci/xen-pcifront.c
> >> index d6cc62c..def8d0b 100644
> >> --- a/drivers/pci/xen-pcifront.c
> >> +++ b/drivers/pci/xen-pcifront.c
> >> @@ -982,7 +982,6 @@ static int pcifront_detach_devices(struct pcifront_device *pdev)
> >>  	int err = 0;
> >>  	int i, num_devs;
> >>  	unsigned int domain, bus, slot, func;
> >> -	struct pci_bus *pci_bus;
> >>  	struct pci_dev *pci_dev;
> >>  	char str[64];
> >>  
> >> @@ -1032,13 +1031,8 @@ static int pcifront_detach_devices(struct pcifront_device *pdev)
> >>  			goto out;
> >>  		}
> >>  
> >> -		pci_bus = pci_find_bus(domain, bus);
> >> -		if (!pci_bus) {
> >> -			dev_dbg(&pdev->xdev->dev, "Cannot get bus %04x:%02x\n",
> >> -				domain, bus);
> >> -			continue;
> >> -		}
> >> -		pci_dev = pci_get_slot(pci_bus, PCI_DEVFN(slot, func));
> >> +		pci_dev = pci_get_domain_bus_and_slot(domain, bus,
> >> +				PCI_DEVFN(slot, func));
> >>  		if (!pci_dev) {
> >>  			dev_dbg(&pdev->xdev->dev,
> >>  				"Cannot get PCI device %04x:%02x:%02x.%d\n",
> >> -- 
> >> 1.7.9.5
> >>
