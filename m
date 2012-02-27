Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754952Ab2B0TR7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Feb 2012 14:17:59 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:63797 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754331Ab2B0TR5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Feb 2012 14:17:57 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of bhelgaas@google.com designates 10.180.107.67 as permitted sender) smtp.mail=bhelgaas@google.com; dkim=pass header.i=bhelgaas@google.com
MIME-Version: 1.0
In-Reply-To: <CAE9FiQUDtJc5uwPXkQ7T7zr8=xa=VnPuQT4Q87SXbynuCHQ2Zg@mail.gmail.com>
References: <1330299202-3838-1-git-send-email-yinghai@kernel.org>
 <1330299202-3838-6-git-send-email-yinghai@kernel.org> <CAErSpo4PMzuPdCZvbYFiQRGjGuMg+KYk0ZxJH0xr-n6AfqBAnA@mail.gmail.com>
 <CAE9FiQUDtJc5uwPXkQ7T7zr8=xa=VnPuQT4Q87SXbynuCHQ2Zg@mail.gmail.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Mon, 27 Feb 2012 12:17:36 -0700
Message-ID: <CAErSpo4pDOZ0FM_OQ7=X2iysfUy6pFyWvY5i7WX=5cdD2Tu9Ew@mail.gmail.com>
Subject: Re: [PATCH 5/8] PCI: add generic device into pci_host_bridge struct
To: Yinghai Lu <yinghai@kernel.org>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 27, 2012 at 12:08 PM, Yinghai Lu <yinghai@kernel.org> wrote:
> On Mon, Feb 27, 2012 at 9:57 AM, Bjorn Helgaas <bhelgaas@google.com> wrote:
>> On Sun, Feb 26, 2012 at 4:33 PM, Yinghai Lu <yinghai@kernel.org> wrote:
>>> use that device for pci_root_bus bridge pointer.
>>>
>>> With that make code more simple.
>>>
>>> Also we can use pci_release_bus_bridge_dev() to release allocated
>>> pci_host_bridge during removing path.
>>>
>>> At last, we can use root bus bridge pointer to get host bridge pointer instead
>>> of going over host bridge list, so could kill that host bridge list.
>>>
>>> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
>>>
>>> ---
>>>  drivers/pci/host-bridge.c |   14 ---------
>>>  drivers/pci/pci.h         |    2 -
>>>  drivers/pci/probe.c       |   65 ++++++++++++++++++++++++----------------------
>>>  include/linux/pci.h       |    4 ++
>>>  4 files changed, 38 insertions(+), 47 deletions(-)
>>>
>>> Index: linux-2.6/drivers/pci/host-bridge.c
>>> ===================================================================
>>> --- linux-2.6.orig/drivers/pci/host-bridge.c
>>> +++ linux-2.6/drivers/pci/host-bridge.c
>>> -       dev = kzalloc(sizeof(*dev), GFP_KERNEL);
>>> -       if (!dev)
>>> -               goto err_dev;
>>> +               return NULL;
>>>
> ...
>
> here old code allocate dummy struct device.
>
>>> +       bridge = pci_alloc_host_bridge(b);
>>> +       if (!bridge)
>>> +               goto err_out;
>>> +
>>> +       bridge->dev.parent = parent;
>>> +       bridge->dev.release = pci_release_bus_bridge_dev;
>>> +       dev_set_name(&bridge->dev, "pci%04x:%02x", pci_domain_nr(b), bus);
>>> +       error = device_register(&bridge->dev);
>>>        if (error)
>>> -               goto dev_reg_err;
>>> -       b->bridge = get_device(dev);
>>> +               goto bridge_dev_reg_err;
>>> +       b->bridge = get_device(&bridge->dev);
> ...
>>> --- linux-2.6.orig/include/linux/pci.h
>>> +++ linux-2.6/include/linux/pci.h
>>> @@ -375,11 +375,13 @@ struct pci_host_bridge_window {
>>>  };
>>>
>>>  struct pci_host_bridge {
>>> -       struct list_head list;
>>> +       struct device dev;
>>>        struct pci_bus *bus;            /* root bus */
>>>        struct list_head windows;       /* pci_host_bridge_windows */
>>>  };
>>
>> This doesn't feel right to me.  You're allocating a new struct device
>> here, but the arch likely already has one.  In fact, I think we even
>> passed it in to pci_create_root_bus().
>
> no.
>
> original pci_create_root_bus() will create one dummy struct device and
> use it as parent for bus->dev.
>
>>
>> On x86, we already have an ACPI device for the host bridge, and now
>> we'll have a second one.  (Actually a *third* one, because PNPACPI
>> also has one, but that's a long-standing problem.)
>
> not related.

OK.  Can you educate me?  What is the device we pass in, what does the
dummy one correspond to, why do we have two, what's the difference,
etc., etc.?

Bjorn
