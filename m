Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751477Ab1AXU0O (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jan 2011 15:26:14 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:44211 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751211Ab1AXU0N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jan 2011 15:26:13 -0500
Date: Mon, 24 Jan 2011 20:26:10 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Colin Cross <ccross@android.com>
Cc: linux-tegra@vger.kernel.org, Russell King <linux@arm.linux.org.uk>,
        konkers@android.com, linux-kernel@vger.kernel.org, olof@lixom.net,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2 20/28] ARM: tegra: cpufreq: Disable cpufreq during
 suspend
Message-ID: <20110124202610.GJ29925@opensource.wolfsonmicro.com>
References: <1295834493-5019-1-git-send-email-ccross@android.com>
 <1295834493-5019-21-git-send-email-ccross@android.com>
 <20110124144142.GA16813@sirena.org.uk>
 <AANLkTikrUdLM8VmW5yCndf927E=drZF1gGBwXq6Dj5mW@mail.gmail.com>
 <20110124193539.GI29925@opensource.wolfsonmicro.com>
 <AANLkTikOEm=watbA1G-SFK3PZrntDc+Wun84nGio=YKv@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTikOEm=watbA1G-SFK3PZrntDc+Wun84nGio=YKv@mail.gmail.com>
X-Cookie: Keep it short for pithy sake.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 24, 2011 at 11:52:12AM -0800, Colin Cross wrote:

> Even _noirq isn't late enough, if cpufreq keeps trying to change the
> frequency (and thus voltage) until sysdev suspend.

If it were just cpufreq in isolation I'm not sure it'd be a big deal -
nothing will go hideously wrong if it's ticking away by itself providing
it's just governors working away providing the error handling is OK.
However...

> On Mon, Jan 24, 2011 at 11:35 AM, Mark Brown

> > So you actively need to push the processor into low power mode during
> > suspend?  I'm still not 100% clear what's triggering the issues you're

> It's more of a voltage scaling issue than a cpufreq issue directly.
> Tegra requires the voltage be set to nominal during resume, and the
> only time it can be set for resume is before I2C suspends.  I handle
> the problem with a suspend notifier in the latest version of the clock
> voltage scaling patches, but I kept this patch to avoid cpufreq trying
> to go to frequencies that are not supported by the suspend voltage.

...it sounds like you do actually have something of the above issue - 
but I think it's a generic-ish problem.  See below.

> > Typically this stuff isn't a problem for regulators themselves since if
> > they're active by the time I2C is off they normally get suspended by
> > hardware handshakes from the CPU as that enters low power mode - right
> > now we have no regulators at all in mainline that do anything in
> > software on suspend.  We can get a long way by just ignoring what
> > happens to regulators over suspend (there is some work to do here but
> > it's orthogonal to this sort of issue).

> The regulator driver itself has nothing to do, and when the CPU enters
> its lowest power mode it signals the regulator to turn off, but
> something needs to tell the regulator to go to the correct voltage.

Normally that's handled by the same transition logic - the core PMIC
will usually sequence a bunch of voltage and power status changes when
entering its own low power mode and have a similar transition on resume
which will ensure that the regulators power back up with a sane setup
regardless of the state they were in beforehand.

It sounds like for your systems what's happening is that the resume is
restoring the previously configured voltages for the core rails rather
than going to a known good state.  Is my understanding correct here?
While your fix is good and I don't see any reason not to do it this does
sound like something we should have a solution for in common code as I'd
not be surprised if there were other hardware out there which did a
similar thing.

Assuming I'm not completely off base with the above it'd be good if you
could clarify this in the commit message - there's enough dragons with
this stuff and it's common to refer to other implementations so it'd be
nice if we had a clear record of the issue in the log.
