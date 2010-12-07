Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753607Ab0LGBRW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Dec 2010 20:17:22 -0500
Received: from mx1.redhat.com ([209.132.183.28]:18758 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753161Ab0LGBRV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Dec 2010 20:17:21 -0500
Subject: Re: [RFC PATCH] Utilize the PCI API in the AGP framework.
From: Dave Airlie <airlied@redhat.com>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: airlied@linux.ie, tglx@linutronix.de, hpa@zytor.com,
        linux-kernel@vger.kernel.org, konrad@kernel.org,
        Jeremy Fitzhardinge <jeremy@goop.org>
In-Reply-To: <20101207004844.GA31478@dumpdata.com>
References: <1291677875-30493-1-git-send-email-konrad.wilk@oracle.com>
	 <1291680126.8232.5.camel@clockmaker-el6>
	 <20101207004844.GA31478@dumpdata.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 07 Dec 2010 11:16:49 +1000
Message-ID: <1291684609.8232.8.camel@clockmaker-el6>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-12-06 at 19:48 -0500, Konrad Rzeszutek Wilk wrote:
> On Tue, Dec 07, 2010 at 10:02:06AM +1000, Dave Airlie wrote:
> > On Mon, 2010-12-06 at 18:24 -0500, Konrad Rzeszutek Wilk wrote:
> > > Attached is a set of RFC patches that make it possible for AGP graphic drivers to
> > > work under Xen. The major problem that Linux kernel has when running under Xen
> > > is that the usage of "virt_to_phys(x) >> PAGE_SIZE" to get the DMA address is not
> > > applicable. That is due to the fact that the PFN value is not the real Machine
> > > Frame Number (MFN), hence virt_to_phys(x) >> PAGE_SIZE ends up pointing to a
> > > random physical address. But if you use the PCI API, then the DMA (bus) address
> > > returned is a valid MFN.
> > 
> > Can I ask you to go back a step and address what the use case for all of
> > this is, the patch description doesn't address why anyone cares about
> > AGP in 2010, esp with Xen. Virtualising hw  drivers for the sake of it
> > is all well and good, but since most of these drivers are for really
> > legacy systems I can't imagine we are going to see a lot of regression
> > testing before they hit distros like Debian two years from now, though
> > maybe Gentoo might pick up some, (is anyone even running IA64?).
> 
> Hey Dave,
> Thank you for you quick reply and brief look at the code. When I wrote
> this code a similar thought went through my head, and around that
> time three bugs from Debian (#601341, #602418 and #604096) asked what
> is the the status of making AGP work with Xen. I've asked the folks
> on the bugs to provide input on your question. In regards to regressions
> I've a lot of these machines so I can definitly test them for
> regressions (my thought was to run the OpenArena, TuxRace, and watch
> some flash - is that a good enough test or should I expand it?)
> But obviously I don't have all of them so yeah something might break.

Okay reading that I'm not sure you've started at the right end.

I just read 601341, and it concerns nouveau, which shouldn't on the hw
described be touching AGP at all. Its a PCIE machine, so the DRM/TTM
code won't use any of the AGP paths.

Now if we have fixes for TTM/nouveau/radeon that make it work under Xen
then that is a whole different story, however these patches are not
those.

I'd suggest you reverse the priority, of the comment

a) Fix the GART/AGP backend (so drivers/char/agp/*.c) so they use the
PCI API.
   Only the i915 and higher are using the PCI API and I've some of the older
   boxes with i860 so can actually test it.
 b) Fix the TTM to use the DMA API.
 c) Lastly, get rid of _PAGE_IOMAP so we don't have to depend on radeon/nouveau/etc
   to set the proper _PAGE_IOMAP on the PFNs/BARs..

to do c, then b, and finally figure out if anyone cares about a, unless there is a major dependency in the code that requires this ordering.

Dave.

