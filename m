Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932805Ab1LERlH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 12:41:07 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:46978 "EHLO
	earthlight.etchedpixels.co.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932588Ab1LERlF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 12:41:05 -0500
Date: Mon, 5 Dec 2011 17:41:32 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Dave Martin <dave.martin@linaro.org>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Anton Vorontsov <cbouatmailru@gmail.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Andrew Morton <akpm@linux-foundation.org>,
        devicetree-discuss@lists.ozlabs.org,
        LKML <linux-kernel@vger.kernel.org>, linux-ide@vger.kernel.org,
        Randy Dunlap <rdunlap@xenotime.net>, linux-next@vger.kernel.org,
        Ingo Molnar <mingo@elte.hu>, Jeff Garzik <jgarzik@redhat.com>,
        Pawel Moll <pawel.moll@arm.com>, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] ata: Don't use NO_IRQ in pata_of_platform driver
Message-ID: <20111205174132.564e0bb0@lxorguk.ukuu.org.uk>
In-Reply-To: <20111205161157.GA27550@localhost.localdomain>
References: <20111110162859.GA7088@oksana.dev.rtsoft.ru>
	<20111202192618.GC3037@localhost.localdomain>
	<CA+55aFwekNWz+V4440f=2iu_BfOxSg0NjVogv4cZZDFbJBNoAQ@mail.gmail.com>
	<1322867573.11728.22.camel@pasglop>
	<20111205161157.GA27550@localhost.localdomain>
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.24.7; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Russell, do you know whether it would make sense to set a timeline for 
> removing NO_IRQ from ARM platforms and migrating to 0 for the no-interrupt
> case?  I'm assuming that this mainly involves migrating existing hard-wired
> code that deals with interrupt numbers to use irq domains.

The timelime was several years ago. Several years of complete inaction
later the chickens have come home to roost.

I refer you to Linus mail of 26 Sept 2006 to linux-kernel ('restore
libata build on frv')

Quoting Linus email:

>> That's fine -- but don't use zero to mean none. We have NO_IRQ for
>> that, and zero isn't an appropriate choice.
>
> Zero _is_ an appropriate choice, dammit!
>
> That NO_IRQ thing should be zero, and any architecture that thinks that
>zero is a valid IRQ just needs to fix its own irq mapping so that the
> "cookie" doesn't work.
>
> The thing is, it's zero. Get over it. It can't be "-1" or some other
> random value like people have indicated, because that thing is often read
> from places where "-1" simply isn't a possible value (eg it gets its
> default value initialized from a "unsigned char" in MMIO space on x86).
>
> So instead of making everybody and their dog to silly things with some
> NO_IRQ define that they haven't historically done, the rule is simple: "0"
> means "no irq", so that you can test for it with obvious code like
>
>	if (!dev->irq)
>		..
>
> and then, if your actual _hardware_ things that the bit-pattern with all
> bits clear is a valid irq that can be used for normal devices, then what
> you do is you add a irq number translation layer (WHICH WE NEED AND HAVE
> _ANYWAY_) and make sure that nobody sees that on a _software_ level.

----------

On 15th October 2008 Linus said the following to linux-next

> Grr. Can we please just get rid of that IDIOTIC thing instead?
> 
> NO_IRQ was a bad idea to begin with. Let's not add more.
> 
> I assume that broken driver is some ARM-specific thing. I certainly don't 
> want to see NO_IRQ in any general drivers. So instead of having that 
> NO_IRQ insanity spread any more, I'd much rather see the driver either 
> fixed to not use it, or just marked ARM-only.
>
> The proper way to test for whether an interrupt is valid or not is to do
>
> 	if (dev->irq) {
>		...
> and no other. There is no spoon. That NO_IRQ was insane. And
> architectures or drivers that still think otherwise should fix themselves.

------------

So there we are.. ARM spent years ignoring clear direction. If ARM breaks
for a release now so be it. You've had *YEARS* to get off your collective
backsides and sort it out.

> I worry that if we just change the convention for the OF case, we'll end
> up with OF-ised platform drivers which have to deal with a different no-
> irq convention depending on whether they are probed as platform drivers
> or through the OF framework ... and these ported or semi-ported drivers
> will be intermixed with unported drivers, confusing maintainers

All drivers should assume that  if (!dev->irq) works. Zero is not an IRQ
except in certain buried internal invisible cases in arch code (legacy PC
timer being the obvious one).

Come to think about it we had a prior discussion about NO_IRQ in 2005
even!

The core kernel generic IRQ code knows about zero being special, many
common driver layer components such as serial and network phylib do, so
if anything it's going to fix bugs sorting the mess out on ARM.

Jut fix it. Other platforms have done so without problem.

Alan
