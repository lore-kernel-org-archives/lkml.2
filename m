Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757014Ab1BAOSv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 09:18:51 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:59693 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756881Ab1BAOSu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 09:18:50 -0500
Date: Tue, 1 Feb 2011 15:18:37 +0100
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Jeremy Kerr <jeremy.kerr@canonical.com>, Dima Zavin <dmitriyz@google.com>,
        Saravana Kannan <skannan@codeaurora.org>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        linux-sh@vger.kernel.org, Ben Herrenschmidt <benh@kernel.crashing.org>,
        Sascha Hauer <s.hauer@pengutronix.de>, linux-kernel@vger.kernel.org,
        Paul Mundt <lethal@linux-sh.org>, Ben Dooks <ben-linux@fluff.org>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        linux-arm-kernel@lists.infradead.org,
        Nicolas Pitre <nicolas.pitre@linaro.org>
Subject: Re: Locking in the clk API, part 2: clk_prepare/clk_unprepare
Message-ID: <20110201141837.GA1147@pengutronix.de>
References: <201102011711.31258.jeremy.kerr@canonical.com>
 <20110201105449.GY1147@pengutronix.de>
 <20110201131512.GH31216@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20110201131512.GH31216@n2100.arm.linux.org.uk>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 01, 2011 at 01:15:12PM +0000, Russell King - ARM Linux wrote:
> On Tue, Feb 01, 2011 at 11:54:49AM +0100, Uwe Kleine-König wrote:
> > Alternatively don't force the sleep in clk_prepare (e.g. by protecting
> > prepare_count by a spinlock (probably enable_lock)) and call clk_prepare
> > before calling clk->ops->enable?
> 
> That's a completely bad idea.  I assume you haven't thought about this
> very much.
Right, but I thought it a bit further than you did.  Like the following:
 
int clk_prepare(struct clk *clk)
{
	int ret = 0, first;
	unsigned long flags;

	spin_lock_irqsave(&clk->enable_lock, flags);
	if (clk->flags & CLK_BUSY) {
		/* 
		 * this must not happen, please serialize calls to
		 * clk_prepare/clk_enable
		 */
		ret = -EBUSY;
		goto out_unlock;
	}
	first = clk->prepare_count++ == 0;
	if (first)
		clk->flags |= CLK_BUSY;
	spin_unlock_irqrestore(&clk->enable_lock, flags);

	if (!first)
		return 0;

	if (clk->ops->prepare) {
		might_sleep();
		ret = clk->ops->prepare(clk);
	}

	spin_lock_irqsave(&clk->enable_lock, flags);
	clk->flags &= ~CLK_BUSY;
	if (ret)
		clk->prepare_count--;
out_unlock:
	spin_unlock_irqrestore(&clk->enable_lock, flags);

	return ret;
}

If you now find a problem with that you can blame me not having thought
it to an end.

And note, this is only a suggestion.  I.e. I don't know what is the best
to do in the case where I implemented returning -EBUSY above.  BUG?
Wait for CLK_BUSY to be cleared?

I'm not sure I like "clk_prepare sleeps iff unprepared but preparable".
Still I think the approach is worth to be discussed.

Best regards
Uwe

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
