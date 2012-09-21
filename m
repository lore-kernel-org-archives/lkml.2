Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756591Ab2IUA3B (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2012 20:29:01 -0400
Received: from mga11.intel.com ([192.55.52.93]:21567 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754692Ab2IUA27 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2012 20:28:59 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,457,1344236400"; 
   d="scan'208";a="224833535"
Message-ID: <1348187322.8212.224.camel@yhuang-dev>
Subject: Re: [RFC 1/3] PCI/PM: Fix kexec for D3cold and bridge suspending
From: Huang Ying <ying.huang@intel.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Bjorn Helgaas <bhelgaas@google.com>, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org, linux-pm@vger.kernel.org,
        Eric Biederman <ebiederm@xmission.com>, kexec@lists.infradead.org
Date: Fri, 21 Sep 2012 08:28:42 +0800
In-Reply-To: <201209202120.32029.rjw@sisk.pl>
References: <1347872076-5260-1-git-send-email-ying.huang@intel.com>
	 <1347872076-5260-2-git-send-email-ying.huang@intel.com>
	 <CAErSpo5fVbN2vD5Omc7dGJFWUccYZoCOVRF4YmXPe2Oxm81u5g@mail.gmail.com>
	 <201209202120.32029.rjw@sisk.pl>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-09-20 at 21:20 +0200, Rafael J. Wysocki wrote:
> On Monday, September 17, 2012, Bjorn Helgaas wrote:
> > +cc Eric and kexec list
> > 
> > On Mon, Sep 17, 2012 at 2:54 AM, Huang Ying <ying.huang@intel.com> wrote:
> > > If PCI devices are put into D3cold before kexec, because the
> > > configuration registers of PCI devices in D3cold are not accessible.
> > >
> > > And if PCI bridges are put into low power state before kexec,
> > > configuration registers of PCI devices underneath the PCI bridges are
> > > not accessible too.
> > >
> > > These will make some PCI devices can not be scanned after kexec, so
> > > resume the PCI devices in D3cold or PCI bridges in low power state
> > > before kexec.
> > 
> > Don't we need to resume the device even without the kexec issue?  And
> > even if it's in D1 or D2?
> > 
> > It looks to me like pci_msi_shutdown() (and probably drv->shutdown())
> > depend on the device being in D0.
> 
> We should in theory, but we didn't do any power management of PCI bridges
> before, so this is the first time we have a problem with it.
> 
> So I'd say, yeah, let's resume if current_state is between D1 and D3cold
> inclusive and the kexec comment is not very helpful (the problem is not
> kexec-specific in general).

Resume from D1 to D3cold for any device or just bridges?

Best Regards,
Huang Ying

> Speaking of kexec, it might consider using the hibernation device freeze
> instead of device shutdown (which the kexec jump feature does).  I've seen
> reports of problems that would be solved this way most likely.
> 
> Thanks,
> Rafael
> 
> 
> > > Signed-off-by: Huang Ying <ying.huang@intel.com>
> > > ---
> > >  drivers/pci/pci-driver.c |    4 ++++
> > >  1 file changed, 4 insertions(+)
> > >
> > > --- a/drivers/pci/pci-driver.c
> > > +++ b/drivers/pci/pci-driver.c
> > > @@ -421,6 +421,10 @@ static void pci_device_shutdown(struct d
> > >         struct pci_dev *pci_dev = to_pci_dev(dev);
> > >         struct pci_driver *drv = pci_dev->driver;
> > >
> > > +       /* Resume bridges and devices in D3cold for kexec to work properly */
> > > +       if (pci_dev->current_state == PCI_D3cold || pci_dev->subordinate)
> > > +               pm_runtime_resume(dev);
> > > +
> > >         if (drv && drv->shutdown)
> > >                 drv->shutdown(pci_dev);
> > >         pci_msi_shutdown(pci_dev);
> > 
> > 
> 


