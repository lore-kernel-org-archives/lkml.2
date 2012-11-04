Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752758Ab2KDDqI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Nov 2012 23:46:08 -0400
Received: from mga09.intel.com ([134.134.136.24]:58078 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751185Ab2KDDqF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Nov 2012 23:46:05 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,707,1344236400"; 
   d="scan'208";a="214912429"
Message-ID: <1352000649.9881.5.camel@yhuang-mobile.sh.intel.com>
Subject: Re: [BUGFIX 2/2] PCI/PM: Resume device before shutdown
From: Huang Ying <ying.huang@intel.com>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-pm@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>
Date: Sun, 04 Nov 2012 11:44:09 +0800
In-Reply-To: <CAErSpo7=6kCG=P-u_MOACD+HVV8cj1JLO-beZYr6tn9bOzfrBg@mail.gmail.com>
References: <1351061654-8339-1-git-send-email-ying.huang@intel.com>
	 <1351061654-8339-2-git-send-email-ying.huang@intel.com>
	 <CAErSpo5bKDrfOC86Cxv+0yFiyj1bMgWF=6XuY+DWFjaMBTQC0A@mail.gmail.com>
	 <1351919112.13106.1.camel@yhuang-mobile.sh.intel.com>
	 <CAErSpo7=6kCG=P-u_MOACD+HVV8cj1JLO-beZYr6tn9bOzfrBg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2012-11-03 at 11:21 -0600, Bjorn Helgaas wrote:
> On Fri, Nov 2, 2012 at 11:05 PM, Huang Ying <ying.huang@intel.com> wrote:
> > On Fri, 2012-11-02 at 10:52 -0600, Bjorn Helgaas wrote:
> >> On Wed, Oct 24, 2012 at 12:54 AM, Huang Ying <ying.huang@intel.com> wrote:
> >> > Some actions during shutdown need device to be in D0 state, such as
> >> > MSI shutdown etc, so resume device before shutdown.
> >>
> >> Is there a problem report or bugzilla for this issue?  What are the
> >> symptoms by which a user could figure out that he needs this fix?
> >
> > No bugzilla for this issue.  This issue will cause the corresponding
> > device lost in kexeced kernel.
> 
> So would the following be accurate changelog text?
> 
>     Without this patch, a device may not work correctly after a kexec
>     because the new kernel expects devices to be in D0.

The issue I encountered is

	Without this patch, a device may not be enumerated after a kexec
	because the corresponding bridge is not in D0, so that
	configuration space of the device is not accessible.

> >> Should this be put in the stable tree as well?  If so, for v3.6 only?
> 
> What about the stable tree?

Yes.  This patch should be for v3.6 stable tree only.

Best Regards,
Huang Ying

> >> > Signed-off-by: Huang Ying <ying.huang@intel.com>
> >> > ---
> >> >  drivers/pci/pci-driver.c |   12 ++----------
> >> >  1 file changed, 2 insertions(+), 10 deletions(-)
> >> >
> >> > --- a/drivers/pci/pci-driver.c
> >> > +++ b/drivers/pci/pci-driver.c
> >> > @@ -398,6 +398,8 @@ static void pci_device_shutdown(struct d
> >> >         struct pci_dev *pci_dev = to_pci_dev(dev);
> >> >         struct pci_driver *drv = pci_dev->driver;
> >> >
> >> > +       pm_runtime_resume(dev);
> >> > +
> >> >         if (drv && drv->shutdown)
> >> >                 drv->shutdown(pci_dev);
> >> >         pci_msi_shutdown(pci_dev);
> >> > @@ -408,16 +410,6 @@ static void pci_device_shutdown(struct d
> >> >          * continue to do DMA
> >> >          */
> >> >         pci_disable_device(pci_dev);
> >> > -
> >> > -       /*
> >> > -        * Devices may be enabled to wake up by runtime PM, but they need not
> >> > -        * be supposed to wake up the system from its "power off" state (e.g.
> >> > -        * ACPI S5).  Therefore disable wakeup for all devices that aren't
> >> > -        * supposed to wake up the system at this point.  The state argument
> >> > -        * will be ignored by pci_enable_wake().
> >> > -        */
> >> > -       if (!device_may_wakeup(dev))
> >> > -               pci_enable_wake(pci_dev, PCI_UNKNOWN, false);
> >> >  }
> >> >
> >> >  #ifdef CONFIG_PM
> >
> >


