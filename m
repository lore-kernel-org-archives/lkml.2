Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755371Ab0FNDKg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jun 2010 23:10:36 -0400
Received: from adelie.canonical.com ([91.189.90.139]:53707 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755297Ab0FNDKe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jun 2010 23:10:34 -0400
From: Jeremy Kerr <jeremy.kerr@canonical.com>
To: Ben Dooks <ben-linux@fluff.org>
Subject: Re: [RFC,PATCH 1/2] Add a common struct clk
Date: Mon, 14 Jun 2010 11:10:25 +0800
User-Agent: KMail/1.13.2 (Linux/2.6.32-22-generic; KDE/4.4.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
       Ben Herrenchmidt <benh@kernel.crashing.org>
References: <1275636608.606606.450179637764.0.gpush@pororo> <201006111557.12249.jeremy.kerr@canonical.com> <20100613222349.GD31045@fluff.org.uk>
In-Reply-To: <20100613222349.GD31045@fluff.org.uk>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201006141110.26440.jeremy.kerr@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ben,

> You also need a warning that even if it protects the clock, it may not
> protect any access to the hardware implementing it.

Yep, agreed. HW clock implementations are free to acquire the mutex in their 
ops.

> > I believe we need to ensure that clocks are enabled when clk_enable
> > returns, so we'll need some mechanism for waiting on the thread doing
> > the enable/disable. Since (as you say) some clocks may take 100s of
> > microseconds to enable, we'll need a lock that we can hold while
> > sleeping.
> 
> Well, mutexes give us that, whilst enabling we hold the mutex.

Exactly, that's why I think the mutex option is the best way to go.

> > I've just yesterday added the following to my tree, to allow dynamic
> > initialisation:
> > 
> > static inline void clk_init(struct clk *clk, const struct clk_ops *ops)
> > {
> > 
> > 	clk->ops = ops;
> > 	clk->enable_count = 0;
> > 	mutex_init(&clk->mutex);
> > 
> > }
> > 
> > So we can do this either way.
> 
> the above is in my view better.

By 'the above' do you mean doing the mutex init at registration time, or the 
clk_init code above?

Either way should be fine; delaying the mutex_init until registration will has 
the nice property of not requiring the clock name to be passed to INIT_CLK.

> > I've been debating dropping the get_parent and set_parent ops entirely,
> > actually; setting a parent seems to be quite specific to hardware (you
> > have to know that a particular clock can be a parent of another clock),
> > so it seems like something that we shouldn't expose to drivers through
> > this API. For the code that knows the hardware, it can probably access
> > the underlying clock types directly.
> 
> Not really, and it is in use with extant drivers, so not easily
> removable either.

OK, is set_parent used much? I can see the use of get_parent, but calls 
set_parent need to know specifics of the clock hardware.

> > Checking for the ops first allows us to skip the mutex acquire, but I'm
> > happy either way.
> 
> erm, sorry, yes, you can check for them before mutex. any chages
> should be done with mutex held.

Yep.

> > Using default ops would mean a couple of things:
> > 
> > 1) we can no longer mark the real ops as const; and
> > 2) we can no longer avoid the hard-to-predict indirect branch
> 
> ok, how about people have to mark these as a default non op in their
> clock structure, and then error if they try and register a clock with
> null ops. anyone changing these to NULL later deserves all the pain and
> agony they get.

That addresses the first point, but still means we have an unnecessary 
indirect branch to a function that does nothing. Since I've unlined the code 
where this happens, the checks for null ops are pretty unobtrusive. If we 
require all ops to be not-null, then we'll need much larger chunks of code 
where the ops are defined. I like that you can just set the ops callbacks that 
you need, and the rest "just works".

Cheers,


Jeremy
