Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754156Ab1BOCmB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Feb 2011 21:42:01 -0500
Received: from adelie.canonical.com ([91.189.90.139]:43549 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751196Ab1BOCl6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Feb 2011 21:41:58 -0500
From: Jeremy Kerr <jeremy.kerr@canonical.com>
To: linux-arm-kernel@lists.infradead.org
Subject: Re: [RFC,PATCH 1/3] Add a common struct clk
Date: Tue, 15 Feb 2011 10:41:40 +0800
User-Agent: KMail/1.13.5 (Linux/2.6.35-25-generic; KDE/4.5.1; x86_64; ; )
Cc: Saravana Kannan <skannan@codeaurora.org>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Dima Zavin <dmitriyz@google.com>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        Vincent Guittot <vincent.guittot@linaro.org>, linux-sh@vger.kernel.org,
        Ben Herrenschmidt <benh@kernel.crashing.org>,
        Sascha Hauer <s.hauer@pengutronix.de>, linux-kernel@vger.kernel.org,
        Paul Mundt <lethal@linux-sh.org>, Ben Dooks <ben-linux@fluff.org>,
        "Uwe =?iso-8859-1?q?Kleine-K=F6nig?=" 
	<u.kleine-koenig@pengutronix.de>,
        Russell King <linux@arm.linux.org.uk>
References: <1297233693.242364.862698430999.1.gpush@pororo> <4D53749B.6010102@codeaurora.org>
In-Reply-To: <4D53749B.6010102@codeaurora.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201102151041.40655.jeremy.kerr@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Saravana,

> Shouldn't you be grabbing the prepare_lock here?

This depends on semantics that (as far as I can tell) aren't defined yet. We 
may even want to disallow set_rate (and set_parent) when prepare_count is non-
zero.

Ideally, we should work out what the semantics are with regards to changing a 
clock's rate when it has multiple users and/or is enabled or prepared, but 
that's a separate issue, and we should *definitely* implement that as a 
separate change.

I'd prefer to enforce the 'sleepability' with might_sleep instead.

> You should probably rename the lock to something else since it's not
> limited to prepare/unprepare. How about resource_lock?

It's not, but that's the only thing it's protecting in the common code. I'm 
open for better names, but resource_lock is too generic.

> > +int clk_set_parent(struct clk *clk, struct clk *parent)
> > +{
> > +	if (clk->ops->set_parent)
> > +		return clk->ops->set_parent(clk, parent);
> 
> I'm not sure on this one. If the prepare ops for a clock also calls the
> prepare ops on the parent, shouldn't we prevent changing the parent
> while the prepare/unprepare is going on?

Again, this is related to set_rate during enable/disable or prepare/unprepare; 
we don't have defined semantics for this at present.

> > +
> > +/* static initialiser for clocks */
> > +#define INIT_CLK(name, o) {						\
> > +	.ops		=&o,						\
> > +	.enable_count	= 0,						\
> > +	.prepare_count	= 0,						\
> 
> Do we need these inits? Doesn't check patch complain about initing
> static/global to 0? If it's generally frowned upon, why the exception
> here. I realize that checkpatch won't catch this, but still...

This took some reading through c99, but yes, it looks like we can drop these 
zero initialisations.

However, the coding style convention for the implicit zeroing of static 
variables is to allow these variables to be put into the .bss section, 
reducing object size. In this case, the clock will never be able to go into 
.bss (it has non-zero elements too), and so this will have no change on object 
size. I prefer to be explicit here, and show that the counts are initialised 
to zero.

I'm happy to go either way. I have a preference for the explicit 
initialisation, but that may not be general style.

> 
> > +	.enable_lock	= __SPIN_LOCK_UNLOCKED(name.enable_lock),	\
> > +	.prepare_lock	= __MUTEX_INITIALIZER(name.prepare_lock),	\
> 
> After a long day, I'm not able to wrap my head around this. Probably a
> stupid question, but will this name.xxx thing prevent using this
> INIT_CLK macro to initialize an array of clocks? More specifically,
> prevent the sub class macro (like INIT_CLK_FIXED) from being used to
> initialize an array of clocks?

That's correct. For an array of clocks, you'll have to use a different 
initialiser. We can add helpers for that that when (and if) the need arises.

> > + * The clk_enable/clk_disable and clk_prepare/clk_unprepare pairs allow
> > + * implementations to split any work between atomic (enable) and
> > sleepable + * (prepare) contexts.  If a clock requires blocking code to
> > be turned on, this
> 
> Aren't all locks blocking? Shouldn't it be, "If turning on a clock
> requires code that might sleep, it should be done in clk_prepare"?
> Replace all "blocking" with "sleepable" or "sleeping" in the comments?

I think "blocking" is generally accepted as is intended in this case, but it's 
probably better to be explicit here.
> 
> > + * should be done in clk_prepare. Switching that will not block should
> > be done + * in clk_enable.
> > + *
> > + * Typically, drivers will call clk_prepare when a clock may be needed
> > later + * (eg. when a device is opened), and clk_enable when the clock
> > is actually + * required (eg. from an interrupt). Note that clk_prepare
> > *must* have been + * called before clk_enable.
> > + *
> > + * For other callbacks, see the corresponding clk_* functions.
> > Parameters and + * return values are passed directly from/to these API
> > functions, or + * -ENOSYS (or zero, in the case of clk_get_rate) is
> > returned if the callback + * is NULL, see kernel/clk.c for
> > implementation details. All are optional.
> 
> is NULL. See kernel... ?

Ah, yes, I'll update this.

Cheers,


Jeremy
