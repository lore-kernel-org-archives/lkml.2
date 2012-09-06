Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756814Ab2IFJJj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2012 05:09:39 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:33207 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756510Ab2IFJJf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2012 05:09:35 -0400
MIME-Version: 1.0
In-Reply-To: <20120831192906.31162.97714@nucleus>
References: <1346415691-13371-1-git-send-email-ulf.hansson@stericsson.com>
	<1346415691-13371-2-git-send-email-ulf.hansson@stericsson.com>
	<20120831192906.31162.97714@nucleus>
Date: Thu, 6 Sep 2012 11:09:33 +0200
Message-ID: <CAPDyKFrS7tKu5AcjL7+R8V5Nvo0O+BVwc8HtGFqQGSf12wMioQ@mail.gmail.com>
Subject: Re: [PATCH 1/4] clk: Provide option for clk_get_rate to issue hw for
 new rate
From: Ulf Hansson <ulf.hansson@linaro.org>
To: Mike Turquette <mturquette@ti.com>
Cc: Ulf Hansson <ulf.hansson@stericsson.com>,
        linux-arm-kernel@lists.infradead.org,
        Samuel Ortiz <sameo@linux.intel.com>, linux-kernel@vger.kernel.org,
        Linus Walleij <linus.walleij@linaro.org>,
        Lee Jones <lee.jones@linaro.org>,
        Philippe Begnic <philippe.begnic@st.com>,
        Srinidhi Kasagar <srinidhi.kasagar@stericsson.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mike,

Thanks for your input, and sorry for my late reply!

On 31 August 2012 21:29, Mike Turquette <mturquette@ti.com> wrote:
> Quoting Ulf Hansson (2012-08-31 05:21:28)
>> From: Ulf Hansson <ulf.hansson@linaro.org>
>>
>> By using CLK_GET_RATE_NOCACHE flag, we tell the clk_get_rate API to
>> issue the hw for an updated clock rate. This can be used for a clock
>> which rate may be updated without a client necessary modifying it.
>>
>
> I'm glad to see this.  We discussed whether the default behavior should
> be cached or from the hardware at length some time back, so having a
> flag to support the non-default is great.
>
>> Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
>> ---
>>  drivers/clk/clk.c            |   43 +++++++++++++++++++++++-------------------
>>  include/linux/clk-provider.h |    1 +
>>  2 files changed, 25 insertions(+), 19 deletions(-)
>>
>> diff --git a/drivers/clk/clk.c b/drivers/clk/clk.c
>> index efdfd00..d9cbae0 100644
>> --- a/drivers/clk/clk.c
>> +++ b/drivers/clk/clk.c
>> @@ -558,25 +558,6 @@ int clk_enable(struct clk *clk)
>>  EXPORT_SYMBOL_GPL(clk_enable);
>>
>>  /**
>> - * clk_get_rate - return the rate of clk
>> - * @clk: the clk whose rate is being returned
>> - *
>> - * Simply returns the cached rate of the clk.  Does not query the hardware.  If
>> - * clk is NULL then returns 0.
>> - */
>> -unsigned long clk_get_rate(struct clk *clk)
>> -{
>> -       unsigned long rate;
>> -
>> -       mutex_lock(&prepare_lock);
>> -       rate = __clk_get_rate(clk);
>> -       mutex_unlock(&prepare_lock);
>> -
>> -       return rate;
>> -}
>> -EXPORT_SYMBOL_GPL(clk_get_rate);
>> -
>> -/**
>>   * __clk_round_rate - round the given rate for a clk
>>   * @clk: round the rate of this clock
>>   *
>> @@ -702,6 +683,30 @@ static void __clk_recalc_rates(struct clk *clk, unsigned long msg)
>>  }
>>
>>  /**
>> + * clk_get_rate - return the rate of clk
>> + * @clk: the clk whose rate is being returned
>> + *
>> + * Simply returns the cached rate of the clk, unless CLK_GET_RATE_NOCACHE flag
>> + * is set, which means a recalc_rate will be issued.
>> + * If clk is NULL then returns 0.
>> + */
>> +unsigned long clk_get_rate(struct clk *clk)
>> +{
>> +       unsigned long rate;
>> +
>> +       mutex_lock(&prepare_lock);
>> +
>> +       if (clk && (clk->flags & CLK_GET_RATE_NOCACHE))
>> +               __clk_recalc_rates(clk, 0);
>
> This is a bit subtle.  Calling __clk_recalc_rates will walk the subtree
> of children recalculating rates as well as firing off notifiers.  Is
> this what you want?  If your clock changes rates behind your back AND
> has chilren then this is probably the right thing to do.  However you
> might be better off with:
>
>         if (clk && (clk->flags & CLK_GET_RATE_NOCACHE))
>                 rate = clk->ops->recalc_rate(clk->hw, clk->parent->rate);
>
> This doesn't update children or fire off notifiers.  What is best for
> your platform?

For my platform, ux500 and for the clock connected to this
patchseries, your suggesting above is enough. (Well some additional
error handling is needed in your code proposal though :-) )

The reason for why I used "__clk_recalc_rates" was because I think it
could make sense to have a more generic approach, not sure if it is
needed as you mention. Additionally, using  __clk_recalc_rates with
"0" as the notification argument, should prevent notifications from
happen, right?

So basically, I wanted the clock rates for the children to be updated
as well as the parent clock rate, but no notifications.

I can happily update the patch according to your proposal if you still
think it is the best way to do it, just tell me again then. :-)

Kind regards
Ulf Hansson
