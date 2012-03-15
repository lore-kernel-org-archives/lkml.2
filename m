Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161249Ab2CORy0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2012 13:54:26 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:53936 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1161203Ab2CORyV convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2012 13:54:21 -0400
MIME-Version: 1.0
In-Reply-To: <CAE9FiQWfYxD2OAmXF5UdQMkPt33xeoSu489N6KtU3k5VE3jUXw@mail.gmail.com>
References: <1331362837-10740-1-git-send-email-yinghai@kernel.org>
 <1331362837-10740-25-git-send-email-yinghai@kernel.org> <CAErSpo6g3pei2+oW0wLEpytBTh6wGTyzo28oVVzFECxZdta+FA@mail.gmail.com>
 <CAE9FiQWfYxD2OAmXF5UdQMkPt33xeoSu489N6KtU3k5VE3jUXw@mail.gmail.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Thu, 15 Mar 2012 11:53:59 -0600
Message-ID: <CAErSpo4KhQJOpKk8OOtcSxWc3wwkhLix8ECZhGtTnQ2WgQH7iw@mail.gmail.com>
Subject: Re: [PATCH v2 24/37] PCI, ACPI: Add pci_root_hp hot removal
 notification support.
To: Yinghai Lu <yinghai@kernel.org>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>, x86 <x86@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Len Brown <lenb@kernel.org>, linux-acpi@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 13, 2012 at 12:06 AM, Yinghai Lu <yinghai@kernel.org> wrote:
> On Mon, Mar 12, 2012 at 8:25 PM, Bjorn Helgaas <bhelgaas@google.com> wrote:
>> On Sat, Mar 10, 2012 at 12:00 AM, Yinghai Lu <yinghai@kernel.org> wrote:
>>> Add missing hot_remove support for root device.
>>>
>>> How to use it?
>>> Find out root bus number to acpi root name mapping from dmesg or /sys
>>>
>>>  echo "\_SB.PCIB 3" > /proc/acpi/sci/notify
>>> to remove root bus
>>
>> Same comments as before: this is definitely NOT the way users should
>> use this.  If you want to do that for debugging the ACPI notification
>> path, fine, but the normal way is for the platform to generate this
>> notification.  I think the normal way for users to manually remove an
>> ACPI device should be something like:
>>
>>    echo 1 > /sys/devices/LNXSYSTM:00/device:00/PNP0A08:00/remove
>>
>> just like we do for PCI devices.
>
> notify way looks more like really physical hotadd/remove.

Sure, the 'echo "\_SB.PCIB 3" > /proc/acpi/sci/notify' way looks more
like physical hotadd/remove because it is basically injecting the
notify event that the hardware/BIOS should be generating itself.  But
it is platform-specific and therefore unacceptable as a general user
interface.

Using /sys/devices/LNXSYSTM:00/device:00/PNP0A08:00/remove would be a
more generic way.  The PNP0A08:00/remove implementation would
basically turn into an acpi_pci_root_remove() call, just like the
'echo "\_SB.PCIB 3" > /proc/acpi/sci/notify' does.

Both ways should exercise the same code path.  The only difference is
that using /proc/acpi/sci/notify should go through a little more of
the ACPI notify path before reaching acpi_pci_root_remove().

> pci bus/remove and other is not really, because when you are using
> /sys, you may still need to hold
> one reference to bus or device.
>
>>
>>> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
>>> Cc: Len Brown <lenb@kernel.org>
>>> Cc: linux-acpi@vger.kernel.org
>>> ---
>>>  drivers/acpi/pci_root_hp.c |   61 ++++++++++++++++++++++++++++++++++++++++++++
>>>  1 files changed, 61 insertions(+), 0 deletions(-)
>>>
>>> diff --git a/drivers/acpi/pci_root_hp.c b/drivers/acpi/pci_root_hp.c
>>> index dc11e81..f5585f5 100644
>>> --- a/drivers/acpi/pci_root_hp.c
>>> +++ b/drivers/acpi/pci_root_hp.c
>>> @@ -73,6 +73,12 @@ static void add_acpi_root_bridge(acpi_handle handle)
>>>        list_add(&bridge->list, &acpi_root_bridge_list);
>>>  }
>>>
>>> +static void remove_acpi_root_bridge(struct acpi_root_bridge *bridge)
>>> +{
>>> +       list_del(&bridge->list);
>>> +       kfree(bridge);
>>> +}
>>> +
>>>  struct acpi_root_hp_work {
>>>        struct work_struct work;
>>>        acpi_handle handle;
>>> @@ -142,6 +148,55 @@ static void handle_root_bridge_insertion(acpi_handle handle)
>>>                printk(KERN_ERR "cannot start bridge\n");
>>>  }
>>>
>>> +static int acpi_root_evaluate_object(acpi_handle handle, char *cmd, int val)
>>> +{
>>> +       acpi_status status;
>>> +       struct acpi_object_list arg_list;
>>> +       union acpi_object arg;
>>> +
>>> +       arg_list.count = 1;
>>> +       arg_list.pointer = &arg;
>>> +       arg.type = ACPI_TYPE_INTEGER;
>>> +       arg.integer.value = val;
>>> +
>>> +       status = acpi_evaluate_object(handle, cmd, &arg_list, NULL);
>>> +       if (ACPI_FAILURE(status)) {
>>> +               printk(KERN_WARNING "%s: %s to %d failed\n",
>>> +                                __func__, cmd, val);
>>> +               return -1;
>>> +       }
>>> +
>>> +       return 0;
>>
>> This function really has nothing to do with host bridges.  Are you
>> sure there's no generic function you can use instead?
>
> seems not.
