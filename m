Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753204Ab1AJCnT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Jan 2011 21:43:19 -0500
Received: from adelie.canonical.com ([91.189.90.139]:39900 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751501Ab1AJCnS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Jan 2011 21:43:18 -0500
From: Jeremy Kerr <jeremy.kerr@canonical.com>
To: Sascha Hauer <s.hauer@pengutronix.de>
Subject: Re: [PATCH 1/2] Add a common struct clk
Date: Mon, 10 Jan 2011 10:43:04 +0800
User-Agent: KMail/1.13.5 (Linux/2.6.35-24-generic; KDE/4.5.1; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Ben Herrenchmidt <benh@kernel.crashing.org>,
        "Uwe =?iso-8859-1?q?Kleine-K=F6nig?=" 
	<u.kleine-koenig@pengutronix.de>
References: <1294199462.347935.472473715866.0.gpush@pororo> <1294199462.348449.192344022926.1.gpush@pororo> <20110108131520.GE26617@pengutronix.de>
In-Reply-To: <20110108131520.GE26617@pengutronix.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201101101043.05406.jeremy.kerr@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sascha,

> I'm currently thinking about how to get the locking right with this
> approach. In the current i.MX implementation we have a global lock which
> protects the clock enable counter and also the register accesses in the
> clock code. With the common struct clock we have a lock per clock which
> only protects the enable counter, so we have to introduce a second lock
> to protect the register accesses.

Are the registers shared between clocks? If not, you can just use the existing 
per-clk lock. Otherwise it'd be reasonable to add a global register lock, 
protecting accesses to the shared register set (and *only* protecting these 
registers).

> The problem comes with nested calls to for example clk_enable which
> happens when the parent clock gets enabled. currently we do this with
> clk->enable(clk->parent) which results in an unlocked clk_enable of the
> parent. With common struct clk we would have to call
> clk_enable(clk_get_parent(clk) which results in taking the lock a second
> time.
> Any ideas how to solve this?

With the shared register lock, you just need to make sure that you don't 
recurse to the parent while holding the lock.

For clocks with a shared register set, the general pattern would be something 
like:

struct clk_foo {
	struct clk clk;
	u32        enable_reg;
	u32        enable_mask;
	struct clk *parent;
};

static DEFINE_SPINLOCK(clk_foo_register_lock);

/* called with _clk->lock held */
static int clk_foo_enable(struct clk *_clk)
{
	struct clk_foo *clk = to_clk_foo(_clk);
	int reg, rc;

	/* enable parent - will acquire and release the parent's per-clk lock */
	rc = clk_enable(clk->parent);
	if (rc)
		return rc;

	/* do register update, under global register lock */
	spin_lock(&clk_foo_register_lock);

	reg = __raw_readl(clk->reg);
	__raw_writel(clk->reg, reg | clk->enable_mask);

	spin_unlock(&clk_foo_register_lock);

	return 0;
}

struct clk_foo_ops = {
	.enable = clk_foo_enable;
	[...]
};

However, because clk_mxc introduces its own set of abstractions, there may be 
some merging to do here. For my work on mx51, I've done a very basic port:

 * changed plat-mxc's struct clk to struct clk_mxc
 * embedded struct clk into struct clk_mxc (ie, making it use the common API)
 * separated some of the simpler clocks to separate types (eg clk_fixed,
   clk_pll, clk_ccgr).

The goal here is to separate all of the clocks into their most basic types, 
leaving no clk_mxc clocks remaining, then the locking should be much simpler.

Cheers,


Jeremy


