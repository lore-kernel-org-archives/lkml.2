Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754785Ab1BDJzb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Feb 2011 04:55:31 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:43926 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753434Ab1BDJz2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Feb 2011 04:55:28 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=F8320u7K5ge6cXl6ORFbjMYq48HqbXBMZigI5A4HLxy4yyJuZkTilyRo+heT584umF
         OAlypWEndOrsrsQ4ff0HSx3Sz9E/cd8gWyGGaQh4FppQ2boo+SDcNJh48QHrvTRpwVZe
         9/63KZ0dsQd2lnrJjmQDr0hiSo4sksoS3Ttss=
Date: Fri, 4 Feb 2011 17:54:24 +0800
From: Richard Zhao <linuxzsc@gmail.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Stephen Boyd <sboyd@codeaurora.org>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Dima Zavin <dmitriyz@google.com>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        Vincent Guittot <vincent.guittot@linaro.org>, linux-sh@vger.kernel.org,
        Ben Herrenschmidt <benh@kernel.crashing.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Paul Mundt <lethal@linux-sh.org>, linux-kernel@vger.kernel.org,
        Saravana Kannan <skannan@codeaurora.org>,
        Ben Dooks <ben-linux@fluff.org>,
        Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        Jeremy Kerr <jeremy.kerr@canonical.com>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: Locking in the clk API, part 2: clk_prepare/clk_unprepare
Message-ID: <20110204095424.GB2347@richard-laptop>
References: <201102011711.31258.jeremy.kerr@canonical.com>
 <20110201105449.GY1147@pengutronix.de>
 <20110201131512.GH31216@n2100.arm.linux.org.uk>
 <20110201141837.GA1147@pengutronix.de>
 <20110201143932.GK31216@n2100.arm.linux.org.uk>
 <20110201151846.GD1147@pengutronix.de>
 <20110201152458.GP31216@n2100.arm.linux.org.uk>
 <4D48741F.8060006@codeaurora.org>
 <20110201212409.GU31216@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110201212409.GU31216@n2100.arm.linux.org.uk>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 01, 2011 at 09:24:09PM +0000, Russell King - ARM Linux wrote:
> On Tue, Feb 01, 2011 at 12:59:11PM -0800, Stephen Boyd wrote:
> > On 02/01/2011 07:24 AM, Russell King - ARM Linux wrote:
> > > I'd also be tempted at this stage to build-in a no-op dummy clock,
> > > that being the NULL clk:
> > >
> > > int clk_prepare(struct clk *clk)
> > > {
> > > 	int ret = 0;
> > >
> > > 	if (clk) {
> > > 		mutex_lock(&clk->mutex);
> > > 		if (clk->prepared == 0)
> > > 			ret = clk->ops->prepare(clk);
> > > 		if (ret == 0)
> > > 			clk->prepared++;
> > > 		mutex_unlock(&clk->mutex);
> > > 	}
> > >
> > > 	return ret;
> > > }
> > 
> > I'm afraid this will hide enable/disable imbalances on some targets and
> > then expose them on others. Maybe its not a big problem though since
> > this also elegantly handles the root(s) of the tree.
> 
> You can't catch enable/disable imbalances in the prepare code, and you
> can't really catch them in the unprepare code either.
> 
> Consider two drivers sharing the same struct clk.  When the second driver
> prepares the clock, the enable count could well be non-zero, caused by
> the first driver.  Ditto for when the second driver is removed, and it
> calls unprepare - the enable count may well be non-zero.
> 
> The only thing you can check is that when the prepare count is zero,
> the enable count is also zero.  You can also check in clk_enable() and
> clk_disable() that the prepare count is non-zero.
but how can we check prepare count without mutex lock? Even if prepare count
is atomic_t, it can not guarantee the clock is actually prepared or unprepared.
So it's important for driver writer to maintain the call sequence.

Thanks
Richard
> 
> If you want tigher checking than that, you need to somehow identify and
> match up the clk_prepare/clk_enable/clk_disable/clk_unprepare calls from
> a particular driver instance.  Addresses of the functions don't work as
> you can't be certain that driver code will be co-located within a certain
> range.  Adding an additional argument to these functions which is driver
> instance specific seems to be horrible too.
> 
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
