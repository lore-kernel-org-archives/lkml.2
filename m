Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757563Ab1I3QiK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Sep 2011 12:38:10 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:39929 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754278Ab1I3QiH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Sep 2011 12:38:07 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Subject: Re: PME via interrupt or SCI mechanism?
Date: Fri, 30 Sep 2011 18:40:20 +0200
User-Agent: KMail/1.13.6 (Linux/3.1.0-rc8+; KDE/4.6.0; x86_64; ; )
Cc: linux-acpi@vger.kernel.org, linux-pci@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        Matthew Garrett <mjg59@srcf.ucam.org>
References: <20110912171003.GA7939@xanatos> <201109292351.50176.rjw@sisk.pl> <20110929225700.GA6207@xanatos>
In-Reply-To: <20110929225700.GA6207@xanatos>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Message-Id: <201109301840.20402.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, September 30, 2011, Sarah Sharp wrote:
> On Thu, Sep 29, 2011 at 11:51:49PM +0200, Rafael J. Wysocki wrote:
> > On Thursday, September 29, 2011, Rafael J. Wysocki wrote:
> > > On Thursday, September 29, 2011, Rafael J. Wysocki wrote:
> > > > On Thursday, September 29, 2011, Sarah Sharp wrote:
> > > > > On Thu, Sep 29, 2011 at 09:39:56PM +0200, Rafael J. Wysocki wrote:
> > > > > > On Thursday, September 29, 2011, Sarah Sharp wrote:
> > > > > > > On Thu, Sep 29, 2011 at 12:21:28AM +0200, Rafael J. Wysocki wrote:
> > > > > > Please try the appended patch and check if you see the "Notification error
> > > > > > for GPE" message (please keep your previous debug patches applied).
> > > > > 
> > > > > Do I need to have the ACPI debug_level or debug_layer set to anything in
> > > > > particular to see this message?
> > > > 
> > > > No, I don't think so, but just in case please try the patch below instead
> > > > of the previous one.
> > > 
> > > Actually, please don't, it's a BIOS-related issue after all.  Apparently,
> > > wakeup from xHCD is not supported by the BIOS, because the DSDT defines
> > > the _L0D method for GPE 0D (13), which is the following:
> > > 
> > >         Method (_L0D, 0, NotSerialized)
> > >         {
> > >             Notify (\_SB.PCI0.EHC1, 0x02)
> > >             Notify (\_SB.PCI0.EHC2, 0x02)
> > >             Notify (\_SB.PCI0.HDEF, 0x02)
> > >             Notify (\_SB.PCI0.GLAN, 0x02)
> > >         }
> > > 
> > > so it notifies some devices, but not the xHCD.
> 
> Ok, I'll let our BIOS guys know they need to add the XHC Notify line.

As stated below, it actually may be better to remove the _L0D method
entirely, because our ACPICA GPE handling code should take care of
notifying all of the devices associated with GPE 0D in that case.

> I should see if the x220 ACPI tables have a similar issue or it's a
> different issue with D3.

Yes, that would be good to know.

> > > We might work around this by doing what Matthew has suggested (ie. polling
> > > all PCI and PCIe devices to check if they have PME pending) or perhaps
> > > we can do something about this in ACPICA.
> > > 
> > > Still, the right fix is to put Notify () for the ACPI objects
> > > corresponding to xHCD into the above method.
> > 
> > Or to remove this method altogether (in which case our ACPICA code
> > should take care of the notifications).
> > 
> > Below is a patch (untested!) that should help, but it's kind of
> > suboptimal.  Nevertheless, please try if it works for you.
> 
> The patch seems to finally get the host controller out of D3 when a
> remote wakeup is triggered.

OK

I'll try to prepare a better patch for you to test.

> I still see a lot of log spam from pci_acpi_wake_dev being called for ehci,
> e1000e, and snd_hcda_intel, but eventually the xHCI host gets put in D0.
> dmesg attached.

That's to be expected.  All of the devices mentioned in the _L0D method
above will be notified every time any of devices associated with GPE 0D
sends a PME message to the Root Complex, which happens quite often
while the polling used to check the PME bits is done only every second.

Thanks,
Rafael
