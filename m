Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756853Ab1CaDcd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 23:32:33 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35708 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753673Ab1CaDcb convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 23:32:31 -0400
MIME-Version: 1.0
In-Reply-To: <AANLkTimPJCiaUyTfcR1NSPivJ2YjSwazhiWRC-CPLy6J@mail.gmail.com>
References: <20110317183048.GW7258@atomide.com> <AANLkTimWbb5DWiiCW821H6pRicbk1fS3PYcnGyUMznvM@mail.gmail.com>
 <20110318101512.GA15375@n2100.arm.linux.org.uk> <201103301906.42429.arnd@arndb.de>
 <AANLkTim578-kwM14SJd06RW_QiC4WVCmFuG+ASgGC4sq@mail.gmail.com>
 <20110331001502.GB6680@n2100.arm.linux.org.uk> <AANLkTinE7EDbV8hrYZWBxgvwOxdPMLoS0Y57PSm04rvM@mail.gmail.com>
 <AANLkTik-BFTzyPLuYVdhCJPocc0wPY0rKvO7BQS4Fg1S@mail.gmail.com>
 <AANLkTikd_JRxmB_OWZqq178=K3bnxhdDqcNbgFNRtTyU@mail.gmail.com>
 <AANLkTimS_8BnBz9MSdxYJVL6oreEpH=W61BsyuX2G+Xz@mail.gmail.com>
 <AANLkTimtO7vR2AQvJj1hHMqHCDqtoiJX_eENE9o3dPpV@mail.gmail.com> <AANLkTimPJCiaUyTfcR1NSPivJ2YjSwazhiWRC-CPLy6J@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 30 Mar 2011 20:24:30 -0700
Message-ID: <AANLkTi=fSUizM38SkBhPAzSbArgoNQxbV8JrC51x_RDf@mail.gmail.com>
Subject: Re: [GIT PULL] omap changes for v2.6.39 merge window
To: Bill Gatliff <bgat@billgatliff.com>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Arnd Bergmann <arnd@arndb.de>, Tony Lindgren <tony@atomide.com>,
        David Brown <davidb@codeaurora.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-omap@vger.kernel.org,
        Nicolas Pitre <nico@fluxnic.net>,
        Catalin Marinas <catalin.marinas@arm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 30, 2011 at 7:20 PM, Bill Gatliff <bgat@billgatliff.com> wrote:
>
> If it isn't opportunity, then you must be arguing that we shouldn't
> add any new ARM SoC support to the kernel.  Is that what you are
> saying?

What I'm saying is that we should not be adding ANY MINDLESS BOARD
DRIVERS for ARM.

Because they don't work. Most of them are totally unmaintainable CRAP
in the long run. They are extra code that actually have negative
worth. It shouldn't be in the kernel at all.

So let's take a really simple example of this kind of crap.

Do this:

    git ls-files arch/arm/ | grep gpio

and cry. That's 145 files in the arm directory that are some kind of
crazy gpio support.

Now, we have gpio drivers in other parts of the kernel too, but ARM is
at the point where it's just crazy.

And most GPIO drivers I've ever seen are actually basically "turn this
bit on or off in this register to turn it into an Input or Output"
along with "read/write this other bit to actually see/set the value".
Repeat that for 'nr' bits, where 'nr' is just some small value,
usually in single digits.

Now, not all of them are that, by all means, and the details are often
slightly different. Sometimes the read register is the same as the
write register, sometimes it isn't. Sometimes you have a "clear
register" and a "set register" instead of a register you write the
value to. And I haven't checked what those 145 files do, but I bet a
_lot_ of them could be described by having a single generic gpio
driver, and then just using devicetree to give that common driver a
few values to describe where the IO ports are, which bits they are,
and which type of gpio it is.

And then when you have another ARM SoC, instead of writing yet another
mindless board driver for the gpio's on it, just add the <nr> entries
for the GPIO's to the device tree. NOT A SINGLE LINE OF CODE.

Yes, yes, there are always exceptions. Many GPIO's are actually behind
some i2c bus or something. Others can do pulsing or are just generally
more complex than an array of single bits. So I'm sure we couldn't
replace all those 145 gpio files under arch/arm with a single driver
and some devicetree entries, but maybe half of them match the simple
pattern. I bet the SoC case it's more than half, it would be silly to
do i2c on an SoC. But I dunno. I really didn't look.

PowerPC does exactly the above, btw. So I'm not just talking about
some magical theoretical thing. I seriously think every ARM person who
has ever written any of those "gpio" files should look at powerpc.
Now, I suspect that most powerpc SoC's tend to share more IP blocks
than the crazy ARM situation, but even so, please just check it out.
Check out the device tree files (*.dts) and do that same

   git ls-files arch/arm/ | grep gpio

except do it on powerpc.

See the difference?

The powerpc people even wrote documentation about the thing, which is
just above and beyond reasonable.

                             Linus
