Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933220Ab1LFK4F (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 05:56:05 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:33238 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933118Ab1LFK4D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 05:56:03 -0500
Date: Tue, 6 Dec 2011 10:55:03 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Dave Martin <dave.martin@linaro.org>
Cc: Rob Herring <robherring2@gmail.com>,
        Anton Vorontsov <cbouatmailru@gmail.com>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Pawel Moll <pawel.moll@arm.com>, devicetree-discuss@lists.ozlabs.org,
        LKML <linux-kernel@vger.kernel.org>, Jeff Garzik <jgarzik@redhat.com>,
        linux-ide@vger.kernel.org, Randy Dunlap <rdunlap@xenotime.net>,
        linux-next@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Jonas Bonn <jonas@southpole.se>, Michal Simek <monstr@monstr.eu>,
        Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH] ata: Don't use NO_IRQ in pata_of_platform driver
Message-ID: <20111206105503.GO14542@n2100.arm.linux.org.uk>
References: <CA+55aFwekNWz+V4440f=2iu_BfOxSg0NjVogv4cZZDFbJBNoAQ@mail.gmail.com> <1322867573.11728.22.camel@pasglop> <20111205161157.GA27550@localhost.localdomain> <alpine.LFD.2.02.1112051236350.2357@xanadu.home> <20111205180253.GB29812@localhost.localdomain> <alpine.LFD.2.02.1112051310150.2357@xanadu.home> <4EDD1897.4030208@gmail.com> <20111205202125.GA32592@oksana.dev.rtsoft.ru> <4EDD2DE1.1050606@gmail.com> <20111206093000.GA2274@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111206093000.GA2274@linaro.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 06, 2011 at 09:30:00AM +0000, Dave Martin wrote:
> Do we expect there to be any platform drivers which are shared between
> legacy platforms and newer DT-ised platforms?
> 
> Those drivers would be pain points since they would need to understand
> both conventions.
> 
> So far as I can see, only boards which are not DT-ised, which do not use
> DT-ised drivers and which do not use drivers which use interrupts and
> are either used by DT-ised boards or by arches with a non-zero NO_IRQ
> could safely carry on using a non-zero NO_IRQ.  Tracking down exactly
> which boards and drivers this applies to could be hard.  We could have a
> CONFIG_NO_IRQ and make them depend on it, but we still have to find that
> list of boards and drivers in the first place.

You're digging too deeply into this.

Drivers which need to know whether an IRQ is valid need to know this if
they wish to do something different for 'this device doesn't have an IRQ
wired'.  These are the drivers which have problems because of the -1 vs
0 thing.

That is different from 'this is an invalid IRQ number', which is what
you find out when you call request_irq().

So please, stop thinking 'we need to convert drivers to check for <= 0'.
We don't.  We just need to make sure that we're not passing a zero IRQ
number to any driver.

On platforms where IRQ0 is special like x86, request_irq() will fail
with -EBUSY on drivers which don't care (or other kind of refusal to
initialize), and will cause 'polling mode' with the 8250 driver.

So, all that we need to do is to ensure that all the IRQ chip stuff is
fixed up so that IRQ0 is only used for the same purpose as x86 - the
PIC timer on systems with an ISA 8253 timer.  Everything else should
not pass IRQ0 outside core platform code.
