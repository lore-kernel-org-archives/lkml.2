Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760073Ab2CTOBk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2012 10:01:40 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:62018 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758036Ab2CTOBi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2012 10:01:38 -0400
Date: Tue, 20 Mar 2012 22:02:24 +0800
From: Shawn Guo <shawn.guo@linaro.org>
To: Mike Turquette <mturquette@linaro.org>
Cc: Russell King <linux@arm.linux.org.uk>, Paul Walmsley <paul@pwsan.com>,
        Linus Walleij <linus.walleij@stericsson.com>, patches@linaro.org,
        Stephen Boyd <sboyd@codeaurora.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Magnus Damm <magnus.damm@gmail.com>, linux-kernel@vger.kernel.org,
        Saravana Kannan <skannan@codeaurora.org>, linaro-dev@lists.linaro.org,
        Jeremy Kerr <jeremy.kerr@canonical.com>,
        Arnd Bergman <arnd.bergmann@linaro.org>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v7 2/3] clk: introduce the common clock framework
Message-ID: <20120320140220.GE32469@S2101-09.ap.freescale.net>
References: <1331878280-2758-1-git-send-email-mturquette@linaro.org>
 <1331878280-2758-3-git-send-email-mturquette@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1331878280-2758-3-git-send-email-mturquette@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 15, 2012 at 11:11:19PM -0700, Mike Turquette wrote:
