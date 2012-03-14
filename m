Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030263Ab2CNCDo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 22:03:44 -0400
Received: from na3sys009aog104.obsmtp.com ([74.125.149.73]:44041 "EHLO
	na3sys009aog104.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965175Ab2CNCDn convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 22:03:43 -0400
MIME-Version: 1.0
In-Reply-To: <20120305092202.GC3261@b20223-02.ap.freescale.net>
References: <1330763341-3437-1-git-send-email-mturquette@linaro.org>
 <1330763341-3437-4-git-send-email-mturquette@linaro.org> <20120305092202.GC3261@b20223-02.ap.freescale.net>
From: "Turquette, Mike" <mturquette@ti.com>
Date: Tue, 13 Mar 2012 19:03:17 -0700
Message-ID: <CAJOA=zN+pyCZSbJQ+AWyby8y26RfHMjwYU=+8pRDhpCZLofXCQ@mail.gmail.com>
Subject: Re: [PATCH v5 3/4] clk: introduce the common clock framework
To: Richard Zhao <richard.zhao@freescale.com>
Cc: Russell King <linux@arm.linux.org.uk>, Andrew Lunn <andrew@lunn.ch>,
        linaro-dev@lists.linaro.org, Grant Likely <grant.likely@secretlab.ca>,
        Saravana Kannan <skannan@codeaurora.org>,
        Jeremy Kerr <jeremy.kerr@canonical.com>,
        Magnus Damm <magnus.damm@gmail.com>,
        Deepak Saxena <dsaxena@linaro.org>,
        linux-arm-kernel@lists.infradead.org,
        Arnd Bergman <arnd.bergmann@linaro.org>, patches@linaro.org,
        Rob Herring <rob.herring@calxeda.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Richard Zhao <richard.zhao@linaro.org>,
        Shawn Guo <shawn.guo@freescale.com>, Paul Walmsley <paul@pwsan.com>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Stephen Boyd <sboyd@codeaurora.org>, linux-kernel@vger.kernel.org,
        Amit Kucheria <amit.kucheria@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 5, 2012 at 1:22 AM, Richard Zhao <richard.zhao@freescale.com> wrote:
> Hi Mike,

Hi Richard,

Sorry for missing this earlier.  I've taken in most of your
suggestions and commented on some of them below.  Any of your feedback
that I cut from this mail was taken in as a fix in v7 :-)

