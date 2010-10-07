Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751598Ab0JHCzU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Oct 2010 22:55:20 -0400
Received: from g4t0016.houston.hp.com ([15.201.24.19]:32992 "EHLO
	g4t0016.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751070Ab0JHCzT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Oct 2010 22:55:19 -0400
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Ram Pai <linuxram@us.ibm.com>
Subject: Re: [RFC v2 PATCH 1/1] PCI: override BIOS/firmware resource allocation
Date: Thu, 7 Oct 2010 15:41:04 -0600
User-Agent: KMail/1.13.2 (Linux/2.6.32-25-generic; KDE/4.4.2; x86_64; ; )
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        clemens@ladisch.de, Yinghai Lu <yinghai@kernel.org>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
References: <20101006225834.GE2945@ram-laptop> <20101007041302.GA19867@helgaas.com> <20101007204213.GA4461@ram-laptop>
In-Reply-To: <20101007204213.GA4461@ram-laptop>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201010071541.07084.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, October 07, 2010 02:42:13 pm Ram Pai wrote:
> On Wed, Oct 06, 2010 at 10:13:02PM -0600, Bjorn Helgaas wrote:
> > On Wed, Oct 06, 2010 at 05:30:41PM -0700, Ram Pai wrote:
> > > On Wed, Oct 06, 2010 at 05:39:53PM -0600, Bjorn Helgaas wrote:
> > > > On Wed, Oct 06, 2010 at 03:58:34PM -0700, Ram Pai wrote:
> > > > >         PCI: override BIOS/firmware memory resource allocation
> > > > > 		through command line parameters
> > > > > 
> > > > > 	Platforms that are unaware of  SRIOV  BARs  fail to allocate MMIO
> > > > > 	resources  to SRIOV PCIe  devices. Hence  on  such  platforms the
> > > > > 	OS fails to  enable  SRIOV.
> > > > > 	Some  platforms  where  BIOS/uEFI resource   allocations  conflict
> > > > > 	the conflicting devices are disabled.
> > > > > 
> > > > > 	Ideally we  would  want  the  OS  to detect and fix automatically
> > > > > 	such problems and conflicts.  However previous  attempts to do so
> > > > > 	have led to regression on legacy platforms.
> > > > 
> > > > I'm sorry to be a nay-sayer, but I think we just haven't tried hard
> > > > enough.  Our ACPI/PCI/e820 resource management is not well integrated,
> > > > and I suspect if we straightened that out, we could avoid some of the
> > > > regressions we saw with previous attempts.
> > > 
> > > Can you be more specific as to what can be done to fix it automatically?
> > > 
> > > Neither accepting this approach nor telling what needs to be straightened out
> > > to automatically fix all the systems out there, is just a deadend.
> > 
> > Yeah, I guess that wasn't really fair, sorry.  And keep in mind that I'm
> > not the PCI maintainer, so these are just my opinions, nothing like an
> > official "nack."
> > 
> > I did look at this dmesg log from the thread you referenced:
> >     http://marc.info/?l=linux-kernel&m=127178918128740&w=2
> > but it looks to me like we just completely botched it.  I don't see an
> > SRIOV device or anything else that didn't have resources, so as far as I
> > can tell, we started with working resource assignments from the BIOS,
> > threw them away, and started over from scratch.  We failed because we
> > tried to assign I/O port space to bridges with nothing behind them, and
> > there was nothing left by the time we got to the 0000:09:04.0 device
> > that actually *did* need the space.
> 
> hmm.. is that possible? Yinghai's patch sized the resource requirement of each
> of the bridges, before actually allocating them. Which means a bridge with
> no device behind it would not get any i/o space.

Here's what I see in the dmesg log referenced above:

    ACPI: PCI Root Bridge [PCI0] (0000:00)
    pci_root PNP0A08:00: host bridge window [io 0x0000-0x0cf7]
    pci_root PNP0A08:00: host bridge window [io 0x0d00-0xffff]
    pci 0000:00:1c.0: PCI bridge to [bus 04-09]
    pci 0000:00:1c.0:   bridge window [io 0xd000-0xdfff]
    pci 0000:04:00.0: PCI bridge to [bus 05-09]
    pci 0000:04:00.0:   bridge window [io 0xd000-0xdfff]
    pci 0000:05:01.0: PCI bridge to [bus 08-09]
    pci 0000:05:01.0:   bridge window [io 0xd000-0xdfff]
    pci 0000:08:00.0: PCI bridge to [bus 09-09]
    pci 0000:08:00.0:   bridge window [io 0xd000-0xdfff]
    pci 0000:09:04.0: found [13f6:8788] class 000401 header type 00
    pci 0000:09:04.0: reg 10: [io  0xd800-0xd8ff]
    pci 0000:05:02.0: PCI bridge to [bus 07-07]
    pci 0000:05:02.0:   bridge window [io 0xf000-0x0000] (disabled)
    pci 0000:05:03.0: PCI bridge to [bus 06-06]
    pci 0000:05:03.0:   bridge window [io 0xf000-0x0000] (disabled)
    
The above is the state as we got it from BIOS.  Despite all the bridges,
09:04.0 is the only device below the 00:1c.0 bridge, and it requires only
0x100 I/O ports.

There are no devices on buses 06 (below 05:03.0) or 07 (below 05:02.0).

I didn't look at Yinghai's patch to figure out *why*, but it sure looks like
we released the 09:04.0 space, then tried to assign 0x2000 ports to 05:01.0 
(which needs 0x100 and had 0x1000 originally), 0x1000 to 05:02.0 (which needs
none), and 0x1000 to 05:03.0 (which also needs none):

    PCI: No. 3 try to assign unassigned res
    release child resource [io  0xd800-0xd8ff]
    pci 0000:08:00.0: resource 7 [io 0xd000-0xdfff] released
    pci 0000:04:00.0: BAR 7: can't assign io (size 0x4000)
    pci 0000:05:01.0: BAR 7: can't assign io (size 0x2000)
    pci 0000:05:02.0: BAR 7: can't assign io (size 0x1000)
    pci 0000:05:03.0: BAR 7: can't assign io (size 0x1000)
    pci 0000:08:00.0: BAR 7: can't assign io (size 0x1000)
    pci 0000:09:04.0: BAR 0: can't assign io (size 0x100)
    
I think there are at least two things wrong here:

  1) We rearranged things when we didn't need to, and
  2) We assigned I/O ports to bridge that didn't need them

