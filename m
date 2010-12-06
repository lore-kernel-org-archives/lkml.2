Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754599Ab0LFUja (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Dec 2010 15:39:30 -0500
Received: from g6t0184.atlanta.hp.com ([15.193.32.61]:36500 "EHLO
	g6t0184.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753060Ab0LFUj3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Dec 2010 15:39:29 -0500
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Jiri Slaby <jirislaby@gmail.com>
Subject: Re: resource map sanity check conflict
Date: Mon, 6 Dec 2010 13:34:56 -0700
User-Agent: KMail/1.13.2 (Linux/2.6.32-25-generic; KDE/4.4.2; x86_64; ; )
Cc: David Airlie <airlied@linux.ie>, LKML <linux-kernel@vger.kernel.org>,
        abelay@mit.edu, Chris Wilson <chris@chris-wilson.co.uk>,
        Thomas Renninger <trenn@suse.de>
References: <4CED14C1.4050703@suse.cz> <201011241222.06749.bjorn.helgaas@hp.com> <4CFD44DD.3070901@gmail.com>
In-Reply-To: <4CFD44DD.3070901@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Message-Id: <201012061334.57246.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, December 06, 2010 01:17:33 pm Jiri Slaby wrote:
> On 11/24/2010 08:22 PM, Bjorn Helgaas wrote:
> > On Wednesday, November 24, 2010 06:36:01 am Jiri Slaby wrote:
> >> Hi,
> >>
> >> with 2.6.37-rc2 with some unrelated patches the following WARNING is
> >> generated:
> >>
> >> pnp 00:0a: [mem 0xfed40000-0xfed44fff]
> >> pnp 00:0a: Plug and Play ACPI device, IDs ATM1200 PNP0c31 (active)
> >> ...
> >> resource map sanity check conflict: 0xfed40000 0xfed44fff 0xfed44000
> >> 0xfed44fff Intel Flush Page
> >> ------------[ cut here ]------------
> >> WARNING: at arch/x86/mm/ioremap.c:98 __ioremap_caller+0x353/0x380()
> >> ...
> > 
> >> /proc/iomem:
> >> fed1c000-fed8ffff : reserved
> >>   fed1c000-fed1ffff : pnp 00:02
> >>   fed40000-fed4bfff : PCI Bus 0000:00
> >>     fed44000-fed44fff : Intel Flush Page
> >>     fed45000-fed4bfff : pnp 00:02
> >>
> >>
> >> Is it a result of the past resource handling rewrote?
> >>
> >> It seems like pci_bus_alloc_resource in
> >> intel_alloc_chipset_flush_resource chooses a weird place to put the
> >> mapping in.
> > 
> > Yes, this is related to the PCI resource changes I made recently.
> > We used to allocate PCI resources from low addresses first and work
> > upwards, and now we do the reverse.  So in 2.6.36, the "Intel Flush
> > Page" was probably allocated low in the [mem 0x7e000000-0xfebfffff]
> > window, but now we put it in the [mem 0xfed40000-0xfed4bfff] window:
> > 
> >   pci_root PNP0A08:00: host bridge window [mem 0x000dc000-0x000dffff]
> >   pci_root PNP0A08:00: host bridge window [mem 0xfed40000-0xfed4bfff]
> > 
> > I think the problem is that we ignore most of what ACPI tells us
> > about motherboard device resource usage.  We do have the "system"
> > driver, which reserves resources used by PNP0c01 and PNP0c02 devices,
> > but we don't do anything about other devices like the ATM1200/PNP0c31
> > device which, in your case, is using some of the space in that
> > [mem 0xfed40000-0xfed4bfff] host bridge window.
> > 
> > I've been worried that this would bite us eventually, and I tried to
> > reserve all the ACPI resources in the PNP core a couple years ago,
> > but we had to revert that because it caused other problems.  I still
> > think it's something we need to do after we straighten out the issues.
> > 
> >> dmesg:
> >> https://bugzillafiles.novell.org/attachment.cgi?id=401414
> >> lspci -vvnnxxx:
> >> https://bugzillafiles.novell.org/attachment.cgi?id=401643
> >> /proc/iomem:
> >> https://bugzillafiles.novell.org/attachment.cgi?id=401476
> > 
> > Is there a kernel.org bugzilla about this?  If not, could you open one
> > and assign it to me?
> 
> I created the bko entry some time ago:
> https://bugzilla.kernel.org/show_bug.cgi?id=23802
> 
> Any chance you will take a look?

I will take a look, and in fact, I'm working on these:
  https://bugzilla.kernel.org/show_bug.cgi?id=23542
  https://bugzilla.kernel.org/show_bug.cgi?id=23332

and the fix I'm contemplating should also apply to 23802.

Bjorn
