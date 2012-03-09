Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758517Ab2CIR26 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2012 12:28:58 -0500
Received: from mail-lb0-f174.google.com ([209.85.217.174]:38689 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758400Ab2CIR24 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2012 12:28:56 -0500
MIME-Version: 1.0
In-Reply-To: <CAE9FiQUGCazRAJ3vaej6wndk9e-kedU7tuaw8VSRcu2RB0qQAg@mail.gmail.com>
References: <1331018040-30725-1-git-send-email-yinghai@kernel.org>
 <1331018040-30725-15-git-send-email-yinghai@kernel.org> <CAErSpo6VyKpBygK3vV25q+X5YisNVPwh64jaJ_KtMO1WB=ocpw@mail.gmail.com>
 <CAE9FiQUGCazRAJ3vaej6wndk9e-kedU7tuaw8VSRcu2RB0qQAg@mail.gmail.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Fri, 9 Mar 2012 10:28:34 -0700
Message-ID: <CAErSpo5KgLWiegOtOyVb7CeMyk2yicuFJC_vfiFmeEO8hj_Muw@mail.gmail.com>
Subject: Re: [PATCH 14/23] PCI: add __pci_remove_bus_devices()
To: Yinghai Lu <yinghai@kernel.org>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>, x86 <x86@kernel.org>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 9, 2012 at 12:17 AM, Yinghai Lu <yinghai@kernel.org> wrote:
> On Thu, Mar 8, 2012 at 5:11 PM, Bjorn Helgaas <bhelgaas@google.com> wrote:
>> On Tue, Mar 6, 2012 at 12:13 AM, Yinghai Lu <yinghai@kernel.org> wrote:
>>> will use it with pci_stop_and_remove_bus later.
>>>
>>> also remove __pci_remove_behind_bridge and pci_stop_behind_bridge.
>>>
>>> they are same except one take bridge and one take bus.
>>>
>>> and we already have pci_stop_bus_devices()
>>>
>>> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
>>> ---
>>>  drivers/pci/remove.c |   28 +++++++++++-----------------
>>>  1 files changed, 11 insertions(+), 17 deletions(-)
>>>
>>> diff --git a/drivers/pci/remove.c b/drivers/pci/remove.c
>>> index 243d59b..62c348c 100644
>>> --- a/drivers/pci/remove.c
>>> +++ b/drivers/pci/remove.c
>>> @@ -78,7 +78,7 @@ void pci_remove_bus(struct pci_bus *pci_bus)
>>>  }
>>>  EXPORT_SYMBOL(pci_remove_bus);
>>>
>>> -static void __pci_remove_behind_bridge(struct pci_dev *dev);
>>> +static void __pci_remove_bus_devices(struct pci_bus *bus);
>>>  /**
>>>  * pci_stop_and_remove_bus_device - remove a PCI device and any children
>>>  * @dev: the device to remove
>>> @@ -96,7 +96,7 @@ void __pci_remove_bus_device(struct pci_dev *dev)
>>>        if (dev->subordinate) {
>>>                struct pci_bus *b = dev->subordinate;
>>>
>>> -               __pci_remove_behind_bridge(dev);
>>> +               __pci_remove_bus_devices(b);
>>>                pci_remove_bus(b);
>>>                dev->subordinate = NULL;
>>>        }
>>> @@ -111,22 +111,12 @@ void pci_stop_and_remove_bus_device(struct pci_dev *dev)
>>>        __pci_remove_bus_device(dev);
>>>  }
>>>
>>> -static void __pci_remove_behind_bridge(struct pci_dev *dev)
>>> +static void __pci_remove_bus_devices(struct pci_bus *bus)
>>>  {
>>>        struct list_head *l, *n;
>>>
>>> -       if (dev->subordinate)
>>> -               list_for_each_safe(l, n, &dev->subordinate->devices)
>>> -                       __pci_remove_bus_device(pci_dev_b(l));
>>> -}
>>> -
>>> -static void pci_stop_behind_bridge(struct pci_dev *dev)
>>> -{
>>> -       struct list_head *l, *n;
>>> -
>>> -       if (dev->subordinate)
>>> -               list_for_each_safe(l, n, &dev->subordinate->devices)
>>> -                       pci_stop_bus_device(pci_dev_b(l));
>>> +       list_for_each_safe(l, n, &bus->devices)
>>> +               __pci_remove_bus_device(pci_dev_b(l));
>>
>> Use list_for_each_entry_safe() so you don't need pci_dev_b().
>
> just want to keep the patch to simple, and looks like just name renaming.
>
> also use list_for_each_safe instead of list_for_each_entry_safe
>
> could have less conversion.

Sorry, I didn't understand the above.

It is OK to improve code as you change it :)  list_for_each_entry() is
clearly an improvement over list_for_each() + some conversion macro.

>>>  }
>>>
>>>  static void pci_stop_bus_devices(struct pci_bus *bus)
>>> @@ -158,8 +148,12 @@ static void pci_stop_bus_devices(struct pci_bus *bus)
>>>  */
>>>  void pci_stop_and_remove_behind_bridge(struct pci_dev *dev)
>>>  {
>>> -       pci_stop_behind_bridge(dev);
>>> -       __pci_remove_behind_bridge(dev);
>>> +       struct pci_bus *bus = dev->subordinate;
>>> +
>>> +       if (bus) {
>>
>> Don't check "bus" here.  If the caller screws up and passes a
>> non-bridge pointer, I want to learn about it rather than ignore it.
>
> old code have that
>           if (dev->subordinate)
>
> checking.

Removing a test that could silently cover a programming error is also
an improvement.

Bjorn
