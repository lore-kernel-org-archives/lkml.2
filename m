Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752431Ab2G0RXb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2012 13:23:31 -0400
Received: from g4t0015.houston.hp.com ([15.201.24.18]:24541 "EHLO
	g4t0015.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751081Ab2G0RX3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2012 13:23:29 -0400
Message-ID: <1343409517.3010.575.camel@misato.fc.hp.com>
Subject: Re: [PATCH v3 2/4] ACPI: Update CPU hotplug messages
From: Toshi Kani <toshi.kani@hp.com>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: lenb@kernel.org, linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        joe@perches.com, isimatu.yasuaki@jp.fujitsu.com, liuj97@gmail.com,
        srivatsa.bhat@linux.vnet.ibm.com, prarit@redhat.com,
        imammedo@redhat.com, vijaymohan.pandarathil@hp.com
Date: Fri, 27 Jul 2012 11:18:37 -0600
In-Reply-To: <CAErSpo5r5W-Yf-eo6o7zW71qYhUiX-3Xu-X76em-GFNWPCmm+g@mail.gmail.com>
References: <1343257978-7085-1-git-send-email-toshi.kani@hp.com>
	 <1343257978-7085-3-git-send-email-toshi.kani@hp.com>
	 <CAErSpo64rOMfLB0abck20OEyeD1V96R-yzPUDt2gHa0zo26EYw@mail.gmail.com>
	 <1343356751.3010.520.camel@misato.fc.hp.com>
	 <CAErSpo5r5W-Yf-eo6o7zW71qYhUiX-3Xu-X76em-GFNWPCmm+g@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-1.fc16) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-07-27 at 10:05 -0600, Bjorn Helgaas wrote:
> On Thu, Jul 26, 2012 at 8:39 PM, Toshi Kani <toshi.kani@hp.com> wrote:
> > On Thu, 2012-07-26 at 13:23 -0600, Bjorn Helgaas wrote:
> >> On Wed, Jul 25, 2012 at 5:12 PM, Toshi Kani <toshi.kani@hp.com> wrote:
> 
> >> > @@ -560,8 +565,7 @@ static int __cpuinit acpi_processor_add(struct acpi_device *device)
> >> >          */
> >> >         if (per_cpu(processor_device_array, pr->id) != NULL &&
> >> >             per_cpu(processor_device_array, pr->id) != device) {
> >> > -               printk(KERN_WARNING "BIOS reported wrong ACPI id "
> >> > -                       "for the processor\n");
> >> > +               pr_warn("BIOS reported wrong ACPI id for the processor\n");
> >>
> >> And this.
> >
> > Changed to use dev_warn().
> 
> Is there additional information you could print here, like the pr->id?
>  I don't understand the data structures here, so maybe there isn't.

Good point.  Yes, we should print pr->id so that we can check if the id
value is wrong.  I will make this change later since I would likely
touch this file again. :)  For now, I'd like to settle the patches
unless there is a major issue.

> >> > @@ -727,17 +731,19 @@ static void acpi_processor_hotplug_notify(acpi_handle handle,
> >> >                                   "received ACPI_NOTIFY_EJECT_REQUEST\n"));
> >> >
> >> >                 if (acpi_bus_get_device(handle, &device)) {
> >> > -                       pr_err(PREFIX "Device don't exist, dropping EJECT\n");
> >> > +                       acpi_pr_err(handle,
> >> > +                               "Device don't exist, dropping EJECT\n");
> >> >                         break;
> >> >                 }
> >> >                 if (!acpi_driver_data(device)) {
> >> > -                       pr_err(PREFIX "Driver data is NULL, dropping EJECT\n");
> >> > +                       acpi_pr_err(handle,
> >> > +                               "Driver data is NULL, dropping EJECT\n");
> >>
> >> And this.
> >
> > No change since it is called directly from the handler.
> 
> True, but by this point, we have a valid acpi_device *, don't we?  We
> called acpi_driver_data(device), which requires "device" to be valid.

Right.  But we need to print ACPI device path in order to be able to
analyze from the log file.  Hence, I am keeping acpi_pr_<level> in the
error paths of the handler itself.  Any subsequent functions call
dev_<level>() when device is valid.  In this particular case,
acpi_driver_data() does not call dev_<level>() when its return value is
NULL, but most other cases are changed to call dev_<level>().

> >> >                         break;
> >> >                 }
> >> >
> >> >                 ej_event = kmalloc(sizeof(*ej_event), GFP_KERNEL);
> >> >                 if (!ej_event) {
> >> > -                       pr_err(PREFIX "No memory, dropping EJECT\n");
> >> > +                       acpi_pr_err(handle, "No memory, dropping EJECT\n");
> >>
> >> And this.
> >
> > No change since it is called directly from the handler.
> >
> >> >                         break;
> >> >                 }
> >> >
> >> > @@ -847,7 +853,7 @@ static acpi_status acpi_processor_hotadd_init(struct acpi_processor *pr)
> >> >          * and do it when the CPU gets online the first time
> >> >          * TBD: Cleanup above functions and try to do this more elegant.
> >> >          */
> >> > -       printk(KERN_INFO "CPU %d got hotplugged\n", pr->id);
> >> > +       pr_info("CPU %d got hotplugged\n", pr->id);
> >>
> >> And this.  The caller (acpi_processor_get_info()) has an acpi_device
> >> *, so we should be able to use it here.
> >
> > I think pr_info() is fine since it is a normal message and already has
> > CPU number in the message.
> 
> Is there another message that correlates the device name
> ("ACPI0007:xx") with the CPU number?  That correlation seems useful.
> My mindset is that a driver should *always* use dev_<level>() when
> possible, but I won't belabor the point.

That's a good point.  This CPU number is used for cpu# file
under /sys/devices/system/cpu, but I do not think there is a good way to
correlate this number to the device name.  This is also the case for all
CPUs launched at boot-time.  At boot-time, all CPUs are launched from
the MADT table, and the code has no knowledge about processor objects.
Typically, cpu# and device instance# are same at boot-time, though.  I
will think about this issue further.

Thanks,
-Toshi

> 
> Bjorn


