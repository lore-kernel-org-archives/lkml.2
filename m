Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756496Ab2EKH5y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2012 03:57:54 -0400
Received: from mga14.intel.com ([143.182.124.37]:44825 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751473Ab2EKH5w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2012 03:57:52 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="141784357"
Message-ID: <1336723068.6487.8.camel@yhuang-dev>
Subject: Re: [RFC v2 3/5] PCIe, Add runtime PM support to PCIe port
From: Huang Ying <ying.huang@intel.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: huang ying <huang.ying.caritas@gmail.com>,
        Bjorn Helgaas <bhelgaas@google.com>, ming.m.lin@intel.com,
        linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        Zheng Yan <zheng.z.yan@intel.com>
Date: Fri, 11 May 2012 15:57:48 +0800
In-Reply-To: <201205072300.46939.rjw@sisk.pl>
References: <1336119221-21146-1-git-send-email-ying.huang@intel.com>
	 <201205042143.54364.rjw@sisk.pl>
	 <CAC=cRTMoSCoWYvVqhBb5_SD=+bJuQ86-eifDqZxtGYRW_Ok9eg@mail.gmail.com>
	 <201205072300.46939.rjw@sisk.pl>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-05-07 at 23:00 +0200, Rafael J. Wysocki wrote:
> On Saturday, May 05, 2012, huang ying wrote:
> > On Sat, May 5, 2012 at 3:43 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > > On Friday, May 04, 2012, Huang Ying wrote:
> > >> From: Zheng Yan <zheng.z.yan@intel.com>
> > >>
> > >> This patch adds runtime PM support to PCIe port.  This is needed by
> > >> PCIe D3cold support, where PCIe device in slot may be powered on/off
> > >> by PCIe port.
> > >>
> > >> Because runtime suspend is broken for some chipset, a white list is
> > >> used to enable runtime PM support for only chipset known to work.
> > >>
> > >> Signed-off-by: Zheng Yan <zheng.z.yan@intel.com>
> > >> Signed-off-by: Huang Ying <ying.huang@intel.com>
> > >> ---
> > >>  drivers/pci/pci.c              |    9 +++++++++
> > >>  drivers/pci/pcie/portdrv_pci.c |   40 ++++++++++++++++++++++++++++++++++++++++
> > >>  2 files changed, 49 insertions(+)
> > >>
> > >> --- a/drivers/pci/pci.c
> > >> +++ b/drivers/pci/pci.c
> > >> @@ -1476,6 +1476,15 @@ bool pci_check_pme_status(struct pci_dev
> > >>   */
> > >>  static int pci_pme_wakeup(struct pci_dev *dev, void *pme_poll_reset)
> > >>  {
> > >> +     struct pci_dev *bridge = dev->bus->self;
> > >> +
> > >> +     /*
> > >> +      * If bridge is in low power state, the configuration space of
> > >> +      * subordinate devices may be not accessible
> > >
> > > Please also say in the comment _when_ this is possible.  That's far from
> > > obvious, because the runtime PM framework generally ensures that parents are
> > > resumed before the children, so the comment should describe the particular
> > > scenario leading to this situation.
> > 
> > OK.  I will add something like below into comments.
> > 
> > This is possible when doing PME poll.
> 
> Well, that doesn't really explain much. :-)
> 
> I _think_ the situation is when a device causes WAKE# to be generated and
> the platform receives a GPE as a result and we get an ACPI_NOTIFY_DEVICE_WAKE
> notification for the device, which may be under a bridge (PCIe port really)
> in D3_cold.  Is that the case?

That is not the case now.  Because we do not use pci_pme_wakeup_bus() in
ACPI handler now.

But for PME poll, if some subordinate devices under a bridge is put in
low power state, we still need to access configuration space of
subordinate devices to poll PME status even when bridge is in low power
state.  That may not work.

> > >> +      */
> > >> +     if (bridge && bridge->current_state != PCI_D0)
> > >> +             return 0;
> > >> +
> > >>       if (pme_poll_reset && dev->pme_poll)
> > >>               dev->pme_poll = false;
> > >>
> > >> --- a/drivers/pci/pcie/portdrv_pci.c
> > >> +++ b/drivers/pci/pcie/portdrv_pci.c
> > >> @@ -11,6 +11,7 @@
> > >>  #include <linux/kernel.h>
> > >>  #include <linux/errno.h>
> > >>  #include <linux/pm.h>
> > >> +#include <linux/pm_runtime.h>
> > >>  #include <linux/init.h>
> > >>  #include <linux/pcieport_if.h>
> > >>  #include <linux/aer.h>
> > >> @@ -99,6 +100,27 @@ static int pcie_port_resume_noirq(struct
> > >>       return 0;
> > >>  }
> > >>
> > >> +#ifdef CONFIG_PM_RUNTIME
> > >> +static int pcie_port_runtime_suspend(struct device *dev)
> > >> +{
> > >> +     struct pci_dev *pdev = to_pci_dev(dev);
> > >> +
> > >
> > > A comment explaining why this is needed here would be welcome.
> > 
> > Sorry, do not catch your idea exactly.  What is needed?  Why do we
> > need to add PCIe port runtime suspend support?
> 
> No, why we need to call pci_save_state() from here and pci_restore_state()
> from the corresponding resume routine.
> 
> In theory that shouldn't be necessary, because the PCI bus type's
> runtime suspend/resume routines do the save/restore of the PCI config space.

I found maybe we do not need this special processing, will test more.

Best Regards,
Huang Ying


