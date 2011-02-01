Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753091Ab1BAVZJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 16:25:09 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:52759 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751622Ab1BAVZG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 16:25:06 -0500
Date: Tue, 1 Feb 2011 21:24:09 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        Saravana Kannan <skannan@codeaurora.org>, linux-sh@vger.kernel.org,
        Ben Herrenschmidt <benh@kernel.crashing.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Paul Mundt <lethal@linux-sh.org>, linux-kernel@vger.kernel.org,
        Dima Zavin <dmitriyz@google.com>, Ben Dooks <ben-linux@fluff.org>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Jeremy Kerr <jeremy.kerr@canonical.com>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: Locking in the clk API, part 2: clk_prepare/clk_unprepare
Message-ID: <20110201212409.GU31216@n2100.arm.linux.org.uk>
References: <201102011711.31258.jeremy.kerr@canonical.com> <20110201105449.GY1147@pengutronix.de> <20110201131512.GH31216@n2100.arm.linux.org.uk> <20110201141837.GA1147@pengutronix.de> <20110201143932.GK31216@n2100.arm.linux.org.uk> <20110201151846.GD1147@pengutronix.de> <20110201152458.GP31216@n2100.arm.linux.org.uk> <4D48741F.8060006@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D48741F.8060006@codeaurora.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 01, 2011 at 12:59:11PM -0800, Stephen Boyd wrote:
> On 02/01/2011 07:24 AM, Russell King - ARM Linux wrote:
> > I'd also be tempted at this stage to build-in a no-op dummy clock,
> > that being the NULL clk:
> >
> > int clk_prepare(struct clk *clk)
> > {
> > 	int ret = 0;
> >
> > 	if (clk) {
> > 		mutex_lock(&clk->mutex);
> > 		if (clk->prepared == 0)
> > 			ret = clk->ops->prepare(clk);
> > 		if (ret == 0)
> > 			clk->prepared++;
> > 		mutex_unlock(&clk->mutex);
> > 	}
> >
> > 	return ret;
> > }
> 
> I'm afraid this will hide enable/disable imbalances on some targets and
> then expose them on others. Maybe its not a big problem though since
> this also elegantly handles the root(s) of the tree.

You can't catch enable/disable imbalances in the prepare code, and you
can't really catch them in the unprepare code either.

Consider two drivers sharing the same struct clk.  When the second driver
prepares the clock, the enable count could well be non-zero, caused by
the first driver.  Ditto for when the second driver is removed, and it
calls unprepare - the enable count may well be non-zero.

The only thing you can check is that when the prepare count is zero,
the enable count is also zero.  You can also check in clk_enable() and
clk_disable() that the prepare count is non-zero.

If you want tigher checking than that, you need to somehow identify and
match up the clk_prepare/clk_enable/clk_disable/clk_unprepare calls from
a particular driver instance.  Addresses of the functions don't work as
you can't be certain that driver code will be co-located within a certain
range.  Adding an additional argument to these functions which is driver
instance specific seems to be horrible too.
