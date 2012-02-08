Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756230Ab2BHEsp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Feb 2012 23:48:45 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:49025 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756083Ab2BHEsh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Feb 2012 23:48:37 -0500
MIME-Version: 1.0
In-Reply-To: <20120208043517.GD8930@ram-ThinkPad-T61>
References: <1328424908-6385-1-git-send-email-yinghai@kernel.org>
	<1328424908-6385-5-git-send-email-yinghai@kernel.org>
	<20120208043517.GD8930@ram-ThinkPad-T61>
Date: Tue, 7 Feb 2012 20:48:36 -0800
X-Google-Sender-Auth: 7y2XkJ6_6VZW5fK976LpGpteBe8
Message-ID: <CAE9FiQUdRLmc-_hHWtaz=8QZiu4Ma6ZY7zavByJnwMDTBQLtzg@mail.gmail.com>
Subject: Re: [PATCH 4/9] PCI: Fix cardbus bridge resources as optional size handling
From: Yinghai Lu <yinghai@kernel.org>
To: Ram Pai <linuxram@us.ibm.com>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 7, 2012 at 8:35 PM, Ram Pai <linuxram@us.ibm.com> wrote:
> On Sat, Feb 04, 2012 at 10:55:03PM -0800, Yinghai Lu wrote:
>> We should not set the requested size to -2.
>>
>> that will confuse the resource list sorting with align when SIZEALIGN is used.
>>
>> Change to STARTALIGN and pass align from start.
>>
>> We are safe to do that just as we do that regular pci bridge.
>>
>> In the long run, we should just treat cardbus like regular pci bridge.
>>
>> Also fix when realloc is not passed, should keep the requested size.
>>
>> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
>> ---
>>  drivers/pci/setup-bus.c |   63 ++++++++++++++++++++++++++--------------------
>>  1 files changed, 36 insertions(+), 27 deletions(-)
>>
>> diff --git a/drivers/pci/setup-bus.c b/drivers/pci/setup-bus.c
>> index d5897c3..3b3932a 100644
>> --- a/drivers/pci/setup-bus.c
>> +++ b/drivers/pci/setup-bus.c
>> @@ -898,21 +898,30 @@ static void pci_bus_size_cardbus(struct pci_bus *bus,
>>  {
>>       struct pci_dev *bridge = bus->self;
>>       struct resource *b_res = &bridge->resource[PCI_BRIDGE_RESOURCES];
>> +     resource_size_t b_res_3_size = pci_cardbus_mem_size * 2;
>>       u16 ctrl;
>>
>>       /*
>>        * Reserve some resources for CardBus.  We reserve
>>        * a fixed amount of bus space for CardBus bridges.
>>        */
>> -     b_res[0].start = 0;
>> -     b_res[0].flags |= IORESOURCE_IO | IORESOURCE_SIZEALIGN;
>> -     if (realloc_head)
>> -             add_to_list(realloc_head, bridge, b_res, pci_cardbus_io_size, 0 /* dont care */);
>> +     b_res[0].start = pci_cardbus_io_size;
>> +     b_res[0].end = b_res[0].start + pci_cardbus_io_size - 1;
>> +     b_res[0].flags |= IORESOURCE_IO | IORESOURCE_STARTALIGN;
>> +     if (realloc_head) {
>> +             b_res[0].end -= pci_cardbus_io_size;
>> +             add_to_list(realloc_head, bridge, b_res, pci_cardbus_io_size,
>> +                             pci_cardbus_io_size);
>> +     }
>>
>> -     b_res[1].start = 0;
>> -     b_res[1].flags |= IORESOURCE_IO | IORESOURCE_SIZEALIGN;
>> -     if (realloc_head)
>> -             add_to_list(realloc_head, bridge, b_res+1, pci_cardbus_io_size, 0 /* dont care */);
>> +     b_res[1].start = pci_cardbus_io_size;
>> +     b_res[1].end = b_res[1].start + pci_cardbus_io_size - 1;
>> +     b_res[1].flags |= IORESOURCE_IO | IORESOURCE_STARTALIGN;
>> +     if (realloc_head) {
>> +             b_res[1].end -= pci_cardbus_io_size;
>> +             add_to_list(realloc_head, bridge, b_res+1, pci_cardbus_io_size,
>> +                              pci_cardbus_io_size);
>> +     }
>>
>>       /* MEM1 must not be pref mmio */
>>       pci_read_config_word(bridge, PCI_CB_BRIDGE_CONTROL, &ctrl);
>> @@ -939,28 +948,28 @@ static void pci_bus_size_cardbus(struct pci_bus *bus,
>>        * twice the size.
>>        */
>>       if (ctrl & PCI_CB_BRIDGE_CTL_PREFETCH_MEM0) {
>> -             b_res[2].start = 0;
>> -             b_res[2].flags |= IORESOURCE_MEM | IORESOURCE_PREFETCH | IORESOURCE_SIZEALIGN;
>> -             if (realloc_head)
>> -                     add_to_list(realloc_head, bridge, b_res+2, pci_cardbus_mem_size, 0 /* dont care */);
>> +             b_res[2].start = pci_cardbus_mem_size;
>> +             b_res[2].end = b_res[2].start + pci_cardbus_mem_size - 1;
>> +             b_res[2].flags |= IORESOURCE_MEM | IORESOURCE_PREFETCH |
>> +                               IORESOURCE_STARTALIGN;
>> +             if (realloc_head) {
>> +                     b_res[2].end -= pci_cardbus_mem_size;
>> +                     add_to_list(realloc_head, bridge, b_res+2,
>> +                              pci_cardbus_mem_size, pci_cardbus_mem_size);
>> +             }
>>
>> -             b_res[3].start = 0;
>> -             b_res[3].flags |= IORESOURCE_MEM | IORESOURCE_SIZEALIGN;
>> -             if (realloc_head)
>> -                     add_to_list(realloc_head, bridge, b_res+3, pci_cardbus_mem_size, 0 /* dont care */);
>
> The b_res_3_size has to be reduced to half here.
> Otherwise it will try allocate 2*pci_cardbus_mem_size to the BAR3..
>
>                b_res_3_size = pci_cardbus_mem_size;
>
>
>> -     } else {
>> -             b_res[3].start = 0;
>> -             b_res[3].flags |= IORESOURCE_MEM | IORESOURCE_SIZEALIGN;
>> -             if (realloc_head)
>> -                     add_to_list(realloc_head, bridge, b_res+3, pci_cardbus_mem_size * 2, 0 /* dont care */);
>> +             /* reduce that to half */
>> +             b_res_3_size = pci_cardbus_mem_size;
>
> b_res3_3_size should not be updated here, since BAR3 has to be allocated 2*pci_cardbus_mem_size
> resource.
>

looks like you did not read the patch correctly

that else {} get removed already in this patch

please check segment after patch...

static void pci_bus_size_cardbus(struct pci_bus *bus,
			struct list_head *realloc_head)
{
	struct pci_dev *bridge = bus->self;
	struct resource *b_res = &bridge->resource[PCI_BRIDGE_RESOURCES];
	resource_size_t b_res_3_size = pci_cardbus_mem_size * 2;
	u16 ctrl;

	/*
	 * Reserve some resources for CardBus.  We reserve
	 * a fixed amount of bus space for CardBus bridges.
	 */
	b_res[0].start = pci_cardbus_io_size;
	b_res[0].end = b_res[0].start + pci_cardbus_io_size - 1;
	b_res[0].flags |= IORESOURCE_IO | IORESOURCE_STARTALIGN;
	if (realloc_head) {
		b_res[0].end -= pci_cardbus_io_size;
		add_to_list(realloc_head, bridge, b_res, pci_cardbus_io_size,
				pci_cardbus_io_size);
	}

	b_res[1].start = pci_cardbus_io_size;
	b_res[1].end = b_res[1].start + pci_cardbus_io_size - 1;
	b_res[1].flags |= IORESOURCE_IO | IORESOURCE_STARTALIGN;
	if (realloc_head) {
		b_res[1].end -= pci_cardbus_io_size;
		add_to_list(realloc_head, bridge, b_res+1, pci_cardbus_io_size,
				 pci_cardbus_io_size);
	}

	/* MEM1 must not be pref mmio */
	pci_read_config_word(bridge, PCI_CB_BRIDGE_CONTROL, &ctrl);
	if (ctrl & PCI_CB_BRIDGE_CTL_PREFETCH_MEM1) {
		ctrl &= ~PCI_CB_BRIDGE_CTL_PREFETCH_MEM1;
		pci_write_config_word(bridge, PCI_CB_BRIDGE_CONTROL, ctrl);
		pci_read_config_word(bridge, PCI_CB_BRIDGE_CONTROL, &ctrl);
	}

	/*
	 * Check whether prefetchable memory is supported
	 * by this bridge.
	 */
	pci_read_config_word(bridge, PCI_CB_BRIDGE_CONTROL, &ctrl);
	if (!(ctrl & PCI_CB_BRIDGE_CTL_PREFETCH_MEM0)) {
		ctrl |= PCI_CB_BRIDGE_CTL_PREFETCH_MEM0;
		pci_write_config_word(bridge, PCI_CB_BRIDGE_CONTROL, ctrl);
		pci_read_config_word(bridge, PCI_CB_BRIDGE_CONTROL, &ctrl);
	}

	/*
	 * If we have prefetchable memory support, allocate
	 * two regions.  Otherwise, allocate one region of
	 * twice the size.
	 */
	if (ctrl & PCI_CB_BRIDGE_CTL_PREFETCH_MEM0) {
		b_res[2].start = pci_cardbus_mem_size;
		b_res[2].end = b_res[2].start + pci_cardbus_mem_size - 1;
		b_res[2].flags |= IORESOURCE_MEM | IORESOURCE_PREFETCH |
				  IORESOURCE_STARTALIGN;
		if (realloc_head) {
			b_res[2].end -= pci_cardbus_mem_size;
			add_to_list(realloc_head, bridge, b_res+2,
				 pci_cardbus_mem_size, pci_cardbus_mem_size);
		}

		/* reduce that to half */
		b_res_3_size = pci_cardbus_mem_size;
	}

	b_res[3].start = pci_cardbus_mem_size;
	b_res[3].end = b_res[3].start + b_res_3_size - 1;
	b_res[3].flags |= IORESOURCE_MEM | IORESOURCE_STARTALIGN;
	if (realloc_head) {
		b_res[3].end -= b_res_3_size;
		add_to_list(realloc_head, bridge, b_res+3, b_res_3_size,
				 pci_cardbus_mem_size);
	}
}
