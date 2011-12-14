Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757936Ab1LNTHg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Dec 2011 14:07:36 -0500
Received: from na3sys009aog117.obsmtp.com ([74.125.149.242]:59592 "EHLO
	na3sys009aog117.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751967Ab1LNTHe convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Dec 2011 14:07:34 -0500
MIME-Version: 1.0
In-Reply-To: <4EE82B76.2000204@gmail.com>
References: <1323834838-2206-1-git-send-email-mturquette@linaro.org>
 <1323834838-2206-4-git-send-email-mturquette@linaro.org> <4EE82B76.2000204@gmail.com>
From: "Turquette, Mike" <mturquette@ti.com>
Date: Wed, 14 Dec 2011 11:07:12 -0800
Message-ID: <CAJOA=zPdjqpAzqWEJyKX9qKXhtDpuUz5GhBRz2sNyZV77di5QQ@mail.gmail.com>
Subject: Re: [PATCH v4 3/6] clk: introduce the common clock framework
To: Ryan Mallon <rmallon@gmail.com>
Cc: linux@arm.linux.org.uk, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        jeremy.kerr@canonical.com, paul@pwsan.com,
        broonie@opensource.wolfsonmicro.com, tglx@linutronix.de,
        linus.walleij@stericsson.com, amit.kucheria@linaro.org,
        dsaxena@linaro.org, patches@linaro.org, linaro-dev@lists.linaro.org,
        grant.likely@secretlab.ca, sboyd@quicinc.com, shawn.guo@freescale.com,
        skannan@quicinc.com, magnus.damm@gmail.com, arnd.bergmann@linaro.org,
        eric.miao@linaro.org, richard.zhao@linaro.org, andrew@lunn.ch
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 13, 2011 at 8:52 PM, Ryan Mallon <rmallon@gmail.com> wrote:
> On 14/12/11 14:53, Mike Turquette wrote:
>> +void __clk_unprepare(struct clk *clk)
>> +{
>> +     if (!clk)
>> +             return;
>> +
>> +     if (WARN_ON(clk->prepare_count == 0))
>> +             return;
>> +
>> +     if (--clk->prepare_count > 0)
>> +             return;
>> +
>> +     WARN_ON(clk->enable_count > 0);
>> +
>> +     if (clk->ops->unprepare)
>> +             clk->ops->unprepare(clk);
>> +
>> +     __clk_unprepare(clk->parent);
>> +}
>
>
> I think you can rewrite this to get rid of the recursion as below:
>
>        while (clk) {
>                if (WARN_ON(clk->prepare_count == 0))
>                        return;
>
>                if (--clk->prepare_count > 0)
>                        return;
>
>                WARN_ON(clk->enable_count > 0)
>
>                if (clk->ops->unprepare)
>                        clk->ops->unprepare(clk);
>
>                clk = clk->parent;
>        }

Looks good.  I'll roll into next set.

> Also, should this function be static?

No, since platform clk code will occasionally be forced to call
clk_(un)prepare while the prepare_lock mutex is held.  For a valid
example see:
http://git.linaro.org/gitweb?p=people/mturquette/linux.git;a=blob;f=arch/arm/mach-omap2/dpll3xxx.c;h=b2412574b63829944593c1a7a6eda5fa4350686f;hb=738bde65918ae1ac743b1498801da0b860e2ee32#l461

>> +void clk_unprepare(struct clk *clk)
>> +{
>> +     mutex_lock(&prepare_lock);
>> +     __clk_unprepare(clk);
>> +     mutex_unlock(&prepare_lock);
>> +}
>> +EXPORT_SYMBOL_GPL(clk_unprepare);
>> +
>> +int __clk_prepare(struct clk *clk)
>> +{
>> +     int ret = 0;
>> +
>> +     if (!clk)
>> +             return 0;
>> +
>> +     if (clk->prepare_count == 0) {
>> +             ret = __clk_prepare(clk->parent);
>> +             if (ret)
>> +                     return ret;
>> +
>> +             if (clk->ops->prepare) {
>> +                     ret = clk->ops->prepare(clk);
>> +                     if (ret) {
>> +                             __clk_unprepare(clk->parent);
>> +                             return ret;
>> +                     }
>> +             }
>> +     }
>> +
>> +     clk->prepare_count++;
>> +
>> +     return 0;
>> +}
>
>
> This is unfortunately a bit tricky to remove the recursion from without
> keeping a local stack of the clocks leading up to first unprepared
> client :-/.
>
> Again, should this be static? What outside this file needs to
> prepare/unprepare clocks without the lock held?

Same as above.

>> +int clk_prepare(struct clk *clk)
>> +{
>> +     int ret;
>> +
>> +     mutex_lock(&prepare_lock);
>> +     ret = __clk_prepare(clk);
>> +     mutex_unlock(&prepare_lock);
>> +
>> +     return ret;
>> +}
>> +EXPORT_SYMBOL_GPL(clk_prepare);
>> +
>> +void __clk_disable(struct clk *clk)
>> +{
>> +     if (!clk)
>> +             return;
>> +
>> +     if (WARN_ON(clk->enable_count == 0))
>> +             return;
>> +
>> +     if (--clk->enable_count > 0)
>> +             return;
>> +
>> +     if (clk->ops->disable)
>> +             clk->ops->disable(clk);
>> +
>> +     if (clk->parent)
>> +             __clk_disable(clk->parent);
>
>
> Easy to get rid of the recursion here. Also should be static?

Yes the enable/disable should be static.  I originally made them
non-static when I converted the prepare/unprepare set, but of course
it's possible to call these with the prepare_lock mutex held so I'll
fix this up in the next set.

>> +long clk_round_rate(struct clk *clk, unsigned long rate)
>> +{
>> +     if (clk && clk->ops->round_rate)
>> +             return clk->ops->round_rate(clk, rate, NULL);
>> +
>> +     return rate;
>> +}
>> +EXPORT_SYMBOL_GPL(clk_round_rate);
>
>
> If the clock doesn't provide a round rate function then shouldn't we
> return an error to the caller? Telling the caller that the rate is
> perfect might lead to odd driver bugs?

Yes this code should so something better.  I've been focused mostly on
the "write" aspects of the clk API (set_rate, set_parent,
enable/disable and prepare/unprepare) and less on the "read" aspects
of the clk API (get_rate, get_parent, round_rate, etc).  I'll give
this a closer look for the next set.

>> +/**
>> + * DOC: Using the CLK_PARENT_SET_RATE flag
>> + *
>> + * __clk_set_rate changes the child's rate before the parent's to more
>> + * easily handle failure conditions.
>> + *
>> + * This means clk might run out of spec for a short time if its rate is
>> + * increased before the parent's rate is updated.
>> + *
>> + * To prevent this consider setting the CLK_GATE_SET_RATE flag on any
>> + * clk where you also set the CLK_PARENT_SET_RATE flag
>> + */
>
>
> Is this standard kerneldoc format?

It is:
http://git.linaro.org/gitweb?p=people/mturquette/linux.git;a=blob;f=Documentation/kernel-doc-nano-HOWTO.txt;h=3d8a97747f7731c801ca7d3a1483858feeb76b6c;hb=refs/heads/v3.2-rc5-clkv4-omap#l298

>> +struct clk *__clk_set_rate(struct clk *clk, unsigned long rate)
>
>
> static?

I'll make it static.  I don't think any platform code needs to call
this (at least I hope not).

>> +{
>> +     struct clk *fail_clk = NULL;
>> +     int ret = 0;
>> +     unsigned long old_rate = clk->rate;
>> +     unsigned long new_rate;
>> +     unsigned long parent_old_rate;
>> +     unsigned long parent_new_rate = 0;
>> +     struct clk *child;
>> +     struct hlist_node *tmp;
>> +
>> +     /* bail early if we can't change rate while clk is enabled */
>> +     if ((clk->flags & CLK_GATE_SET_RATE) && clk->enable_count)
>> +             return clk;
>> +
>> +     /* find the new rate and see if parent rate should change too */
>> +     WARN_ON(!clk->ops->round_rate);
>> +
>> +     new_rate = clk->ops->round_rate(clk, rate, &parent_new_rate);
>> +
>> +     /* FIXME propagate pre-rate change notification here */
>> +     /* XXX note that pre-rate change notifications will stack */
>> +
>> +     /* change the rate of this clk */
>> +     if (clk->ops->set_rate)
>> +             ret = clk->ops->set_rate(clk, new_rate);
>> +
>> +     if (ret)
>> +             return clk;
>
>
> Is there are reason to write it this way and not:
>
>        if (clk->ops->set_rate) {
>                ret = clk->ops->set_rate(clk, new_rate);
>                if (ret)
>                        return clk;
>        }
>
> If !clk->ops->set_rate then ret is always zero right? Note, making this
> change means that you don't need to init ret to zero at the top of this
> function.

Looks good.  Will fix in the next set.

>> +int clk_set_rate(struct clk *clk, unsigned long rate)
>> +{
>> +     struct clk *fail_clk;
>> +     int ret = 0;
>> +
>> +     /* prevent racing with updates to the clock topology */
>> +     mutex_lock(&prepare_lock);
>> +
>> +     /* bail early if nothing to do */
>> +     if (rate == clk->rate)
>> +             goto out;
>
>> +
>> +     fail_clk = __clk_set_rate(clk, rate);
>> +     if (fail_clk) {
>> +             pr_warn("%s: failed to set %s rate\n", __func__,
>> +                             fail_clk->name);
>> +             /* FIXME propagate rate change abort notification here */
>> +             ret = -EIO;
>
>
> Why does __clk_set_rate return a struct clk if you don't do anything
> with it? You can move the pr_warn into __clk_set_rate and have it return
> a proper errno value instead so that you get a reason why it failed to
> set the rate.

The next patch in the series uses fail_clk to propagate
ABORT_RATE_CHANGE notifications to any drivers that have subscribed to
them.  The FIXME comment hints at that but doesn't make it clear.  The
idea is that the PRE_RATE_CHANGE notifiers will be noisy and stack up
(potentially), but I only want to propagate the POST_RATE_CHANGE and
ABORT_RATE_CHANGE notifications once for any single call to
clk_set_rate, which is why __clk_set_rate returns a struct clk *.

>> +void __clk_reparent(struct clk *clk, struct clk *new_parent)
>> +{
>
>> +     if (!clk || !new_parent)
>> +             return;
>
>
> clk_reparent already checks for !clk, shouldn't it also check for
> !new_parent and remove the check from here?

I need to take another look at this.  new_parent can be NULL if we
think it is plausible for a parented clk to suddenly become a root clk
(where clk->parent == NULL).

Thanks for reviewing,
Mike
