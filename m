Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755693Ab1AKKru (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jan 2011 05:47:50 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:43056 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755598Ab1AKKrq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jan 2011 05:47:46 -0500
Date: Tue, 11 Jan 2011 10:47:09 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
Cc: Jeremy Kerr <jeremy.kerr@canonical.com>, linux-sh@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Ben Herrenschmidt <benh@kernel.crashing.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        Vincent Guittot <vincent.guittot@linaro.org>
Subject: Re: Locking in the clk API
Message-ID: <20110111104709.GB11039@n2100.arm.linux.org.uk>
References: <201101111016.42819.jeremy.kerr@canonical.com> <20110111091607.GI12552@n2100.arm.linux.org.uk> <201101111744.59712.jeremy.kerr@canonical.com> <20110111103929.GN24920@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20110111103929.GN24920@pengutronix.de>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 11, 2011 at 11:39:29AM +0100, Uwe Kleine-König wrote:
> A quick look into Digi's BSP (digiEL-5.0) shows they implemented
> something I suggested earlier here:
> 
> 	static int clk_enable_haslocknchange(struct clk *clk)
> 	{
> 		int ret = 0;
> 
> 		assert_spin_locked(&clk_lock);
> 		BUG_ON(!test_bit(CLK_FLAG_CHANGESTATE, &clk->flags));
> 
> 		if (clk->usage++ == 0) {
> 			if (clk->parent) {
> 				ret = clk_enable_haslock(clk->parent);
> 				if (ret)
> 					goto err_enable_parent;
> 			}
> 
> 			spin_unlock(&clk_lock);
> 
> 			if (clk->endisable)
> 				ret = clk->endisable(clk, 1);
> 
> 			spin_lock(&clk_lock);
> 
> 			if (ret) {
> 				clk_disable_parent_haslock(clk);
> 	err_enable_parent:
> 				clk->usage = 0;
> 			}
> 		}
> 
> 		return ret;
> 	}
> 
> 	static int clk_enable_haslock(struct clk *clk)
> 	{
> 		int ret;
> 		assert_spin_locked(&clk_lock);
> 		if (__test_and_set_bit(CLK_FLAG_CHANGESTATE, &clk->flags))
> 			return -EBUSY;
> 
> 		ret = clk_enable_haslocknchange(clk);
> 
> 		clear_bit(CLK_FLAG_CHANGESTATE, &clk->flags);
> 
> 		return ret;
> 	}
> 
> 	int clk_enable(struct clk *clk)
> 	{
> 		...
> 		spin_lock_irqsave(&clk_lock, flags);
> 		ret = clk_enable_haslock(clk);
> 		spin_unlock_irqrestore(&clk_lock, flags);
> 		return ret;
> 	}
> 
> 
> I think the idea is nice.  At least it allows with a single lock to
> implement both, sleeping and atomic clks without the need to mark the
> atomicity in a global flag.

It doesn't.  clk_enable() here can still end up trying to sleep when
it's called from IRQ context - the code doesn't solve that.  All it
means is that the intermediate code doesn't care whether clk->endisable
ends up sleeping or not.

What it does do is return -EBUSY if there are two concurrent attempts
to enable the same clock.  How many drivers today deal sanely with
such an error from clk_enable(), and how many would just fail their
probe() call on such an occurance?
