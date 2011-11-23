Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756048Ab1KWVbQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Nov 2011 16:31:16 -0500
Received: from na3sys009aog114.obsmtp.com ([74.125.149.211]:38553 "EHLO
	na3sys009aog114.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755882Ab1KWVbP convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Nov 2011 16:31:15 -0500
MIME-Version: 1.0
In-Reply-To: <4ECC6487.1060300@codeaurora.org>
References: <1321926047-14211-1-git-send-email-mturquette@linaro.org>
 <1321926047-14211-4-git-send-email-mturquette@linaro.org> <4ECC6487.1060300@codeaurora.org>
From: "Turquette, Mike" <mturquette@ti.com>
Date: Wed, 23 Nov 2011 13:30:53 -0800
Message-ID: <CAJOA=zN0_cY8gmMN3YE=M9ktxokE3kBvU+5bzGU9b4JO_NO4cw@mail.gmail.com>
Subject: Re: [PATCH v3 3/5] clk: introduce the common clock framework
To: Saravana Kannan <skannan@codeaurora.org>
Cc: linux@arm.linux.org.uk, linaro-dev@lists.linaro.org, eric.miao@linaro.org,
        grant.likely@secretlab.ca, paul@pwsan.com, jeremy.kerr@canonical.com,
        Stephen Boyd <sboyd@codeaurora.org>, magnus.damm@gmail.com,
        dsaxena@linaro.org, linux-arm-kernel@lists.infradead.org,
        arnd.bergmann@linaro.org, patches@linaro.org, tglx@linutronix.de,
        linux-omap@vger.kernel.org, richard.zhao@linaro.org,
        shawn.guo@freescale.com, linus.walleij@stericsson.com,
        broonie@opensource.wolfsonmicro.com, linux-kernel@vger.kernel.org,
        amit.kucheria@linaro.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 22, 2011 at 7:12 PM, Saravana Kannan <skannan@codeaurora.org> wrote:
> On 11/21/2011 05:40 PM, Mike Turquette wrote:
>> +void __clk_unprepare(struct clk *clk)
>> +{
>> +       if (!clk)
>> +               return;
>> +
>> +       if (WARN_ON(clk->prepare_count == 0))
>> +               return;
>> +
>> +       if (--clk->prepare_count>  0)
>
> Space before ">"?

Will fix all spacing errors in v4.

>> +int __clk_enable(struct clk *clk)
>> +{
>> +       int ret = 0;
>> +
>> +       if (!clk)
>> +               return 0;
>> +
>> +       if (WARN_ON(clk->prepare_count == 0))
>> +               return -ESHUTDOWN;
>
> EPERM? EBADFD?

This came from discussion out of Jeremy's original patches and I'm
inclined to keep it there.

>> +unsigned long clk_get_rate(struct clk *clk)
>> +{
>> +       if (!clk)
>> +               return 0;
>> +
>> +       return clk->rate;
>
> I think you need to grab the prepare_mutex here too. Otherwise another call
> to clk_set_rate() could be changing clk->rate while it's being read here. It
> shouldn't be a problem in ARM where I think 32bit reads are atomic. But I'm
> not sure you can say the same for all archs.

Hmm, need to decide if code calling this will likely hold the mutex
itself.  The comment can be updated to say "caller must hold
prepare_mutex", but that may be undo burden for a driver that just
wants to know a clk rate.  Thoughts?

>> +/**
>> + * clk_recalc_rates
>> + * @clk: first clk in the subtree
>> + *
>> + * Walks the subtree of clks starting with clk and recalculates rates as
>> it
>> + * goes.  Note that if a clk does not implement the recalc_rate operation
>> then
>> + * propagation of that subtree stops and all of that clks children will
>> not
>> + * have their rates updated.  Caller must hold prepare_lock.
>
> May be call this functions __clk_recalc_rates() to match the naming
> convention of the other fns that don't grab locks?

Other functions have __private_func syntax for one of two reasons:

1) the outer function holds a lock, and sometimes we want to access
the inner function from some other code path that avoids nested
locking (e.g. clk_enable)

2) the outer function sets up some staging data for a recursive
mechanism to use (e.g. clk_set_rate)

clk_recalc_rates doesn't hold a lock nor does it have staging data, so
it would just end up looking like:

__clk_recalc_rates(struct clk *clk)
{
do the real work
}

clk_recalc_rates(struct clk *clk)
{
__clk_recalc_rates(clk)
}

There is no obvious gain for splitting the function.

>
>> + */
>> +static void clk_recalc_rates(struct clk *clk)
>> +{
>> +       unsigned long old_rate;
>> +       struct hlist_node *tmp;
>> +       struct clk *child;
>> +
>> +       old_rate = clk->rate;
>> +
>> +       if (clk->ops->recalc_rate)
>> +               clk->rate = clk->ops->recalc_rate(clk);
>
> Any reason you can't just do "else return" instead of the check below? That
> would be more straight-forward and also remove the need for old_rate.

old_rate doesn't protect against not having a .recalc_rate pointer.
It is an optimization for when a clks rate hasn't changed and there is
no reason to traverse the tree.  In the case where there is no
.recalc_rate pointer then it serves the dual-purpose of bailing out
early.

>> +struct clk *__clk_set_rate(struct clk *clk, unsigned long rate)
>> +{
>> +       struct clk *fail_clk = NULL;
>> +       int ret;
>> +       unsigned long old_rate = clk->rate;
>> +       unsigned long new_rate;
>> +       unsigned long parent_old_rate;
>> +       unsigned long parent_new_rate = 0;
>> +       struct clk *child;
>> +       struct hlist_node *tmp;
>> +
>> +       /* bail early if we can't change rate while clk is enabled */
>> +       if ((clk->flags&  CLK_GATE_SET_RATE)&&  clk->enable_count)
>> +               return clk;
>
> Spacing fix near & and &&.

Will fix in V4.

>
>> +
>> +       /* find the new rate and see if parent rate should change too */
>> +       WARN_ON(!clk->ops->round_rate);
>
> It looks like you don't consider absence of round_rate as an error (going by
> clk_round_rate()), so why warn on this? See below for additional comments.
>
>> +       new_rate = clk->ops->round_rate(clk, rate,&parent_new_rate);

The above will cause a NULL ptr deref if you don't have a .round_rate
defined, so I'd say having .round_rate isn't very optional for
clk_set_rate support :-)

The question is, should it be?  For very simple clocking schemes where
the PLL locking rates will never vary from board to board or the
oscillators won't get changed across products... I guess it's not
necessary.  I can conditionally check for it before calling unless
others feel that .round_rate should be mandatory for .set_rate.  Need
feedback on that.

>
> Should we split the "figuring out the parent rate" and "round rate"?

No.  These two are inherently linked.  If you set them independently
you will have some crazy code trying to make sure that the clk's rate
and the parent's rate that are being programmed make sense.  Best to
control is centrally.

> If any clock driver doesn't care for propagation (too simple clock tree or
> very versatile clock tree), and doesn't want to implement ops->round_rate,
> this code is still forcing them to implement ops->round_rate(). But then
> clk_round_rate() thinks it's okay if that ops->round_rate() is not
> implemented. This is a bit inconsistent.
>
> May be we should just add ops->propagate_parent() that is optional and takes

I don't like this at all.  ops->propagate_parent() would just be
another call to __clk_set_rate, so why obscure it?  I encourage you to
convert your platform over to this code and try it on for size first;
I think it will do the job for you.

> in the result of ops->round_rate()? If a clock needs propagation, it will
> implement and return the new parent rate.
>
>> +int clk_set_rate(struct clk *clk, unsigned long rate)
>> +{
>> +       struct clk *fail_clk;
>> +       int ret = 0;
>> +
>> +       if (!clk->ops->set_rate)
>> +               return -ENOSYS;
>> +
>> +       /* bail early if nothing to do */
>> +       if (rate == clk->rate)
>> +               return rate;
>
> This check needs to be after the lock is taken.

Will fix in v4.

>
>> +
>> +       /* prevent racing with updates to the clock topology */
>> +       mutex_lock(&prepare_lock);
>> +       fail_clk = __clk_set_rate(clk, rate);
>> +       if (fail_clk) {
>> +               pr_warn("%s: failed to set %s rate to %lu\n",
>> +                               __func__, fail_clk->name, rate);
>
> Going by the current implementation, the "fail_clk" is not necessarily the
> same as "clk". But the "rate" you are printing is always the rate for "clk".

Since this isn't python and we're not returning multiple values from a
function call I'll just change the error to:

pr_warn("%s: failed to set %s rate\n", __func__, fail_clk->name);

>
> if (fail_clk == clk)
>  print blah
> else
>  print blah bloo
>
> ?
>
>> +struct clk *clk_get_parent(struct clk *clk)
>> +{
>> +       if (!clk)
>> +               return NULL;
>> +
>> +       return clk->parent;
>
> Same comment as get_rate(). I think this needs locking too to avoid maligned
> reads.

I'm not so sure.  clk_get_rate is more difficult because I can imagine
driver code calling that for any number of reasons, so maybe the
locking should be in that function.

However clk_get_parent is a different beast. If you want the parent
pointer then odds are that you are already holding the prepare_mutex.
Again I feel that the comment should just be updated to say "caller
must hold prepare_mutex".  Objections to this approach?

>
>> +}
>> +EXPORT_SYMBOL_GPL(clk_get_parent);
>> +
>> +void __clk_reparent(struct clk *clk, struct clk *new_parent)
>> +{
>> +       hlist_del(&clk->child_node);
>> +       hlist_add_head(&clk->child_node,&new_parent->children);
>
> Check new_parent != NULL before trying to add the clock to its children
> list?

Will add to v4.

>> +int clk_set_parent(struct clk *clk, struct clk *parent)
>> +{
>> +       int ret = 0;
>> +
>> +       if (!clk || !clk->ops)
>
> I would like NULL clocks to be treated as real/proper clocks. So, can we
> split this into two "if"s please? And return 0 for (!clk)?

Eww that's gross. How about include/linux/clk.h has an "extern struct
clk dummy_clk" that has no ops and no parent and you can use to stub
out support for clks that you don't really manage.  I'd prefer that
over treating NULL clks as legit.

>
>> +               return -EINVAL;
>> +
>> +       if (!clk->ops->set_parent)
>> +               return -ENOSYS;
>> +
>> +       if (clk->parent == parent)
>> +               return 0;
>
> This check should be done after taking the lock.

Will fix in V4.

Thanks for the review,
Mike
