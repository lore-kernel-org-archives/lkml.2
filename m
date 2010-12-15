Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752794Ab0LOG0z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Dec 2010 01:26:55 -0500
Received: from qmta04.emeryville.ca.mail.comcast.net ([76.96.30.40]:54977 "EHLO
	qmta04.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752398Ab0LOG0x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Dec 2010 01:26:53 -0500
Date: Tue, 14 Dec 2010 23:26:51 -0700
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>, Len Brown <lenb@kernel.org>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Rafael J. Wysocki" <rjw@sisk.pl>, linux-acpi@vger.kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@elte.hu>, Adam Belay <abelay@mit.edu>
Subject: Re: [PATCH 5/5] PNP: HP nx6325 fixup: reserve unreported resources
Message-ID: <20101215062650.GB2728@helgaas.com>
References: <20101208213606.13026.47657.stgit@bob.kio>
 <20101208213627.13026.18854.stgit@bob.kio>
 <AANLkTinhHkqpVQp10y6uRp9ug73iXRuF4Bed2okPOdit@mail.gmail.com>
 <20101212061743.GA4974@helgaas.com>
 <AANLkTikogB78xPGiQZpg6nWKYVffr61A_Adm0a+C3mbR@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTikogB78xPGiQZpg6nWKYVffr61A_Adm0a+C3mbR@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 14, 2010 at 12:34:20PM -0800, Linus Torvalds wrote:
> On Sat, Dec 11, 2010 at 10:17 PM, Bjorn Helgaas <bjorn.helgaas@hp.com> wrote:
> >
> > Not really -- the main point here is to make multi-host bridge
> > machines work reliably, and I really don't see a way to do that
> > without using _CRS.
> >
> > If we're going to use _CRS, I think in the long run we'll be better
> > off if we do it similarly to Windows, despite these early problems.
> 
> It's not about any "despite these early problems".
> 
> It's about "clearly we're not doing things at all like Windows, and
> it's just broken".
> 
> The thing is, we will never be able to match Windows exactly. It may
> well have random hardcoded quirks we simply don't know about.

Granted.

> I'm perfectly happy with you aiming to use _CRS. I am _not_ happy with
> you then using that as an excuse to then do things that don't work.

I don't want to do things that make you unhappy :)  

> We will NOT start doing random BIOS-specific quirks just because
> top-down allocations hit other bugs than bottom-up ones do. Just no.
> We'll continue doing that we have tried to do, which is to perhaps
> have quirks that are specific to *hardware* (like the ones in
> drivers/pci/quirks.c) and just filling in stuff that some BIOSes are
> known to get wrong.

I've only proposed one BIOS-specific quirk, which is the one for the
nx6325 unreported regions, and I identified things we do differently
than Windows that explain why we see the problem and Windows doesn't.

If we stop opening windows on subtractive-decode bridges, we don't
need that quirk to avoid the hang.  We will still need it if we
want to use more than 40-odd MB of space on a PC Card.

I'm pretty confident that if we could find PC Cards that require
enough space, they wouldn't work under Windows either.

I don't know whether the other patches in this series make you
unhappy.  I'm really not happy with how I implemented the avoidance
of ACPI devices when doing PCI allocation, but I do think we need
to avoid them *somehow*, and I was looking for a minimal quick
fix at this point in the cycle.

Avoiding ACPI devices fixes the Matthew's 2530p problem.  We can
also avoid that particular problem with the simple PCIBIOS_MAX_MEM_32
change you proposed.  However, avoiding ACPI devices fixes other
problems at the same time, such as this one:
    https://bugzilla.kernel.org/show_bug.cgi?id=23802
where we put the intel-gtt "flush page" on top of an ACPI TPM
device.

Bjorn
