Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761542Ab2EJTXR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 15:23:17 -0400
Received: from ogre.sisk.pl ([193.178.161.156]:36756 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755627Ab2EJTXQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 15:23:16 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Huang Ying <ying.huang@intel.com>
Subject: Re: [RFC v2 5/5] PCIe, Add PCIe runtime D3cold support
Date: Thu, 10 May 2012 21:28:06 +0200
User-Agent: KMail/1.13.6 (Linux/3.4.0-rc6+; KDE/4.6.0; x86_64; ; )
Cc: huang ying <huang.ying.caritas@gmail.com>,
        Bjorn Helgaas <bhelgaas@google.com>, ming.m.lin@intel.com,
        linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        Zheng Yan <zheng.z.yan@intel.com>
References: <1336119221-21146-1-git-send-email-ying.huang@intel.com> <1336443743.6190.159.camel@yhuang-dev> <1336466097.6190.196.camel@yhuang-dev>
In-Reply-To: <1336466097.6190.196.camel@yhuang-dev>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201205102128.06914.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, May 08, 2012, Huang Ying wrote:
> On Tue, 2012-05-08 at 10:22 +0800, Huang Ying wrote:
> > On Mon, 2012-05-07 at 23:22 +0200, Rafael J. Wysocki wrote:
> > > On Saturday, May 05, 2012, huang ying wrote:
> [...]
> > > > >> --- a/drivers/pci/pci-acpi.c
> > > > >> +++ b/drivers/pci/pci-acpi.c
> > > > >> @@ -48,6 +48,21 @@ static void pci_acpi_wake_dev(acpi_handl
> > > > >>       if (event != ACPI_NOTIFY_DEVICE_WAKE || !pci_dev)
> > > > >>               return;
> > > > >>
> > > > >> +     if (pci_dev->current_state == PCI_D3cold) {
> > > > >> +             unsigned int count = 0;
> > > > >> +
> > > > >> +             /*
> > > > >> +              * Powering on bridge need to resume whole hierarchy,
> > > > >> +              * just resume the children to avoid the bridge going
> > > > >> +              * suspending as soon as resumed
> > > > >> +              */
> > > > >
> > > > > Don't you need to resume the bridge before you start walking the hierarchy
> > > > > below it?
> > > > 
> > > > When we resume the hierarchy below the bridge, its parent, the bridge,
> > > > will be resumed firstly. That is:
> > > > 
> > > > rpm_resume(child)
> > > >   rpm_resume(parent)
> > > >   ->runtime_suspend(child)
> > > > 
> > > > >> +             if (pci_dev->subordinate)
> > > > >> +                     count = pci_wakeup_bus(pci_dev->subordinate);
> > > > >> +             if (count == 0)
> > > > >> +                     pm_runtime_resume(&pci_dev->dev);
> > > > >
> > > > > What's the count for, exactly?
> > > > 
> > > > If there is no devices under the bridge, count returned will be 0,
> > > > then we will resume bridge itself.
> > > 
> > > So it looks like you will resume the bridge in both cases, right?
> > > 
> > > Why don't you call pm_runtime_get_sync() on the bridge first and then
> > > go for resuming the devices below it, then?
> > 
> > OK.  I will do that.
> 
> After some thinking, have some question on this method.
> 
> Do you suggest something like below?
> 
>     pm_runtime_get_sync(&pci_dev->dev);
>     pci_wakeup_bus(pci_dev->subordinate);
>     pm_runtime_put(&pci_dev->dev);
> 
> If so,  because pci_wakeup_bus() will call pm_request_resume() on
> subordinate devices, which is asynchronous, bridge may go suspended
> (powered off) again after pm_runtime_put(), if resuming of subordinate
> devices are still pending in work queue.

I don't think this is a big problem.  Worst case it will be resumed
again by the first resuming child, but I doubt we'll see much of that
in practice.

Alternatively, you can use pm_runtime_put_noidle() followed by
pm_runtime_schedule_suspend() with appropriate delay.

Thanks,
Rafael
