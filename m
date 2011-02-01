Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757274Ab1BAOk4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 09:40:56 -0500
Received: from adelie.canonical.com ([91.189.90.139]:56229 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757041Ab1BAOky (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 09:40:54 -0500
From: Jeremy Kerr <jeremy.kerr@canonical.com>
To: "Uwe =?iso-8859-1?q?Kleine-K=F6nig?=" 
	<u.kleine-koenig@pengutronix.de>
Subject: Re: Locking in the clk API, part 2: clk_prepare/clk_unprepare
Date: Tue, 1 Feb 2011 22:40:37 +0800
User-Agent: KMail/1.13.5 (Linux/2.6.35-24-generic; KDE/4.5.1; x86_64; ; )
Cc: "Russell King - ARM Linux" <linux@arm.linux.org.uk>,
        Dima Zavin <dmitriyz@google.com>,
        Saravana Kannan <skannan@codeaurora.org>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        linux-sh@vger.kernel.org, Ben Herrenschmidt <benh@kernel.crashing.org>,
        Sascha Hauer <s.hauer@pengutronix.de>, linux-kernel@vger.kernel.org,
        Paul Mundt <lethal@linux-sh.org>, Ben Dooks <ben-linux@fluff.org>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        linux-arm-kernel@lists.infradead.org,
        Nicolas Pitre <nicolas.pitre@linaro.org>
References: <201102011711.31258.jeremy.kerr@canonical.com> <20110201131512.GH31216@n2100.arm.linux.org.uk> <20110201141837.GA1147@pengutronix.de>
In-Reply-To: <20110201141837.GA1147@pengutronix.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201102012240.38100.jeremy.kerr@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Uwe,

Thanks for the feedback, I'm not sure I like the more complex approach though:

> Right, but I thought it a bit further than you did.  Like the following:
> 
> int clk_prepare(struct clk *clk)
> {
> 	int ret = 0, first;
> 	unsigned long flags;
> 
> 	spin_lock_irqsave(&clk->enable_lock, flags);
> 	if (clk->flags & CLK_BUSY) {
> 		/*
> 		 * this must not happen, please serialize calls to
> 		 * clk_prepare/clk_enable
> 		 */
> 		ret = -EBUSY;
> 		goto out_unlock;

Why is this an error? Two separate drivers may be clk_prepare()-ing at the 
same time, which should be acceptable. Both calls should block until the 
prepare is complete.

> 	}
> 	first = clk->prepare_count++ == 0;
> 	if (first)
> 		clk->flags |= CLK_BUSY;
> 	spin_unlock_irqrestore(&clk->enable_lock, flags);
> 
> 	if (!first)
> 		return 0;
> 
> 	if (clk->ops->prepare) {
> 		might_sleep();
> 		ret = clk->ops->prepare(clk);
> 	}
> 
> 	spin_lock_irqsave(&clk->enable_lock, flags);
> 	clk->flags &= ~CLK_BUSY;
> 	if (ret)
> 		clk->prepare_count--;
> out_unlock:
> 	spin_unlock_irqrestore(&clk->enable_lock, flags);
> 
> 	return ret;
> }

Cheers,


Jeremy

