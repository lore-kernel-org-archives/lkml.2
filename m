Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753670Ab0LOHLR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Dec 2010 02:11:17 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44842 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752661Ab0LOHLP convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Dec 2010 02:11:15 -0500
MIME-Version: 1.0
In-Reply-To: <20101215062650.GB2728@helgaas.com>
References: <20101208213606.13026.47657.stgit@bob.kio> <20101208213627.13026.18854.stgit@bob.kio>
 <AANLkTinhHkqpVQp10y6uRp9ug73iXRuF4Bed2okPOdit@mail.gmail.com>
 <20101212061743.GA4974@helgaas.com> <AANLkTikogB78xPGiQZpg6nWKYVffr61A_Adm0a+C3mbR@mail.gmail.com>
 <20101215062650.GB2728@helgaas.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 14 Dec 2010 23:03:15 -0800
Message-ID: <AANLkTi=U+CTn=RDvYG0w6JK0Owv_TEc9YNtAtm9DeLKi@mail.gmail.com>
Subject: Re: [PATCH 5/5] PNP: HP nx6325 fixup: reserve unreported resources
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>, Len Brown <lenb@kernel.org>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Rafael J. Wysocki" <rjw@sisk.pl>, linux-acpi@vger.kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@elte.hu>, Adam Belay <abelay@mit.edu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 14, 2010 at 10:26 PM, Bjorn Helgaas <bjorn.helgaas@hp.com> wrote:
>
> I don't know whether the other patches in this series make you
> unhappy.  I'm really not happy with how I implemented the avoidance
> of ACPI devices when doing PCI allocation, but I do think we need
> to avoid them *somehow*, and I was looking for a minimal quick
> fix at this point in the cycle.

So the "avoid ACPI devices" part makes sense, and doesn't involved
quirks, so I don't hate it at all the same way I hated the HP quirk.

However, I hate how it makes the allocation logic opaque. You can no
longer tell from the regular non-debug dmesg and the /proc/iomem _why_
something got allocated the way it did, because there are hidden
rules. That makes things awkward, methinks.

Also, quite frankly, I wonder what happens after release when somebody
shows another machine that simply stopped working because the
allocation strategy didn't work for it. The hw coverage that -rc6 gets
is tiny compared to a real release.

IOW, what's the long-term strategy for this? The only sane long-term
strategy I can see is the one we have _always_ done, which is to try
to populate the memory resource tree with what simply matches reality.
The whole "ok, we know the hardware better than the BIOS does" is a
_stable_ strategy. In contrast, the things you propose are NOT stable
strategies, they all depend on basically "we match windows exactly
and/or trust ACPI". Both of which are *known* to be failing models.

That's why I'm somewhat upset. Your whole strategy seems to depend on
a known broken model. We _know_ ACPI tables are crap much of the time.
So we know that "avoiding ACPI resources" is inevitably insufficient.

And that's why I hate the "switch everything around" model. Yes, we
have a known way to fix things up - namely to actually detect the
hardware itself properly when firmware inevitably screws up - but the
very act of switching things around will pretty much guarantee that
all our years of effort is of dubious value, and we'll end up finding
other laptops that used to work and no longer does.

Only switching around when _CRS is used is possible, and shouldn't
cause any regressions if we continue to default to not using _CRS. But
you want to switch that default around at some point, don't you? At
which point we'll be up sh*t creek again. See what I'm saying?

Which all makes me suspect that we'd be much better off just doing the
bottom-up allocation even for _CRS. And maybe CRS works fine then when
we combine our hardware knowledge with the ACPI region avoidance.

                     Linus
