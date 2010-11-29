Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754122Ab0K2WEn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Nov 2010 17:04:43 -0500
Received: from g1t0029.austin.hp.com ([15.216.28.36]:12447 "EHLO
	g1t0029.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750925Ab0K2WEm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Nov 2010 17:04:42 -0500
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] x86/PCI: never allocate PCI space from the last 1M below 4G
Date: Mon, 29 Nov 2010 15:04:40 -0700
User-Agent: KMail/1.13.2 (Linux/2.6.32-25-generic; KDE/4.4.2; x86_64; ; )
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>, Matthew Garrett <mjg@redhat.com>
References: <20101129183009.11256.33739.stgit@bob.kio> <201011291432.51264.bjorn.helgaas@hp.com> <4CF41C89.9060708@zytor.com>
In-Reply-To: <4CF41C89.9060708@zytor.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201011291504.40536.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, November 29, 2010 02:35:05 pm H. Peter Anvin wrote:
> On 11/29/2010 01:32 PM, Bjorn Helgaas wrote:
> > 
> > Oops, egg on my face.  In this case, there *is* an ACPI INT0800 device
> > at 0xff000000-0xffffffff, which should prevent us from allocating that
> > space for anything else.  Only problem is, we IGNORE that useful bit of
> > information.
> 
> Eep... why?

We have always ignored ACPI device resource information (except for
PNP0C01 and PNP0C02 motherboard devices).  There are a number of issues
in the way: conflicts with the hardcoded assumptions about legacy
devices, init ordering (e.g., we currently initialize PCI before
PNPACPI), ACPI resource interpretation (e.g., we don't do it the way
Windows does so we trip over BIOS bugs), the E820 mess (E820 is non-
hierarchical, but we wedge it into the iomem_resource tree anyway),
etc.

I've been working on these for the last few years, but we aren't
there yet.

> >> It is certainly reasonable to block off the last chunk of the 32-bit
> >> address space.  Some systems double-decode it to avoid issues with
> >> A20M#, so I would argue that we should avoid at least 2 MiB.
> >>
> >> As far as discovering them from the BIOS, there is a way to do it --
> >> E820.  This is a fallback for the case where the BIOS has plain and
> >> simply failed to provide it, and so a heuristic is probably the best we
> >> can do.  Probing is extremely unsafe.
> > 
> > I think it's clearly a bug that Linux ignores ACPI resource information
> > (except PNP0C01/PNP0C02 motherboard devices).  If we fix that bug, it
> > will fix Matthew's 2530p.
> 
> I would definitely agree with that.
> 
> > We might still want a patch like this current one because it could
> > work around some BIOS defects, and because I think it's too late to
> > fix the ACPI resource problem for .37.  But I'm not convinced we
> > should reserve more than Windows does, because that may keep us from
> > discovering other important Linux problems.
> 
> I'm not so sure about that... it feels like a pretty weak argument that
> we might work on some machines even though our code isn't perfect.

I think we're talking about whether to reserve the top 1MB or top 2MB.
I freely admit I don't know the right answer.  My point is merely that
since we're using a heuristic anyway, copying Windows is a pretty good
starting point.  In my mind, doing something different requires a
stronger argument than "it might fix some machines where Windows is
broken."

Bjorn
