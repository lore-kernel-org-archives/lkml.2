Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753416Ab1DDAPB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Apr 2011 20:15:01 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:54189 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751558Ab1DDAPA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Apr 2011 20:15:00 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: [GIT PULL] omap changes for v2.6.39 merge window
Date: Mon, 4 Apr 2011 02:14:16 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.37; KDE/4.3.2; x86_64; ; )
Cc: Detlef Vollmann <dv@vollmann.ch>, david@lang.hm,
        "Russell King - ARM Linux" <linux@arm.linux.org.uk>,
        Nicolas Pitre <nico@fluxnic.net>, Tony Lindgren <tony@atomide.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        lkml <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@elte.hu>, linux-omap@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        David Brown <davidb@codeaurora.org>,
        linux-arm-kernel@lists.infradead.org
References: <alpine.LFD.2.00.1103310145390.28032@xanadu.home> <4D95E112.4020400@vollmann.ch> <1301869097.2549.36.camel@pasglop>
In-Reply-To: <1301869097.2549.36.camel@pasglop>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201104040214.16581.arnd@arndb.de>
X-Provags-ID: V02:K0:fxkJaEzMOCvdKwHvkhooXyl2iFxQkRTx/8zkYKi1bzf
 RGXRhkoTYrNdph4nwg7m+f53TIS8kpWuhz0YLmOcAo934lubAS
 C+KleEGe1CVmhh/3BruEPxsNtTo7ApHhCtHHhu/EsFlimxDJI0
 Geqr7ITzTrxjWq8ObXV/11J2IUxfaspXNq0GhQpabX66hnytHj
 FJReLrQozL2yYoFN5VWoA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 04 April 2011, Benjamin Herrenschmidt wrote:
> On Fri, 2011-04-01 at 16:28 +0200, Detlef Vollmann wrote:
> > >   * No board files
> > Where do you put code that needs to run very early (e.g. pinging the
> > watchdog)? 
> 
> Even on powerpc I keep board files :-)
> 
> The main thing is:
> 
> - The generic -> board linkage must not be hard (ie, no
> platform_restart, but a board_ops.restart() etc....)
> 
> - An average board file is a few hundreds line long, that's it, mostly
> it hooks up to generically provided functions, tho it gets the choice of
> _which_ ones to hookup.

I believe a machine_type is more general than a board file, i.e. what
gets described as a machine in powerpc would often currently correspond
to multiple board files, if I am not mistaken.

The fact that we have a more diverse set of hardware on ARM, and that
it's growing quicker than powerpc also means that we should try harder
to reduce duplication than is necessary there.

> - It can still quirk/fixup a thing or two if needed, I thinkt it's
> useful to keep that around, as long as such "quirks" remain small and
> few. At the end of the day, if dealing with one board special case gives
> you the choice between changing a ton of infrastructure/core to
> introduce a new abstraction to deal with -that- special case vs. having
> a one liner fixup in the platform code, the later is the most sensible
> option. The hard part of course is to have sensible maintainers to make
> sure this doesn't grow back to the old mess.

I guess quirks are fine, as long as it's not required to have a them
for each board. We can have a function that gets called for any matching
"compatible" property of the root node, but I think the default should
be not to need it eventually.

This is one area where I think I can illustrate how a gradual change
from the status quo differs from a parallel new platform implementation:
To gradually change one board file, you would convert the existing
machine description to match the compatible property of the device
tree root node and possibly at a later stage remove that code again
once it's possible to work without it.
When starting out with a fresh implementation, we first need to
change all device drivers that are used on the board to work
without a machine description, but then would not have to change
any code twice, and the work for a similar board is almost done.

	Arnd
