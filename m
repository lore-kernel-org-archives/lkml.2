Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751920Ab1BDMqh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Feb 2011 07:46:37 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:32956 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751120Ab1BDMqg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Feb 2011 07:46:36 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=psOIMv017tu0uWgsIQ24czJJMqJgiKsMp/cmi3lZEnczQSp4sNIWnXc63EKnpRdGZ5
         ekM0c8lD+sq4bBpAjtmkEs/OkUU8qfg0E52/PveasZKZZuClY5O8PzTs1EKV9SnjXF1x
         2mEukvfXN3TiAVzX90FcKarRHeKI5RzSvkUqc=
Date: Fri, 4 Feb 2011 20:45:34 +0800
From: Richard Zhao <linuxzsc@gmail.com>
To: Jeremy Kerr <jeremy.kerr@canonical.com>
Cc: Russell King <linux@arm.linux.org.uk>,
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
Message-ID: <20110204124534.GA2597@richard-laptop>
References: <201102011711.31258.jeremy.kerr@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201102011711.31258.jeremy.kerr@canonical.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 01, 2011 at 05:11:29PM +0800, Jeremy Kerr wrote:
> Hi all,
> 
> > I suggested that clk_prepare() be callable only from non-atomic contexts,
> > and do whatever's required to ensure that the clock is available.  That
> > may end up enabling the clock as a result.
> 
> I think that clk_prepare/clk_unprepare looks like the most promising solution, 
> so will try to get some preliminary patches done. Here's what I'm planning:
> 
> -----
> 
> The changes to the API are essentially:
> 
> 1) Document clk_enable/clk_disable as callable from atomic contexts, and
>    so clock implementations must not sleep within this function.
> 
> 2) For clock implementations that may sleep to turn on a clock, we add a
>    new pair of functions to the clock API: clk_prepare and clk_unprepare.
> 
>    These will provide hooks for the clock implmentation to do any sleepable
>    work (eg, wait for PLLs to settle) in preparation for a later clk_enable.
> 
>    For the most common clock implemntation cases (where clocks can be enabled 
>    atomically), these functions will be a no-op, and all of the enable/disable
>    work can be done in clk_enable/clk_disable.
> 
>    For implementations where clocks require blocking on enable/disable, most
>    of the work will be done in clk_prepare/clk_unprepare. The clk_enable
>    and clk_disable functions may be no-ops.
> 
> For drivers, this means that clk_prepare must be called (and have returned) 
> before calling clk_enable.
> 
> == Enable/Prepare counts ==
> 
> I intend to do the enable and prepare "counting" in the core clock API, 
> meaning that that the clk_ops callbacks will only invoked on the first 
> prepare/enable and the last unprepare/disable.
> 
> == Concurrency ==
> 
> Splitting the prepare and enable stages introduces the concurrency 
> requirements:
> 
> 1) clk_enable must not return before the clock is outputting a valid clock 
>    signal.
> 
> 2) clk_prepare must not return before the clock is fully prepared (ie, it is 
>    safe to call clk_enable).
> 
> It is not possible for clk_enable to wait for the clock to be prepared, 
> because that would require synchronisation with clk_prepare, which may then 
> require blocking. Therefore:
> 
> 3) The clock consumer *must* respect the proper ordering of clk_prepare and 
>    clk_enable. For example, drivers that call clk_enable during an interrupt 
>    must ensure that the interrupt handler will not be invoked until 
>    clk_prepare has returned.
> 
> == Other considerations ==
> 
> The time that a clock spends "prepared" is a superset of the the time that a 
> clock spends "enabled". Therefore, clocks that are switched on during 
> clk_prepare (ie, non-atomic clocks) will be running for a larger amount of 
> time. In some cases, this can be mitigated by moving some of the final 
> (atomic) switching functionality to the clk_enable function.
> 
> == Implementation ==
> 
> Basically:
> 
> struct clk {
> 	const struct clk_ops *ops
> 	int                  enable_count;
> 	spinlock_t           enable_lock;
> 	int                  prepare_count;
> 	struct mutex         prepare_lock;
> };
> 
> int clk_enable(struct clk *clk)
> {
> 	int ret = 0;
> 
> 	spin_lock(&clk->enable_lock);
> 	if (!clk->enable_count)
> 		ret = clk->ops->enable(clk);
> 
> 	if (!ret)
> 		clk->enable_count++;
> 	spin_unlock(&clk->enable_lock);
> 
> 	return ret;
> }
Why do we not call parent's clk_enable in this function? For flexible? How many
different cases is causing us to move the effert to platform clock driver?
> 
> int clk_prepare(struct clk *clk)
> {
> 	int ret = 0;
> 
> 	mutex_lock(&clk->prepare_lock);
> 	if (!clk->prepare_count)
> 		ret = clk->ops->prepare(clk);
> 
> 	if (!ret)
> 		clk->prepare_count++;
> 	mutex_unlock(&clk->prepare_lock);
> 
> 	return ret;
> }
Same as above.
And for most clocks, prepare/unprepare may be NULL. So in such case, is it
better to call parent's prepare and increase its own prepare_count here?

Thanks
Richard
> 
> -----
> 
> Comments welcome, code coming soon.
> 
> Cheers,
> 
> 
> Jeremy
> 
> 
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
