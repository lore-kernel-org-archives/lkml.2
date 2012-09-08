Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755269Ab2IHPac (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Sep 2012 11:30:32 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:61086 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755000Ab2IHPa3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Sep 2012 11:30:29 -0400
MIME-Version: 1.0
In-Reply-To: <20120908134220.GA24831@localhost>
References: <20120731235705.GW2422@linux.vnet.ibm.com>
	<1343779778.27983.73.camel@gandalf.stny.rr.com>
	<20120801001811.GX2422@linux.vnet.ibm.com>
	<20120801004319.GA7043@localhost>
	<20120822025008.GA8066@localhost>
	<20120822154908.2e6ef3c0@feng-i7>
	<CAErSpo7HhdDi4EhbQZ-oZbsbGVvTfZW8MwKn7Tm+6B8jaQxLBg@mail.gmail.com>
	<20120823154503.15a45b14@feng-i7>
	<CAE9FiQVXj6sLEs0GiBnVsKAbms-Bnt06xYeT01MBtSjNqaqypA@mail.gmail.com>
	<CAE9FiQU2sqXLyMg2KbdKQBaX8WDeagd=OmZ5ELhYgkUQ4b6jZA@mail.gmail.com>
	<20120908134220.GA24831@localhost>
Date: Sat, 8 Sep 2012 08:30:26 -0700
X-Google-Sender-Auth: r-vpbSkdWDDG3vhzxUfsgX6ibkA
Message-ID: <CAE9FiQXT6jH4tK7-6KqkUVc=Yezpi18+5Lk-yEPDwTYpnL_wpA@mail.gmail.com>
Subject: Re: [PATCH 1/2] PCI: Use local parameter pci_device_id for pci_get_subsys/class()
From: Yinghai Lu <yinghai@kernel.org>
To: Fengguang Wu <fengguang.wu@intel.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Steven Rostedt <rostedt@goodmis.org>, Avi Kivity <avi@redhat.com>,
        Steven Rostedt <srostedt@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
        linux-pci@vger.kernel.org, Feng Tang <feng.tang@intel.com>,
        Bjorn Helgaas <bhelgaas@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 8, 2012 at 6:42 AM, Fengguang Wu <fengguang.wu@intel.com> wrote:
> On Fri, Sep 07, 2012 at 06:32:48PM -0700, Yinghai Lu wrote:
>
>> > with this one in pci/next pci config in /sys are not created.
>> >
>> > 10:~ # lspci -tv
>> > pcilib: Cannot open /sys/bus/pci/devices/0000:00:03.0/config
>> > lspci: Unable to read the standard configuration space header of
>> > device 0000:00:03.0
>> > pcilib: Cannot open /sys/bus/pci/devices/0000:00:02.0/config
>> > lspci: Unable to read the standard configuration space header of
>> > device 0000:00:02.0
>> > pcilib: Cannot open /sys/bus/pci/devices/0000:00:01.3/config
>> > lspci: Unable to read the standard configuration space header of
>> > device 0000:00:01.3
>> > pcilib: Cannot open /sys/bus/pci/devices/0000:00:01.1/config
>> > lspci: Unable to read the standard configuration space header of
>> > device 0000:00:01.1
>> > pcilib: Cannot open /sys/bus/pci/devices/0000:00:01.0/config
>> > lspci: Unable to read the standard configuration space header of
>> > device 0000:00:01.0
>> > pcilib: Cannot open /sys/bus/pci/devices/0000:00:00.0/config
>> > lspci: Unable to read the standard configuration space header of
>> > device 0000:00:00.0
>> > -[0000:00]-
>> >
>> > bisected to this commit
>> >
>> > ccee7d23102f5e5765ec24779c5b77472af8f79e is the first bad commit
>> > commit ccee7d23102f5e5765ec24779c5b77472af8f79e
>> > Author: Feng Tang <feng.tang@intel.com>
>> > Date:   Thu Aug 23 15:45:03 2012 +0800
>> >
>> >     PCI: Use pci_device_id on stack for pci_get_subsys/class() to avoid kmalloc
>> >
>> >     This fixes a kernel warning https://lkml.org/lkml/2012/7/31/682
>> >
>> >     pci_get_subsys() may get called in late system reboot stage, using
>> >     a sleepable kmalloc() sounds fragile and will cause a kernel warning
>> >     with my recent commmit 55c844a "x86/reboot: Fix a warning message
>> >     triggered by stop_other_cpus()" which disable local interrupt in
>> >     late system shutdown/reboot phase. Using a local parameter instead
>> >     will fix it and make it eligible for calling forom atomic context.
>> >
>> >     Do the same change for the pci_get_class() as suggested by Bjorn Helgaas
>> >
>> >     [bhelgaas: changelog]
>> >     Bisected-by: Fengguang Wu <fengguang.wu@intel.com>
>> >     Signed-off-by: Feng Tang <feng.tang@intel.com>
>> >     Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
>> >     Reviewed-by: Fengguang Wu <fengguang.wu@intel.com>
>> >
>> > :040000 040000 dee62a035816b73abc68e40de8f21c7349efc4cb
>> > 70b2a6258bffa1ab963bd650d8f5d02da774fbce M      drivers
>> >
>> > so the stack get overrun ?
>> >
>> > Bjorn, I think it is this one that cause lspci broken that I mentioned
>> > during meeting at San Diego.
>
> This makes lspci work again on my side. The caveat is, kzalloc() will
> zero out all data while the new local variable leaves some data
> uninitialized.
>
> diff --git a/drivers/pci/search.c b/drivers/pci/search.c
> index 78a08b1..9148b6e 100644
> --- a/drivers/pci/search.c
> +++ b/drivers/pci/search.c
> @@ -245,7 +245,12 @@ struct pci_dev *pci_get_subsys(unsigned int vendor, unsigned int device,
>                                unsigned int ss_vendor, unsigned int ss_device,
>                                struct pci_dev *from)
>  {
> -       struct pci_device_id id;
> +       struct pci_device_id id = {
> +               .vendor = vendor,
> +               .device = device,
> +               .subvendor = ss_vendor,
> +               .subdevice = ss_device,
> +       };
>
>         /*
>          * pci_find_subsys() can be called on the ide_setup() path,
> @@ -256,11 +261,6 @@ struct pci_dev *pci_get_subsys(unsigned int vendor, unsigned int device,
>         if (unlikely(no_pci_devices()))
>                 return NULL;
>
> -       id.vendor = vendor;
> -       id.device = device;
> -       id.subvendor = ss_vendor;
> -       id.subdevice = ss_device;
> -

yes, here forget to clear .class and .class_mask

>         return pci_get_dev_by_id(&id, from);
>  }
>
> @@ -300,11 +300,14 @@ pci_get_device(unsigned int vendor, unsigned int device, struct pci_dev *from)
>   */
>  struct pci_dev *pci_get_class(unsigned int class, struct pci_dev *from)
>  {
> -       struct pci_device_id id;
> -
> -       id.vendor = id.device = id.subvendor = id.subdevice = PCI_ANY_ID;
> -       id.class_mask = PCI_ANY_ID;
> -       id.class = class;
> +       struct pci_device_id id = {
> +               .vendor = PCI_ANY_ID,
> +               .device = PCI_ANY_ID,
> +               .subvendor = PCI_ANY_ID,
> +               .subdevice = PCI_ANY_ID,
> +               .class_mask = PCI_ANY_ID,
> +               .class = class,
> +       };
>
>         return pci_get_dev_by_id(&id, from);
>  }
