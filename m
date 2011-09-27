Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753532Ab1I0Uwh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Sep 2011 16:52:37 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:59945 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752278Ab1I0Uwf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Sep 2011 16:52:35 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Subject: Re: PME via interrupt or SCI mechanism?
Date: Tue, 27 Sep 2011 22:54:47 +0200
User-Agent: KMail/1.13.6 (Linux/3.1.0-rc4+; KDE/4.6.0; x86_64; ; )
Cc: linux-acpi@vger.kernel.org, linux-pci@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
References: <20110912171003.GA7939@xanatos> <201109270020.26439.rjw@sisk.pl> <20110926234835.GA9551@xanatos>
In-Reply-To: <20110926234835.GA9551@xanatos>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Message-Id: <201109272254.47232.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, September 27, 2011, Sarah Sharp wrote:
> On Tue, Sep 27, 2011 at 12:20:26AM +0200, Rafael J. Wysocki wrote:
> > On Sunday, September 25, 2011, Rafael J. Wysocki wrote:
> > > On Thursday, September 22, 2011, Sarah Sharp wrote:
> > > > On Mon, Sep 19, 2011 at 11:43:33PM +0200, Rafael J. Wysocki wrote:
> > > Without looking at the tables at the moment (I'll do that later),
> > > I think that they are missing the information that GPE 0D is a wakeup
> > > GPE for the xHCI device.
> > 
> > The DSDT appears to contain that information, so I'm not sure what's
> > going on.  Perhaps you can put a debug printk into acpi_dev_run_wake()
> > to see if that function is called for the xHCI controllers?
> 
> I put a printk in acpi_dev_run_wake(), and that shows up in the original
> dmesg I sent:
> 
> Sep 22 10:47:09 talon kernel: [ 2026.211933] xhci_hcd 0000:00:14.0: acpi_pci_run_wake - enable dev wake
> Sep 22 10:47:09 talon kernel: [ 2026.211936] acpi device:34: acpi_dev_run_wake - enable dev wake
> Sep 22 10:47:09 talon kernel: [ 2026.211955] acpi device:34: acpi_dev_run_wake - return -19

OK, can you printk() dev->wakeup.gpe_number here?

[/me realizes that "error" is not really used in this function.  Bah.]

> The patch I've been using for adding debugging to the PCI and ACPI code
> is attached.  I've been adding printks willy-nilly to try to understand
> what's going on.

That's fine.

> > > > In digging through the ACPI code, I noticed that acpi_bus_get_flags()
> > > > looks for the ACPI methods _PR0 or _PS0 and sets
> > > > device->flags.power_manageable to 1 if either of those methods are
> > > > successfully invoked.  When I deassembled the ACPI tables, I didn't see
> > > > either method for any of the USB host controllers in the system.
> > 
> > However, the power_manageable flag only indicates that the device can
> > be put into low-power states through ACPI methods, it shouldn't have
> > any effect on the wakeup settings.
> 
> Ok, good to know.
> 
> > > > device->flags.power_manageable is checked later when the runtime PM
> > > > system attempts to put the PCI device into a lower state, but it seems
> > > > to be ignored?  Is it supposed to be ignored?
> > > 
> > > Hmm, not really.  I'll have a look at that later.
> > 
> > It is used to decide whether or not to call __acpi_bus_set_power(), AFAICS.
> > If it is not set, this function is not called, which is OK.  Still,
> > devices for which it is not set may be put into low-power states and may
> > generate wakeup signals.
> > 
> > For many PCI devices there are two possible power management interfaces,
> > the native one and the ACPI-based one.  All of the modern devices support
> > the native power management interface, so they can be put into low-power
> > states even if the ACPI-based interface is missing for them (which is the
> > case for your USB controllers).  For those devices, if the ACPI-based
> > interface is not present, we simply use the native one only.
> 
> So if I understand you correctly, the kernel can use the native PCI power
> management interface to put the PCI device into a lower power state...
> 
> > As far as wakeup is concerned, we should enable them to generate PME
> > using the native interface and in addition to it we should use ACPI to
> > enable the wakeup GPEs that are supposed to be triggered in response to
> > the PME signals.
> 
> ...but the kernel ACPI core will still be watching for the SCI that the
> firmware generates on a PME wakeup?  Correct?

Yes, it should work like this.

> Is the native PCI power management interface you're referring to
> implemented through the PCIe PME driver?

No, this is what pci_raw_set_power_state() does.

> Because this particular host controller is a PCIe device, not a PCI device.

Well, PCIe is PCI to some extent. :-)

> I added some debug statements to drivers/pci/pcie/pme.c, but the dmesg shows
> that none of them got called.

This one only handles the native PME signaling, which is a PCIe feature
(instead of using ACPI GPEs for that, it signals PME via interrupts from
Root Ports).  Of course, it only works if you have those "PCIe PME" entries
in /proc/interrupts.

> > This apparently doesn't work correctly on your system and we need to figure
> > out why.
> 
> Ok.  Do you have suggestions for any tests I can run or debugging
> statements to add?  I'm really not an ACPI expert and I've been
> basically fumbling in the dark.

Yes, please see above.  I need to know the number of the GPE it tries to
enable for the USB controller.

Thanks,
Rafael
