Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760886Ab2EITpx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 15:45:53 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:56864 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756718Ab2EITpv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 15:45:51 -0400
MIME-Version: 1.0
In-Reply-To: <4FAAC652.4060502@tilera.com>
References: <1336422606-4244-1-git-send-email-yinghai@kernel.org>
	<1336422606-4244-20-git-send-email-yinghai@kernel.org>
	<4FAAC652.4060502@tilera.com>
Date: Wed, 9 May 2012 12:45:50 -0700
X-Google-Sender-Auth: pucW-TPlssew2IRCj2TtymwZaBM
Message-ID: <CAE9FiQXLriREi1m==3-yXrQja3Qi+HNfnvvq_0Sr7Rpiu_JKTg@mail.gmail.com>
Subject: Re: [PATCH 19/21] tile/PCI: Use pci_scan_root_bus instead pci_scan_bus
From: Yinghai Lu <yinghai@kernel.org>
To: Chris Metcalf <cmetcalf@tilera.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Tony Luck <tony.luck@intel.com>, David Miller <davem@davemloft.net>,
        x86 <x86@kernel.org>, Dominik Brodowski <linux@dominikbrodowski.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 9, 2012 at 12:32 PM, Chris Metcalf <cmetcalf@tilera.com> wrote:
> On 5/7/2012 4:30 PM, Yinghai Lu wrote:
>> It will update busn_res accordingly, so we get that for last_busno.
>>
>> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
>> Cc: Chris Metcalf <cmetcalf@tilera.com>
>> ---
>>  arch/tile/kernel/pci.c |    5 ++++-
>>  1 files changed, 4 insertions(+), 1 deletions(-)
>>
>> diff --git a/arch/tile/kernel/pci.c b/arch/tile/kernel/pci.c
>> index 7aa2743..4a951b87 100644
>> --- a/arch/tile/kernel/pci.c
>> +++ b/arch/tile/kernel/pci.c
>> @@ -310,6 +310,7 @@ int __devinit pcibios_init(void)
>>               if (pci_scan_flags[i] == 0 && controllers[i].ops != NULL) {
>>                       struct pci_controller *controller = &controllers[i];
>>                       struct pci_bus *bus;
>> +                     LIST_HEAD(resources);
>>
>>                       if (tile_init_irqs(i, controller)) {
>>                               pr_err("PCI: Could not initialize IRQs\n");
>> @@ -327,7 +328,9 @@ int __devinit pcibios_init(void)
>>                        * This is inlined in linux/pci.h and calls into
>>                        * pci_scan_bus_parented() in probe.c.
>>                        */
>> -                     bus = pci_scan_bus(0, controller->ops, controller);
>> +                     pci_add_resource(&resources, &ioport_resource);
>> +                     pci_add_resource(&resources, &iomem_resource);
>> +                     bus = pci_scan_root_bus(NULL, 0, controller->ops, controller, &resources);
>>                       controller->root_bus = bus;
>>                       controller->last_busno = bus->busn_res.end;
>>               }
>
> We don't want ioport_resource on tilepro, since we don't support accessing
> I/O port space.
>
> With that one line removed:
>
> Acked-by: Chris Metcalf <cmetcalf@tilera.com>

Thanks.

>
> Or, I can queue this change to take through the tile tree when the merge
> window opens.  Which would you prefer?

have to go through pci-next tree. because other change like

 controller->last_busno = bus->busn_res.end;

is in pci-next.

Yinghai
