Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754379Ab1BOH1M (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 02:27:12 -0500
Received: from adelie.canonical.com ([91.189.90.139]:53565 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751912Ab1BOH1K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 02:27:10 -0500
From: Jeremy Kerr <jeremy.kerr@canonical.com>
To: Saravana Kannan <skannan@codeaurora.org>
Subject: Re: [RFC,PATCH 1/3] Add a common struct clk
Date: Tue, 15 Feb 2011 15:26:53 +0800
User-Agent: KMail/1.13.5 (Linux/2.6.35-25-generic; KDE/4.5.1; x86_64; ; )
Cc: linux-arm-kernel@lists.infradead.org,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        linux-sh@vger.kernel.org, Ben Herrenschmidt <benh@kernel.crashing.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Paul Mundt <lethal@linux-sh.org>, linux-kernel@vger.kernel.org,
        Russell King <linux@arm.linux.org.uk>,
        Dima Zavin <dmitriyz@google.com>, Ben Dooks <ben-linux@fluff.org>,
        "Uwe =?iso-8859-1?q?Kleine-K=F6nig?=" 
	<u.kleine-koenig@pengutronix.de>,
        Vincent Guittot <vincent.guittot@linaro.org>
References: <1297233693.242364.862698430999.1.gpush@pororo> <201102151041.40655.jeremy.kerr@canonical.com> <4D5A100F.9000809@codeaurora.org>
In-Reply-To: <4D5A100F.9000809@codeaurora.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201102151526.54280.jeremy.kerr@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Saravana,

> Sure, one could argue that in some archs for a certain set of clocks the
> slow stuff in prepare/unprepare won't need to be done during set rate --
> say, a simple clock that always runs off the same PLL but just has a
> integer divider to change the rate.
> 
> In those cases, not grabbing the prepare_lock would make the code less
> "locky".
> 
> > We
> > may even want to disallow set_rate (and set_parent) when prepare_count is
> > non- zero.
> 
> This is definitely not right.

Why is that? Consider two devices using one clock; one does some 
initialisation based on the return value of clk_get_rate(), the other calls 
clk_set_rate() some time later. Now the first device is incorrectly 
initialised.

Regardless, this is definitely something to flag for a later discussion. I'm 
happy to return to that, but we should focus on one issue at a time here.

> Changing the rate of a clock when it's
> already enabled/prepared is a very reasonable thing to do. It's only
> doing a set rate at the "same time" as a prepare/unprepare that's wrong
> for some clocks. We could have the specific implementation deal with the
> locking internally.

Yes, hence leaving the locking here to the clock implementation.

> > I'd prefer to enforce the 'sleepability' with might_sleep instead.
> 
> Yeah, I realized this option after sending out my previous email. Please
> do add a might_sleep(). It will actually point out errors (per the new
> clarification) in some serial drivers.

Yep, will do.

> >>> +	.enable_lock	= __SPIN_LOCK_UNLOCKED(name.enable_lock),	\
> >>> +	.prepare_lock	= __MUTEX_INITIALIZER(name.prepare_lock),	\
> >> 
> >> After a long day, I'm not able to wrap my head around this. Probably a
> >> stupid question, but will this name.xxx thing prevent using this
> >> INIT_CLK macro to initialize an array of clocks? More specifically,
> >> prevent the sub class macro (like INIT_CLK_FIXED) from being used to
> >> initialize an array of clocks?
> > 
> > That's correct. For an array of clocks, you'll have to use a different
> > initialiser. We can add helpers for that that when (and if) the need
> > arises.
> 
> Would it even be possible to get this to work for an array? You don't
> have to change this in the patch, but I'm curious to know how to get
> this to work for an array without doing a run time init of the lock.

I'd assume that you'd have to do this at run time, as with any other array of 
structs that contain a mutex or spinlock.

Cheers,


Jeremy
