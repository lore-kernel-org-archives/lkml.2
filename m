Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755505Ab1JMOaW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Oct 2011 10:30:22 -0400
Received: from smtp.ctxuk.citrix.com ([62.200.22.115]:41208 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751686Ab1JMOaV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Oct 2011 10:30:21 -0400
X-IronPort-AV: E=Sophos;i="4.69,340,1315180800"; 
   d="scan'208";a="8374498"
Date: Thu, 13 Oct 2011 15:30:22 +0100
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
In-Reply-To: <4E92DEC1.5050806@oracle.com>
Message-ID: <alpine.DEB.2.00.1110131525320.3519@kaball-desktop>
References: <4E8C40A8.6080205@oracle.com> <alpine.DEB.2.00.1110061137120.3519@kaball-desktop> <CAE9FiQVyT=n18JnuBmda86D77Ai4HAC=w68Oo-Na3mCdAxsCMw@mail.gmail.com> <alpine.DEB.2.00.1110061711290.3519@kaball-desktop> <4E92DEC1.5050806@oracle.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 10 Oct 2011, Ajaykumar Hotchandani wrote:
> On 10/06/2011 09:47 PM, Stefano Stabellini wrote:
> > On Thu, 6 Oct 2011, Yinghai Lu wrote:
> >> On Thu, Oct 6, 2011 at 3:39 AM, Stefano Stabellini
> >> <stefano.stabellini@eu.citrix.com>  wrote:
> >>> I had the same issue and sent a patch a while ago to fix it, adding
> >>>
> >>> current_state = PCI_D0 in acpiphp_glue.c:register_slot
> >>>
> >>> it is strange that this does not work for you:
> >>>
> >>> http://marc.info/?l=linux-kernel&m=129891002722845&w=2
> >> So guest os has to load acpiphp instead of pciehp?
> >
> > maybe pciehp needs to make sure that current_state = D0 in
> > pciehp_enable_slot, like acpiphp does
> Here, acpi hotplugging is involved.
> With your change in register_slot(), device will have proper power state when module is being loaded for the first time after booting.
> However, while unload of pci module; following is in pci_device_remove():
>          if (pci_dev->current_state == PCI_D0)
>                  pci_dev->current_state = PCI_UNKNOWN;
> 
> So, device power state state will remain PCI_UNKNOWN while module is loaded again. Subsequently, MSI write will do nothing.

Does this mean that this bug would actually trigger even with devices that
do support _EJ0 and power management?
Because acpi_pci_set_power_state won't set current_state to PCI_D0
because the "hotplug driver will take care of _PSx" (see
10b3dcae0f275e2546e55303d64ddbb58cec7599) but the hotplug driver is not
actually invoked when loading again a driver module of an existing pci
device (the example you mention above)?
