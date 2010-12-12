Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751353Ab0LLGRh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Dec 2010 01:17:37 -0500
Received: from qmta08.emeryville.ca.mail.comcast.net ([76.96.30.80]:51166 "EHLO
	qmta08.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750923Ab0LLGRf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Dec 2010 01:17:35 -0500
Date: Sat, 11 Dec 2010 23:17:43 -0700
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>, Len Brown <lenb@kernel.org>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Rafael J. Wysocki" <rjw@sisk.pl>, linux-acpi@vger.kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@elte.hu>, Adam Belay <abelay@mit.edu>
Subject: Re: [PATCH 5/5] PNP: HP nx6325 fixup: reserve unreported resources
Message-ID: <20101212061743.GA4974@helgaas.com>
References: <20101208213606.13026.47657.stgit@bob.kio>
 <20101208213627.13026.18854.stgit@bob.kio>
 <AANLkTinhHkqpVQp10y6uRp9ug73iXRuF4Bed2okPOdit@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTinhHkqpVQp10y6uRp9ug73iXRuF4Bed2okPOdit@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 11, 2010 at 07:30:54PM -0800, Linus Torvalds wrote:
> On Wed, Dec 8, 2010 at 1:36 PM, Bjorn Helgaas <bjorn.helgaas@hp.com> wrote:
> >
> > The HP nx6325 BIOS doesn't report any devices in the [0xf8000000-0xfbffffff]
> > region via ACPI devices or the E820 memory map, but when we assign it to the
> > 00:14.4 bridge as a prefetchable memory window, the machine hangs.
> 
> Quite frankly, I think this patch sucks.
> 
> It sucks because these kinds of hw-specific patches are fundamentally
> a sign of something else being wrong. Why didn't windows hit this? Why
> do we need this total hack?

I agree, it *does* suck, and I *am* quite worried about how many
issues like this we might trip over.

Windows didn't hit this because of other differences:
  - Windows relies on subtractive decode; Linux programs a window
  - Windows gives the downstream CardBus bridge a 4K and a 64M mem window;
    Linux gives it two 64M windows
  - Windows doesn't align the CardBus windows on their size; Linux does

Under Windows, the CardBus windows don't conflict with the unreported
devices.  The larger windows allocated by Linux do.  So relying on
subtractive decode would work until we plug in a CardBus device that
expects to *use* that area, and then the device won't work.

> And is there any reason at all to believe that that one particular
> laptop is really special? I doubt it. And what happens for the next
> random machine that comes along an hits this?
> 
> Maybe we should just say that if we know the bridge is negative
> decode, and it hasn't been set up by the BIOS, we just don't allocate
> it at all. And try to look like Windows.

I do like this idea more than I did at first, even though it's not a
complete fix, because it's much better to have a non-working CardBus
device than a hanging machine.  But I guess we'd still want to fix
that device, and then we're back at a hw-specific quirk like this one.
Maybe we should do both (leave the bridge alone and keep the quirk).

> Or figure out what else Windows is doing differently.
> 
> The whole "allocate bottom up" old PCI allocation has _years_ of
> testing and quirk that have been gathered over a long time. We can't
> just say "we'll do the same thing for the top-down allocator".

True (although most of the quirks I can think of are in the form of
hard-coded legacy device reservations, and we're keeping those).

If we didn't care about host bridge _CRS, there'd be no reason to
change the old PCI allocation scheme.  But I think we *do* care and
will care more in the future.  We frequently assign resources to
devices the BIOS didn't configure, and that only works if we're lucky
or there's only one host bridge.

> The WHOLE AND ONLY POINT of the top-down allocator was to act lik
> Windows and not need crap like this. If that doesn't work, then I
> seriously don't think we should change bottom-up to top-down at all,
> and for 2.6.37 we should just revert the "set to top-down by default".
> 
> Seriously. That "whole and only point" thing is important. If we need
> hacks like this, then we shouldn't do it. We're much better off with
> the model that has year of testing an not the upheaval. Top-down
> allocation is in _no_ way inherently better, the only excuse for it
> was supposed to be "we don't need these kinds of hooks".

Not really -- the main point here is to make multi-host bridge
machines work reliably, and I really don't see a way to do that
without using _CRS.

If we're going to use _CRS, I think in the long run we'll be better
off if we do it similarly to Windows, despite these early problems.

Bjorn
