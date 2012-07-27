Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752233Ab2G0QFh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2012 12:05:37 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:34905 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751350Ab2G0QFf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2012 12:05:35 -0400
MIME-Version: 1.0
In-Reply-To: <1343356751.3010.520.camel@misato.fc.hp.com>
References: <1343257978-7085-1-git-send-email-toshi.kani@hp.com>
 <1343257978-7085-3-git-send-email-toshi.kani@hp.com> <CAErSpo64rOMfLB0abck20OEyeD1V96R-yzPUDt2gHa0zo26EYw@mail.gmail.com>
 <1343356751.3010.520.camel@misato.fc.hp.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Fri, 27 Jul 2012 10:05:13 -0600
Message-ID: <CAErSpo5r5W-Yf-eo6o7zW71qYhUiX-3Xu-X76em-GFNWPCmm+g@mail.gmail.com>
Subject: Re: [PATCH v3 2/4] ACPI: Update CPU hotplug messages
To: Toshi Kani <toshi.kani@hp.com>
Cc: lenb@kernel.org, linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        joe@perches.com, isimatu.yasuaki@jp.fujitsu.com, liuj97@gmail.com,
        srivatsa.bhat@linux.vnet.ibm.com, prarit@redhat.com,
        imammedo@redhat.com, vijaymohan.pandarathil@hp.com
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 26, 2012 at 8:39 PM, Toshi Kani <toshi.kani@hp.com> wrote:
> On Thu, 2012-07-26 at 13:23 -0600, Bjorn Helgaas wrote:
>> On Wed, Jul 25, 2012 at 5:12 PM, Toshi Kani <toshi.kani@hp.com> wrote:

>> > @@ -560,8 +565,7 @@ static int __cpuinit acpi_processor_add(struct acpi_device *device)
>> >          */
>> >         if (per_cpu(processor_device_array, pr->id) != NULL &&
>> >             per_cpu(processor_device_array, pr->id) != device) {
>> > -               printk(KERN_WARNING "BIOS reported wrong ACPI id "
>> > -                       "for the processor\n");
>> > +               pr_warn("BIOS reported wrong ACPI id for the processor\n");
>>
>> And this.
>
> Changed to use dev_warn().

Is there additional information you could print here, like the pr->id?
 I don't understand the data structures here, so maybe there isn't.

>> > @@ -727,17 +731,19 @@ static void acpi_processor_hotplug_notify(acpi_handle handle,
>> >                                   "received ACPI_NOTIFY_EJECT_REQUEST\n"));
>> >
>> >                 if (acpi_bus_get_device(handle, &device)) {
>> > -                       pr_err(PREFIX "Device don't exist, dropping EJECT\n");
>> > +                       acpi_pr_err(handle,
>> > +                               "Device don't exist, dropping EJECT\n");
>> >                         break;
>> >                 }
>> >                 if (!acpi_driver_data(device)) {
>> > -                       pr_err(PREFIX "Driver data is NULL, dropping EJECT\n");
>> > +                       acpi_pr_err(handle,
>> > +                               "Driver data is NULL, dropping EJECT\n");
>>
>> And this.
>
> No change since it is called directly from the handler.

True, but by this point, we have a valid acpi_device *, don't we?  We
called acpi_driver_data(device), which requires "device" to be valid.

>> >                         break;
>> >                 }
>> >
>> >                 ej_event = kmalloc(sizeof(*ej_event), GFP_KERNEL);
>> >                 if (!ej_event) {
>> > -                       pr_err(PREFIX "No memory, dropping EJECT\n");
>> > +                       acpi_pr_err(handle, "No memory, dropping EJECT\n");
>>
>> And this.
>
> No change since it is called directly from the handler.
>
>> >                         break;
>> >                 }
>> >
>> > @@ -847,7 +853,7 @@ static acpi_status acpi_processor_hotadd_init(struct acpi_processor *pr)
>> >          * and do it when the CPU gets online the first time
>> >          * TBD: Cleanup above functions and try to do this more elegant.
>> >          */
>> > -       printk(KERN_INFO "CPU %d got hotplugged\n", pr->id);
>> > +       pr_info("CPU %d got hotplugged\n", pr->id);
>>
>> And this.  The caller (acpi_processor_get_info()) has an acpi_device
>> *, so we should be able to use it here.
>
> I think pr_info() is fine since it is a normal message and already has
> CPU number in the message.

Is there another message that correlates the device name
("ACPI0007:xx") with the CPU number?  That correlation seems useful.
My mindset is that a driver should *always* use dev_<level>() when
possible, but I won't belabor the point.

Bjorn
