Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932800Ab0FBQlF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jun 2010 12:41:05 -0400
Received: from g1t0027.austin.hp.com ([15.216.28.34]:19147 "EHLO
	g1t0027.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752875Ab0FBQlC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jun 2010 12:41:02 -0400
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Mike Habeck <habeck@sgi.com>
Subject: Re: [Patch 1/1] x86 pci: Add option to not assign BAR's if not already assigned
Date: Wed, 2 Jun 2010 10:40:38 -0600
User-Agent: KMail/1.13.2 (Linux/2.6.32-22-generic; KDE/4.4.2; x86_64; ; )
Cc: Mike Travis <travis@sgi.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
       x86@kernel.org, Jesse Barnes <jbarnes@virtuousgeek.org>,
       Jacob Pan <jacob.jun.pan@intel.com>, Tejun Heo <tj@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>, linux-pci@vger.kernel.org
References: <4BEAF008.9030805@sgi.com> <201006011649.56074.bjorn.helgaas@hp.com> <4C067E73.2010005@sgi.com>
In-Reply-To: <4C067E73.2010005@sgi.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201006021040.39378.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, June 02, 2010 09:53:23 am Mike Habeck wrote:
> Bjorn Helgaas wrote:
> > I'm still having trouble reconciling the stated purpose, i.e., the
> > changelog, with the behavior.  The changelog implies that the patch
> > is required to make >16 devices with I/O BARs work at all, but per
> > Mike Habeck, the patch just gets rid of some warnings and maybe helps
> > with hot-add of devices using I/O space.
> 
> greaterthan 16 devices will still work if the BIOS doesn't assign
> the I/O BARs and the kernel does (including the devices that don't
> get assigned due to the kernel running out of I/O Port resources).
> And when the kernel runs out of I/O Port space it will warn for
> those devices it couldn't assign: (example):
> 
>    pci 0002:03:00.0: BAR 5: can't allocate I/O resource [0x0-0x7f]

[For anybody else grepping for this message, it is now "can't assign",
not "can't allocate".]

> But if the kernel assigns all the I/O Port space to these devices
> we know don't need it (thus the reason the BIOS didn't assign it)
> then I believe hot-add of devices using I/O space will fail.

Yes, I understand and agree with this motivation, though I hope
"pci=nobar" is recognized as only a short-term workaround.  I think
it's completely unacceptable in terms of the user experience.  Using
DMI quirks to turn it on automatically removes some user pain, but
it's not a real solution and still leaves a maintenance problem.

How about if we write a changelog that mentions hot-add of devices
that need I/O space?  :-)

> There is also the issue that quirk_system_pci_resources() thinks
> those unassigned I/O resources are using I/O port space 0x0-0xFF.
> Since the BIOS never assigned the BAR the kernel reads it as
> having a base of 0x0 and a limit of whatever the BAR size is when
> it writes all 1's to obtain the size.  So that results in
> quirk_system_pci_resources() disabling pnp devices: (example):
> 
>    pnp 00:11: io resource (0x92-0x92) overlaps 0002:03:00.0 BAR 0 (0x0-0xff), disabling
[...]
> 
> One could argue this is a quirk_system_pci_resources() issue and
> should be handled there rather than "zeroing out the resource if
> the bios didn't assign it" as the patch does, but what the patch
> is attempting to do (as stated above) is to allow the BIOS a way
> to not assign resources it knows are not needed and thus make sure
> the kernel doesn't override that... and in doing that the quirk
> issue goes away too.

This is definitely a problem, but I think it should be handled
separately.  The fact that this patch makes the "overlap" messages
go away is a nice coincidence, but it doesn't fix the underlying
issue.

I think setting the resource start/end to zero to "disable" it as in
this patch (and elsewhere) is just a hack -- we no longer know the size
of the BAR, the struct resource no longer corresponds to the BAR contents,
and I don't think we do anything with the PCI_COMMAND_IO/PCI_COMMAND_MEM
bits to actually disable the BAR, so the device probably still responds
at whatever we left in the BAR.

In quirk_system_pci_resources(), we set IORESOURCE_DISABLED rather than
setting the PNP resource start/end to zero, but that's a bit of a hack,
too.  All that does is prevent the PNP motherboard driver (pnp/system.c)
from requesting that region.  We don't actually do anything to stop the
device from responding to that address.

Bjorn