> On Sat, Mar 03, 2012 at 12:29:00AM -0800, Mike Turquette wrote:
>> +/**
>> + * __clk_round_rate - round the given rate for a clk
>> + * @clk: round the rate of this clock
>> + *
>> + * Caller must hold prepare_lock.  Useful for clk_ops such as .set_rate
>> + */
>> +unsigned long __clk_round_rate(struct clk *clk, unsigned long rate)
>> +{
>> +     if (!clk && !clk->ops->round_rate)
> be               || ?

This is fixed in v7 by a refactor of how clk_round_rate and
__clk_round_rate work.

>> +long clk_round_rate(struct clk *clk, unsigned long rate)
>> +{
>> +     unsigned long ret = rate;
>> +
>> +     mutex_lock(&prepare_lock);
>> +     if (clk && clk->ops->round_rate)
>> +             ret = __clk_round_rate(clk, rate);
>> +     mutex_unlock(&prepare_lock);
>> +
>> +     return ret;
> If clk is NULL, clk_round_rate and __clk_round_rate return different
> values. Do you mean it?

This also is fixed in v7 by a refactor of how clk_round_rate and
__clk_round_rate work.

>> +static int __clk_speculate_rates(struct clk *clk, unsigned long parent_rate)
>> +{
>> +     struct hlist_node *tmp;
>> +     struct clk *child;
>> +     unsigned long new_rate;
>> +     int ret = NOTIFY_DONE;
>> +
>> +     if (!clk->ops->recalc_rate)
>> +             goto out;
> When recalc_rate is NULL, it's possible for it and its children to have
> notifier too.

Fixed by assuming parent rate without .recalc_rate callback.  This
mirrors __clk_recalc_rates.

>> +
>> +     new_rate = clk->ops->recalc_rate(clk->hw, parent_rate);
>> +
>> +     /* abort the rate change if a driver returns NOTIFY_BAD */
>> +     if (clk->notifier_count)
>> +             ret = __clk_notify(clk, PRE_RATE_CHANGE, clk->rate, new_rate);
>> +
>> +     if (ret == NOTIFY_BAD)
>> +             goto out;
>> +
>> +     hlist_for_each_entry(child, tmp, &clk->children, child_node) {
>> +             ret = __clk_speculate_rates(child, new_rate);
>> +             if (ret == NOTIFY_BAD)
>> +                     break;
>> +     }
> Tell the notifier that already receive PRE_RATE_CHANGE abort?

All of this stuff might change due to existing thread with Sascha on
how clk_set_rate should propagate parent rate changes.  But for
completeness sake, a single ABORT goes out at the end of clk_set_rate
in this implementation, so there isn't a problem here.

>> +static struct clk *__clk_set_rate(struct clk *clk, unsigned long rate)
>> +{
>> +     struct clk *fail_clk = NULL;
>> +     int ret = NOTIFY_DONE;
>> +     unsigned long old_rate = clk->rate;
>> +     unsigned long new_rate;
>> +     unsigned long parent_old_rate;
>> +     unsigned long parent_new_rate = 0;
>> +     struct clk *child;
>> +     struct hlist_node *tmp;
>> +
>> +     /* bail early if we can't change rate while clk is enabled */
>> +     if ((clk->flags & CLK_SET_RATE_GATE) && clk->enable_count)
>> +             return clk;
>> +
>> +     /* find the new rate and see if parent rate should change too */
>> +     WARN_ON(!clk->ops->round_rate);
>> +
>> +     new_rate = clk->ops->round_rate(clk->hw, rate, &parent_new_rate);
>> +
>> +     /* NOTE: pre-rate change notifications will stack */
>> +     if (clk->notifier_count)
>> +             ret = __clk_notify(clk, PRE_RATE_CHANGE, clk->rate, new_rate);
>
> if ((clk->flags & CLK_SET_RATE_PARENT) && parent_new_rate)
>        dowstream notify from parent clk?

The pre-rate change notifiers stack; also no problem here.

>> +
>> +     if (ret == NOTIFY_BAD)
>> +             return clk;
>> +
>> +     /* speculate rate changes down the tree */
>> +     hlist_for_each_entry(child, tmp, &clk->children, child_node) {
>> +             ret = __clk_speculate_rates(child, new_rate);
>> +             if (ret == NOTIFY_BAD)
> roll back?

Similar to the above.  The post-rate change notifiers are sent out
once from the top of the subtree in __clk_set_rate; no problem here.

>> +                     return clk;
>> +     }
>> +
>> +     /* change the rate of this clk */
>> +     if (clk->ops->set_rate)
> If set_rate is NULL, it can fail at the beginning of this function.

We don't want to fail.  In the conditional block below we allow for
propagating the rate request up to the parent.  This would allow for a
gate clock at the bottom of the tree to have clk_set_rate called
against it, even though its hardware doesn't support it, and it will
propagate the request up the tree until it finds a clock that can
adjust the rate.  This feature is very desirable for driver folks who
do not want to know about the tree topology in their driver beyond the
clocks needed by their device.

>> +             ret = clk->ops->set_rate(clk->hw, new_rate);
>> +
>> +     if (ret == NOTIFY_BAD)
> you mean to check set_rate fail? Notify ABORT_RATE_CHANGE?

As stated, this happens once in clk_set_rate.

>> +             return clk;
>> +
>> +     /*
>> +      * change the rate of the parent clk if necessary
>> +      *
>> +      * hitting the nested 'if' path implies we have hit a .set_rate
>> +      * failure somewhere upstream while propagating __clk_set_rate
>> +      * up the clk tree.  roll back the clk rates one by one and
>> +      * return the pointer to the clk that failed.  clk_set_rate will
>> +      * use the pointer to propagate a rate-change abort notifier
>> +      * from the "highest" point.
>> +      */
>> +     if ((clk->flags & CLK_SET_RATE_PARENT) && parent_new_rate) {
>> +             parent_old_rate = clk->parent->rate;
>> +             fail_clk = __clk_set_rate(clk->parent, parent_new_rate);
>> +
>> +             /* roll back changes if parent rate change failed */
>> +             if (fail_clk) {
>> +                     pr_warn("%s: failed to set parent %s rate to %lu\n",
>> +                                     __func__, fail_clk->name,
>> +                                     parent_new_rate);
>> +
>> +                     /*
>> +                      * Send PRE_RATE_CHANGE notifiers down the tree
>> +                      * again, since we're rolling back the rate
>> +                      * changes due to the abort.
>> +                      *
>> +                      * Ignore any NOTIFY_BAD's since this *is* the
>> +                      * exception handler.
>> +                      *
>> +                      * NOTE: pre-rate change notifications will stack
>> +                      */
>> +                     __clk_speculate_rates(clk, clk->parent->rate);
> IMHO, driver can not be happy to receive multiple PRE_RATE_CHANGE.
> Notify ABORT_RATE_CHANGE?

This is getting looked at again in the v6 thread :-)

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
>> +
>> +     fail_clk = __clk_set_rate(clk, rate);
>> +     if (fail_clk) {
>> +             pr_warn("%s: failed to set %s rate\n", __func__,
>> +                             fail_clk->name);
>> +             __clk_recalc_rates(clk, ABORT_RATE_CHANGE);
> It might need to begin from parent clk. move it to __clk_set_rate?

That should be __clk_recalc_rates(fail_clk, ABORT_RATE_CHANGE), which
is the parent clk.  Thanks for catching that.

>> +void __clk_init(struct device *dev, struct clk *clk)
>> +{
...
>> +     /*
>> +      * walk the list of orphan clocks and reparent any that are children of
>> +      * this clock
>> +      */
>> +     hlist_for_each_entry(orphan, tmp, &clk_orphan_list, child_node)
>> +             __clk_reparent(orphan, __clk_init_parent(orphan));
> check whether orphan->parent is the value of  __clk_init_parent(orphan)
> before reparent?

Good point.  I cleaned this up a bit to only check orphan's parents
against the clock being registered.  I can't think of any reason why
that wouldn't be adequate.

>> +int clk_notifier_register(struct clk *clk, struct notifier_block *nb)
>> +{
>> +     struct clk_notifier *cn;
>> +     int ret = -ENOMEM;
>> +
>> +     if (!clk || !nb)
>> +             return -EINVAL;
>> +
>> +     mutex_lock(&prepare_lock);
>> +
>> +     /* search the list of notifiers for this clk */
>> +     list_for_each_entry(cn, &clk_notifier_list, node)
>> +             if (cn->clk == clk)
>> +                     break;
>> +
>> +     /* if clk wasn't in the notifier list, allocate new clk_notifier */
>> +     if (cn->clk != clk) {
>> +             cn = kzalloc(sizeof(struct clk_notifier), GFP_KERNEL);
>> +             if (!cn)
>> +                     goto out;
>> +
>> +             cn->clk = clk;
>> +             srcu_init_notifier_head(&cn->notifier_head);
>> +
>> +             list_add(&cn->node, &clk_notifier_list);
>> +     }
> why not embedd notifier_head to struct clk?

It is assumed that the vast majority of clocks will not have drivers
subscribed to their notifiers.  This saves space over having the
notifier_head in every single struct clk.

Thanks for the great review.

Mike

> Thanks
> Richard
>
