Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752627Ab0LLDbY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Dec 2010 22:31:24 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59782 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752231Ab0LLDbW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Dec 2010 22:31:22 -0500
MIME-Version: 1.0
In-Reply-To: <20101208213627.13026.18854.stgit@bob.kio>
References: <20101208213606.13026.47657.stgit@bob.kio> <20101208213627.13026.18854.stgit@bob.kio>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sat, 11 Dec 2010 19:30:54 -0800
Message-ID: <AANLkTinhHkqpVQp10y6uRp9ug73iXRuF4Bed2okPOdit@mail.gmail.com>
Subject: Re: [PATCH 5/5] PNP: HP nx6325 fixup: reserve unreported resources
To: Bjorn Helgaas <bjorn.helgaas@hp.com>,
        Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Len Brown <lenb@kernel.org>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
        linux-acpi@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Adam Belay <abelay@mit.edu>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 8, 2010 at 1:36 PM, Bjorn Helgaas <bjorn.helgaas@hp.com> wrote:
>
> The HP nx6325 BIOS doesn't report any devices in the [0xf8000000-0xfbffffff]
> region via ACPI devices or the E820 memory map, but when we assign it to the
> 00:14.4 bridge as a prefetchable memory window, the machine hangs.

Quite frankly, I think this patch sucks.

It sucks because these kinds of hw-specific patches are fundamentally
a sign of something else being wrong. Why didn't windows hit this? Why
do we need this total hack?

And is there any reason at all to believe that that one particular
laptop is really special? I doubt it. And what happens for the next
random machine that comes along an hits this?

Maybe we should just say that if we know the bridge is negative
decode, and it hasn't been set up by the BIOS, we just don't allocate
it at all. And try to look like Windows.

Or figure out what else Windows is doing differently.

The whole "allocate bottom up" old PCI allocation has _years_ of
testing and quirk that have been gathered over a long time. We can't
just say "we'll do the same thing for the top-down allocator".

The WHOLE AND ONLY POINT of the top-down allocator was to act lik
Windows and not need crap like this. If that doesn't work, then I
seriously don't think we should change bottom-up to top-down at all,
and for 2.6.37 we should just revert the "set to top-down by default".

Seriously. That "whole and only point" thing is important. If we need
hacks like this, then we shouldn't do it. We're much better off with
the model that has year of testing an not the upheaval. Top-down
allocation is in _no_ way inherently better, the only excuse for it
was supposed to be "we don't need these kinds of hooks".

                Linus
