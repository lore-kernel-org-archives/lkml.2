Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932830Ab0EMUDm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 May 2010 16:03:42 -0400
Received: from g5t0006.atlanta.hp.com ([15.192.0.43]:48375 "EHLO
	g5t0006.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932805Ab0EMUD0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 May 2010 16:03:26 -0400
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Mike Habeck <habeck@sgi.com>
Subject: Re: [Patch 1/1] x86 pci: Add option to not assign BAR's if not already assigned
Date: Thu, 13 May 2010 14:02:30 -0600
User-Agent: KMail/1.13.2 (Linux/2.6.32-22-generic; KDE/4.4.2; x86_64; ; )
Cc: Mike Travis <travis@sgi.com>, Ingo Molnar <mingo@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       x86@kernel.org, Jesse Barnes <jbarnes@virtuousgeek.org>,
       Jacob Pan <jacob.jun.pan@intel.com>, Tejun Heo <tj@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>, Yinghai <yinghai.lu@oracle.com>,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
       Myron Stowe <myron.stowe@hp.com>
References: <4BEAF008.9030805@sgi.com> <201005131256.17997.bjorn.helgaas@hp.com> <4BEC5530.1000008@sgi.com>
In-Reply-To: <4BEC5530.1000008@sgi.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201005131402.30759.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, May 13, 2010 01:38:24 pm Mike Habeck wrote:
> Bjorn Helgaas wrote:
> > On Wednesday, May 12, 2010 12:14:32 pm Mike Travis wrote:
> >> Subject: [Patch 1/1] x86 pci: Add option to not assign BAR's if not already assigned
> >> From: Mike Habeck <habeck@sgi.com>
> >>
> >> The Linux kernel assigns BARs that a BIOS did not assign, most likely
> >> to handle broken BIOSes that didn't enumerate the devices correctly.
> >> On UV the BIOS purposely doesn't assign I/O BARs for certain devices/
> >> drivers we know don't use them (examples, LSI SAS, Qlogic FC, ...).
> >> We purposely don't assign these I/O BARs because I/O Space is a very
> >> limited resource.  There is only 64k of I/O Space, and in a PCIe
> >> topology that space gets divided up into 4k chucks (this is due to
> >> the fact that a pci-to-pci bridge's I/O decoder is aligned at 4k)...
> >> Thus a system can have at most 16 cards with I/O BARs: (64k / 4k = 16)
> >>
> >> SGI needs to scale to >16 devices with I/O BARs.  So by not assigning
> >> I/O BARs on devices we know don't use them, we can do that (iff the
> >> kernel doesn't go and assign these BARs that the BIOS purposely didn't
> >> assign).
> > 
> > I don't quite understand this part.  If you boot with "pci=nobar",
> > the BIOS doesn't assign BARs, Linux doesn't either, the drivers
> > don't need them -- everything works, and that makes sense so far.
> > 
> > Now, if you boot normally (without "pci=nobar"), what changes?
> > The BIOS situation is the same, but Linux tries to assign the
> > unassigned BARs.  It may assign a few before running out of space,
> > but the drivers still don't need those BARs.  What breaks?
> 
> Nothing really breaks, it's more of a problem that the kernel uses
> up the rest of the I/O Space, and starts spitting out warning
> messages as it tries to assign the rest of the I/O BARs that the
> BIOS didn't assign, something like:
> 
>    pci 0010:03:00.0: BAR 5: can't allocate I/O resource [0x0-0x7f]
>    pci 0012:05:00.0: BAR 5: can't allocate I/O resource [0x0-0x7f]
>    ...

OK, that's what I would expect.  Personally, I think I'd *like*
to have those messages.  If 0010:03:00.0 is a device whose driver
depends on I/O space, the message will be a good clue as to why
the driver isn't working.

> And in using up all the I/O space, I think that could prevent a
> hotplug attach of a pci device requiring I/O space (although I
> believe most BIOSes pad the bridge decoders to support that).
> I'm not to familiar with how pci hotplug works on x86 so I may
> be wrong in what I just stated.

Yep, that's definitely a problem, and I don't have a good solution.

HP (and probably SGI) had a nice hardware solution for ia64 --
address translation across the host bridge, so each bridge could
have its own 64K I/O space.  But I don't see that coming in the
x86 PC arena.

> > This issue is not specific to x86, so I don't really like having
> > the implementation be x86-specific.
> 
> I agree this isn't a x86 specific issue but given the 'norom'
> cmdline option is basically doing the same thing (but for pci
> Expansion ROM BARs) this code was modeled after it.

IMHO, we should fix both.

Bjorn
