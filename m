Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751348Ab0LMFtS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Dec 2010 00:49:18 -0500
Received: from qmta02.emeryville.ca.mail.comcast.net ([76.96.30.24]:39808 "EHLO
	qmta02.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750973Ab0LMFtR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Dec 2010 00:49:17 -0500
X-Greylist: delayed 350 seconds by postgrey-1.27 at vger.kernel.org; Mon, 13 Dec 2010 00:49:17 EST
Date: Sun, 12 Dec 2010 22:43:35 -0700
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Len Brown <lenb@kernel.org>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@elte.hu>, Adam Belay <abelay@mit.edu>,
        Matthew Garrett <mjg@redhat.com>, Dan Williams <dcbw@redhat.com>
Subject: Re: [PATCH 1/5] resources: add arch hook for preventing allocation
 in reserved areas
Message-ID: <20101213054334.GA15856@helgaas.com>
References: <20101208213606.13026.47657.stgit@bob.kio>
 <AANLkTi=b5pq+RhA1DpyyRaLEQxQFOrf4aEXHrG-Qjqbt@mail.gmail.com>
 <20101211201615.79186de7@jbarnes-desktop>
 <201012121420.57217.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201012121420.57217.rjw@sisk.pl>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 12, 2010 at 02:20:56PM +0100, Rafael J. Wysocki wrote:
> On Sunday, December 12, 2010, Jesse Barnes wrote:
> > On Sat, 11 Dec 2010 19:34:05 -0800
> > Linus Torvalds <torvalds@linux-foundation.org> wrote:
> > 
> > > On Fri, Dec 10, 2010 at 5:37 PM, Jesse Barnes <jbarnes@virtuousgeek.org> wrote:
> > > >
> > > > Thanks, I'll add Dan and Rafael's tested-bys to the patches (they're
> > > > already in my for-linus tree).  Unless Linus has a problem with them
> > > > I'll send them over to him this weekend or Monday.
> > > 
> > > See my other email I just sent out.
> > > 
> > > I really am not going to take some totally new experimental and hacky
> > > major PCI resource management thing this late in the -rc game. No way,
> > > no how.
> > > 
> > > If the top-down allocator is causing regressions that cannot be fixed
> > > by _simple_ patches, we're simply going to have to undo it. What's the
> > > advantage of top-down? None. Not if we then need all this crap, which
> > > we could as easily do on top of the bottom-up one WITHOUT any
> > > regressions.
> > > 
> > > Why isn't anybody else questioning the whole basic premise here?
> > 
> > Questioning the whole premise is fine, but so far we've gone in (or at
> > least think we're going in) a consistent direction: behave like Windows
> > on platforms designed for Windows to avoid bugs that Windows doesn't
> > hit and enable all the same devices Windows allows.
> > 
> > But yes, I really don't like the nx6325 patch either; there's obviously
> > something we're still missing that's preventing us from doing the right
> > thing on that platform.  Quirking it isn't a good long term answer.
> 
> OK, so I guess the best thing we can do for 2.6.37 is to revert
> 1af3c2e (x86: allocate space within a region top-down), right?

That's a possibility, but I'm not sure it's the best.  It would avoid
the nx6325 landmine, but we could easily step on a different one on
other machines.

If Windows uses the end of available space first, that's the best-tested
territory, and I think it's better to try to stay in it rather revert
1af3c2e and start mapping different territory that really isn't tested
by Windows at all.

On the nx6325, we stray out of that tested territory because Linux opens
windows on subtractive-decode bridges and allocates more space to
CardBus bridges.

I think it'd be fairly simple to leave subtractive-decode bridges alone,
and that might make the nx6325 work well enough for .37, even without
the quirk.  This feels like a change that might be the right thing to do
in general.  Using subtractive rather than positive decode would give up
a little performance, but I doubt it's important

There's another regression,
https://bugzilla.kernel.org/show_bug.cgi?id=23132, that seems similar,
though we haven't debugged it yet.  It also has to do with assigning
resources that aren't strictly needed to bridges, so there might be more
changes we should make to that strategy.

Bjorn
