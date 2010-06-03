Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933772Ab0FCDVh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jun 2010 23:21:37 -0400
Received: from adelie.canonical.com ([91.189.90.139]:46568 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933743Ab0FCDVg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jun 2010 23:21:36 -0400
From: Jeremy Kerr <jeremy.kerr@canonical.com>
To: Ben Dooks <ben-linux@fluff.org>
Subject: Re: [RFC,PATCH 1/2] Add a common struct clk
Date: Thu, 3 Jun 2010 11:21:19 +0800
User-Agent: KMail/1.13.2 (Linux/2.6.32-22-generic; KDE/4.4.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
       Ben Herrenchmidt <benh@kernel.crashing.org>
References: <1275479804.137633.565764505843.0.gpush@pororo> <1275479804.138101.137592675542.1.gpush@pororo> <20100602120356.GQ7248@trinity.fluff.org>
In-Reply-To: <20100602120356.GQ7248@trinity.fluff.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201006031121.21896.jeremy.kerr@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ben,

> > And a set of clock operations (defined per type of clock):
> > 
> > struct clk_operations {
> > 
> >        int             (*enable)(struct clk *);
> 
> I'd rather the enable/disable calls where simply a set
> and a bool on/off, very rarelyt is the enable and disable
> operartions different.

I thought about merging these, but decided against it. It does work for the 
simple case where we're setting a bit in a register:

static int clk_foo_set_state(struct clk *_clk, int enable)
{
	struct clk_foo *clk = to_clk_foo(_clk)
	u32 reg;

	reg = raw_readl(foo->some_register);
	if (enable)
		reg |= FOO_ENABLE;
	else
		reg &= ~FOO_ENABLE;
	raw_writel(foo->some_register, reg);

	return 0;
}

However, for anything more complex than this - for example, if there's a 
parent clock - then we start getting pretty messy:

static int clk_foo_set_state(struct clk *_clk, int enable)
{
	struct clk_foo *clk = to_clk_foo(_clk)
	u32 reg;

	if (enable) {
		int ret = clk_enable(clk->parent);
		if (ret)
			return ret;
	}

	reg = raw_readl(foo->some_register);
	if (enable)
		reg |= FOO_ENABLE;
	else
		reg &= ~FOO_ENABLE;

	raw_writel(foo->some_register, reg);

	if (!enable)
		clk_disable(clk->parent);

	return 0;
}

- where most of the function becomes surrounded by "if (enable)" statements. 

I'm aware that we can turn this into a conditional call of clk_foo_enable or 
clk_foo_disable, but then we're back to square 1. I also think that the simple 
case is clearer (if a little more verbose) with separate functions.

Also, enable and disable in the external clock API have different return 
types.

> an aside, you might want to just clal these clk_ops to get into the
> spirit of the original naming.

Either is fine with me - looks like 'ops' is more commonly used:

$ git grep -E '^struct \w*operations\s*\{' include/ | wc -l
30

$ git grep -E '^struct \w*ops\s*{' include/ | wc -l
138

Cheers,


Jeremy
