Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755502Ab1BDKVo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Feb 2011 05:21:44 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:60262 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754551Ab1BDKVl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Feb 2011 05:21:41 -0500
Date: Fri, 4 Feb 2011 11:21:20 +0100
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Richard Zhao <linuxzsc@gmail.com>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        Vincent Guittot <vincent.guittot@linaro.org>, linux-sh@vger.kernel.org,
        Ben Herrenschmidt <benh@kernel.crashing.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Paul Mundt <lethal@linux-sh.org>, Stephen Boyd <sboyd@codeaurora.org>,
        linux-kernel@vger.kernel.org, Dima Zavin <dmitriyz@google.com>,
        Saravana Kannan <skannan@codeaurora.org>,
        Ben Dooks <ben-linux@fluff.org>,
        Jeremy Kerr <jeremy.kerr@canonical.com>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: Locking in the clk API, part 2: clk_prepare/clk_unprepare
Message-ID: <20110204102120.GJ30452@pengutronix.de>
References: <201102011711.31258.jeremy.kerr@canonical.com>
 <20110201105449.GY1147@pengutronix.de>
 <20110201131512.GH31216@n2100.arm.linux.org.uk>
 <20110201141837.GA1147@pengutronix.de>
 <20110201143932.GK31216@n2100.arm.linux.org.uk>
 <20110201151846.GD1147@pengutronix.de>
 <20110201152458.GP31216@n2100.arm.linux.org.uk>
 <4D48741F.8060006@codeaurora.org>
 <20110201212409.GU31216@n2100.arm.linux.org.uk>
 <20110204095424.GB2347@richard-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20110204095424.GB2347@richard-laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Richard,

On Fri, Feb 04, 2011 at 05:54:24PM +0800, Richard Zhao wrote:
> On Tue, Feb 01, 2011 at 09:24:09PM +0000, Russell King - ARM Linux wrote:
> > On Tue, Feb 01, 2011 at 12:59:11PM -0800, Stephen Boyd wrote:
> > > On 02/01/2011 07:24 AM, Russell King - ARM Linux wrote:
> > > > I'd also be tempted at this stage to build-in a no-op dummy clock,
> > > > that being the NULL clk:
> > > >
> > > > int clk_prepare(struct clk *clk)
> > > > {
> > > > 	int ret = 0;
> > > >
> > > > 	if (clk) {
> > > > 		mutex_lock(&clk->mutex);
> > > > 		if (clk->prepared == 0)
> > > > 			ret = clk->ops->prepare(clk);
> > > > 		if (ret == 0)
> > > > 			clk->prepared++;
> > > > 		mutex_unlock(&clk->mutex);
> > > > 	}
> > > >
> > > > 	return ret;
> > > > }
> > > 
> > > I'm afraid this will hide enable/disable imbalances on some targets and
> > > then expose them on others. Maybe its not a big problem though since
> > > this also elegantly handles the root(s) of the tree.
> > 
> > You can't catch enable/disable imbalances in the prepare code, and you
> > can't really catch them in the unprepare code either.
> > 
> > Consider two drivers sharing the same struct clk.  When the second driver
> > prepares the clock, the enable count could well be non-zero, caused by
> > the first driver.  Ditto for when the second driver is removed, and it
> > calls unprepare - the enable count may well be non-zero.
> > 
> > The only thing you can check is that when the prepare count is zero,
> > the enable count is also zero.  You can also check in clk_enable() and
> > clk_disable() that the prepare count is non-zero.
> but how can we check prepare count without mutex lock? Even if prepare count
> is atomic_t, it can not guarantee the clock is actually prepared or unprepared.
> So it's important for driver writer to maintain the call sequence.
I happily point out that the prepare_count needs to be protected by a
spinlock and you need a flag that signals a prepare or unprepare is
currently running.

SCNR
Uwe

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
