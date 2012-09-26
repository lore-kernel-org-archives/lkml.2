Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758216Ab2IZSuv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2012 14:50:51 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:2571 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756757Ab2IZSut (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2012 14:50:49 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6847"; a="241530819"
Message-ID: <50634E79.6060205@codeaurora.org>
Date: Wed, 26 Sep 2012 11:50:33 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:15.0) Gecko/20120907 Thunderbird/15.0.1
MIME-Version: 1.0
To: Pankaj Jangra <jangra.pankaj9@gmail.com>
CC: David Brown <davidb@codeaurora.org>, Daniel Walker <dwalker@fifo99.com>,
        Bryan Huntsman <bryanh@codeaurora.org>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Saravana Kannan <skannan@codeaurora.org>,
        Mike Turquette <mturquette@linaro.org>
Subject: Re: [PATCH 10/10] ARM: msm: Migrate to common clock framework
References: <1348194419-11486-1-git-send-email-sboyd@codeaurora.org> <1348194419-11486-11-git-send-email-sboyd@codeaurora.org> <CADTbHxpOJ+5xMQ8NkntQtFezwsryzvMDBx8eroNjzfp_5b0DfQ@mail.gmail.com>
In-Reply-To: <CADTbHxpOJ+5xMQ8NkntQtFezwsryzvMDBx8eroNjzfp_5b0DfQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/26/12 11:47, Pankaj Jangra wrote:
> Hi Stephen,
>
> On Fri, Sep 21, 2012 at 7:56 AM, Stephen Boyd <sboyd@codeaurora.org> wrote:
>
>> -static int pc_clk_set_rate(unsigned id, unsigned rate)
>> +static int pc_clk_set_rate(struct clk_hw *hw, unsigned long new_rate,
>> +                          unsigned long p_rate)
>>  {
>> -       /* The rate _might_ be rounded off to the nearest KHz value by the
>> +       struct clk_pcom *p = to_clk_pcom(hw);
>> +       unsigned id = p->id, rate = new_rate;
>> +       int rc;
>> +
>> +       /*
>> +        * The rate _might_ be rounded off to the nearest KHz value by the
>>          * remote function. So a return value of 0 doesn't necessarily mean
>>          * that the exact rate was set successfully.
>>          */
>> -       int rc = msm_proc_comm(PCOM_CLKCTL_RPC_SET_RATE, &id, &rate);
>> -       if (rc < 0)
>> -               return rc;
>> -       else
>> -               return (int)id < 0 ? -EINVAL : 0;
>> -}
>> -
>> -static int pc_clk_set_min_rate(unsigned id, unsigned rate)
>> -{
>> -       int rc = msm_proc_comm(PCOM_CLKCTL_RPC_MIN_RATE, &id, &rate);
>> -       if (rc < 0)
>> -               return rc;
>> +       if (p->flags & CLKFLAG_MIN)
>> +               rc = msm_proc_comm(PCOM_CLKCTL_RPC_MIN_RATE, &id, &rate);
> You are missing if condition here checking the rc ?
>
>>         else
>> -               return (int)id < 0 ? -EINVAL : 0;
>> -}
>> -
>> -static int pc_clk_set_max_rate(unsigned id, unsigned rate)
>> -{
>> -       int rc = msm_proc_comm(PCOM_CLKCTL_RPC_MAX_RATE, &id, &rate);
> and else here i think for the MIN_FLAG if check.
>
>> +               rc = msm_proc_comm(PCOM_CLKCTL_RPC_SET_RATE, &id, &rate);
>>         if (rc < 0)
>>                 return rc;
>>         else
>>                 return (int)id < 0 ? -EINVAL : 0;
>>  }

This is the resulting code:

        if (p->flags & CLKFLAG_MIN)
                rc = msm_proc_comm(PCOM_CLKCTL_RPC_MIN_RATE, &id, &rate);
        else
                rc = msm_proc_comm(PCOM_CLKCTL_RPC_SET_RATE, &id, &rate);
        if (rc < 0)
                return rc;
        else
                return (int)id < 0 ? -EINVAL : 0;

So we check the rc for both cases in the same if condition. Is there
anything wrong?

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation

