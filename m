Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753974Ab1APVIN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Jan 2011 16:08:13 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:53707 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753666Ab1APVIM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Jan 2011 16:08:12 -0500
Date: Sun, 16 Jan 2011 22:07:59 +0100
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Ryan Mallon <ryan@bluewatersys.com>
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Jeremy Kerr <jeremy.kerr@canonical.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Ben Herrenchmidt <benh@kernel.crashing.org>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 1/2] Add a common struct clk
Message-ID: <20110116210759.GI6917@pengutronix.de>
References: <1294199462.347935.472473715866.0.gpush@pororo>
 <20110110104122.GI12078@pengutronix.de>
 <20110110110028.GB12552@n2100.arm.linux.org.uk>
 <201101110854.15653.jeremy.kerr@canonical.com>
 <AANLkTikjnz6RBCpOZM2imzX3d1ANUkaOZ2Qg9nqhpfpt@mail.gmail.com>
 <4D33580A.8090007@bluewatersys.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4D33580A.8090007@bluewatersys.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 17, 2011 at 09:41:46AM +1300, Ryan Mallon wrote:
> On 01/16/2011 08:26 PM, Grant Likely wrote:
> > On Mon, Jan 10, 2011 at 5:54 PM, Jeremy Kerr <jeremy.kerr@canonical.com> wrote:
> >> Hi Russell,
> >>
> >>> Unless the locking problems can be resolved, the patches aren't ready.
> >>>
> >>> From what I've seen there's still quite a problem with what kind of
> >>> lock to use in the clock - mutex or spinlock.
> >>
> >> Yes, the clock driver may either use a spinlock or mutex.
> >>
> >> However, this exactly the same as the current clock code, my patches do not
> >> alter what we currently have.
> >>
> >> I do agree that we should define some specific semantics for the clock API
> >> with regards to sleeping, and I'll start a new thread about that. But we
> >> should definitely separate that issue from the problem of having multiple
> >> definitions for struct clk, which is what these patches address.
> > 
> > Given that each current struct clk implementation makes it's own
> > decisions about how to handle locking, would it not make sense to omit
> > locking entirely?  At least as a first step?  Let the clock ops
> > implement their own locking.  Make enable count management their
> > responsibility too.  That's all that the lock protects anyway.  The
> > clk_* apis can fall directly through to the ops hooks with no
> > manipulation or locking.  The way v3 of the patch worked.
> 
> This doesn't really work in a generic API because the call sites need to
> know whether it safe to call clk_enable/disable, etc from a
> non-sleepable context. This has essentially the same problems as using a
> union with both a mutex and a spinlock.
Note that this is the current status quo, too.  clk_enable on imx
sleeps, clk_enable on at91 doesn't.  I think we all agree we don't want
to change that during the unifying step.  So the common struct clk might
not solve all problems, but it's not worse than the state now.

> That said, although we are aiming for a generic clock API, it's usage
> typically isn't. Most of the users of the clock API are machine/platform
> specific drivers and so they can make assumptions about the
> implementation of the clock API calls. We currently do have a generic
> set of clock calls which do not define rules about calling from atomic
> context. We have a number of drivers, for several platforms, using the
> clk_enable/disable calls. Some platforms are using sleeping clocks and
> others are using atomic clocks, but because the _usage_ of the API is
> largely platform specific it all hangs together.
> 
> This is a bit ugly in practice. It's hardly desirable to have an API
> which looks generic, but in reality is platform/machine specific. I'm
> guessing that a large benefit of having a unified API and well defined
> rules about whether clock API calls may sleep or not allows the usage of
> the clock API to become more generic.
> 
> I agree with Russell that the best short term approach is to create two
> clock APIs, one for clocks which are atomic and the other for clocks
> which need to sleep. If nothing else this at least allows the rules
> about calling context to nailed down.
For me this sounds like code duplication if everything is identical only
spinlocks are substituted by mutexes.  What do you think about my
suggestion to use a Kconfig symbol that is selected by platforms (e.g.
COMMON_CLK_SLEEPING) and then use:

	#ifdef CONFIG_COMMON_CLK_SLEEPING
		... mutex stuff ...
	#else
		... spinlock stuff ...
	#endif

?

Best regards
Uwe

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