...
> +struct clk_ops {
> +	int		(*prepare)(struct clk_hw *hw);
> +	void		(*unprepare)(struct clk_hw *hw);
> +	int		(*enable)(struct clk_hw *hw);
> +	void		(*disable)(struct clk_hw *hw);
> +	int		(*is_enabled)(struct clk_hw *hw);
> +	unsigned long	(*recalc_rate)(struct clk_hw *hw,
> +					unsigned long parent_rate);

I believe I have heard people love the interface with parent_rate
passed in.  I love that too.  But I would like to ask the same thing
on .round_rate and .set_rate as well for the same reason why we have
it for .recalc_rate.

> +	long		(*round_rate)(struct clk_hw *hw, unsigned long,
> +					unsigned long *);

Yes, we already have parent_rate passed in .round_rate with an pointer.
But I think it'd be better to have it passed in no matter flag
CLK_SET_RATE_PARENT is set or not.  Something like:

8<---
@@ -584,7 +584,7 @@ EXPORT_SYMBOL_GPL(clk_get_rate);
  */
 unsigned long __clk_round_rate(struct clk *clk, unsigned long rate)
 {
-       unsigned long unused;
+       unsigned long parent_rate = 0;

        if (!clk)
                return -EINVAL;
@@ -592,10 +592,10 @@ unsigned long __clk_round_rate(struct clk *clk, unsigned long rate)
        if (!clk->ops->round_rate)
                return clk->rate;

-       if (clk->flags & CLK_SET_RATE_PARENT)
-               return clk->ops->round_rate(clk->hw, rate, &unused);
-       else
-               return clk->ops->round_rate(clk->hw, rate, NULL);
+       if (clk->parent)
+               parent_rate = clk->parent->rate;
+
+       return clk->ops->round_rate(clk->hw, rate, &parent_rate);
 }

 /**
@@ -765,9 +765,12 @@ static void clk_calc_subtree(struct clk *clk, unsigned long new_rate)
 static struct clk *clk_calc_new_rates(struct clk *clk, unsigned long rate)
 {
        struct clk *top = clk;
-       unsigned long best_parent_rate = clk->parent->rate;
+       unsigned long best_parent_rate = 0;
        unsigned long new_rate;

+       if (clk->parent)
+               best_parent_rate = clk->parent->rate;
+
        if (!clk->ops->round_rate && !(clk->flags & CLK_SET_RATE_PARENT)) {
                clk->new_rate = clk->rate;
                return NULL;
@@ -780,10 +783,7 @@ static struct clk *clk_calc_new_rates(struct clk *clk, unsigned long rate)
                goto out;
        }

-       if (clk->flags & CLK_SET_RATE_PARENT)
-               new_rate = clk->ops->round_rate(clk->hw, rate, &best_parent_rate);
-       else
-               new_rate = clk->ops->round_rate(clk->hw, rate, NULL);
+       new_rate = clk->ops->round_rate(clk->hw, rate, &best_parent_rate);

        if (best_parent_rate != clk->parent->rate) {
                top = clk_calc_new_rates(clk->parent, best_parent_rate);

--->8

The reason behind the change is that any clk implements .round_rate will
mostly need to get the parent rate, no matter flag CLK_SET_RATE_PARENT
is set or not.  Instead of expecting every .round_rate implementation
to get the parent rate in the way beloe

	 parent_rate = __clk_get_rate(__clk_get_parent(hw->clk));

we can just pass the parent rate into .round_rate.

> +	int		(*set_parent)(struct clk_hw *hw, u8 index);
> +	u8		(*get_parent)(struct clk_hw *hw);
> +	int		(*set_rate)(struct clk_hw *hw, unsigned long);

For the same reason, I would change .set_rate interface like below.

8<---

diff --git a/drivers/clk/clk-divider.c b/drivers/clk/clk-divider.c
index d5ac6a7..6bd8037 100644
--- a/drivers/clk/clk-divider.c
+++ b/drivers/clk/clk-divider.c
@@ -119,7 +119,8 @@ static long clk_divider_round_rate(struct clk_hw *hw, unsigned long rate,
 }
 EXPORT_SYMBOL_GPL(clk_divider_round_rate);

-static int clk_divider_set_rate(struct clk_hw *hw, unsigned long rate)
+static int clk_divider_set_rate(struct clk_hw *hw, unsigned long rate,
+                               unsigned long parent_rate)
 {
        struct clk_divider *divider = to_clk_divider(hw);
        unsigned int div;
diff --git a/drivers/clk/clk.c b/drivers/clk/clk.c
index dbc310a..d74ac4b 100644
--- a/drivers/clk/clk.c
+++ b/drivers/clk/clk.c
@@ -833,17 +833,18 @@ static struct clk *clk_propagate_rate_change(struct clk *clk, unsigned long even
 static void clk_change_rate(struct clk *clk)
 {
        struct clk *child;
-       unsigned long old_rate;
+       unsigned long old_rate, parent_rate = 0;
        struct hlist_node *tmp;

        old_rate = clk->rate;
+       if (clk->parent)
+               parent_rate = clk->parent->rate;

        if (clk->ops->set_rate)
-               clk->ops->set_rate(clk->hw, clk->new_rate);
+               clk->ops->set_rate(clk->hw, clk->new_rate, parent_rate);

        if (clk->ops->recalc_rate)
-               clk->rate = clk->ops->recalc_rate(clk->hw,
-                               clk->parent->rate);
+               clk->rate = clk->ops->recalc_rate(clk->hw, parent_rate);
        else
                clk->rate = clk->parent->rate;

diff --git a/include/linux/clk-provider.h b/include/linux/clk-provider.h
index 5508897..1031f1f 100644
--- a/include/linux/clk-provider.h
+++ b/include/linux/clk-provider.h
@@ -125,7 +125,8 @@ struct clk_ops {
                                        unsigned long *);
        int             (*set_parent)(struct clk_hw *hw, u8 index);
        u8              (*get_parent)(struct clk_hw *hw);
-       int             (*set_rate)(struct clk_hw *hw, unsigned long);
+       int             (*set_rate)(struct clk_hw *hw, unsigned long,
+                                       unsigned long);
        void            (*init)(struct clk_hw *hw);
 };

--->8

Then with parent rate passed into .round_rate and .set_rate like what
we do with .recalc_rate right now, we can save particular clk
implementation from calling __clk_get_parent() and __clk_get_rate to
get parent rate.

For example, the following will the be diff we gain on clk-divider.

8<---

diff --git a/drivers/clk/clk-divider.c b/drivers/clk/clk-divider.c
index 6bd8037..8a28ffb 100644
--- a/drivers/clk/clk-divider.c
+++ b/drivers/clk/clk-divider.c
@@ -68,8 +68,8 @@ static int clk_divider_bestdiv(struct clk_hw *hw, unsigned long rate,
        if (divider->flags & CLK_DIVIDER_ONE_BASED)
                maxdiv--;

-       if (!best_parent_rate) {
-               parent_rate = __clk_get_rate(__clk_get_parent(hw->clk));
+       if (!(divider->flags & CLK_SET_RATE_PARENT)) {
+               parent_rate = *best_parent_rate;
                bestdiv = DIV_ROUND_UP(parent_rate, rate);
                bestdiv = bestdiv == 0 ? 1 : bestdiv;
                bestdiv = bestdiv > maxdiv ? maxdiv : bestdiv;
@@ -109,13 +109,7 @@ static long clk_divider_round_rate(struct clk_hw *hw, unsigned long rate,
        int div;
        div = clk_divider_bestdiv(hw, rate, prate);

-       if (prate)
-               return *prate / div;
-       else {
-               unsigned long r;
-               r = __clk_get_rate(__clk_get_parent(hw->clk));
-               return r / div;
-       }
+       return *prate / div;
 }
 EXPORT_SYMBOL_GPL(clk_divider_round_rate);

@@ -127,7 +121,7 @@ static int clk_divider_set_rate(struct clk_hw *hw, unsigned long rate,
        unsigned long flags = 0;
        u32 val;

-       div = __clk_get_rate(__clk_get_parent(hw->clk)) / rate;
+       div = parent_rate / rate;

        if (!(divider->flags & CLK_DIVIDER_ONE_BASED))
                div--;

--->8

I always get a sense of worry in using functions named in __xxx which
sounds like something somehow internal.  With the requested interface
change above, I can get all __xxx functions out of my clk_ops
implementation.

> +	void		(*init)(struct clk_hw *hw);
> +};

-- 
Regards,
Shawn
