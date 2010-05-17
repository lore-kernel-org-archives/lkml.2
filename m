Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753328Ab0EQOdQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 May 2010 10:33:16 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:56710 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752374Ab0EQOdP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 May 2010 10:33:15 -0400
Date: Mon, 17 May 2010 07:33:21 -0700
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Sundar <sunder.svit@gmail.com>
Cc: Deepak Sikri <deepak.sikri79@gmail.com>, viresh.kumar@st.com,
       rajeev-dlh.kumar@st.com, armando.visconti@st.com,
       linux-kernel@vger.kernel.org, vipin.kumar@st.com, shiraz.hashim@st.com,
       linux-pm@lists.linux-foundation.org, linus.walleij@stericsson.com,
       STEricsson_nomadik_linux@list.st.com
Subject: Re: Fwd: [linux-pm] Power Domain Framework
Message-ID: <20100517143319.GC5257@opensource.wolfsonmicro.com>
References: <AANLkTinZU1D1rMOBQDi47tRhXrOXwduQIdni7bCXdce0@mail.gmail.com>
 <20100510140527.GG5199@sirena.org.uk>
 <AANLkTikyqnKDNz7FIUvLDAvBReHskHvRCrEz2qBBqseH@mail.gmail.com>
 <20100517031613.GA3130@opensource.wolfsonmicro.com>
 <AANLkTimDdBCnRFMDiUkuNKanOzuPNwCpfRv9Gsi03Lsy@mail.gmail.com>
 <AANLkTinZRhUpFTOOUCdH5dEl3QaXn10USL_hPPQX8cie@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTinZRhUpFTOOUCdH5dEl3QaXn10USL_hPPQX8cie@mail.gmail.com>
X-Cookie: You will contract a rare disease.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 17, 2010 at 07:03:57PM +0530, Sundar wrote:
> On Mon, May 17, 2010 at 8:46 AM, Mark Brown

> > I'm really not convinced that this is a good idea.  Generally I suspect
> > the implementations of these concepts that I've seen would introduce
> > layering violations if done via the regulator API - from what I've seen
> > the power domains can end up knowing rather more about the things that
> > are being powered than is healthy for the regulator API and...

> I am sorry but I do not understand how this can violate the framework APIs.
> Even know, a regulator knows about its machine constraints, valid features
> w.r.t operating modes, DRMS, load currents etc. What additional information
> the regulator would be associated with would be operating points, constraints
> w.r.t peripherals etc.

There's two problems I see.  One is expressing the operating modes in a
way that is suitably abstract and will work for more than one chip.  The
other is that as soon as the regulator driver has to know something
about the consumers you're running into trouble.

The major goal of the regulator API is to allow us to match up consumer
drivers with regulator drivers without having any device specific tie
between the two.  Pushing things that need such tie in through the API
breaks that.

> > I do think it's likely that you'll want something that looks like the
> > regulator API at the edges, but that a separate implementation that
> > avoids having to shoehorn through the abstractions of the regulator API
> > for the on-chip work seems much more sensible (and is what OMAP and SH

> True. But a separate implementation is not needed because the current
> framework already provides me support for a majority of features. Features like
> OPP control, power states which are usually associated with SoC power domains
> are available on modem regulators. When such features will eventually creep in

Are you sure about these statements?  Bear in mind that with a regulator
on a separate device there is no direct way for the regulator to know
anything about what the device it is supplying is doing, and not only
are latency requirements for mode changes are very tight but there may
not be any software running when the mode changes which is in a position
to relay information to the regulator.  The trend with regulators
appears to be rather more towards removal of user visible control of the
internal operating modes of the regulator itself with the device
reconfiguring itself based on the ability to achieve good regulation at
a given load point.  This gives good responsivness and efficiency over
the full range of loads.

The physical nature of the system means that there's a very clear
abstraction point where a voltage is being supplied, possibly with some
limits on the possible current drawn.  The fact that the consumer may
have various power modes doesn't impact on the regulator except in that
it may be able to get some information about the range of currents being
supplied.  The converse also applies - the consumer doesn't really need
to know anything about what the regulator is up to internally.

> the regular framework, then why distinguish between on-SoC power sources
> and on-board power sources..

The big difference is that the on-SoC power domain configuration does
frequently rely on an abstraction other than the simple voltage plus
load one that the regulator API represents, as I said this frequently
includes a strong tie in with information about the device clocking.
Typically changing the operating mode will change or limit the clock
rates in use in various parts of the device.

It really would be worth taking a look at how the OMAP and SH platforms
are implementing this stuff.
