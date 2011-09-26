Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752299Ab1IZWSS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Sep 2011 18:18:18 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:57403 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750873Ab1IZWSQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Sep 2011 18:18:16 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Subject: Re: PME via interrupt or SCI mechanism?
Date: Tue, 27 Sep 2011 00:20:26 +0200
User-Agent: KMail/1.13.6 (Linux/3.1.0-rc4+; KDE/4.6.0; x86_64; ; )
Cc: linux-acpi@vger.kernel.org, linux-pci@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
References: <20110912171003.GA7939@xanatos> <20110922183201.GA4659@xanatos> <201109251653.04170.rjw@sisk.pl>
In-Reply-To: <201109251653.04170.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Message-Id: <201109270020.26439.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, September 25, 2011, Rafael J. Wysocki wrote:
> On Thursday, September 22, 2011, Sarah Sharp wrote:
> > On Mon, Sep 19, 2011 at 11:43:33PM +0200, Rafael J. Wysocki wrote:
> > > Hi,
> > > 
> > > Sorry for the delayed response, I was traveling during the last week too.
> > 
> > No worries. :)
> > 
> > > On Monday, September 12, 2011, Sarah Sharp wrote:
> > > > Hi Rafael,
> > > > 
> > > > As I mentioned at LPC, I have a USB host controller that is failing to
> > > > wakeup from D3 when a new USB device is connected to an external hub.
> > > > The system is in S0 at this point.
> > > > 
> > > > You mentioned that there were two ways for hardware to generate PMEs:
> > > > either through the standard PCI interrupt process, or via an ACPI SCI
> > > > call.
> > > > 
> > > > I think the hardware engineers want Linux to set up the PCI device to
> > > > generate PMEs via an SCI call, but I'm not sure if Linux is.  I've tried
> > > > turning on ACPI debugging (with level and layers both set to 0xffffffff
> > > > so I can see all debugging), and I don't see any output at all from ACPI
> > > > functions like acpi_ev_sci_xrupt_handler when the host controller comes
> > > > out of D3.  (It does come out of D3 if I plug in the device within 10
> > > > seconds of PCI suspend, for whatever reason.)
> > > > 
> > > > Is there a way to tell if SCI is being used by a PCI device to generate
> > > > PMEs?
> > > 
> > > Yes, there is.  First, if the native PCIe PME is used (which means SCI isn't),
> > > there will be entries like these in /proc/interrupts:
> > > 
> > >  40:          0          0   PCI-MSI-edge      PCIe PME
> > >  41:          0          0   PCI-MSI-edge      PCIe PME
> > >  42:          0          0   PCI-MSI-edge      PCIe PME
> > > 
> > > If they are not present, it means that the kernel is _trying_ to use SCI
> > > for PME signaling.  In that case, you can check if the number of ACPI
> > > interrupts in /proc/interrupts is increasing when you try to trigger the
> > > events.
> > 
> > Ok, here's what /proc/interrupts shows for my system:
> > 
> >            CPU0       CPU1       CPU2       CPU3       
> >   0:         28          0          0          0  IR-IO-APIC-edge      timer
> >   8:          1          0          0          0  IR-IO-APIC-edge      rtc0
> >   9:          0          0          0          0  IR-IO-APIC-fasteoi   acpi
> >  16:        795          0          0          0  IR-IO-APIC-fasteoi   ehci_hcd:usb1
> >  19:         16          0          0          0  IR-IO-APIC-fasteoi   firewire_ohci
> >  23:         34          0          0          0  IR-IO-APIC-fasteoi   ehci_hcd:usb2
> >  40:          0          0          0          0  DMAR_MSI-edge      dmar0
> >  42:       2931          0          0          0  IR-PCI-MSI-edge      eth7
> >  43:      13285          0          0          0  IR-PCI-MSI-edge      ahci
> >  44:          0          0          0          0  IR-PCI-MSI-edge      xhci_hcd
> >  45:        558          0          0          0  IR-PCI-MSI-edge      snd_hda_intel
> >  46:        235          0        204          0  IR-PCI-MSI-edge      snd_hda_intel
> >  47:        808          0          0          0  IR-PCI-MSI-edge      radeon
> > NMI:          0          0          0          0   Non-maskable interrupts
> > LOC:      14857      14209      44533      15822   Local timer interrupts
> > SPU:          0          0          0          0   Spurious interrupts
> > PMI:          0          0          0          0   Performance monitoring interrupts
> > IWI:          0          0          0          0   IRQ work interrupts
> > RES:      11671      13274       2835       4637   Rescheduling interrupts
> > CAL:        210        311        396        470   Function call interrupts
> > TLB:        287        242        135        296   TLB shootdowns
> > TRM:          0          0          0          0   Thermal event interrupts
> > THR:          0          0          0          0   Threshold APIC interrupts
> > MCE:          0          0          0          0   Machine check exceptions
> > MCP:          5          5          5          5   Machine check polls
> > ERR:          0
> > MIS:          0
> > 
> > I don't see any PCIe PME entries, so can I assume that ACPI is trying to use
> > SCI?
> 
> Yes.
> 
> > > In that case you can use the files under /sys/firmware/acpi/interrupts/
> > > to see what GPEs are activated by the wakeup events.
> > 
> > Ok, before I put the host controller into D3 by echoing auto to
> > /sys/bus/pci/devices/0000:00:14.0/power/control, catting those files in
> > /sys/firmware/acpi/interrupts/ shows all zeros (and some enabled GPEs).
> > 
> > After I enable runtime PM for the PCI device, wait for it to go into D3,
> > and then plug a new USB host controller into an external hub under xHCI,
> > I see the count in the file gpe0D increase:
> > 
> > sarah@talon:/sys/firmware/acpi/interrupts$ cat gpe0D
> >   645925   disabled
> 
> Well, apparently, the GPE is disabled, although it should be enabled
> at this point if it is supposed to be a wakeup GPE for the controller.
> 
> > But the host controller is never brought out of D3, and the port status
> > change events was never reported.  The dmesg from the run is attached,
> > with some additional debugging I added to the PCI and ACPI core.  The
> > part where the host controller first goes into D3 is on line 3521.
> > 
> > I'm starting to think that the ACPI tables for this platform are not
> > correct.  The BIOS guys haven't let me know whether wake from D3 is
> > actually supported by the BIOS yet (this platform is still under
> > development).  The disassembled ACPI tables are attached.
> 
> Without looking at the tables at the moment (I'll do that later),
> I think that they are missing the information that GPE 0D is a wakeup
> GPE for the xHCI device.

The DSDT appears to contain that information, so I'm not sure what's
going on.  Perhaps you can put a debug printk into acpi_dev_run_wake()
to see if that function is called for the xHCI controllers?

> > In digging through the ACPI code, I noticed that acpi_bus_get_flags()
> > looks for the ACPI methods _PR0 or _PS0 and sets
> > device->flags.power_manageable to 1 if either of those methods are
> > successfully invoked.  When I deassembled the ACPI tables, I didn't see
> > either method for any of the USB host controllers in the system.

However, the power_manageable flag only indicates that the device can
be put into low-power states through ACPI methods, it shouldn't have
any effect on the wakeup settings.

> > device->flags.power_manageable is checked later when the runtime PM
> > system attempts to put the PCI device into a lower state, but it seems
> > to be ignored?  Is it supposed to be ignored?
> 
> Hmm, not really.  I'll have a look at that later.

It is used to decide whether or not to call __acpi_bus_set_power(), AFAICS.
If it is not set, this function is not called, which is OK.  Still,
devices for which it is not set may be put into low-power states and may
generate wakeup signals.

For many PCI devices there are two possible power management interfaces,
the native one and the ACPI-based one.  All of the modern devices support
the native power management interface, so they can be put into low-power
states even if the ACPI-based interface is missing for them (which is the
case for your USB controllers).  For those devices, if the ACPI-based
interface is not present, we simply use the native one only.

As far as wakeup is concerned, we should enable them to generate PME
using the native interface and in addition to it we should use ACPI to
enable the wakeup GPEs that are supposed to be triggered in response to
the PME signals.

This apparently doesn't work correctly on your system and we need to figure
out why.

Thanks,
Rafael
