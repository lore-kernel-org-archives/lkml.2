Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753649Ab2IYH5A (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 03:57:00 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:48365 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753701Ab2IYH45 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 03:56:57 -0400
MIME-Version: 1.0
In-Reply-To: <20120924153514.12878.47739@nucleus>
References: <1348497799-32143-1-git-send-email-ulf.hansson@stericsson.com>
	<1348497799-32143-3-git-send-email-ulf.hansson@stericsson.com>
	<20120924153514.12878.47739@nucleus>
Date: Tue, 25 Sep 2012 09:56:56 +0200
Message-ID: <CAPDyKFqKUuqEj7yWGMPnFUvE2-kBExevweMdGAdD1EjhHSEwsQ@mail.gmail.com>
Subject: Re: [PATCH 2/3] clk: ux500: Support prcmu ape opp voltage clock
From: Ulf Hansson <ulf.hansson@linaro.org>
To: Mike Turquette <mturquette@ti.com>
Cc: Ulf Hansson <ulf.hansson@stericsson.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Linus Walleij <linus.walleij@linaro.org>,
        Lee Jones <lee.jones@linaro.org>,
        Philippe Begnic <philippe.begnic@st.com>,
        Srinidhi Kasagar <srinidhi.kasagar@stericsson.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mike,

Thanks for your input!

On 24 September 2012 17:35, Mike Turquette <mturquette@ti.com> wrote:
> Quoting Ulf Hansson (2012-09-24 07:43:18)
>> From: Ulf Hansson <ulf.hansson@linaro.org>
>>
>> Some scalable prcmu clocks needs to be handled in conjuction with the
>> ape opp 100 voltage. A new prcmu clock type clk_prcmu_opp_volt_scalable
>> is implemented to handle this.
>>
>> Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
>> ---
>>  drivers/clk/ux500/clk-prcmu.c |   55 +++++++++++++++++++++++++++++++++++++++++
>>  drivers/clk/ux500/clk.h       |    6 +++++
>>  2 files changed, 61 insertions(+)
>>
>> diff --git a/drivers/clk/ux500/clk-prcmu.c b/drivers/clk/ux500/clk-prcmu.c
>> index 930cdfe..04577ca 100644
>> --- a/drivers/clk/ux500/clk-prcmu.c
>> +++ b/drivers/clk/ux500/clk-prcmu.c
>> @@ -133,6 +133,40 @@ out_error:
>>                 hw->init->name);
>>  }
>>
>> +static int clk_prcmu_opp_volt_prepare(struct clk_hw *hw)
>> +{
>> +       int err;
>> +       struct clk_prcmu *clk = to_clk_prcmu(hw);
>> +
>> +       err = prcmu_request_ape_opp_100_voltage(true);
>> +       if (err) {
>> +               pr_err("clk_prcmu: %s failed to request APE OPP VOLT for %s.\n",
>> +                       __func__, hw->init->name);
>> +               return err;
>> +       }
>> +
>> +       err = prcmu_request_clock(clk->cg_sel, true);
>> +       if (err)
>> +               prcmu_request_ape_opp_100_voltage(false);
>> +
>> +       return err;
>> +}
>> +
>> +static void clk_prcmu_opp_volt_unprepare(struct clk_hw *hw)
>> +{
>> +       struct clk_prcmu *clk = to_clk_prcmu(hw);
>> +
>> +       if (prcmu_request_clock(clk->cg_sel, false))
>> +               goto out_error;
>> +       if (prcmu_request_ape_opp_100_voltage(false))
>> +               goto out_error;
>> +       return;
>> +
>> +out_error:
>> +       pr_err("clk_prcmu: %s failed to disable %s.\n", __func__,
>> +               hw->init->name);
>> +}
>
> Hello Ulf,
>
> I was hoping to use the rate-change notifiers for voltage scaling, as in
> my clk reentrancy/dvfs RFCs.  Using prepare/unprepare to set voltage for
> non-scalable clocks is probably OK; do you plan to scale voltage when
> your clocks change rate?  If so then you will need more than just
> prepare/unprepare.

I see, you have a good point here. Although right now this clock will
never change rate except during "init". Prepare/unprepare is thus
enough.

For the u8500 platform the sdmmc clock is the parent for all the
mmc/sd/sdio controllers. So, to no introduce a very complex
clockhandling mechanism (using rate-change notifiers would help a bit,
but is not enough), the clock is not supposed to be changed after
init. Proper dividing of the clock is handled internally by each
controller instead.


>
> Regards,
> Mike
>
>> +
>>  static struct clk_ops clk_prcmu_scalable_ops = {
>>         .prepare = clk_prcmu_prepare,
>>         .unprepare = clk_prcmu_unprepare,
>> @@ -167,6 +201,17 @@ static struct clk_ops clk_prcmu_opp_gate_ops = {
>>         .recalc_rate = clk_prcmu_recalc_rate,
>>  };
>>
>> +static struct clk_ops clk_prcmu_opp_volt_scalable_ops = {
>> +       .prepare = clk_prcmu_opp_volt_prepare,
>> +       .unprepare = clk_prcmu_opp_volt_unprepare,
>> +       .enable = clk_prcmu_enable,
>> +       .disable = clk_prcmu_disable,
>> +       .is_enabled = clk_prcmu_is_enabled,
>> +       .recalc_rate = clk_prcmu_recalc_rate,
>> +       .round_rate = clk_prcmu_round_rate,
>> +       .set_rate = clk_prcmu_set_rate,
>> +};
>> +
>>  static struct clk *clk_reg_prcmu(const char *name,
>>                                  const char *parent_name,
>>                                  u8 cg_sel,
>> @@ -250,3 +295,13 @@ struct clk *clk_reg_prcmu_opp_gate(const char *name,
>>         return clk_reg_prcmu(name, parent_name, cg_sel, 0, flags,
>>                         &clk_prcmu_opp_gate_ops);
>>  }
>> +
>> +struct clk *clk_reg_prcmu_opp_volt_scalable(const char *name,
>> +                                           const char *parent_name,
>> +                                           u8 cg_sel,
>> +                                           unsigned long rate,
>> +                                           unsigned long flags)
>> +{
>> +       return clk_reg_prcmu(name, parent_name, cg_sel, rate, flags,
>> +                       &clk_prcmu_opp_volt_scalable_ops);
>> +}
>> diff --git a/drivers/clk/ux500/clk.h b/drivers/clk/ux500/clk.h
>> index 836d7d1..f36eeed 100644
>> --- a/drivers/clk/ux500/clk.h
>> +++ b/drivers/clk/ux500/clk.h
>> @@ -45,4 +45,10 @@ struct clk *clk_reg_prcmu_opp_gate(const char *name,
>>                                    u8 cg_sel,
>>                                    unsigned long flags);
>>
>> +struct clk *clk_reg_prcmu_opp_volt_scalable(const char *name,
>> +                                           const char *parent_name,
>> +                                           u8 cg_sel,
>> +                                           unsigned long rate,
>> +                                           unsigned long flags);
>> +
>>  #endif /* __UX500_CLK_H */
>> --
>> 1.7.10

Kind regards
Ulf Hansson
