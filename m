Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966578Ab2EPDCK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 23:02:10 -0400
Received: from mga14.intel.com ([143.182.124.37]:60018 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966317Ab2EPDCI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 23:02:08 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="143702707"
Message-ID: <1337137312.6493.3.camel@yhuang-dev>
Subject: Re: [PATCH -v3 1/2] PCIe: Add runtime PM support to PCIe port
From: Huang Ying <ying.huang@intel.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Bjorn Helgaas <bhelgaas@google.com>, ming.m.lin@intel.com,
        linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        Zheng Yan <zheng.z.yan@intel.com>
Date: Wed, 16 May 2012 11:01:52 +0800
In-Reply-To: <201205152053.44885.rjw@sisk.pl>
References: <1337065211-19525-1-git-send-email-ying.huang@intel.com>
	 <1337065211-19525-2-git-send-email-ying.huang@intel.com>
	 <201205152053.44885.rjw@sisk.pl>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2-1+b1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-05-15 at 20:53 +0200, Rafael J. Wysocki wrote:
> On Tuesday, May 15, 2012, Huang Ying wrote:
> > From: "Yan, Zheng" <zheng.z.yan@intel.com>
> > 
> > This patch adds runtime PM support to PCIe port.  This is needed by
> > PCIe D3cold support, where PCIe device without ACPI node may be
> > powered on/off by PCIe port.
> > 
> > Because runtime suspend is broken for some chipsets, a black list is
> > used to disable runtime PM support for these chipsets.
> > 
> > Signed-off-by: Zheng Yan <zheng.z.yan@intel.com>
> > ---
> >  drivers/pci/pci.c              |   10 ++++++++++
> >  drivers/pci/pcie/portdrv_pci.c |   30 ++++++++++++++++++++++++++++++
> >  2 files changed, 40 insertions(+)
> > 
> > --- a/drivers/pci/pci.c
> > +++ b/drivers/pci/pci.c
> > @@ -1517,6 +1517,16 @@ static void pci_pme_list_scan(struct wor
> >  	if (!list_empty(&pci_pme_list)) {
> >  		list_for_each_entry_safe(pme_dev, n, &pci_pme_list, list) {
> >  			if (pme_dev->dev->pme_poll) {
> > +				struct pci_dev *bridge;
> > +
> > +				bridge = pme_dev->dev->bus->self;
> > +				/*
> > +				 * If bridge is in low power state, the
> > +				 * configuration space of subordinate devices
> > +				 * may be not accessible
> > +				 */
> > +				if (bridge && bridge->current_state != PCI_D0)
> > +					continue;
> >  				pci_pme_wakeup(pme_dev->dev, NULL);
> >  			} else {
> >  				list_del(&pme_dev->list);
> > --- a/drivers/pci/pcie/portdrv_pci.c
> > +++ b/drivers/pci/pcie/portdrv_pci.c
> > @@ -11,6 +11,7 @@
> >  #include <linux/kernel.h>
> >  #include <linux/errno.h>
> >  #include <linux/pm.h>
> > +#include <linux/pm_runtime.h>
> >  #include <linux/init.h>
> >  #include <linux/pcieport_if.h>
> >  #include <linux/aer.h>
> > @@ -99,6 +100,21 @@ static int pcie_port_resume_noirq(struct
> >  	return 0;
> >  }
> >  
> > +#ifdef CONFIG_PM_RUNTIME
> > +static int pcie_port_runtime_suspend(struct device *dev)
> > +{
> > +	return 0;
> > +}
> > +
> > +static int pcie_port_runtime_resume(struct device *dev)
> > +{
> > +	return 0;
> > +}
> 
> Do we need those empty definitions?  If so, it might be just one
> function.

Yes.  The empty definition is necessary.  I will use just one function
here.

Best Regards,
Huang Ying


