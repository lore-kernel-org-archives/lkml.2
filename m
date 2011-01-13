Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757256Ab1AMVIu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jan 2011 16:08:50 -0500
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:48323 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756990Ab1AMVIo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jan 2011 16:08:44 -0500
Date: Thu, 13 Jan 2011 22:09:50 +0100
From: Borislav Petkov <bp@amd64.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>,
        Manoj Iyer <manoj.iyer@canonical.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        "Herrmann3, Andreas" <Andreas.Herrmann3@amd.com>
Subject: Re: [PATCH] Quirk to fix suspend/resume on Lenovo Edge 11,13,14,15
Message-ID: <20110113210950.GA4081@aftab>
References: <AANLkTinw23rtSERxAy6G_cu5=rvQeEzxvf3snsUOZE+z@mail.gmail.com>
 <20110113175531.GD2006@aftab>
 <AANLkTikDoRMoQjtN03eMoeacwottEixrFqcF8nJZWgKy@mail.gmail.com>
 <20110113183025.GE2006@aftab>
 <alpine.LFD.2.00.1101131946560.2678@localhost6.localdomain6>
 <20110113185807.GA24720@srcf.ucam.org>
 <20110113190700.GB30866@kryptos.osrc.amd.com>
 <alpine.LFD.2.00.1101132012140.2678@localhost6.localdomain6>
 <20110113192825.GC30866@kryptos.osrc.amd.com>
 <alpine.LFD.2.00.1101132032350.2678@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1101132032350.2678@localhost6.localdomain6>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 13, 2011 at 02:41:51PM -0500, Thomas Gleixner wrote:
> On Thu, 13 Jan 2011, Borislav Petkov wrote:
> 
> > On Thu, Jan 13, 2011 at 08:13:42PM +0100, Thomas Gleixner wrote:
> > > > Well, Andreas did boot with 'hpet=verbose' on an affected machine here
> > > > and did a suspend/resume and the hpet config registers looked ok before
> > > > suspend and after resume. It might be that the HPET is temporarily
> > > > "insane" while resume lasts but we don't have any hard facts confirming
> > > 
> > > And you have no explanation at all why applying the irq pin routing
> > > quirk makes HPETs temporal insanity go away magically :)
> > 
> > But after the HPET counter wraps around, the machine is alive again.
> > Which means that the IRQ0 pin2 override is only temporarily needed after
> > resume... Strange.
> 
> Thinking more about it:
> 
> Case 1:	IRQ0 pin2 override applied
> 
>      Resume hangs until HPET wraps around and issues another interrupt
> 
> Case 2: IRQ0 pin2 override ignored via quirk
> 
>      Resume just works
> 
> So the question is what is restored _AFTER_ the HPET is reprogrammed
> in the resume path ?
> 
> The HPET reprogramming happens via timekeeping_resume() which is in
> the sysdev part of resume. ioapic, apic, iommus etc. are also resumed
> via the sysdev_class. So what makes sure that the ordering of these is
> correct?
> 
> AFAICT nothing :)

I see. You're hinting at some wrong ordering between resuming apic and
hpet maybe... But why does this work on SB700 without timer override? So
it looks like SB800 does something differently which cannot stomach what
Linux does. Could it be that after resume, HPET uses "by default" pin0
for the IRQ when it expires and that's why it works?

> We need information about the resume order of sysdev_class and the
> difference of the pin routings in the quirk non/quirk case.

I'll try to get that tomorrow on the SB800 system we have.

>From Manoj's dmesg logs I can see the following (1st one is with the
timer override):

[    0.000000] ACPI: PM-Timer IO Port: 0x8008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 2, version 33, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 low level)
[    0.000000] ACPI: BIOS IRQ0 pin2 override ignored.
[    0.000000] ACPI: IRQ9 used by override.


[    0.000000] ACPI: PM-Timer IO Port: 0x8008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 2, version 33, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 low level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.

Which looks ok, AFAICT.

Here's the respective snippet on an SB700 system which suspends fine:

[    0.000000] ACPI: PM-Timer IO Port: 0x808
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x02] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x03] enabled)
[    0.000000] ACPI: IOAPIC (id[0x04] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 4, version 33, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 low level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.


Do you see anything? :)

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
General Managers: Alberto Bozzo, Andrew Bowd
Registration: Dornach, Gemeinde Aschheim, Landkreis Muenchen
Registergericht Muenchen, HRB Nr. 43632
