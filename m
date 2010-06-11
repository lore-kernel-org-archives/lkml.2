Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758186Ab0FKH5Y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jun 2010 03:57:24 -0400
Received: from adelie.canonical.com ([91.189.90.139]:39680 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752868Ab0FKH5X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jun 2010 03:57:23 -0400
From: Jeremy Kerr <jeremy.kerr@canonical.com>
To: Ben Dooks <ben-linux@fluff.org>
Subject: Re: [RFC,PATCH 1/2] Add a common struct clk
Date: Fri, 11 Jun 2010 15:57:10 +0800
User-Agent: KMail/1.13.2 (Linux/2.6.32-22-generic; KDE/4.4.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
       Ben Herrenchmidt <benh@kernel.crashing.org>
References: <1275636608.606606.450179637764.0.gpush@pororo> <1275636608.607067.417709988883.1.gpush@pororo> <20100611042046.GA31045@fluff.org.uk>
In-Reply-To: <20100611042046.GA31045@fluff.org.uk>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201006111557.12249.jeremy.kerr@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ben,

> > Platforms can enable the generic struct clock through
> > CONFIG_USE_COMMON_STRUCT_CLK. In this case, the clock infrastructure
> > consists of a common struct clk:
>
> What do people think of just changing everyone who is currently using
> clk support to using this new implementation?

I think it'd be too-big a task to take on for a single change; we'd be better 
off allowing the two implementations concurrently. Also, I'd say that there 
are many platforms that will never need the new code, so no need to change 
them over.

> > struct clk {
> > 
> > 	const struct clk_ops	*ops;
> > 	unsigned int		enable_count;
> > 	struct mutex		mutex;
> 
> I'm a little worried about the size of struct clk if all of them
> have a mutex in them. If i'm right, this is 40 bytes of data each
> clock has to take on board.

Yeah, I see your concern about adding a mutex per clock, but I do think it's 
the best solution. Of course, if there's a better way to do it, I'm happy to 
try it out.

I believe we need to ensure that clocks are enabled when clk_enable returns, 
so we'll need some mechanism for waiting on the thread doing the 
enable/disable. Since (as you say) some clocks may take 100s of microseconds 
to enable, we'll need a lock that we can hold while sleeping.

We could use a global mutex for all clocks, but that would complicate the 
interface by requiring non-locking versions of enable/disable, to allow 
recursive enable/disable of parent clocks. Also, we'd lose any parallelism 
possible in clock initialisation (we want boot to be fast, right?)

Without all the debug stuff, it looks like a mutex is 12 bytes on UP, 20 on 
SMP. That brings the maximum possible overhead to 26kB/43kB. More tolerable, 
but not great.

You know what would be awesome? if we could put platform-specific code in 
their own sections and the discard the ones we know we won't need after boot. 
But that's a discussion for another day...

> >        int             (*enable)(struct clk *);
> 
> still think that not passing an bool as a second argument is silly.

Still don't :D

> > +struct clk {
> > +	const struct clk_ops	*ops;
> > +	unsigned int		enable_count;
> > +	struct mutex		mutex;
> > +};
> 
> how about defining a nice kerneldoc for this.

Shall do. I've also decided to un-inline the base API, which means that I can 
use all of the existing prototypes in clk.h, which means the kerneldoc is 
shared too.

> > +#define INIT_CLK(name, o) \
> > +	{ .ops = &o, .enable_count = 0, \
> > +		.mutex = __MUTEX_INITIALIZER(name.mutex) }
> 
> how about doing the mutex initinitialisation at registration
> time, will save a pile of non-zero code in the image to mess up
> the compression.

I've just yesterday added the following to my tree, to allow dynamic 
initialisation:

static inline void clk_init(struct clk *clk, const struct clk_ops *ops)
{
	clk->ops = ops;
	clk->enable_count = 0;
	mutex_init(&clk->mutex);
}

So we can do this either way.

> ~> +struct clk_ops {
> 
> > +       int             (*enable)(struct clk *);
> > +       void            (*disable)(struct clk *);
> > +       unsigned long   (*get_rate)(struct clk *);
> > +       void            (*put)(struct clk *);
> > +       long            (*round_rate)(struct clk *, unsigned long);
> > +       int             (*set_rate)(struct clk *, unsigned long);
> > +       int             (*set_parent)(struct clk *, struct clk *);
> > +       struct clk*     (*get_parent)(struct clk *);
> 
> should each clock carry a parent field and the this is returned by
> the get parent call.~~

I've been debating dropping the get_parent and set_parent ops entirely, 
actually; setting a parent seems to be quite specific to hardware (you have to 
know that a particular clock can be a parent of another clock), so it seems 
like something that we shouldn't expose to drivers through this API. For the 
code that knows the hardware, it can probably access the underlying clock 
types directly.

However, I see that something in the samsung code uses clk_get_parent for what 
seems like a sane purpose, so have left them in for now. Or could this be done 
differently?

> > +static inline int clk_enable(struct clk *clk)
> > +{
> > +	int ret = 0;
> > +
> > +	if (!clk->ops->enable)
> > +		return 0;
> > +
> > +	mutex_lock(&clk->mutex);
> > +	if (!clk->enable_count)
> > +		ret = clk->ops->enable(clk);
> > +
> > +	if (!ret)
> > +		clk->enable_count++;
> > +	mutex_unlock(&clk->mutex);
> > +
> > +	return ret;
> > +}
> 
> So we're leaving the enable parent code now to each implementation?
> 
> I think this is a really bad decision, it leaves so much open to bad
> code repetition, as well as something the core should really be doing
> if it had a parent clock field.

I'm tempted to go in either direction - either no [sg]et_parent in the clk 
API, or add a parent to struct clk, but first I'd need to get up to speed on 
the external uses of the clk's parent. Want to catch me on IRC to discuss?

> ~> +static inline void clk_disable(struct clk *clk)
> 
> > +{
> > +	if (!clk->ops->enable)
> > +		return;
> 
> so if we've no enable call we ignore disable too?

Typo; this should be "if (!clk->ops->disable)". Will fix for the next 
revision.

> also, we don't keep an enable count if this fields are in use,
> could people rely on this being correct even if the clock has
> no enable/disable fields.
> 
> Would much rather see the enable_count being kept up-to-date
> no matter what, given it may be watched by other parts of the
> implementation, useful for debug info, and possibly useful if
> later in the start sequence the clk_ops get changed to have this
> field.~

Checking for the ops first allows us to skip the mutex acquire, but I'm happy 
either way.

> > +~	mutex_lock(&clk->mutex);
> > +
> > +	if (!--clk->enable_count)
> > +		clk->ops->disable(clk);
> > +
> > +	mutex_unlock(&clk->mutex);
> > +}
> > +
> > +static inline unsigned long clk_get_rate(struct clk *clk)
> > +{
> > +	if (clk->ops->get_rate)
> > +		return clk->ops->get_rate(clk);
> > +	return 0;
> > +}
> > +
> > +static inline void clk_put(struct clk *clk)
> > +{
> > +	if (clk->ops->put)
> > +		clk->ops->put(clk);
> > +}
> 
> I'm beginging to wonder if we don't just have a set of default ops
> that get set into the clk+ops at registration time if these do
> not have an implementation.

Using default ops would mean a couple of things:

1) we can no longer mark the real ops as const; and
2) we can no longer avoid the hard-to-predict indirect branch

> this means that either any driver that is using a multi-parent clock
> has to deal with the proper enable/disable of the parents (this is
> is going to lead to code repetition, and I bet people will get it
> badly wrong).
> 
> I belive the core of the clock code should deal with this, since
> otherwise we end up with the situation of the same code being
> repeated throughout the kernel.

I see the concern here, but I'll defer this one until we've decided on whether 
or not the parents should be exposed through the API.

Cheers,


Jeremy
