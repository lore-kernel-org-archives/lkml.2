Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754502Ab0LOSSq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Dec 2010 13:18:46 -0500
Received: from g4t0016.houston.hp.com ([15.201.24.19]:40553 "EHLO
	g4t0016.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754403Ab0LOSSn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Dec 2010 13:18:43 -0500
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 5/5] PNP: HP nx6325 fixup: reserve unreported resources
Date: Wed, 15 Dec 2010 11:18:28 -0700
User-Agent: KMail/1.13.2 (Linux/2.6.32-26-generic; KDE/4.4.2; x86_64; ; )
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>, Len Brown <lenb@kernel.org>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Rafael J. Wysocki" <rjw@sisk.pl>, linux-acpi@vger.kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@elte.hu>, Adam Belay <abelay@mit.edu>
References: <20101208213606.13026.47657.stgit@bob.kio> <20101215062650.GB2728@helgaas.com> <AANLkTi=U+CTn=RDvYG0w6JK0Owv_TEc9YNtAtm9DeLKi@mail.gmail.com>
In-Reply-To: <AANLkTi=U+CTn=RDvYG0w6JK0Owv_TEc9YNtAtm9DeLKi@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201012151118.30512.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, December 15, 2010 12:03:15 am Linus Torvalds wrote:
> On Tue, Dec 14, 2010 at 10:26 PM, Bjorn Helgaas <bjorn.helgaas@hp.com> wrote:
> >
> > I don't know whether the other patches in this series make you
> > unhappy.  I'm really not happy with how I implemented the avoidance
> > of ACPI devices when doing PCI allocation, but I do think we need
> > to avoid them *somehow*, and I was looking for a minimal quick
> > fix at this point in the cycle.
> 
> So the "avoid ACPI devices" part makes sense, and doesn't involved
> quirks, so I don't hate it at all the same way I hated the HP quirk.
> 
> However, I hate how it makes the allocation logic opaque. You can no
> longer tell from the regular non-debug dmesg and the /proc/iomem _why_
> something got allocated the way it did, because there are hidden
> rules. That makes things awkward, methinks.
> 
> Also, quite frankly, I wonder what happens after release when somebody
> shows another machine that simply stopped working because the
> allocation strategy didn't work for it. The hw coverage that -rc6 gets
> is tiny compared to a real release.
> 
> IOW, what's the long-term strategy for this? The only sane long-term
> strategy I can see is the one we have _always_ done, which is to try
> to populate the memory resource tree with what simply matches reality.
> The whole "ok, we know the hardware better than the BIOS does" is a
> _stable_ strategy. In contrast, the things you propose are NOT stable
> strategies, they all depend on basically "we match windows exactly
> and/or trust ACPI". Both of which are *known* to be failing models.
> 
> That's why I'm somewhat upset. Your whole strategy seems to depend on
> a known broken model. We _know_ ACPI tables are crap much of the time.
> So we know that "avoiding ACPI resources" is inevitably insufficient.
> 
> And that's why I hate the "switch everything around" model. Yes, we
> have a known way to fix things up - namely to actually detect the
> hardware itself properly when firmware inevitably screws up - but the
> very act of switching things around will pretty much guarantee that
> all our years of effort is of dubious value, and we'll end up finding
> other laptops that used to work and no longer does.
> 
> Only switching around when _CRS is used is possible, and shouldn't
> cause any regressions if we continue to default to not using _CRS. But
> you want to switch that default around at some point, don't you? At
> which point we'll be up sh*t creek again. See what I'm saying?
> 
> Which all makes me suspect that we'd be much better off just doing the
> bottom-up allocation even for _CRS. And maybe CRS works fine then when
> we combine our hardware knowledge with the ACPI region avoidance.

ACPI devices tend to be at high addresses, so allocating top-down
is definitely more dangerous unless we explicitly avoid them.  I
should have realized that and done something like patches 1-3 of
this series before the top-down patches.

Doing it bottom-up would very likely work better than the "top-down
without avoiding ACPI regions" model we currently have, at least in
the short term.  We *would* have to do something to avoid E820
reservations to fix this:
  https://bugzilla.kernel.org/show_bug.cgi?id=16228,
but that's doable.

So here's my proposal for .37:
  - Keep the current state of _CRS enabled by default (for 2008
    and newer machines).
  - Allocate bottom-up always
  - Avoid E820 reservations

That should fix all the regressions I'm aware of.  I'll work on
the patches this afternoon.

Bjorn
