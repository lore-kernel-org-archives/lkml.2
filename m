Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753859Ab0FCSLT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jun 2010 14:11:19 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:43678 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752025Ab0FCSLS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jun 2010 14:11:18 -0400
Date: Thu, 3 Jun 2010 19:10:10 +0100
From: Russell King <rmk@arm.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Kevin Hilman <khilman@deeprootsystems.com>,
       Daniel Walker <dwalker@codeaurora.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-arm-msm@vger.kernel.org
Subject: Re: ARM defconfig files
Message-ID: <20100603181010.GA25779@flint.arm.linux.org.uk>
References: <20100603074548.GA12104@flint.arm.linux.org.uk> <alpine.LFD.2.00.1006030725420.8175@i5.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1006030725420.8175@i5.linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 03, 2010 at 07:48:18AM -0700, Linus Torvalds wrote:
> So I _think_ whatever "mach-xyz" file _should_ do something like
> 
> 	# Kconfig file for OMAP4ABCXYZ chip
> 
> 	.. set the particulars for this _particular_ chip,
> 	   ie select the particular drivers on this chip ..
> 
> 	include "chip-family-details" (ie maybe "base OMAP details")
> 
> 	include "architecture-family-details" (ie ARM Kconfig)
> 
> see? Not one flat file, and very much not something generated.

Umm...

> And I actually suspect we could do it with our current Kconfig file model. 
> IOW, in the arch/arm/Kconfig file, I think it should be doable to have 
> basically a
> 
> 	choice
> 		prompt "ARM platform"
> 
> 	config ARM_PLATFORM_OMAP
> 		bool PLATFORM_OMAP
> 
> 	config ARM_PLATFORM_MSM
> 		bool PLATFORM_MSM
> 	...
> 	endchoice

Umm.  I don't think you've actually looked at the Kconfig files if you're
writing this, because that's precisely what we already do.

arch/arm/Kconfig has a big choice statement in it to select the machine
class, and then it sources the individual arch/arm/*/Kconfig files,
which are themselves wrapped in a

if FOO

foo's options

endif

It's not one huge big "let's source everything and hope people ignore
options which don't apply to their platform" that you seem to be implying
we are doing.

The big problem with doing away with the defconfig files is more to do
with what happens _outside_ of arch/arm.

At one time, I was phasing IDE out, and didn't want to see the "IDE"
configuration options on platforms which either never had IDE support
or had had IDE support removed - unfortunately I was overruled by the
IDE/ATA developers and the conditionals we had went away.

That's just one instance, but consider when you're presented with
thousands of driver and filesystem configuration options as is the
case with modern kernels.  How do you find the few options you need
to get to a point that the kernel you've built is actually useful?

Anyway, I thought we were discussing _defconfig_ files, not Kconfig
files...

What we _could_ to is introduce a:

config STD_CONFIG
	bool "Enable me to generate a standard configuration for your platform"

and then have platforms conditionally select everything that's
appropriate for their use.  That provides a way to avoid the ages old
issue of select forcing options on, but the user still being presented
with the option and being told the only possible value for it is 'y'.

And yes, it _is_ necessary - because if you want to turn off something
on the platform - eg, you're not using MMC and MMC fails to build -
you can still end up with a working configuration at the end of the
day.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
