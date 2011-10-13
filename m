Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755077Ab1JMV6c (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Oct 2011 17:58:32 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:51410 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754909Ab1JMV6b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Oct 2011 17:58:31 -0400
Date: Thu, 13 Oct 2011 22:58:27 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, alsa-devel@alsa-project.org,
        linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Liam Girdwood <lrg@ti.com>
Subject: Re: [alsa-devel] linux-next: Tree for Oct 12
 (sound/soc/codecs/wm1250-ev1)
Message-ID: <20111013215827.GA2866@opensource.wolfsonmicro.com>
References: <20111012175425.a2e3e6e6a92265e433aeca25@canb.auug.org.au>
 <4E9634C9.3020404@xenotime.net>
 <20111013102427.GG1098@sirena.org.uk>
 <4E972DE1.9020308@xenotime.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E972DE1.9020308@xenotime.net>
X-Cookie: Don't read everything you believe.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 13, 2011 at 11:28:49AM -0700, Randy Dunlap wrote:

> You are listed as MODULE_AUTHOR().  Can we expect a fix?

I dunno; like I say I don't see an issue in the driver here (the driver
usage of the GPIOs is optional), the GPIO build options are pretty
fiddly and I just wrote the mail below.

> I don't see how stubs help with source lines like:
> struct wm1250_priv {
> 	struct gpio gpios[WM1250_EV1_NUM_GPIOS];
> };

So, clearly there's an issue with the API not stubbing itself out
terribly well here; the obvious solution would appear to be to have a
definition of the struct to go along with the stubs.  I guess you see
some sort of problem with this, though?  It does work well enough for
other similar APIs like regulator_bulk_*() so I'd expect it to work here.

To be honest though I'm more concerned that this is being reported as an
issue in a specific driver than I am about the actual issue (which one
does have to try pretty hard to see, I'd be astonished if someone saw it
outside of deliberate testing).  As a result of the number of randconfig
type tests you do I'd guess you're aware of the APIs like GPIO which are
expected to stub themselves out when disabled.  As with the usage in
this driver there's a huge proportion of users which can optionally use
the API but don't actually need it and which therefore shouldn't have
build time dependencies, and clearly scattering ifdefs throughout the
code isn't great either.  These things do fix the *configs but they
reduce the coverage we get with our automated testing and they make the
code harder to work with.

The main reason I'm pushing back in this way is that as we start to get
more and more embedded hardware in subsystems maintained by people from
a PC background it becomes more and more important that people like you
who do this who do a lot of this kernel wide testing are directing these
issues appropriately by checking to see if what's going wrong is a
result of the driver or if it's a result of one of the service APIs like
GPIO or regulator (and hopefully soon clk) not being transparent enough.

Subsystem maintainers who usually work on PCs likely won't be aware of
what's going on with this sort of stuff except in so far as they get
reports of *config issues since PCs don't generally have to deal with
the haphazard board dependant setup that is so common in the embedded
space and random driver authors aren't going to be reliably familiar
with either that or build coverage type things either as the
configurations that break are generally not too realistic anyway.

I don't mean to get at you personally here - while you do do a lot of
good work here you're not the only person who does this sort of testing
and hence reports issues in this manner, and obviously there's a lot of
maintainers too.  I think it's mostly an education thing but I'm not
sure what the best way to go about spreading the word is, if nothing
else I don't know how to reach all the build coverage people (who I
think are key here).
