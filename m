Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753444Ab1J0NOV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Oct 2011 09:14:21 -0400
Received: from smtp.eu.citrix.com ([62.200.22.115]:8392 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753301Ab1J0NOS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Oct 2011 09:14:18 -0400
X-IronPort-AV: E=Sophos;i="4.69,413,1315180800"; 
   d="scan'208";a="8620433"
Date: Thu, 27 Oct 2011 14:14:34 +0100
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball-desktop
To: Ajaykumar Hotchandani <ajaykumar.hotchandani@oracle.com>
CC: Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        Yinghai Lu <yhlu.kernel@gmail.com>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] PCI: Set device power state to PCI_D0 for device without
 native PM support
In-Reply-To: <4E9D8495.4010105@oracle.com>
Message-ID: <alpine.DEB.2.00.1110271411450.3519@kaball-desktop>
References: <4E8C40A8.6080205@oracle.com> <alpine.DEB.2.00.1110061137120.3519@kaball-desktop> <CAE9FiQVyT=n18JnuBmda86D77Ai4HAC=w68Oo-Na3mCdAxsCMw@mail.gmail.com> <alpine.DEB.2.00.1110061711290.3519@kaball-desktop> <4E92DEC1.5050806@oracle.com>
 <alpine.DEB.2.00.1110131525320.3519@kaball-desktop> <4E9D8495.4010105@oracle.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 18 Oct 2011, Ajaykumar Hotchandani wrote:
> On 10/13/2011 08:00 PM, Stefano Stabellini wrote:
> > On Mon, 10 Oct 2011, Ajaykumar Hotchandani wrote:
> >> On 10/06/2011 09:47 PM, Stefano Stabellini wrote:
> >>> On Thu, 6 Oct 2011, Yinghai Lu wrote:
> >>>> On Thu, Oct 6, 2011 at 3:39 AM, Stefano Stabellini
> >>>> <stefano.stabellini@eu.citrix.com>   wrote:
> >>>>> I had the same issue and sent a patch a while ago to fix it, adding
> >>>>>
> >>>>> current_state = PCI_D0 in acpiphp_glue.c:register_slot
> >>>>>
> >>>>> it is strange that this does not work for you:
> >>>>>
> >>>>> http://marc.info/?l=linux-kernel&m=129891002722845&w=2
> >>>> So guest os has to load acpiphp instead of pciehp?
> >>> maybe pciehp needs to make sure that current_state = D0 in
> >>> pciehp_enable_slot, like acpiphp does
> >> Here, acpi hotplugging is involved.
> >> With your change in register_slot(), device will have proper power state when module is being loaded for the first time after booting.
> >> However, while unload of pci module; following is in pci_device_remove():
> >>           if (pci_dev->current_state == PCI_D0)
> >>                   pci_dev->current_state = PCI_UNKNOWN;
> >>
> >> So, device power state state will remain PCI_UNKNOWN while module is loaded again. Subsequently, MSI write will do nothing.
> > Does this mean that this bug would actually trigger even with devices that
> > do support _EJ0 and power management?
> Nope. I don't have system to verify. But, for the scenario you mentioned 
> (device is hot pluggable, acpi bus power manageable and device with 
> pm_cap supported; if I understand it correctly), following is what I 
> think should happen:
> - Inside pci_platform_power_transition(), 
> platform_pci_power_manageable() will be successful. However, 
> platform_pci_set_power_state() will fail (as device supports EJ0) and 
> subsequently pci_update_current_state() will not get called.
> - So, current power state of device will not be read and power state of 
> device will remain PCI_UNKNOWN.
> - Now, pci_raw_set_power_state() will get called. Here, as current power 
> state is PCI_UNKNOWN, pci_write_config_word() will be called with pmcsr 
> value as 0. As, last two bits of pmcsr is 0, written power state of 
> device will be PCI_D0 now. And subsequently, dev->current_state will be 
> assigned as PCI_D0 (by using pci_read_config_word() ).

OK, I understand.


> > Because acpi_pci_set_power_state won't set current_state to PCI_D0
> > because the "hotplug driver will take care of _PSx" (see
> > 10b3dcae0f275e2546e55303d64ddbb58cec7599) but the hotplug driver is not
> > actually invoked when loading again a driver module of an existing pci
> > device (the example you mention above)?
> Can you please elaborate more on this?
> acpi_bus_set_power() will update state of acpi_dev (ACPI_STATE_XX) and 
> not pci_dev (PCI_XX).
> And here, issue lies with current_state of pci_dev.

I agree, I was merely stating again what the problem is.

BTW I am OK with your patch.
