Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751800Ab2EHIfC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2012 04:35:02 -0400
Received: from mga03.intel.com ([143.182.124.21]:55887 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751266Ab2EHIfA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2012 04:35:00 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="140227695"
Message-ID: <1336466097.6190.196.camel@yhuang-dev>
Subject: Re: [RFC v2 5/5] PCIe, Add PCIe runtime D3cold support
From: Huang Ying <ying.huang@intel.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: huang ying <huang.ying.caritas@gmail.com>,
        Bjorn Helgaas <bhelgaas@google.com>, ming.m.lin@intel.com,
        linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        Zheng Yan <zheng.z.yan@intel.com>
Date: Tue, 08 May 2012 08:34:57 +0000
In-Reply-To: <1336443743.6190.159.camel@yhuang-dev>
References: <1336119221-21146-1-git-send-email-ying.huang@intel.com>
	 <201205042250.39519.rjw@sisk.pl>
	 <CAC=cRTP3ZOy1BkvtEZgZ4wfTzaMB8fdZhU_6VOKRwVQ8WLLxJg@mail.gmail.com>
	 <201205072322.51322.rjw@sisk.pl> <1336443743.6190.159.camel@yhuang-dev>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-05-08 at 10:22 +0800, Huang Ying wrote:
> On Mon, 2012-05-07 at 23:22 +0200, Rafael J. Wysocki wrote:
> > On Saturday, May 05, 2012, huang ying wrote:
[...]
> > > >> --- a/drivers/pci/pci-acpi.c
> > > >> +++ b/drivers/pci/pci-acpi.c
> > > >> @@ -48,6 +48,21 @@ static void pci_acpi_wake_dev(acpi_handl
> > > >>       if (event != ACPI_NOTIFY_DEVICE_WAKE || !pci_dev)
> > > >>               return;
> > > >>
> > > >> +     if (pci_dev->current_state == PCI_D3cold) {
> > > >> +             unsigned int count = 0;
> > > >> +
> > > >> +             /*
> > > >> +              * Powering on bridge need to resume whole hierarchy,
> > > >> +              * just resume the children to avoid the bridge going
> > > >> +              * suspending as soon as resumed
> > > >> +              */
> > > >
> > > > Don't you need to resume the bridge before you start walking the hierarchy
> > > > below it?
> > > 
> > > When we resume the hierarchy below the bridge, its parent, the bridge,
> > > will be resumed firstly. That is:
> > > 
> > > rpm_resume(child)
> > >   rpm_resume(parent)
> > >   ->runtime_suspend(child)
> > > 
> > > >> +             if (pci_dev->subordinate)
> > > >> +                     count = pci_wakeup_bus(pci_dev->subordinate);
> > > >> +             if (count == 0)
> > > >> +                     pm_runtime_resume(&pci_dev->dev);
> > > >
> > > > What's the count for, exactly?
> > > 
> > > If there is no devices under the bridge, count returned will be 0,
> > > then we will resume bridge itself.
> > 
> > So it looks like you will resume the bridge in both cases, right?
> > 
> > Why don't you call pm_runtime_get_sync() on the bridge first and then
> > go for resuming the devices below it, then?
> 
> OK.  I will do that.

After some thinking, have some question on this method.

Do you suggest something like below?

    pm_runtime_get_sync(&pci_dev->dev);
    pci_wakeup_bus(pci_dev->subordinate);
    pm_runtime_put(&pci_dev->dev);

If so,  because pci_wakeup_bus() will call pm_request_resume() on
subordinate devices, which is asynchronous, bridge may go suspended
(powered off) again after pm_runtime_put(), if resuming of subordinate
devices are still pending in work queue.


If we replace pm_runtime_put() with pm_runtime_put_noidle() as follow,

    pm_runtime_get_sync(&pci_dev->dev);
    pci_wakeup_bus(pci_dev->subordinate);
    pm_runtime_put_noidle(&pci_dev->dev);

if before pm_runtime_put_noidle(), subordinate devices have already go
through resuming/suspending cycle and go suspended again (because of
preemption?), bridge may lose an opportunity to go suspended.

Or we can add a parameter to pci_wakeup_bus() which will resume the
first device synchronously?

Best Regards,
Huang Ying