Neither one is a terrible problem, so I think it's better to just fix
them than to add a special alternate path and a kernel parameter to
enable it.

> > > The choice is between
> > > 	(a) an automated patch with the risk of regressing some platforms.
> > > 	(b) an semi-automated patch that does not regress *any* platform,
> > > 		with the ability to fix platforms that are currently broken.
> > > 	(c) status quo, which means broken platforms continue to be so.
> > > 
> > > I thought the initial proposal was to use (b), with the long
> > > term goal of fixing it automatically, assuming that it is even possible.
> > > 
> > > Let me know if that is *not* the goal and I will change directions.
> > 
> > *My* goal is that a user would never need a kernel option except to help
> > debug kernel problems.  I think of an option like "pci=override" as a
> > band-aid that covers up a kernel problem without really fixing it, so I
> > guess my choice would be (a).  Yes, there's a risk of regression, and we
> > have to do everything we can to avoid it.  But the result is a more
> > usable system.
> 
> Ok. I think we agree with your goal, but the disagreement is on the approach.
> You want to take one big leap, whereas the consensus  I heard in earlier 
> threads was that we need to take baby steps.

We need baby steps in terms of a series of tiny patches.  I'm not yet
convinced that we need to add a "mostly-working" alternate path and
make the user figure out whether to use it.  That makes things more
complicated and reduces testing coverage.

Bjorn
