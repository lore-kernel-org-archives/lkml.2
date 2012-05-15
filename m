Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966634Ab2EOTvL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 15:51:11 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:49078 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965947Ab2EOTvH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 15:51:07 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6712"; a="191223252"
Message-ID: <4FB2B3AA.3010903@codeaurora.org>
Date: Tue, 15 May 2012 12:51:06 -0700
From: Saravana Kannan <skannan@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Sascha Hauer <s.hauer@pengutronix.de>
CC: Mike Turquette <mturquette@linaro.org>,
        Arnd Bergman <arnd.bergmann@linaro.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Rob Herring <rob.herring@calxeda.com>,
        Russell King <linux@arm.linux.org.uk>,
        Jeremy Kerr <jeremy.kerr@canonical.com>,
        Thomas Gleixner <tglx@linutronix.de>, Paul Walmsley <paul@pwsan.com>,
        Shawn Guo <shawn.guo@freescale.com>, Jamie Iles <jamie@jamieiles.com>,
        Richard Zhao <richard.zhao@linaro.org>,
        Magnus Damm <magnus.damm@gmail.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Stephen Boyd <sboyd@codeaurora.org>,
        Amit Kucheria <amit.kucheria@linaro.org>,
        Deepak Saxena <dsaxena@linaro.org>,
        Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH] clk: Fix race conditions between clk_set_parent() and
 clk_enable()
References: <1336798797-8724-1-git-send-email-skannan@codeaurora.org> <20120515194245.GO30400@pengutronix.de>
In-Reply-To: <20120515194245.GO30400@pengutronix.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/15/2012 12:42 PM, Sascha Hauer wrote:
> Hi Saravana,
>
> On Fri, May 11, 2012 at 09:59:56PM -0700, Saravana Kannan wrote:
>> Without this patch, the following race conditions are possible.
>>
>> Race condition 1:
>> * clk-A has two parents - clk-X and clk-Y.
>> * All three are disabled and clk-X is current parent.
>> * Thread A: clk_set_parent(clk-A, clk-Y).
>> * Thread A:<snip execution flow>
>> * Thread A: Grabs enable lock.
>> * Thread A: Sees enable count of clk-A is 0, so doesn't enable clk-Y.
>> * Thread A: Releases enable lock.
>> * Thread B: Calls clk_enable(clk-A), which in turn enables clk-X.
>> * Thread A: Switches clk-A's parent to clk-Y in hardware.
>>
>> clk-A is now enabled in software, but not clocking in hardware.
>>
>> Race condition 2:
>> * clk-A has two parents - clk-X and clk-Y.
>> * All three are disabled and clk-X is current parent.
>> * Thread A: clk_set_parent(clk-A, clk-Y).
>> * Thread A:<snip execution flow>
>> * Thread A: Switches parent in hardware to clk-Y.
>> * Thread A: Grabs enable lock.
>> * Thread A: Sees enable count of clk-A is 0, so doesn't disable clk-X.
>> * Thread A: Releases enable lock.
>> * Thread B: Calls clk_enable(clk-A)
>> * Thread B: Software state still says parent is clk-X.
>> * Thread B: So, enables clk-X and then itself.
>> * Thread A: Updates parent in software state to clk-Y.
>
> Had a look at this and I can follow your reasoning and you patch seems
> to fix this. However, there is a problem,
>
>>
>>   	/* migrate prepare and enable */
>> @@ -1092,23 +1098,23 @@ static int __clk_set_parent(struct clk *clk, struct clk *parent)
>>
>>   	/* FIXME replace with clk_is_enabled(clk) someday */
>>   	spin_lock_irqsave(&enable_lock, flags);
>> +
>>   	if (clk->enable_count)
>>   		__clk_enable(parent);
>> -	spin_unlock_irqrestore(&enable_lock, flags);
>>
>>   	/* change clock input source */
>>   	ret = clk->ops->set_parent(clk->hw, i);
>
> You call ->set_parent while holding a spinlock. This won't work with i2c
> clocks.

I did account for that. I explained it in the commit text. Please let me 
know if any part of that is not clear or is not correct.

Thanks,
Saravana

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
