Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932506Ab2EGU4A (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2012 16:56:00 -0400
Received: from ogre.sisk.pl ([193.178.161.156]:57974 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932360Ab2EGUz7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2012 16:55:59 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: huang ying <huang.ying.caritas@gmail.com>
Subject: Re: [RFC v2 3/5] PCIe, Add runtime PM support to PCIe port
Date: Mon, 7 May 2012 23:00:46 +0200
User-Agent: KMail/1.13.6 (Linux/3.4.0-rc6+; KDE/4.6.0; x86_64; ; )
Cc: Huang Ying <ying.huang@intel.com>, Bjorn Helgaas <bhelgaas@google.com>,
        ming.m.lin@intel.com, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org, Zheng Yan <zheng.z.yan@intel.com>
References: <1336119221-21146-1-git-send-email-ying.huang@intel.com> <201205042143.54364.rjw@sisk.pl> <CAC=cRTMoSCoWYvVqhBb5_SD=+bJuQ86-eifDqZxtGYRW_Ok9eg@mail.gmail.com>
In-Reply-To: <CAC=cRTMoSCoWYvVqhBb5_SD=+bJuQ86-eifDqZxtGYRW_Ok9eg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201205072300.46939.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, May 05, 2012, huang ying wrote:
> On Sat, May 5, 2012 at 3:43 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > On Friday, May 04, 2012, Huang Ying wrote:
> >> From: Zheng Yan <zheng.z.yan@intel.com>
> >>
> >> This patch adds runtime PM support to PCIe port.  This is needed by
> >> PCIe D3cold support, where PCIe device in slot may be powered on/off
> >> by PCIe port.
> >>
> >> Because runtime suspend is broken for some chipset, a white list is
> >> used to enable runtime PM support for only chipset known to work.
> >>
> >> Signed-off-by: Zheng Yan <zheng.z.yan@intel.com>
> >> Signed-off-by: Huang Ying <ying.huang@intel.com>
> >> ---
> >>  drivers/pci/pci.c              |    9 +++++++++
> >>  drivers/pci/pcie/portdrv_pci.c |   40 ++++++++++++++++++++++++++++++++++++++++
> >>  2 files changed, 49 insertions(+)
> >>
> >> --- a/drivers/pci/pci.c
> >> +++ b/drivers/pci/pci.c
> >> @@ -1476,6 +1476,15 @@ bool pci_check_pme_status(struct pci_dev
> >>   */
> >>  static int pci_pme_wakeup(struct pci_dev *dev, void *pme_poll_reset)
> >>  {
> >> +     struct pci_dev *bridge = dev->bus->self;
> >> +
> >> +     /*
> >> +      * If bridge is in low power state, the configuration space of
> >> +      * subordinate devices may be not accessible
> >
> > Please also say in the comment _when_ this is possible.  That's far from
> > obvious, because the runtime PM framework generally ensures that parents are
> > resumed before the children, so the comment should describe the particular
> > scenario leading to this situation.
> 
> OK.  I will add something like below into comments.
> 
> This is possible when doing PME poll.

Well, that doesn't really explain much. :-)

I _think_ the situation is when a device causes WAKE# to be generated and
the platform receives a GPE as a result and we get an ACPI_NOTIFY_DEVICE_WAKE
notification for the device, which may be under a bridge (PCIe port really)
in D3_cold.  Is that the case?

> >> +      */
> >> +     if (bridge && bridge->current_state != PCI_D0)
> >> +             return 0;
> >> +
> >>       if (pme_poll_reset && dev->pme_poll)
> >>               dev->pme_poll = false;
> >>
> >> --- a/drivers/pci/pcie/portdrv_pci.c
> >> +++ b/drivers/pci/pcie/portdrv_pci.c
> >> @@ -11,6 +11,7 @@
> >>  #include <linux/kernel.h>
> >>  #include <linux/errno.h>
> >>  #include <linux/pm.h>
> >> +#include <linux/pm_runtime.h>
> >>  #include <linux/init.h>
> >>  #include <linux/pcieport_if.h>
> >>  #include <linux/aer.h>
> >> @@ -99,6 +100,27 @@ static int pcie_port_resume_noirq(struct
> >>       return 0;
> >>  }
> >>
> >> +#ifdef CONFIG_PM_RUNTIME
> >> +static int pcie_port_runtime_suspend(struct device *dev)
> >> +{
> >> +     struct pci_dev *pdev = to_pci_dev(dev);
> >> +
> >
> > A comment explaining why this is needed here would be welcome.
> 
> Sorry, do not catch your idea exactly.  What is needed?  Why do we
> need to add PCIe port runtime suspend support?

No, why we need to call pci_save_state() from here and pci_restore_state()
from the corresponding resume routine.

In theory that shouldn't be necessary, because the PCI bus type's
runtime suspend/resume routines do the save/restore of the PCI config space.

Thanks,
Rafael
