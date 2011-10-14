Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757020Ab1JNW0W (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Oct 2011 18:26:22 -0400
Received: from relais.videotron.ca ([24.201.245.36]:25720 "EHLO
	relais.videotron.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752304Ab1JNW0V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Oct 2011 18:26:21 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN; CHARSET=US-ASCII
Date: Fri, 14 Oct 2011 18:26:20 -0400 (EDT)
From: Nicolas Pitre <nico@fluxnic.net>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Arnd Bergmann <arnd@arndb.de>, Stephen Warren <swarren@nvidia.com>,
        Olof Johansson <olof@lixom.net>,
        Peter De Schrijver <pdeschrijver@nvidia.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "Colin Cross (ccross@android.com)" <ccross@android.com>,
        Erik Gilling <konkers@android.com>
Subject: Re: [PATCH] arm/tegra: select AUTO_ZRELADDR by default
In-reply-to: <20111014211311.GY21648@n2100.arm.linux.org.uk>
Message-id: <alpine.LFD.2.02.1110141730060.17040@xanadu.home>
References: <1317172068-14872-1-git-send-email-pdeschrijver@nvidia.com>
 <201110141729.41515.arnd@arndb.de>
 <74CDBE0F657A3D45AFBB94109FB122FF173BE1A283@HQMAIL01.nvidia.com>
 <201110141827.53906.arnd@arndb.de>
 <alpine.LFD.2.02.1110141353390.17040@xanadu.home>
 <20111014192057.GT21648@n2100.arm.linux.org.uk>
 <alpine.LFD.2.02.1110141609510.17040@xanadu.home>
 <20111014201737.GW21648@n2100.arm.linux.org.uk>
 <alpine.LFD.2.02.1110141628230.17040@xanadu.home>
 <20111014211311.GY21648@n2100.arm.linux.org.uk>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 14 Oct 2011, Russell King - ARM Linux wrote:

> On Fri, Oct 14, 2011 at 04:31:12PM -0400, Nicolas Pitre wrote:
> > On Fri, 14 Oct 2011, Russell King - ARM Linux wrote:
> > 
> > > On Fri, Oct 14, 2011 at 04:14:12PM -0400, Nicolas Pitre wrote:
> > > > On Fri, 14 Oct 2011, Russell King - ARM Linux wrote:
> > > > 
> > > > > On Fri, Oct 14, 2011 at 02:01:07PM -0400, Nicolas Pitre wrote:
> > > > > > The way I'm restructuring things around this is that AUTO_ZRELADDR will 
> > > > > > always be active by default, just like ARM_PATCH_PHYS_VIRT now.  This 
> > > > > > platform specific exclusion thinking is a step backward so I'd prefer if 
> > > > > > people would refrain from going there for the moment.
> > > > > 
> > > > > Are you expecting everyone to change the way they load the zImage
> > > > > overnight then?
> > > > 
> > > > No, of course.  But adding restrictions in the kernel build because 
> > > > u-Boot's own image format dictates such restrictions doesn't make sense.  
> > > > Those restrictions must be pushed towards the uImage encapsulation step, 
> > > > not higher the kernel config hierarchy.
> > > 
> > > You're not understanding again.
> > > 
> > > I'm talking about people who _explicitly_ load the zImage at a different
> > > address to which the decompressed image ends up.  With AUTO_ZRELADDR=y
> > > their setup will break unless they stop that behaviour, which takes
> > > away one of the advantages of using the zImage format.
> > 
> > Would you care to explain where you got this from?  Because I really do 
> > not understand what you're saying indeed.
> 
> My I point out that it's you who decided that I was talking about u-boot
> when I said no such thing in my message.  I merely pointed out about
> those people who may be loading the zImage elsewhere in memory and using
> that facility to cut down on the boot time.  u-boot can't load zImages
> directly.
> 
> Yet you started nattering on about uboot - which we know is a pile of
> crap for dealing with this stuff.

OK, sorry for confusing matters.

>From your statement I inferred that making AUTO_ZRELADDR=y would be 
useless, because this is actually true with u-Boot.  Making 
AUTO_ZRELADDR the default allows for cleaning up zreladdr away, but that 
will break "make uImage".  I've yet to find the best way around that.

> > With AUTO_ZRELADDR=y you _still_ can load zImage to a different location 
> > from where the decompressed kernel ends up.
> 
> You are correct for some values of 'different location' but not all -
> and how can we know _what_ people are doing?  We don't.
> 
> #ifdef CONFIG_AUTO_ZRELADDR
>                 @ determine final kernel image address
>                 mov     r4, pc
>                 and     r4, r4, #0xf8000000
>                 add     r4, r4, #TEXT_OFFSET
> #else
>                 ldr     r4, =zreladdr
> #endif
> 
> So this means the decompressor _must_ run within the first 128MB chunk
> of memory for the resulting kernel to be correctly placed at expected
> place - at the beginning of system memory + TEXT_OFFSET.
> 
> Can we know that this is always the case?  I don't think so.

This is certainly the case for a big chunk of legacy ARM machines that 
don't have more than 128MB of RAM.  Discontigous memory banks may break 
that assumption but that's still a large limiting factor.

> Can we expect there to be regressions if we force AUTO_ZRELADDR=y?  We'd
> be stupid not to expect them.

They should be expected indeed.  However we must weight the benefits 
against the possible regressions.

For example, on X86 they decided at some point that the zImage would no 
longer include the floppy boot sector with kernel loading code.  This 
was an explicit regression because simply copying zImage to a floppy and 
sticking that floppy into a PC no longer boots the kernel.  I'm sure 
some people were affected by that, and the official word was that you 
now have to use a proper boot loader, period.

So far, I've never seen any ARM machine where the kernel is loaded more 
than 64MB away from start of RAM.  And that 64MB happened only once and 
that was from my own doing.  Most people load zImage much closer to 
start of RAM, and almost all of them simply load zImage at zreladdr.  
Or worse, they wrap it into a uImage, load it higher thinking it is 
good, and u-Boot copies it to zreladdr because that's what 'make uImage' 
uses, forcing zImage to make a second copy.

Between you and I, we've seen quite a lot of ARM setups after all those 
years. We should be able to guess the probability for causing regression 
with AUTO_ZRELADDR=y by default.  Personally I'd say that, while not 
impossible, the probability is close to zero for 99% of the cases.


Nicolas
