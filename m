Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932681Ab1LEXk1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 18:40:27 -0500
Received: from na3sys009aob106.obsmtp.com ([74.125.149.76]:44748 "EHLO
	na3sys009aog106.obsmtp.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932481Ab1LEXk0 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 18:40:26 -0500
MIME-Version: 1.0
In-Reply-To: <1321926047-14211-4-git-send-email-mturquette@linaro.org>
References: <1321926047-14211-1-git-send-email-mturquette@linaro.org> <1321926047-14211-4-git-send-email-mturquette@linaro.org>
From: "Turquette, Mike" <mturquette@ti.com>
Date: Mon, 5 Dec 2011 15:40:03 -0800
Message-ID: <CAJOA=zPv6wUEEmPafY4AEtHkuSAv9CpSwa-YLfq9gjFbHGyqoA@mail.gmail.com>
Subject: Re: [PATCH v3 3/5] clk: introduce the common clock framework
To: linux@arm.linux.org.uk
Cc: linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, jeremy.kerr@canonical.com,
        broonie@opensource.wolfsonmicro.com, tglx@linutronix.de,
        linus.walleij@stericsson.com, amit.kucheria@linaro.org,
        dsaxena@linaro.org, patches@linaro.org, linaro-dev@lists.linaro.org,
        paul@pwsan.com, grant.likely@secretlab.ca, sboyd@quicinc.com,
        shawn.guo@freescale.com, skannan@quicinc.com, magnus.damm@gmail.com,
        arnd.bergmann@linaro.org, eric.miao@linaro.org,
        richard.zhao@linaro.org, mturquette@ti.com,
        Mike Turquette <mturquette@linaro.org>,
        Colin Cross <ccross@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 21, 2011 at 5:40 PM, Mike Turquette <mturquette@ti.com> wrote:
> +/**
> + * clk_get_parent - return the parent of a clk
> + * @clk: the clk whose parent gets returned
> + *
> + * Simply returns clk->parent.  It is up to the caller to hold the
> + * prepare_lock, if desired.  Returns NULL if clk is NULL.
> + */
> +struct clk *clk_get_parent(struct clk *clk)
> +{
> +       if (!clk)
> +               return NULL;
> +
> +       return clk->parent;
> +}
> +EXPORT_SYMBOL_GPL(clk_get_parent);

While auditing the uses/expectations of the current clk API users, I
see that clk_get_parent is rarely used; it is in fact only called in
11 files throughout the kernel.

I decided to have a little audit and here is what I found:

arch/arm/mach-shmobile/board-ap4evb.c: fsi_ak4642_set_rate
Used within clk_set_rate.  Can dereference clk->parent directly and
ideally should propagate up the clk tree using the new recursive
clk_set_rate.

arch/arm/mach-tegra/usb_phy.c: tegra_usb_phy_open
Used within a clk_get_rate.  pll_u should ideally have it's own
clk->rate populated, reducing the need for tegra_usb_phy_open to know
details of the clk tree.  The logic to pull pll_u's rate from it's
parent belongs to pll_u's .recalc_rate callback.

arch/arm/plat-s5p/clock.c: s5p_spdif_set_rate
Another clk_get_parent call from within a .set_rate callback.  Again:
use clk->parent directly and better yet, propagate the rate change up
via the recursive clk_set_rate.

arch/arm/plat-s5p/clock.c: s5p_spdif_get_rate
Another clk_get_parent call from within a .recalc_rate callback.
Again, clk->rate should be populated with parent's rate correctly,
otherwise dereference clk->parent directly without use of
clk_get_parent.

arch/arm/plat-s5p/s5p-time.c: s5p_clockevent_init
This problem would be solved by propagating rate_change requests up
two-levels of parents via the new recursive clk_set_rate.  There is
also a clk_set_parent call in here, which has nothing to do with the
clk_get_parent call, but it makes me wonder if we should revisit the
issue of switching parents as part of clk_set_rate:
clk_set_rate(tin_event, pclk->rate / 2);

arch/arm/plat-samsung/pwm.c: pwm_is_tdiv
Used in only two places: as part of pwm_calc_tin which could be
replaced wholesale by a better .round_rate implementation and for a
debug print (who cares).

arch/arm/plat-samsung/pwm.c: pwm_calc_tin
Just a .round_rate implementation.  Can dereference clk->parent directly.

arch/arm/plat-samsung/time.c: s3c2410_timer_setup
Same as s5p_clockevent_init above.

drivers/sh/clk/core.c: clk_round_parent
An elaborate .round_rate that should have resulted from recursive
propagation up to clk->parent.

drivers/video/omap2/dss/dss.c:
Every call to clk_get_parent in here is wrapped in clk_get_rate.  The
functions that use this are effectively .set_rate, .get_rate and
.recalc_rate doppelgangers.  Also a debug print calls clk_get_parent
but who cares.

drivers/video/sh_mobile_hdmi.c:
Used in a .set_rate and .round_rate implementation.  No reason not to
deref clk->parent directly.

The above explanations take a little liberty listing certain functions
as .round_rate, .set_rate and .recalc_rate callbacks, but that is
because a lot of the code mentioned could be neatly wrapped up that
way.

Do we really need clk_get_parent?  The primary problem with it is
ambiguity in the API: should the caller hold a lock?  Is the rate
guaranteed not the change after being called?  A top-level clk API
function that can be called within other top-level clk API functions
is inconsitent: most of the time this would incur nested locking.
Also having a top-level API expose the tree structure encourages
platform and driver developers to put clk tree details into their code
as opposed to having clever .round_rate and .set_rate callbacks hide
these details from them with the new recursive clk_set_rate.

Thoughts?

Thanks,
Mike
