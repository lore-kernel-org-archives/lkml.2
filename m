Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756783Ab1BANQl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 08:16:41 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:58234 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751640Ab1BANQk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 08:16:40 -0500
Date: Tue, 1 Feb 2011 13:15:12 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
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
Message-ID: <20110201131512.GH31216@n2100.arm.linux.org.uk>
References: <201102011711.31258.jeremy.kerr@canonical.com> <20110201105449.GY1147@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20110201105449.GY1147@pengutronix.de>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 01, 2011 at 11:54:49AM +0100, Uwe Kleine-König wrote:
> Alternatively don't force the sleep in clk_prepare (e.g. by protecting
> prepare_count by a spinlock (probably enable_lock)) and call clk_prepare
> before calling clk->ops->enable?

That's a completely bad idea.  I assume you haven't thought about this
very much.

There's two ways I can think of doing what you're suggesting:

int clk_prepare(struct clk *clk)
{
	unsigned long flags;
	int ret = 0;

	might_sleep();

	spin_lock_irqsave(&clk->enable_lock, flags);
	if (clk->prepare_count++ == 0)
		ret = clk->ops->prepare(clk);
	spin_unlock_irqrestore(&clk->enable_clock, flags);

	return ret;
}

The problem is that clk->ops->prepare() is called in a non-sleepable
context.  So this breaks the whole idea of clk_prepare(), and so isn't
a solution.

The other solution is:

int clk_prepare(struct clk *clk)
{
	unsigned long flags;
	int ret = 0;
	bool first;

	might_sleep();

	spin_lock_irqsave(clk->enable_lock, flags);
	first = clk->prepare_count++ == 0;
	spin_unlock_irqrestore(clk->enable_clock, flags);

	if (first)
		ret = clk->ops->prepare(clk);

	return ret;
}

The problem with this is that you now don't have any sane locking on
the prepare callback, and the circumstances under which it's called
are very indefinite.  For example, consider a preempt-enabled system:

	thread 1		thread 2		prepare_count
	clk_prepare					0
	clk->prepare_count++				1
	<thread switch>
				clk_prepare		1
				clk->prepare_count++	2
				clk_prepare returns	2

				clk_enable		2
				<explodes as clock is not prepared>
				<thread switch>
	clk->ops->prepare(clk)

So really, what you're suggesting is completely broken.
