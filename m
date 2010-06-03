Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933824Ab0FCKZL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jun 2010 06:25:11 -0400
Received: from adelie.canonical.com ([91.189.90.139]:49773 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933486Ab0FCKZI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jun 2010 06:25:08 -0400
From: Jeremy Kerr <jeremy.kerr@canonical.com>
To: Ben Dooks <ben-linux@fluff.org>
Subject: Re: [RFC,PATCH 1/2] Add a common struct clk
Date: Thu, 3 Jun 2010 18:24:50 +0800
User-Agent: KMail/1.13.2 (Linux/2.6.32-22-generic; KDE/4.4.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
       Ben Herrenchmidt <benh@kernel.crashing.org>
References: <1275479804.137633.565764505843.0.gpush@pororo> <201006031121.21896.jeremy.kerr@canonical.com> <20100603081354.GA4720@trinity.fluff.org>
In-Reply-To: <20100603081354.GA4720@trinity.fluff.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201006031824.53832.jeremy.kerr@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ben,

> clk_enable(struct clk *clk)
> {
> 	if (clk->parent)
> 		clk_enable(clk->parent)
> 	...
> }
> 
> clk_disable(struct clk *clk)
> {
> 	...
> 	if (clk->parent)
> 		clk_disable(clk->parent)
> }
> 
> I think it is a really bad idea for each implementation to have to worry
> about this. It sounds like a recipie for people to get wrong, especially
> if we have a number of these implementations kicking around.

OK, this would mean adding parent to struct clk:

struct clk {
	struct clk_operations	*ops;
	atomic_t				enable_count;
	struct clk			*parent;
};

I was originally intending for struct clk to have the absolute minimum of 
fields, only those necessary for every clock in the system. parent didn't make 
the cut, as some clocks don't have a parent.

However, lets explore this a little - handling parents in the infrastructure 
code this may simplify the hardware-specific code somewhat. We'd add the 
parent-handling stuff to the global clk_enable/clk_disable:

static inline int clk_enable(struct clk *clk)
{
	int ret;

	if (atomic_inc(clk->enable_count) != 1))
		return 0;

	if (clk->parent) {
		ret = clk_enable(clk->parent);
		if (ret)
			goto out_dec;
	}

	ret = clk->ops->enable(clk)
	if (!ret)
		return 0;

out_dec:
	atomic_dec(clk->enable_count);
	return ret;
}

The downside here is that the static inline becomes quite bloated, and we can 
no longer avoid the atomic operation if there is no enable op. I guess we 
could add a:

	if (!clk->ops->enable && !clk->parent)
		return 0;

but now were in serious "don't do that as a inline" territory. So we'd be 
better off making this a proper function.

[as an aside, I need to add the atomic_dec to the error path of my current 
code, will respin a new version. But even then, it's small enough to inline]

I think that handling the enable/disable in the hardware-specific op is an 
acceptable solution. It's only one line of code (or two if you want to check 
for the presence of a parent first), and is, after all, a hardware-specific 
property of the clock.

So, we either:

1) keep it as is, with the hw-specific code handling parent enable/disable; or

2) add the parent-handling code to the clock infrastructure and move the core
   API functions out-of-line.

> As a note, I also left the enable callback in the 'struct clk' instead
> of in the ops, enable/disable is the most used case of these clock
> functions, and as such should probably be the easiest to get to.

I strongly disagree on this one. I want all of the ops in one place, not 
scattered around the API.

> Also, wheras plat-samsung has very few sets of clk_ops sitting about,
> there are more enable/disable calls, and adding more fields to the
> clocks to deal with this would add extra space to the kernel.

Sorry, I don't think I understand your point here - you're saying that moving 
the enable/disable callbacks to struct clk will increase the size of the 
kernel (which is correct, as there are more struct clks than there are struct 
clk_operations), so doesn't this provide an argument against doing this?

> > Also, enable and disable in the external clock API have different return
> > types.
> 
> does that really matter?

Only if someone expects a failed disable to be detected by the driver.

> > Either is fine with me - looks like 'ops' is more commonly used:
> My pref. is for less typing.

OK, will do this in the next revision.

Cheers,


Jeremy
