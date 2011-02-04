Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752853Ab1BDNV0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Feb 2011 08:21:26 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:51112 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752286Ab1BDNVZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Feb 2011 08:21:25 -0500
Date: Fri, 4 Feb 2011 13:20:40 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Richard Zhao <linuxzsc@gmail.com>
Cc: Jeremy Kerr <jeremy.kerr@canonical.com>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        Saravana Kannan <skannan@codeaurora.org>, linux-sh@vger.kernel.org,
        Ben Herrenschmidt <benh@kernel.crashing.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Paul Mundt <lethal@linux-sh.org>, linux-kernel@vger.kernel.org,
        Dima Zavin <dmitriyz@google.com>, Ben Dooks <ben-linux@fluff.org>,
        Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: Locking in the clk API, part 2: clk_prepare/clk_unprepare
Message-ID: <20110204132040.GI14627@n2100.arm.linux.org.uk>
References: <201102011711.31258.jeremy.kerr@canonical.com> <20110204124534.GA2597@richard-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110204124534.GA2597@richard-laptop>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 04, 2011 at 08:45:34PM +0800, Richard Zhao wrote:
> > == Implementation ==
> > 
> > Basically:
> > 
> > struct clk {
> > 	const struct clk_ops *ops
> > 	int                  enable_count;
> > 	spinlock_t           enable_lock;
> > 	int                  prepare_count;
> > 	struct mutex         prepare_lock;
> > };
> > 
> > int clk_enable(struct clk *clk)
> > {
> > 	int ret = 0;
> > 
> > 	spin_lock(&clk->enable_lock);
> > 	if (!clk->enable_count)
> > 		ret = clk->ops->enable(clk);
> > 
> > 	if (!ret)
> > 		clk->enable_count++;
> > 	spin_unlock(&clk->enable_lock);
> > 
> > 	return ret;
> > }
> Why do we not call parent's clk_enable in this function? For flexible? How many
> different cases is causing us to move the effert to platform clock driver?

You may notice that struct clk above doesn't have a parent.
