Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753859Ab2H0RFc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2012 13:05:32 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:56718 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753749Ab2H0RF3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2012 13:05:29 -0400
MIME-Version: 1.0
In-Reply-To: <1345074214-17531-2-git-send-email-mturquette@linaro.org>
References: <1345074214-17531-1-git-send-email-mturquette@linaro.org>
	<1345074214-17531-2-git-send-email-mturquette@linaro.org>
Date: Mon, 27 Aug 2012 22:35:29 +0530
Message-ID: <CADTbHxob_pkYN_73AD4YL_Ki5i40iLTJuN0rPuFzYcyyhfoMAQ@mail.gmail.com>
Subject: Re: [PATCH v2 1/4] [RFC] clk: new locking scheme for reentrancy
From: Pankaj Jangra <jangra.pankaj9@gmail.com>
To: Mike Turquette <mturquette@linaro.org>
Cc: linux-kernel@vger.kernel.org, paul@pwsan.com, pgaikwad@nvidia.com,
        viresh.kumar@linaro.org, linus.walleij@linaro.org, rnayak@ti.com,
        rob.herring@calxeda.com, ccross@android.com, myungjoo.ham@samsung.com,
        broonie@opensource.wolfsonmicro.com, rajagopal.venkat@linaro.org,
        shawn.guo@linaro.org, pdeschrijver@nvidia.com,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mike,

On Thu, Aug 16, 2012 at 5:13 AM, Mike Turquette <mturquette@linaro.org> wrote:
> The global prepare_lock mutex prevents concurrent operations in the clk
> api.  This incurs a performance penalty when unrelated clock subtrees
> are contending for the lock.
>
> Additionally there are use cases which benefit from reentrancy into the
> clk api.  A simple example is reparenting a mux clock with a call to
> clk_set_rate.  Patch #4 in this series demonstrates this without the use
> of internal helper functions.
>
> A more complex example is performing dynamic frequency and voltage
> scaling from clk_set_rate.  Patches #2 and #3 in this series demonstrate
> this.
>
> This commit affects users of the global prepare_lock mutex, namely
> clk_prepare, clk_unprepare, clk_set_rate and clk_set_parent.
>
> This patch introduces an enum inside of struct clk which tracks whether
> the framework has LOCKED or UNLOCKED the clk.
>
> Access to clk->state must be protected by the global prepare_lock mutex.
> In the future maybe the global mutex can be dropped and all operations
> will only use a global spinlock to protect access to the per-clk enums.
> A general outline of the new locking scheme is as follows:
>
> 1) hold the global prepare_lock mutex
> 2) traverse the tree checking to make sure that any clk's needed are
> UNLOCKED and not LOCKED
>         a) if a clk in the subtree of affected clk's is LOCKED then
>            release the global lock, wait_for_completion and then try
>            again up to a maximum of WAIT_TRIES times
>         b) After WAIT_TRIES times return -EBUSY
> 3) if all clk's are UNLOCKED then mark them as LOCKED
> 4) release the global prepare_lock mutex
> 5) do the real work
> 6) hold the global prepare_lock mutex
> 7) set all of the clocks previously marked as LOCKED to UNLOCKED
> 8) release the global prepare_lock mutex and return
>
> The primary down-side to this approach is that the clk api's might
> return -EBUSY due to lock contention.  This is only after having tried
> several times.  Bailing out like this is necessary to prevent deadlocks.
>
> The enum approach in this version of the patchset does not benefit from
> lockdep checking the lock order (but neither did v1).  It is possible
> for circular dependencies to pop up for the careless developer and
> bailing out after a number of unsuccessful tries is the sanest strategy.
>
> Signed-off-by: Mike Turquette <mturquette@linaro.org>
> ---
>  drivers/clk/clk.c            |  354 +++++++++++++++++++++++++++++++++++++-----
>  include/linux/clk-private.h  |    1 +
>  include/linux/clk-provider.h |    4 +-
>  3 files changed, 318 insertions(+), 41 deletions(-)
>

> +}
> +
> +void __clk_unprepare(struct clk *clk, struct clk *top)

Why do you need to change the signature of __clk_prepare and
__clk_unprepare functions ?
I mean i did not understand the use of passing struct clk *top? As i
understand, it tells when you reach at the last
clk struct in the tree which needs to be prepared/unprepared. Do we
have extra benefit of this or if i am missing something?

> +{
>         if (clk->ops->unprepare)
>                 clk->ops->unprepare(clk->hw);
>
> -       __clk_unprepare(clk->parent);
> +       if (clk != top)
> +               __clk_unprepare(clk->parent, top);
> +}
> +
> +static void __clk_prepare_unlock(struct clk *clk, struct clk *top)
> +{
> +       clk->state = UNLOCKED;
> +
> +       if (clk != top)
> +               __clk_prepare_unlock(clk->parent, top);
>  }
>
>  /**
> @@ -404,35 +437,94 @@ void __clk_unprepare(struct clk *clk)
>   */
>  void clk_unprepare(struct clk *clk)
>  {
> +       struct clk *top = ERR_PTR(-EBUSY);
> +       int tries = 0;
> +
> +       /*
> +        * walk the list of parents checking clk->state along the way.  If all
> +        * clk->state is UNLOCKED then continue.  If a clk->state is LOCKED then
> +        * bail out with -EBUSY.
> +        */
> +       while (IS_ERR(top)) {
> +               mutex_lock(&prepare_lock);
> +               top = __clk_unprepare_lock(clk);
> +               mutex_unlock(&prepare_lock);
> +
> +               if (IS_ERR(top)) {
> +                       pr_debug("%s: %s failed with %ld on attempt %d\n",
> +                                       __func__, clk->name, PTR_ERR(top),
> +                                       tries);
> +                       wait_for_completion(&clk_completion);
> +                       if (WAIT_TRIES == ++tries)
> +                               break;
> +               } else
> +                       break;

Braces around else part please.

> +       }
> +
> +       if (WAIT_TRIES == tries) {
> +               pr_warning("%s: failed to lock clocks; cyclical dependency?\n",
> +                               __func__);
> +               return;
> +       }
> +
> +       /* unprepare the list of clocks from clk to top */
> +       __clk_unprepare(clk, top);
> +

> +       /* unprepare the list of clocks from clk to top */
> +       __clk_prepare(clk, top);

You mean prepare right ? :)



Regards,
Pankaj Kumar
