Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754726Ab1AUSB5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jan 2011 13:01:57 -0500
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:60387 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753824Ab1AUSBy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jan 2011 13:01:54 -0500
Date: Fri, 21 Jan 2011 19:01:38 +0100
From: Borislav Petkov <bp@amd64.org>
To: Tim Hockin <thockin@hockin.org>
Cc: Mike Waychison <mikew@google.com>, Ingo Molnar <mingo@elte.hu>,
        huang ying <huang.ying.caritas@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Huang Ying <ying.huang@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andi Kleen <andi@firstfloor.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Chris Mason <chris.mason@oracle.com>, Borislav Petkov <bp@alien8.de>,
        Robert Lippert <rlippert@google.com>
Subject: Re: [PATCH -v10 0/4] Lock-less list
Message-ID: <20110121180138.GA2582@kryptos.osrc.amd.com>
References: <20110119165247.cca2f434.akpm@linux-foundation.org>
 <1295520247.28776.152.camel@laptop>
 <AANLkTimR6xd1PxCP6jmuNwFkANrGPdTf2wpiGsBXGpKx@mail.gmail.com>
 <1295522876.28776.158.camel@laptop>
 <AANLkTin3_NuGG_E0Juy7=1Q7PcMJ6id1ZU-Gngfp_=dg@mail.gmail.com>
 <20110120121455.GA7680@elte.hu>
 <AANLkTikv3h_QoHs4uj6CNJdC7tb_-e0osKa47KWEJvFV@mail.gmail.com>
 <20110120130625.GA14436@elte.hu>
 <4D38BCFA.8050609@google.com>
 <AANLkTinbnJCWbtJWQPC7dYqTZGJWTS_mPCk-MnrNetXd@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTinbnJCWbtJWQPC7dYqTZGJWTS_mPCk-MnrNetXd@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 21, 2011 at 09:39:34AM -0800, Tim Hockin wrote:
> >> Of course, that's why the upstream EDAC code uses printk too. In fact it
> >> does all
> >> sorts of in-kernel decoding to make the printk output more useful - the
> >> /dev/mcelog
> >> method of pushing all decoding to user-space is fundamentally flawed.
> 
> EDAC is fundamentally flawed and we don't use it any more.  It strips
> off so much information that we can't actually figure out what
> happened to the level we want.  We do it in userspace now.

Well, you better make sure to tell me what information you need reported
and I'll try to get it fixed :) Currently, we can decode all MCEs in the
kernel and when the MCE is reporting a DRAM ECC error we can get you the
chip select it resulted from with EDAC.

We can also get you the bank, row and column from which the error
originates (could be added easily to amd64_edac.c).

[..]

> > It's also very ignorant to assume that the kernel knows everything about the
> > system and is capable of decoding errors to the satisfaction of userland.
> >  As Duncan Laurie pointed out (https://lkml.org/lkml/2011/1/11/390) we care
> > about not only the physical address, but which stick and which dimm *chip*
> > on the stick is having problems.  In-kernel abstractions  break down due to
> > the following:
> 
> This.  Andi was trying to use DMI tables to decode physical address to
> DIMMs, but I'll tell you this: I have yet to see a platform that has
> THAT MUCH information in the DMI tables and have it be *correct*.

and yes, there's not a fool-proof and generic way to tell which chip
select on the system points at which DIMM. And excuse me, but I really
really think that reading i2c devices and decyphering SPD ROM info from
them is still not the optimal solution - it should be easier and more
transparent than that. But guess what, this might change...

> >   * The kernel couldn't possible know how my i2c busses are setup and the
> > SPD EEPROMs are related to the physical memory abstraction that the bios
> > sets up for me.  I don't know of any standard way to have the BIOS expose
> > this sort of information to the operating system.  This sort of layout
> > changes between motherboard spins quite frequently as well, so good luck
> > mapping it yourself in any generic way.
> >
> >   * The kernel couldn't know how to map SPD JEDEC Manufacturer ID, Model
> > part number and revision to anything useful about the chips themselves.
> >
> >   * The kernel also couldn't know how to communicate with the AMBs in a
> > meaningful way (if present).
> >
> >
> > At the end of the day,   The only things I really care about are:
> >
> >   * I don't care if the kernel pre-processes the data it gets from the
> > hardware when there is an error.  For most users, burping something out to
> > the logs in decoded form is generally useful.  It isn't for us.
> >   * Don't ever put the kernel in a position where it will spam the logs and
> > wedge the system -- even if the hardware is wonky.
> 
> I'll add to this - sometimes 100 MCEs/second is acceptable.  The
> Kernel needs to not flake out under that.

Yeah, we got that, you want error reporting to be configurable and not
only over printk - we'll fix it.

> >   * Don't dummy the data such that I can't do the same calculations with
> > better visibility from userland.
> 
> This.  We do extensive analysis of data in userland.

Yeah, we want to put the MCE register info along with the decoded info.
We don't want to dummy up the data - we want to make it more useful.

> >   * Don't ever enforce a reactive policy that can't be changed from
> > userland.
> >   * I don't care whether the data comes from netlink, /dev/mcelog,
> > whiz-bang-sysfs uevent, or thingamaboo perfevents doohickie: as long as I
> > get events that are both atomic+consistent and the ABI is maintained.
> 
> I've been asking for hardware events for ever.  I seem to recall a
> proposal from IBM at OLS 2002 or 2003 where this was discussed.  I
> wanted it then, and I still want it.  But I don't just want MCEs.  Why
> can I not use the same channel to get PCI errors or SATA errors or
> EDAC (non-MCE) errors.
> 
> I don't care what the channel is, so long as I can rate-limit
> (/dev/mcelog is pretty good at that) events and the events I read
> contain full details about what happened.

Ok, makes sense.

> > I've CCed Robert who owns our userland bits as he may have something to add.
> >
> > That said, I'd love to have generic NMI-safe data-passing for improved
> > debugability, regardless of this conflated bickering about RAS
> > infrastructure :)

Thanks for the suggestions, much appreciated.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
General Managers: Alberto Bozzo, Andrew Bowd
Registration: Dornach, Gemeinde Aschheim, Landkreis Muenchen
Registergericht Muenchen, HRB Nr. 43632
