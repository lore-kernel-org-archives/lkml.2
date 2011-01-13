Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757333Ab1AMVbH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jan 2011 16:31:07 -0500
Received: from www.tglx.de ([62.245.132.106]:54584 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756717Ab1AMVa7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jan 2011 16:30:59 -0500
Date: Thu, 13 Jan 2011 22:30:43 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Borislav Petkov <bp@amd64.org>
cc: Matthew Garrett <mjg59@srcf.ucam.org>,
        Manoj Iyer <manoj.iyer@canonical.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        "Herrmann3, Andreas" <Andreas.Herrmann3@amd.com>
Subject: Re: [PATCH] Quirk to fix suspend/resume on Lenovo Edge 11,13,14,15
In-Reply-To: <20110113210950.GA4081@aftab>
Message-ID: <alpine.LFD.2.00.1101132210351.2678@localhost6.localdomain6>
References: <AANLkTinw23rtSERxAy6G_cu5=rvQeEzxvf3snsUOZE+z@mail.gmail.com> <20110113175531.GD2006@aftab> <AANLkTikDoRMoQjtN03eMoeacwottEixrFqcF8nJZWgKy@mail.gmail.com> <20110113183025.GE2006@aftab> <alpine.LFD.2.00.1101131946560.2678@localhost6.localdomain6>
 <20110113185807.GA24720@srcf.ucam.org> <20110113190700.GB30866@kryptos.osrc.amd.com> <alpine.LFD.2.00.1101132012140.2678@localhost6.localdomain6> <20110113192825.GC30866@kryptos.osrc.amd.com> <alpine.LFD.2.00.1101132032350.2678@localhost6.localdomain6>
 <20110113210950.GA4081@aftab>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 13 Jan 2011, Borislav Petkov wrote:
> On Thu, Jan 13, 2011 at 02:41:51PM -0500, Thomas Gleixner wrote:
> > On Thu, 13 Jan 2011, Borislav Petkov wrote:
> > 
> > > On Thu, Jan 13, 2011 at 08:13:42PM +0100, Thomas Gleixner wrote:
> > > > > Well, Andreas did boot with 'hpet=verbose' on an affected machine here
> > > > > and did a suspend/resume and the hpet config registers looked ok before
> > > > > suspend and after resume. It might be that the HPET is temporarily
> > > > > "insane" while resume lasts but we don't have any hard facts confirming
> > > > 
> > > > And you have no explanation at all why applying the irq pin routing
> > > > quirk makes HPETs temporal insanity go away magically :)
> > > 
> > > But after the HPET counter wraps around, the machine is alive again.
> > > Which means that the IRQ0 pin2 override is only temporarily needed after
> > > resume... Strange.
> > 
> > Thinking more about it:
> > 
> > Case 1:	IRQ0 pin2 override applied
> > 
> >      Resume hangs until HPET wraps around and issues another interrupt
> > 
> > Case 2: IRQ0 pin2 override ignored via quirk
> > 
> >      Resume just works
> > 
> > So the question is what is restored _AFTER_ the HPET is reprogrammed
> > in the resume path ?
> > 
> > The HPET reprogramming happens via timekeeping_resume() which is in
> > the sysdev part of resume. ioapic, apic, iommus etc. are also resumed
> > via the sysdev_class. So what makes sure that the ordering of these is
> > correct?
> > 
> > AFAICT nothing :)
> 
> I see. You're hinting at some wrong ordering between resuming apic and
> hpet maybe... But why does this work on SB700 without timer override? So
> it looks like SB800 does something differently which cannot stomach what
> Linux does. Could it be that after resume, HPET uses "by default" pin0
> for the IRQ when it expires and that's why it works?
> 
> > We need information about the resume order of sysdev_class and the
> > difference of the pin routings in the quirk non/quirk case.
> 
> I'll try to get that tomorrow on the SB800 system we have.
> 
> >From Manoj's dmesg logs I can see the following (1st one is with the
> timer override):
> 
> [    0.000000] ACPI: PM-Timer IO Port: 0x8008
> [    0.000000] ACPI: Local APIC address 0xfee00000
> [    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
> [    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
> [    0.000000] ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
> [    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
> [    0.000000] ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
> [    0.000000] IOAPIC[0]: apic_id 2, version 33, address 0xfec00000, GSI 0-23
> [    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 low level)
> [    0.000000] ACPI: BIOS IRQ0 pin2 override ignored.
> [    0.000000] ACPI: IRQ9 used by override.

The more interesting info is there in Manoj's logs:

[    0.036455] ..TIMER: vector=0x30 apic1=0 pin1=0 apic2=-1 pin2=-1
[    0.040000] ..MP-BIOS bug: 8254 timer not connected to IO-APIC
[    0.040000] ...trying to set up timer (IRQ0) through the 8259A ...
[    0.040000] ..... (found apic 0 pin 0) ...
[    0.080021] ....... works.

versus

[    0.036460] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1

So the "working" state is using "apic 0 pin 0" while the non working
state is using "vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1".

Something changes across suspend/resume which makes the BIOS
advertised routing work with PIT but not with HPET. Further why does
the apic 0/0 solution found by the kernel (when ignoring BIOS) works
always (except that we don't know whether the "nohpet" case works as
well, but I bet it does).

So we are back to the question I raised above: What changes and even
more interesting what changes after the HPET expires - which we know
for sure that it must happen as otherwise we wont get a HPET interrupt
after the 32bit wraparound.

We need answers to these questions before applying any
patch/workaround/quirk or whatever.

Thanks,

	tglx


