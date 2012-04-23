Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754270Ab2DWTwa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2012 15:52:30 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:35167 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752952Ab2DWTw3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2012 15:52:29 -0400
Date: Mon, 23 Apr 2012 20:52:14 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Pavel Machek <pavel@denx.de>
Cc: kernel list <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>, wd@denx.de
Subject: Re: Sharing header files -- arch/arm/mach-generic  ?
Message-ID: <20120423195214.GA24277@n2100.arm.linux.org.uk>
References: <20120423194042.GA5734@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120423194042.GA5734@elf.ucw.cz>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 23, 2012 at 09:40:42PM +0200, Pavel Machek wrote:
> I have new architecture I'd like to merge into the mainline. It has
> some code very similar to existing plaforms (for example
> real differences to mach-realview/platsmp.c are two lines.)

I suspect there's more differences than just that, because 17 lines
in that file are very specific to realview.  I doubt that you even
need a scu_base_addr() function as you probably know where the SCU
is located.

So, I bet the reason your example is just two lines different from
mach-realview/platsmp.c is because someone copied and modified the
file rather than thinking about what's really required.

> Should mach-generic/platsmp.c be created, so code can be better
> shared? Or are the code pieces small enough that this duplication can
> be ignored?

It should be ignored.

> headsmp.S is another candidate for sharing. AFAICT we have 4 times
> identical code in the tree already:
> 
> ./mach-exynos/headsmp.S:   ldmia	r4, {r5, r6}
> ./plat-versatile/headsmp.S:		ldmia	 r4, {r5, r6}
> ./mach-ux500/headsmp.S:			ldmia	 r4, {r5, r6}
> ./mach-msm/headsmp.S:			ldmia	 r4, {r5, r6}

Again, because of standard 'lets copy and modify' behaviour.  I'd
really like to drop the holding pen from versatile stuff - it's not
really required, as we can wake each CPU individually.  The only
reason it hasn't happened is because the holding pen stuff is also
used for holding CPUs in the unplugged state, as realview and versatile
express have no way to power manage or reset individual CPUs.

Most normal platforms (iow, those fabricated on real SoCs rather than
test-chips) have ways to power off the unplugged CPU, and don't need
this holding pen.  Or they only have one additional CPU, and so don't
even need any holding pen.

Unfortunately, I don't have the time to hit people over the head to
get them to fix their implementations here, so lots of copy-n-modify
for the SMP bringup from Realview has happened over the years.  It's
little surprise though that OMAP (where I've been quite involved with)
does not suffer from this...

Basically, everything except plat-versatile probably shouldn't be using
this holding pen stuff.
