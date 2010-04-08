Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755868Ab0DHDY3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Apr 2010 23:24:29 -0400
Received: from g1t0027.austin.hp.com ([15.216.28.34]:24121 "EHLO
	g1t0027.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755395Ab0DHDY1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Apr 2010 23:24:27 -0400
Subject: Re: [PATCH] x86: Reserve legacy VGA MMIO area for x86_64 as well
	as x86_32
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Yinghai <yinghai.lu@oracle.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@redhat.com>, linux-pci@vger.kernel.org,
       x86@kernel.org, linux-kernel@vger.kernel.org,
       Andy Isaacson <adi@hexapodia.org>, Thomas Renninger <trenn@suse.de>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
In-Reply-To: <4BBD13C3.2060404@oracle.com>
References: <20100407210628.28364.96982.stgit@bob.kio>
	 <4BBD0B0A.3090702@oracle.com> <201004071705.07176.bjorn.helgaas@hp.com>
	 <4BBD13C3.2060404@oracle.com>
Content-Type: text/plain
Date: Wed, 07 Apr 2010 21:24:14 -0600
Message-Id: <1270697054.25226.16.camel@dc7800.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-04-07 at 16:22 -0700, Yinghai wrote:
> On 04/07/2010 04:05 PM, Bjorn Helgaas wrote:
> > On Wednesday 07 April 2010 04:45:30 pm Yinghai wrote:
> >> On 04/07/2010 02:06 PM, Bjorn Helgaas wrote:
> >>>
> >>> Currently, we only reserve the legacy VGA area [mem 0xa0000-0xbffff] on
> >>> x86_32.  But this legacy area is also used on x86_64, so this patch
> >>> reserves it there, too.
> >>>
> >>> If we don't reserve it, we may mistakenly move a PCI device to that area,
> >>> as we did here:
> >>>
> >>>   pci_root PNP0A03:00: host bridge window [mem 0xff980800-0xff980bff]
> >>>   pci_root PNP0A03:00: host bridge window [mem 0xff97c000-0xff97ffff]
> >>>   pci 0000:00:1f.2: no compatible bridge window for [mem 0xff970000-0xff9707ff]
> >>>   pci 0000:00:1f.2: BAR 5: assigned [mem 0x000a0000-0x000a07ff]
> >>>
> >>> as reported by Andy Isaacson at http://lkml.org/lkml/2010/4/6/375
> >>>
> >>> I think the fact that the BAR is not within a host bridge window is a
> >>> BIOS defect, and it's now more visible because we have "pci=use_crs" as
> >>> the default.  Using "pci=nocrs" is a workaround, because then we won't
> >>> attempt to move the device.
> >>
> >> that doesn't look right.
> >>
> >> It seem another thread, erission has one model without VGA, and they use that area for other device MMIO.
> >>
> >> current for 64bit, We remove [0xa0000, 0x100000) from e820 map if those area is E820_RAM.
> >>
> >> in e820_reserve_resources(), kernel will reserve range < 1M according to e820 map.
> >> that is before pci BAR is claimed.
> >>
> >> or you can add
> >> boot_params.screen_info.orig_video_isVGA == 1
> >> or double check scan pci tree to see if video is there or not
> > 
> > I'm sorry, I can't understand what you're saying.
> 
> for 64 bit, you may check boot_params.screen_info.orig_video_isVGA to see if you need to reserve that VGA range.
> not sure if every bootloader fill that...

If you're saying that on x86_64, you have a reliable way to determine
whether to reserve the legacy VGA MMIO area, I hope you'll provide a
patch, because I don't know about this sort of x86_32 vs x86_64
difference.

I actually did propose doing something in pci_setup_device(), similar to
what we already do for legacy IDE resources, but HPA thought it should
be done in the arch code instead, again for reasons I don't completely
understand.

> when the system only have one peer root bus, can you skip the _CRS for it?

That's ugly.  When we discover the first host bridge, we have no idea
whether there will be more.  I don't want to mess around with trying to
count the number of bridges, then go back and add them in another pass.

I think it's fairly clear from http://lkml.org/lkml/2010/4/7/284 that
Windows is paying attention the _CRS, even though there's only one host
bridge.  So we ought to be able to make it work, too.

This is not a problem with pci=use_crs.  This is only a problem because
we don't reserve the VGA area when we should.  That's the problem we
should fix.

Bjorn


