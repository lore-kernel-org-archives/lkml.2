Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756131Ab0FCUfw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jun 2010 16:35:52 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55430 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754833Ab0FCUfu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jun 2010 16:35:50 -0400
Date: Thu, 3 Jun 2010 13:31:07 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Russell King <rmk@arm.linux.org.uk>
cc: Daniel Walker <dwalker@codeaurora.org>,
       Kevin Hilman <khilman@deeprootsystems.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-arm-msm@vger.kernel.org
Subject: Re: ARM defconfig files
In-Reply-To: <alpine.LFD.2.00.1006031305310.8175@i5.linux-foundation.org>
Message-ID: <alpine.LFD.2.00.1006031317410.8175@i5.linux-foundation.org>
References: <20100603074548.GA12104@flint.arm.linux.org.uk> <alpine.LFD.2.00.1006030725420.8175@i5.linux-foundation.org> <20100603181010.GA25779@flint.arm.linux.org.uk> <alpine.LFD.2.00.1006031116360.8175@i5.linux-foundation.org> <20100603185333.GD25779@flint.arm.linux.org.uk>
 <alpine.LFD.2.00.1006031153420.8175@i5.linux-foundation.org> <1275593742.23384.48.camel@c-dwalke-linux.qualcomm.com> <20100603194559.GF25779@flint.arm.linux.org.uk> <alpine.LFD.2.00.1006031305310.8175@i5.linux-foundation.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 3 Jun 2010, Linus Torvalds wrote:
> 
> I apparently haven't explained myself enough, because what you keep on 
> harping on is not something I consider acceptable.
> 
> STD_CONFIG is pointless. It's pointless because the solution to what 
> you call STD_CONFIG would be to just NOT USING the special Kconfig.xyz 
> file at all.

To make this _really_ concrete, let me actually give you an example (but 
broken and pointless) example Kconfig file, in order to _avoid_ having a 
def_config file.

I do it by generating it. Let's say that I want a x86 configuration that 
has USB enabled. I can basically _ask_ the Kconfig machinery to generate 
that with something like this:

 - create a "Mykconfig" file:

	config MYCONFIG
		bool
		default y
		select USB

	source arch/x86/Kconfig

and then I just do

	KBUILD_KCONFIG=Mykconfig make allnoconfig

and look what appears in the .config file. In fact, do this:

	make allnoconfig
	cp .config no-config
	KBUILD_KCONFIG=Mykconfig make allnoconfig
	cp .config my-config
	diff -u no-config my-config

to see the point of it all.

Now, the above is a _trivial_ one. And it's actually broken, because I 
should not have forced CONFIG_USB (it depends on CONFIG_USB_SUPPORT). 

But with this approach you could basically generate the defconfig files. 
And exactly because Kconfig files are already hierarchical, you can do 
things like

 - Kconfig.omap3_evm:

	# Set the OMAP3 EVM-specific parts
	config OMAP3EVM
		bool
		default y
		select OMAP3_EVM_TIMERS # whatever
		...

	# this sets the thngs all OMAP3 cases want
	source Kconfig.omap3

 - Kconfig.omap3

	# Set the OMAP3 specific parts
	config OMAP3
		bool
		default y
		select USB_SUPPORT
		select USB
		...

	source Kconfig.arm

and now you'd be able to basically generate a OMAP3EVM .config file by 
just running "allnoconfig" on that Kconfig.omap3_evm file. But it would 
only have to select the parts that are specific for the EVM platform, 
because the generic OMAP3 support would be picked by the Kconfig.omap3 
file, which in turn would not have to worry about the generic ARM parts 
etc.

See?

		Linus
