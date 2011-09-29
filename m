Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757799Ab1I2Vg6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Sep 2011 17:36:58 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:37997 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755728Ab1I2Vg5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Sep 2011 17:36:57 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Subject: Re: PME via interrupt or SCI mechanism?
Date: Thu, 29 Sep 2011 23:38:48 +0200
User-Agent: KMail/1.13.6 (Linux/3.1.0-rc8+; KDE/4.6.0; x86_64; ; )
Cc: linux-acpi@vger.kernel.org, linux-pci@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        Matthew Garrett <mjg59@srcf.ucam.org>
References: <20110912171003.GA7939@xanatos> <20110929204440.GA6043@xanatos> <201109292328.45375.rjw@sisk.pl>
In-Reply-To: <201109292328.45375.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201109292338.48690.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, September 29, 2011, Rafael J. Wysocki wrote:
> On Thursday, September 29, 2011, Sarah Sharp wrote:
> > On Thu, Sep 29, 2011 at 09:39:56PM +0200, Rafael J. Wysocki wrote:
> > > On Thursday, September 29, 2011, Sarah Sharp wrote:
> > > > On Thu, Sep 29, 2011 at 12:21:28AM +0200, Rafael J. Wysocki wrote:
> > > Please try the appended patch and check if you see the "Notification error
> > > for GPE" message (please keep your previous debug patches applied).
> > 
> > Do I need to have the ACPI debug_level or debug_layer set to anything in
> > particular to see this message?
> 
> No, I don't think so, but just in case please try the patch below instead
> of the previous one.

Actually, please don't, it's a BIOS-related issue after all.  Apparently,
wakeup from xHCD is not supported by the BIOS, because the DSDT defines
the _L0D method for GPE 0D (13), which is the following:

        Method (_L0D, 0, NotSerialized)
        {
            Notify (\_SB.PCI0.EHC1, 0x02)
            Notify (\_SB.PCI0.EHC2, 0x02)
            Notify (\_SB.PCI0.HDEF, 0x02)
            Notify (\_SB.PCI0.GLAN, 0x02)
        }

so it notifies some devices, but not the xHCD.

We might work around this by doing what Matthew has suggested (ie. polling
all PCI and PCIe devices to check if they have PME pending) or perhaps
we can do something about this in ACPICA.

Still, the right fix is to put Notify () for the ACPI objects
corresponding to xHCD into the above method.

Thanks,
Rafael
