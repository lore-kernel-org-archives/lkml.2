Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756588Ab0FDAGK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jun 2010 20:06:10 -0400
Received: from trinity.fluff.org ([89.16.178.74]:54334 "EHLO trinity.fluff.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754110Ab0FDAGI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jun 2010 20:06:08 -0400
Date: Fri, 4 Jun 2010 01:06:05 +0100
From: Ben Dooks <ben-linux@fluff.org>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Jeremy Kerr <jeremy.kerr@canonical.com>, Ben Dooks <ben-linux@fluff.org>,
       Ben Herrenchmidt <benh@kernel.crashing.org>,
       linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [RFC,PATCH 1/2] Add a common struct clk
Message-ID: <20100604000605.GF4720@trinity.fluff.org>
References: <1275479804.137633.565764505843.0.gpush@pororo> <201006031121.21896.jeremy.kerr@canonical.com> <20100603081354.GA4720@trinity.fluff.org> <201006031824.53832.jeremy.kerr@canonical.com> <20100603110533.GB7127@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100603110533.GB7127@n2100.arm.linux.org.uk>
X-Disclaimer: These are my views alone.
X-URL: http://www.fluff.org/
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: ben@trinity.fluff.org
X-SA-Exim-Scanned: No (on trinity.fluff.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 03, 2010 at 12:05:33PM +0100, Russell King - ARM Linux wrote:
> On Thu, Jun 03, 2010 at 06:24:50PM +0800, Jeremy Kerr wrote:
> > OK, this would mean adding parent to struct clk:
> > 
> > struct clk {
> > 	struct clk_operations	*ops;
> > 	atomic_t				enable_count;
> 
> I don't think it makes sense for this to be an atomic type.
> 
> > static inline int clk_enable(struct clk *clk)
> > {
> > 	int ret;
> > 
> > 	if (atomic_inc(clk->enable_count) != 1))
> > 		return 0;
> 
> Okay, so what if we sleep at this point, and someone else comes along
> and calls clk_enable(), which'll merely increment the count and return.
> 
> Unfortunately, the clock is still disabled at that point - which is a
> violation of what's supposed to happen.
> 
> Or to put it another way, the above method results in clk_enable()
> sometimes returning with the clock enabled and sometimes with the
> clock still disabled.
> 
> That's not nice behaviour for drivers which may need the clock enabled
> to read/write the device registers.

You're right, especially if the clock takes time to enable.

Either we need some form of locking to deal with this. An overall lock
will cause problems with respect to re-using clk_enable() internally
and per-clock locks are probably a bad idea with respect of trying to
lock the parents (deadlock) depending on the implementation.

I'm not sure if something like a wake queue is required, where any caller
who is calling when the clock is disabled gets placed on the queue
awaiting the original enabler finishing the enable operation.

	 if (atomic_increment(&clk->usage_count) == 1) {
	    /* start enable */
	    atomic_set(&clk->is_enabled, 1);
	    wake_up(&clk->wait_for_enable);   
	 } else if (atomic_read(&clk->is_enabled) == 0) {
	   wait_event(&clk->wait_for_enable);
	 }

Also, what about the behaviour across >1 CPU? There's a pile of
up-comming SoCs with SMP ARM cores. If CPU1 enables the clock, and CPU2
comes along and tries to do that also, we have the same race condition
again.

As an addendum to Russell's comments, we need to specify the behaviour
with resepect to what happens about clock stabilisation as well, if the
clock we enabled takes time to stabilise, then should we wait? This will
be even worse when we realise some of these architectures have clocks
which are source from PLLs that can be turned on/off, and these PLLs
have settling time in 100s of usecs.

Even if the clock is enabled, it requires time to stabilise to avoid
problems when the driver then goes to try and use it.

-- 
Ben

Q:      What's a light-year?
A:      One-third less calories than a regular year.

