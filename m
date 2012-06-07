Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755811Ab2FGBDU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 21:03:20 -0400
Received: from mga01.intel.com ([192.55.52.88]:54246 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752217Ab2FGBDT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 21:03:19 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="175760013"
Message-ID: <1339030997.7404.18.camel@yhuang-dev>
Subject: Re: [PATCH -v4 2/2] PCIe: Add PCIe runtime D3cold support
From: Huang Ying <ying.huang@intel.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Bjorn Helgaas <bhelgaas@google.com>, ming.m.lin@intel.com,
        linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        Zheng Yan <zheng.z.yan@intel.com>
Date: Thu, 07 Jun 2012 09:03:17 +0800
In-Reply-To: <201206061552.47395.rjw@sisk.pl>
References: <1337305725-10482-1-git-send-email-ying.huang@intel.com>
	 <201206020110.28487.rjw@sisk.pl> <1338873853.6824.76.camel@yhuang-dev>
	 <201206061552.47395.rjw@sisk.pl>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2-1+b1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-06-06 at 15:52 +0200, Rafael J. Wysocki wrote:
> On Tuesday, June 05, 2012, Huang Ying wrote:
> > On Sat, 2012-06-02 at 01:10 +0200, Rafael J. Wysocki wrote:
> > > On Friday, June 01, 2012, Huang Ying wrote:
> > > > On Thu, 2012-05-31 at 21:01 +0200, Rafael J. Wysocki wrote:
> > > > > On Thursday, May 31, 2012, Huang Ying wrote:
> > > > > > On Wed, 2012-05-30 at 23:49 +0200, Rafael J. Wysocki wrote:
> > > > > > > On Tuesday, May 22, 2012, Rafael J. Wysocki wrote:
> > > > > > > > On Friday, May 18, 2012, Huang Ying wrote:
[snip] 
> > > > > Besides, this hunk of the $subject patch:
> > > > > 
> > > > > > @@ -731,8 +791,8 @@ int pci_set_power_state(struct pci_dev *
> > > > > >       int error;
> > > > > >  
> > > > > >       /* bound the state we're entering */
> > > > > > -     if (state > PCI_D3hot)
> > > > > > -             state = PCI_D3hot;
> > > > > > +     if (state > PCI_D3cold)
> > > > > > +             state = PCI_D3cold;
> > > > > >       else if (state < PCI_D0)
> > > > > >               state = PCI_D0;
> > > > > >       else if ((state == PCI_D1 || state == PCI_D2) && pci_no_d1d2(dev))
> > > > > > @@ -747,10 +807,15 @@ int pci_set_power_state(struct pci_dev *
> > > > > >  
> > > > > >       /* This device is quirked not to be put into D3, so
> > > > > >          don't put it in D3 */
> > > > > > -     if (state == PCI_D3hot && (dev->dev_flags & PCI_DEV_FLAGS_NO_D3))
> > > > > > +     if (state >= PCI_D3hot && (dev->dev_flags & PCI_DEV_FLAGS_NO_D3))
> > > > > >               return 0;
> > > > > >  
> > > > > > -     error = pci_raw_set_power_state(dev, state);
> > > > > > +     /*
> > > > > > +      * To put device in D3cold, we put device into D3hot in native
> > > > > > +      * way, then put device into D3cold with platform ops
> > > > > > +      */
> > > > > > +     error = pci_raw_set_power_state(dev, state > PCI_D3hot ?
> > > > > > +                                     PCI_D3hot : state);
> > > > > >  
> > > > > >       if (!__pci_complete_power_transition(dev, state))
> > > > > >               error = 0;
> > > > > 
> > > > > should be merged separately, because it will affect suspend/hibernation code
> > > > > paths.  Namely, it will change the behavior in such a way that some devices
> > > > > put into D3hot previously will be put into D3cold now during system suspend.
> > > > 
> > > > Yes.  This patch enables both runtime D3cold and D3cold during system
> > > > suspend.  How about separate this patch into the following patches?
> > > > 
> > > > - Add d3cold disable logic, including flags: no_d3cold, d3cold_allowed,
> > > > runtime_d3cold, and disable runtime d3cold (because part of runtime
> > > > d3cold support will be enabled by system d3cold support).
> > > > 
> > > > - system d3cold support for PCIe port
> > > > 
> > > > - system d3cold support in PCI core
> > > > 
> > > > - runtime d3cold support for PCIe port
> > > > 
> > > > - runtime d3cold support in PCI core
> > > 
> > > Sounds good in principle.
> > 
> > Thought it again.
> > 
> > If my understanding were correct, in most cases, The value to put
> > devices into D3cold during system suspend/hibernate may be questionable.
> > Because after Linux put the devices into lower power state,  the
> > firmware may put devices into D3cold state before entering system
> > suspend state.
> > 
> > So, I think maybe we can just constrain the target state to D3hot in
> > pci_set_power_state() if system suspend/hibernate is ongoing
> > (dev->runtime_d3cold is not set).  That is something as follow:
> > 
> > /* D3cold during system suspend/hibernate is not supported yet */
> > if (dev->runtime_d3cold && state >= PCI_D3cold)
> > 	state = PCI_D3cold;
> > else if (state > PCI_D3hot)
> > 	state = PCI_D3hot;
> > 
> > This way, we can just make some minor change to this patch and maybe
> > work on D3cold during system suspend/hibernate after some discussion.
> 
> I don't honestly think we should add such ugly checks to pci_set_power_state().
> 
> Why don't we ensure that acpi_pm_device_sleep_state() doesn't return 4
> (D3cold) if acpi_target_sleep_state is different from 0 instead?

We can add that into acpi_target_sleep_state.  But pci_set_power_sate()
is public API and used by many places already, do a quick search in
recent kernel source.

$ grep 'pci_set_power_state' -r . | grep -v PCI_D3hot | grep -v PCI_D0 | grep -v pci_choose_state | wc -l

yields:
55

$ grep 'pci_set_power_state' -r . | grep -v PCI_D3hot | grep -v PCI_D0 | grep -v pci_choose_state | grep -i d3cold

yields:
./drivers/misc/cb710/core.c:            pci_set_power_state(pdev, PCI_D3cold);
./arch/x86/pci/mrst.c:  pci_set_power_state(dev, PCI_D3cold);

Although we can check/fix them one by one.  We need to prevent future
pci_set_power_state to accept PCI_D3cold in some situation.

So I think we need to constrain the parameter of pci_set_power_state
anyway.  Maybe something like below in pci_set_power_state is better
than my previous one.

/* D3cold during system suspend/hibernate is not supported yet */
if (!dev->runtime_d3cold && state > PCI_D3hot)
	state = PCI_D3hot;

if (state > PCI_D3cold)
	state = PCI_D3cold;

Best Regards,
Huang Ying


